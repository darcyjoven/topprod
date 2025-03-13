# Prog. Version..: '5.30.06-13.04.22(00009)'     #
#
# Pattern name...: axmi160.4gl
# Descriptions...: 產品客戶包裝維護作業
# Date & Author..: 94/12/13 By Danny
 # Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0038 04/11/15 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: NO.FUN-4C0096 05/01/06 By Carol 修改報表架構轉XML
# Modify.........: No.FUN-570109 05/07/15 By jackie 修正建檔程式key值是否可更改  
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/01 By bnlent 欄位型態定義，改為LIKE
#
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.MOD-780248 07/08/23 By claire key值加上obl02
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840039 08/09/22 BY dxfwo 老報表改p_query
# Modify.........: No.MOD-970267 09/07/30 BY Dido 當料號刪除時,邏輯調整
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No.TQC-B20139 11/02/22 By zhangll 修正當查詢無資料顯示時，右派會出現多個錯誤按鈕
# Modify.........: No:FUN-D30034 13/04/16 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_obl           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        obl01       LIKE obl_file.obl01,  
        obl02       LIKE obl_file.obl02, 
        occ02       LIKE occ_file.occ02,
        obl03       LIKE obl_file.obl03
                    END RECORD,
    g_obl_t         RECORD                 #程式變數 (舊值)
        obl01       LIKE obl_file.obl01,  
        obl02       LIKE obl_file.obl02, 
        occ02       LIKE occ_file.occ02,
        obl03       LIKE obl_file.obl03
                    END RECORD,
     g_wc2,g_sql    STRING,   #No.FUN-580092 HCN    
    g_rec_b         LIKE type_file.num5,     #單身筆數                   #No.FUN-680137 SMALLINT
    l_ac            LIKE type_file.num5      #目前處理的ARRAY CNT        #No.FUN-680137 SMALLINT
DEFINE p_row,p_col  LIKE type_file.num5      #No.FUN-680137 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL   
DEFINE   g_cnt      LIKE type_file.num10    #No.FUN-680137 INTEGER
DEFINE   g_i        LIKE type_file.num5     #count/index for any purpose #No.FUN-680137 SMALLINT
DEFINE   g_before_input_done    LIKE type_file.num5     #No.FUN-570109   #No.FUN-680137 SMALLINT
MAIN
#     DEFINEl_time LIKE type_file.chr8           #No.FUN-6A0094
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
    LET p_row = 4 LET p_col = 5
 
    OPEN WINDOW i160_w AT p_row,p_col WITH FORM "axm/42f/axmi160"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
        
    LET g_wc2 = '1=1' CALL i160_b_fill(g_wc2)
    CALL i160_menu()
    CLOSE WINDOW i160_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
FUNCTION i160_menu()
 
   WHILE TRUE
      CALL i160_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN 
               CALL i160_q() 
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i160_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output" 
            IF cl_chk_act_auth() THEN 
               CALL i160_out() 
            END IF
         WHEN "help"  
            CALL cl_show_help()
         WHEN "exit" 
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_obl),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i160_q()
   CALL i160_b_askkey()
END FUNCTION
 
FUNCTION i160_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT #No.FUN-680137 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680137 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680137 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680137 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,                #可新增否          #No.FUN-680137 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否          #No.FUN-680137 SMALLINT
DEFINE l_imaud02    LIKE ima_file.imaud02    #add by guanyao160708 
DEFINE l_imaud08    LIKE ima_file.imaud08    #add by guanyao160708
DEFINE l_ima25      LIKE ima_file.ima25      #aad by guanyao160708
DEFINE l_ima63_fac  LIKE ima_file.ima63_fac  #add by guanyao160708
DEFINE l_i          LIKE type_file.num5      #add by guanyao160708
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT obl01,obl02,'',obl03 FROM obl_file ",
                       " WHERE obl01=?  AND obl02=? AND obl03=? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i160_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_obl WITHOUT DEFAULTS FROM s_obl.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_obl_t.* = g_obl[l_ac].*  #BACKUP
#No.FUN-570109 --start--                                                                                                            
               LET g_before_input_done = FALSE                                                                                      
               CALL i160_set_entry_b(p_cmd)                                                                                         
               CALL i160_set_no_entry_b(p_cmd)                                                                                      
               LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end-- 
               BEGIN WORK
 
               OPEN i160_bcl USING g_obl_t.obl01,g_obl_t.obl02,g_obl_t.obl03
               IF STATUS THEN
                  CALL cl_err("OPEN i160_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE   
                  FETCH i160_bcl INTO g_obl[l_ac].* 
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_obl_t.obl01,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  END IF
                  SELECT occ02 INTO g_obl[l_ac].occ02 FROM occ_file
                   WHERE occ01 = g_obl[l_ac].obl02
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO obl_file(obl01,obl02,obl03)
            VALUES(g_obl[l_ac].obl01,g_obl[l_ac].obl02,
                   g_obl[l_ac].obl03)
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_obl[l_ac].obl01,SQLCA.sqlcode,0)   #No.FUN-660167
                CALL cl_err3("ins","obl_file",g_obl[l_ac].obl01,g_obl[l_ac].obl02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
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
            CALL i160_set_entry_b(p_cmd)                                                                                         
            CALL i160_set_no_entry_b(p_cmd)                                                                                      
            LET g_before_input_done = TRUE                                                                                       
#No.FUN-570109 --end-- 
            INITIALIZE g_obl[l_ac].* TO NULL      #900423
            LET g_obl_t.* = g_obl[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD obl01
 
        AFTER FIELD obl01                   
            IF NOT cl_null(g_obl[l_ac].obl01) THEN 
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_obl[l_ac].obl01,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_obl[l_ac].obl01= g_obl_t.obl01
                 NEXT FIELD obl01
              END IF
#FUN-AA0059 ---------------------end-------------------------------
               LET l_n = 0
               SELECT COUNT(*) INTO l_n FROM ima_file
                WHERE ima01 = g_obl[l_ac].obl01
               IF l_n = 0 THEN 
                  CALL cl_err('','axm-297',0)
                 #-MOD-970267-add-
 		  IF g_chkey = 'Y' THEN
                     NEXT FIELD obl01 
		  ELSE
                     NEXT FIELD obl03 
                  END IF
                 #-MOD-970267-end-
               END IF 
               #str-----add by guanyao160708
               LET l_imaud02 = ''
               LET l_imaud08 = ''
               LET l_ima25 = ''
               SELECT imaud02,imaud08,ima25 INTO l_imaud02,l_imaud08,l_ima25 FROM ima_file WHERE ima01 =g_obl[l_ac].obl01
               IF cl_null(l_imaud02) OR cl_null(l_imaud08) THEN 
                  CALL cl_err(g_obl[l_ac].obl01,'cim-010',0)
                  NEXT FIELD obl01
               END IF 
               IF l_imaud02 !=l_ima25 THEN 
                  CALL s_umfchk(g_obl[l_ac].obl01,l_imaud02,l_ima25)
                        RETURNING l_i,l_ima63_fac
                  IF l_i = '1' THEN
                     CALL cl_err(g_obl[l_ac].obl01,'cim-009',0)
                     NEXT FIELD obl01
                  END IF
               END IF 
               #end-----add by guanyao160708
            END IF 
         
        AFTER FIELD obl02
            IF g_obl[l_ac].obl02 IS NOT NULL THEN
            IF (g_obl[l_ac].obl02 != g_obl_t.obl02 OR g_obl_t.obl02 IS NULL)
             OR (g_obl[l_ac].obl01 != g_obl_t.obl01 OR g_obl_t.obl01 IS NULL)
             THEN
                SELECT COUNT(*) INTO g_cnt FROM obl_file
                 WHERE obl01 = g_obl[l_ac].obl01
                   AND obl02 = g_obl[l_ac].obl02
                IF g_cnt > 0 THEN
                   CALL cl_err('',-239,0)
                   LET g_obl[l_ac].obl01 = g_obl_t.obl01
                   LET g_obl[l_ac].obl02 = g_obl_t.obl02
                   NEXT FIELD obl01
                END IF
             END IF
             IF g_obl[l_ac].obl02 != 'ALL' THEN   #add by guanyao160708
                SELECT occ02 INTO g_obl[l_ac].occ02 FROM occ_file
                 WHERE occ01 = g_obl[l_ac].obl02 
                IF STATUS THEN 
#                  CALL cl_err('','anm-045',0)   #No.FUN-660167
                   CALL cl_err3("sel","occ_file",g_obl[l_ac].obl02 ,"","anm-045","","",1)  #No.FUN-660167
                   NEXT FIELD obl02
                END IF 
             END IF #add by guanyao160708
             END IF 
 
        AFTER FIELD obl03
           IF NOT cl_null(g_obl[l_ac].obl03) THEN 
            LET l_n = 0
            SELECT COUNT(*) INTO l_n FROM obe_file
             WHERE obe01 = g_obl[l_ac].obl03
            IF l_n = 0 THEN 
               CALL cl_err('','axm-810',0)
               NEXT FIELD obl03 
            END IF 
            END IF 
 
        BEFORE DELETE                            #是否取消單身
            IF g_obl_t.obl01 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                
                DELETE FROM obl_file WHERE obl01 = g_obl_t.obl01
                                       AND obl02 = g_obl_t.obl02   #MOD-780248 add
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_obl_t.obl01,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("del","obl_file",g_obl_t.obl01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2 
                MESSAGE "Delete OK"
                CLOSE i160_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_obl[l_ac].* = g_obl_t.*
               CLOSE i160_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_obl[l_ac].obl01,-263,1)
               LET g_obl[l_ac].* = g_obl_t.*
            ELSE
               UPDATE obl_file SET obl01=g_obl[l_ac].obl01,
                                   obl02=g_obl[l_ac].obl02,
                                   obl03=g_obl[l_ac].obl03
                WHERE CURRENT OF i160_bcl
               IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_obl[l_ac].obl01,SQLCA.sqlcode,0)   #No.FUN-660167
                   CALL cl_err3("upd","obl_file",g_obl_t.obl01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
                   LET g_obl[l_ac].* = g_obl_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   CLOSE i160_bcl
                   COMMIT WORK
               END IF
            END IF
 
        #--New AFTER ROW block
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30034 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_obl[l_ac].* = g_obl_t.*
               #FUN-D30034--add--begin--
               ELSE
                  CALL g_obl.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30034--add--end----
               END IF
               CLOSE i160_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30034 add
            CLOSE i160_bcl
            COMMIT WORK
 
        ON ACTION CONTROLN
            CALL i160_b_askkey()
            EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(obl01) AND l_ac > 1 THEN
                LET g_obl[l_ac].* = g_obl[l_ac-1].*
                NEXT FIELD obl01
            END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(obl01)
#                CALL q_ima(10,3,g_obl[l_ac].obl01)
#                     RETURNING g_obl[l_ac].obl01
#FUN-AA0059---------mod------------str-----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form ="q_ima"
#                 LET g_qryparam.default1 = g_obl[l_ac].obl01
#                 CALL cl_create_qry() RETURNING g_obl[l_ac].obl01
#                 CALL FGL_DIALOG_SETBUFFER( g_obl[l_ac].obl01 )
                  CALL q_sel_ima(FALSE, "q_ima","",g_obl[l_ac].obl01,"","","","","",'' ) 
                   RETURNING  g_obl[l_ac].obl01
#FUN-AA0059---------mod------------end-----------------

                  DISPLAY BY NAME g_obl[l_ac].obl01         #No.MOD-490371
                 NEXT FIELD obl01
              WHEN INFIELD(obl02)
#                CALL q_occ(10,3,g_obl[l_ac].obl02)
#                     RETURNING g_obl[l_ac].obl02
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_occ"
                 LET g_qryparam.default1 = g_obl[l_ac].obl02
                 CALL cl_create_qry() RETURNING g_obl[l_ac].obl02
#                 CALL FGL_DIALOG_SETBUFFER( g_obl[l_ac].obl02 )
                  DISPLAY BY NAME g_obl[l_ac].obl02         #No.MOD-490371
                 NEXT FIELD obl02 
              WHEN INFIELD(obl03)
#                CALL q_obe(10,3,g_obl[l_ac].obl03)
#                     RETURNING g_obl[l_ac].obl03
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_obe"
                 LET g_qryparam.default1 = g_obl[l_ac].obl03
                 CALL cl_create_qry() RETURNING g_obl[l_ac].obl03
#                 CALL FGL_DIALOG_SETBUFFER( g_obl[l_ac].obl03 )
                  DISPLAY BY NAME g_obl[l_ac].obl03         #No.MOD-490371
                 NEXT FIELD obl03 
           END CASE
 
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
 
    CLOSE i160_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i160_b_askkey()
    CLEAR FORM
    CALL g_obl.clear()
    CONSTRUCT g_wc2 ON obl01,obl02,obl03
            FROM s_obl[1].obl01,s_obl[1].obl02,s_obl[1].obl03
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(obl01)
#                CALL q_ima(10,3,g_obl[1].obl01)
#                     RETURNING g_obl[1].obl01
#FUN-AA0059---------mod------------str-----------------
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state = "c"
#                 LET g_qryparam.form ="q_ima"
#                 LET g_qryparam.default1 = g_obl[1].obl01
#                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 CALL q_sel_ima(TRUE, "q_ima","",g_obl[1].obl01,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end----------------- 
                 DISPLAY g_qryparam.multiret TO s_obl[1].obl01
                 NEXT FIELD obl01
              WHEN INFIELD(obl02)
#                CALL q_occ(10,3,g_obl[1].obl02)
#                     RETURNING g_obl[1].obl02
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_occ"
                 LET g_qryparam.default1 = g_obl[1].obl02
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_obl[1].obl02
                 NEXT FIELD obl02 
              WHEN INFIELD(obl03)
#                CALL q_obe(10,3,g_obl[1].obl03)
#                     RETURNING g_obl[1].obl03
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_obe"
                 LET g_qryparam.default1 = g_obl[1].obl03
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO s_obl[1].obl03
                 NEXT FIELD obl03 
           END CASE
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
    CALL i160_b_fill(g_wc2)
END FUNCTION
 
FUNCTION i160_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(200)
 
    LET g_sql =
        "SELECT obl01,obl02,occ02,obl03",
        " FROM obl_file LEFT OUTER JOIN occ_file ON obl_file.obl02=occ_file.occ01 ",
        " WHERE  ", p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
    PREPARE i160_pb FROM g_sql
    DECLARE obl_curs CURSOR FOR i160_pb
 
    CALL g_obl.clear()
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH obl_curs INTO g_obl[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
     
    END FOREACH
    CALL g_obl.deleteElement(g_cnt)
    MESSAGE ""
 
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2 
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i160_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_obl TO s_obl.* ATTRIBUTE(COUNT=g_rec_b)
 
      #Add No.TQC-B20139
      BEFORE DISPLAY 
         CALL cl_show_fld_cont()  
      #End Add No.TQC-B20139

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
 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i160_out()
    DEFINE
       l_obl            RECORD 
        obl01       LIKE obl_file.obl01,  
        ima02       LIKE ima_file.ima02,
        ima021      LIKE ima_file.ima021,
        obl02       LIKE obl_file.obl02, 
        occ02       LIKE occ_file.occ02,
        obl03       LIKE obl_file.obl03 
                    END RECORD,
        l_i             LIKE type_file.num5,          #No.FUN-680137 SMALLINT
        l_name          LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
        l_za05          LIKE type_file.chr1000        #No.FUN-680137 VARCHAR(40)
    DEFINE l_cmd        LIKE type_file.chr1000        
    IF g_wc2 IS NULL THEN 
       CALL cl_err('','9057',0) RETURN END IF
    LET l_cmd = 'p_query "axmi160" "',g_wc2 CLIPPED,'"'                                                           
    CALL cl_cmdrun(l_cmd)
#No.FUN-840039 --start-- 
#    CALL cl_wait()
#    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
#
#    LET g_sql="SELECT obl01,'','',obl02,'',obl03  FROM obl_file ",  # 組合出 SQL 指令
#              " WHERE ",g_wc2 CLIPPED
#    PREPARE i160_p1 FROM g_sql              # RUNTIME 編譯
#    DECLARE i160_co                         # CURSOR
#        CURSOR FOR i160_p1
#
#    LET g_rlang = g_lang                               #FUN-4C0096 add
#    CALL cl_outnam('axmi160') RETURNING l_name         #FUN-4C0096 add
#    START REPORT i160_rep TO l_name
#
#    FOREACH i160_co INTO l_obl.*
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('foreach:',SQLCA.sqlcode,1) 
#            EXIT FOREACH
#            END IF
#        SELECT occ02 INTO l_obl.occ02 FROM occ_file
#         WHERE occ01 = l_obl.obl02
#        SELECT ima02,ima021 INTO l_obl.ima02,l_obl.ima021 FROM ima_file
#         WHERE ima01 = l_obl.obl01
#        OUTPUT TO REPORT i160_rep(l_obl.*)
#    END FOREACH
#
#    FINISH REPORT i160_rep
#
#    CLOSE i160_co
#    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)
#No.FUN-840039 --end-- 
END FUNCTION
 
#No.FUN-840039 --start-- 
 
#REPORT i160_rep(sr)
#    DEFINE
#        l_last_sw    LIKE type_file.chr1,            #No.FUN-680137 VARCHAR(1)
#        l_str        LIKE aab_file.aab02,            #No.FUN-680137 VARCHAR(06)
#        sr           RECORD 
#         obl01       LIKE obl_file.obl01,  
#         ima02       LIKE ima_file.ima02,
#         ima021      LIKE ima_file.ima021,
#         obl02       LIKE obl_file.obl02, 
#         occ02       LIKE occ_file.occ02,
#         obl03       LIKE obl_file.obl03 
#                     END RECORD
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.obl01
#
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#            LET g_pageno = g_pageno + 1
#            LET pageno_total = PAGENO USING '<<<','/pageno'
#            PRINT g_head CLIPPED, pageno_total
#            PRINT ''
#
#            PRINT g_dash[1,g_len]
#            PRINT g_x[31], 
#                  g_x[32],
#                  g_x[33],
#                  g_x[34],
#                  g_x[35],
#                  g_x[36]
#            PRINT g_dash1
#            LET l_last_sw = 'n'
#
#        BEFORE GROUP OF sr.obl01
#            PRINT COLUMN g_c[31],sr.obl01,
#                  COLUMN g_c[32],sr.ima02,
#                  COLUMN g_c[33],sr.ima021
#        ON EVERY ROW
#            PRINT COLUMN g_c[34],sr.obl02,
#                  COLUMN g_c[35],sr.occ02,
#                  COLUMN g_c[36],sr.obl03
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            PRINT g_x[4] CLIPPED, COLUMN g_c[36], g_x[7] CLIPPED
#            LET l_last_sw = 'y'
#
#        PAGE TRAILER
#            IF l_last_sw = 'n' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4] CLIPPED, COLUMN g_c[36], g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#END REPORT
#No.FUN-840039 --end-- 
 
#No.FUN-570109 --start--                                                                                                            
FUNCTION i160_set_entry_b(p_cmd)                                                                                                    
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                    #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
  IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                                                                               
     CALL cl_set_comp_entry("obl01,obl02",TRUE)                                                                                     
  END IF                                                                                                                            
                                                                                                                                    
END FUNCTION                                                                                                                        
                                                                                                                                    
                                                                                                                                    
FUNCTION i160_set_no_entry_b(p_cmd)                                                                                                 
                                                                                                                                    
  DEFINE p_cmd   LIKE type_file.chr1                   #No.FUN-680137 VARCHAR(1)
                                                                                                                                    
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
     CALL cl_set_comp_entry("obl01,obl02",FALSE)                                                                                    
   END IF                                                                                                                           
                                                                                                                                    
END FUNCTION                                                                                                                        
#No.FUN-570109 --end--    
