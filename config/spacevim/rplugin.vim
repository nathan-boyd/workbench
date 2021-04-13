" perl plugins


" node plugins
call remote#host#RegisterPlugin('node', '/home/nboyd/.cache/vimfiles/repos/github.com/mhartington/nvim-typescript/rplugin/node/nvim_typescript', [
      \ {'sync': v:false, 'name': 'TSRename', 'type': 'command', 'opts': {'nargs': '*'}},
      \ {'sync': v:false, 'name': 'TSGetWorkspaceSymbols', 'type': 'command', 'opts': {'nargs': '*'}},
      \ {'sync': v:null, 'name': 'TSSig', 'type': 'command', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSDefPreview', 'type': 'command', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSDoc', 'type': 'command', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSDef', 'type': 'command', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSImport', 'type': 'command', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSRefs', 'type': 'command', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSEditConfig', 'type': 'command', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSStart', 'type': 'command', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSStop', 'type': 'command', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSReloadProject', 'type': 'command', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSBuild', 'type': 'command', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSTypeDef', 'type': 'command', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSType', 'type': 'command', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSGetDocSymbols', 'type': 'command', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSOrganizeImports', 'type': 'command', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSGetDiagnostics', 'type': 'command', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSGetErrorFull', 'type': 'command', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSGetCodeFix', 'type': 'command', 'opts': {}},
      \ {'sync': v:true, 'name': 'TSGetProjectInfoFunc', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'TSGetWorkspaceSymbolsFunc', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'TSGetDocSymbolsFunc', 'type': 'function', 'opts': {}},
      \ {'sync': v:false, 'name': 'TSDeoplete', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'TSOmniFunc', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'TSGetServerPath', 'type': 'function', 'opts': {}},
      \ {'sync': v:true, 'name': 'TSGetVersion', 'type': 'function', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSNcm2OnComplete', 'type': 'function', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSCmRefresh', 'type': 'function', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSCloseWindow', 'type': 'function', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSEchoMessage', 'type': 'function', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSOnBufEnter', 'type': 'function', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSOnBufLeave', 'type': 'function', 'opts': {}},
      \ {'sync': v:null, 'name': 'TSOnBufSave', 'type': 'function', 'opts': {}},
     \ ])


" python3 plugins
call remote#host#RegisterPlugin('python3', '/home/nboyd/.SpaceVim/bundle/deoplete.nvim/rplugin/python3/deoplete', [
      \ {'sync': v:false, 'name': '_deoplete_init', 'type': 'function', 'opts': {}},
     \ ])


" ruby plugins


" python plugins


