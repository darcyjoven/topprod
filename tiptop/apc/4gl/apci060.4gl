# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: "apci060.4gl"
# Descriptions...: POS用戶資料維護作業
# Date & Author..: 10/03/31  BY huangrh 
# Modify.........: No:TQC-A30156 10/06/02 By Cockroach 有效碼默認為N
# Modify.........: No:FUN-A80148 10/08/31 By shaoyong  開啟時接收參數, 來限制查詢資料的範圍.
# Modify.........: No:FUN-AA0064 10/10/24 By johnson 同步到32區.
# Modify.........: No:FUN-AC0022 10/12/08 By suncx1 如果g_argv1不為空，則ryi02應開窗只能查詢本營運中心員工
# Modify.........: No:FUN-B30168 11/03/25 By suncx1 新增使用者權限維護單身，對邏輯做相應調整
# Modify.........: No:FUN-B40071 11/04/28 by jason 已傳POS否狀態調整
# Modify.........: No:FUN-B60111 11/06/22 By huangtao 操作等級在新增或者更改時候預設最低折扣
# Modify.........: No:FUN-B80029 11/08/04 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-B70075 11/10/26 By nanbing 添加已傳POS否的狀態4.修改中，不下傳
# Modify.........: No:FUN-C40084 12/04/28 By baogc 添加權限編號欄位(ryi07)
# Modify.........: No:FUN-C40084 12/05/29 By nanbing 添加設置密碼ACTION
# Modify.........: No:FUN-C50036 12/05/31 By yangxf 如果aza88=Y， 已传pos否<>'1'，更改时把key值noentry
# Modify.........: No:FUN-C60050 12/07/09 By yangxf 调整画面及相关逻辑
# Modify.........: No:FUN-D20017 13/02/05 By pauline 當資料失效並且為已下傳時開放可修改職能
# Modify.........: No:FUN-D20038 13/02/18 By dongsz POS使用者權限相關邏輯調整
# Modify.........: No:FUN-D30033 13/04/12 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

#FUN-A40005---add 
#FUN-C40084 sta
IMPORT JAVA java.security.MessageDigest
IMPORT JAVA java.lang.String
IMPORT JAVA java.lang.Byte
IMPORT JAVA java.lang.Integer
#FUN-C40084 end
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ryi   DYNAMIC ARRAY OF RECORD 
                ryi01       LIKE ryi_file.ryi01,

                ryi02       LIKE ryi_file.ryi02,
                gen02       LIKE gen_file.gen02,
                gen03       LIKE gen_file.gen03,
                gem02       LIKE gem_file.gem02,
                gen07       LIKE gen_file.gen07,
                azp02       LIKE azp_file.azp02,
                ryi03       LIKE ryi_file.ryi03,
                ryi04       LIKE ryi_file.ryi04,
               #FUN-C40084 Add&Mark Begin ---
               #ryi05       LIKE ryi_file.ryi05,
               #ryi06       LIKE ryi_file.ryi06,
                ryi07       LIKE ryi_file.ryi07,
                ryi07_desc  LIKE ryr_file.ryr02,
               #FUN-C40084 Add&Mark End -----
                ryipos      LIKE ryi_file.ryipos,
                ryiacti     LIKE ryi_file.ryiacti
                        END RECORD,
        g_ryi_t RECORD
                ryi01       LIKE ryi_file.ryi01,
                ryi02       LIKE ryi_file.ryi02,
                gen02       LIKE gen_file.gen02,
                gen03       LIKE gen_file.gen03,
                gem02       LIKE gem_file.gem02,
                gen07       LIKE gen_file.gen07,
                azp02       LIKE azp_file.azp02,
                ryi03       LIKE ryi_file.ryi03,
                ryi04       LIKE ryi_file.ryi04,
               #FUN-C40084 Add&Mark Begin ---
               #ryi05       LIKE ryi_file.ryi05,
               #ryi06       LIKE ryi_file.ryi06,
                ryi07       LIKE ryi_file.ryi07,
                ryi07_desc  LIKE ryr_file.ryr02,
               #FUN-C40084 Add&Mark End -----
                ryipos      LIKE ryi_file.ryipos,
                ryiacti     LIKE ryi_file.ryiacti
                        END RECORD
#FUN-B30168 ADD begin----------------------------
DEFINE g_ryo   DYNAMIC ARRAY OF RECORD 
                ryo02       LIKE ryo_file.ryo02,
                azw08       LIKE azw_file.azw08,
                ryoacti     LIKE ryo_file.ryoacti
                        END RECORD,
        g_ryo_t RECORD
                ryo02       LIKE ryo_file.ryo02,
                azw08       LIKE azw_file.azw08,
                ryoacti     LIKE ryo_file.ryoacti
                        END RECORD
DEFINE g_cmd    STRING
#FUN-B30168 ADD end--------------------------------
DEFINE  g_sql    STRING,
        g_wc2    STRING,
        g_wc3    STRING,   #FUN-B30168
        g_rec_b  LIKE type_file.num5,
        g_rec_b1 LIKE type_file.num5,   #FUN-B30168 ADD 第二單身筆數
        l_ac     LIKE type_file.num5,
        l_ac1    LIKE type_file.num5    #FUN-B30168 ADD 第二單身位置
DEFINE  p_row,p_col     LIKE type_file.num5
DEFINE  g_forupd_sql    STRING
DEFINE  g_before_input_done     LIKE type_file.num5
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  g_argv1         LIKE gen_file.gen07                        #FUN-A80148--add--
DEFINE  g_action_flag   STRING   #FUN-B30168 記錄焦點在第一單身還是第二單身
 
MAIN
   OPTIONS                            
      INPUT NO WRAP
   DEFER INTERRUPT                      
 
   LET g_argv1 = ARG_VAL(1)           #FUN-A80148--add--

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APC")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1)      
        RETURNING g_time   
          
   LET p_row = 4 LET p_col = 10
   OPEN WINDOW i060_w AT p_row,p_col WITH FORM "apc/42f/apci060"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("ryipos",g_aza.aza88 = 'Y')       #FUN-D20038 add

   LET g_wc2 = " 1=1"
   LET g_wc3 = " 1=1"   #FUN-B30168
   #CALL i060_b_fill(g_wc2)   #FUN-B30168 mark
   CALL i060_b_fill(g_wc2,g_wc3)
   CALL i060_b1_fill(g_wc3)  #FUN-B30168 
   CALL i060_menu()
   CLOSE WINDOW i060_w                   
   CALL  cl_used(g_prog,g_time,2)        
        RETURNING g_time    
END MAIN
 
FUNCTION i060_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #FUN-B30168 ADD BEGIN-------------------------
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_ryi TO s_ryi.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE ROW
            IF g_action_flag='' OR g_action_flag IS NULL THEN
               IF g_cmd = '' OR g_cmd IS NULL THEN
                  LET l_ac = ARR_CURR()
               ELSE
                  LET g_cmd = ''
               END IF
            ELSE
               LET g_action_flag=''
            END IF
            CALL fgl_set_arr_curr(l_ac)
            CALL i060_b1_fill(g_wc3)
            CALL cl_show_fld_cont()                   
            
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
         ON ACTION detail
            LET g_action_choice="detail"
            LET l_ac = 1
            LET g_action_flag=''
            EXIT DIALOG
         ON ACTION output
           LET g_action_choice="output"
            EXIT DIALOG
         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG
         
         ON ACTION locale
            CALL cl_dynamic_locale()
             CALL cl_show_fld_cont()                  
         
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG
         #FUN-C40084 sta
         ON ACTION passwd
            LET g_action_choice="passwd"
            EXIT DIALOG
         ON ACTION resetpasswd
            LET g_action_choice="resetpasswd"
            EXIT DIALOG
         #FUN-C40084 end  
         
         ##########################################################################
         # Standard 4ad ACTION
         ##########################################################################
         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG
         
         ON ACTION accept
            LET g_action_choice="detail"
            LET l_ac = ARR_CURR()
            LET g_action_flag=''
            EXIT DIALOG
         
         ON ACTION cancel
            LET INT_FLAG=FALSE 		
            LET g_action_choice="exit"
            EXIT DIALOG
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
         
         ON ACTION about         
            CALL cl_about()     
         ON ACTION related_document 
            LET g_action_choice="related_document"
            EXIT DIALOG
         
               
         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG
         AFTER DISPLAY
            CONTINUE DIALOG
      END DISPLAY
      
      DISPLAY ARRAY g_ryo TO s_ryo.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
            
         ON ACTION query
            LET g_action_choice="query"
            EXIT DIALOG
         ON ACTION detail
            LET g_action_choice="detail"
            LET l_ac1 = 1
            LET g_action_flag='p_detail'
            EXIT DIALOG
         ON ACTION output
           LET g_action_choice="output"
            EXIT DIALOG
         ON ACTION help
            LET g_action_choice="help"
            EXIT DIALOG
         
         ON ACTION locale
            CALL cl_dynamic_locale()
             CALL cl_show_fld_cont()                  
         
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG
         #FUN-C40084 sta
         ON ACTION passwd
            LET g_action_choice="passwd"
            EXIT DIALOG
         ON ACTION resetpasswd
            LET g_action_choice="resetpasswd"
            EXIT DIALOG   
         #FUN-C40084 end 
         
         ##########################################################################
         # Standard 4ad ACTION
         ##########################################################################
         ON ACTION controlg
            LET g_action_choice="controlg"
            EXIT DIALOG
         
         ON ACTION accept
            LET g_action_choice="detail"
            LET l_ac1 = ARR_CURR()
            LET g_action_flag='p_detail'
            EXIT DIALOG
         
         ON ACTION cancel
            LET INT_FLAG=FALSE 		
            LET g_action_choice="exit"
            EXIT DIALOG
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE DIALOG
         
         ON ACTION about         
            CALL cl_about()     
         ON ACTION related_document 
            LET g_action_choice="related_document"
            EXIT DIALOG
         
               
         ON ACTION exporttoexcel
            LET g_action_choice = 'exporttoexcel'
            EXIT DIALOG
         AFTER DISPLAY
            CONTINUE DIALOG
      END DISPLAY
   END DIALOG
   #FUN-B30168 ADD END---------------------------
   
   #FUN-B30168 mark begin-------------------------
   #DISPLAY ARRAY g_ryi TO s_ryi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
   #   BEFORE ROW
   #      LET l_ac = ARR_CURR()
   #   CALL cl_show_fld_cont()                   
   #   
   #   ON ACTION query
   #      LET g_action_choice="query"
   #      EXIT DISPLAY
   #   ON ACTION detail
   #      LET g_action_choice="detail"
   #      LET l_ac = 1
   #      EXIT DISPLAY
   #   ON ACTION output
   #     LET g_action_choice="output"
   #      EXIT DISPLAY
   #   ON ACTION help
   #      LET g_action_choice="help"
   #      EXIT DISPLAY
   #
   #   ON ACTION locale
   #      CALL cl_dynamic_locale()
   #       CALL cl_show_fld_cont()                  
   #
   #   ON ACTION exit
   #      LET g_action_choice="exit"
   #      EXIT DISPLAY
   #
   #   ##########################################################################
   #   # Standard 4ad ACTION
   #   ##########################################################################
   #   ON ACTION controlg
   #      LET g_action_choice="controlg"
   #      EXIT DISPLAY
   #
   #   ON ACTION accept
   #      LET g_action_choice="detail"
   #      LET l_ac = ARR_CURR()
   #      EXIT DISPLAY
   #
   #   ON ACTION cancel
   #      LET INT_FLAG=FALSE 		
   #      LET g_action_choice="exit"
   #      EXIT DISPLAY
   #
   #   ON IDLE g_idle_seconds
   #      CALL cl_on_idle()
   #      CONTINUE DISPLAY
   #
   #   ON ACTION about         
   #      CALL cl_about()     
   #   ON ACTION related_document 
   #      LET g_action_choice="related_document"
   #      EXIT DISPLAY
   #
   #         
   #   ON ACTION exporttoexcel
   #      LET g_action_choice = 'exporttoexcel'
   #      EXIT DISPLAY
   #   AFTER DISPLAY
   #      CONTINUE DISPLAY
   #
   #END DISPLAY
   #FUN-B30168 mark end---------------------------
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i060_menu()
 
   WHILE TRUE
      CALL i060_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i060_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               #CALL i060_b()  #FUN-B30168 mark
               #FUN-B30168 add begin------
               IF g_action_flag = 'p_detail' THEN
                  CALL i060_b1()
               ELSE
                 	CALL i060_b()
               END IF
               #FUN-B30168 add end--------
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i060_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()       
          WHEN "related_document" 
            IF cl_chk_act_auth() AND l_ac != 0 THEN 
               IF g_ryi[l_ac].ryi01 IS NOT NULL THEN
                  LET g_doc.column1 = "ryi01"
                  LET g_doc.value1 = g_ryi[l_ac].ryi01
                  CALL cl_doc()
               END IF
            END IF

         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_ryi),'','')
             END IF
        #FUN-C40084 sta
         WHEN "passwd"
            IF cl_chk_act_auth() THEN
                CALL i060_passwd(g_ryi[l_ac].ryi01,'S',FALSE)
                CALL i060_b_fill(" 1=1"," 1=1")
                CALL i060_b1_fill(" 1=1")
            END IF 
         WHEN "resetpasswd"
            IF cl_chk_act_auth() THEN
                CALL i060_passwd(g_ryi[l_ac].ryi01,'R',FALSE)
                CALL i060_b_fill(" 1=1"," 1=1")
                CALL i060_b1_fill(" 1=1")
            END IF    
         #FUN-C40084 end         
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i060_q()
 
   CALL i060_b_askkey()
   
END FUNCTION
 
FUNCTION i060_b_askkey()
 
    CLEAR FORM
  
   #FUN-C40084 Mark&Add Begin ---
   #CONSTRUCT g_wc2 ON ryi01,ryi02,ryi04,ryi05,ryi06
   #                FROM s_ryi[1].ryi01,s_ryi[1].ryi02,s_ryi[1].ryi04,
   #                    s_ryi[1].ryi05,s_ryi[1].ryi06

    CONSTRUCT g_wc2 ON ryi01,ryi02,ryi03,ryi04,ryi07,ryipos,ryiacti
                  FROM s_ryi[1].ryi01,s_ryi[1].ryi02,s_ryi[1].ryi03,s_ryi[1].ryi04,
                       s_ryi[1].ryi07,s_ryi[1].ryipos,s_ryi[1].ryiacti
   #FUN-C40084 Mark&Add End -----
 
        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
        ON ACTION about         
          CALL cl_about()      
 
        ON ACTION help         
          CALL cl_show_help()
 
        ON ACTION controlg   
          CALL cl_cmdask() 
 
        ON ACTION qbe_select                     
     	  CALL cl_qbe_select()
          
        ON ACTION qbe_save                        
          CALL cl_qbe_save()
        ON ACTION controlp
          CASE
             WHEN INFIELD(ryi02)
                CALL cl_init_qry_var()
                LET g_qryparam.state="c"
                #LET g_qryparam.form = "q_gen"   #FUN-AC0022 mark
                #FUN-AC0022 -add--begin---------------------------
                IF cl_null(g_argv1) THEN
                   LET g_qryparam.form = "q_gen"
                ELSE
                   LET g_qryparam.form = "q_gen01"
                   LET g_qryparam.arg1 = g_argv1
                END IF
                #FUN-AC0022 -add---end----------------------------
                LET g_qryparam.default1 =g_ryi[1].ryi02
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ryi02
                NEXT FIELD ryi02

            #FUN-C40084 Add Begin ---
            #權限編號開窗
             WHEN INFIELD(ryi07) 
                CALL cl_init_qry_var()
                LET g_qryparam.state="c"
                LET g_qryparam.form = "q_ryi07"
                LET g_qryparam.default1 =g_ryi[1].ryi07
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ryi07
                NEXT FIELD ryi07
            #FUN-C40084 Add End -----
             OTHERWISE EXIT CASE
         END CASE

		
    END CONSTRUCT
    LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('ryiuser', 'ryigrup') #FUN-980030
    
    IF INT_FLAG THEN
       LET INT_FLAG = 0 
       RETURN
    END IF
    
    #FUN-B30168 add begin--------------------------------
    CONSTRUCT g_wc3 ON ryo02,ryoacti FROM s_ryo[1].ryo02,s_ryo[1].ryoacti
                    
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT

       ON ACTION about
          CALL cl_about()

       ON ACTION help
          CALL cl_show_help()

       ON ACTION controlg
          CALL cl_cmdask()

       ON ACTION qbe_select
          CALL cl_qbe_select()

       ON ACTION qbe_save
          CALL cl_qbe_save()
       ON ACTION controlp
          CASE
             WHEN INFIELD(ryo02)
                CALL cl_init_qry_var()
                LET g_qryparam.state="c"
                LET g_qryparam.form = "q_azw08"
                LET g_qryparam.default1 =g_ryo[1].ryo02
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ryo02
                NEXT FIELD ryo02
             OTHERWISE EXIT CASE
          END CASE
    END CONSTRUCT
    LET g_wc3 = g_wc3 CLIPPED
    
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    #FUN-B30168 add end---------------------------------- 
    #CALL i060_b_fill(g_wc2)   #FUN-B30168 mark
    CALL i060_b_fill(g_wc2,g_wc3)
    
END FUNCTION
 
#FUNCTION i060_b_fill(p_wc2)   #FUN-B30168 mark
FUNCTION i060_b_fill(p_wc2,p_wc3)              
DEFINE   p_wc2       STRING   
DEFINE   p_wc3       STRING     #FUN-B30168  
 
#FUN-A80148--begin--
#   LET g_sql = "SELECT ryi01,ryi02,'','','','','',ryi03,ryi04,ryi05,ryi06,ryipos,ryiacti FROM ryi_file ",
#               " WHERE ",p_wc2 CLIPPED
    IF not cl_null(g_argv1) THEN
       IF p_wc3 = " 1=1" THEN  #FUN-B30168 add
         #FUN-C40084 Mark&Add Begin ---
         #LET g_sql = "SELECT ryi01,ryi02,'','','','','',ryi03,ryi04,ryi05,ryi06,ryipos,ryiacti FROM ryi_file ",  
         #LET g_sql = "SELECT ryi01,ryi02,'','','','','',ryi03,ryi04,ryi07,'',ryipos,ryiacti FROM ryi_file ",                   #FUN-C60050 mark
          LET g_sql = "SELECT DISTINCT ryi01,ryi02,'','','','','',ryi03,ryi04,ryi07,'',ryipos,ryiacti FROM ryi_file ",          #FUN-C60050 add 
         #FUN-C40084 Mark&Add End -----
                      "  LEFT JOIN gen_file ON ryi02 = gen01 ",  
                      " WHERE ",p_wc2 CLIPPED,
                      "   AND gen07 = '",g_argv1,"' "
       ELSE
       	  #FUN-B30168 add begin-------------------
         #FUN-C40084 Mark&Add Begin ---
         #LET g_sql = "SELECT ryi01,ryi02,'','','','','',ryi03,ryi04,ryi05,ryi06,ryipos,ryiacti FROM ryi_file ",  
         #LET g_sql = "SELECT ryi01,ryi02,'','','','','',ryi03,ryi04,ryi07,'',ryipos,ryiacti FROM ryi_file ",             #FUN-C60050 mark
          LET g_sql = "SELECT DISTINCT ryi01,ryi02,'','','','','',ryi03,ryi04,ryi07,'',ryipos,ryiacti FROM ryi_file ",    #FUN-C60050 add
         #FUN-C40084 Mark&Add End -----
                      "  LEFT JOIN gen_file ON ryi02 = gen01,ryo_file ",  
                      " WHERE ",p_wc2 CLIPPED,
                      "   AND gen07 = '",g_argv1,"' ",
                      "   AND ryo01 = ryi01 AND ",p_wc3 CLIPPED
          #FUN-B30168 add end---------------------
       END IF
    ELSE
    	 IF p_wc3 = " 1=1" THEN  #FUN-B30168 add
           #FUN-C40084 Mark&Add Begin ---
    	   #LET g_sql = "SELECT ryi01,ryi02,'','','','','',ryi03,ryi04,ryi05,ryi06,ryipos,ryiacti FROM ryi_file ", 
    	   #LET g_sql = "SELECT ryi01,ryi02,'','','','','',ryi03,ryi04,ryi07,'',ryipos,ryiacti FROM ryi_file ",                      #FUN-C60050 mark
            LET g_sql = "SELECT DISTINCT ryi01,ryi02,'','','','','',ryi03,ryi04,ryi07,'',ryipos,ryiacti FROM ryi_file ",             #FUN-C60050 add
           #FUN-C40084 Mark&Add End -----
                        " WHERE ",p_wc2 CLIPPED
       ELSE
       	  #FUN-B30168 add begin-------------------
         #FUN-C40084 Mark&Add Begin ---
         #LET g_sql = "SELECT ryi01,ryi02,'','','','','',ryi03,ryi04,ryi05,ryi06,ryipos,ryiacti FROM ryi_file,ryo_file ", 
         #LET g_sql = "SELECT ryi01,ryi02,'','','','','',ryi03,ryi04,ryi07,'',ryipos,ryiacti FROM ryi_file,ryo_file ",                #FUN-C60050 mark
          LET g_sql = "SELECT DISTINCT ryi01,ryi02,'','','','','',ryi03,ryi04,ryi07,'',ryipos,ryiacti FROM ryi_file,ryo_file ",       #FUN-C60050 add 
         #FUN-C40084 Mark&Add End -----
                      " WHERE ",p_wc2 CLIPPED,
                      "   AND ryo01 = ryi01 AND ",p_wc3 CLIPPED
          #FUN-B30168 add end--------------------- 
       END IF
    END IF
#FUN-A80148--end--

    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    
    PREPARE i060_pb FROM g_sql
    DECLARE ryi_cs CURSOR FOR i060_pb
 
    CALL g_ryi.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH ryi_cs INTO g_ryi[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
        SELECT gen02,gen03,gen07 INTO g_ryi[g_cnt].gen02,g_ryi[g_cnt].gen03,g_ryi[g_cnt].gen07 
         FROM gen_file
         WHERE gen01=g_ryi[g_cnt].ryi02
        SELECT gem02 INTO g_ryi[g_cnt].gem02 FROM gem_file
         WHERE gem01=g_ryi[g_cnt].gen03
        SELECT azp02 INTO g_ryi[g_cnt].azp02 FROM azp_file
         WHERE azp01=g_ryi[g_cnt].gen07

       #FUN-C40084 Add Begin ---
       #抓取權限名稱
        SELECT ryr02 INTO g_ryi[g_cnt].ryi07_desc
          FROM ryr_file
         WHERE ryr01 = g_ryi[g_cnt].ryi07
       #FUN-C40084 Add End -----

        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CALL g_ryi.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
        
END FUNCTION
 
FUNCTION i060_b()
        DEFINE   l_start         LIKE type_file.num5 
        DEFINE   l_end           LIKE type_file.num5
        DEFINE   li_i            LIKE type_file.num5
        DEFINE   l_chr           LIKE type_file.chr1
        DEFINE   l_ac_t          LIKE type_file.num5,
                 l_n             LIKE type_file.num5,
                 l_lock_sw       LIKE type_file.chr1,
                 p_cmd           LIKE type_file.chr1,
                 l_allow_insert  LIKE type_file.num5,
                 l_allow_delete  LIKE type_file.num5,
                 l_count         LIKE type_file.num5
        DEFINE   l_msg           STRING
        DEFINE   ls_tmp          STRING 
        DEFINE   l_ryiacti       LIKE ryi_file.ryiacti
        DEFINE   l_ryipos        LIKE ryi_file.ryipos
        DEFINE   l_azw04         LIKE azw_file.azw04    #FUN-B30168
                
        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
 
        CALL cl_opmsg('b')
        
       #FUN-C40084 Mark&Add Begin ---
       #LET g_forupd_sql="SELECT ryi01,ryi02,'','','','','',ryi03,ryi04,ryi05,ryi06,ryipos",
        LET g_forupd_sql="SELECT ryi01,ryi02,'','','','','',ryi03,ryi04,ryi07,'',ryipos",
       #FUN-C40084 Mark&Add End -----
                        " FROM ryi_file",
                        " WHERE ryi01=?",
                        " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE i060_bcl CURSOR FROM g_forupd_sql
        
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        
        INPUT ARRAY g_ryi WITHOUT DEFAULTS FROM s_ryi.*
                ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b !=0 THEN 
                        CALL fgl_set_arr_curr(l_ac)
                       #CALL cl_set_comp_entry("ryi05,ryi06",FALSE) #FUN-C40084 MARK
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET g_cmd = '' #FUN-C40084 Add
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
                
               #BEGIN WORK       #FUN-B70075 MARK 
                            
                IF g_rec_b>=l_ac THEN 
                        LET p_cmd ='u'
                        LET g_ryi_t.*=g_ryi[l_ac].*
                        #FUN-B70075 Add Begin---
                        #-<修改時將已傳POS否更新為狀態4.修改中，不下傳，并記錄原來的狀態>-#
                        IF g_aza.aza88 = 'Y' THEN
                          #FUN-C40084 Add Begin ---
                           BEGIN WORK
                           OPEN i060_bcl USING g_ryi_t.ryi01 
                           IF STATUS THEN
                              CALL cl_err("OPEN i060_bcl:",STATUS,1)
                              CLOSE i060_bcl
                              ROLLBACK WORK
                              RETURN
                           ELSE
                              FETCH i060_bcl INTO g_ryi[l_ac].*
                              IF SQLCA.sqlcode THEN
                                 CALL cl_err(g_ryi_t.ryi01,SQLCA.sqlcode,1)
                                 CLOSE i060_bcl
                                 ROLLBACK WORK
                                 RETURN
                             #FUN-D20038--add--str---
                              ELSE
                                 UPDATE ryi_file SET ryipos = '4'
                                  WHERE ryi01 = g_ryi[l_ac].ryi01
                                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                                    CALL cl_err3("upd","ryi_file",g_ryi_t.ryi01,"",SQLCA.sqlcode,"","",1)
                                    LET l_lock_sw = "Y"
                                 END IF
                                 LET l_ryipos = g_ryi[l_ac].ryipos
                                 LET g_ryi[l_ac].ryipos = '4'
                                 DISPLAY BY NAME g_ryi[l_ac].ryipos
                             #FUN-D20038--add--end---
                              END IF
                           END IF
                          #FUN-C40084 Add End -----
                          #FUN-D20038--mark--str---
                          #LET l_ryipos = g_ryi[l_ac].ryipos
                          #UPDATE ryi_file SET ryipos = '4'
                          # WHERE ryi01 = g_ryi[l_ac].ryi01
                          #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                          #   CALL cl_err3("upd","ryi_file",g_ryi_t.ryi01,"",SQLCA.sqlcode,"","",1)
                          #   LET l_lock_sw = "Y"
                          #END IF
                          #LET g_ryi[l_ac].ryipos = '4'
                          #DISPLAY BY NAME g_ryi[l_ac].ryipos
                          #FUN-D20038--mark--end---
                           CLOSE i060_bcl          #FUN-D20038 add
                           COMMIT WORK
                        END IF

                        BEGIN WORK
                        #FUN-B70075 Add End-----
                        LET g_before_input_done = FALSE                                                                                      
                        CALL i060_set_entry(p_cmd)                                                                                           
                        CALL i060_set_no_entry(p_cmd)                                                                                        
#FUN-C50036 add begin ---
                        IF g_aza.aza88 = 'Y' THEN
                          #IF l_ryipos <> '1' THEN  #FUN-D20017 mark 
                           IF  l_ryipos <> '1' AND NOT (l_ryipos = '3' AND g_ryi[l_ac].ryiacti = 'N') THEN  #FUN-D20017 add
                              CALL cl_set_comp_entry("ryi01,ryi04",FALSE)
                           ELSE
                              CALL i060_set_entry(p_cmd)
                              CALL i060_set_no_entry(p_cmd)
                              CALL cl_set_comp_entry("ryi04",TRUE)
                           END IF
                        END IF
#FUN-C50036 add end ---
                        LET g_before_input_done = TRUE
                        
                        OPEN i060_bcl USING g_ryi_t.ryi01
                        IF STATUS THEN
                                CALL cl_err("OPEN i060_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i060_bcl INTO g_ryi[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err(g_ryi_t.ryi01,SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                               #FUN-C40084 Mark Begin ---
                               #IF g_ryi[l_ac].ryi04='1' THEN
                               #   CALL cl_set_comp_entry("ryi05,ryi06",TRUE)
                               #ELSE
                               #   CALL cl_set_comp_entry("ryi05,ryi06",FALSE)
                               #END IF
                               #FUN-C40084 Mark End -----
                                SELECT gen02,gen03,gen07 INTO g_ryi[l_ac].gen02,g_ryi[l_ac].gen03,g_ryi[l_ac].gen07 
                                  FROM gen_file
                                  WHERE gen01=g_ryi[l_ac].ryi02
                                SELECT gem02 INTO g_ryi[l_ac].gem02 FROM gem_file
                                  WHERE gem01=g_ryi[l_ac].gen03
                                SELECT azp02 INTO g_ryi[l_ac].azp02 FROM azp_file
                                  WHERE azp01=g_ryi[l_ac].gen07

                               #FUN-C40084 Add Begin ---
                                SELECT ryr02 INTO g_ryi[l_ac].ryi07_desc
                                  FROM ryr_file
                                 WHERE ryr01 = g_ryi[l_ac].ryi07
                                DISPLAY BY NAME g_ryi[l_ac].ryi07_desc
                               #FUN-C40084 Add End -----

                                DISPLAY BY NAME   g_ryi[l_ac].gen02
                                DISPLAY BY NAME   g_ryi[l_ac].gen03
                                DISPLAY BY NAME   g_ryi[l_ac].gen07
                                DISPLAY BY NAME   g_ryi[l_ac].gem02
                                DISPLAY BY NAME   g_ryi[l_ac].azp02
                        END IF
              END IF
              CALL i060_b1_fill(g_wc3)  #FUN-B30168
              CALL i060_ryo_refresh()   #FUN-B30168
              
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                LET g_before_input_done = FALSE                                                                                      
                CALL i060_set_entry(p_cmd)                                                                                           
                CALL i060_set_no_entry(p_cmd)                                                                                        
                LET g_before_input_done = TRUE
                INITIALIZE g_ryi[l_ac].* TO NULL               
                LET g_ryi[l_ac].ryipos = '1' #NO.FUN-B40071
                IF g_aza.aza88 = 'Y' THEN       #FUN-D20038 add
                   LET g_ryi[l_ac].ryipos = '1' #FUN-D20038 add
                   LET l_ryipos = '1'           #FUN-B70075
                END IF                          #FUN-D20038 add
                LET g_ryi[l_ac].ryiacti = 'Y'     #TQC-A30156 ADD
                LET g_ryi_t.*=g_ryi[l_ac].*
                CALL g_ryo.clear()
                DISPLAY ARRAY g_ryo TO s_ryo.*
                   BEFORE DISPLAY
                      EXIT DISPLAY
                END DISPLAY
                CALL cl_show_fld_cont()
                NEXT FIELD ryi01
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                BEGIN WORK #FUN-B70075 ADD                
               #INSERT INTO ryi_file(ryi01,ryi02,ryi03,ryi04,ryi05,ryi06,ryipos, #FUN-C40084 MARK
                INSERT INTO ryi_file(ryi01,ryi02,ryi03,ryi04,ryi07,ryipos,       #FUN-C40084 ADD
                                     ryiacti,ryiuser,ryigrup,ryicrat,ryioriu,ryiorig)
                     VALUES(g_ryi[l_ac].ryi01,g_ryi[l_ac].ryi02,g_ryi[l_ac].ryi03,
                           #g_ryi[l_ac].ryi04,g_ryi[l_ac].ryi05,g_ryi[l_ac].ryi06,g_ryi[l_ac].ryipos, #FUN-C40084 MARK
                            g_ryi[l_ac].ryi04,g_ryi[l_ac].ryi07,g_ryi[l_ac].ryipos,                   #FUN-C40084 ADD
                            g_ryi[l_ac].ryiacti,g_user,g_grup,g_today, g_user, g_grup) 
                       
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","ryi_file",g_ryi[l_ac].ryi01,g_ryi[l_ac].ryi02,SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                   #FUN-B30168 add begin-----------------
                   SELECT azw04 INTO l_azw04 FROM azw_file WHERE azw01=g_ryi[l_ac].gen07
                   IF l_azw04 = '2' THEN            
                      INSERT INTO ryo_file(ryo01,ryo02,ryoacti) VALUES(g_ryi[l_ac].ryi01,g_ryi[l_ac].gen07,'Y')
                      IF SQLCA.sqlcode THEN
                         CALL cl_err3("ins","ryO_file",g_ryi[l_ac].ryi01,g_ryi[l_ac].gen07,SQLCA.sqlcode,"","",1)
                         CANCEL INSERT
                      END IF
                   END IF
                  #FUN-D20038--add--str---
                   LET l_n = 0
                   SELECT COUNT(*) INTO l_n FROM ryp_file WHERE ryp04 = '2' AND ryp01 IN (
                                                         SELECT rys02 FROM rys_file WHERE rys01 = g_ryi[l_ac].ryi07)
                   #新增POS用戶對應權限包含WPC程式,則新增相關權限資料
                   IF l_n > 0 THEN
                      IF g_ryi[l_ac].ryiacti = 'Y' THEN
                         CALL i060_set_permit("a")
                      END IF
                   END IF
                  #FUN-D20038--add--end---
                   LET g_cmd = 'c'
                   #FUN-B30168 add end-------------------
                   MESSAGE 'INSERT Ok'
                   COMMIT WORK
                   LET g_rec_b=g_rec_b+1
                   DISPLAY g_rec_b To FORMONLY.cn2
                END IF
                
#KEY不能重復
      AFTER FIELD ryi01
                IF cl_null(g_ryi[l_ac].ryi01) THEN
                   CALL cl_err('ryi01','apc-132',0)
                   NEXT FIELD ryi01
                END IF

                IF NOT cl_null(g_ryi[l_ac].ryi01) THEN   
                   LET ls_tmp=g_ryi[l_ac].ryi01
                   LET l_start = 1
                   LET l_end = ls_tmp.getLength()

                   FOR li_i = l_start TO l_end
                      LET l_chr = ls_tmp.getCharAt(li_i)
                      IF l_chr NOT MATCHES "[0-9]" THEN
                         CALL cl_err('ryi01','apc-134',0) 
                         LET g_ryi[l_ac].ryi01 = g_ryi_t.ryi01
                         DISPLAY BY NAME g_ryi[l_ac].ryi01
                         NEXT FIELD ryi01
                         EXIT FOR
                      END IF
                   END FOR

                  IF p_cmd = "a" OR                    
                     (p_cmd = "u" AND (g_ryi[l_ac].ryi01 != g_ryi_t.ryi01)) THEN                
                  SELECT COUNT(*) INTO l_n FROM ryi_file WHERE ryi01 = g_ryi[l_ac].ryi01
                  IF l_n > 0 THEN       
                    LET l_msg = g_ryi[l_ac].ryi01 CLIPPED,",",g_plant CLIPPED           
                    CALL cl_err(l_msg,-239,0)
                    LET g_ryi[l_ac].ryi01 = g_ryi_t.ryi01
                    DISPLAY BY NAME g_ryi[l_ac].ryi01
                    NEXT FIELD CURRENT
                  END IF  
                  END IF                            
                 #FUN-D20038--add--str---
                  #已存在p_zx資料,不允許修改POS用戶
                  IF p_cmd = "u" AND (g_ryi[l_ac].ryi01 != g_ryi_t.ryi01) THEN
                     SELECT COUNT(*) INTO l_n FROM zx_file WHERE zx01 = g_ryi_t.ryi01
                     IF l_n > 0 THEN
                        CALL cl_err('','apc-667',0)
                        LET g_ryi[l_ac].ryi01 = g_ryi_t.ryi01
                        DISPLAY BY NAME g_ryi[l_ac].ryi01
                        NEXT FIELD ryi01
                     END IF
                  END IF
                 #FUN-D20038--add--end---
                END IF
 
      AFTER FIELD ryi02
             IF NOT cl_null(g_ryi[l_ac].ryi02) THEN
                IF p_cmd = "a" OR (p_cmd = "u" AND (g_ryi[l_ac].ryi02 != g_ryi_t.ryi02)) THEN
                   #FUN-B30168 mark begin----------------------
                   #LET l_count=0
                   #SELECT COUNT(*) INTO l_count FROM ryi_file WHERE ryi02=g_ryi[l_ac].ryi02
                   #IF l_count>0 THEN
                   #   CALL cl_err('','apc-136',0)
                   #   NEXT FIELD ryi02
                   #END IF
                   #FUN-B30168 mark end------------------------
                END IF
                #FUN-A80148 ------------------add start--------------------------------
                LET l_count = 0 
                IF NOT cl_null(g_argv1) THEN
                   SELECT  COUNT(*)  INTO l_count
                     FROM gen_file
                    WHERE gen01 = g_ryi[l_ac].ryi02 AND gen07 = g_argv1
                   IF cl_null(l_count) OR l_count = 0 THEN
                      CALL cl_err('','apc-140',0)
                      NEXT FIELD ryi02
                   END IF
                END IF
                #FUN-A80148 ----------------add end by vealxu -------------------------

                SELECT gen02,gen03,gen07 INTO g_ryi[l_ac].gen02,g_ryi[l_ac].gen03,g_ryi[l_ac].gen07
                  FROM gen_file
                  WHERE gen01=g_ryi[l_ac].ryi02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("sel","gen_file",g_ryi[l_ac].ryi02,'',SQLCA.sqlcode,"","",1)
                   NEXT FIELD ryi02
                END IF
 
                SELECT gem02 INTO g_ryi[l_ac].gem02 FROM gem_file
                  WHERE gem01=g_ryi[l_ac].gen03
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("sel","gem_file",g_ryi[l_ac].ryi02,'',SQLCA.sqlcode,"","",1)
                END IF
                IF cl_null(g_ryi[l_ac].gen07) THEN
                   CALL cl_err('gen_file','apc-135',0)
                END IF
                SELECT azp02 INTO g_ryi[l_ac].azp02 FROM azp_file
                  WHERE azp01=g_ryi[l_ac].gen07
                DISPLAY BY NAME   g_ryi[l_ac].gen02
                DISPLAY BY NAME   g_ryi[l_ac].gen03
                DISPLAY BY NAME   g_ryi[l_ac].gen07
                DISPLAY BY NAME   g_ryi[l_ac].gem02
                DISPLAY BY NAME   g_ryi[l_ac].azp02
             END IF

      AFTER FIELD ryi03
         IF NOT cl_null(g_ryi[l_ac].ryi03) THEN
            LET ls_tmp=g_ryi[l_ac].ryi03
                IF ls_tmp.getLength() > 10 THEN
                   CALL cl_err("Maximum Length Should Be < 10","!",1)
                   NEXT FIELD zx10
                END IF
         END IF

     #FUN-C40084 Mark Begin ---
     # ON CHANGE ryi04
     #   IF cl_null(g_ryi[l_ac].ryi04) THEN
     #     CALL cl_err('ryi04','apc-132',0)
     #      NEXT FIELD ryi05
     #   END IF

     #   IF g_ryi[l_ac].ryi04='1' THEN
     #      CALL cl_set_comp_entry("ryi05,ryi06",TRUE)
     #   END IF
     #   IF g_ryi[l_ac].ryi04='2' THEN
     #      CALL cl_set_comp_entry("ryi05,ryi06",FALSE)
     #      LET g_ryi[l_ac].ryi05=''
     #      LET g_ryi[l_ac].ryi06=''
     #   END IF

     #AFTER FIELD ryi05
     #   IF cl_null(g_ryi[l_ac].ryi05) AND g_ryi[l_ac].ryi04='1' THEN
     #      CALL cl_err('ryi05','apc-132',0)
     #      NEXT FIELD ryi05
     #   END IF
     #   IF p_cmd = 'a' OR (p_cmd = "u" AND (g_ryi[l_ac].ryi05 != g_ryi_t.ryi05)) THEN     #FUN-B60111 add
     #      SELECT ryh02 INTO g_ryi[l_ac].ryi06 FROM ryh_file
     #       WHERE ryh01=g_ryi[l_ac].ryi05
     #   END IF                                                                            #FUN-B60111 add
     #   DISPLAY BY NAME g_ryi[l_ac].ryi06

     #AFTER FIELD ryi06
     #   IF cl_null(g_ryi[l_ac].ryi06) AND g_ryi[l_ac].ryi04='1' THEN
     #      CALL cl_err('ryi06','apc-132',0)
     #      NEXT FIELD ryi06
     #   END IF
     #   IF g_ryi[l_ac].ryi06>100 OR g_ryi[l_ac].ryi06<0 THEN
     #      CALL cl_err('ryi06','apc-133',0)
     #      NEXT FIELD ryi06
     #   END IF
     #FUN-C40084 Mark End -----

     #FUN-C40084 Add Begin ---
     #權限編號檢查
      AFTER FIELD ryi07
         IF NOT cl_null(g_ryi[l_ac].ryi07) THEN
            CALL i060_ryi07()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err('',g_errno,0)
               NEXT FIELD ryi07
            END IF
         ELSE
            LET g_ryi[l_ac].ryi07_desc = NULL
         END IF
     #FUN-C40084 Add End -----
 
       BEFORE DELETE                      
           DISPLAY "BEFORE DELETE"
           IF g_ryi_t.ryi01 > 0 AND g_ryi_t.ryi01 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
             #SELECT ryiacti,ryipos INTO l_ryiacti,l_ryipos    #FUN-D20038 mark
             #    FROM ryi_file WHERE ryi01=g_ryi_t.ryi01      #FUN-D20038 mark
              IF g_aza.aza88='Y' THEN
                #FUN-B40071 --START--
                 #IF l_ryiacti<>'N' OR l_ryipos<>'Y' THEN
                 #   CALL cl_err("",'apc-139', 1)
                 #   CANCEL DELETE
                 #END IF
                #IF NOT ((l_ryipos='3' AND l_ryiacti='N')      #FUN-D20038 mark
                 IF NOT ((l_ryipos='3' AND g_ryi_t.ryiacti = 'N')   #FUN-D20038 add
                            OR (l_ryipos='1'))  THEN                  
                    CALL cl_err('','apc-139',0)            
                    CANCEL DELETE
                 END IF      
                #FUN-B40071 --END--
              END IF
              DELETE FROM ryi_file
               WHERE ryi01 = g_ryi_t.ryi01
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","ryi_file",g_ryi_t.ryi01,'',SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              ELSE
                 #FUN-B30168 add begin------------------
                 DELETE FROM ryo_file
                  WHERE ryo01 = g_ryi_t.ryi01

                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","ryo_file",g_ryi_t.ryi01,'',SQLCA.sqlcode,"","",1)
                    ROLLBACK WORK
                    CANCEL DELETE
                 END IF
                 #FUN-B30168 add end--------------------
                #FUN-D20038--add--str---
                 #對應權限包含WPC程式,同步刪除相關權限資料
                 SELECT COUNT(*) INTO l_n FROM ryp_file WHERE ryp04 = '2' AND ryp01 IN (
                                                       SELECT rys02 FROM rys_file WHERE rys01 = g_ryi[l_ac].ryi07)
                 IF l_n > 0 THEN
                    CALL i060_set_permit("d")
                 END IF
                #FUN-D20038--add--end---
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ryi[l_ac].* = g_ryi_t.*
              CLOSE i060_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ryi[l_ac].ryi02,-263,1)
              LET g_ryi[l_ac].* = g_ryi_t.*
           ELSE
              IF g_aza.aza88='Y' THEN
                #FUN-B40071 --START--
                 #LET g_ryi[l_ac].ryipos='N'
                #IF g_ryi[l_ac].ryipos <> '1' THEN               #FUN-B70075 MARK
                 IF l_ryipos <> '1' THEN                         #FUN-B70075 ADD
                    LET g_ryi[l_ac].ryipos='2'
                 ELSE                                            #FUN-B70075 ADD
                    LET g_ryi[l_ac].ryipos='1'                   #FUN-B70075 ADD
                 END IF
                #FUN-B40071 --END--
              END IF
              UPDATE ryi_file SET ryi01 = g_ryi[l_ac].ryi01,
                                  ryi02 = g_ryi[l_ac].ryi02,
                                  ryi03 = g_ryi[l_ac].ryi03,
                                  ryi04 = g_ryi[l_ac].ryi04,
                                 #FUN-C40084 Mark&Add Begin ---
                                 #ryi05 = g_ryi[l_ac].ryi05,
                                 #ryi06 = g_ryi[l_ac].ryi06,
                                  ryi07 = g_ryi[l_ac].ryi07,
                                 #FUN-C40084 Mark&Add End -----
                                  ryimodu = g_user,
                                  ryidate = g_today,
                                  ryipos = g_ryi[l_ac].ryipos,
                                  ryiacti =g_ryi[l_ac].ryiacti
                 WHERE ryi01=g_ryi_t.ryi01
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","ryi_file",g_ryi_t.ryi01,'',SQLCA.sqlcode,"","",1) 
                 LET g_ryi[l_ac].* = g_ryi_t.*
              ELSE
                #FUN-D20038--add--str---
                 IF g_ryi[l_ac].ryi01 = g_ryi_t.ryi01 THEN
                    IF g_ryi[l_ac].ryi07 != g_ryi_t.ryi07 THEN
                       SELECT COUNT(*) INTO l_n FROM ryp_file WHERE ryp04 = '2' AND ryp01 IN (
                                                             SELECT rys02 FROM rys_file WHERE rys01 = g_ryi[l_ac].ryi07)
                       IF l_n > 0 THEN
                          SELECT COUNT(*) INTO l_n FROM ryp_file WHERE ryp04 = '2' AND ryp01 IN (
                                                             SELECT rys02 FROM rys_file WHERE rys01 = g_ryi_t.ryi07)
                          IF l_n > 0 THEN
                             #對應舊值權限中包含WPC程式,則更新相關權限資料
                             CALL i060_set_permit("u")
                          ELSE
                             #對應舊值權限中不包含WPC程式,則新增相關權限資料
                             CALL i060_set_permit("a")
                          END IF
                       ELSE 
                          #對應權限中不包含WPC程式,則刪除原用戶相關權限資料
                          CALL i060_set_permit("d")
                       END IF
                    END IF
                 END IF
                 IF g_ryi[l_ac].ryiacti != g_ryi_t.ryiacti THEN
                    SELECT COUNT(*) INTO l_n FROM ryp_file WHERE ryp04 = '2' AND ryp01 IN (
                                                          SELECT rys02 FROM rys_file WHERE rys01 = g_ryi[l_ac].ryi07)
                    IF l_n > 0 THEN
                       IF g_ryi[l_ac].ryiacti = 'Y' THEN
                          CALL i060_set_permit("a")
                       ELSE
                          CALL i060_set_permit("d")
                       END IF 
                    END IF
                 END IF
             #FUN-D20038--add--end--- 
                 LET g_cmd = 'c'
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac   #FUN-D30033 mark
          #CALL cl_set_comp_entry("ryi05,ryi06",FALSE) #FUN-C40084 MARK
 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CLOSE i060_bcl
              ROLLBACK WORK
              IF p_cmd = 'u' THEN
                 LET g_ryi[l_ac].* = g_ryi_t.*
              #FUN-D30033--add--begin--
              ELSE
                 CALL g_ryi.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30033--add--end----
              END IF
             #IF p_cmd = 'a' THEN #FUN-B70075 Add   #FUN-D30033 mark
             #   CALL g_ryi.deleteElement(l_ac)     #FUN-D30033 mark
             #END IF              #FUN-B70075 Add   #FUN-D30033 mark
              
              #FUN-B70075 Add Begin---
              IF p_cmd = 'u' THEN
                #IF g_aza.aza88 = 'Y' THEN     #FUN-D20038 mark
                 IF g_aza.aza88 = 'Y' AND l_lock_sw <> 'Y' THEN    #FUN-D20038 add
                    UPDATE ryi_file SET ryipos = l_ryipos
                     WHERE ryi01 = g_ryi[l_ac].ryi01
                    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                       CALL cl_err3("upd","ryi_file",g_ryi_t.ryi01,"",SQLCA.sqlcode,"","",1)
                    END IF
                    LET g_ryi[l_ac].ryipos = l_ryipos
                    DISPLAY BY NAME g_ryi[l_ac].ryipos
                 END IF
              END IF
              #FUN-B70075 Add End-----
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac   #FUN-D30033 add
           CLOSE i060_bcl
           COMMIT WORK
      ON ACTION controlp
          CASE
             WHEN INFIELD(ryi02)
                CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_gen"   #FUN-AC0022 mark
                #FUN-AC0022 -add--begin---------------------------
                IF cl_null(g_argv1) THEN 
                   LET g_qryparam.form = "q_gen"
                ELSE
                   LET g_qryparam.form = "q_gen01"
                   LET g_qryparam.arg1 = g_argv1
                END IF 
                #FUN-AC0022 -add---end----------------------------
                LET g_qryparam.default1 =g_ryi[l_ac].ryi02 
                CALL cl_create_qry() RETURNING g_ryi[l_ac].ryi02 
                NEXT FIELD ryi02

            #FUN-C40084 Add Begin ---
            #權限編號開窗
             WHEN INFIELD(ryi07)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ryr01"
                LET g_qryparam.where = " ryracti = 'Y' "
                LET g_qryparam.default1 =g_ryi[l_ac].ryi07
                CALL cl_create_qry() RETURNING g_ryi[l_ac].ryi07
                CALL i060_ryi07()
                DISPLAY BY NAME g_ryi[l_ac].ryi07
                NEXT FIELD ryi07
            #FUN-C40084 Add End -----
             OTHERWISE EXIT CASE
         END CASE
        #FUN-C40084 sta
        ON ACTION passwd
           IF cl_null(g_ryi[l_ac].ryi01) THEN 
              CALL cl_err('','apc1028',0)
              NEXT FIELD ryi01
           END IF    
           CALL i060_passwd(g_ryi[l_ac].ryi01,'S',TRUE)
        ON ACTION resetpasswd
           IF cl_null(g_ryi[l_ac].ryi01) THEN 
              CALL cl_err('','apc1028',0)
              NEXT FIELD ryi01
           END IF    
           CALL i060_passwd(g_ryi[l_ac].ryi01,'R',TRUE)   
        #FUN-C40084 end
           
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about       
           CALL cl_about()     
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT
  
    CLOSE i060_bcl
    COMMIT WORK
    
END FUNCTION 

#FUN-B30168 add begin-----------------------------
FUNCTION i060_b1()
        DEFINE   l_ac1_t         LIKE type_file.num5,
                 l_n             LIKE type_file.num5,
                 l_lock_sw       LIKE type_file.chr1,
                 p_cmd           LIKE type_file.chr1,
                 l_allow_insert  LIKE type_file.num5,
                 l_allow_delete  LIKE type_file.num5,
                 l_count         LIKE type_file.num5 
        DEFINE   l_ryiacti       LIKE ryi_file.ryiacti
        DEFINE   l_ryipos        LIKE ryi_file.ryipos
        DEFINE   l_pos_str       LIKE type_file.chr1   #FUN-B70075 ADD                

        LET g_action_choice=""
        IF s_shut(0) THEN 
                RETURN
        END IF
        #FUN-B70075 Add Begin---
        IF g_aza.aza88 = 'Y' THEN
           LET l_pos_str = 'N'
           UPDATE ryi_file SET ryipos = '4'
            WHERE ryi01 = g_ryi[l_ac].ryi01
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              CALL cl_err3("upd","ryi_file",g_ryi_t.ryi01,"",SQLCA.sqlcode,"","",1)
              RETURN
           END IF
           LET l_ryipos = g_ryi[l_ac].ryipos
           LET g_ryi[l_ac].ryipos = '4'
           DISPLAY ARRAY g_ryi TO s_ryi.* ATTRIBUTE(COUNT=g_rec_b)
              BEFORE DISPLAY
                 EXIT DISPLAY
           END DISPLAY
          #DISPLAY BY NAME g_ryi[l_ac].ryipos
        END IF
        #FUN-B70075 Add End----- 
        CALL cl_opmsg('b')
        
        LET g_forupd_sql="SELECT ryo02,'',ryoacti",
                        " FROM ryo_file",
                        " WHERE ryo01=? AND ryo02=?",
                        " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE i060_bcl1 CURSOR FROM g_forupd_sql
        
        LET l_allow_insert=cl_detail_input_auth("insert")
        LET l_allow_delete=cl_detail_input_auth("delete")
        
        INPUT ARRAY g_ryo WITHOUT DEFAULTS FROM s_ryo.*
                ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b1 !=0 THEN 
                        CALL fgl_set_arr_curr(l_ac1)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac1 =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
                
                BEGIN WORK 
                            
                IF g_rec_b1>=l_ac1 THEN 
                        LET p_cmd ='u'
                        LET g_ryo_t.*=g_ryo[l_ac1].*
                        
                        LET g_before_input_done = FALSE                                                                                      
#                       CALL i060_set_entry(p_cmd)              #FUN-C50036 mark                                                                                        
#                       CALL i060_set_no_entry(p_cmd)           #FUN-C50036 mark                                                                       
#FUN-C50036 add begin ---
                        IF g_aza.aza88 = 'Y' THEN
                           IF l_ryipos <> '1' THEN
                              CALL cl_set_comp_entry("ryo02",FALSE)
                           ELSE
                              CALL i060_set_entry_b(p_cmd)
                              CALL i060_set_no_entry_b(p_cmd)
                           END IF
                        ELSE
                        CALL i060_set_entry_b(p_cmd)
                        CALL i060_set_no_entry_b(p_cmd)
                        END IF
#FUN-C50036 add end ---
                        LET g_before_input_done = TRUE
                        
                        OPEN i060_bcl1 USING g_ryi[l_ac].ryi01,g_ryo_t.ryo02
                        IF STATUS THEN
                                CALL cl_err("OPEN i060_bcl1:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i060_bcl1 INTO g_ryo[l_ac1].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err(g_ryo_t.ryo02,SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                SELECT azw08 INTO g_ryo[l_ac1].azw08
                                  FROM azw_file
                                  WHERE azw01=g_ryo[l_ac1].ryo02
                                DISPLAY BY NAME   g_ryo[l_ac1].azw08
                        END IF
              END IF
              
       BEFORE INSERT
          LET l_n=ARR_COUNT()
          LET p_cmd='a'
          LET g_before_input_done = FALSE                                                                                      
#         CALL i060_set_entry(p_cmd)                        #FUN-C50036 mark                                                                                       
#         CALL i060_set_no_entry(p_cmd)                     #FUN-C50036 mark                                                 
          CALL i060_set_entry_b(p_cmd)                      #FUN-C50036 add
          CALL i060_set_no_entry_b(p_cmd)                   #FUN-C50036 add
          LET g_before_input_done = TRUE
          INITIALIZE g_ryo[l_ac1].* TO NULL               
          LET g_ryo[l_ac1].ryoacti = 'Y'     #TQC-A30156 ADD
          LET g_ryo_t.*=g_ryo[l_ac1].*
          CALL cl_show_fld_cont()
          #NEXT FIELD ryo02

       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG=0
             CANCEL INSERT
          END IF
          
          INSERT INTO ryo_file(ryo01,ryo02,ryoacti)
               VALUES(g_ryi[l_ac].ryi01,g_ryo[l_ac1].ryo02,g_ryo[l_ac1].ryoacti) 
                 
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","ryo_file",g_ryi[l_ac].ryi01,g_ryo[l_ac1].ryo02,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
          ELSE
            #FUN-B70075 Mark Begin---
            #IF g_aza.aza88='Y' THEN
            #   LET g_ryi[l_ac].ryipos='1' #NO.FUN-B40071
            #END IF
            #UPDATE ryi_file SET ryipos = g_ryi[l_ac].ryipos WHERE ryi01 = g_ryi[l_ac].ryi01
            #IF SQLCA.sqlerrd[3] = 0 OR SQLCA.sqlcode THEN
            #   CALL cl_err3("upd","ryi_file",g_ryi[l_ac].ryi01,g_ryo[l_ac1].ryo02,SQLCA.sqlcode,"","",1)
            #   CANCEL INSERT
            #END IF  
            #FUN-B70075 Mark End-----
            #FUN-D20038--add--str---
             SELECT COUNT(*) INTO l_n FROM ryp_file WHERE ryp04 = '2' AND ryp01 IN (
                                                         SELECT rys02 FROM rys_file WHERE rys01 = g_ryi[l_ac].ryi07)
             IF l_n > 0 THEN
                IF g_ryi[l_ac].ryiacti = 'Y' THEN
                   IF g_ryo[l_ac1].ryoacti = 'Y' THEN
                      CALL i060_set_permit1('a')
                   END IF
                END IF
             END IF
            #FUN-D20038--add--end---
             MESSAGE 'INSERT Ok'
             COMMIT WORK
             LET l_pos_str = 'Y'   #FUN-B70075 ADD
             LET g_rec_b1=g_rec_b1+1
          END IF
 
      AFTER FIELD ryo02
         IF NOT cl_null(g_ryo[l_ac1].ryo02) THEN
            IF p_cmd = "a" OR (p_cmd = "u" AND (g_ryo[l_ac1].ryo02 != g_ryo_t.ryo02)) THEN
               LET l_count=0
               SELECT COUNT(*) INTO l_count FROM ryo_file 
                WHERE ryo02=g_ryo[l_ac1].ryo02
                  AND ryo01=g_ryi[l_ac].ryi01
               IF l_count>0 THEN
                  CALL cl_err('','apc-005',0)
                  NEXT FIELD ryo02
               END IF
               LET l_count=0
               SELECT COUNT(*) INTO l_count FROM azw_file      
                WHERE azw01 = g_ryo[l_ac1].ryo02
                  AND azw04 = '2' AND azwacti = 'Y'
               IF l_count <= 0 THEN
                  CALL cl_err('','apc-003',0)
                  NEXT FIELD ryo02
               END IF
            END IF       
            SELECT azw08 INTO g_ryo[l_ac1].azw08
              FROM azw_file
              WHERE azw01=g_ryo[l_ac1].ryo02
            DISPLAY BY NAME   g_ryo[l_ac1].azw08
         END IF

          
      BEFORE DELETE                      
         DISPLAY "BEFORE DELETE"
         IF NOT cl_delb(0,0) THEN
            CANCEL DELETE
         END IF
         IF l_lock_sw = "Y" THEN
            CALL cl_err("", -263, 1)
            CANCEL DELETE
         END IF
         DELETE FROM ryo_file
          WHERE ryo01 = g_ryi[l_ac].ryi01
            AND ryo02=g_ryo_t.ryo02
            
         IF SQLCA.sqlcode THEN   
            CALL cl_err3("del","ryo_file",g_ryo_t.ryo02,'',SQLCA.sqlcode,"","",1)  
            ROLLBACK WORK
            CANCEL DELETE
         ELSE
           #FUN-B70075 Mark Begin---
           #IF g_aza.aza88='Y' THEN
           #  #FUN-B40071 --START--
           #   #LET g_ryi[l_ac].ryipos='N'
           #   IF g_ryi[l_ac].ryipos <> '1' THEN
           #      LET g_ryi[l_ac].ryipos='2'
           #   END IF
           #  #FUN-B40071 --END--
           #END IF
           #UPDATE ryi_file SET ryipos = g_ryi[l_ac].ryipos WHERE ryi01 = g_ryi[l_ac].ryi01
           #IF SQLCA.sqlerrd[3] = 0 OR SQLCA.sqlcode THEN
           #   CALL cl_err3("upd","ryi_file",g_ryi[l_ac].ryi01,g_ryo[l_ac1].ryo02,SQLCA.sqlcode,"","",1)
           #   ROLLBACK WORK
           #   CANCEL DELETE
           #END IF  
           #FUN-B70075 Mark End-----
           #FUN-D20038--add--str---
            SELECT COUNT(*) INTO l_n FROM ryp_file WHERE ryp04 = '2' AND ryp01 IN (
                                                  SELECT rys02 FROM rys_file WHERE rys01 = g_ryi[l_ac].ryi07)
            IF l_n > 0 THEN
               IF g_ryi[l_ac].ryiacti = 'Y' THEN
                  CALL i060_set_permit1('d')
               END IF
            END IF
           #FUN-D20038--add--end---
            MESSAGE 'DELETE Ok'
            COMMIT WORK
            LET l_pos_str = 'Y'   #FUN-B70075 ADD
            LET g_rec_b1=g_rec_b1-1 
         END IF

      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_ryo[l_ac1].* = g_ryo_t.*
            CLOSE i060_bcl1
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_ryo[l_ac1].ryo02,-263,1)
            LET g_ryo[l_ac1].* = g_ryo_t.*
         ELSE
            UPDATE ryo_file SET ryo02 = g_ryo[l_ac1].ryo02,
                                ryoacti =g_ryo[l_ac1].ryoacti
               WHERE ryo01 = g_ryi[l_ac].ryi01
                 AND ryo02=g_ryo_t.ryo02
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("upd","ryo_file",g_ryo_t.ryo02,'',SQLCA.sqlcode,"","",1) 
               LET g_ryo[l_ac1].* = g_ryo_t.*
            ELSE
              #FUN-B70075 Mark Begin---
              #IF g_aza.aza88='Y' THEN                  
              #   #FUN-B40071 --START--
              #    #LET g_ryi[l_ac].ryipos='N'                    
              #    IF g_ryi[l_ac].ryipos <> '1' THEN
              #       LET g_ryi[l_ac].ryipos='2'
              #    END IF
              #   #FUN-B40071 --END--
              #END IF
              #UPDATE ryi_file SET ryipos = g_ryi[l_ac].ryipos WHERE ryi01 = g_ryi[l_ac].ryi01
              #IF SQLCA.sqlerrd[3] = 0 OR SQLCA.sqlcode THEN
              #   CALL cl_err3("upd","ryi_file",g_ryi[l_ac].ryi01,g_ryo[l_ac1].ryo02,SQLCA.sqlcode,"","",1)
              #   LET g_ryo[l_ac1].* = g_ryo_t.*
              #END IF
              #FUN-B70075 Mark End-----
              #FUN-D20038--add--str---
               SELECT COUNT(*) INTO l_n FROM ryp_file WHERE ryp04 = '2' AND ryp01 IN (
                                                     SELECT rys02 FROM rys_file WHERE rys01 = g_ryi[l_ac].ryi07)
               IF l_n > 0 THEN
                  IF g_ryi[l_ac].ryiacti = 'Y' THEN
                     CALL i060_set_permit1('u')
                  END IF
                  IF g_ryo[l_ac1].ryoacti != g_ryo_t.ryoacti THEN
                     IF g_ryo[l_ac1].ryoacti = 'Y' THEN
                        CALL i060_set_permit1('a')
                     ELSE
                        CALL i060_set_permit1('d')
                     END IF
                  END IF
               END IF
                     
              #FUN-D20038--add--end---
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
               LET l_pos_str = 'Y'   #FUN-B70075 ADD
            END IF
         END IF
 
      AFTER ROW
         DISPLAY  "AFTER ROW!!"
         LET l_ac1 = ARR_CURR()
        #LET l_ac1_t = l_ac1  #FUN-D30033 mark
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_ryo[l_ac1].* = g_ryo_t.*
            #FUN-D30033--add--begin--
            ELSE
               CALL g_ryo.deleteElement(l_ac1)
               IF g_rec_b1 != 0 THEN
                  LET g_action_choice = "detail"
                  LET g_action_flag = 'p_detail' 
                  LET l_ac1 = l_ac1_t
               END IF
            #FUN-D30033--add--end----
            END IF
            CLOSE i060_bcl1
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac1_t = l_ac1  #FUN-D30033 add
         CLOSE i060_bcl1
         COMMIT WORK
      ON ACTION controlp
          CASE
             WHEN INFIELD(ryo02)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azw08" 
                LET g_qryparam.default1 =g_ryo[l_ac1].ryo02 
                CALL cl_create_qry() RETURNING g_ryo[l_ac1].ryo02
                DISPLAY BY NAME  g_ryo[l_ac1].ryo02 
                NEXT FIELD ryo02
             OTHERWISE EXIT CASE
         END CASE
      #FUN-C40084 sta
      ON ACTION passwd
         IF cl_null(g_ryi[l_ac].ryi01) THEN 
            CALL cl_err('','apc1028',0)
            NEXT FIELD ryi01
         END IF  
         CALL i060_passwd(g_ryi[l_ac].ryi01,'S',TRUE)
      ON ACTION resetpasswd
         IF cl_null(g_ryi[l_ac].ryi01) THEN 
            CALL cl_err('','apc1028',0)
            NEXT FIELD ryi01
         END IF    
         CALL i060_passwd(g_ryi[l_ac].ryi01,'R',TRUE)      
      #FUN-C40084 end
                      
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about       
         CALL cl_about()     
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
   END INPUT
  
   CLOSE i060_bcl1
   COMMIT WORK
   #FUN-B70075 Add Begin---
   IF g_aza.aza88 = 'Y' THEN
      IF l_pos_str = 'Y' THEN
         IF l_ryipos <> '1' THEN
            LET g_ryi[l_ac].ryipos = '2'
         ELSE
            LET g_ryi[l_ac].ryipos = '1'
         END IF
         UPDATE ryi_file SET ryipos = g_ryi[l_ac].ryipos
          WHERE ryi01 = g_ryi[l_ac].ryi01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","ryi_file",g_ryi_t.ryi01,"",SQLCA.sqlcode,"","",1)
         END IF
         DISPLAY BY NAME g_ryi[l_ac].ryipos
      ELSE
         UPDATE ryi_file SET ryipos = l_ryipos
          WHERE ryi01 = g_ryi[l_ac].ryi01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET l_lock_sw = "Y"
         END IF
         LET g_ryi[l_ac].ryipos = l_ryipos
         DISPLAY BY NAME g_ryi[l_ac].ryipos
      END IF
   END IF
   #FUN-B70075 Add End-----   
END FUNCTION

FUNCTION i060_b1_fill(p_wc3)
DEFINE   p_wc3       STRING     
DEFINE   l_cnt       INTEGER
   LET l_cnt = g_ryi.getLength()
   IF cl_null(l_ac) OR l_ac=0 THEN LET l_ac = 1 END IF
   IF  l_cnt=0 OR l_cnt IS NULL THEN RETURN END IF
   
   LET g_sql = "SELECT ryo02,'',ryoacti FROM ryo_file ",   
               " WHERE ryo01 = '",g_ryi[l_ac].ryi01,"'",
               "   AND ",p_wc3 CLIPPED              
   
   PREPARE i060_pb1 FROM g_sql
   DECLARE ryo_cs CURSOR FOR i060_pb1
 
   CALL g_ryo.clear()
   LET g_cnt = 1
   MESSAGE "Searching!"
   FOREACH ryo_cs INTO g_ryo[g_cnt].*  
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH
      END IF
      SELECT azw08 INTO g_ryo[g_cnt].azw08
        FROM azw_file
       WHERE azw01=g_ryo[g_cnt].ryo02
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_ryo.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b1 = g_cnt-1
   LET g_cnt = 0
END FUNCTION
#FUN-B30168 add end-------------------------------                         
                                                   
FUNCTION i060_bp_refresh()
 
  DISPLAY ARRAY g_ryi TO s_ryi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
  
END FUNCTION
 
#FUN-B30168 add begin------------------------
FUNCTION i060_ryo_refresh()

  DISPLAY ARRAY g_ryo TO s_ryo.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY

END FUNCTION
#FUN-B30168 add end--------------------------

#FUN-C40084 Add Begin ---
FUNCTION i060_ryi07()
DEFINE l_ryracti   LIKE ryr_file.ryracti

   LET g_errno = ''
   SELECT ryr02,ryracti INTO g_ryi[l_ac].ryi07_desc,l_ryracti
     FROM ryr_file
    WHERE ryr01 = g_ryi[l_ac].ryi07

   CASE
      WHEN SQLCA.sqlcode = 100 LET g_errno = 'apc-153' #該權限編號不存在
                               LET g_ryi[l_ac].ryi07_desc = NULL
      WHEN l_ryracti <> 'Y'    LET g_errno = 'apc-154' #該權限編號已無效
      OTHERWISE LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
END FUNCTION
#FUN-C40084 Add End -----

 
FUNCTION i060_out()                                                     
DEFINE l_cmd  LIKE type_file.chr1000
    IF g_wc2 IS NULL THEN                                                                                                            
       CALL cl_err('','9057',0) RETURN                                                                                              
    END IF                                                                                                                          
    LET l_cmd = 'p_query "apci060" "',g_wc2 CLIPPED,'"'                                                                              
    CALL cl_cmdrun(l_cmd)
    
END FUNCTION                                                            
 
FUNCTION i060_set_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
          #CALL cl_set_comp_entry("ryi01",TRUE)               #FUN-D20038 mark
           CALL cl_set_comp_entry("ryi01,ryi04",TRUE)         #FUN-D20038 add
        END IF
END FUNCTION

FUNCTION i060_set_no_entry(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("ryi01",FALSE)
        END IF
END FUNCTION

#FUN-C50036 add begin ---
FUNCTION i060_set_entry_b(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
           CALL cl_set_comp_entry("ryo02",TRUE)
        END IF
END FUNCTION

FUNCTION i060_set_no_entry_b(p_cmd)
        DEFINE p_cmd LIKE type_file.chr1
        IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("ryo02",FALSE)
        END IF
END FUNCTION
#FUN-C50036 add end ---

#FUN-A40005 ADD
#FUN-AA0064 
#FUN-B80029
#FUN-C40084 sta
FUNCTION i060_passwd(l_ryi01,l_action,p_inTransaction)
DEFINE l_ryi01     LIKE ryi_file.ryi01
DEFINE l_gen02     LIKE gen_file.gen02
DEFINE l_ryi03     LIKE ryi_file.ryi03
DEFINE passwd1     LIKE ryi_file.ryi03
DEFINE passwd2     LIKE ryi_file.ryi03
DEFINE passwd3     LIKE ryi_file.ryi03
DEFINE l_oldpw     LIKE ryi_file.ryi03
DEFINE l_newpw     LIKE ryi_file.ryi03
DEFINE l_ryi       RECORD LIKE ryi_file.*
DEFINE l_str       STRING
DEFINE l_forupd_sql    STRING
DEFINE p_inTransaction LIKE type_file.num5
DEFINE l_ryipos    LIKE ryi_file.ryipos
DEFINE l_action    LIKE type_file.chr1
DEFINE l_ryi07     LIKE ryi_file.ryi07     #FUN-D20038 add
DEFINE l_zx10      LIKE zx_file.zx10       #FUN-D20038 add
DEFINE l_n         LIKE type_file.num5     #FUN-D20038 add
DEFINE l_sql       STRING                  #FUN-D20038 add

   IF NOT p_inTransaction THEN  
      LET l_forupd_sql = "SELECT * FROM ryi_file WHERE ryi01 = ? FOR UPDATE"
      LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
      DECLARE i060_cl CURSOR FROM l_forupd_sql   
      BEGIN WORK
      OPEN i060_cl USING l_ryi01 
      IF STATUS THEN
         CALL cl_err("OPEN i060_cl:",STATUS,1)
         CLOSE i060_cl
         ROLLBACK WORK
         RETURN
      ELSE
         FETCH i060_cl INTO l_ryi.*
         IF SQLCA.sqlcode THEN
            CALL cl_err(l_ryi01,SQLCA.sqlcode,1)
            CLOSE i060_cl
            ROLLBACK WORK
            RETURN
         END IF
      END IF
   END IF   
   LET g_success = 'Y' 
   OPEN WINDOW i060_1_w WITH FORM "apc/42f/apci060_1"
            ATTRIBUTE(STYLE=g_win_style CLIPPED)
   CALL cl_ui_locale("apci060_1")
   IF l_action = 'R' THEN 
      CALL cl_set_comp_visible('passwd1',FALSE)
      CALL cl_set_comp_entry('passwd1',FALSE)
   ELSE
      CALL cl_set_comp_visible('passwd1',TRUE)  
      CALL cl_set_comp_entry('passwd1',TRUE) 
   END IF    
   SELECT gen02 INTO l_gen02 FROM gen_file 
    WHERE gen01 = (SELECT ryi02 FROM ryi_file WHERE ryi01 = l_ryi01) 
   DISPLAY l_ryi01,l_gen02 TO ryi01,gen02

   INPUT  BY NAME passwd1,passwd2,passwd3  WITHOUT DEFAULTS
      BEFORE INPUT
         IF l_action = 'S' THEN 
            SELECT ryi03 INTO l_ryi03 FROM ryi_file
             WHERE ryi01 = l_ryi01
            IF cl_null(l_ryi03) THEN 
               CALL cl_set_comp_entry('passwd1',FALSE)
            ELSE 
               CALL cl_set_comp_entry('passwd1',TRUE)
            END IF 
         END IF    
      AFTER FIELD passwd1
         IF NOT cl_null(passwd1) THEN 
            LET l_str = l_ryi01,passwd1
            CALL i060_changepw(l_str) RETURNING l_oldpw
            IF l_oldpw <> l_ryi03 THEN 
               CALL cl_err('','azz-865',0)
               NEXT FIELD passwd1
            END IF
         END IF
      BEFORE FIELD passwd2
         IF l_action = 'S' THEN 
            IF NOT cl_null(l_ryi03) AND cl_null(passwd1) THEN 
               CALL cl_err('','apc1026',0)
               NEXT FIELD passwd1
            END IF  
         END IF    
      AFTER FIELD passwd2
         IF NOT cl_null(passwd2) THEN 
            IF LENGTH(passwd2) > 10 THEN 
               CALL cl_err('','apc1024',0)
               NEXT FIELD passwd2
            END IF 
         END IF 
      BEFORE FIELD passwd3
         IF cl_null(passwd2) THEN 
            CALL cl_err('','apc1025',0)
            NEXT FIELD passwd2
         END IF 
      AFTER FIELD passwd3
         
         IF NOT cl_null(passwd3) THEN    
            IF LENGTH(passwd3) > 10 THEN 
               CALL cl_err('','apc1024',0)
               NEXT FIELD passwd3
            END IF 
         END IF 
      AFTER INPUT 
         IF NOT cl_null(passwd2) AND NOT cl_null(passwd3) THEN 
            IF passwd2 <> passwd3 THEN 
               CALL cl_err('','apc1027',0)
               LET passwd3 = ''
               NEXT FIELD passwd3
            ELSE 
               LET l_str = l_ryi01,passwd3
               CALL i060_changepw(l_str) RETURNING l_newpw
                  
            END IF 
               
         END IF    
   END INPUT            
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW i060_1_w
      IF NOT p_inTransaction THEN 
         CLOSE i060_cl
      END IF
      RETURN    
     # LET g_success = 'N'
   END IF
   CLOSE WINDOW i060_1_w
   IF NOT p_inTransaction THEN 
      IF g_success = 'Y' THEN    
         IF l_ryi.ryipos <> '1' THEN 
            LET l_ryi.ryipos = '2'
         END IF    
         UPDATE ryi_file SET ryi03 = l_newpw,
                             ryipos = l_ryi.ryipos
          WHERE ryi01 = l_ryi01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","ryi_file",l_ryi01,'',SQLCA.sqlcode,"","",1) 
            CLOSE i060_cl
            ROLLBACK WORK 
         ELSE
           #FUN-D20038--add--str---
            SELECT ryi07 INTO l_ryi07 FROM ryi_file WHERE ryi01 = l_ryi01
            SELECT COUNT(*) INTO l_n FROM ryp_file WHERE ryp04 = '2' AND ryp01 IN (
                                                  SELECT rys02 FROM rys_file WHERE rys01 = l_ryi07)
            IF l_n > 0 THEN
               LET l_zx10 = cl_user_encode(passwd3)
               UPDATE zx_file SET zx10 = l_zx10,zx16 = g_today
                WHERE zx01 = l_ryi01
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","zx_file",'','',SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK
               END IF
               LET l_sql = "UPDATE ",s_dbstring("wds") CLIPPED,"wzx_file",
                           "   SET wzx06 = '",l_zx10,"' ",
                           "      ,wzx08 = '",g_today,"' ",
                           " WHERE wzx01 = '",l_ryi01,"' "
               PREPARE upd_wzx_pre3 FROM l_sql
               EXECUTE upd_wzx_pre3
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","wzx_file",'','',SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK
               END IF 
            END IF
           #FUN-D20038--add--end---
            MESSAGE 'UPDATE O.K'
            CLOSE i060_cl
            COMMIT WORK 
         END IF 
      ELSE
         CLOSE i060_cl
         ROLLBACK WORK    
      END IF 
   ELSE
      IF g_success = 'Y' THEN 
         LET g_ryi[l_ac].ryi03 = l_newpw
      END IF 
   END IF    
END FUNCTION
FUNCTION i060_changepw(l_str)
   DEFINE l_str       java.lang.String               #要加密的明文
   DEFINE l_digest    java.security.MessageDigest    #加密演算法物件
   DEFINE l_ength     INTEGER                        #加密後長度(應該為16 Byte)
   DEFINE l_i         SMALLINT
   DEFINE l_byte      java.lang.Byte                 #加密後每一個Byte值(有可能為負數)
   DEFINE l_encrypt   STRING                         #以MD5來說加密後就是32位16進制的數值字串
   DEFINE l_tmp       STRING
   DEFINE l_int       INTEGER

   LET l_encrypt = ""

   IF l_str IS NULL THEN
      display "Encryption string is null."
      LET g_success = 'N'
      RETURN 
   END IF

   TRY
      #指定加密演算法
      LET l_digest = java.security.MessageDigest.getInstance("MD5")
      #將字串轉換成byte,並傳送要演算的字串

      CALL l_digest.update(l_str.getBytes())

      #原則上MD5加密後長度應該會是16 bytes
      LET l_ength = l_digest.getDigestLength()       #因為在java裡無法做byte與java.lang.Byte的型態轉換
      #而且在4gl code中又無法引用java裡byte這個基本型態
      #因此只能利用for迴圈逐一抓出byte的值,順便做16進制的轉換
      FOR l_i = 1 TO l_ength
         #逐一取出每一個byte加密後的值
         LET l_byte = java.lang.Byte.valueOf(l_digest.digest()[l_i])
         #DISPLAY "digest[", l_i, "]: ", l_byte, ";"

         #java的toHexString參數是int,所以這裡還需做型態轉換
         #心得:利用4gl寫java要特別注意型態,一但型態錯誤就無法做api的呼叫
         LET l_int = l_byte.intValue()

         #因為每一個byte加密後的值有可能是負數,所以需做補數轉換
         #java code本是這樣做:(l_byte & 0XFF)就可以了
         #4gl code就直接將負數加256吧(因為1個byte是8 bit,所以要加上2的8次方=256)
         IF l_byte < 0 THEN
            LET l_int = l_byte.intValue() + 256
         ELSE
            LET l_int = l_byte.intValue()
         END IF

         #進行16進位轉碼,因為需固定取出二位字串故先在前面多加個"0"字串
         #等後面再做subString取出二個長度的字串
         LET l_tmp = java.lang.Integer.toHexString(l_int)
           LET l_tmp = "0", l_tmp
         #取出二位字串
         #範例1,有可能出來的是0:  "0", "0"  = "00"  ===> subString(1, 2)
         #範例2,有可能出來的是FF: "0", "FF" = "0FF" ===> subString(2, 3)
         LET l_tmp = l_tmp.subString(l_tmp.getLength() - 1, l_tmp.getLength())          #組合加密後之16進制的32位元數值字串
         LET l_encrypt = l_encrypt, l_tmp

         #重新傳送要演算的字串
         #要這樣做的原因就在於在for圈裡會再執行l_digest.digest()
         #呼叫digest()時會重新再一次用演算法進行加密
         #這樣下一個再取出的byte值就會和第一次計算的不一樣
         #所以這裡要再重新傳送要演算的字串
         CALL l_digest.update(l_str.getBytes())
      END FOR 
         
      DISPLAY "Encrypt Finish."
   CATCH 
      LET l_encrypt = "" 
      DISPLAY "Error:", STATUS
      display "Generate MD5 key failed."
      LET g_success = 'N'
      RETURN 
   END TRY
            
   RETURN l_encrypt
END FUNCTION
#FUN-C40084 end

#FUN-D20038--add--str---
FUNCTION i060_set_permit(p_action)
DEFINE p_action      LIKE type_file.chr1
DEFINE l_gen02       LIKE gen_file.gen02
DEFINE l_gen03       LIKE gen_file.gen03
DEFINE l_zxw02       LIKE zxw_file.zxw02
DEFINE l_ryp06       LIKE ryp_file.ryp06
DEFINE l_zz04        LIKE zz_file.zz04
DEFINE l_ryr02       LIKE ryr_file.ryr02
DEFINE l_ryo02       LIKE ryo_file.ryo02
DEFINE l_zx08        LIKE zx_file.zx08
DEFINE l_wzx04       LIKE zx_file.zx08
DEFINE l_n           LIKE type_file.num5
DEFINE l_sql         STRING
DEFINE l_str         LIKE type_file.chr1

   IF p_action = "a" THEN
      SELECT COUNT(*) INTO l_n FROM zx_file WHERE zx01 = g_ryi[l_ac].ryi01
      IF l_n > 0 THEN RETURN END IF 
      SELECT gen02,gen03 INTO l_gen02,l_gen03 FROM gen_file WHERE gen01 = g_ryi[l_ac].ryi02
      SELECT MAX(zxw02) INTO l_zxw02 FROM zxw_file WHERE zxw01 = g_ryi[l_ac].ryi01
      IF cl_null(l_zxw02) THEN LET l_zxw02 = 0 END IF 
      INSERT INTO zx_file(zx01,zx02,zx03,zx04,zx05,zx06,zx07,zx08,zx09,zx10,zx11,zx12,zx13,zx14,zx15,
                          zx16,zx17,zx18,zx19,zx20,zxuser,zxgrup,zxmodu,zxdate,zxacti,zxoriu,zxorig)
                   VALUES(g_ryi[l_ac].ryi01,l_gen02,l_gen03,g_ryi[l_ac].ryi07,'wpc',g_lang,'Y',' ',NULL,NULL,NULL,'N',NULL,NULL,'3',
                          NULL,0,NULL,'Y',0,g_user,g_grup,g_user,g_today,'Y',g_user,g_grup)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","zx_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF
{
      SELECT ryo02 INTO l_ryo02 FROM ryo_file WHERE ryo01 = g_ryi[l_ac].ryi01
      IF NOT cl_null(l_ryo02) THEN
         UPDATE zx_file SET zx08 = l_ryo02 WHERE zx01 = g_ryi[l_ac].ryi01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","zx_file","","",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF

         INSERT INTO zxy_file(zxy01,zxy02,zxy03) VALUES(g_ryi[l_ac].ryi01,l_gen02,l_ryo02)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","zxy_file","","",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF

         LET l_sql = "INSERT INTO ",s_dbstring("wds") CLIPPED,"wzy_file","(",
                     " wzy01,wzy02,wzy03) ",
                     " VALUES('",g_ryi[l_ac].ryi01,"','2','",l_ryo02,"') "
         PREPARE trans_ins_wzy_3 FROM l_sql
         EXECUTE trans_ins_wzy_3
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","wzy_file","","",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF 
      END IF
}
      INSERT INTO zxw_file(zxw01,zxw02,zxw03,zxw04,zxw05,zxw06,zxw07,zxw08) 
                    VALUES(g_ryi[l_ac].ryi01,l_zxw02+1,'1',g_ryi[l_ac].ryi07,NULL,NULL,NULL,NULL)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","zxw_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF

      LET l_str = ' '
      LET l_sql = "INSERT INTO ",s_dbstring("wds") CLIPPED,"wzx_file","(",
                  " wzx01,wzx02,wzx03,wzx04,wzx05,wzx06,wzx07,wzx08,wzxuser,wzxgrup,wzxmodu,wzxdate,wzxacti,wzx09,wzx10) ",
                  " VALUES('",g_ryi[l_ac].ryi01,"','",l_gen02,"','",g_lang,"','",l_ryo02,"','",l_gen03,"',NULL,NULL,NULL,
                           '",g_user,"','",g_grup,"','",g_user,"','",g_today,"','Y','wpc',NUll) "
      PREPARE trans_ins_wzx FROM l_sql
      EXECUTE trans_ins_wzx
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","wzx_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF

      LET l_sql = "INSERT INTO ",s_dbstring("wds") CLIPPED,"wzy_file","(",
                  " wzy01,wzy02,wzy03) ",
                  " VALUES('",g_ryi[l_ac].ryi01,"','1','",g_ryi[l_ac].ryi07,"') "
      PREPARE trans_ins_wzy_1 FROM l_sql
      EXECUTE trans_ins_wzy_1 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","wzy_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF   

      LET l_sql = " SELECT ryp06 FROM ryp_file WHERE ryp04 = '2' AND ryp01 IN (SELECT rys02 FROM rys_file ",
                  "                                             WHERE rys01 = '",g_ryi[l_ac].ryi07,"') "
      PREPARE sel_ryp06_pre1 FROM l_sql
      DECLARE sel_ryp06_cs1  CURSOR FOR sel_ryp06_pre1
      FOREACH sel_ryp06_cs1  INTO l_ryp06
         SELECT COUNT(*) INTO l_n FROM zw_file WHERE zw01 = g_ryi[l_ac].ryi07
         IF l_n<1 THEN
            SELECT ryr02 INTO l_ryr02 FROM ryr_file WHERE ryr01 = g_ryi[l_ac].ryi07
            INSERT INTO zw_file(zw01,zw02,zw03,zw04,zw05,zw06,zwacti,zwuser,zwgrup,zwmodu,zwdate,zworig,zworiu)
                         VALUES(g_ryi[l_ac].ryi07,l_ryr02,NULL,'1',NULL,NULL,'Y',g_user,g_grup,g_user,g_today,g_grup,g_user)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","zw_file","","",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               RETURN
            END IF
         END IF

         SELECT COUNT(*) INTO l_n FROM zy_file WHERE zy01 = g_ryi[l_ac].ryi07 AND zy02 = l_ryp06
         IF l_n < 1 THEN
            SELECT zz04 INTO l_zz04 FROM zz_file WHERE zz01 = l_ryp06
            INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy06,zyuser,zygrup,zymodu,zydate,zy07,zyorig,zyoriu)
                         VALUES(g_ryi[l_ac].ryi07,l_ryp06,l_zz04,'0','0',NULL,g_user,g_grup,g_user,g_today,'0',g_grup,g_user)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","zy_file","","",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               RETURN
            END IF
         END IF
      END FOREACH

      LET l_sql = " SELECT ryo02 FROM ryo_file WHERE ryo01 = '",g_ryi[l_ac].ryi01,"' "
      PREPARE sel_ryo02_pre FROM l_sql
      DECLARE sel_ryo02_cs  CURSOR FOR sel_ryo02_pre
      FOREACH sel_ryo02_cs  INTO l_ryo02
         SELECT zx08 INTO l_zx08 FROM zx_file WHERE zx01 = g_ryi[l_ac].ryi01
         IF cl_null(l_zx08) THEN
            UPDATE zx_file SET zx08 = l_ryo02 WHERE zx01 = g_ryi[l_ac].ryi01
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","zx_file","","",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               RETURN
            END IF
         END IF

         LET l_sql = " SELECT wzx04 FROM ",s_dbstring("wds") CLIPPED,"wzx_file",
                     "  WHERE wzx01 = '",g_ryi[l_ac].ryi01,"' "
         PREPARE sel_wzx04_pre FROM l_sql
         EXECUTE sel_wzx04_pre INTO l_wzx04
         IF cl_null(l_wzx04) THEN
            LET l_sql = "UPDATE ",s_dbstring("wds") CLIPPED,"wzx_file",
                        "   SET wzx04 = '",l_ryo02,"' ",
                        " WHERE wzx01 = '",g_ryi[l_ac].ryi01,"' "
            PREPARE upd_wzx_pre4 FROM l_sql
            EXECUTE upd_wzx_pre4
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","wzx_file","","",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               RETURN
            END IF
         END IF

         SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_ryi[l_ac].ryi02
         INSERT INTO zxy_file(zxy01,zxy02,zxy03) VALUES(g_ryi[l_ac].ryi01,l_gen02,l_ryo02)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","zxy_file","","",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF
   
         LET l_sql = "INSERT INTO ",s_dbstring("wds") CLIPPED,"wzy_file","(",
                     " wzy01,wzy02,wzy03) ",
                     " VALUES('",g_ryi[l_ac].ryi01,"','2','",l_ryo02,"') "
         PREPARE trans_ins_wzy_4 FROM l_sql
         EXECUTE trans_ins_wzy_4
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","wzy_file","","",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF
      END FOREACH
   END IF

   IF p_action = "u" THEN
      UPDATE zx_file SET zx04 = g_ryi[l_ac].ryi07 WHERE zx01 = g_ryi[l_ac].ryi01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","zx_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF
      
      UPDATE zxw_file SET zxw04 = g_ryi[l_ac].ryi07 WHERE zxw01 = g_ryi[l_ac].ryi01 AND zxw04 = g_ryi_t.ryi07
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","zxw_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF

      LET l_sql = "UPDATE ",s_dbstring("wds") CLIPPED,"wzy_file",
                  "   SET wzy03 = '",g_ryi[l_ac].ryi07,"' ",
                  " WHERE wzy01 = '",g_ryi[l_ac].ryi01,"' AND wzy02 = '1' "
      PREPARE trans_upd_wzy FROM l_sql
      EXECUTE trans_upd_wzy
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","wzy_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF

      LET l_sql = " SELECT ryp06 FROM ryp_file WHERE ryp04 = '2' AND ryp01 IN (SELECT rys02 FROM rys_file ",
                  "                                             WHERE rys01 = '",g_ryi[l_ac].ryi07,"') "
      PREPARE sel_ryp06_pre2 FROM l_sql
      DECLARE sel_ryp06_cs2  CURSOR FOR sel_ryp06_pre2
      FOREACH sel_ryp06_cs2  INTO l_ryp06
         SELECT COUNT(*) INTO l_n FROM zy_file WHERE zy01 = g_ryi[l_ac].ryi07 AND zy02 = l_ryp06
         IF l_n < 1 THEN
            SELECT zz04 INTO l_zz04 FROM zz_file WHERE zz01 = l_ryp06
            INSERT INTO zy_file(zy01,zy02,zy03,zy04,zy05,zy06,zyuser,zygrup,zymodu,zydate,zy07,zyorig,zyoriu)
                         VALUES(g_ryi[l_ac].ryi07,l_ryp06,l_zz04,'0','0',NULL,g_user,g_grup,g_user,g_today,'0',g_grup,g_user)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","zy_file","","",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               RETURN
            END IF
         END IF 
      END FOREACH
   END IF

   IF p_action = "d" THEN
      DELETE FROM zx_file WHERE zx01 = g_ryi[l_ac].ryi01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zx_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF

      DELETE FROM zxy_file WHERE zxy01 = g_ryi[l_ac].ryi01 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zxy_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF 

      DELETE FROM zxw_file WHERE zxw01 = g_ryi[l_ac].ryi01 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zxw_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF

      LET l_sql = "DELETE FROM ",s_dbstring("wds") CLIPPED,"wzx_file",
                  " WHERE wzx01 = '",g_ryi[l_ac].ryi01,"' "
      PREPARE trans_del_wzx FROM l_sql
      EXECUTE trans_del_wzx
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","wzx_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF

      LET l_sql = "DELETE FROM ",s_dbstring("wds") CLIPPED,"wzy_file",
                  " WHERE wzy01 = '",g_ryi[l_ac].ryi01,"' "
      PREPARE trans_del_wzy FROM l_sql
      EXECUTE trans_del_wzy
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","wzy_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF 
   END IF
END FUNCTION 

FUNCTION i060_set_permit1(p_action)
DEFINE   p_action        LIKE type_file.chr1
DEFINE   l_wzx04         LIKE zx_file.zx08    
DEFINE   l_zx08          LIKE zx_file.zx08
DEFINE   l_gen02         LIKE gen_file.gen02
DEFINE   l_sql           STRING 
 
   IF p_action = 'a' THEN
      SELECT zx08 INTO l_zx08 FROM zx_file WHERE zx01 = g_ryi[l_ac].ryi01
      IF cl_null(l_zx08) THEN
         UPDATE zx_file SET zx08 = g_ryo[l_ac1].ryo02 WHERE zx01 = g_ryi[l_ac].ryi01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","zx_file","","",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF
      END IF

      LET l_sql = " SELECT wzx04 FROM ",s_dbstring("wds") CLIPPED,"wzx_file",
                  "  WHERE wzx01 = '",g_ryi[l_ac].ryi01,"' "
      PREPARE sel_wzx04_pre3 FROM l_sql
      EXECUTE sel_wzx04_pre3 INTO l_wzx04
      IF cl_null(l_wzx04) THEN
         LET l_sql = "UPDATE ",s_dbstring("wds") CLIPPED,"wzx_file",
                     "   SET wzx04 = '",g_ryo[l_ac1].ryo02,"' ",
                     " WHERE wzx01 = '",g_ryi[l_ac].ryi01,"' "
         PREPARE upd_wzx_pre FROM l_sql
         EXECUTE upd_wzx_pre
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","wzx_file","","",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF
      END IF

      SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01 = g_ryi[l_ac].ryi02
      INSERT INTO zxy_file(zxy01,zxy02,zxy03) VALUES(g_ryi[l_ac].ryi01,l_gen02,g_ryo[l_ac1].ryo02)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","zxy_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF

      LET l_sql = "INSERT INTO ",s_dbstring("wds") CLIPPED,"wzy_file","(",
                  " wzy01,wzy02,wzy03) ",
                  " VALUES('",g_ryi[l_ac].ryi01,"','2','",g_ryo[l_ac1].ryo02,"') "
      PREPARE trans_ins_wzy_2 FROM l_sql
      EXECUTE trans_ins_wzy_2
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","wzy_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF
   END IF

   IF p_action = 'u' THEN
      SELECT zx08 INTO l_zx08 FROM zx_file WHERE zx01 = g_ryi[l_ac].ryi01
      IF l_zx08 = g_ryo_t.ryo02 THEN
         UPDATE zx_file SET zx08 = g_ryo[l_ac1].ryo02 WHERE zx01 = g_ryi[l_ac].ryi01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","zx_file","","",SQLCA.sqlcode,"","",1)
            LET g_ryo[l_ac1].* = g_ryo_t.*
            ROLLBACK WORK
            RETURN
         END IF
      END IF

      LET l_sql = " SELECT wzx04 FROM ",s_dbstring("wds") CLIPPED,"wzx_file",
                  "  WHERE wzx01 = '",g_ryi[l_ac].ryi01,"' "
      PREPARE sel_wzx04_pre2 FROM l_sql
      EXECUTE sel_wzx04_pre2 INTO l_wzx04
      IF l_wzx04 = g_ryo_t.ryo02 THEN
         LET l_sql = "UPDATE ",s_dbstring("wds") CLIPPED,"wzx_file",
                     "   SET wzx04 = '",g_ryo[l_ac1].ryo02,"' ",
                     " WHERE wzx01 = '",g_ryi[l_ac].ryi01,"' "
         PREPARE upd_wzx_pre2 FROM l_sql
         EXECUTE upd_wzx_pre2
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","wzx_file","","",SQLCA.sqlcode,"","",1)
            LET g_ryo[l_ac1].* = g_ryo_t.*
            ROLLBACK WORK
            RETURN
         END IF
      END IF

      UPDATE zxy_file SET zxy03 = g_ryo[l_ac1].ryo02 WHERE zxy01 = g_ryi[l_ac].ryi01 AND zxy03 = g_ryo_t.ryo02
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","zxy_file","","",SQLCA.sqlcode,"","",1)
         LET g_ryo[l_ac1].* = g_ryo_t.*
         ROLLBACK WORK
         RETURN
      END IF

      LET l_sql = "UPDATE ",s_dbstring("wds") CLIPPED,"wzy_file",
                  "   SET wzy03 = '",g_ryo[l_ac1].ryo02,"' ",
                  " WHERE wzy01 = '",g_ryi[l_ac].ryi01,"' AND wzy02 = '2' AND wzy03 = '",g_ryo_t.ryo02,"' "
      PREPARE trans_upd_wzy1 FROM l_sql
      EXECUTE trans_upd_wzy1
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","wzy_file","","",SQLCA.sqlcode,"","",1)
         LET g_ryo[l_ac1].* = g_ryo_t.*
         ROLLBACK WORK
         RETURN
      END IF
   END IF

   IF p_action = 'd' THEN
      SELECT zx08 INTO l_zx08 FROM zx_file WHERE zx01 = g_ryi[l_ac].ryi01
      IF l_zx08 = g_ryo_t.ryo02 THEN
         UPDATE zx_file SET zx08 = ' ' WHERE zx01 = g_ryi[l_ac].ryi01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","zx_file","","",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF
      END IF

      LET l_sql = " SELECT wzx04 FROM ",s_dbstring("wds") CLIPPED,"wzx_file",
                  "  WHERE wzx01 = '",g_ryi[l_ac].ryi01,"' "
      PREPARE sel_wzx04_pre1 FROM l_sql
      EXECUTE sel_wzx04_pre1 INTO l_wzx04
      IF l_wzx04 = g_ryo_t.ryo02 THEN
         LET l_sql = "UPDATE ",s_dbstring("wds") CLIPPED,"wzx_file",
                     "   SET wzx04 = ' ' ",
                     " WHERE wzx01 = '",g_ryi[l_ac].ryi01,"' "
         PREPARE upd_wzx_pre1 FROM l_sql
         EXECUTE upd_wzx_pre1
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","wzx_file","","",SQLCA.sqlcode,"","",1)
            ROLLBACK WORK
            RETURN
         END IF
      END IF

      DELETE FROM zxy_file WHERE zxy01 = g_ryi[l_ac].ryi01 AND zxy03 = g_ryo_t.ryo02
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","zxy_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF
     
      LET l_sql = "DELETE FROM ",s_dbstring("wds") CLIPPED,"wzy_file",
                  " WHERE wzy01 = '",g_ryi[l_ac].ryi01,"' ",
                  "   AND wzy02 = '2' ",
                  "   AND wzy03 = '",g_ryo_t.ryo02,"' "
      PREPARE trans_del_wzy1 FROM l_sql
      EXECUTE trans_del_wzy1
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","wzy_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK
         RETURN
      END IF
   END IF

END FUNCTION
#FUN-D20038--add--end---

