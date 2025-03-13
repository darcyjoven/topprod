# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asft702.4gl
# Descriptions...: 工單轉出維護作業
# Date & Author..: 99/06/11 By Carol
# Modify.........: No:7316 03/07/15 By Carol 跳入工單轉出的畫面要離開前先check數量是否相符,如畫面中的
#                                            數量為0,則update shb17=0 回asft700主畫面
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-570110 05/07/15 By wujie 修正建檔程式key值是否可更改
# Modify.........: No.FUN-680033 06/08/17 By kim GP3.5 成本改善-工單轉出
# Modify.........: No.FUN-680121 06/09/04 By huchenghao 類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:FUN-A70125 10/07/26 By lilingyu 平行工藝整批修改
# Modify.........: No:FUN-B70106 11/07/26 By lixh1 取消asft702的時候 LET INT_FLAG = 0
# Modify.........: No.FUN-C30163 12/12/18 By pauline CALL q_ecm(時增加參數
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    g_yy,g_mm       LIKE type_file.num5,          #No.FUN-680121 SMALLINT#
    b_shi           RECORD LIKE shi_file.*,
    g_shi           DYNAMIC ARRAY OF RECORD    #程式變數(Prinram Variables)
                    shi02     LIKE shi_file.shi02,
                    shi03     LIKE shi_file.shi03,
                    ecm45     LIKE ecm_file.ecm45,
                    shi04     LIKE shi_file.shi04,
                    shi05     LIKE shi_file.shi05
                    END RECORD,
    g_shi_t         RECORD
                    shi02     LIKE shi_file.shi02,
                    shi03     LIKE shi_file.shi03,
                    ecm45     LIKE ecm_file.ecm45,
                    shi04     LIKE shi_file.shi04,
                    shi05     LIKE shi_file.shi05
                    END RECORD,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_sw            LIKE type_file.chr1,                #No.FUN-680121 VARCHAR(1)
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680121 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
 
DEFINE g_shi01      LIKE shi_file.shi01
DEFINE g_unit       LIKE ecm_file.ecm57                 #No.FUN-680121 VARCHAR(04)
DEFINE g_shb17      LIKE shb_file.shb17
DEFINE g_shi05      LIKE shi_file.shi05
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_before_input_done      LIKE type_file.num5            #No.FUN-570110        #No.FUN-680121 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10            #No.FUN-680121 INTEGER
FUNCTION t702(p_shi01,p_unit,p_shb17)
DEFINE p_shi01   LIKE shi_file.shi01
DEFINE p_unit    LIKE ecm_file.ecm57                     #No.FUN-680121 VARCHAR(04)   
DEFINE p_shb17   LIKE shb_file.shb17
DEFINE ls_tmp    STRING
 
    WHENEVER ERROR CONTINUE                #忽略一切錯誤
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
    LET g_shi01      = p_shi01
    LET g_unit       = p_unit 
    LET g_shb17      = p_shb17
 
     OPEN WINDOW t702_w AT 3,5 WITH FORM "asf/42f/asft702"
           ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_locale("asft702")
 
     LET ls_tmp = g_prog CLIPPED
     LET g_prog='asft702'   
 
    CALL t702_b_fill(' 1=1') 
 
    DISPLAY ARRAY g_shi TO s_shi.*  #FUN-680033
         #MOD-860081------add-----str---
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  

       #FUN-B70106 --------Begin--------
         ON ACTION close
            LET INT_FLAG = 0
            LET g_action_choice = "exit"
            EXIT DISPLAY
         ON ACTION cancel
            LET INT_FLAG = 0
            LET g_action_choice = "exit"
            EXIT DISPLAY
       #FUN-B70106 --------End----------

    END DISPLAY
         #MOD-860081------add-----end---
#FUN-680033...............mark begin
#   WHILE TRUE 
#      CALL t702_b() 
#      SELECT SUM(shi05) INTO g_shi05 FROM shi_file WHERE shi01=g_shi01
#      IF STATUS OR cl_null(g_shi05) THEN LET g_shi05=0 END IF
#No:7316 modify..............................................
#      IF g_shi05 > 0 AND g_shi05 !=g_shb17 THEN 
#         CALL cl_err(g_shb17,'asf-926',0)
#      ELSE
#         EXIT WHILE
#      END IF
#   END WHILE
#   IF g_shi05 = 0 AND g_shb17 > 0 THEN 
#      UPDATE shb_file SET shb17 = 0 
#       WHERE shb01 = g_shi01
#      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
#         CALL cl_err('t702_upd_shb17',SQLCA.sqlcode,0)
#      END IF 
#   END IF 
#FUN-680033...............mark end
##
    CLOSE WINDOW t702_w
    LET g_prog = ls_tmp
 
END FUNCTION
 
FUNCTION t702_menu()
 
   WHILE TRUE
      CALL t702_bp("G")
      CASE g_action_choice
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t702_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
#        WHEN "jump" 
#           CALL t702_fetch('/')
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0011
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_shi),'','')
            END IF
##
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t702_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_row,l_col     LIKE type_file.num5,                #No.FUN-680121 SMALLINT #分段輸入之行,列數
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用        #No.FUN-680121 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680121 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680121 VARCHAR(1)
    l_b2            LIKE type_file.chr1000,             #No.FUN-680121 VARCHAR(30)
    l_ima35,l_ima36 LIKE ima_file.ima35,                #No.FUN-680121 VARCHAR(10)
#   l_qty           LIKE ima_file.ima26,                #No.FUN-680121 DECIMAL(15,3)
    l_qty           LIKE type_file.num15_3,             ###GP5.2  #NO.FUN-A20044
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680121 SMALLINT
 
    LET g_action_choice = ""
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = 
        "SELECT shi02,shi03,'',shi04,shi05 FROM shi_file ",
        "WHERE shi01= ? AND shi02= ? AND shi04= ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t702_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    #CKP
    IF g_rec_b=0 THEN CALL g_shi.clear() END IF
 
    INPUT ARRAY g_shi WITHOUT DEFAULTS FROM s_shi.* 
 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR() 
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            IF g_rec_b >= l_ac  THEN
                LET p_cmd='u'
                LET g_shi_t.* = g_shi[l_ac].*  #BACKUP
#No.FUN-570110--begin                                                           
                LET g_before_input_done = FALSE                                 
                CALL t702_set_entry_b(p_cmd)                                    
                CALL t702_set_no_entry_b(p_cmd)                                 
                LET g_before_input_done = TRUE                                  
#No.FUN-570110--end                  
                BEGIN WORK
 
                OPEN t702_bcl USING g_shi01,g_shi_t.shi02,g_shi_t.shi04
                IF STATUS THEN
                   CALL cl_err("OPEN t702_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE 
                   FETCH t702_bcl INTO g_shi[l_ac].* 
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock shi',SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            IF l_ac <= l_n THEN                   #DISPLAY NEWEST
               SELECT ecm45 INTO g_shi[l_ac].ecm45 FROM ecm_file 
                WHERE ecm01=g_shi[l_ac].shi02 AND ecm03=g_shi[l_ac].shi04
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              #CKP
              INITIALIZE g_shi[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_shi[l_ac].* TO s_shi.*
              CALL g_shi.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
 
            CALL t702_move_shi('a') 
#FUN-A70125 --begin--
      IF cl_null(b_shi.shi012) THEN
         LET b_shi.shi012 = ' '
      END IF
#FUN-A70125 --end--
            INSERT INTO shi_file VALUES(b_shi.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err('ins shi',SQLCA.sqlcode,0)
               CANCEL INSERT
            ELSE 
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570110--begin                                                           
            LET g_before_input_done = FALSE                                     
            CALL t702_set_entry_b(p_cmd)                                        
            CALL t702_set_no_entry_b(p_cmd)                                     
            LET g_before_input_done = TRUE                                      
#No.FUN-570110--end  
            INITIALIZE g_shi[l_ac].* TO NULL      #900423
            INITIALIZE g_shi_t.* TO NULL
            LET g_shi[l_ac].shi05=0
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD shi02
 
        AFTER FIELD shi02                        #check 序號是否重複
            IF NOT cl_null(g_shi[l_ac].shi02) THEN 
               SELECT COUNT(*) INTO g_cnt FROM sfb_file 
                  WHERE sfb01=g_shi[l_ac].shi02 AND sfb87!='X' 
               IF g_cnt=0 THEN 
                  CALL cl_err(g_shi[l_ac].shi02,'asf-312',0)
                  NEXT FIELD shi02
               END IF
            END IF
 
        AFTER FIELD shi03 
           IF NOT cl_null(g_shi[l_ac].shi03) THEN 
              IF t702_shi03() THEN NEXT FIELD shi03 END IF
           END IF
 
        AFTER FIELD shi05 
           IF NOT cl_null(g_shi[l_ac].shi05) THEN 
              IF g_shi[l_ac].shi05=0 THEN NEXT FIELD shi05 END IF
           END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_shi_t.shi02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
 
              IF l_lock_sw = "Y" THEN 
                 CALL cl_err("", -263, 1) 
                 ROLLBACK WORK
                 CANCEL DELETE 
              END IF 
 
              DELETE FROM shi_file
               WHERE shi01 = g_shi01 
                 AND shi02 = g_shi[l_ac].shi02
                 AND shi04 = g_shi[l_ac].shi04
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_shi_t.shi02,SQLCA.sqlcode,0)
                 ROLLBACK WORK
                 CANCEL DELETE
              ELSE 
                 LET g_rec_b=g_rec_b-1
                 COMMIT WORK
              END IF
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_shi[l_ac].* = g_shi_t.*
               CLOSE t702_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_shi[l_ac].shi02,-263,1)
               LET g_shi[l_ac].* = g_shi_t.*
            ELSE
               CALL t702_move_shi('u') 
               UPDATE shi_file SET * = b_shi.*
                WHERE shi01=g_shi01 
                  AND shi02=g_shi_t.shi02
                  AND shi04=g_shi_t.shi04
               IF SQLCA.sqlcode THEN
                  CALL cl_err('upd shi',SQLCA.sqlcode,0)
                  LET g_shi[l_ac].* = g_shi_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
	          COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac      #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_shi[l_ac].* = g_shi_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_shi.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE t702_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 Add
            CLOSE t702_bcl
            COMMIT WORK
            #CKP
           #CALL g_shi.deleteElement(g_rec_b+1)   #FUN-D40030 Mark
 
#       ON ACTION CONTROLN
#           CALL t702_b_askkey()
#           EXIT INPUT
 
        ON ACTION controlp
           CASE WHEN INFIELD(shi02) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_sfb02"
                     LET g_qryparam.default1 = g_shi[l_ac].shi02
                     LET g_qryparam.arg1     = "2345"
                     CALL cl_create_qry() RETURNING g_shi[l_ac].shi02
#                     CALL FGL_DIALOG_SETBUFFER( g_shi[l_ac].shi02 )
                      DISPLAY BY NAME g_shi[l_ac].shi02   #No.MOD-490371
                     NEXT FIELD shi02
 
                WHEN INFIELD(shi03) 
                    #CALL q_ecm(FALSE,FALSE,g_shi[l_ac].shi02,'')  #FUN-C30163 mark
                     CALL q_ecm(FALSE,FALSE,g_shi[l_ac].shi02,'','','','','')  #FUN-C30163 add
                          RETURNING g_shi[l_ac].shi03,g_shi[l_ac].shi04
#                     CALL FGL_DIALOG_SETBUFFER( g_shi[l_ac].shi03 )
#                     CALL FGL_DIALOG_SETBUFFER( g_shi[l_ac].shi04 )
                     SELECT ecm45 INTO g_shi[l_ac].ecm45 FROM ecm_file
                      WHERE ecm01=g_shi[l_ac].shi02 AND ecm04=g_shi[l_ac].shi03
                        AND ecm03=g_shi[l_ac].shi04
                     IF STATUS THEN  #資料資料不存在
                        CALL cl_err(g_shi[l_ac].shi03,g_errno,0)
                        NEXT FIELD shi03  
                     END IF
                      DISPLAY BY NAME g_shi[l_ac].shi03,g_shi[l_ac].shi04  #No.MOD-490371
                     NEXT FIELD shi03
               OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
    
    END INPUT
 
    CLOSE t702_bcl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION t702_move_shi(p_cmd)
    DEFINE  p_cmd    LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    LET b_shi.shi01 = g_shi01
    LET b_shi.shi02 = g_shi[l_ac].shi02  
    LET b_shi.shi03 = g_shi[l_ac].shi03  
    LET b_shi.shi04 = g_shi[l_ac].shi04  
    LET b_shi.shi05 = g_shi[l_ac].shi05  
 
    LET b_shi.shiplant = g_plant #FUN-980008 add
    LET b_shi.shilegal = g_legal #FUN-980008 add
END FUNCTION
 
FUNCTION t702_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON shi02,shi03,shi04,shi05
            FROM s_shi[1].shi02, s_shi[1].shi03, s_shi[1].shi04, s_shi[1].shi05
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
    
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    LET l_wc2 = l_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t702_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t702_b_fill(p_wc2)                          #BODY FILL UP
DEFINE p_wc2,l_sql     LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
 
    LET l_sql =
        "SELECT shi02,shi03,ecm45,shi04,shi05 FROM shi_file,OUTER ecm_file ",
        " WHERE shi01 ='",g_shi01 CLIPPED,"'",       #單頭
        "   AND shi_file.shi02=ecm_file.ecm01 AND shi_file.shi03=ecm_file.ecm04 AND shi_file.shi04=ecm_file.ecm03 ",
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE t702_pb FROM l_sql
    DECLARE shi_curs CURSOR FOR t702_pb
 
    CALL g_shi.clear()
 
    LET g_cnt = 1
    FOREACH shi_curs INTO g_shi[g_cnt].*             #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_shi.deleteELement(g_cnt)
    LET g_rec_b=g_cnt - 1
 
    LET g_cnt = 0 
 
END FUNCTION
 
FUNCTION t702_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_shi TO s_shi.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
#FUN-4B0011
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t702_shi03()
    IF NOT cl_null(g_shi[l_ac].shi04) THEN
       SELECT COUNT(*) INTO g_cnt FROM ecm_file
        WHERE ecm01=g_shi[l_ac].shi02 AND ecm04=g_shi[l_ac].shi03
          AND ecm03=g_shi[l_ac].shi04 AND ecm57=g_unit
    ELSE
       SELECT COUNT(*) INTO g_cnt FROM ecm_file
        WHERE ecm01=g_shi[l_ac].shi02 AND ecm04=g_shi[l_ac].shi03
          AND ecm57=g_unit
    END IF
 
    CASE 
      WHEN g_cnt=0
           CALL cl_err(g_shi[l_ac].shi03,100,0)
           RETURN -1
      WHEN g_cnt=1
           IF NOT cl_null(g_shi[l_ac].shi04) THEN
               SELECT ecm45 INTO g_shi[l_ac].ecm45
                 FROM ecm_file
                WHERE ecm01=g_shi[l_ac].shi02 AND ecm04=g_shi[l_ac].shi03
                  AND ecm03=g_shi[l_ac].shi04
           ELSE
               SELECT ecm03,ecm45 INTO g_shi[l_ac].shi04,g_shi[l_ac].ecm45
                 FROM ecm_file
                WHERE ecm01=g_shi[l_ac].shi02 AND ecm04=g_shi[l_ac].shi03
           END IF
           IF STATUS THEN  #資料資料不存在
              CALL cl_err(g_shi[l_ac].shi03,STATUS,0)
              RETURN -1
           END IF
      WHEN g_cnt>1
          #CALL q_ecm(FALSE,FALSE,g_shi[l_ac].shi02,g_shi[l_ac].shi03)  #FUN-C30163 mark
           CALL q_ecm(FALSE,FALSE,g_shi[l_ac].shi02,g_shi[l_ac].shi03,'','','','')   #FUN-C30163 add
                RETURNING g_shi[l_ac].shi03,g_shi[l_ac].shi04
           SELECT ecm45 INTO g_shi[l_ac].ecm45
             FROM ecm_file
            WHERE ecm01=g_shi[l_ac].shi02 AND ecm04=g_shi[l_ac].shi03
              AND ecm03=g_shi[l_ac].shi04
           IF STATUS THEN  #資料資料不存在
              CALL cl_err(g_shi[l_ac].shi03,STATUS,0)
              RETURN -1
           END IF
    END CASE
    RETURN 0
END FUNCTION
 
#No.FUN-570110--begin                                                           
FUNCTION t702_set_entry_b(p_cmd)                                                
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680121 VARCHAR(1)
                                                                                
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN                          
     CALL cl_set_comp_entry("shi02",TRUE)                                       
   END IF                                                                       
END FUNCTION                                                                    
                                                                                
FUNCTION t702_set_no_entry_b(p_cmd)                                             
  DEFINE p_cmd   LIKE type_file.chr1                                                                 #No.FUN-680121 VARCHAR(1)
                                                                                
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN          
     CALL cl_set_comp_entry("shi02",FALSE)                                      
   END IF                                                                       
END FUNCTION                                                                    
#No.FUN-570110--end      
