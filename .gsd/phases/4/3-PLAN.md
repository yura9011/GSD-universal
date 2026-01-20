---
phase: 4
plan: 3
wave: 3
milestone: v1.2
---

# Plan 4.3: Game Integration UI

## Objective
Add Game Integration section to configuration UI, allowing users to enable/disable auto-PTT, configure per-game settings, and test PTT keys.

## Context
- src/config_ui.py - Configuration UI
- src/game_detector.py - Game detection (from Plan 4.1)
- .gsd/phases/4/RESEARCH.md - UI design

## Tasks

<task type="auto">
  <name>Add Game Integration tab to config UI</name>
  <files>src/config_ui.py</files>
  <action>
Update ConfigUI to add Game Integration tab:

1. **In _create_widgets(), add new tab after Advanced:**
```python
        # Advanced tab
        advanced_frame = ttk.Frame(notebook, padding=10)
        notebook.add(advanced_frame, text='Advanced')
        self._create_advanced_tab(advanced_frame)
        
        # Game Integration tab
        games_frame = ttk.Frame(notebook, padding=10)
        notebook.add(games_frame, text='Game Integration')
        self._create_games_tab(games_frame)
        
        # Buttons at bottom
        button_frame = ttk.Frame(self.root, padding=10)
```

2. **Create _create_games_tab method:**
```python
    def _create_games_tab(self, parent):
        """Create Game Integration settings tab."""
        # Auto-PTT enabled
        ttk.Label(parent, text="Enable Auto-PTT:").grid(row=0, column=0, sticky='w', pady=5)
        self.auto_ptt_enabled_var = tk.BooleanVar()
        ttk.Checkbutton(parent, variable=self.auto_ptt_enabled_var).grid(row=0, column=1, sticky='w')
        
        ttk.Label(parent, text="(Automatically press game's PTT key when sending audio)", 
                 font=('Arial', 8)).grid(row=0, column=2, sticky='w', padx=10)
        
        # Hold duration
        ttk.Label(parent, text="Hold Duration (s):").grid(row=1, column=0, sticky='w', pady=5)
        self.auto_ptt_hold_var = tk.DoubleVar()
        ttk.Entry(parent, textvariable=self.auto_ptt_hold_var, width=10).grid(row=1, column=1, sticky='w')
        
        # Separator
        ttk.Separator(parent, orient='horizontal').grid(row=2, column=0, columnspan=3, sticky='ew', pady=10)
        
        # Game profiles header
        ttk.Label(parent, text="Game Profiles:", font=('Arial', 10, 'bold')).grid(row=3, column=0, sticky='w', pady=5)
        
        # Load game profiles
        from game_detector import DEFAULT_GAME_PROFILES
        
        # Create variables for each game
        self.game_enabled_vars = {}
        self.game_ptt_vars = {}
        
        row = 4
        for game_id, profile in DEFAULT_GAME_PROFILES.items():
            # Game name
            ttk.Label(parent, text=profile['name']).grid(row=row, column=0, sticky='w', pady=2)
            
            # Enabled checkbox
            enabled_var = tk.BooleanVar()
            self.game_enabled_vars[game_id] = enabled_var
            ttk.Checkbutton(parent, text="Enabled", variable=enabled_var).grid(row=row, column=1, sticky='w')
            
            # PTT key entry
            ttk.Label(parent, text="PTT Key:").grid(row=row+1, column=0, sticky='w', padx=20)
            ptt_var = tk.StringVar()
            self.game_ptt_vars[game_id] = ptt_var
            ttk.Entry(parent, textvariable=ptt_var, width=15).grid(row=row+1, column=1, sticky='w')
            
            # Test button
            ttk.Button(parent, text="Test Key", 
                      command=lambda gid=game_id: self._test_game_ptt(gid)).grid(row=row+1, column=2, padx=5)
            
            row += 2
    
    def _test_game_ptt(self, game_id):
        """Test PTT key for specific game."""
        ptt_key = self.game_ptt_vars[game_id].get()
        
        if not ptt_key:
            messagebox.showwarning("No Key", "Please enter a PTT key first")
            return
        
        try:
            import keyboard
            import time
            
            messagebox.showinfo("Testing", 
                               f"Will press and release '{ptt_key}' key.\nMake sure the game is focused!")
            
            # Press and release
            keyboard.press(ptt_key)
            time.sleep(0.5)
            keyboard.release(ptt_key)
            
            messagebox.showinfo("Test Complete", 
                               f"[OK] Pressed and released '{ptt_key}'\nCheck if the game registered it.")
        
        except Exception as e:
            messagebox.showerror("Test Failed", f"[ERROR] {str(e)}")
```

3. **Update _load_values() to load auto-PTT settings:**
```python
        # Auto-PTT settings
        auto_ptt_cfg = self.config.get('auto_ptt', {})
        self.auto_ptt_enabled_var.set(auto_ptt_cfg.get('enabled', True))
        self.auto_ptt_hold_var.set(auto_ptt_cfg.get('hold_duration', 0.1))
        
        # Game profiles
        games_cfg = auto_ptt_cfg.get('games', {})
        for game_id in self.game_enabled_vars.keys():
            game_cfg = games_cfg.get(game_id, {})
            self.game_enabled_vars[game_id].set(game_cfg.get('enabled', True))
            
            # Get default PTT key from DEFAULT_GAME_PROFILES
            from game_detector import DEFAULT_GAME_PROFILES
            default_ptt = DEFAULT_GAME_PROFILES.get(game_id, {}).get('ptt_key', '')
            self.game_ptt_vars[game_id].set(game_cfg.get('ptt_key', default_ptt))
```

4. **Update _save_config() to save auto-PTT settings:**
```python
        # Auto-PTT settings
        if 'auto_ptt' not in self.config:
            self.config['auto_ptt'] = {'games': {}}
        
        self.config['auto_ptt']['enabled'] = self.auto_ptt_enabled_var.get()
        self.config['auto_ptt']['hold_duration'] = self.auto_ptt_hold_var.get()
        
        # Game profiles
        if 'games' not in self.config['auto_ptt']:
            self.config['auto_ptt']['games'] = {}
        
        for game_id in self.game_enabled_vars.keys():
            self.config['auto_ptt']['games'][game_id] = {
                'enabled': self.game_enabled_vars[game_id].get(),
                'ptt_key': self.game_ptt_vars[game_id].get()
            }
        
        # Save to file
        if save_config(self.config):
```

IMPORTANT:
- Create new tab for game integration
- List all default game profiles
- Enable/disable per game
- Edit PTT key per game
- Test button to verify key works
- Load/save all settings
  </action>
  <verify>python -m py_compile src/config_ui.py</verify>
  <done>Game Integration tab added to configuration UI</done>
</task>

## Success Criteria
- [ ] Config UI has Game Integration tab
- [ ] Can enable/disable auto-PTT globally
- [ ] Can enable/disable per game
- [ ] Can edit PTT key per game
- [ ] Test button verifies key press works
- [ ] Settings persist across restarts
