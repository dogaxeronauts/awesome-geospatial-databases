select t.*
, 'Top 20 Waits investigated by user last 15 minutes' as comment
from
(

  select session.inst_id,
         session.sid,
         session.username,
         sum(active_session_history.wait_time +
             active_session_history.time_waited) total_WaitTime
    from gv$active_session_history active_session_history,
         gv$session session
   where active_session_history.sample_time> (sysdate-1/(24 * 4))
     and active_session_history.session_id = session.sid
     and active_session_history.inst_id = session.inst_id
     and session.username is not null
     and rownum < 20
 group by session.inst_id, session.sid, session.username
 order by 4 desc
) t
