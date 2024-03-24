function root = stk_init()
    app = actxserver('STK12.application');
    root = app.Personality2;

end