# Prog. Version..: '5.30.06-13.04.22(00008)'     #
#
# Pattern name...: anmi001.4gl
# Descriptions...: 內部帳戶資料維護作業
# Date & Author..: 06/09/22 By Ray
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.FUN-790050 07/07/10 By Carrier _out()轉p_query實現
# Modify.........: No.TQC-790091 07/09/17 By Mandy Primary Key的關系,原本SQLCA.sqlcode重復的錯誤碼-239,在informix不適用
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9B0194 09/12/16 By Carrier 全行noentry时,带到下一行可edit的行
# Modify.........: No.TQC-A10060 10/01/11 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No.FUN-A50102 10/07/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_nac           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        nac01       LIKE nac_file.nac01,       #內部帳戶編號
        nac02       LIKE nac_file.nac02,       #內部帳戶簡稱
        nac03       LIKE nac_file.nac03,       #內部帳戶帳號
        nac04       LIKE nac_file.nac04,       #幣別
        nac05       LIKE nac_file.nac05,       #歸屬分公司編碼
        nac05_azp02 LIKE azp_file.azp02,       #歸屬分公司名稱
        nacacti     LIKE nac_file.nacacti      #資料有效碼
                    END RECORD,
    g_nac_t         RECORD                     #程式變數 (舊值)
        nac01       LIKE nac_file.nac01,       #內部帳戶編號
        nac02       LIKE nac_file.nac02,       #內部帳戶簡稱
        nac03       LIKE nac_file.nac03,       #內部帳戶帳號
        nac04       LIKE nac_file.nac04,       #幣別
        nac05       LIKE nac_file.nac05,       #歸屬分公司編碼
        nac05_azp02 LIKE azp_file.azp02,       #歸屬分公司名稱
        nacacti     LIKE nac_file.nacacti      #資料有效碼
                    END RECORD,
    g_wc,g_sql      STRING,                    
    g_rec_b         LIKE type_file.num5,       #單身筆數 
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT 
 
DEFINE g_forupd_sql STRING                     #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10      
DEFINE g_i          LIKE type_file.num5        #count/index for any purpose 
DEFINE g_msg        LIKE type_file.chr1000     #No.FUN-790050
DEFINE g_before_input_done  LIKE type_file.num5    
DEFINE g_edit       LIKE type_file.chr1        #No.TQC-9C0194
 
MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0082
DEFINE p_row,p_col   LIKE type_file.num5       
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間)  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
 
   LET p_row = 4 LET p_col = 11
   OPEN WINDOW i001_w AT p_row,p_col WITH FORM "anm/42f/anmi001"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
    LET g_wc = '1=1' CALL i001_b_fill(g_wc)
    CALL i001_menu()
    CLOSE WINDOW i001_w                 #結束畫面
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間)  #No.FUN-6A0082
         RETURNING g_time    #No.FUN-6A0082
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
         WHEN "output"
            IF cl_chk_act_auth() THEN
               #No.FUN-790050  --Begin
               #CALL i001_out()
               IF cl_null(g_wc) THEN LET g_wc = " 1=1" END IF
               LET g_msg = 'p_query "anmi001" "',g_wc CLIPPED,'"'
               CALL cl_cmdrun(g_msg)
               #No.FUN-790050  --End  
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nac),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i001_q()
   CALL i001_b_askkey()
END FUNCTION
 
FUNCTION i001_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT 
    l_n             LIKE type_file.num5,   #檢查重複用       
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否      
    p_cmd           LIKE type_file.chr1,   #處理狀態       
    l_allow_insert  LIKE type_file.num5,   #可新增否      
    l_allow_delete  LIKE type_file.num5    #可刪除否     
 
    LET g_action_choice = ""                                                    
 
    IF s_anmshut(0) THEN RETURN END IF
    LET l_allow_insert = cl_detail_input_auth('insert')                         
    LET l_allow_delete = cl_detail_input_auth('delete')               
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT nac01,nac02,nac03,nac04,nac05,'',nacacti FROM nac_file WHERE nac01=? FOR UPDATE" 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i001_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        INPUT ARRAY g_nac
            WITHOUT DEFAULTS
            FROM s_nac.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,           
                         INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)   
 
        BEFORE INPUT                                                            
         IF g_rec_b!=0 THEN
          CALL fgl_set_arr_curr(l_ac)                                           
         END IF
            
        BEFORE ROW
            LET p_cmd='u' 
            LET l_ac = ARR_CURR()
#           DISPLAY l_ac TO FORMONLY.cn3  
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
            LET p_cmd='u'
            LET g_nac_t.* = g_nac[l_ac].*  #BACKUP
            LET g_plant_new = g_nac_t.nac05                                                                                    
            #CALL s_getdbs()                   #FUN-A50102                                                                                      
            #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_new CLIPPED," nme_file ",  
            LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'nme_file'), #FUN-A50102              
                        " WHERE nme01 = '",g_nac_t.nac01,"'"                                                                    
 	        CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
            PREPARE nme_pre1 FROM g_sql                                                                                         
            DECLARE nme_cur1 CURSOR FOR nme_pre1                                                                                
            OPEN nme_cur1                                                                                                       
            FETCH nme_cur1 INTO l_n                                                                                             
            IF l_n <> 0 THEN
               CALL cl_err(g_nac_t.nac01,'anm-994',0)
            END IF
            LET g_before_input_done = FALSE                                 
            CALL i001_set_entry(p_cmd)                                      
            CALL i001_set_no_entry(p_cmd)                                   
            LET g_before_input_done = TRUE                                  
 
            BEGIN WORK
              OPEN i001_bcl USING g_nac_t.nac01
              IF STATUS THEN
                 CALL cl_err("OPEN i001_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i001_bcl INTO g_nac[l_ac].* 
                 IF SQLCA.sqlcode THEN
                     CALL cl_err(g_nac_t.nac01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                 END IF
                 SELECT azp02 INTO g_nac[l_ac].nac05_azp02
                   FROM azp_file
                  WHERE azp01 = g_nac[l_ac].nac05
                #IF SQLCA.sqlcode THEN
                #   CALL cl_err3("sel","azp_file",g_nac[l_ac].nac05,"",SQLCA.sqlcode,"","",1)
                #END IF
              END IF
              CALL cl_show_fld_cont()
              #No.TQC-9B0194  --Begin
              IF g_edit = 'N' THEN
                 LET l_ac = l_ac + 1
                 CALL fgl_set_arr_curr(l_ac)
              END IF
              #No.TQC-9B0194  --End  
           END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_before_input_done = FALSE                                     
            CALL i001_set_entry(p_cmd)                                          
            CALL i001_set_no_entry(p_cmd)                                       
            LET g_before_input_done = TRUE                                      
            INITIALIZE g_nac[l_ac].* TO NULL
            LET g_nac[l_ac].nacacti = 'Y'       #Body default
            LET g_nac_t.* = g_nac[l_ac].*         #新輸入資料
          
            CALL cl_show_fld_cont() 
            NEXT FIELD nac01
 
        AFTER INSERT                                                            
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            BEGIN WORK
            INSERT INTO nac_file(nac01,nac02,nac03,nac04,nac05,
                                 nacacti,nacuser,nacdate,nacoriu,nacorig)
            VALUES(g_nac[l_ac].nac01,g_nac[l_ac].nac02,g_nac[l_ac].nac03,
                   g_nac[l_ac].nac04,g_nac[l_ac].nac05,g_nac[l_ac].nacacti,     
                   g_user,g_today, g_user, g_grup)      #No.FUN-980030 10/01/04  insert columns oriu, orig
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","nac_file",g_nac[l_ac].nac01,"",SQLCA.sqlcode,"","",1)
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
               CALL i001_ins_nma()
               IF g_success = 'Y' THEN
                  MESSAGE 'INSERT O.K'
                  LET g_rec_b=g_rec_b+1
                  DISPLAY g_rec_b TO FORMONLY.cn2  
               ELSE
                  INITIALIZE g_nac[l_ac].* TO NULL
                  ROLLBACK WORK
                  CANCEL INSERT
               END IF
            END IF
 
        AFTER FIELD nac01                        #check 編號是否重複
            IF g_nac[l_ac].nac01 != g_nac_t.nac01 OR
               (g_nac[l_ac].nac01 IS NOT NULL AND g_nac_t.nac01 IS NULL) THEN
                SELECT count(*) INTO l_n FROM nac_file
                    WHERE nac01 = g_nac[l_ac].nac01
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_nac[l_ac].nac01 = g_nac_t.nac01
                    NEXT FIELD nac01
                END IF
            END IF
 
	AFTER FIELD nac03
            IF cl_null(g_nac[l_ac].nac03) THEN
               CALL cl_err(g_nac[l_ac].nac03,'anm-992',0)
               NEXT FIELD nac03
            END IF
               
        AFTER FIELD nac04
            IF NOT cl_null(g_nac[l_ac].nac04) THEN
               SELECT COUNT(azi01) INTO l_n FROM azi_file
                WHERE azi01 = g_nac[l_ac].nac04
               IF l_n = 0 THEN
                  CALL cl_err(g_nac[l_ac].nac04,'axs-001',0)
                  NEXT FIELD nac04
               END IF
            END IF
 
        AFTER FIELD nac05
            IF NOT cl_null(g_nac[l_ac].nac05) THEN
               CALL i001_nac05(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nac[l_ac].nac05,g_errno,1)
                  LET g_nac[l_ac].nac05 = g_nac_t.nac05
                  DISPLAY BY NAME g_nac[l_ac].nac05
                  NEXT FIELD nac05
               END IF
            END IF
  
        BEFORE DELETE                            #是否取消單身
            IF g_nac_t.nac01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                LET g_plant_new = g_nac_t.nac05  
                #CALL s_getdbs()                  #FUN-A50102
                #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_new CLIPPED," nme_file ",
                LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'nme_file'), #FUN-A50102
                            " WHERE nme01 = '",g_nac_t.nac01,"'"
 	            CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
                PREPARE del_pre1 FROM g_sql                                                                                         
                DECLARE del_cur1 CURSOR FOR del_pre1                                                                                
                OPEN del_cur1                                                                                                       
                FETCH del_cur1 INTO l_n
                IF l_n <> 0 THEN
                   CALL cl_err('','anm-993',1)
                   CANCEL DELETE
                ELSE   
                   DELETE FROM nac_file WHERE nac01 = g_nac_t.nac01
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("del","nac_file",g_nac_t.nac01,"",SQLCA.sqlcode,"","",1)
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
   
                   #LET g_sql = "DELETE FROM ",g_dbs_new CLIPPED," nma_file ",
                   LET g_sql = "DELETE FROM ",cl_get_target_table(g_plant_new,'nma_file'), #FUN-A50102
                               " WHERE nma01 = '",g_nac_t.nac01,"'"
 	               CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
                   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
                   PREPARE nma_del_pre FROM g_sql
                   EXECUTE nma_del_pre
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("del","nma_file",g_nac_t.nac01,"",SQLCA.sqlcode,"","",1)
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                   LET g_rec_b=g_rec_b-1
                   DISPLAY g_rec_b TO FORMONLY.cn2  
                   MESSAGE "Delete OK"                                             
                   CLOSE i001_bcl         
                   COMMIT WORK
               END IF
            END IF
 
        ON ROW CHANGE                                                           
          IF INT_FLAG THEN          
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_nac[l_ac].* = g_nac_t.*
               CLOSE i001_bcl   
               ROLLBACK WORK     
               EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN                                               
             CALL cl_err(g_nac[l_ac].nac01,-263,1)                            
             LET g_nac[l_ac].* = g_nac_t.*                                      
          ELSE                                      
             UPDATE nac_file SET nac01 = g_nac[l_ac].nac01,
                                 nac02 = g_nac[l_ac].nac02,
                                 nac03 = g_nac[l_ac].nac03,
                                 nac04 = g_nac[l_ac].nac04,
                                 nac05 = g_nac[l_ac].nac05,
                                 nacacti = g_nac[l_ac].nacacti,
                                 nacmodu = g_user,
                                 nacdate = g_today
              WHERE nac01=g_nac_t.nac01
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","nac_file",g_nac_t.nac01,"",SQLCA.sqlcode,"","",1)
                LET g_nac[l_ac].* = g_nac_t.*
             ELSE
                MESSAGE 'UPDATE O.K'
                CLOSE i001_bcl         
                UPDATE nma_file SET nma02 = g_nac[l_ac].nac02,
                                    nma03 = g_nac[l_ac].nac02,
                                    nma04 = g_nac[l_ac].nac03,
                                    nma10 = g_nac[l_ac].nac04,
                                    nmaacti = g_nac[l_ac].nacacti
                WHERE nma01 = g_nac_t.nac01
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","nma_file",g_nac_t.nac01,"",SQLCA.sqlcode,"","",0)
                END IF
             END IF
          END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET g_nac[l_ac].* = g_nac_t.*
             #FUN-D30032--add--str--
             ELSE
                CALL g_nac.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30032--add--end-- 
             END IF
             CLOSE i001_bcl                                                     
             ROLLBACK WORK  
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac                                                     
          CLOSE i001_bcl                                                        
          COMMIT WORK   
 
        ON ACTION CONTROLP
           CASE 
              WHEN INFIELD(nac04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.default1 = g_nac[l_ac].nac04
                  CALL cl_create_qry() RETURNING g_nac[l_ac].nac04
                  DISPLAY BY NAME g_nac[l_ac].nac04
                  NEXT FIELD nac04
              WHEN INFIELD(nac05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azp"
                  LET g_qryparam.default1 = g_nac[l_ac].nac05
                  CALL cl_create_qry() RETURNING g_nac[l_ac].nac05
                  DISPLAY BY NAME g_nac[l_ac].nac05
                  NEXT FIELD nac05
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLN
            CALL i001_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(nac01) AND l_ac > 1 THEN
                LET g_nac[l_ac].* = g_nac[l_ac-1].*
                NEXT FIELD nac01
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
 
        ON ACTION about    
           CALL cl_about()
 
        ON ACTION help   
           CALL cl_show_help()
 
        END INPUT
 
    CLOSE i001_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i001_b_askkey()
    CLEAR FORM
    CALL g_nac.clear()
    CONSTRUCT g_wc ON nac01,nac02,nac03,nac04,nac05,nacacti
            FROM s_nac[1].nac01,s_nac[1].nac02,s_nac[1].nac03,s_nac[1].nac04
			       ,s_nac[1].nac05,s_nac[1].nacacti
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(nac04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azi" 
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO nac04
                NEXT FIELD nac04
            WHEN INFIELD(nac05)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azp" 
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO nac05
                NEXT FIELD nac05
             OTHERWISE
                EXIT CASE
         END CASE
 
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
 
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nacuser', 'nacgrup') #FUN-980030
 
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i001_b_fill(g_wc)
 
END FUNCTION
 
FUNCTION i001_b_fill(p_wc2)        #BODY FILL UP
DEFINE
#    p_wc2   LIKE type_file.chr1000
     p_wc2  STRING     #NO.FUN-910082
 
    LET g_sql =
        "SELECT nac01,nac02,nac03,nac04,nac05,'',nacacti",
        " FROM nac_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY nac01"
    PREPARE i001_pb FROM g_sql
    DECLARE nac_curs CURSOR FOR i001_pb
 
    FOR g_cnt = 1 TO g_nac.getLength() 
       INITIALIZE g_nac[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH nac_curs INTO g_nac[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT azp02 INTO g_nac[g_cnt].nac05_azp02
          FROM azp_file
         WHERE azp01 = g_nac[g_cnt].nac05
       #IF SQLCA.sqlcode THEN
       #   CALL cl_err3("sel","azp_file",g_nac[g_cnt].nac05,"",SQLCA.sqlcode,"","",1)
       #END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_nac.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nac TO s_nac.*  ATTRIBUTE(COUNT=g_rec_b)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
 
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
         CALL cl_show_fld_cont()  
 
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
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"                                             
         EXIT DISPLAY                                                           
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about     
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i001_ins_nma()
    DEFINE l_nma        RECORD LIKE nma_file.*
    DEFINE 
           #l_sql        LIKE type_file.chr1000
           l_sql        STRING       #NO.FUN-910082
 
    LET g_success = 'Y'
    LET g_plant_new = g_nac[l_ac].nac05  
    #CALL s_getdbs()                      #FUN-A50102
    #LET l_sql = "INSERT INTO ",g_dbs_new," nma_file",
    LET l_sql = "INSERT INTO ",cl_get_target_table(g_plant_new,'nma_file'), #FUN-A50102
                "  (nma01   , ",
                "   nma02   , ",
                "   nma03   , ",
                "   nma04   , ",
                "   nma10   , ",
                "   nma22   , ",
                "   nma23   , ",
                "   nma24   , ",
                "   nma25   , ",
                "   nma26   , ",
                "   nma27   , ",
                "   nma28   , ",
                "   nma37   , ",
                "   nma38   , ",
                "   nmaacti , ",
                "   nmauser , ",
                "   nmagrup , ",
                "   nmaoriu , ",        #TQC-A10060  add
                "   nmaorig , ",        #TQC-A10060  add
                "   nmadate)  ",        
                "    VALUES(?,?,?,?,?,?,?,?,?, ",
                "           ?,?,?,?,?,?,?,?,?,?,?) "        #TQC-A10060  add ?,?
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE nma_ins_pre FROM l_sql
 
    INITIALIZE l_nma.* TO NULL
    LET l_nma.nma01 = g_nac[l_ac].nac01
    LET l_nma.nma02 = g_nac[l_ac].nac02
    LET l_nma.nma03 = g_nac[l_ac].nac02
    LET l_nma.nma04 = g_nac[l_ac].nac03
    LET l_nma.nma10 = g_nac[l_ac].nac04 
    LET l_nma.nma22 = 0
    LET l_nma.nma23 = 0
    LET l_nma.nma24 = 0
    LET l_nma.nma25 = 0
    LET l_nma.nma26 = 0
    LET l_nma.nma27 = 0
    LET l_nma.nma28 = '3'
    LET l_nma.nma37 = '0'
    LET l_nma.nma38 = g_plant
    LET l_nma.nmaacti = g_nac[l_ac].nacacti
    LET l_nma.nmauser = g_user
    LET l_nma.nmagrup = g_grup
    LET l_nma.nmaoriu = g_user     #TQC-A10060  add
    LET l_nma.nmaorig = g_grup     #TQC-A10060  add
    LET l_nma.nmadate = g_today
  
    EXECUTE nma_ins_pre USING
              l_nma.nma01   ,
              l_nma.nma02   ,
              l_nma.nma03   ,
              l_nma.nma04   ,
              l_nma.nma10   ,
              l_nma.nma22   ,
              l_nma.nma23   ,
              l_nma.nma24   ,
              l_nma.nma25   ,
              l_nma.nma26   ,
              l_nma.nma27   ,
              l_nma.nma28   ,
              l_nma.nma37   ,
              l_nma.nma38   ,
              l_nma.nmaacti ,
              l_nma.nmauser ,
              l_nma.nmagrup ,
              l_nma.nmaoriu ,    #TQC-A10060  add
              l_nma.nmaorig ,    #TQC-A10060  add
              l_nma.nmadate  
    IF SQLCA.sqlcode THEN
      #IF SQLCA.sqlcode = -239 THEN             #TQC-790091 mark
       IF cl_sql_dup_value(SQLCA.sqlcode) THEN  #TQC-790091 mod
          CALL cl_err(l_nma.nma01,'anm-982',1)
          LET g_success='N'
          RETURN
       ELSE
          CALL cl_err('ins nma',STATUS,1)
          LET g_success='N'
          RETURN
       END IF
    END IF
 
END FUNCTION
 
#No.FUN-790050  --Begin
#FUNCTION i001_out()
#    DEFINE
#        l_nac           RECORD LIKE nac_file.*,
#        l_i             LIKE type_file.num5,  
#        l_name          LIKE type_file.chr20,    # External(Disk) file name
#        l_za05          LIKE type_file.chr1000
#   
#    IF g_wc IS NULL THEN
#       CALL cl_err('','9057',0) 
#       RETURN 
#    END IF
#    CALL cl_wait()
#    CALL cl_outnam('anmi001') RETURNING l_name
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    LET g_sql="SELECT * FROM nac_file ",          # 組合出 SQL 指令
#              " WHERE ",g_wc CLIPPED
#    PREPARE i001_p1 FROM g_sql                # RUNTIME 編譯
#    DECLARE i001_co CURSOR FOR i001_p1
#
#    START REPORT i001_rep TO l_name
#
#    FOREACH i001_co INTO l_nac.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
#            EXIT FOREACH
#        END IF
#        OUTPUT TO REPORT i001_rep(l_nac.*)
#    END FOREACH
#
#    FINISH REPORT i001_rep
#
#    CLOSE i001_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#END FUNCTION
#
#REPORT i001_rep(sr)
#    DEFINE
#        l_trailer_sw    LIKE type_file.chr1,  
#        sr              RECORD LIKE nac_file.*,
#        l_azp02         LIKE azp_file.azp02,
#        l_chr           LIKE type_file.chr1   
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.nac01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno=g_pageno+1
#            LET pageno_total=PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,g_x[35] CLIPPED,g_x[37] CLIPPED,g_x[36] CLIPPED
#            PRINT g_dash1
#            LET l_trailer_sw = 'y'
#
#        ON EVERY ROW
#            SELECT azp02 INTO l_azp02 FROM azp_file where azp01 = sr.nac05
#            PRINT COLUMN g_c[31],sr.nac01,
#                  COLUMN g_c[32],sr.nac02,
#                  COLUMN g_c[33],sr.nac03,
#                  COLUMN g_c[34],sr.nac04,
#                  COLUMN g_c[35],sr.nac05,
#                  COLUMN g_c[37],l_azp02 CLIPPED,
#                  COLUMN g_c[36],sr.nacacti
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            LET l_trailer_sw = 'n'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#        PAGE TRAILER
#            IF l_trailer_sw = 'y' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-790050  --End  
 
FUNCTION i001_nac05(p_cmd)
  DEFINE p_cmd     LIKE type_file.chr1   
         
  SELECT azp02 INTO g_nac[l_ac].nac05_azp02
    FROM azp_file
   WHERE azp01 = g_nac[l_ac].nac05
 
   CASE WHEN SQLCA.SQLCODE = 100 
                           LET g_errno = 'anm-981'
                           LET g_nac[l_ac].nac05_azp02 = NULL
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
                                                                                                                                    
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY BY NAME g_nac[l_ac].nac05_azp02
   END IF
 
END FUNCTION
                                                                                
FUNCTION i001_set_entry(p_cmd)                                                  
  DEFINE p_cmd     LIKE type_file.chr1  
  DEFINE l_n     LIKE type_file.num5  
 
   IF p_cmd='a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("nac01,nac05",TRUE)
   END IF                                                                       
   IF p_cmd = 'u' THEN
      #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_new CLIPPED," nme_file ",
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'nme_file'), #FUN-A50102      
                  " WHERE nme01 = '",g_nac_t.nac01,"'"                                                                    
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE nme_pre2 FROM g_sql                                                                                         
      DECLARE nme_cur2 CURSOR FOR nme_pre2                                                                                
      OPEN nme_cur2                                                                                                       
      FETCH nme_cur2 INTO l_n                                                                                             
      IF l_n = 0 THEN
         CALL cl_set_comp_entry("nac01,nac02,nac03,nac04,nac05,nacacti",TRUE)
      END IF
   END IF
    
END FUNCTION                                                                    
                                                                                
FUNCTION i001_set_no_entry(p_cmd)                                               
  DEFINE p_cmd   LIKE type_file.chr1  
  DEFINE l_n     LIKE type_file.num5  
                                                                                
   LET g_edit = 'Y'   #No.TQC-9B0194
   IF p_cmd='u' AND  ( NOT g_before_input_done ) AND g_chkey='N' THEN           
     CALL cl_set_comp_entry("nac01",FALSE)                                      
   END IF                                                                       
   IF p_cmd='u' THEN
      LET g_plant_new = g_nac_t.nac05                                                                                     
      #CALL s_getdbs()               #FUN-A50102
      #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_new CLIPPED," nma_file ",
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'nma_file'), #FUN-A50102 
                  " WHERE nma01 = '",g_nac_t.nac01,"'" 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE nma_pre1 FROM g_sql                                                                                         
      DECLARE nma_cur1 CURSOR FOR nma_pre1                                                                                
      OPEN nma_cur1                                                                                                       
      FETCH nma_cur1 INTO l_n
      IF l_n <> 0 THEN
         CALL cl_set_comp_entry("nac05",FALSE)
      END IF
      #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_new CLIPPED," nme_file ", 
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_plant_new,'nme_file'), #FUN-A50102     
                  " WHERE nme01 = '",g_nac_t.nac01,"'"                                                                    
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE nme_pre3 FROM g_sql                                                                                         
      DECLARE nme_cur3 CURSOR FOR nme_pre3                                                                                
      OPEN nme_cur3                                                                                                       
      FETCH nme_cur3 INTO l_n                                                                                             
      IF l_n <> 0 THEN
         CALL cl_set_comp_entry("nac01,nac02,nac03,nac04,nac05,nacacti",FALSE)
         LET g_edit = 'N'   #No.TQC-9B0194
      END IF
   END IF
 
END FUNCTION                                                                    
