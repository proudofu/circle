function print(obj,varargin)
%PRINT function prints current picture.
    printFig = figure('name','Print Figure',...
                      'numbertitle','off',...
                      'units','pixels',...
                      'pos',get(get(obj.hMainFig,'currentaxes'),'pos'),...
                      'resize','off',...
                      'CreateFcn','movegui(''center'')');
    copyobj(get(obj.hMainFig,'currentaxes'),printFig);
end