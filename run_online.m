function [fig,outputArg2] = run_online(block, params)
%RUN_ONLINE Online demo 

    params = struct('Baseline', [0 1], 'fps', 15, 'Stimulus', [1 1.2]);

    wmap = glance_std(block);
    [wmap,stats] = glance_filter(wmap, []);
    mask = glance_merge_convex(wmap, stats);
    
    [roitrace, stats] = trace_extract_trial(block, mask, params);
    summaryimage = mean(block,3);
    
    fig = uionline_show_trial(summaryimage, params, mask, roitrace, stats);
end

