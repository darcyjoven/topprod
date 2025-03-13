# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimi115.4gl
# Descriptions...: 料件資料(Phase out) FM
# Date & Author..: 00/04/17 By Apple
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-530065 05/03/29 By Will 增加料件的開窗
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6A0036 06/11/13 By rainy 新增欄位(生效日 ima1401)
# Modify.........: No.TQC-690120 06/12/06 By pengu 此程式沒有單身新增的功能,新增的按鈕應該要Disable掉
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-930157 09/03/13 By shiwuying i115_b() FUNCTION一開始進入時判斷g_rec_b是否為0，若等於0則RETURN不要讓user進入單身
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/23 By vealxu ima26x 調整
# Modify.........: No.MOD-A60064 10/06/10 By liuxqa 隐藏btn_01-btn_20个按钮。
# Modify.........: No.FUN-A90049 10/09/25 By vealxu 1.只能允許查詢料件性質(ima120)='1' (企業料號')
#                                                   2.程式中如有  INSERT INTO ima_file 時料件性質(ima120)值給'1'(企業料號)
# Modify.........: No.FUN-AA0059 10/10/29 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-AB0025 10/11/10 By lixh1  開窗批處理BUG處理
# Modify.........: No.FUN-B20008 11/02/10 By jrg542 AFTER ROW 出現兩次

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
     g_ima          DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ima01       LIKE ima_file.ima01,   #料件編號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,  #規格
        ima08       LIKE ima_file.ima08,   #來源
        ima06       LIKE ima_file.ima06,   #分群
        ima25       LIKE ima_file.ima25,   #單位
#        ima262      LIKE ima_file.ima262,  #可用庫存  #FUN-A20044
        avl_stk     LIKE type_file.num15_3,            #FUN-A20044
        ima140      LIKE ima_file.ima140,  #phase out
        ima1401     LIKE ima_file.ima1401  #生效日     #FUN-6A0036
        ,imaud32    like ima_file.imaud32  #darcy:2023/07/15 add
        ,imaud29    like ima_file.imaud29  #darcy:2024/03/01 add
                    END RECORD,
    g_ima_t         RECORD                 #程式變數 (舊值)
        ima01       LIKE ima_file.ima01,   #料件編號
        ima02       LIKE ima_file.ima02,   #品名
        ima021      LIKE ima_file.ima021,  #規格
        ima08       LIKE ima_file.ima08,   #來源
        ima06       LIKE ima_file.ima06,   #分群
        ima25       LIKE ima_file.ima25,   #單位
#        ima262      LIKE ima_file.ima262,  #可用庫存  #FUN-6A0036
        avl_stk     LIKE type_file.num15_3,            #FUN-6A0036 
        ima140      LIKE ima_file.ima140,  #phase out
        ima1401     LIKE ima_file.ima1401  #生效日     #FUN-6A0036
        ,imaud32    like ima_file.imaud32  #darcy:2023/07/15 add
        ,imaud29    like ima_file.imaud29  #darcy:2024/03/01 add
                    END RECORD,
    g_wc,g_sql      string,                 #No.FUN-580092 HCN
    g_cmd           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(100)
    g_rec_b         LIKE type_file.num5,    #單身筆數             #No.FUN-690026 SMALLINT
    l_ac            LIKE type_file.num5     #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql STRING                  #SELECT ... FOR UPDATE SQL
DEFINE g_cnt        LIKE type_file.num10    #No.FUN-690026 INTEGER
 
MAIN
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
    OPEN WINDOW i115_w WITH FORM "aim/42f/aimi115"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    CALL i115_menu()
    CLOSE WINDOW i115_w                 #結束畫面

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0074
END MAIN
 
FUNCTION i115_menu()
 
   WHILE TRUE
      CALL i115_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i115_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i115_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ima),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION i115_q()
   CALL i115_b_askkey()
END FUNCTION
 
FUNCTION i115_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用         #No.FUN-690026 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否         #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態           #No.FUN-690026 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,   #可新增否           #No.FUN-690026 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1    #可刪除否           #No.FUN-690026 VARCHAR(1)
   ,l_avl_stk_mpsmrp LIKE type_file.num15_3,                   #No.FUN-A20044
    l_unavl_stk      LIKE type_file.num15_3,                   #No.FUN-A20044
    l_avl_stk        LIKE type_file.num15_3                    #No.FUN-A20044
 
    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""
    IF g_rec_b = 0 THEN RETURN END IF  #No.MOD-930157
   #---No.TQC-690120 modify
   #LET l_allow_insert = cl_detail_input_auth('insert')
   #LET l_allow_delete = cl_detail_input_auth('delete')
    LET l_allow_insert = FALSE
    LET l_allow_delete = FALSE
   #---No.TQC-690120 modify
 
#   LET g_forupd_sql = " SELECT ima01,ima02,ima021,ima08,ima06,ima25,ima262,ima140,ima1401 ", #FUN-6A0036 add  ima1401  #FUN-A20044
    LET g_forupd_sql = " SELECT ima01,ima02,ima021,ima08,ima06,ima25,'',ima140,ima1401,imaud32,imaud29 ",     #FUN-A20044   #darcy:2023/07/15 add imaud22 #darcy:2024/03/01 add imaud29    
                     "   FROM ima_file ",
                     "  WHERE ima01= ? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i115_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
         INPUT ARRAY g_ima WITHOUT DEFAULTS FROM s_ima.*      
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
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
            IF g_rec_b>=l_ac THEN
               BEGIN WORK
               LET p_cmd='u'
               LET g_ima_t.* = g_ima[l_ac].*  #BACKUP
 
               OPEN i115_bcl USING g_ima_t.ima01
               IF STATUS THEN
                   CALL cl_err("OPEN i115_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
               ELSE
                  FETCH i115_bcl INTO g_ima[l_ac].*
                  IF STATUS THEN
                      CALL cl_err(g_ima_t.ima01,STATUS,1)
                      LET l_lock_sw = "Y"
                  END IF
                  CALL s_getstock(g_ima_t.ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk   #FUN-A20044
                  LET g_ima[l_ac].avl_stk = l_avl_stk                                               #FUN-A20044
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           CALL i115_set_entry_b()  #FUN-6A0043
        
 
        AFTER FIELD ima140
            IF cl_null(g_ima[l_ac].ima140) OR
               g_ima[l_ac].ima140 not matches'[YN]' THEN
               NEXT FIELD ima140
            END IF
            CALL i115_set_no_entry_b()  #FUN-6A0043 add
            IF g_ima[l_ac].ima140 = 'Y' THEN NEXT FIELD ima1401 END IF
            
      #FUN-6A0043 add--begin
        AFTER FIELD ima1401
            IF cl_null(g_ima[l_ac].ima1401) AND
               g_ima[l_ac].ima140 ='Y' THEN
                NEXT FIELD ima1401
            END IF
            IF NOT cl_null(g_ima[l_ac].ima1401) AND 
               (g_ima[l_ac].ima1401 != g_ima_t.ima1401 OR cl_null(g_ima_t.ima1401) )THEN
              
               IF g_ima[l_ac].ima140 = 'Y' AND
                  g_ima[l_ac].ima1401 < g_today THEN
                   CALL cl_err('','aim-900',0)
                   NEXT FIELD ima1401
               END IF
            END IF
      #FUN-6A0043--end
 
      #FUN-6A0043--begin
        AFTER INPUT
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ima[l_ac].* = g_ima_t.*
              DISPLAY BY NAME g_ima[l_ac].ima140,g_ima[l_ac].ima1401,g_ima[l_ac].imaud32,g_ima[l_ac].imaud29  #FUN-6A0043 #darcy:2023/07/15 add #darcy:2024/03/01 add imaud29
              CLOSE i115_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
      #FUN-6A0043--end
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ima[l_ac].* = g_ima_t.*
              DISPLAY BY NAME g_ima[l_ac].ima140,g_ima[l_ac].ima1401,g_ima[l_ac].imaud32,g_ima[l_ac].imaud29  #FUN-6A0043 #darcy:2023/07/15 add #darcy:2024/03/01 add
              CLOSE i115_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
 
           IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ima[l_ac].ima01,-263,1)
               LET g_ima[l_ac].* = g_ima_t.*
               DISPLAY BY NAME g_ima[l_ac].ima140,g_ima[l_ac].ima1401,g_ima[l_ac].imaud32,g_ima[l_ac].imaud29  #FUN-6A0043 #darcy:2023/07/15 #darcy:2024/03/01 add imaud29
           ELSE
               UPDATE ima_file
                  SET ima140  = g_ima[l_ac].ima140,
                      ima1401 = g_ima[l_ac].ima1401,  #FUN-6A0043 add
                      imaud32 = g_ima[l_ac].imaud32, #darcy:2023/07/15 add
                      imaud29 = g_ima[l_ac].imaud29, #darcy:2024/03/01 add
                      imamodu = g_user,
                      imadate = g_today
                WHERE ima01   = g_ima[l_ac].ima01
 
               IF SQLCA.sqlcode THEN
#                 CALL cl_err(g_ima[l_ac].ima01,SQLCA.SQLCODE,0)  #No.FUN-660156 
                  CALL cl_err3("upd","ima_file",g_ima[l_ac].ima01,"",
                                SQLCA.sqlcode,"","",1)  #No.FUN-660156
                  LET g_ima[l_ac].* = g_ima_t.*
                  DISPLAY BY NAME g_ima[l_ac].ima140,g_ima[l_ac].ima1401,g_ima[l_ac].imaud32,g_ima[l_ac].imaud29  #FUN-6A0043 #darcy:2023/07/15 add #darcy:2024/03/01 add imaud29
                  ROLLBACK WORK
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
                 LET g_ima[l_ac].* = g_ima_t.*
                 DISPLAY BY NAME g_ima[l_ac].ima140,g_ima[l_ac].ima1401,g_ima[l_ac].imaud32,g_ima[l_ac].imaud29  #FUN-6A0043 #darcy:2023/07/15 #darcy:2024/03/01 add imaud29
              END IF
              CLOSE i115_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i115_bcl
           COMMIT WORK
 
      #  AFTER ROW   #FUN-B20008
 
      # ON ACTION CONTROLN
      #     CALL i115_b_askkey()
      #     EXIT INPUT
 
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
 
    CLOSE i115_bcl
    COMMIT WORK
END FUNCTION
 
FUNCTION i115_b_askkey()
    CLEAR FORM
    CALL g_ima.clear()
    CALL cl_opmsg('q')
#   CONSTRUCT g_wc ON ima01,ima02,ima021,ima08,ima06,ima25,ima262,ima140,ima1401  #FUN-6A0043 add ima1401  #FUN-A20044
    CONSTRUCT g_wc ON ima01,ima02,ima021,ima08,ima06,ima25,ima140,ima1401,imaud32,imaud29  #darcy:2024/03/01 add imaud29 #FUN-A20044 #darcy:2023/07/15 add
            FROM s_ima[1].ima01,s_ima[1].ima02,s_ima[1].ima021,s_ima[1].ima08,
#                s_ima[1].ima06,s_ima[1].ima25,s_ima[1].ima262,s_ima[1].ima140,s_ima[1].ima1401  #FUN-6A0043 add ima1401  #FUN-A20044
                 s_ima[1].ima06,s_ima[1].ima25,s_ima[1].ima140,s_ima[1].ima1401,s_ima[1].imaud32,s_ima[1].imaud29 #darcy:2024/03/01 add imaud29               #FUN-A20044 #darcy:2023/07/15 add
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
     #FUN-530065
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(ima01)
#FUN-AA0059 --Begin--
           CALL cl_init_qry_var()
           LET g_qryparam.form = "q_ima"
           LET g_qryparam.state = "c"
           LET g_qryparam.where = "(ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL)"    #FUN-AB0025 
           LET g_qryparam.default1 = g_ima[1].ima01
           CALL cl_create_qry() RETURNING g_qryparam.multiret
          # CALL q_sel_ima( TRUE, "q_ima","",g_ima[1].ima01,"","","","","",'')  RETURNING  g_qryparam.multiret   #FUN-AB0025
#FUN-AA0059 --End-- 
            DISPLAY g_qryparam.multiret TO ima01
            NEXT FIELD ima01
         OTHERWISE
            EXIT CASE
       END CASE
    #--
 
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL i115_b_fill(g_wc)
END FUNCTION
 
FUNCTION i115_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
   ,l_avl_stk_mpsmrp   LIKE type_file.num15_3, #FUN-A20044
    l_unavl_stk        LIKE type_file.num15_3, #FUN-A20044
    l_avl_stk          LIKE type_file.num15_3  #FUN-A20044

    LET g_sql =
#       "SELECT ima01,ima02,ima021,ima08,ima06,ima25,ima262,ima140,ima1401 ",  #FUN-6A0043 add ima1401  #FUN-A20044
        "SELECT ima01,ima02,ima021,ima08,ima06,ima25,'',ima140,ima1401,imaud32,imaud29 ", #darcy:2024/03/01 add         #FUN-A20044 #darcy:2023/07/15 add
        " FROM ima_file",
#       " WHERE ", p_wc2 CLIPPED," AND imaacti='Y'",                        #FUN-A90049 mark
        " WHERE ( ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL ) AND ", p_wc2 CLIPPED," AND imaacti='Y'",        #FUN-A90049 add 
        " ORDER BY 1"
    PREPARE i115_pb FROM g_sql
    DECLARE ima_curs CURSOR FOR i115_pb
 
    FOR g_cnt = 1 TO g_ima.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_ima[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH ima_curs INTO g_ima[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        CALL s_getstock(g_ima[g_cnt].ima01,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk   #FUN-A20044
        LET g_ima[g_cnt].avl_stk = l_avl_stk                                                          #FUN-A20044
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ima.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cnt
END FUNCTION
 
FUNCTION i115_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ima TO s_ima.* ATTRIBUTE(COUNT=g_rec_b)

#MOD-A60064 --add --begin
      BEFORE DISPLAY 
       CALL cl_show_fld_cont()
#MOD-A60064 --add end 
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#FUN-6A0043 add--begin
FUNCTION i115_set_entry_b()
   CALL cl_set_comp_entry("ima1401",TRUE)
END FUNCTION
 
FUNCTION i115_set_no_entry_b()
   IF g_ima[l_ac].ima140 = 'N' THEN
      LET g_ima[l_ac].ima1401 = ''
      DISPLAY BY NAME g_ima[l_ac].ima1401
      CALL cl_set_comp_entry("ima1401",FALSE)
   END IF 
END FUNCTION
#FUN-6A0043 add--end
#Patch....NO.TQC-610036 <001> #
