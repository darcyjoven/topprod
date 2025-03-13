# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name...: s_chk_process_no.4gl
# Descriptions...: 检查对应的 process 在对应的AP主机上是否仍在正常运行 
# Date & Author..: FUN-CA0119 11/10/23 By wangxy  
# Usage..........: CALL s_chk_process_no(p_apname,p_prog,p_dist)
# Input PARAMETER: p_apname    AP主机名称 
#                  p_dist      (distribution)apcp200是否为分布上传 LIKE ryz10
#                  p_prog      说明是apcp100/apcp101作业的判断还是apcp200作业的判断 
# RETURN Code....: TRUE / FALSE
# Modify.........: FUN-CA0119

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_pid         LIKE gbq_file.gbq01

#FUNCTION s_chk_process_pos(p_pid,p_apname,p_prog,p_dist)
#FUN-CA0119
FUNCTION s_chk_process_pos(p_apname,p_prog,p_dist)
  #DEFINE p_pid        LIKE gbq_file.gbq01
   DEFINE p_apname     LIKE gbq_file.gbq11
   DEFINE p_prog       LIKE gbq_file.gbq04
   DEFINE p_dist       LIKE ryz_file.ryz10
   DEFINE l_sql        STRING
   DEFINE l_sql2       STRING
   DEFINE l_cnt        LIKE type_file.num5
   DEFINE l_cnt2       LIKE type_file.num5
   DEFINE l_n_ps       LIKE type_file.num5
   DEFINE l_n_gbq      LIKE type_file.num5
   DEFINE lch_cmd      base.Channel
   DEFINE l_n          LIKE type_file.num5
   DEFINE l_n2         LIKE type_file.num5
   DEFINE ls_cmd       STRING,
          ls_result    STRING,
          ls_token     STRING
   DEFINE lst_token    base.StringTokenizer
   DEFINE li_i         LIKE type_file.num5
   DEFINE li_j         LIKE type_file.num5
   DEFINE ga_process   DYNAMIC ARRAY OF RECORD
             p01          LIKE type_file.chr10,   #Login User
             p02          LIKE type_file.chr10,   #PID
             p09          LIKE type_file.chr10    #hostname
                       END RECORD
   DEFINE lr_gbq       DYNAMIC ARRAY OF RECORD LIKE gbq_file.*
   DEFINE gi_count     LIKE type_file.num5
   DEFINE l_diff_no    LIKE type_file.num5

   LET g_pid = FGL_GETPID()

   IF cl_null(p_apname) THEN
      RETURN FALSE
   END IF

   CALL cl_process_check()  #先將gbq_file內的資料refresh

   #apcp100,apcp101,apcp200不勾选分布式上传,当有一个在运行不能再运行另一支
   #apcp200选择分布式上传时，ryg03对应的的营运中心只能运行一支
   CASE 
      WHEN (p_prog = "apcp100" OR p_prog = "apcp101")
         LET l_sql = " SELECT COUNT(*) FROM gbq_file",
                     " WHERE (gbq04 = 'apcp100' OR gbq04 = 'apcp101') ",
                     "   AND gbq11 = '",p_apname,"'",
                     "   AND gbq01 <> ",g_pid
         LET ls_cmd = "ps -ef | grep -E 'apcp100|apcp101'| grep fglrun-bin | grep -v ",g_pid,"| grep -v p_cron | grep -v r.d2+ | grep 42r | grep -v fgldeb | wc -l"
      WHEN "apcp200"
         IF(p_dist = "Y") THEN
            LET l_sql = " SELECT * FROM gbq_file",
                        " WHERE gbq04 = '",p_prog,"' AND gbq11 = '",p_apname,
                        "' AND gbq01 <> ",g_pid
            LET ls_cmd = "ps -ef | grep '",p_prog,"'| grep fglrun-bin | grep -v ",g_pid," |grep -v p_cron | grep -v r.d2+ | grep 42r | grep -v fgldeb"
            ##############################################################   
               LET l_sql2 = " SELECT COUNT(*) FROM gbq_file",
                            " WHERE gbq04 = 'apcp200' AND gbq11 = '",p_apname CLIPPED,"' AND gbq10 = '",g_plant CLIPPED,"/",g_plant CLIPPED,
                            "' AND gbq01 <> ",g_pid
            ##############################################################   
         ELSE
            LET l_sql = " SELECT COUNT(*) FROM gbq_file",
                        " WHERE gbq04 = '",p_prog,"' AND gbq11 = '",p_apname,
                        "' AND gbq01 <> ",g_pid
            LET ls_cmd = "ps -ef | grep '",p_prog,"'| grep fglrun-bin | grep -v ",g_pid,"| grep -v p_cron | grep -v r.d2+ | grep 42r | grep -v fgldeb | wc -l"
         END IF
      OTHERWISE
         RETURN FALSE
   END CASE

   PREPARE gbq_pre1 FROM l_sql
   DECLARE gbq_curs CURSOR FOR gbq_pre1
   LET lch_cmd = base.Channel.create()

   IF p_prog = "apcp200" AND p_dist = "Y" THEN
      ########################################
      #若gbq_file中有当前营运中心当前AP开启的apcp200,不能再运行，若无与ps -ef结果比较，查看ps -ef 中是否有比gbq_file多出来的apcp200
         PREPARE gbq_pre2 FROM l_sql2
         DECLARE gbq_curs2 CURSOR FOR gbq_pre2
         EXECUTE gbq_curs2 INTO l_cnt2
            #IF SQLCA.sqlcode THEN
            #   EXIT 
            #END IF
      ########################################

      IF l_cnt2 > 0 THEN 
         RETURN FALSE
      ELSE 
         #抓取gbq_file中apcp200的数据放入数组lr_gbq[li_j].*
         LET gi_count = 1
         FOREACH gbq_curs INTO lr_gbq[gi_count].*
            IF SQLCA.sqlcode THEN
               EXIT FOREACH
            END IF
            LET gi_count = gi_count + 1
         END FOREACH
         CALL lr_gbq.deleteElement(gi_count)
         LET l_n_gbq = lr_gbq.getLength()
   
         #将ps -ef | grep 得到的数据放入数组ga_process[gi_count].*
         CALL ga_process.clear()
         LET gi_count = 1
   
         CALL lch_cmd.openPipe(ls_cmd, "r")
         WHILE lch_cmd.read(ls_result)
            LET lst_token = base.StringTokenizer.create(ls_result, ' ')
   
            #若ps -ef | grep的数据为空，RETURN TRUE。不为空时，存入数组
            IF lst_token IS NULL THEN
               RETURN TRUE
            ELSE
               LET li_i = 1
               WHILE lst_token.hasMoreTokens()
                  LET ls_token = lst_token.nextToken()
                  CASE
                     WHEN li_i = 1   #Login User
                        LET ga_process[gi_count].p01 = ls_token
                     WHEN li_i = 2   #PID
                        LET ga_process[gi_count].p02 = ls_token
                  END CASE
                  LET li_i = li_i + 1
               END WHILE
               LET ga_process[gi_count].p09 = cl_used_ap_hostname()   #本機查出的PID均應填入本機AP名稱
            END IF
            LET gi_count = gi_count + 1
         END WHILE

        #DISPLAY "David:", ga_process.getLength()
        #DISPLAY "David:",gi_count
         CALL ga_process.deleteElement(gi_count)
        #DISPLAY "David:",ga_process.getLength()
        #LET l_n_ps = ga_process.getLength()
         LET l_n_ps = gi_count - 1
   
         #比较ps -ef与gbq_file中得到的结果。若存在于ps -ef中但不在gbq_file中返回FALSE，都存在返回TRUE.
         FOR li_i = 1 TO l_n_ps
            LET l_diff_no = 0
            FOR li_j = 1 TO l_n_gbq
               IF ga_process[li_i].p02 = lr_gbq[li_j].gbq01 AND
                  ga_process[li_i].p09 = lr_gbq[li_j].gbq11 THEN
               ELSE
                  LET l_diff_no = l_diff_no + 1 
               END IF
            END FOR
            IF l_diff_no = l_n_gbq THEN
               RETURN FALSE
            END IF
         END FOR
         RETURN TRUE
      END IF
   
   ELSE
      EXECUTE gbq_pre1 INTO l_cnt
      IF SQLCA.sqlcode AND SQLCA.sqlcode <> 100 THEN
         CALL cl_err('',SQLCA.sqlcode,0)
      END IF
      IF l_cnt > 0 THEN
         RETURN FALSE
      END IF
      
      CALL lch_cmd.openPipe(ls_cmd, "r")
      WHILE lch_cmd.read(l_n)
      END WHILE
      CALL lch_cmd.close()
      
      IF l_n = 0 THEN
         RETURN TRUE
      ELSE
         RETURN FALSE
      END IF
   END IF
   END FUNCTION
