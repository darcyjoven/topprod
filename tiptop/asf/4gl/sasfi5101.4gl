# Prog. Version..: '5.30.06-13.04.22(00001)'     #
#
# PATTERN NAME...: asfi5101
# DESCRIPTIONS...: 欠料調整作業
# DATE & AUTHOR..: 13/02/04  By Nina
# Modify.........: No.DEV-D20001 13/02/04 By Nina 新增作業欠料調整作業
# Modify.........: No.DEV-D30019 13/03/04 By Nina (1)增加依是否調整倉庫儲位Flag控管是否讓使用者調整倉庫儲位
#                                                 (2)右側欄位增加：倉庫+儲位的輸入條件
#                                                 (3)右邊料件數量總量需控卡須等於左邊的實發量(料件+倉庫+儲位)
# Modify.........: No.DEV-D30026 13/03/20 By Nina GP5.3 追版:以上為GP5.25 的單號         

DATABASE ds
             
GLOBALS "../../config/top.global"
#GLOBALS "../4gl/sasfi501.global"  #mark by guanyao160908
 
#DEV-D20001 add str----------
DEFINE 
    g_ibj    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
         ibj02        LIKE ibj_file.ibj02,
         ima02        LIKE ima_file.ima02,
         ima021       LIKE ima_file.ima021,
         ibj03        LIKE ibj_file.ibj03, 
         ibj04        LIKE ibj_file.ibj04,
         ibj05        LIKE ibj_file.ibj05,
         sfs05_sum    LIKE sfs_file.sfs05
           END  RECORD,
    g_sfs    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
         sfs04        LIKE sfs_file.sfs04,
         sfs02        LIKE sfs_file.sfs02,
         sfs03        LIKE sfs_file.sfs03,
         sfs07        LIKE sfs_file.sfs07,      #DEV-D30019 add
         sfs08        LIKE sfs_file.sfs08,      #DEV-D30019 add
         sfs05        LIKE sfs_file.sfs05,
         sfs05_2      LIKE sfs_file.sfs05
            END  RECORD,
    g_sfs_t    DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
         sfs04        LIKE sfs_file.sfs04,
         sfs02        LIKE sfs_file.sfs02,
         sfs03        LIKE sfs_file.sfs03,
         sfs07        LIKE sfs_file.sfs07,      #DEV-D30019 add
         sfs08        LIKE sfs_file.sfs08,      #DEV-D30019 add
         sfs05        LIKE sfs_file.sfs05,
         sfs05_2      LIKE sfs_file.sfs05
            END  RECORD,
    g_wc,g_wc2,g_sql     STRING,  
    g_rec_b         LIKE type_file.num10,                #單身筆數  
    g_rec_b2        LIKE type_file.num10,                #單身筆數  
    g_row_count     LIKE type_file.num5,
    g_curs_index    LIKE type_file.num5,
    mi_no_ask       LIKE type_file.num5,
    g_jump          LIKE type_file.num5,
    l_ac            LIKE type_file.num10,                 #目前處理的ARRAY CNT  
    l_ac2           LIKE type_file.num10,                 #目前處理的ARRAY CNT  
    g_chr           LIKE type_file.chr1,
    g_flag          LIKE type_file.chr1,
    g_msg           STRING,
    l_row_count     LIKE type_file.num10,
    l_row_count2    LIKE type_file.num10,           #DEV-D30019 add
    l_ibj_row       LIKE type_file.num10

DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done   LIKE type_file.num5        
DEFINE g_cnt           LIKE type_file.num10      
DEFINE i               LIKE type_file.num5     #count/index for any purpose  
DEFINE p_row,p_col     LIKE type_file.num5    
DEFINE g_argv1         LIKE type_file.chr20   
DEFINE g_sfs05      DYNAMIC ARRAY OF RECORD
        sfs05_sum   LIKE sfs_file.sfs05   
           END  RECORD
DEFINE l_chk_sfs05_2   LIKE type_file.chr1   #DEV-D30019 add
DEFINE l_chk_sfs07     LIKE type_file.chr1   #DEV-D30019 add
DEFINE l_chk_sfs08     LIKE type_file.chr1   #DEV-D30019 add
DEFINE l_chk_warahouse LIKE type_file.chr1   #DEV-D30019 add
DEFINE g_argv2          LIKE type_file.chr1    #No.FUN-680121 CHAR(1)   #add by guanyao160908
 
FUNCTION i5101(p_argv1,p_argv2)
   DEFINE p_argv1      LIKE type_file.chr20
   DEFINE p_argv2      LIKE type_file.chr1   #DEV-D30019 add

    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   
   IF (NOT cl_user()) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("asf")) THEN
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF

   LET g_argv1 = p_argv1
   LET g_argv2 = p_argv2    #DEV-D30019 add
   
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) 
       RETURNING g_time    
    LET p_row = 3 LET p_col = 14
    OPEN WINDOW i5101_w AT p_row,p_col WITH FORM "asf/42f/asfi5101"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()    
    CALL cl_ui_locale("asfi5101")    

    #DEV-D30019 add str-----------
     IF g_argv2 = 'Y' THEN
        CALL cl_set_comp_visible("sfs07",TRUE)        
        CALL cl_set_comp_visible("sfs08",TRUE)
     ELSE
        CALL cl_set_comp_visible("sfs07",FALSE)
        CALL cl_set_comp_visible("sfs08",FALSE)
     END IF
    #DEV-D30019 add end-----------

    IF NOT cl_null(g_argv1) THEN  
       CALL i5101_q()       
    END IF    
    CALL i5101_menu()
    CLOSE WINDOW i5101_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) 
       RETURNING g_time    
END FUNCTION 
 
FUNCTION i5101_menu()
 
   WHILE TRUE
      CALL i5101_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i5101_q()
            END IF            
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "detail"
            CALL i5101_b()
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION i5101_q()

   MESSAGE ""
   CLEAR FORM
   CALL g_ibj.CLEAR()
   CALL g_sfs.CLEAR()
 
   CALL i5101_cs()
   CALL i5101_show()
 
END FUNCTION

FUNCTION i5101_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
   CLEAR FORM 
    CALL g_ibj.CLEAR()
    CALL g_sfs.CLEAR()

    IF NOT cl_null(g_argv1) OR g_argv1<>' ' THEN  
       LET g_wc  = " ibj06 ='",g_argv1,"'"                                  
       LET g_wc2 = " sfs01 ='",g_argv1,"'"               
    ELSE
      DIALOG ATTRIBUTES(UNBUFFERED)
         CONSTRUCT BY NAME g_wc ON s_ibj

         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         END CONSTRUCT

         CONSTRUCT BY NAME g_wc2 ON s_sfs

         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         END CONSTRUCT
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG 
    
         ON ACTION about
            CALL cl_about()
    
         ON ACTION HELP
            CALL cl_show_help()
    
         ON ACTION controlg
            CALL cl_cmdask()
    
        #ON ACTION qbe_save
        #   CALL cl_qbe_save()
 
         ON ACTION accept
            EXIT DIALOG
           
         ON ACTION cancel
            LET INT_FLAG = TRUE
            EXIT DIALOG

         ON ACTION exit
            LET INT_FLAG = TRUE
            EXIT DIALOG

         ON ACTION close
            LET INT_FLAG = TRUE
            EXIT DIALOG

   END DIALOG 
  END IF

   IF INT_FLAG THEN 
       LET INT_FLAG = FALSE
       LET g_wc = null
       RETURN 
   END IF 
   IF cl_null(g_wc2) THEN LET g_wc = " 1=1 " END IF
 
END FUNCTION

FUNCTION i5101_show()
DEFINE  l_ima02   LIKE ima_file.ima02
DEFINE  l_ima021  LIKE ima_file.ima021
   
   CALL i5101_b_fill(g_wc,g_wc2)
   CALL cl_show_fld_cont()
END FUNCTION

FUNCTION i5101_b_fill(p_wc,p_wc2)
DEFINE p_wc2         STRING
DEFINE p_wc          STRING
DEFINE l_sfs05_sum   LIKE sfs_file.sfs05
DEFINE l_sfs04       LIKE sfs_file.sfs04
DEFINE l_sfs07       LIKE sfs_file.sfs07
DEFINE l_sfs08       LIKE sfs_file.sfs08

   IF cl_null(p_wc2) OR p_wc2=" 1=1" THEN 
      LET g_sql = " SELECT ibj02,ima02,ima021,ibj03,ibj04,ibj05 ",
                  "   FROM ibj_file ",
                  "  LEFT JOIN ima_file ON ibj02=ima01 ",
                  "  WHERE ibj01='2' AND ",
                  "        ibj10='N' AND ",p_wc,
                  "  ORDER BY ibj02 "
   ELSE
      LET g_sql = " SELECT DISTINCT ibj02,ima02,ima021,ibj03,ibj04,ibj05 ",
                  "   FROM ibj_file ",
                  "  LEFT JOIN ima_file ON ibj02=ima01 ",
                  "  INNER JOIN sfs_file ON sfs01=ibj06 AND",
                  "                         sfs04 = ibj02 AND ",
                  "                         sfs07 = ibj03 AND ",
                  "                         sfs08 = ibj04 ",               
                  "  WHERE ibj01='2' AND ",
                  "        ibj10='N' AND ",p_wc," AND ",p_wc2,
                  "  ORDER BY ibj02 "
   END IF               
   PREPARE i5101_pb FROM g_sql
   DECLARE ibj_cs CURSOR FOR i5101_pb
 
   CALL g_ibj.CLEAR()
   CALL g_sfs05.CLEAR()
   LET g_cnt = 1
 
   FOREACH ibj_cs INTO g_ibj[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
      #DEV-D30019 add str-------------
       IF g_argv2 = 'Y' THEN
          SELECT sfs04,sfs07,sfs08,SUM(sfs05) 
            INTO l_sfs04,l_sfs07,l_sfs08,l_sfs05_sum
            FROM sfs_file 
           WHERE sfs01= g_argv1 AND
                 sfs04 = g_ibj[g_cnt].ibj02 
           GROUP BY sfs04,sfs07,sfs08 
           ORDER BY sfs04,sfs07,sfs08
       ELSE
      #DEV-D30019 add end-------------
          SELECT sfs04,sfs07,sfs08,SUM(sfs05) 
            INTO l_sfs04,l_sfs07,l_sfs08,l_sfs05_sum
            FROM sfs_file 
           WHERE sfs01= g_argv1 AND
                 sfs04 = g_ibj[g_cnt].ibj02 AND
                 sfs07 = g_ibj[g_cnt].ibj03 AND
                 sfs08 = g_ibj[g_cnt].ibj04
           GROUP BY sfs04,sfs07,sfs08 
           ORDER BY sfs04,sfs07,sfs08
       END IF                      #DEV-D30019 add

       LET g_ibj[g_cnt].sfs05_sum = l_sfs05_sum

       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF

   END FOREACH
   CALL g_ibj.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   LET g_cnt = 0
   LET l_row_count2 = g_rec_b        #DEV-D30019 add
END FUNCTION

FUNCTION i5101_d_fill(p_ibj06,p_ibj02,p_ibj03,p_ibj04)
DEFINE p_ibj02  LIKE  ibj_file.ibj02
DEFINE p_ibj03  LIKE  ibj_file.ibj03
DEFINE p_ibj04  LIKE  ibj_file.ibj04
DEFINE p_ibj06  LIKE  ibj_file.ibj06
   
  #DEV-D30019 add str-----------------
   IF g_argv2 = 'Y' THEN
      LET g_sql = "SELECT sfs04, sfs02, sfs03, sfs07, sfs08, sfs05",   #DEV-D30019 add
               "  FROM sfs_file ",
               " WHERE sfs01= '",p_ibj06,"' AND ",
               " sfs04 = '",p_ibj02,"' ",
               " ORDER BY sfs02 "
   ELSE 
  #DEV-D30019 add end-----------------
      LET g_sql = "SELECT sfs04, sfs02, sfs03, sfs07, sfs08, sfs05",   #DEV-D30019 add
               "  FROM sfs_file ",
               " WHERE sfs01= '",p_ibj06,"' AND ",
               " sfs04 = '",p_ibj02,"' AND ",
               " sfs07 = '",p_ibj03,"' AND ",
               " sfs08 = '",p_ibj04,"' ",
               " ORDER BY sfs02 "
   END IF         
   PREPARE i5101_pb_d FROM g_sql
   DECLARE sfs_cs CURSOR FOR i5101_pb_d
 
   CALL g_sfs.clear()
   LET g_cnt = 1
 
   FOREACH sfs_cs INTO g_sfs[g_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_sfs[g_cnt].sfs05_2 = 0 
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_sfs.deleteElement(g_cnt)
   LET g_rec_b2=g_cnt-1
   LET g_cnt = 0
   LET l_row_count = g_rec_b2
   LET l_ibj_row = l_ac

END FUNCTION
  
FUNCTION i5101_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    
   DEFINE   l_sql  STRING
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel,close", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
    
      DISPLAY ARRAY g_ibj TO s_ibj.* ATTRIBUTE(COUNT=g_rec_b)
          BEFORE DISPLAY 
            IF l_ac > 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF 
            
          BEFORE ROW 
             LET l_ac  = ARR_CURR()
             IF l_ac  > 0 THEN
                CALL i5101_d_fill(g_argv1,g_ibj[l_ac].ibj02,g_ibj[l_ac].ibj03,g_ibj[l_ac].ibj04)
             END IF 
             CALL cl_show_fld_cont()
      END DISPLAY 
      
      DISPLAY ARRAY g_sfs TO s_sfs.* ATTRIBUTE(COUNT=g_rec_b2)
          BEFORE DISPLAY 
            IF l_ac2 > 0 THEN
               CALL fgl_set_arr_curr(l_ac2)
            END IF 
            
          BEFORE ROW 
             LET l_ac2  = ARR_CURR()
             CALL cl_show_fld_cont()
      END DISPLAY 
      
      BEFORE DIALOG 
         IF l_ac > 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF 


    #ON ACTION query
    #   LET g_action_choice="query"
    #   EXIT DIALOG

      ON ACTION HELP
         LET g_action_choice="help"
         EXIT DIALOG 

      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   
         LET g_action_choice = 'locale'
         EXIT DIALOG 

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG 
        
      ON ACTION detail
         LET g_action_choice = 'detail'
         EXIT DIALOG 
 
      ON ACTION accept
         LET g_action_choice = 'detail'
         EXIT DIALOG 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION controls                          
         CALL cl_set_head_visible("","AUTO")
 
      ON ACTION CANCEL
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DIALOG

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      AFTER DIALOG
         CONTINUE DIALOG
   END DIALOG 
   CALL cl_set_act_visible("accept,cancel,close", TRUE)
END FUNCTION

FUNCTION i5101_b()
  DEFINE l_flag          LIKE type_file.chr1
  DEFINE l_ac            LIKE type_file.num5
  DEFINE p_cmd           LIKE type_file.chr1    #處理狀態
  DEFINE l_n             LIKE type_file.num5    #檢查重複用
  DEFINE l_lock_sw       LIKE type_file.chr1
  DEFINE l_ac_t          LIKE type_file.num5    #未取消的ARRAY CNT
  DEFINE l_sfs04         LIKE sfs_file.sfs04
  DEFINE l_sfs07         LIKE sfs_file.sfs07
  DEFINE l_sfs08         LIKE sfs_file.sfs08
 #DEFINE l_tot_sfs05_2   LIKE sfs_file.sfs05

    LET g_action_choice = ""
    LET l_flag = 'N'

    IF s_shut(0) THEN
       RETURN
    END IF

    IF g_argv1 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF

    INPUT ARRAY g_sfs WITHOUT DEFAULTS FROM s_sfs.*
     ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED,
            INSERT ROW=FALSE,DELETE ROW=TRUE,APPEND ROW=FALSE)

    BEFORE ROW
       LET p_cmd = ''
       LET l_ac = ARR_CURR()
       LET l_lock_sw = 'N'
       LET l_n  = ARR_COUNT()
   #DEV-D30019 mark str------------------
   #   IF g_rec_b >= l_ac THEN
   #      LET p_cmd='u'
   #   
   #      LET g_forupd_sql = "SELECT sfs04,sfs02,sfs03,sfs07,sfs08,sfs05 ",  #DEV-D30019 add sfs07,sfs08
   #                         "FROM sfs_file WHERE  ",
   #                         " sfs01=? AND sfs02=? ",
   #                         " FOR UPDATE "
   #      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   #      DECLARE i5101_bcl CURSOR FROM g_forupd_sql
   #      
   #      LET g_sfs_t[l_ac].* = g_sfs[l_ac].*
   #      BEGIN WORK
   #      OPEN i5101_bcl USING  g_argv1,g_sfs[l_ac].sfs02
   #      IF STATUS THEN
   #         CALL cl_err("OPEN i5101_bcl:", STATUS, 1)
   #         LET l_lock_sw = "Y"
   #      ELSE
   #         FETCH i5101_bcl INTO g_sfs[l_ac].*
   #         IF SQLCA.sqlcode THEN
   #            CALL cl_err(g_sfs[l_ac].sfs04,SQLCA.sqlcode,1)
   #            LET l_lock_sw = "Y"
   #         END IF
   #      END IF
   #      CALL cl_show_fld_cont()
   #   END IF
   #DEV-D30019 mark end------------------

   AFTER FIELD sfs05_2
      IF NOT cl_null(g_sfs[l_ac].sfs05_2) AND g_sfs[l_ac].sfs05_2 > 0 THEN
         IF g_sfs[l_ac].sfs05_2 < 0 THEN   #發料量不可為負
            CALL cl_err('','asf-037',1)
            LET g_sfs[l_ac].sfs05_2 = 0
            NEXT FIELD sfs05_2
         END IF
      END IF

  #DEV-D30019 add str-------------- 
   AFTER FIELD sfs07
      IF NOT cl_null(g_sfs[l_ac].sfs07) THEN
         CALL i5101_chk_sfs07()
         IF l_chk_sfs07 = 'N' THEN
            NEXT FIELD sfs07
         END IF 
      END IF

   AFTER FIELD sfs08
     IF NOT cl_null(g_sfs[l_ac].sfs08) THEN
        CALL i5101_chk_sfs08()
        IF l_chk_sfs08 = 'N' THEN
           NEXT FIELD sfs08
        END IF 
     END IF
#DEV-D30019 add end-------------- 
  
   ON ROW CHANGE
      LET l_flag = 'Y' #判斷是否有異動資料

   AFTER INPUT
      LET l_ac = ARR_CURR()
      LET l_ac_t = l_ac
      IF INT_FLAG THEN
         CALL cl_err('',9001,0)
         LET INT_FLAG = 0
         IF p_cmd = 'u' THEN
            LET g_sfs[l_ac].* = g_sfs_t[l_ac].*
         END IF
        #CLOSE i5101_bcl      #DEV-D30019 add
        #ROLLBACK WORK        #DEV-D30019 add
         EXIT INPUT
      END IF
     #DEV-D30019 add str----------
      CALL i5101_chk_sfs05_2()
      IF l_chk_sfs05_2 = 'N' THEN
         NEXT FIELD sfs05_2
      END IF
      CALL i5101_chk_warahouse()
      IF l_chk_warahouse = 'N' THEN
         NEXT FIELD sfs07
      END IF
     #DEV-D30019 add end----------
      IF l_flag = 'Y' THEN
         IF cl_confirm2('asf1045',g_argv1) THEN
           #DEV-D30019 add str------------
            IF l_chk_warahouse = 'Z' THEN
               CALL cl_err('','asf1052',1)
               RETURN 
            END IF 
           #DEV-D30019 add end------------
            LET g_success = 'Y'
            LET g_cnt = 1
            FOREACH sfs_cs INTO g_sfs[g_cnt].* 
               UPDATE sfs_file 
                  SET sfs05 = g_sfs[g_cnt].sfs05_2,
                      sfs07 = g_sfs[g_cnt].sfs07,     #DEV-D30019 add
                      sfs08 = g_sfs[g_cnt].sfs08      #DEV-D30019 add
                WHERE sfs01 = g_argv1 AND
                      sfs02 = g_sfs[g_cnt].sfs02
       
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN	
                  CALL cl_err3("upd","sfs_file","項次:sfs02","",SQLCA.SQLCODE,"","upd sfs05",1)  	
                  LET g_success = 'N'	
                  ROLLBACK WORK	
                  EXIT FOREACH	
               ELSE
                  LET l_sfs04 = NULL
                  LET l_sfs07 = NULL 
                  LET l_sfs08 = NULL

                  SELECT sfs04,sfs07,sfs08
                    INTO l_sfs04,l_sfs07,l_sfs08
                    FROM sfs_file
                   WHERE sfs01 = g_argv1 AND
                         sfs02 = g_sfs[g_cnt].sfs02

                  UPDATE ibj_file
                     SET ibj10 = 'Y'
                   WHERE ibj01 = '2' AND
                         ibj02 = l_sfs04 AND
                         ibj03 = l_sfs07 AND
                         ibj04 = l_sfs08

                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                     CALL cl_err3("upd","ibj_file","","",SQLCA.SQLCODE,"","upd ibj10",1)
                     LET g_success = 'N'
                     ROLLBACK WORK
                     EXIT FOREACH
                  ELSE
                     LET g_cnt = g_cnt + 1
                     IF g_cnt > g_max_rec THEN
                        CALL cl_err( '', 9035, 0 )
                        EXIT FOREACH
                     END IF
                  END IF
               END IF	
            END FOREACH		
         ELSE
            IF p_cmd = 'u' THEN
               LET g_sfs[l_ac].* = g_sfs_t[l_ac].*
            END IF
           #CLOSE i5101_bcl     #DEV-D30019 add
           #ROLLBACK WORK       #DEV-D30019 add
            EXIT INPUT
         END IF
      END IF
     #CLOSE i5101_bcl           #DEV-D30019 add
      IF g_success = 'Y' THEN
         COMMIT WORK
         CALL i5101_q()
         CALL cl_err('','asf1046',1)
      END IF

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()

      ON ACTION CONTROLG
          CALL cl_cmdask()

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

    END INPUT
    IF INT_FLAG THEN
       LET INT_FLAG = FALSE
    END IF
END FUNCTION
#DEV-D20001 add end----------

#DEV-D30019 add str----------
FUNCTION i5101_chk_sfs05_2()
   DEFINE l_tot_sfs05_2   LIKE sfs_file.sfs05
   DEFINE l_ibj03         LIKE ibj_file.ibj03
   DEFINE l_ibj04         LIKE ibj_file.ibj04
   DEFINE l_i             LIKE type_file.num5
   DEFINE l_chk_flag      LIKE type_file.chr1

   LET l_chk_sfs05_2 = 'Y'

   IF g_argv2 = 'Y' THEN
     #控卡欲調整數量等於其倉庫儲位原實發量
      FOR l_i = 1 to l_row_count2
         LET l_ibj03 = ''
         LET l_ibj04 = ''
         LET l_ibj03 = g_ibj[l_i].ibj03
         LET l_ibj04 = g_ibj[l_i].ibj04
         LET l_tot_sfs05_2 = 0
        
         FOR g_cnt = 1 TO l_row_count
             IF g_sfs[g_cnt].sfs07 = l_ibj03 AND g_sfs[g_cnt].sfs08 = l_ibj04 THEN
                LET l_chk_flag = 'Y'
                LET l_tot_sfs05_2 = l_tot_sfs05_2 + g_sfs[g_cnt].sfs05_2
                IF g_cnt > l_row_count THEN
                   CALL cl_err( '', 9035, 0 )
                END IF
             END IF
         END FOR 
         IF l_tot_sfs05_2 <> g_ibj[l_i].ibj05 AND l_tot_sfs05_2 > 0 THEN
            CALL cl_err('','asf1047',1)
            LET l_chk_sfs05_2 = 'N'
            EXIT FOR
         END IF
      END FOR
   ELSE
     #控卡欲調整數量等於原實發量
      LET l_tot_sfs05_2 = 0
      FOR g_cnt = 1 TO l_row_count
          LET l_tot_sfs05_2 = l_tot_sfs05_2 + g_sfs[g_cnt].sfs05_2

          IF g_cnt > l_row_count THEN
             CALL cl_err( '', 9035, 0 )
          END IF
      END FOR
      IF l_tot_sfs05_2 <> g_ibj[l_ibj_row].ibj05 AND l_tot_sfs05_2 > 0 THEN
         CALL cl_err('','asf1047',1)
         LET l_chk_sfs05_2 = 'N'
      END IF
   END IF
END FUNCTION

FUNCTION i5101_chk_sfs07()
   DEFINE l_ibj03         LIKE ibj_file.ibj03
   DEFINE l_i             LIKE type_file.num5

   LET l_ac  = ARR_CURR()
   LET l_chk_sfs07 = 'N'

   FOR l_i = 1 TO l_row_count2
      IF g_sfs[l_ac].sfs07 = g_ibj[l_i].ibj03 THEN
         LET l_chk_sfs07 = 'Y'
      END IF
   END FOR
   IF l_chk_sfs07 = 'N' THEN
      LET g_sfs[l_ac].sfs07 = ''
      CALL cl_err('','asf1050',1)
   END IF
END FUNCTION 

FUNCTION i5101_chk_sfs08()
   DEFINE l_ibj04         LIKE ibj_file.ibj04
   DEFINE l_i             LIKE type_file.num5

   LET l_ac  = ARR_CURR()
   LET l_chk_sfs08 = 'N'

   FOR l_i = 1 TO l_row_count2
      IF g_sfs[l_ac].sfs08 = g_ibj[l_i].ibj04 THEN
         LET l_chk_sfs08 = 'Y'
      END IF
   END FOR
   IF l_chk_sfs08 = 'N' THEN
      LET g_sfs[l_ac].sfs08 = ' '
      CALL cl_err('','asf1051',1)
   END IF
END FUNCTION 

FUNCTION i5101_chk_warahouse()
   DEFINE l_ibj03         LIKE ibj_file.ibj03
   DEFINE l_ibj04         LIKE ibj_file.ibj04
   DEFINE l_i             LIKE type_file.num5
   DEFINE l_j             LIKE type_file.num5
   DEFINE l_str           LIKE type_file.chr50
   DEFINE l_tot           LIKE type_file.num5

   LET l_chk_warahouse = 'N'
   LET l_str = ''
   LET l_tot = 0

   FOR l_i = 1 TO l_row_count
      FOR l_j = 1 TO l_row_count2
         IF g_sfs[l_i].sfs07 = g_ibj[l_j].ibj03 AND g_sfs[l_i].sfs08 = g_ibj[l_j].ibj04 THEN
            LET l_chk_warahouse = 'Y'
            LET l_tot = l_tot + g_sfs[l_i].sfs05_2
         END IF
      END FOR
      IF l_chk_warahouse = 'N' THEN
         LET l_str = '倉庫:',g_sfs[l_i].sfs07,' 儲位:',g_sfs[l_i].sfs08,' '
         CALL cl_err(l_str,'asf1049',1)
         EXIT FOR
      END IF
      IF l_tot = 0 THEN
         LET l_chk_warahouse = 'Z'
      END IF
   END FOR
END FUNCTION 

#DEV-D30019 add end----------
#DEV-D30026 add
