# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aapi204.4gl
# Descriptions...: 常用科目維護作業
# Date & Author..: 96/02/15 By Felicity Tseng
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin  放寬aag02
# Modify.........: No.FUN-4B0009 04/11/02 By ching add '轉Excel檔' action
# Modify.........: No.FUN-4C0097 05/01/05 By Nicola 報表架構修改
# Modify.........: No.FUN-570108 05/07/13 By vivien 可否更改KEY值的相關修改  
# Modify.........: No.FUN-590124 05/10/04 By Dido aag02 放寬  
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660192 06/07/04 By Smapmin 類別不可輸入1-9,A,B,C,Z
# Modify.........: No.FUN-680029 06/08/17 By zhuying 多套帳修改
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.MOD-6A0079 06/11/10 By Smapmin 修正FUN-660192判斷位置
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-730064 07/03/29 By sherry 會計科目加帳套
# Modify.........: No.FUN-770093 07/08/07 By johnray 修改報表功能，使用CR打印報表
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B20059 11/02/24 By wujie  科目自动开窗hard code修改
# Modify.........: No:FUN-B40011 11/04/08 By guoch  apw01不能等於D
# Modify.........: No:TQC-BC0184 11/12/30 By yinhy 新增時統治科目不可錄入
# Modify.........: No.FUN-C90122 12/10/16 By wangrr apw01不能等於F
# Modify.........: No.FUN-C90044 12/10/18 By minpp apw01不能等於E 
# Modify.........: No.FUN-C50126 12/12/26 By Abby HRM改善功能:增加類別G,代表"代扣款(HRM整合專用)"
# Modify.........: No.FUN-CB0065 13/01/04 By wangrr apw01不能等於G
# Modify.........: No.FUN-CC0142 13/01/14 By Nina HRM改善功能:增加類別G,代表"代扣款(HRM整合專用)"=>改為類別H
# Modify.........: No:FUN-D30032 13/04/01 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_apw           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        apw01       LIKE apw_file.apw01,   
        apw02       LIKE apw_file.apw02,  
        apw03       LIKE apw_file.apw03,
#FUN-590124  
        aag02       LIKE aag_file.aag02, 
#       aag02       VARCHAR(30) 
#FUN-590124 End
        apw031      LIKE apw_file.apw03,       #FUN-680029 
        aag021      LIKE aag_file.aag02        #FUN-680029
                    END RECORD,
    g_apw_t         RECORD                 #程式變數 (舊值)
        apw01       LIKE apw_file.apw01,   
        apw02       LIKE apw_file.apw02,  
        apw03       LIKE apw_file.apw03,  
#FUN-590124  
        aag02       LIKE aag_file.aag02, 
#       aag02       VARCHAR(30) 
#FUN-590124 End
        apw031      LIKE apw_file.apw03,       #FUN-680029 
        aag021      LIKE aag_file.aag02        #FUN-680029 
                    END RECORD,
   #g_wc2,g_sql     LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(300)
    g_wc2,g_sql     STRING,                #TQC-630166
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690028 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-690028 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690028 INTEGER
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570108    #No.FUN-690028 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0055
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
    OPTIONS                               #改變一些系統預設值
       INPUT NO WRAP
    DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
 
   LET p_row = 3 LET p_col = 22
   OPEN WINDOW i204_w AT p_row,p_col 
     WITH FORM "aap/42f/aapi204"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
#FUN-680029----begin---
   IF g_aza.aza63 = 'Y' THEN
      CALL cl_set_comp_visible("apw031,aag021",TRUE)
   ELSE
      CALL cl_set_comp_visible("apw031,aag021",FALSE)
   END IF
#FUN-680029---end-----
   LET g_wc2 = '1=1' 
 
   CALL i204_b_fill(g_wc2)
 
   CALL i204_menu()
 
   CLOSE WINDOW i204_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
         RETURNING g_time    #No.FUN-6A0055
 
END MAIN
 
FUNCTION i204_menu()
DEFINE l_cmd     STRING          #No.FUN-770093 add
 
   WHILE TRUE
      CALL i204_bp("G")
      CASE g_action_choice
         WHEN "query"  
            IF cl_chk_act_auth() THEN
               CALL i204_q() 
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i204_b() 
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"  
            IF cl_chk_act_auth() THEN 
#No.FUN-770093 -- begin --
#               CALL i204_out()
               IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
               IF g_aza.aza63 = 'Y'  THEN
                  LET l_cmd = 'p_query "aapi204" "',g_wc2 CLIPPED,'"'
               ELSE
                  LET l_cmd = 'p_query "aapi204_1" "',g_wc2 CLIPPED,'"'
               END IF
               CALL cl_cmdrun(l_cmd)
#No.FUN-770093 -- end --
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
 
         #FUN-4B0009
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_apw),'','')
             END IF
         #--
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i204_q()
 
   CALL i204_b_askkey()
 
END FUNCTION
 
FUNCTION i204_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690028 SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690028 SMALLINT
   l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690028 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690028 VARCHAR(1)
   l_allow_insert  LIKE type_file.chr1,     #No.FUN-690028 VARCHAR(1)
   l_allow_delete  LIKE type_file.chr1     #No.FUN-690028 VARCHAR(1)
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   CALL cl_opmsg('b')
                                                  
   LET g_forupd_sql = "SELECT apw01,apw02,apw03,apw031 FROM apw_file WHERE apw01=? FOR UPDATE  "  #FUN-680029
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i204_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_apw WITHOUT DEFAULTS FROM s_apw.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT        
         IF g_rec_b != 0 THEN 
            CALL fgl_set_arr_curr(l_ac) 
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
#        DISPLAY l_ac TO FORMONLY.cn3  
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_apw_t.* = g_apw[l_ac].*  #BACKUP
#No.FUN-570108 --start                                                          
            LET g_before_input_done = FALSE                                         
            CALL i204_set_entry(p_cmd)                                              
            CALL i204_set_no_entry(p_cmd)                                           
            LET g_before_input_done = TRUE                                          
#No.FUN-570108 --end            
            BEGIN WORK
            OPEN i204_bcl USING g_apw_t.apw01
            IF STATUS THEN
               CALL cl_err("OPEN i204_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE  
               FETCH i204_bcl INTO g_apw[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_apw_t.apw01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
               LET g_apw[l_ac].aag02 = g_apw_t.aag02
               LET g_apw[l_ac].apw031= g_apw_t.apw031         #FUN-680029  
               LET g_apw[l_ac].aag021= g_apw_t.aag021         #FUN-680029
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
#No.FUN-570108 --start                                                          
         LET g_before_input_done = FALSE                                         
         CALL i204_set_entry(p_cmd)                                              
         CALL i204_set_no_entry(p_cmd)                                           
         LET g_before_input_done = TRUE                                          
#No.FUN-570108 --end        
         INITIALIZE g_apw[l_ac].* TO NULL      #900423
         LET g_apw_t.* = g_apw[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD apw01
 
      AFTER INSERT
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
            EXIT INPUT
         END IF
 
         INSERT INTO apw_file(apw01,apw02,apw03,apw031)    #FUN-680029
              VALUES(g_apw[l_ac].apw01,g_apw[l_ac].apw02,g_apw[l_ac].apw03,g_apw[l_ac].apw031)   #FUN-680029
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_apw[l_ac].apw01,SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("ins","apw_file",g_apw[l_ac].apw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2  
         END IF
 
      AFTER FIELD apw01                        #check 編號是否重複
         IF NOT cl_null(g_apw[l_ac].apw01) THEN
            IF g_apw[l_ac].apw01 != g_apw_t.apw01 OR
               (g_apw[l_ac].apw01 IS NOT NULL AND g_apw_t.apw01 IS NULL) THEN
               SELECT count(*) INTO l_n FROM apw_file
                WHERE apw01 = g_apw[l_ac].apw01
               IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_apw[l_ac].apw01 = g_apw_t.apw01
                  NEXT FIELD apw01
               END IF
               #-----FUN-660192---------
               IF g_apw[l_ac].apw01 MATCHES '[1-9,A,B,C,D,E,F,G,H,Z]' THEN   #FUN-B40011 #FUN-C90122 add 'F' #FUN-C90044 add 'E'  #FUN-C50126 add 'G' #FUN-CB0065 add 'G'  #FUN-CC0142 add 'H'
                  CALL cl_err('','aap-259',0)
                  NEXT FIELD apw01
               END IF
               #-----END FUN-660192-----
            END IF
         END IF
 
      BEFORE FIELD apw02
          IF NOT cl_null(g_apw[l_ac].apw01) THEN        #-->No.MOD-480024
            IF g_apw[l_ac].apw01 MATCHES '[0-9]' THEN 
               NEXT FIELD apw01 
            END IF
          END IF                                        #-->No.MOD-480024
    
      AFTER FIELD apw03  
         IF NOT cl_null(g_apw[l_ac].apw03) THEN
            SELECT aag02 INTO g_apw[l_ac].aag02 FROM aag_file
             WHERE aag01 = g_apw[l_ac].apw03
               AND aag00 = g_aza.aza81             #No.FUN-730064  
               AND aag07 IN ('2','3')   #TQC-BC0184
            IF STATUS THEN
#              CALL cl_err('sel aag:',STATUS,0)   #No.FUN-660122
#No.FUN-B20059 --begin
               CALL cl_err3("sel","aag_file",g_apw[l_ac].apw03,"",STATUS,"","sel aag:",0)  #No.FUN-660122
               CALL q_aapact(FALSE,FALSE,'2',g_apw[l_ac].apw03,g_aza.aza81) #No.FUN-730064
                    RETURNING g_apw[l_ac].apw03
#No.FUN-B20059 --end
               NEXT FIELD apw03
            END IF
         END IF
#FUN-680029----begin---
      AFTER FIELD apw031
         IF NOT cl_null(g_apw[l_ac].apw031) THEN
            SELECT aag02 INTO g_apw[l_ac].aag021 FROM aag_file
             WHERE aag01 = g_apw[l_ac].apw031
               AND aag00 = g_aza.aza82        #No.FUN-730064
               AND aag07 IN ('2','3')   #TQC-BC0184
            IF STATUS THEN                                                                                                                                                          
#No.FUN-B20059 --begin
               CALL cl_err3("sel","aag_file",g_apw[l_ac].apw031,"",STATUS,"","sel aag:",0)    
               CALL q_aapact(FALSE,FALSE,'2',g_apw[l_ac].apw031,g_aza.aza82)  #No.FUN-730064
                    RETURNING g_apw[l_ac].apw031
#No.FUN-B20059 --end
               NEXT FIELD apw031                                                                                                     
            END IF
         END IF
#FUN-680029----end-----
 
 
      BEFORE DELETE                            #是否取消單身
         IF g_apw_t.apw01 IS NOT NULL THEN
            IF NOT cl_delete() THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN 
               CALL cl_err("", -263, 1) 
               CANCEL DELETE 
            END IF 
            DELETE FROM	 apw_file WHERE apw01 = g_apw_t.apw01
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_apw_t.apw01,SQLCA.sqlcode,0)   #No.FUN-660122
               CALL cl_err3("del","apw_file",g_apw_t.apw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2  
            MESSAGE "Delete OK" 
            CLOSE i204_bcl     
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_apw[l_ac].* = g_apw_t.*
            CLOSE i204_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_apw[l_ac].apw01,-263,1)
            LET g_apw[l_ac].* = g_apw_t.*
         ELSE
            UPDATE apw_file SET apw01=g_apw[l_ac].apw01,
                                apw02=g_apw[l_ac].apw02,
                                apw03=g_apw[l_ac].apw03,
                                apw031=g_apw[l_ac].apw031          #FUN-680029
             WHERE apw01 = g_apw_t.apw01
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_apw[l_ac].apw01,SQLCA.sqlcode,0)   #No.FUN-660122
               CALL cl_err3("upd","apw_file",g_apw_t.apw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
               LET g_apw[l_ac].* = g_apw_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()                                               
         IF INT_FLAG THEN                 #900423                            
            CALL cl_err('',9001,0)                                           
            LET INT_FLAG = 0  
            IF p_cmd = 'u' THEN                                               
               LET g_apw[l_ac].* = g_apw_t.* 
            #FUN-D30032--add--str--
            ELSE
               CALL g_apw.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end--
            END IF
            CLOSE i204_bcl                                                   
            ROLLBACK WORK                                                    
            EXIT INPUT                                                       
         END IF                                                              
         LET l_ac_t = l_ac                                                   
         CLOSE i204_bcl                                                      
         COMMIT WORK            
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(apw01) AND l_ac > 1 THEN
            LET g_apw[l_ac].* = g_apw[l_ac-1].*
            NEXT FIELD apw01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLP                                                      
         CASE WHEN INFIELD(apw03) # Account number                            
#           CALL q_aapact(FALSE,TRUE,'2',g_apw[l_ac].apw03)       #No:8727
#                         RETURNING g_apw[l_ac].apw03
            CALL q_aapact(FALSE,TRUE,'2',g_apw[l_ac].apw03,g_aza.aza81) #No.FUN-730064
                          RETURNING g_apw[l_ac].apw03
#           CALL FGL_DIALOG_SETBUFFER( g_apw[l_ac].apw03 )
             #NO:8095 #No.MOD-490344
            DISPLAY BY NAME g_apw[l_ac].apw03
            NEXT FIELD apw03
 #FUN-680029----begin-----
            WHEN INFIELD(apw031)
#           CALL q_aapact(FALSE,TRUE,'2',g_apw[l_ac].apw031)
#                         RETURNING g_apw[l_ac].apw031
            CALL q_aapact(FALSE,TRUE,'2',g_apw[l_ac].apw031,g_aza.aza82)  #No.FUN-730064
                          RETURNING g_apw[l_ac].apw031
            CALL FGL_DIALOG_SETBUFFER( g_apw[l_ac].apw031 )
            DISPLAY BY NAME g_apw[l_ac].apw031
            NEXT FIELD apw031
 #FUN-680029------end-----
         END CASE       
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
        
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
      
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
   CLOSE i204_bcl
   COMMIT WORK
 
END FUNCTION
FUNCTION i204_b_askkey()
 
   CLEAR FORM
   CALL g_apw.clear()
 
   CONSTRUCT g_wc2 ON apw01,apw02,apw03,apw031             #FUN-680029  
                 FROM s_apw[1].apw01,s_apw[1].apw02,s_apw[1].apw03,s_apw[1].apw031   #FUN-680029  
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP                                                          
         CASE
            WHEN INFIELD(apw03) # Account number                                
#              CALL q_aapact(TRUE,TRUE,'2',g_apw[1].apw03)    #No:8727
#                          RETURNING g_qryparam.multiret 
               CALL q_aapact(TRUE,TRUE,'2',g_apw[1].apw03,g_aza.aza81)    #No.FUN-730064
                           RETURNING g_qryparam.multiret 
               DISPLAY g_qryparam.multiret TO apw03                                
               NEXT FIELD apw03
    #FUn-680029----begin------
            WHEN INFIELD(apw031)
#              CALL q_aapact(TRUE,TRUE,'2',g_apw[1].apw031)
#                           RETURNING g_qryparam.multiret
               CALL q_aapact(TRUE,TRUE,'2',g_apw[1].apw031,g_aza.aza82) #No.FUN-730064
                            RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO apw031
               NEXT FIELD apw031
    #FUN-680029-----end--------
         END CASE
 
                                                                 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
      
       ON ACTION about         #MOD-4C0121
          CALL cl_about()      #MOD-4C0121
      
       ON ACTION help          #MOD-4C0121
          CALL cl_show_help()  #MOD-4C0121
      
       ON ACTION CONTROLG      #MOD-4C0121
          CALL cl_cmdask()     #MOD-4C0121
     
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT        
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
#No.TQC-710076 -- begin --
#   IF INT_FLAG THEN 
#      LET INT_FLAG = 0 
#      RETURN 
#   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
 
   CALL i204_b_fill(g_wc2)
 
END FUNCTION
 
FUNCTION i204_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(200)
DEFINE l_aag02         LIKE aag_file.aag02
 
   LET g_sql = "SELECT apw01,apw02,apw03,aag02,apw031,'' ",   #FUN-680029
               " FROM apw_file, OUTER aag_file",
#              " WHERE apw_file.apw03=aag_file.aag01 AND ", p_wc2 CLIPPED,                     #單身
               " WHERE apw_file.apw03=aag_file.aag01 AND aag_file.aag00 = '",g_aza.aza81,"' AND ", p_wc2 CLIPPED,   #No.FUN-630064
               " ORDER BY apw01"
   PREPARE i204_pb FROM g_sql
   DECLARE apw_curs CURSOR FOR i204_pb
 
   CALL g_apw.clear()
   LET g_cnt = 1
   MESSAGE "Searching!" 
 
   FOREACH apw_curs INTO g_apw[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN 
         CALL cl_err('foreach:',STATUS,1) 
         EXIT FOREACH 
      END IF
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   #FUN-680029-----begin-----                                                                                                         
      SELECT aag02 INTO l_aag02 FROM aag_file                                                                                       
      WHERE aag01=g_apw[g_cnt].apw031     
        AND aag00=g_aza.aza82     #No.FUN-730064                                                                                             
      LET g_apw[g_cnt].aag021 = l_aag02                                                                                             
      LET l_aag02 = NULL
      DISPLAY l_aag02  TO FORMONLY.aag021                                                                                           
   #FUN-680029------end------                                                                                                         
      LET g_cnt = g_cnt + 1   
   END FOREACH
 
   CALL g_apw.deleteElement(g_cnt)
 
   MESSAGE ""
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i204_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN                            
      RETURN                                                                    
   END IF                                                                       
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_apw TO s_apw.* ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept                                                          
         LET g_action_choice="detail"                                           
         LET l_ac = ARR_CURR()                                                  
         EXIT DISPLAY                                                           
                                                                                
      ON ACTION cancel                                                          
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0009
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#No.FUN-770093 -- begin --
#FUNCTION i204_out()
#    DEFINE
#        l_i             LIKE type_file.num5,    #No.FUN-690028 SMALLINT
#        l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
#        l_aag02         LIKE aag_file.aag02,    #No.FUN-690028 VARCHAR(20),   #FUN-680029
#        sr    RECORD 
#                 apw01   LIKE type_file.chr2,   # No.FUN-690028 VARCHAR(2) 
#                 apw02   LIKE apw_file.apw02,
#                 apw03   LIKE apw_file.apw03,
#                 aag02   LIKE aag_file.aag02,
#                 apw031  LIKE apw_file.apw03,    #FUN-680029 
#                 aag021  LIKE aag_file.aag02     #FUN-680029 
#              END RECORD
#
#   IF g_wc2 IS NULL THEN
#      CALL cl_err('','9057',0)
#      RETURN
#   END IF
#
#   CALL cl_wait()
#
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#                                                #FUN-680029                      
#   LET g_sql="SELECT apw01,apw02,apw03,aag02,apw031 FROM apw_file,",# 組合出SQL指令
##            " OUTER aag_file WHERE apw_file.apw03=aag_file.aag01 AND aaaa",g_wc2 CLIPPED," ORDER BY apw01"
#             " OUTER aag_file WHERE apw_file.apw03=aag_file.aag01 AND aag_file.aag00 =  '",g_aza.aza81,"' AND ",g_wc2 CLIPPED," ORDER BY apw01"  #NO.FUN-730064
#                                                   # RUNTIME 編譯  #FUN-680029
#   PREPARE i204_p1 FROM g_sql 
#   DECLARE i204_co CURSOR FOR i204_p1
# #FUN-680029----begin-----
#   CALL cl_outnam('aapi204') RETURNING l_name 
#   IF g_aza.aza63 = 'Y'  THEN
#      LET g_zaa[35].zaa06 = "N"
#      LET g_zaa[36].zaa06 = "N"
#   ELSE
#      LET g_zaa[35].zaa06 = "Y"
#      LET g_zaa[36].zaa06 = "Y"
#   END IF
#   CALL cl_prt_pos_len()
# #FUN-680029------end-----
#   START REPORT i204_rep TO l_name
#
#   FOREACH i204_co INTO sr.*
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
#         EXIT FOREACH
#      END IF
#
#      IF sr.apw03 = 'N' THEN 
#         LET sr.apw01 = '*',sr.apw01
#      END IF
#   #FUN-680029----begin----
#      IF sr.apw031 = 'N' THEN
#         LET sr.apw01 = '*',sr.apw01
#      END IF
#      SELECT aag02 INTO l_aag02 FROM aag_file
#       WHERE aag01 = sr.apw031
#         AND aag00 = g_aza.aza82         #No.FUN-730064
#         LET sr.aag021 = l_aag02
#         LET  l_aag02  = NULL
##      DISPLAY l_aag02 TO FORMONLY.aag021 
#   #FUN-680029---end-------       
#
#
#      OUTPUT TO REPORT i204_rep(sr.*)
#
#   END FOREACH
#
#   FINISH REPORT i204_rep
#
#   CLOSE i204_co
#   ERROR ""
#
#   CALL cl_prt(l_name,' ','1',g_len)
#
#END FUNCTION
#
#REPORT i204_rep(sr)
#DEFINE  l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
#        sr    RECORD 
#                 apw01   LIKE type_file.chr2,   # No.FUN-690028 VARCHAR(2)
#                 apw02   LIKE apw_file.apw02,
#                 apw03   LIKE apw_file.apw03,
#                 aag02   LIKE aag_file.aag02,
#                 apw031  LIKE apw_file.apw031,         #FUN-680029 
#                 aag021  LIKE aag_file.aag02           #FUN-680029 
#              END RECORD
#
#   OUTPUT
#      TOP MARGIN g_top_margin
#      LEFT MARGIN g_left_margin
#      BOTTOM MARGIN g_bottom_margin
#      PAGE LENGTH g_page_line
#
#   ORDER BY sr.apw01
#
#   FORMAT
#      PAGE HEADER
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)-1,g_company CLIPPED
#         PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)-1,g_x[1]
#         LET g_pageno = g_pageno + 1
#         LET pageno_total = PAGENO USING '<<<',"/pageno"
#         PRINT g_head CLIPPED,pageno_total
#         PRINT 
#         PRINT g_dash[1,g_len]
#         PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#         PRINT g_dash1
#         LET l_trailer_sw = 'y'
#
#      ON EVERY ROW
#         PRINT COLUMN g_c[31],sr.apw01 CLIPPED,
#               COLUMN g_c[32],sr.apw02 CLIPPED,
#               COLUMN g_c[33],sr.apw03 CLIPPED,
#               COLUMN g_c[34],sr.aag02;
#         IF g_aza.aza63 = 'Y' THEN
#               PRINT COLUMN g_c[35],sr.apw031,     #FUN-680029
#                     COLUMN g_c[36],sr.aag021      #FUN-680029
#         ELSE
#               PRINT " "
#         END IF
#      ON LAST ROW
#         IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
#            CALL cl_wcchp(g_wc2,'apw01,apw02') RETURNING g_sql
#            PRINT g_dash[1,g_len]
#            #TQC-630166
#            #IF g_sql[001,080] > ' ' THEN
#      	    #   PRINT COLUMN g_c[31],g_x[8] CLIPPED,
#            #         COLUMN g_c[32],g_sql[001,070] CLIPPED 
#            #END IF
#            #IF g_sql[071,140] > ' ' THEN
#      	    #   PRINT COLUMN g_c[32],g_sql[071,140] CLIPPED 
#            #END IF
#            #IF g_sql[141,210] > ' ' THEN
#      	    #   PRINT COLUMN g_c[32],g_sql[141,210] CLIPPED 
#            #END IF
#             CALL cl_prt_pos_wc(g_sql)
#            #END TQC-630166
#         END IF
#         PRINT g_dash[1,g_len]
#         LET l_trailer_sw = 'n'
#         PRINT g_x[4],g_x[40] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
#
#      PAGE TRAILER
#         IF l_trailer_sw = 'y' THEN
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
#         ELSE
#            SKIP 2 LINE
#         END IF
#
#END REPORT
#No.FUN-770093 -- end --
 
#No.FUN-570108 --start                                                          
FUNCTION i204_set_entry(p_cmd)                                                  
  DEFINE p_cmd   LIKE type_file.chr1                                                           #No.FUN-690028 VARCHAR(1)
                                                                                
   IF p_cmd='a' AND ( NOT g_before_input_done ) THEN                            
     CALL cl_set_comp_entry("apw01",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION i204_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1                                                           #No.FUN-690028 VARCHAR(1)
                                                                                
   IF p_cmd='u' AND  ( NOT g_before_input_done ) AND g_chkey='N' THEN           
     CALL cl_set_comp_entry("apw01",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570108 --end           
