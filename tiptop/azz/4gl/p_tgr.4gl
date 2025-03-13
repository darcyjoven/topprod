# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_tgr.4gl                                                                                                        
# Descriptions...: 觸發器維護作業                                                                                             
# Date & Author..: 07/12/23 shine    #FUN-690054
# Modify.........: No.TQC-860017 08/06/09 By Jerry 修改程式控制區間內,缺乏ON IDLE的部份
# Modify.........: No.TQC-880048 08/09/25 By jerry 將原本變數"宣告成固定長度"的部份修正為"參照至type_file內的欄位"
# Modify.........: No.MOD-8C0198 08/12/22 By Sarah 新增一進入單身程式就當掉
 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds    #FUN-690054
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_gcp01         LIKE gcp_file.gcp01,   
    g_gcp01_t       LIKE gcp_file.gcp01,   
    g_gcp           DYNAMIC ARRAY OF RECORD
        gcp02       LIKE gcp_file.gcp02,   
        gcp03       LIKE gcp_file.gcp03,   
        gcp04       LIKE gcp_file.gcp04,  
        gcp05       LIKE gcp_file.gcp05,
        gcp07       LIKE gcp_file.gcp07  
                    END RECORD,
    g_gcq01         LIKE gcq_file.gcq01,
    g_gcq03         LIKE gcq_file.gcq03,
    g_gcp_t         RECORD                 
        gcp02       LIKE gcp_file.gcp02,  
        gcp03       LIKE gcp_file.gcp03,  
        gcp04       LIKE gcp_file.gcp04,   
        gcp05       LIKE gcp_file.gcp05,
        gcp07       LIKE gcp_file.gcp07  
                    END RECORD,
    g_gco           DYNAMIC ARRAY OF RECORD
        gco01       LIKE gco_file.gco01,
        gco02       LIKE gco_file.gco02,
        gco03       LIKE gco_file.gco03,
        gco04       LIKE gco_file.gco04,
        gco05       LIKE gco_file.gco05,
        gco06       LIKE gco_file.gco06,
        gco07       LIKE gco_file.gco07
                    END RECORD,
    g_gco_t         RECORD
        gco01       LIKE gco_file.gco01,
        gco02       LIKE gco_file.gco02,
        gco03       LIKE gco_file.gco03,
        gco04       LIKE gco_file.gco04,
        gco05       LIKE gco_file.gco05,
        gco06       LIKE gco_file.gco06,
        gco07       LIKE gco_file.gco07
                    END RECORD,
    g_gcq           RECORD LIKE gcq_file.*,
    g_gcq_t         RECORD LIKE gcq_file.*,      
    g_gcq03_t       LIKE gcq_file.gcq03,      
    g_gcq02_t       LIKE gcq_file.gcq02,
    g_gcq01_t       LIKE gcq_file.gcq01,
    g_gcq04_t       LIKE gcq_file.gcq04,
    g_gcq05_t       LIKE gcq_file.gcq05,   
     g_trigger_name LIKE type_file.chr37, #TQC-880048
   # g_trigger_name  VARCHAR(30),
    g_gcq02         LIKE gcq_file.gcq02,
    g_gcq04         LIKE gcq_file.gcq04,
 
  g_wc,g_sql,g_wc2 STRING,#TQC-880048
  g_wc1           STRING,#TQC-880048
  g_sql1          STRING,#TQC-880048
  g_show         LIKE type_file.chr1,#TQC-880048
 
   # g_wc,g_sql,g_wc2    VARCHAR(1300),
   # g_wc1           VARCHAR(1300),  
   # g_sql1          VARCHAR(1300),
   # g_show          VARCHAR(1),
   
    g_rec_b         LIKE type_file.num5,  
    g_rec_b1        LIKE type_file.num5,            
    
    g_flag          LIKE type_file.chr1,#TQC-880048
    g_ver           LIKE type_file.chr1,#TQC-880048
    g_db_type       LIKE type_file.chr3,#TQC-880048
 
   #  g_flag          VARCHAR(1),
   #  g_ver           VARCHAR(1),               
   #  g_db_type       VARCHAR(3),
    g_test          LIKE type_file.num5,
    g_cmd           STRING
                   
DEFINE p_row,p_col       LIKE type_file.num5
DEFINE   g_forupd_sql    STRING   
DEFINE   g_cnt           LIKE type_file.num10
DEFINE   g_cnt1          LIKE type_file.num10
DEFINE   g_i             LIKE type_file.num5  
DEFINE   g_msg           LIKE type_file.chr100 #TQC-880048
 
# DEFINE   g_msg           VARCHAR(72)
DEFINE   g_before_input_done LIKE type_file.num5
DEFINE   g_row_count    LIKE type_file.num10
DEFINE   g_row_count1   LIKE type_file.num10
DEFINE   g_curs_index   LIKE type_file.num10
DEFINE   g_curs_index1  LIKE type_file.num10
DEFINE   g_jump         LIKE type_file.num10
DEFINE   g_jump1        LIKE type_file.num10
DEFINE   g_no_ask       LIKE type_file.num5
DEFINE   g_argv1        LIKE gcp_file.gcp01
DEFINE   g_argv2        LIKE gcp_file.gcp02
DEFINE   g_b_flag       LIKE type_file.num5
DEFINE   mi_no_ask      LIKE type_file.num5
 
MAIN
DEFINE
     l_time           LIKE type_file.chr8 #TQC-880048
 
   # l_time        VARCHAR(8)               
 
    OPTIONS                               
        INPUT NO WRAP
    DEFER INTERRUPT      
 
    LET g_argv1 = ARG_VAL(1)
    WHENEVER ERROR CALL cl_err_msg_log              
 
    LET g_db_type=cl_db_get_database_type()
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AZZ")) THEN
       EXIT PROGRAM
    END IF
      CALL cl_used(g_prog,l_time,1)       
      RETURNING l_time
    LET g_gcp01 = NULL
    LET p_row = 5 LET p_col = 26
 
    LET g_forupd_sql = "SELECT * FROM gcq_file WHERE ROWID = ? FOR UPDATE  "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_gcp_cl1 CURSOR FROM g_forupd_sql
    
 
    OPEN WINDOW p_gcp_w AT p_row,p_col
        WITH FORM "azz/42f/p_tgr" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN
       CALL p_tgr_q()
    END IF 
 
    CALL p_tgr_menu()  
 
    CLOSE WINDOW p_gcp_w             
      CALL cl_used(g_prog,l_time,2)  
        RETURNING l_time
END MAIN
 
FUNCTION p_tgr_cs()
    CLEAR FORM                    
#    LET g_gcp.clear()
   
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = "gcp01 like '",g_argv1 CLIPPED,"'"
    ELSE   
       CONSTRUCT g_wc ON gcp01,gcp02,gcp03,gcp04,gcp05
       FROM gcp01,s_gcp[1].gcp02,s_gcp[1].gcp03,s_gcp[1].gcp04,
            s_gcp[1].gcp05
    
       ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
       ON ACTION about         
         CALL cl_about()      
 
       ON ACTION help        
         CALL cl_show_help()  
 
       ON ACTION controlg      
         CALL cl_cmdask()     
  
      
       ON ACTION controlp
         CASE
            WHEN INFIELD(gcp01)   
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = 'c'
                 LET g_qryparam.form ="q_zta1"
                 LET g_qryparam.arg1 = g_lang CLIPPED
                 CALL cl_create_qry()RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO gcp01
                 NEXT FIELD gcp01
 
           OTHERWISE EXIT CASE
          END CASE
 
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    END IF  
   
    IF INT_FLAG THEN RETURN END IF
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN 
    #        LET g_wc = g_wc clipped," AND gcpuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN 
    #        LET g_wc = g_wc clipped," AND gcpgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
    
    LET g_sql= "SELECT UNIQUE gcp01  FROM gcp_file ",  
               " WHERE ", g_wc CLIPPED,
               " AND gcp01 IS NOT NULL",
               " ORDER BY gcp01"
    PREPARE p_gcp_prepaap FROM g_sql   
    DECLARE p_gcp_bcs                     
        SCROLL CURSOR WITH HOLD FOR p_gcp_prepaap
 
    LET g_sql = " SELECT UNIQUE gcp01",
                " FROM gcp_file ",
                " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
    DROP TABLE x
 
    PREPARE p_gcp_pre_x FROM g_sql
    EXECUTE p_gcp_pre_x
 
    LET g_sql = "SELECT COUNT(*) FROM x WHERE gcp01 IS NOT NULL"
    PREPARE p_gcp_precnt FROM g_sql
    DECLARE p_gcp_count CURSOR FOR p_gcp_precnt 
END FUNCTION
 
FUNCTION p_tgr_menu()
   WHILE TRUE
      LET g_b_flag = 1
      CALL p_tgr_bp("G")
 
      CASE g_b_flag
#         WHEN 1
#            CALL p_tgr_bp("G") 
         WHEN 2 
            CALL p_tgr_bp1()
#         WHEN 3
#             CALL p_tgr_menu1()
      END CASE 
 
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               LET g_gcp01 = NULL
               
#               IF g_b_flag = 3 THEN
#                  CALL p_tgr_a1()
#               ELSE
                  CALL p_tgr_a()
#               END IF
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               LET g_gcp01 = NULL
               CALL p_tgr_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL p_tgr_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CASE g_b_flag
                  wHEN 1
                    CALL p_tgr_b()
                  WHEN 2
                    CALL p_tgr_b1()
               END CASE
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL p_tgr_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "create trigger"
            CALL p_tgr_create_trigger()
         WHEN "drop trigger"
            CALL p_tgr_drop_trigger()
      END CASE
   END WHILE
 
END FUNCTION 
 
FUNCTION p_tgr_create_trigger()
   
   DEFINE 
       l_sql             STRING,
       l_ac              LIKE type_file.num5,
       l_str             STRING,
       l_trigger_name    STRING,
       table_name        STRING,  
       l_sql1,l_sql2     STRING, 
      l_table_name      LIKE type_file.chr10,#TQC-880048 
     #  l_table_name      VARCHAR(10),
      #l_tmp             VARCHAR(3000),            #MOD-8C0198 mark
       l_tmp             LIKE type_file.chr1000,   #MOD-8C0198
       l_start,l_end     LIKE type_file.num5,
       l_start1,l_end1   LIKE type_file.num5,
       l_str_buf         base.StringBuffer,
      
      lc_desc       LIKE type_file.chr200,#TQC-880048
      lc_sub,lc_sub1    LIKE type_file.chr200,#TQC-880048
      l_str1,l_str2     LIKE type_file.chr200, #TQC-880048
 
 
 
 
     #  lc_desc           VARCHAR(200),
     #  lc_sub,lc_sub1    VARCHAR(200),
     #  l_str1,l_str2     VARCHAR(200),
       l_str3            STRING, 
       l_sql3,l_sql4     STRING,
       l_sql5,l_sql6     STRING,
       l_str_buf1        base.StringBuffer,
       l_tmp1            STRING,
      
 
       l_trigid1,l_trigid2,l_trigid3        LIKE type_file.chr100, #TQC-880048
     # l_trigid1,l_trigid2,l_trigid3        VARCHAR(100),
       l_sql7,l_sql8     STRING,
       l_old,l_new       STRING
 
  DEFINE l_char            LIKE type_file.chr500 #TQC-880048
 
# DEFINE l_char            VARCHAR(500)
DEFINE l_char1           STRING
DEFINE l_sql10           STRING
DEFINE l_char2           STRING
DEFINE l_char3           STRING
DEFINE l_num             LIKE type_file.num5
 
  DEFINE l_word,l_word1,l_word2,l_word3,l_word4,l_word5  LIKE type_file.chr1 #TQC-880048
# DEFINE l_word,l_word1,l_word2,l_word3,l_word4,l_word5  VARCHAR(1) 
DEFINE l_gcq13           STRING
 
  DEFINE l_begin,l_begin1,l_begin2           LIKE type_file.chr100 #TQC-880048
 
# DEFINE l_begin,l_begin1,l_begin2           VARCHAR(40)
DEFINE l_type            LIKE type_file.num5
     
    LET l_ac = ARR_CURR()
    IF cl_null(g_gcp01) THEN
       CALL cl_err("",-400,0)
       RETURN
    END IF        
 
     LET l_ac = ARR_CURR()
     SELECT gcq07,gcq08,gcq09,gcq10,gcq11,gcq12,gcq13
         INTO l_tmp,l_word,l_word1,l_word2,l_word3,l_word4,l_word5 
            FROM gcq_file WHERE gcq01=g_gcp[l_ac].gcp02   
#     SELECT gcq08 INTO l_word FROM gcq_file WHERE gcq01=g_gcp[l_ac].gcp02            
#     SELECT gcq09 INTO l_word1 FROM gcq_file WHERE gcq01=g_gcp[l_ac].gcp02            
#     SELECT gcq10 INTO l_word2 FROM gcq_file WHERE gcq01=g_gcp[l_ac].gcp02            
#     SELECT gcq11 INTO l_word3 FROM gcq_file WHERE gcq01=g_gcp[l_ac].gcp02            
#     SELECT gcq12 INTO l_word4 FROM gcq_file WHERE gcq01=g_gcp[l_ac].gcp02 
     
     
     IF l_word1="Y" THEN 
        LET l_begin ="insert"
     END IF
     IF l_word2="Y" THEN 
        LET l_begin ="delete"
     END IF
     IF l_word3="Y" THEN 
        LET l_begin ="update"
     END IF
     IF l_word1="Y" AND l_word2="Y" THEN
        LET l_begin ="insert or delete" 
     END IF 
     IF l_word1="Y" AND l_word3="Y" THEN
        LET l_begin = "insert or update" 
     END IF
     IF l_word2="Y" AND l_word3="Y" THEN
        LET l_begin ="delete or update"
     END IF 
     IF l_word1="Y" AND l_word2="Y" AND l_word3="Y" THEN
        LET l_begin = "insert or delete or update"
     END IF 
     IF l_word ="1" THEN
        LET l_begin1="before"
     END IF 
     IF l_word ="2" THEN 
        LET l_begin1="after"
     END IF    
     IF l_word4 = "Y" THEN
        LET l_begin2 ="for each row"
     ELSE 
        LET l_begin2 = ""
     END IF 
     IF l_word5 ="1" THEN 
        LET l_gcq13 ="REFERENCING OLD AS old NEW AS new "
     ELSE 
     	LET l_gcq13 =" "
     END IF 
     LET l_str_buf = base.StringBuffer.create()                                                                          
     CALL l_str_buf.append(l_tmp) 
     
    IF g_db_type = "ORA" THEN 
       LET l_str3 = g_gcp01
       LET l_str3 = l_str3.toUpperCase()   
       LET l_sql8=" SELECT column_name FROM user_tab_columns",
               " WHERE table_name='",l_str3,"'" 
       PREPARE p_select FROM l_sql8                                                                                            
       DECLARE p_qq                                                                                                       
                  CURSOR FOR p_select                                                                                               
       FOREACH p_qq INTO l_char
          LET l_char1=l_char1 clipped,",",l_char
          LET l_char2=l_char2 CLIPPED,"||','||:OLD.",l_char
          LET l_char3=l_char3 CLIPPED,"||','||:NEW.",l_char   
       END FOREACH 
       LET  l_char1=l_char1.subString(2,l_char1.getLength())
       LET  l_char2=l_char2.subString(8,l_char2.getLength())
       LET  l_char3=l_char3.subString(8,l_char3.getLength())
              
              
    LET l_str=g_gcp[l_ac].gcp02 CLIPPED,"_",g_gcp01 CLIPPED    
    LET l_str=l_str.toUpperCase()
       IF g_gcp[l_ac].gcp05 = "Y" THEN 
          CALL cl_err(g_gcp01,'p_tgr00',1)
       ELSE                                                 
          
          LET l_start = l_str_buf.getIndexOf('$',1)
          IF l_start>0 THEN
             LET l_end = l_str_buf.getIndexOf('$',l_start+1)
          END IF
          IF l_end>0  THEN
             LET lc_sub = l_str_buf.SubString(l_start+1,l_end-1)
          END IF    
          IF ((l_start>0)AND(l_end = 0))THEN
             CALL cl_err("","lib-245",1)
             RETURN '',FALSE
          END IF
                
          CALL l_str_buf.replace('$TABLENAME$',g_gcp01 CLIPPED,0)
          CALL l_str_buf.replace('$COLLIST$',l_char1 CLIPPED,0)
          CALL l_str_buf.replace('$NEWLIST$',l_char3 CLIPPED,0)
          CALL l_str_buf.replace('$OLDLIST$',l_char2 CLIPPED,0)
          CALL l_str_buf.replace('\n',' ',0)
          LET l_tmp1 = l_str_buf.toString()
          SELECT gcp04 INTO l_num FROM gcp_file WHERE gcp01= g_gcp01 AND gcp02 = g_gcp[l_ac].gcp02
            IF l_num IS NOT NULL THEN
               LET l_str_buf = base.StringBuffer.create()                                                                          
               CALL l_str_buf.append(l_tmp1)                                                                                        
               LET l_start1 = l_str_buf.getIndexOf('#',1)                                                                           
               IF l_start>0 THEN                                                                                                   
                  LET l_end1 = l_str_buf.getIndexOf('#',l_start1+1)                                                                  
               END IF                                                                                                              
               IF l_end>0  THEN                                                                                                    
                  LET lc_sub = l_str_buf.SubString(l_start1+1,l_end1-1)                                                                 
               END IF
            END IF
            CALL l_str_buf.replace(l_str_buf.subString(l_start1,l_end1),                                                          
                                    g_gcp[l_ac].gcp04 CLIPPED,0) 
            LET l_tmp1 = l_str_buf.toString()
            LET l_sql2 = " Create or replace trigger ",g_gcp[l_ac].gcp02 CLIPPED,"_",g_gcp01 CLIPPED,
                         " ",l_begin1 CLIPPED," ",l_begin CLIPPED,        
                         " On  ",g_gcp01 CLIPPED," ",l_begin2, 
                         " ",  l_tmp1 CLIPPED
            PREPARE l_create1 FROM l_sql2            
            EXECUTE l_create1
            IF SQLCA.sqlcode THEN 
               DISPLAY SQLERRMESSAGE
               CALL cl_err(SQLERRMESSAGE,'p_tgr17',1)
            END IF    
            LET l_sql4 = " UPDATE gcp_file SET gcp06 = '",l_str,"'",
                         " WHERE gcp01 = '",g_gcp01,"'",
                         " AND gcp02 = '",g_gcp[l_ac].gcp02 CLIPPED,"'"
            PREPARE l_upd1 FROM l_sql4
            EXECUTE l_upd1
 
        END IF
 
      LET  l_sql1=" SELECT table_name",
                  " FROM user_triggers",
                  " WHERE trigger_name =","'",l_str CLIPPED,"'"
      PREPARE l_select FROM l_sql1
      EXECUTE l_select INTO l_table_name
      IF l_table_name IS NULL THEN
         LET g_gcp[l_ac].gcp05 = "N"
      ELSE
         LET g_gcp[l_ac].gcp05 = "Y"
      END IF
      UPDATE gcp_file set gcp05= g_gcp[l_ac].gcp05
      WHERE gcp01=g_gcp01 and gcp02= g_gcp[l_ac].gcp02 
    END IF
 
    IF g_db_type = "IFX" THEN               
       LET l_str3 = g_gcp01 
       LET l_sql8=" SELECT colname,coltype from syscolumns,systables where syscolumns.tabid = systables.tabid",
                  " AND tabname= '",l_str3,"'" 
       PREPARE p_select1 FROM l_sql8                                                                                            
       DECLARE p_ifx                                                                                                       
                  CURSOR FOR p_select1                                                                                               
       FOREACH p_ifx INTO l_char,l_type
       
       LET l_tmp1 = l_tmp
#       LET l_start = l_tmp1.getIndexOf(1,'OLD AS')
#       LET l_end = l_tmp1.getIndexOf(1,'NEW AS')
#       LET l_old = l_tmp1.subString(l_start,l_end)
#       LET l_old = l_old.trim()
#       LET l_end1 = l_tmp1.getIndexOf(l_end,'/n')
#       LET l_new = l_tem1.subString(l_end,l_end1)
#       LET l_new = l_new.trim()
       
          LET l_char1=l_char1 clipped,",",l_char
          IF l_type =0 OR l_type =13 OR l_type=15 OR l_type=16 
            OR l_type =256 OR l_type =269 OR l_type = 271 OR l_type =272 THEN
             LET l_char2=l_char2 CLIPPED,"||','||trim(old.",l_char,")"
             LET l_char3=l_char3 CLIPPED,"||','||trim(new.",l_char,")"   
          ELSE
             LET l_char2=l_char2 CLIPPED,"||','||(old.",l_char,")"
             LET l_char3=l_char3 CLIPPED,"||','||(new.",l_char,")"   
          END IF 
       END FOREACH 
       LET  l_char1=l_char1.subString(2,l_char1.getLength())
       LET  l_char2=l_char2.subString(8,l_char2.getLength())
       LET  l_char3=l_char3.subString(8,l_char3.getLength())  
       
       CALL l_str_buf.replace('$TABLENAME$',g_gcp01 CLIPPED,0)
       CALL l_str_buf.replace('$COLLIST$',l_char1 CLIPPED,0)
       CALL l_str_buf.replace('$NEWLIST$',l_char3 CLIPPED,0)
       CALL l_str_buf.replace('$OLDLIST$',l_char2 CLIPPED,0)  
       CALL l_str_buf.replace('\n',' ',0)
       LET l_tmp1 = l_str_buf.toString()                                                                                   
       IF g_gcp[l_ac].gcp05 = "Y" THEN                                                                                             
          CALL cl_err(g_gcp01,'p_tgr00',1)                                                                                         
       ELSE                                                                                                                      
          IF NOT cl_null(l_gcq13) THEN                                                                                                              
             LET l_sql2 = " Create trigger ",g_gcp[l_ac].gcp02 CLIPPED,"_",g_gcp01 CLIPPED,
                          " ",l_begin CLIPPED," on ",g_gcp01 CLIPPED," ",
                          l_gcq13,"",l_begin2," ",l_begin1," ",l_tmp1
          ELSE 
             LET l_sql2 = " Create trigger ",g_gcp[l_ac].gcp02 CLIPPED,"_",g_gcp01 CLIPPED,
                          " ",l_begin CLIPPED," on ",g_gcp01 CLIPPED," ",
                          l_begin2," ",l_begin1," ",l_tmp1
          END IF 	            
          PREPARE l_create2 FROM l_sql2  
          IF SQLCA.sqlcode THEN 
             DISPLAY SQLERRMESSAGE
             CALL cl_err(SQLERRMESSAGE,'p_tgr17',1)
             RETURN 
          END IF   
          EXECUTE l_create2
          IF SQLCA.sqlcode THEN 
             DISPLAY SQLERRMESSAGE
             CALL cl_err(SQLERRMESSAGE,'p_tgr17',1)
          END IF              
       END IF 
       
       LET  l_sql3=" SELECT trigid ",                                                                                           
                  " FROM systriggers ",                                                                                            
                  " WHERE trigname = ","'",g_gcp[l_ac].gcp02 CLIPPED,"_",g_gcp01 CLIPPED,"'"            
       PREPARE l_S FROM l_sql3
       EXECUTE l_S INTO l_trigid1
       IF l_trigid1 IS NULL THEN                             
          LET g_gcp[l_ac].gcp05 = "N"                                                                                              
       ELSE                                                                                                                        
          LET g_gcp[l_ac].gcp05 = "Y"
          LET l_sql4 = " UPDATE gcp_file SET gcp06 = '",g_gcp[l_ac].gcp02 CLIPPED,"_",g_gcp01 CLIPPED,"'",
                         " WHERE gcp01 = '",g_gcp01,"'",
                         " AND gcp02 = '",g_gcp[l_ac].gcp02 CLIPPED,"'"
          PREPARE l_updn FROM l_sql4
          EXECUTE l_updn                                                                                             
       END IF                                                                                                                      
       UPDATE gcp_file set gcp05= g_gcp[l_ac].gcp05                                                                                
       WHERE gcp01=g_gcp01 and gcp02= g_gcp[l_ac].gcp02                                                                            
    END IF        
END FUNCTION
 
#FUNCTION p_tgr_create_trigger1()
#  DEFINE    l_sql           STRING,
#            l_sql1          STRING,
#            l_str           STRING,
#            l_table_name    VARCHAR(10),
#            l_trigid        VARCHAR(10)
#
#   IF cl_null(g_gcq.gcq01) THEN                                                                                                 
#       CALL cl_err("",-400,0)                                                                                                       
#       RETURN                                                                                                                       
#    END IF
#
#   LET l_sql = g_gcq.gcq03,g_gcq.gcq07
#   PREPARE l_cre FROM l_sql
#   EXECUTE l_cre
#
#   IF g_gcq.gcq05="Y" THEN
#      CALL cl_err("g_gcq.gcq02",'p_tgr00',1)
#   ELSE 
#    IF g_db_type = "ORA" THEN
#      LET l_str=g_gcq.gcq02
#      LET l_str=l_str.toUpperCase() 
# 
#      LET  l_sql1=" SELECT table_name",
#                  " FROM user_triggers",
#                  " WHERE trigger_name =","'",l_str CLIPPED,"'"
#      PREPARE l_select2 FROM l_sql1
#      EXECUTE l_select2 INTO l_table_name
#      IF l_table_name IS NULL THEN
#         LET g_gcq.gcq05 = "N"
#         CALL cl_err('g_gcq.gcq07','p_tgr09',1) 
#      ELSE
#         LET g_gcq.gcq05 = "Y"
#      END IF
##     ELSE
##      LET l_sql1=" SELECT trigid ",
##                 " FROM systriggers",
##                 " WHERE trigname = ","'",g_gcq.gcq02 CLIPPED,"'"
##      PREPARE l_sele FROM l_sql1
##      EXECUTE l_sele INTO l_trigid
##      IF l_trigid IS NULL THEN
##         LET g_gcq.gcq05 = "N"
##      ELSE
##         LET g_gcq.gcq05 = "Y"
##      END IF
#    END IF 
#   END IF
#    DISPLAY BY NAME g_gcq.gcq05
#    UPDATE gcq_file set gcq05= g_gcq.gcq05
#    WHERE gcq01=g_gcq.gcq01 and gcq02 = g_gcq.gcq02 
#
#END FUNCTION 
 
FUNCTION p_tgr_drop_trigger()  
 
DEFINE
   l_sql           STRING,
   l_ac            LIKE type_file.num5,
   l_str           STRING,
   l_trigger_name  STRING,
   table_name      STRING,
   l_sql1          STRING,
  
    l_table_name    LIKE type_file.chr18, #TQC-880048
 #  l_table_name    VARCHAR(15),
   l_sql2,l_sql3,l_sql4,l_sql5,l_sql6,l_sql7     STRING,
  
    l_trigid,l_trigid1,l_trigid2,l_trigid3        LIKE type_file.chr100, #TQC-880048
 #  l_trigid,l_trigid1,l_trigid2,l_trigid3        VARCHAR(100),
   li_cnt          LIKE ze_file.ze03,                                                                                              
   li_bnt          LIKE ze_file.ze03,                                                                                              
   l_i             LIKE type_file.num5,
   l_sqln          STRING,
   l_triggername   LIKE gcq_file.gcq02
  
 
   LET l_ac = ARR_CURR()
 
   IF cl_null(g_gcp01) THEN                                                                                                        
       CALL cl_err("",-400,0)                                                                                                       
       RETURN                                                                                                                       
    END IF
 
   LET l_str=g_gcp[l_ac].gcp02 CLIPPED,"_",g_gcp01 CLIPPED                                                                       
   LET l_str=l_str.toUpperCase()
 
   IF g_db_type="ORA" THEN
     IF g_gcp[l_ac].gcp07 = "Y" THEN
      IF g_gcp[l_ac].gcp05 = "N" THEN
         CALL cl_err(g_gcp01,'p_tgr01',1)
      ELSE
         LET l_sql = " Drop trigger ",g_gcp[l_ac].gcp02 CLIPPED,"_",g_gcp01 CLIPPED 
         PREPARE l_drop FROM l_sql
         EXECUTE l_drop
 
         LET l_sqln = "UPDATE gcp_file SET gcp06 ='' WHERE gcp06 = '",l_str,"'"
         PREPARE l_upd5 FROM l_sqln
         EXECUTE l_upd5
      END IF
 
      LET  l_sql1= " SELECT table_name",                                                                                     
                 " FROM user_triggers",                                                                                             
                 " WHERE trigger_name =","'",l_str CLIPPED,"'"                                                                      
      PREPARE l_select1 FROM l_sql1                                                                                                 
      EXECUTE l_select1 INTO l_table_name
      IF l_table_name IS NULL THEN                                                                                                  
         LET g_gcp[l_ac].gcp05 = "N"                                                                                            
      ELSE                                                                                                                          
         LET g_gcp[l_ac].gcp05 = "Y"                                                                                                 
      END IF
      UPDATE gcp_file                                                                                                                
      SET gcp05= g_gcp[l_ac].gcp05                                                                                              
      WHERE gcp01=g_gcp01 and gcp02= g_gcp[l_ac].gcp02   
     ELSE
      IF g_gcp[l_ac].gcp05 = "N" THEN                                                                                               
         CALL cl_err(g_gcp01,'p_tgr01',1)                                                                                           
      ELSE
         CALL cl_getmsg('p_tgr13',g_lang) RETURNING li_cnt                                                               
         CALL cl_getmsg('p_tgr12',g_lang) RETURNING li_bnt                                                               
                                                                                                                                    
         LET l_i = FALSE                                                                                                 
                                                                                                                                   
         MENU li_bnt ATTRIBUTE (STYLE="dialog",COMMENT=li_cnt CLIPPED,IMAGE="information")                               
                                                                                                                                    
         ON ACTION delyes 
            LET l_i = TRUE                                                                                             
            LET l_sql ="  DROP trigger ", g_gcp[l_ac].gcp02 CLIPPED                                
            PREPARE l_drop_trigger1 FROM l_sql                                                                      
            EXECUTE l_drop_trigger1     
            DELETE FROM gcp_file WHERE gcp02 = g_gcp[l_ac].gcp02 
            LET l_triggername=g_gcp[l_ac].gcp02
#            CALL p_tgr_refurbish()  
            CALL g_gcp.deleteElement(l_ac)
            LET l_sql7=" UPDATE gcq_file SET gcq05='N' WHERE gcq02=LOWER('",l_triggername,"')"                                  
            PREPARE l_upd FROM l_sql7                                                                                               
            EXECUTE l_upd 
            EXIT MENU
                                                                                                                                    
         ON ACTION delno                                                                                                
            RETURN                                                                                                      
         EXIT MENU                                                                                                   
#TQC-860017 start
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE MENU
#TQC-860017 end
      END MENU                                                                                                                 
      END IF
      LET l_str=g_gcp[l_ac].gcp02 CLIPPED                                                                       
      LET l_str=l_str.toUpperCase()                                                                                                 
      LET  l_sql1= " SELECT table_name",                                                                                            
                 " FROM user_triggers",                                                                                             
                 " WHERE trigger_name =","'",l_str CLIPPED,"'"                                                                      
      PREPARE l_select3 FROM l_sql1                                                                                                 
      EXECUTE l_select3 INTO l_table_name                                                                                           
      IF l_table_name IS NULL THEN                                                                                                  
         LET g_gcp[l_ac].gcp05 = "N"                                                                                                
      ELSE                                                                                                                          
         LET g_gcp[l_ac].gcp05 = "Y"                                                                                   
      END IF                                                                                                                        
      UPDATE gcp_file                                                                                                               
                                                                                                                                    
      SET gcp05= g_gcp[l_ac].gcp05                                                                                                  
      WHERE gcp01=g_gcp01 and gcp02= g_gcp[l_ac].gcp02 
     END IF
   END IF      
   IF g_db_type ="IFX" THEN
      IF g_gcp[l_ac].gcp07 = "Y" THEN       
         IF g_gcp[l_ac].gcp05 = "N" THEN                                                                                               
            CALL cl_err(g_gcp01,'p_tgr01',1)                                                                                            
         ELSE            
            LET l_sql = "Drop trigger ",g_gcp[l_ac].gcp02 CLIPPED,"_",g_gcp01 CLIPPED
            PREPARE l_drop5 FROM l_sql
            EXECUTE l_drop5
            LET  l_sql1= " SELECT trigid",                                                                                       
                         " FROM systriggers",                                                                                              
                         " WHERE trigname =","'",g_gcp[l_ac].gcp02,"_",g_gcp01 CLIPPED,"'"                                                  
            PREPARE l_seect1 FROM l_sql                                                                                              
            EXECUTE l_seect1 INTO l_trigid                                                                                           
            IF l_trigid IS NULL THEN 
               LET g_gcp[l_ac].gcp05 = "N"                                                                                           
            ELSE                                                                                                                     
               LET g_gcp[l_ac].gcp05 = "Y"                                                                                           
            END IF                                                                                                                   
            UPDATE gcp_file                                                                                                          
              SET gcp05= g_gcp[l_ac].gcp05                                                                                             
                WHERE gcp01=g_gcp01 and gcp02= g_gcp[l_ac].gcp02                                               
         END IF
      ELSE
         IF g_gcp[l_ac].gcp05 = "N" THEN                                                                                               
            CALL cl_err(g_gcp01,'p_tgr01',1)                                                                                           
         ELSE
            CALL cl_getmsg('p_tgr13',g_lang) RETURNING li_cnt                                                               
            CALL cl_getmsg('p_tgr12',g_lang) RETURNING li_bnt                                                               
                                                                                                                                       
            LET l_i = FALSE                                                                                                 
                                                                                                                                      
            MENU li_bnt ATTRIBUTE (STYLE="dialog",COMMENT=li_cnt CLIPPED,IMAGE="information")                               
                                                                                                                                       
            ON ACTION delyes 
               LET l_i = TRUE                                                                                             
               LET l_sql ="  DROP trigger ", g_gcp[l_ac].gcp02 CLIPPED                                
               PREPARE l_drop_triggera FROM l_sql                                                                      
               EXECUTE l_drop_triggera     
               DELETE FROM gcp_file WHERE gcp02 = g_gcp[l_ac].gcp02 
               LET l_triggername=g_gcp[l_ac].gcp02
#               CALL p_tgr_refurbish()  
               CALL g_gcp.deleteElement(l_ac)
               LET l_sql7=" UPDATE gcq_file SET gcq05='N' WHERE gcq02=LOWER('",l_triggername,"')"                                  
               PREPARE l_upda FROM l_sql7                                                                                               
               EXECUTE l_upda 
               EXIT MENU
                                                                                                                                       
            ON ACTION delno                                                                                                
               RETURN                                                                                                      
            EXIT MENU                                                                                                   
#TQC-860017 start
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE MENU
#TQC-860017 end           
     END MENU
         END IF                                                                                                                  
      END IF    
    END IF          
END FUNCTION
 
#FUNCTION p_tgr_drop_trigger1()
#  DEFINE   l_sql            STRING,
#           l_trigger_name   STRING,
#           l_table_name     VARCHAR(10),
#           l_str            STRING,
#           l_sql1           STRING,
#           l_trigid         VARCHAR(10)
#         
#       IF cl_null(g_gcq.gcq01) THEN                                                                                            
#          CALL cl_err("",-400,0)                                                                                                
#          RETURN                                                                                                                   
#       END IF 
#
#       IF g_gcq.gcq05 = "N" THEN
#          CALL cl_err('','p_tgr01',1)
#       ELSE
#          LET l_sql = "DROP TRIGGER ",g_gcq.gcq02 CLIPPED
#          PREPARE l_dropx FROM l_sql
#          EXECUTE l_dropx
#       END IF    
#        
#       IF g_db_type = "ORA" THEN 
#          LET l_str = g_gcq.gcq02
#          LET l_str = l_str.toUpperCase()
#          LET  l_sql1= " SELECT table_name",                                                                                      
#                       " FROM user_triggers",                                                                                      
#                       " WHERE trigger_name =","'",l_str CLIPPED,"'"                                                               
#          PREPARE l_sel FROM l_sql1                                                                                                 
#          EXECUTE l_sel INTO l_table_name
#          IF l_table_name IS NULL THEN
#             LET g_gcq.gcq05 = "N"
#          ELSE 
#             LET g_gcq.gcq05 = "Y"
#          END IF
#       ELSE 
#          LET l_sql1 = " SELECT trigid ",
#                       " FROM systriggers ",
#                       " WHERE trigname =","'",g_gcq.gcq02 CLIPPED,"'"
#          PREPARE l_se FROM l_sql1
#          EXECUTE l_se INTO l_trigid
#          IF l_trigid IS NULL THEN
#             LET g_gcq.gcq05 = "N"
#          ELSE 
#             LET g_gcq.gcq05 = "Y"
#          END IF
#       END IF  
#       DISPLAY BY NAME g_gcq.gcq05
#       UPDATE gcq_file SET gcq05 = g_gcq.gcq05
#       WHERE gcq01=g_gcq.gcq01 AND gcq02 = g_gcq.gcq02
#END FUNCTION
          
FUNCTION p_tgr_a()
    MESSAGE ""
    CLEAR FORM
    CALL g_gcp.clear()
    CALL g_gco.clear()
    LET g_gcp01    = NULL
    LET g_gcp01_t  = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL p_tgr_i("a")                 
        IF INT_FLAG THEN                 
           LET g_gcp01 = NULL
#           INITIALIZE g_gcp02 TO NULL 
           LET INT_FLAG = 0
           CALL cl_err('',9001,0)
           CLEAR g_gcp.*
           CLEAR FORM
           EXIT WHILE
        END IF
        CALL g_gcp.clear()
        CALL p_tgr_bf('1=1')            
        CALL p_tgr_b()                
        LET g_gcp01_t = g_gcp01
        LET g_wc=" gcp01='",g_gcp01,"' "
        EXIT WHILE
    END WHILE
    
END FUNCTION
 
FUNCTION p_tgr_i(p_cmd)
DEFINE
 
  p_cmd           LIKE type_file.chr1,#TQC-880048
# p_cmd           VARCHAR(1),           
    l_n,l_w         LIKE type_file.num5,
  
   l_str           LIKE type_file.chr50,#TQC-880048
 # l_str           VARCHAR(40),
    l_sql           STRING
 
    INPUT g_gcp01 WITHOUT DEFAULTS
         FROM gcp01 HELP 1
 
        AFTER FIELD gcp01                
            IF cl_null(g_gcp01) THEN
    #           LET g_gcp01=' '
            MESSAGE "TABLE NAME SHOULD NOT BE NULL"
            NEXT FIELD gcp01
            END IF
            SELECT COUNT(*) INTO l_n FROM gcp_file
             WHERE gcp01=g_gcp01
            IF l_n > 0 THEN
               CALL cl_err(g_gcp01,-239,0)
               NEXT FIELD gcp01
            END IF
            SELECT COUNT(*) INTO l_w FROM zta_file
            WHERE  zta01 = g_gcp01
            IF l_w = 0 THEN
               CALL cl_err(g_gcp01,'p_tgr07',0)
               NEXT FIELD gcp01
            END IF
           
           
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLF             
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()     
 
        ON ACTION help        
           CALL cl_show_help()  
 
        ON ACTION controlg     
           CALL cl_cmdask()     
 
        ON ACTION controlp                                                                                                            
           CASE                                                                                                                       
             WHEN INFIELD(gcp01)                                                                                         
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.state = 'i'                                                                                         
                 LET g_qryparam.form ="q_zta1"                                                                                       
                 LET g_qryparam.arg1 = g_lang CLIPPED                                                                               
                 CALL cl_create_qry() RETURNING g_gcp01                                                                  
                 DISPLAY BY NAME g_gcp01                                                                               
                 NEXT FIELD gcp01                                                                                                   
                                                                                                                                    
           OTHERWISE EXIT CASE                                                                                                      
          END CASE                
    END INPUT
END FUNCTION
 
FUNCTION p_tgr_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_gcp.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL p_tgr_cs()                  
    IF INT_FLAG THEN            
        LET INT_FLAG = 0
        RETURN
        CLEAR FORM
    END IF
    OPEN p_gcp_bcs                      
    IF SQLCA.sqlcode THEN            
       CALL cl_err('',SQLCA.sqlcode,0)
       INITIALIZE g_gcp01 TO NULL
    ELSE
       OPEN p_gcp_count
       FETCH p_gcp_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       DISPLAY g_curs_index TO FORMONLY.idx
       CALL p_tgr_fetch('F')            
    END IF
  
END FUNCTION
 
FUNCTION p_tgr_fetch(p_flag)
DEFINE
 
    p_flag          LIKE type_file.chr1 #TQC-880048
 #  p_flag          VARCHAR(1)             
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     p_gcp_bcs INTO g_gcp01
        WHEN 'P' FETCH PREVIOUS p_gcp_bcs INTO g_gcp01
        WHEN 'F' FETCH FIRST    p_gcp_bcs INTO g_gcp01
        WHEN 'L' FETCH LAST     p_gcp_bcs INTO g_gcp01
        WHEN '/'
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt mod
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()     
 
         END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump p_gcp_bcs INTO g_gcp01
         LET g_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN               
       CALL cl_err(g_gcp01,SQLCA.sqlcode,0)
       RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count)
       CALL p_tgr_show() 
       DISPLAY g_curs_index TO FORMONLY.idx
 
    END IF
#    SELECT UNIQUE gcp01 INTO g_gcp01
#      FROM gcp_file
#     WHERE gcp01=g_gcp01
    IF SQLCA.sqlcode THEN                 
        CALL cl_err(g_gcp01,SQLCA.sqlcode,0)
    ELSE
#        LET g_data_owner = g_gcpuser   
#        LET g_data_group = g_gcpgrup   
        CALL p_tgr_show()
    END IF
 
END FUNCTION
 
FUNCTION p_tgr_show()
    DISPLAY g_gcp01 TO gcp01              
    CALL p_tgr_bf(g_wc)
    CALL p_tgr_bf1()
END FUNCTION
 
FUNCTION p_tgr_r()
 
  IF s_shut(0) THEN RETURN END IF
 
  IF g_gcp01 IS NULL THEN
     CALL cl_err('',-400,0)
     RETURN
  END IF
 
  BEGIN WORK
  IF cl_delh(0,0) THEN
     DELETE FROM gcp_file
      WHERE gcp01=g_gcp01
     IF SQLCA.sqlcode THEN
        CALL cl_err('BODY DELETE:',SQLCA.sqlcode,0)
     ELSE
        CLEAR FORM
        CALL g_gcp.clear()
        LET g_cnt=SQLCA.SQLERRD[3]
        MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
        OPEN p_gcp_count
        FETCH p_gcp_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN p_gcp_bcs
        IF g_curs_index = g_row_count THEN
           LET g_jump = g_row_count
           CALL p_tgr_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET g_no_ask = TRUE
           CALL p_tgr_fetch('/')
        END IF
     END IF
     LET g_msg=TIME
  END IF
  COMMIT WORK
END FUNCTION
 
FUNCTION p_tgr_b()
DEFINE
    l_ac_t          LIKE type_file.num5,              
    l_n             LIKE type_file.num5,          
     l_lock_sw      LIKE type_file.chr1,#TQC-880048
     p_cmd          LIKE type_file.chr1,#TQC-880048
 #   l_lock_sw       VARCHAR(1),            
 #   p_cmd           VARCHAR(1),           
    l_allow_insert  LIKE type_file.num5,          
    l_allow_delete  LIKE type_file.num5,
    l_str           STRING,
 
    l_trigger_type  LIKE type_file.chr18,#TQC-880048
 #  l_trigger_type  VARCHAR(16),
    l_ac            LIKE type_file.num5,
    li_cnt          LIKE ze_file.ze03,
    li_bnt          LIKE ze_file.ze03,
    l_i             LIKE type_file.num5,
    l_sql           STRING,
    l_a             LIKE type_file.num5 
 
 
    LET g_action_choice = ""
    IF g_gcp01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      #"SELECT gcp02,gcp03,gcp04,gcp05 FROM gcp_file ",        #MOD-8C0198 mark
       "SELECT gcp02,gcp03,gcp04,gcp05,gcp07 FROM gcp_file ",  #MOD-8C0198
       "WHERE gcp01 = ? AND gcp02 = ? AND gcp03 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p_gcp_b_cl CURSOR FROM g_forupd_sql
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_gcp WITHOUT DEFAULTS FROM s_gcp.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
   
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        CALL cl_set_comp_entry("gcp02,gcp03,gcp05",FALSE )
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_gcp_t.* = g_gcp[l_ac].*  
                OPEN p_gcp_b_cl USING g_gcp01,g_gcp_t.gcp02,g_gcp_t.gcp03
                IF STATUS THEN
                   CALL cl_err("OPEN p_gcp_b_cl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_gcp01_t,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       LET g_gcp_t.*=g_gcp[l_ac].*
                   END IF
                   FETCH p_gcp_b_cl INTO g_gcp[l_ac].*
            END IF  
                END IF
            NEXT FIELD gcp02
 
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_gcp[l_ac].* TO NULL           
            LET g_gcp_t.* = g_gcp[l_ac].*            
            LET g_gcp[l_ac].gcp05 = "N" 
             
            SELECT COUNT(*) INTO l_a FROM gcp_file 
            WHERE gcp01 = g_gcp01 
            IF l_a = 0 THEN
               LET g_sql = " SELECT gcp02,gcp03 ",
                        " FROM gcp_file",
                        " WHERE gcp01 IS NULL",
                        " ORDER BY gcp02"
               PREPARE p_gcp_pb FROM g_sql
               DECLARE gcp_cs1
                CURSOR FOR p_gcp_pb
 
               CALL g_gcp.clear()
               LET g_cnt =1 
            
               FOREACH gcp_cs1 INTO g_gcp[g_cnt].*
                  LET g_gcp[g_cnt].gcp05 = "N"
                  LET g_gcp[g_cnt].gcp07 = "Y"
                  LET g_cnt = g_cnt +1
               END FOREACH
               CALL g_gcp.deleteElement(g_cnt)
 
               LET g_rec_b=g_cnt
               LET g_cnt = 0   
 
               DROP TABLE y
               SELECT * FROM gcp_file WHERE gcp01 IS NULL
                 INTO TEMP y
               UPDATE y
                 SET gcp01=g_gcp01
               UPDATE y
                 SET gcp05 = "N"
               UPDATE y
                 SET gcp07 = "Y"
               INSERT INTO gcp_file
                SELECT * FROM y
            END IF 
       
            CALL p_tgr_refurbish()
 
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
 #           INSERT INTO gcp_file(gcp01,gcp02,gcp03,gcp04,gcpacti)
 #             VALUES(g_gcp01,g_gcp[l_ac].gcp02,g_gcp[l_ac].gcp03,
 #                g_gcp[l_ac].gcp04,g_gcp[l_ac].gcpacti)
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_gcp[l_ac].gcp02,SQLCA.sqlcode,0)
                CANCEL INSERT
            ELSE
#                MESSAGE 'INSERT O.K'
                COMMIT WORK
                LET g_rec_b=g_rec_b+1
#                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        AFTER FIELD gcp04                                                                                                         
            IF g_gcp[l_ac].gcp02 IS NULL THEN                                                                                       
               CALL cl_err('','p_tgr10',1)                                                                                          
               RETURN                                                                                                               
            END IF  
 
        BEFORE DELETE                            
            IF NOT cl_null(g_gcp_t.gcp02) AND
               NOT cl_null(g_gcp_t.gcp03) THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
   #             IF l_lock_sw = "Y" THEN
   #                CALL cl_err("", -263, 1)
   #                CANCEL DELETE
   #             END IF
                 IF g_gcp[l_ac].gcp05 = "Y" THEN
                    CALL cl_getmsg('p_tgr11',g_lang) RETURNING li_cnt
                    CALL cl_getmsg('p_tgr12',g_lang) RETURNING li_bnt
 
                    LET l_i = FALSE
 
                    MENU li_bnt ATTRIBUTE (STYLE="dialog",COMMENT=li_cnt CLIPPED,IMAGE="information")
 
                      ON ACTION delyes
                         LET l_i = TRUE
                         DELETE FROM gcp_file
                         WHERE gcp01 = g_gcp01
                                 AND gcp02 = g_gcp_t.gcp02
                                 AND gcp03 = g_gcp_t.gcp03
                         LET l_sql ="  DROP trigger ", g_gcp[l_ac].gcp02 CLIPPED,"_",g_gcp01 CLIPPED 
                             PREPARE l_drop_trigger FROM l_sql
                             EXECUTE l_drop_trigger
                    EXIT MENU
 
                     ON ACTION delno
                        RETURN 
                        EXIT MENU
#TQC-860017 start
 
                     ON IDLE g_idle_seconds
                        CALL cl_on_idle()
                        CONTINUE MENU
#TQC-860017 end         
                   END MENU
                   ELSE                                                                                                             
                    DELETE FROM gcp_file WHERE gcp01 = g_gcp01                                                                      
                                AND gcp02 = g_gcp_t.gcp02                                                                           
                                AND gcp03 = g_gcp_t.gcp03                                                                           
                   END IF 
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_gcp_t.gcp02,SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
            COMMIT WORK
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_gcp[l_ac].* = g_gcp_t.*
               DISPLAY BY NAME g_gcp[l_ac].*
               CLOSE p_gcp_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_gcp[l_ac].gcp02,-263,1)
               LET g_gcp[l_ac].* = g_gcp_t.*
            ELSE
               UPDATE gcp_file SET gcp04=g_gcp[l_ac].gcp04
#                                   gcpacti=g_gcp[l_ac].gcpacti
               WHERE gcp01=g_gcp01 AND gcp02 = g_gcp[l_ac].gcp02
         #       WHERE CURRENT OF p_gcp_b_cl 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_gcp[l_ac].gcp02,SQLCA.sqlcode,0)
                  LET g_gcp[l_ac].* = g_gcp_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_gcp[l_ac].* = g_gcp_t.*
               END IF
               CLOSE p_gcp_b_cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            CLOSE p_gcp_b_cl
            COMMIT WORK 
 
 #       ON ACTION CONTROLN
 #           CALL p_tgr_b_askkey()
 #           EXIT INPUT
 
        ON ACTION CONTROLO                 
            IF INFIELD(gcp02) AND l_ac > 1 THEN
                LET g_gcp[l_ac].* = g_gcp[l_ac-1].*
                LET g_gcp[l_ac].gcp02=l_ac
                DISPLAY BY NAME g_gcp[l_ac].*
                DISPLAY BY NAME g_gcp[l_ac].gcp02
                NEXT FIELD gcp02
            END IF
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
        END INPUT
    CLOSE p_gcp_b_cl
    COMMIT WORK
    CALL p_tgr_show()
END FUNCTION
 
FUNCTION p_tgr_b1()
    DEFINE     l_ac_t          LIKE type_file.num5,
               l_n             LIKE type_file.num5,
                l_lock_sw      LIKE type_file.chr1, #TQC-880048
                p_cmd          LIKE type_file.chr1, #TQC-880048
             #  l_lock_sw       VARCHAR(1),
             #  p_cmd           VARCHAR(1),
               l_allow_insert  LIKE type_file.num5,
               l_allow_delete  LIKE type_file.num5,
               l_str           STRING,
               l_ac            LIKE type_file.num5,
               l_sql           STRING,
               l_test          LIKE type_file.num5
 
      LET g_action_choice = ""
      IF cl_null(g_wc) AND g_gco_t.gco01 IS NULL THEN 
         CALL cl_err('',-400,0)
         RETURN
      END IF 
      IF s_shut(0) THEN RETURN END IF 
      CALL cl_opmsg('b')
      SELECT COUNT(*)INTO l_test FROM gco_file WHERE gco01=g_gcp01
      LET g_forupd_sql =
          "SELECT gco01,gco02,gco03,gco04,gco05,gco06,gco07 FROM gco_file",
          "WHERE gco01=? AND gco02=? AND gco03=? FOR UPDATE "
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      DECLARE p_gcp_b_c2 CURSOR FROM g_forupd_sql
 
      LET l_ac_t = 0
      LET l_allow_insert =cl_detail_input_auth("insert")
      LET l_allow_delete =cl_detail_input_auth("delete")
 
      INPUT ARRAY g_gco WITHOUT DEFAULTS FROM s_gco.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
            INSERT ROW =l_allow_insert,DELETE ROW =l_allow_delete,
            APPEND ROW =l_allow_insert)
    
      BEFORE ROW 
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'
         LET l_n = ARR_COUNT()
 
     BEFORE DELETE
         IF l_lock_sw = "Y" THEN
            CALL cl_err("",-263,1)
            CANCEL DELETE
         END IF
         IF NOT cl_delb(0,0) THEN
            CANCEL DELETE
         END IF 
         LET l_sql = " DELETE FROM gco_file ",
                     " WHERE gco03 ='", g_gco[l_ac].gco03 CLIPPED,"'",
                     " AND gco04 ='", g_gco[l_ac].gco04 CLIPPED,"'"
         PREPARE l_delete FROM l_sql
         EXECUTE l_delete
         IF SQLCA.sqlcode THEN
              CALL cl_err('',SQLCA.sqlcode,0)
              ROLLBACK WORK
              CANCEL DELETE
         END IF 
         LET l_test = l_test-1
         DISPLAY l_test TO FORMONLY.cn2
       
      AFTER ROW 
         LET l_ac =ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
           CALL cl_err('',9001,0)
         END IF
         LET INT_FLAG = 0
         IF p_cmd = 'u' THEN
            LET g_gco[l_ac].*=g_gco_t.*
         END IF 
         CLOSE p_gcp_b_c2
         COMMIT WORK             
#TQC-860017 start
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION controlg
           CALL cl_cmdask()
 
        ON ACTION help
           CALL cl_show_help()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
#TQC-860017 end    
     END INPUT 
 
END FUNCTION
 
FUNCTION p_tgr_bf(p_wc)                   
DEFINE
  
   p_wc            LIKE type_file.chr200 #TQC-880048
 # p_wc            VARCHAR(200)
    LET g_sql =
       " SELECT gcp02,gcp03,gcp04,gcp05,gcp07 ",
       " FROM gcp_file ",
       " WHERE gcp01 = '",g_gcp01,"'",
#       " AND gcp07='Y'",  
       " AND ",p_wc CLIPPED ,
       " ORDER BY gcp02"
    PREPARE p_gcp_prepaap2 FROM g_sql    
    DECLARE gcp_cs CURSOR FOR p_gcp_prepaap2
    CALL g_gcp.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH gcp_cs INTO g_gcp[g_cnt].*    
        LET g_rec_b = g_rec_b + 1
        IF SQLCA.sqlcode THEN
            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_gcp.deleteElement(g_cnt)
#   DISPLAY ARRAY g_gcp TO s_gcp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
#    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION p_tgr_bf1()
 
   DEFINE   p_wc         LIKE type_file.chr200 #TQC-880048
 # DEFINE   p_wc         VARCHAR(200)
  DEFINE   l_test       LIKE type_file.num5
      #    SELECT gco01 INTO l_test FROM gco_file
      #    WHERE gco01 = g_gcp01
             
          LET g_sql1 =
               " SELECT gco01,gco02,gco03,gco04,gco05,gco06,gco07",
               " FROM gco_file",
               " WHERE gco01='",g_gcp01,"'",
               " ORDER BY gco01"
           PREPARE p_gcp_prepare3 FROM g_sql1
           DECLARE p_gco_cs CURSOR FOR p_gcp_prepare3
          
           SELECT COUNT(*)INTO g_test FROM gco_file WHERE gco01=g_gcp01 
           CALL g_gco.clear()
           LET g_cnt = 1
           LET g_rec_b1 = 0 
           FOREACH p_gco_cs INTO g_gco[g_cnt].*
               LET g_rec_b1=g_rec_b1+1
               LET g_cnt = g_cnt +1
               IF g_cnt > g_max_rec THEN
                  CALL cl_err('',9035,0)
                  EXIT FOREACH
               END IF 
           END FOREACH
           CALL g_gco.deleteElement(g_cnt)
           DISPLAY g_test TO FORMONLY.cn2
#           DISPLAY ARRAY g_gco TO s_gco.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
           LET g_cnt = 0
END FUNCTION
 
FUNCTION p_tgr_bp(p_ud)
DEFINE
  
    p_ud            LIKE type_file.chr1, #TQC-880048
  # p_ud            VARCHAR(1),
    l_ac1           LIKE type_file.num5,
    l_ac            LIKE type_file.num5
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_gcp TO s_gcp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)  
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count)
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
#      ON ACTION reproduce
#         LET g_action_choice="reproduce"
#         EXIT DISPLAY
      ON ACTION first
         CALL p_tgr_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
          EXIT DISPLAY               
 
      ON ACTION previous
         CALL p_tgr_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
          EXIT DISPLAY               
 
      ON ACTION jump
         CALL p_tgr_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
          EXIT DISPLAY               
 
      ON ACTION next
         CALL p_tgr_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
          EXIT DISPLAY                
 
      ON ACTION last
         CALL p_tgr_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
          EXIT DISPLAY      
 
      ON ACTION trigger_setting
         LET g_cmd = "p_tgr_base"
         CALL cl_cmdrun(g_cmd)
         LET g_action_choice = "trigger_setting"
         EXIT DISPLAY  
 
      ON ACTION refurbish
         CALL p_tgr_refurbish()
         EXIT DISPLAY  
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET g_b_flag = 1
         LET l_ac = 1
         EXIT DISPLAY
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      ON ACTION page2
#         LET l_ac1 = ARR_CURR()
         LET g_b_flag = 2
#        CALL p_tgr_bp1()
         EXIT DISPLAY	
      
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
   ON ACTION accept
      LET g_action_choice="detail"
      LET g_b_flag = 1
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 	
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION close
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
#      ON ACTION exporttoexcel   
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
 
      ON ACTION create_trigger
         CALL p_tgr_create_trigger()
 
      ON ACTION drop_trigger
         CALL p_tgr_drop_trigger()
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p_tgr_bp1()
  
     DEFINE p_ud             LIKE type_file.chr1, #TQC-880048
 #   DEFINE p_ud               VARCHAR(1),
          l_ac1              LIKE type_file.num5
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF  
 
   LET g_action_choice = " "
 
#   DISPALY g_rec_b1 TO FORMONLY.cn2
 
   CALL cl_set_act_visible("accept,cancel",FALSE)
 
   DISPLAY ARRAY g_gco TO s_gco.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting(g_curs_index,g_row_count)
 
      BEFORE ROW 
         LET l_ac1 = ARR_CURR()
 
     ON ACTION locale
        CALL cl_dynamic_locale()
        EXIT DISPLAY
  
     ON ACTION page1
        LET g_b_flag = 1
#        CALL p_tgr_menu()
#        CALL p_tgr_bp("G") 
        EXIT DISPLAY
 
     ON ACTION detail
        LET g_action_choice="detail"
        LET g_b_flag=2
        LET l_ac1 = ARR_CURR()
        EXIT DISPLAY
 
     ON ACTION cancel
        LET g_action_choice="exit"
        EXIT DISPLAY
 
     ON ACTION help
        LET g_action_choice="help"
        EXIT DISPLAY
 
     ON ACTION controlg
        LET g_action_choice="controlg"
        EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
     ON ACTION about
        CALL cl_about()
 
     ON ACTION exit 
        LET g_action_choice="exit"
        EXIT DISPLAY      
     
     ON ACTION exporttoexcel
        CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_gco),'','')
        EXIT DISPLAY 
 
     ON ACTION first
        CALL p_tgr_fetch('F')
#        CALL cl_navigator_setting(g_curs_index,g_row_count)
          IF g_rec_b1 != 0 THEN
             CALL fgl_set_arr_curr(1)
          END IF 
        EXIT DISPLAY
 
     ON ACTION previous
        CALL p_tgr_fetch('P')
#        CALL cl_navigator_setting(g_curs_index,g_row_count)
          IF g_rec_b1 != 0 THEN
             CALL fgl_set_arr_curr(1)
          END IF 
        EXIT DISPLAY
 
     ON ACTION jump
         CALL p_tgr_fetch('/')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
          EXIT DISPLAY               
 
      ON ACTION next
         CALL p_tgr_fetch('N')
#         CALL cl_navigator_setting(g_curs_index, g_row_count) 
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
          EXIT DISPLAY                
 
      ON ACTION last
         CALL p_tgr_fetch('L')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
           END IF
          EXIT DISPLAY
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel",TRUE)
END FUNCTION
 
FUNCTION p_tgr_refurbish()
DEFINE    l_sql                  STRING
DEFINE    l_str                  STRING
DEFINE    l_allow_insert         LIKE type_file.num5
DEFINE    l_allow_delete         LIKE type_file.num5
DEFINE    l_num                  LIKE type_file.num5
 
   IF g_gcp01 IS NULL THEN                                                                            
      CALL cl_err('',-400,0)                                                                                                      
      RETURN                                                                                                                      
   END IF                                                                                                                         
   SELECT COUNT(*) INTO g_cnt FROM gcp_file WHERE gcp01 = g_gcp01 
   LET l_str = g_gcp01
   LET l_str = l_str.toUpperCase() 
   IF g_cnt != 0 THEN   #MOD-8C0198 add
      SELECT COUNT(*) INTO l_num FROM gcp_file
       WHERE gcp02 = g_gcp[g_cnt].gcp02 AND gcp07 = 'N'                                
  #str MOD-8C0198 add
   ELSE
      LET l_num = 0
   END IF
  #end MOD-8C0198 add
   IF l_num = 0 THEN  
      IF g_db_type='ORA' THEN 
         LET l_sql = " SELECT trigger_name  ",                                                                             
                     " FROM user_triggers",
                     " WHERE table_name = '",l_str,"' AND",                                                             
                     " trigger_name NOT IN (SELECT gcp06 FROM gcp_file ",  
                     " WHERE gcp06 IS NOT NULL)"
         PREPARE p_gcp_pb1 FROM l_sql                                                                                     
         DECLARE gcp_cs2                                                                                                  
              CURSOR FOR p_gcp_pb1                                                                                   
         LET g_cnt = g_cnt+1                                                                                               
         LET g_rec_b = 0                                                                                                    
         FOREACH gcp_cs2 INTO g_gcp[g_cnt].gcp02
            SELECT ze03 INTO g_gcp[g_cnt].gcp03 FROM ze_file 
            WHERE ze01 = 'p_tgr' AND ze02 = g_lang 
            LET g_gcp[g_cnt].gcp05 = "Y"                                                                                          
            LET g_gcp[g_cnt].gcp07 = "N"
            SELECT COUNT(*) INTO l_num FROM gcp_file WHERE gcp02 = g_gcp[g_cnt].gcp02 AND gcp07 = 'N'                    
            IF l_num = 0 THEN 
               INSERT INTO gcp_file(gcp01,gcp02,gcp03,gcp05,gcp06,gcp07) VALUES(g_gcp01,g_gcp[g_cnt].gcp02,g_gcp[g_cnt].gcp03,'Y',g_gcp[g_cnt].gcp02,'N') 
            END IF
            LET g_rec_b = g_rec_b + 1                                                                                              
            IF SQLCA.sqlcode THEN                                                                                                  
               CALL cl_err('FOREACH:',SQLCA.sqlcode,1)                                                                        
               EXIT FOREACH                                                                                                     
            END IF                                                                                                            
            LET g_cnt = g_cnt + 1                                                                                                
            IF g_cnt > g_max_rec THEN                                                                                           
               CALL cl_err('',9035,0)                                                                                              
               EXIT FOREACH                                                                                                        
            END IF                                                                                                                 
         END FOREACH  
      ELSE 
         LET l_sql = " SELECT trigname ",
                     " FROM systriggers,systables ",
                     " WHERE systriggers.tabid = systables.tabid ",
                     " AND systables.tabname = '",g_gcp01 CLIPPED,"' AND ",
                     " systriggers.trigname NOT IN (SELECT gcp06 FROM gcp_file ",
                	   " WHERE gcp06 IS NOT NULL)" 
         PREPARE p_gcp_pb2 FROM l_sql                                                                                     
         DECLARE gcp_cs3                                                                                                  
              CURSOR FOR p_gcp_pb2                                                                                   
         LET g_cnt = g_cnt+1                                                                                               
         LET g_rec_b = 0                                                                                                    
         FOREACH gcp_cs3 INTO g_gcp[g_cnt].gcp02
            SELECT ze03 INTO g_gcp[g_cnt].gcp03 FROM ze_file 
            WHERE ze01 = 'p_tgr' AND ze02 = g_lang 
            LET g_gcp[g_cnt].gcp05 = "Y"                                                                                          
            LET g_gcp[g_cnt].gcp07 = "N"
            SELECT COUNT(*) INTO l_num FROM gcp_file WHERE gcp02 = g_gcp[g_cnt].gcp02 AND gcp07 = 'N'                    
            IF l_num = 0 THEN 
               INSERT INTO gcp_file(gcp01,gcp02,gcp03,gcp05,gcp06,gcp07) VALUES(g_gcp01,g_gcp[g_cnt].gcp02,g_gcp[g_cnt].gcp03,'Y',g_gcp[g_cnt].gcp02,'N') 
            END IF
            LET g_rec_b = g_rec_b + 1                                                                                              
            IF SQLCA.sqlcode THEN                                                                                                  
               CALL cl_err('FOREACH:',SQLCA.sqlcode,1)                                                                        
               EXIT FOREACH                                                                                                     
            END IF                                                                                                            
            LET g_cnt = g_cnt + 1                                                                                                
            IF g_cnt > g_max_rec THEN                                                                                           
               CALL cl_err('',9035,0)                                                                                              
               EXIT FOREACH                                                                                                        
            END IF                                                                                                                 
         END FOREACH    
      END IF         	   
      CALL g_gcp.deleteElement(g_cnt)
   END IF         
END FUNCTION 
 
FUNCTION p_tgr_out()
    DEFINE
        l_i             LIKE type_file.num5,
         l_name          LIKE type_file.chr20, #TQC-880048                
         l_za05          LIKE type_file.chr50, #TQC-880048
      #  l_name          VARCHAR(20),                
      #  l_za05          VARCHAR(40),
        sr RECORD
             gcp01      LIKE gcp_file.gcp01,
             gcp02      LIKE gcp_file.gcp02,
             gcp03      LIKE gcp_file.gcp03,
             gcp04      LIKE gcp_file.gcp04
        END RECORD
 
    IF cl_null(g_wc) AND g_gcp01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    CALL cl_wait()
    CALL cl_outnam('p_gcp') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT gcp01,gcp02,gcp03,gcp04,gcp05 FROM gcp_file ", 
              " WHERE ",g_wc CLIPPED ,
              " ORDER BY gcp01,gcp02,gcp03 "
    PREPARE p_gcp_p1 FROM g_sql              
    DECLARE p_gcp_co CURSOR FOR p_gcp_p1
 
    START REPORT p_tgr_rep TO l_name
 
    FOREACH p_gcp_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        OUTPUT TO REPORT p_tgr_rep(sr.*)
    END FOREACH
 
    FINISH REPORT p_tgr_rep
 
    CLOSE p_gcp_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT p_tgr_rep(sr)
    DEFINE
       
         l_trailer_sw    LIKE type_file.chr1, #TQC-880048
      #  l_trailer_sw    VARCHAR(1),
        sr RECORD
           gcp01   LIKE gcp_file.gcp01,
           gcp02   LIKE gcp_file.gcp02,
           gcp03   LIKE gcp_file.gcp03,
           gcp04   LIKE gcp_file.gcp04
#           gcpacti LIKE gcp_file.gcpacti
        END RECORD
 
   OUTPUT
       TOP MARGIN 0
       LEFT MARGIN 0
       BOTTOM MARGIN 4
       PAGE LENGTH g_page_line
 
    ORDER BY sr.gcp01,sr.gcp02,sr.gcp03
 
    FORMAT
        PAGE HEADER
            PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED, pageno_total
            PRINT g_dash[1,g_len]
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]
            PRINT g_dash1
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.gcp01
           PRINT COLUMN g_c[31],sr.gcp01 CLIPPED;
 
        ON EVERY ROW
           PRINT COLUMN g_c[32],sr.gcp02 CLIPPED,
                 COLUMN g_c[33],sr.gcp03 CLIPPED,
                 COLUMN g_c[34],cl_numfor(sr.gcp04,34,g_azi04)
 
        ON LAST ROW
          IF g_zz05 = 'Y' THEN     
             PRINT g_dash[1,g_len]
            END IF
          PRINT g_dash[1,g_len]
          LET l_trailer_sw = 'n'
          PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
