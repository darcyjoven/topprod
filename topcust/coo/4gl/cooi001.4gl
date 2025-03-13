# Prog. Version..: '5.30.06-13.04.22(00006)'     #
#
# Pattern name...: cooi001.4gl
# Descriptions...: 单据追踪范围維護作業
# Date & Author..: 13/12/11 By chuyl

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE 
    g_tc_gee           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        tc_gee01       LIKE tc_gee_file.tc_gee01,  
        tc_gee02       LIKE tc_gee_file.tc_gee02,
        tc_gee03       LIKE tc_gee_file.tc_gee03,
        tc_gee04       LIKE tc_gee_file.tc_gee04,
        tc_gee05       LIKE tc_gee_file.tc_gee05, 
        tc_gee06       LIKE tc_gee_file.tc_gee06,
        tc_gee07       LIKE tc_gee_file.tc_gee07, 
        tc_gee08       LIKE tc_gee_file.tc_gee08,
        tc_gee09       LIKE tc_gee_file.tc_gee09,
        tc_gee12       LIKE tc_gee_file.tc_gee12,
        tc_gee10       LIKE tc_gee_file.tc_gee10,
        tc_gee11       LIKE tc_gee_file.tc_gee11,
        tc_geeacti     LIKE type_file.chr1
                    END RECORD,
    g_tc_gee_t         RECORD                 #程式變數 (舊值)
        tc_gee01       LIKE tc_gee_file.tc_gee01,  
        tc_gee02       LIKE tc_gee_file.tc_gee02,
        tc_gee03       LIKE tc_gee_file.tc_gee03,
        tc_gee04       LIKE tc_gee_file.tc_gee04,
        tc_gee05       LIKE tc_gee_file.tc_gee05, 
        tc_gee06       LIKE tc_gee_file.tc_gee06,
        tc_gee07       LIKE tc_gee_file.tc_gee07, 
        tc_gee08       LIKE tc_gee_file.tc_gee08,
        tc_gee09       LIKE tc_gee_file.tc_gee09,
        tc_gee12       LIKE tc_gee_file.tc_gee12,
        tc_gee10       LIKE tc_gee_file.tc_gee10,
        tc_gee11       LIKE tc_gee_file.tc_gee11,
        tc_geeacti     LIKE type_file.chr1
                    END RECORD,
     g_wc2,g_sql    STRING,  #No.FUN-580092 HCN     
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5          #No.FUN-680137 SMALLINT
 
DEFINE g_forupd_sql STRING  #SELECT ... FOR UPDATE SQL 
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680137 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570109          #No.FUN-680137 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0094
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("COO")) THEN
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
        RETURNING g_time
   LET p_row = 3 LET p_col = 13

   OPEN WINDOW i001_w AT p_row,p_col WITH FORM "coo/42f/cooi001"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

   CALL cl_ui_init()

   CALL i001_menu()
   CLOSE WINDOW i001_w                 #結束畫面
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
        RETURNING g_time    #No.FUN-6A0094
END MAIN
 
FUNCTION i001_menu()
 
   WHILE TRUE
      CALL i001_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i001_q() 
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i001_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         --WHEN "output" 
            --IF cl_chk_act_auth() THEN
               --CALL i001_out()
            --END IF
         WHEN "from_excel"
            IF cl_chk_act_auth() THEN 
               CALL i001_from_excel()
            END IF 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_tc_gee),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i001_q()
   CALL i001_b_askkey()
END FUNCTION
 
FUNCTION i001_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680137 SMALLINT
DEFINE   li_inx     LIKE type_file.num5
DEFINE   ls_str     STRING
DEFINE   ls_sql     STRING 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT tc_gee01,tc_gee02,tc_gee03,tc_gee04,tc_gee05,tc_gee06,tc_gee07,tc_gee08,",
    "tc_gee09,tc_gee12,tc_gee10,tc_gee11,tc_geeacti FROM tc_gee_file WHERE tc_gee01=? AND tc_gee02=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i001_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_tc_gee WITHOUT DEFAULTS FROM s_tc_gee.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
            
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
             CALL cl_set_combo_module('tc_gee01','1')
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_tc_gee_t.* = g_tc_gee[l_ac].*  #BACKUP
 
#No.FUN-570109 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i001_set_entry_b(p_cmd)                                                                                         
               CALL i001_set_no_entry_b(p_cmd)                                                                                      
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--  
               BEGIN WORK
 
               OPEN i001_bcl USING g_tc_gee_t.tc_gee01,g_tc_gee_t.tc_gee02
               IF STATUS THEN
                  CALL cl_err("OPEN i001_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE  
                  FETCH i001_bcl INTO g_tc_gee[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_tc_gee_t.tc_gee01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO tc_gee_file(tc_gee01,tc_gee02,tc_gee03,tc_gee04,tc_gee05,tc_gee06,tc_gee07,
                     tc_gee08,tc_gee09,tc_gee10,tc_gee11,tc_gee12,tc_geeacti)
              VALUES(g_tc_gee[l_ac].tc_gee01,g_tc_gee[l_ac].tc_gee02,g_tc_gee[l_ac].tc_gee03,
                 g_tc_gee[l_ac].tc_gee04,g_tc_gee[l_ac].tc_gee05,g_tc_gee[l_ac].tc_gee06,g_tc_gee[l_ac].tc_gee07,
                  g_tc_gee[l_ac].tc_gee08,g_tc_gee[l_ac].tc_gee09,g_tc_gee[l_ac].tc_gee10,g_tc_gee[l_ac].tc_gee11,
                  g_tc_gee[l_ac].tc_gee12,g_tc_gee[l_ac].tc_geeacti)
              IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_tc_gee[l_ac].tc_gee01,SQLCA.sqlcode,0)   #No.FUN-660167
                  CALL cl_err3("ins","tc_gee_file",g_tc_gee[l_ac].tc_gee01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                  CANCEL INSERT
              ELSE
                  MESSAGE 'INSERT O.K'
                  LET g_rec_b=g_rec_b+1
                  DISPLAY g_rec_b TO FORMONLY.cn2  
              END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start--                                                                                                            
            LET g_before_input_done = FALSE                                                                                      
            CALL i001_set_entry_b(p_cmd)                                                                                         
            CALL i001_set_no_entry_b(p_cmd)                                                                                      
            LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end--  
            INITIALIZE g_tc_gee[l_ac].* TO NULL      #900423
            LET g_tc_gee[l_ac].tc_geeacti = 'Y'
            LET g_tc_gee_t.* = g_tc_gee[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
 
        AFTER FIELD tc_gee01                        #check 編號是否重複
            IF g_tc_gee[l_ac].tc_gee01 IS NOT NULL THEN
            IF g_tc_gee[l_ac].tc_gee01 != g_tc_gee_t.tc_gee01 OR
               (g_tc_gee[l_ac].tc_gee01 IS NOT NULL AND g_tc_gee_t.tc_gee01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM tc_gee_file
                    WHERE tc_gee01 = g_tc_gee[l_ac].tc_gee01
                    AND tc_gee02 = g_tc_gee[l_ac].tc_gee02
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_tc_gee[l_ac].tc_gee01 = g_tc_gee_t.tc_gee01
                    NEXT FIELD tc_gee01
                END IF
            END IF
            END IF

        AFTER FIELD tc_gee02
            IF g_tc_gee[l_ac].tc_gee02 IS NOT NULL THEN
            IF g_tc_gee[l_ac].tc_gee02 != g_tc_gee_t.tc_gee02 OR
               (g_tc_gee[l_ac].tc_gee02 IS NOT NULL AND g_tc_gee_t.tc_gee02 IS NULL) THEN
                SELECT count(*) INTO l_n FROM tc_gee_file
                    WHERE tc_gee01 = g_tc_gee[l_ac].tc_gee01
                    AND tc_gee02 = g_tc_gee[l_ac].tc_gee02
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_tc_gee[l_ac].tc_gee02 = g_tc_gee_t.tc_gee02
                    NEXT FIELD tc_gee02
                END IF
                SELECT gee05 INTO g_tc_gee[l_ac].tc_gee03 FROM gee_file WHERE gee01 =  g_tc_gee[l_ac].tc_gee01
                AND gee02 = g_tc_gee[l_ac].tc_gee02 AND gee03 = '2'
            END IF
            END IF
            
        BEFORE DELETE                            #是否取消單身
            IF g_tc_gee_t.tc_gee01 IS NOT NULL AND g_tc_gee_t.tc_gee02 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                # genero shell add end
{ckp#1}         DELETE FROM tc_gee_file WHERE tc_gee01 = g_tc_gee_t.tc_gee01
                       AND tc_gee02 = g_tc_gee_t.tc_gee02
                      
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_tc_gee_t.tc_gee01,SQLCA.sqlcode,0) #No.FUN-660167
                   CALL cl_err3("del","tc_gee_file",g_tc_gee_t.tc_gee01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"
                CLOSE i001_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_tc_gee[l_ac].* = g_tc_gee_t.*
               CLOSE i001_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_tc_gee[l_ac].tc_gee01,-263,1)
               LET g_tc_gee[l_ac].* = g_tc_gee_t.*
            ELSE
               UPDATE tc_gee_file SET tc_gee01=g_tc_gee[l_ac].tc_gee01,
                                   tc_gee02=g_tc_gee[l_ac].tc_gee02,
                                   tc_gee03=g_tc_gee[l_ac].tc_gee03,
                                   tc_gee04=g_tc_gee[l_ac].tc_gee04,
                                   tc_gee05=g_tc_gee[l_ac].tc_gee05,
                                   tc_gee06=g_tc_gee[l_ac].tc_gee06,
                                   tc_gee07=g_tc_gee[l_ac].tc_gee07,
                                   tc_gee08=g_tc_gee[l_ac].tc_gee08,
                                   tc_gee09=g_tc_gee[l_ac].tc_gee09,
                                   tc_gee10=g_tc_gee[l_ac].tc_gee10,
                                   tc_gee11=g_tc_gee[l_ac].tc_gee11,
                                   tc_gee12=g_tc_gee[l_ac].tc_gee12,
                                   tc_geeacti=g_tc_gee[l_ac].tc_geeacti
                WHERE tc_gee01 = g_tc_gee_t.tc_gee01
                       AND tc_gee02 = g_tc_gee_t.tc_gee02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_tc_gee[l_ac].tc_gee01,SQLCA.sqlcode,0)   #No.FUN-660167
                    CALL cl_err3("upd","tc_gee_file",g_tc_gee_t.tc_gee01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                    LET g_tc_gee[l_ac].* = g_tc_gee_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    CLOSE i001_bcl
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac   #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_tc_gee[l_ac].* = g_tc_gee_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_tc_gee.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i001_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30034 add
            CLOSE i001_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i001_b_askkey()
            EXIT INPUT

        ON ACTION controlp 
           CASE 
             WHEN INFIELD(tc_gee04)
                 CALL cl_init_qry_var() 
                 LET g_qryparam.form ="q_gat"
                 LET g_qryparam.arg1 = g_lang
                 LET g_qryparam.where= " gat07 = 'T' "
                 LET g_qryparam.default1 = g_tc_gee[l_ac].tc_gee04
                 CALL cl_create_qry() RETURNING g_tc_gee[l_ac].tc_gee04
                 DISPLAY BY NAME g_tc_gee[l_ac].tc_gee04
                 NEXT FIELD tc_gee04
             WHEN INFIELD (tc_gee05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gaq"
                 LET g_qryparam.arg1 = g_lang
                 LET ls_str =  g_tc_gee[l_ac].tc_gee04
                 LET li_inx = ls_str.getIndexOf("_file",1)
                 IF li_inx >= 1 THEN
                    LET ls_str = ls_str.subString(1,li_inx - 1)
                 ELSE
                    LET ls_str = ""
                 END IF
                 LET g_qryparam.arg2 = ls_str
                 LET g_qryparam.default1= g_tc_gee[l_ac].tc_gee05
                 CALL cl_create_qry() RETURNING g_tc_gee[l_ac].tc_gee05
                 DISPLAY BY NAME g_tc_gee[l_ac].tc_gee05
                 NEXT FIELD tc_gee05
             WHEN INFIELD (tc_gee06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gaq"
                 LET g_qryparam.arg1 = g_lang
                 LET ls_str =  g_tc_gee[l_ac].tc_gee04
                 LET li_inx = ls_str.getIndexOf("_file",1)
                 IF li_inx >= 1 THEN
                    LET ls_str = ls_str.subString(1,li_inx - 1)
                 ELSE
                    LET ls_str = ""
                 END IF
                 LET g_qryparam.arg2 = ls_str
                 LET g_qryparam.default1= g_tc_gee[l_ac].tc_gee06
                 CALL cl_create_qry() RETURNING g_tc_gee[l_ac].tc_gee06
                 DISPLAY BY NAME g_tc_gee[l_ac].tc_gee06
                 NEXT FIELD tc_gee06             
             WHEN INFIELD (tc_gee08)
                  CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gaq"
                 LET g_qryparam.arg1 = g_lang
                 LET ls_str =  g_tc_gee[l_ac].tc_gee04
                 LET li_inx = ls_str.getIndexOf("_file",1)
                 IF li_inx >= 1 THEN
                    LET ls_str = ls_str.subString(1,li_inx - 1)
                 ELSE
                    LET ls_str = ""
                 END IF
                 LET g_qryparam.arg2 = ls_str
                 LET g_qryparam.default1= g_tc_gee[l_ac].tc_gee08
                 CALL cl_create_qry() RETURNING g_tc_gee[l_ac].tc_gee08
                 DISPLAY BY NAME g_tc_gee[l_ac].tc_gee08
                 NEXT FIELD tc_gee08                     
             WHEN INFIELD (tc_gee10)
                CALL cl_init_qry_var() 
                 LET g_qryparam.form ="q_gat"
                 LET g_qryparam.arg1 = g_lang
                 LET g_qryparam.where= " gat07 = 'T' "
                 LET g_qryparam.default1 = g_tc_gee[l_ac].tc_gee10
                 CALL cl_create_qry() RETURNING g_tc_gee[l_ac].tc_gee10
                 DISPLAY BY NAME g_tc_gee[l_ac].tc_gee10
                 NEXT FIELD tc_gee10
            WHEN INFIELD (tc_gee12)
                  CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gaq"
                 LET g_qryparam.arg1 = g_lang
                 LET ls_str =  g_tc_gee[l_ac].tc_gee04
                 LET li_inx = ls_str.getIndexOf("_file",1)
                 IF li_inx >= 1 THEN
                    LET ls_str = ls_str.subString(1,li_inx - 1)
                 ELSE
                    LET ls_str = ""
                 END IF
                 LET g_qryparam.arg2 = ls_str
                 LET g_qryparam.default1= g_tc_gee[l_ac].tc_gee12
                 CALL cl_create_qry() RETURNING g_tc_gee[l_ac].tc_gee12
                 DISPLAY BY NAME g_tc_gee[l_ac].tc_gee12
                 NEXT FIELD tc_gee12      
             OTHERWISE EXIT CASE 
           END CASE 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(tc_gee01) AND l_ac > 1 THEN
                LET g_tc_gee[l_ac].* = g_tc_gee[l_ac-1].*
                NEXT FIELD tc_gee01
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
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
 
    CLOSE i001_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i001_b_askkey()
    CLEAR FORM
    CALL g_tc_gee.clear()
    CALL cl_set_combo_module('tc_gee01','1')
    CONSTRUCT g_wc2 ON tc_gee01,tc_gee02
            FROM s_tc_gee[1].tc_gee01,s_tc_gee[1].tc_gee02
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
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
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i001_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i001_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(200)
 
    LET g_sql =
        "SELECT tc_gee01,tc_gee02,tc_gee03,tc_gee04,tc_gee05,tc_gee06,tc_gee07,",
        "tc_gee08,tc_gee09,tc_gee12,tc_gee10,tc_gee11,tc_geeacti",
        " FROM tc_gee_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY tc_gee01,tc_gee02"
    PREPARE i001_pb FROM g_sql
    DECLARE tc_gee_curs CURSOR FOR i001_pb
 
    CALL g_tc_gee.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH tc_gee_curs INTO g_tc_gee[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
     
    END FOREACH
    CALL g_tc_gee.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_tc_gee TO s_tc_gee.* ATTRIBUTE(COUNT=g_rec_b)
 
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
         LET l_ac = 1
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
   ON ACTION from_excel
      LET g_action_choice="from_excel"
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
 
   
   ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

 
#No.FUN-570109 --start--                                                                                                            
FUNCTION i001_set_entry_b(p_cmd)                                                                                                    
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("tc_gee01,tc_gee02",TRUE)                                                                                           
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i001_set_no_entry_b(p_cmd)                                                                                                 
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1       #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("tc_gee01,tc_gee02",FALSE)                                                                                          
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570109 --end--
FUNCTION i001_from_excel()
DEFINE p_mmg01      LIKE mmg_file.mmg01
DEFINE p_mmg02      LIKE mmg_file.mmg02

     
   OPEN WINDOW i001_w1 AT 4,12 WITH FORM "coo/42f/cooi0011"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
      
   CALL cl_ui_locale("cooi0011")
     
   CALL i001_excel_tm()  
        
   CLOSE WINDOW i001_w1 
END FUNCTION

FUNCTION i001_excel_tm()
DEFINE l_file LIKE ze_file.ze03

   WHILE TRUE

      INPUT l_file WITHOUT DEFAULTS FROM FORMONLY.file_1

         ON CHANGE file_1
            LET l_file = GET_FLDBUF(file_1)

         AFTER FIELD file_1
            IF cl_null(l_file) THEN
               CALL cl_err('','',1)
               NEXT FIELD file_1
            END IF

         ON ACTION open_file
            LET l_file = cl_browse_file()
            DISPLAY l_file TO FORMONLY.file_1

         ON ACTION locale
            CALL cl_show_fld_cont()
            LET g_action_choice = "locale"

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT WHILE

         ON ACTION cancel
            LET INT_FLAG = 1
            EXIT WHILE

         ON ACTION accept
            IF NOT cl_null(l_file) THEN
               CALL i001_in_excel(l_file)
               EXIT WHILE
            END IF

      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG=FALSE
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION

FUNCTION i001_in_excel(p_fname)
   DEFINE l_tc_gee         RECORD
          tc_gee01       LIKE tc_gee_file.tc_gee01,  
        tc_gee02       LIKE tc_gee_file.tc_gee02,
        tc_gee03       LIKE tc_gee_file.tc_gee03,
        tc_gee04       LIKE tc_gee_file.tc_gee04,
        tc_gee05       LIKE tc_gee_file.tc_gee05, 
        tc_gee06       LIKE tc_gee_file.tc_gee06,
        tc_gee07       LIKE tc_gee_file.tc_gee07, 
        tc_gee08       LIKE tc_gee_file.tc_gee08,
        tc_gee09       LIKE tc_gee_file.tc_gee09,
        tc_gee10       LIKE tc_gee_file.tc_gee10,
        tc_gee11       LIKE tc_gee_file.tc_gee11,
        tc_gee12       LIKE tc_gee_file.tc_gee12,
        tc_geeacti     LIKE type_file.chr1
                    END RECORD
                    
   DEFINE p_file          STRING                 #表名
   DEFINE p_fname         STRING                 #本次汇入档名
   DEFINE l_cmd           LIKE type_file.chr1000
   DEFINE l_count         LIKE type_file.num5
   DEFINE l_num           LIKE type_file.num5
   DEFINE li_i_r          LIKE type_file.num5
   DEFINE li_flag         LIKE type_file.chr1  #读入完成否 Y:完成 N:未完成
   DEFINE l_fname         STRING               #本次汇入档名
   DEFINE l_sql           STRING
   DEFINE i               LIKE type_file.num5
   DEFINE l_cnt           LIKE type_file.num5
   DEFINE xlapp,iRes,iRow,j     INTEGER

   WHENEVER ERROR CALL cl_err_msg_log

   DROP TABLE i001_tmp
   CREATE TEMP TABLE i001_tmp(
        tc_gee01       LIKE tc_gee_file.tc_gee01,  
        tc_gee02       LIKE tc_gee_file.tc_gee02,
        tc_gee03       LIKE tc_gee_file.tc_gee03,
        tc_gee04       LIKE tc_gee_file.tc_gee04,
        tc_gee05       LIKE tc_gee_file.tc_gee05, 
        tc_gee06       LIKE tc_gee_file.tc_gee06,
        tc_gee07       LIKE tc_gee_file.tc_gee07, 
        tc_gee08       LIKE tc_gee_file.tc_gee08,
        tc_gee09       LIKE tc_gee_file.tc_gee09,
        tc_gee10       LIKE tc_gee_file.tc_gee10,
        tc_gee11       LIKE tc_gee_file.tc_gee11,
        tc_gee12       LIKE tc_gee_file.tc_gee12,
        tc_geeacti     LIKE type_file.chr1);
                  
   DELETE FROM i001_tmp
   LET l_cmd =  p_fname CLIPPED

   LET l_count = LENGTH(l_cmd)
   IF l_count = 0 THEN 
      RETURN 
   END IF 

   #取导入文件名称
   LET l_num = 0
   CALL cl_replace_str(l_cmd, "/", "\\") RETURNING l_fname

   MESSAGE p_fname,"资料导入中..."    #" File Analyze..."

   LET li_flag = 'N'
   LET li_i_r  = 2                    #从第二行开始
   LET g_success = 'Y'

   MESSAGE p_fname,"资料导入开始......"

   BEGIN WORK 

   CALL ui.interface.frontCall('WinCOM','CreateInstance',['Excel.Application'],[xlApp])
   IF xlApp <> -1 THEN
      CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'WorkBooks.Open',l_fname],[iRes])
      IF iRes <> -1 THEN
         CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.UsedRange.Rows.Count'],[iRow])
         IF iRow > 1 THEN
            FOR i = 2 TO iRow              #从第二行开始导入
                INITIALIZE l_tc_gee.* TO NULL
   
                MESSAGE "资料导入中...共",iRow USING '<<<<<&',"笔,当前第",i USING '<<<<<&',"笔,请耐心等待..."
   
                #导入数据
                   
                   CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',1).Value'],[l_tc_gee.tc_gee01])
                   CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',2).Value'],[l_tc_gee.tc_gee02])
                   CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',3).Value'],[l_tc_gee.tc_gee03])
                   CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',4).Value'],[l_tc_gee.tc_gee04])
                   CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',5).Value'],[l_tc_gee.tc_gee05])
                   CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',6).Value'],[l_tc_gee.tc_gee06])
                   CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',7).Value'],[l_tc_gee.tc_gee07])
                   CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',8).Value'],[l_tc_gee.tc_gee08])
                   CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',9).Value'],[l_tc_gee.tc_gee09])
                   CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',10).Value'],[l_tc_gee.tc_gee12])
                   CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',11).Value'],[l_tc_gee.tc_gee10])
                   CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',12).Value'],[l_tc_gee.tc_gee11])
                   CALL ui.interface.frontCall('WinCOM','GetProperty',[xlApp,'ActiveSheet.Cells('||i||',13).Value'],[l_tc_gee.tc_geeacti])

                  IF NOT cl_null(l_tc_gee.tc_gee01) AND NOT cl_null(l_tc_gee.tc_gee02) AND
                     g_success != 'N' THEN
                      INSERT INTO i001_tmp VALUES (l_tc_gee.*)
                      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                       CALL s_errmsg("tc_gee01",l_tc_gee.tc_gee01,'',SQLCA.sqlcode,1)
                       LET g_success = 'N'
                      END IF
                  END IF 
                 LET li_i_r = li_i_r + 1
            END FOR
         END IF
      ELSE 
         DISPLAY 'NO FILE_1'
         MESSAGE "未找到文件!"
      END IF
   ELSE
      DISPLAY 'NO EXCEL'
      MESSAGE "未找到相关文档!"
   END IF 
   
#131110 add luoyb str
   LET l_sql = " SELECT * ",
               "  FROM i001_tmp ",
               " ORDER BY tc_gee01,tc_gee02 "
 
   PREPARE i001_pb1_2 FROM l_sql
   DECLARE i001_curs_2 CURSOR FOR i001_pb1_2
 
   FOREACH i001_curs_2 INTO l_tc_gee.*

      IF cl_null(l_tc_gee.tc_gee01) OR cl_null(l_tc_gee.tc_gee02) THEN 
         CALL s_errmsg("tc_gee01",l_tc_gee.tc_gee01,'','-286',1)
         LET g_success = 'N'
      END IF 

      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM tc_gee_file
       WHERE tc_gee01 = l_tc_gee.tc_gee01
         AND tc_gee02 = l_tc_gee.tc_gee02

      IF l_cnt = 0 THEN  
         INSERT INTO tc_gee_file VALUES l_tc_gee.*
      ELSE 
         UPDATE tc_gee_file SET * = l_tc_gee.*
          WHERE tc_gee01 = l_tc_gee.tc_gee01
            AND tc_gee02 = l_tc_gee.tc_gee02
      END IF 
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err3("upd","tc_gee_file",l_tc_gee.tc_gee01,"",STATUS,"","",1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

   END FOREACH
   
   IF g_success = 'Y' THEN
      COMMIT WORK
      MESSAGE "excel导入完成!"
   ELSE
      ROLLBACK WORK
      MESSAGE "excel导入失败!"
   END IF

   IF g_success = 'N' THEN
      CALL s_showmsg()              #开启错误窗口
   END IF
   
   CALL ui.interface.frontCall('WinCOM','CallMethod',[xlApp,'Quit'],[iRes])
   CALL ui.interface.frontCall('WinCOM','ReleaseInstance',[xlApp],[iRes])
END FUNCTION 