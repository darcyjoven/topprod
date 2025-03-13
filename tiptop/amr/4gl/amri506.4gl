# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: amri506.4gl
# Descriptions...: 獨立需求維護作業
# Date & Author..: 96/06/13 By Roger
# Modify.........: No.MOD-490371 04/09/22 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0013 04/11/08 By ching add '轉Excel檔' action
# Modify.........: No.FUN-510046 05/01/25 By pengu 報表轉XML
# Modify.........: No.FUN-550055 05/05/25 By Will 單據編號放大
# Modify.........: No.FUN-550610 05/07/13 By vivien KEY值更改控制  
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: NO.FUN-650143 06/05/25 By Sarah 輸入時沒有判斷Key值不可空白、重複,導致刪除不是只刪除Current哪一筆
#                                                  ps.Key值為rpc01,rpc02,rpc03,rpc12
# Modify.........: No.FUN-660107 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6A0080 06/11/20 By xumin 報表修改
# Modify.........: No.MOD-6A0028 06/12/11 By Claire 進入單身時且不可以改key值會錯
# Modify.........: No.TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改
# Modify.........: No.TQC-760042 07/06/05 By Judy 需求數量,已耗需求無控管
# Modify.........: NO.FUN-6B0045 07/07/26 BY yiting 1.改成假雙檔 2.新增確認/取消確認/結案/已耗需求維護action,確認後才可按'已耗需求維護' 進入單身修改已耗需求
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-820181 08/03/13 By Pengu 增加判斷料號是否為確認
# Modify.........: No.MOD-820182 08/03/20 By Pengu 第一筆按到料號之後按往下鍵,第二筆項次為空白
# Modify.........: No.FUN-840156 08/04/23 By rainy 新增參數接收
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.MOD-870080 08/07/16 By Pengu 按完結案關閉程式，再開啟來查詢結案碼又被清掉了
# Modify.........: No.FUN-850048 08/05/09 By destiny 報表改為CR輸出 
#                                08/08/08 By Cockroach 21區追至31區
# Modify.........: No.FUN-880052 09/01/06 By Cockroach   
# Modify.........: No.TQC-970339 09/07/29 By sherry 審核后資料不可以刪除   
# Modify.........: No.FUN-980004 09/08/12 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0073 10/01/14 By chenls 程序精簡
# Modify.........: No.FUN-AA0059 10/10/28 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()
# Modify.........: No.FUN-AB0065 10/11/15 By houlia 倉庫營運中心權限控管審核段控管
# Modify.........: No:FUN-8C0120 11/01/25 By Summer 新增複製功能
# Modify.........: No:FUN-B50046 11/05/13 By abby APS GP5.25 追版 str-----
# Modify.........: No:FUN-9B0084 09/11/18 By Mandy 新增Action "APS單據追溯"
# Modify.........: No:FUN-B50046 11/05/13 By abby APS GP5.25 追版 end-----
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No:MOD-B50186 11/07/17 By Summer 若下一筆單身資料少於前一筆時，單身資料會有問題
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:MOD-C70001 12/08/09 By ck2yuan 開放可輸入QBE條件之rpc21、rpc18、rpc19、rpc20
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_rpc02      LIKE rpc_file.rpc02    #NO.FUN-6B0045
DEFINE g_rpc02_t    LIKE rpc_file.rpc02    #no.FUN-6B0045
DEFINE g_rpc21      LIKE rpc_file.rpc21    #NO.FUN-6B0045
DEFINE g_rpc21_t    LIKE rpc_file.rpc21    #NO.FUN-6B0045
DEFINE g_rpc18      LIKE rpc_file.rpc18    #no.FUN-6B0045
DEFINE g_rpc18_t    LIKE rpc_file.rpc18    #no.FUN-6B0045
DEFINE g_rpc19      LIKE rpc_file.rpc19    #NO.FUN-6B0045
DEFINE g_rpc19_t    LIKE rpc_file.rpc19    #NO.FUN-6B0045
DEFINE g_rpc20      LIKE rpc_file.rpc20    #no.FUN-6B0045
DEFINE g_rpc20_t    LIKE rpc_file.rpc20    #no.FUN-6B0045
DEFINE g_t1         LIKE oay_file.oayslip  #no.FUN-6B0045
DEFINE g_chr        LIKE type_file.chr1    #no.FUN-6B0045
DEFINE g_argv1      LIKE rpc_file.rpc02    #FUN-840156
DEFINE g_rpc11      LIKE rpc_file.rpc11    #darcy:2023/03/24 add
define g_ta_rpc06   like rpc_file.ta_rpc06 #darcy:2023/07/29 add
#darcy:2023/06/15 add s---
define g_ta_rpc04   like rpc_file.ta_rpc04
define g_ta_rpc05   like rpc_file.ta_rpc05
#darcy:2023/06/15 add e---
DEFINE g_rpc11_t    LIKE rpc_file.rpc11    #darcy:2023/03/24 add
define g_ta_rpc06_t  like rpc_file.ta_rpc06 #darcy:2023/07/29

#darcy:2023/03/06 add s---
type tc_rpc record
   tc_rpc04 like tc_rpc_file.tc_rpc04,
   tc_rpc05 like tc_rpc_file.tc_rpc05,
   ta_rpc02_2 like rpc_file.ta_rpc02,
   ta_rpc03_2 like rpc_file.ta_rpc03,
   tc_rpc06 like tc_rpc_file.tc_rpc06,
   diff3 like tc_rpc_file.tc_rpc06,
   tc_rpc07 like tc_rpc_file.tc_rpc07,
   tc_rpc08 like tc_rpc_file.tc_rpc08,
   tc_rpc09 like tc_rpc_file.tc_rpc09,
   tc_rpc10 like tc_rpc_file.tc_rpc10,
   tc_rpc11 like tc_rpc_file.tc_rpc11,
   tc_rpc12 like tc_rpc_file.tc_rpc12,
   tc_rpc13 like tc_rpc_file.tc_rpc13,
   tc_rpc02 like tc_rpc_file.tc_rpc02
   end record
#darcy:2023/03/06 add e---
 
DEFINE 
    b_rpc           RECORD LIKE rpc_file.*,
    g_rpc           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
        rpc03       LIKE rpc_file.rpc03,    #no.FUN-6B0045 add
        rpc01       LIKE rpc_file.rpc01,  
        ima02       LIKE ima_file.ima02,
        #darcy:2023/06/29 add s---
        ima021      LIKE ima_file.ima021,
        ima25       LIKE ima_file.ima25,
        #darcy:2023/06/29 add e---
        rpc12       LIKE rpc_file.rpc12, 
        rpc13       LIKE rpc_file.rpc13,
        rpc131      LIKE rpc_file.rpc131,
        diff        LIKE rpc_file.rpc13,
        #darcy:2023/03/06 add s---
        ta_rpc01    like rpc_file.ta_rpc01,
        ta_rpc02    like rpc_file.ta_rpc02,
        ta_rpc03    like rpc_file.ta_rpc03,
        diff2       like rpc_file.ta_rpc03,
        #darcy:2023/03/06 add e---
        rpc17       LIKE rpc_file.rpc17  
                    END RECORD,
    g_rpc_t         RECORD                    #程式變數 (舊值)
        rpc03       LIKE rpc_file.rpc03,    #no.FUN-6B0045 add
        rpc01       LIKE rpc_file.rpc01,  
        ima02       LIKE ima_file.ima02,
        #darcy:2023/06/29 add s---
        ima021      LIKE ima_file.ima021,
        ima25       LIKE ima_file.ima25,
        #darcy:2023/06/29 add e---
        rpc12       LIKE rpc_file.rpc12, 
        rpc13       LIKE rpc_file.rpc13,
        rpc131      LIKE rpc_file.rpc131,
        diff        LIKE rpc_file.rpc13,
        #darcy:2023/03/06 add s---
        ta_rpc01    like rpc_file.ta_rpc01,
        ta_rpc02    like rpc_file.ta_rpc02,
        ta_rpc03    like rpc_file.ta_rpc03,
        diff2       like rpc_file.ta_rpc03,
        #darcy:2023/03/06 add e---
        rpc17       LIKE rpc_file.rpc17  
                    END RECORD,
    g_rec_b         LIKE type_file.num5,   #單身筆數               #No.FUN-680082 SMALLINT
    l_ac            LIKE type_file.num5,   #目前處理的ARRAY CNT    #No.FUN-680082 SMALLINT
    l_sl            LIKE type_file.num5,   #目前處理的SCREEN LINE  #No.FUN-680082 SMALLINT
    g_wc,g_sql,g_wc2    STRING             #NO.FUN-6B0045
   
DEFINE g_forupd_sql          STRING                 #SELECT ... FOR UPDATE SQL   
DEFINE   g_cnt               LIKE type_file.num10   #No.FUN-680082 INTEGER
DEFINE   g_i                 LIKE type_file.num5    #count/index for any purpose #No.FUN-680082 SMALLINT
DEFINE g_before_input_done   STRING                #No.FUN-550610  
DEFINE g_row_count          LIKE type_file.num10   #NO.FUN-6B0045 
DEFINE g_curs_index         LIKE type_file.num10   #NO.FUN-6B0045
DEFINE g_jump               LIKE type_file.num10   #NO.FUN-6B0045
DEFINE mi_no_ask            LIKE type_file.num5    #NO.FUN-6B0045
DEFINE g_msg                LIKE type_file.chr1000  #NO.FUN-6B0045
DEFINE g_sql_tmp            STRING                 #NO.FUN-6B0045
 
MAIN
DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-680082 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AMR")) THEN
       EXIT PROGRAM
    END IF
 
    LET g_argv1=ARG_VAL(1)	#FUN-840156
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time      #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
    LET p_row = 3 LET p_col = 2 
    OPEN WINDOW i506_w AT p_row,p_col WITH FORM "amr/42f/amri506"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN CALL i506_q() END IF  #FUN-840156
 
    CALL i506_menu()
    CLOSE WINDOW i506_w                 #結束畫面
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
 
FUNCTION i506_menu()
 
   WHILE TRUE
      CALL i506_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i506_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i506_r()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i506_q()
            END IF
        #------------No:FUN-8C0120 add
         WHEN "reproduce"                       # C.複製
            IF cl_chk_act_auth() THEN
               CALL i506_copy()
            END IF
        #------------No:FUN-8C0120 end
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i506_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i506_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_rpc),'','')
             END IF
         WHEN "close_the_case" 
            IF cl_chk_act_auth() THEN 
               CALL i506_x()
            END IF
            #圖形顯示
            CALL cl_set_field_pic(g_rpc18,"","",g_rpc19,"","")
         WHEN "confirm" 
            IF cl_chk_act_auth() THEN 
               CALL i506_y()
            END IF
            #圖形顯示
            CALL cl_set_field_pic(g_rpc18,"","",g_rpc19,"","")
         WHEN "undo_confirm" 
            IF cl_chk_act_auth() THEN 
               CALL i506_z()
            END IF
            #圖形顯示
            CALL cl_set_field_pic(g_rpc18,"","",g_rpc19,"","")
         WHEN "maintain_used_require"
            IF cl_chk_act_auth() THEN 
               CALL i506_require()
            END IF
         #FUN-9B0084---add----str----
         #darcy:2023/03/06 add s---
         when "maintain_used_require2"
            if cl_chk_act_auth() then
               call i506_require2()
            end if
         when "maintain_used_modify"
            if cl_chk_act_auth() then
               call i506_require_modify()
            end if
         #darcy:2023/03/06 add e---
         #APS單據追溯
         WHEN "aps_document_tracing"
            IF cl_chk_act_auth() THEN
               CALL i506_aps()
            END IF
         #FUN-9B0084---add----end----
      END CASE
   END WHILE
END FUNCTION

#FUN-9B0084---add----str---
FUNCTION i506_aps()
   DEFINE l_cmd           LIKE type_file.chr1000

   IF cl_null(g_rpc02) THEN
       CALL cl_err('',-400,1)
       RETURN
   END IF
   LET l_cmd = "apsq860 '",g_rpc02,"'"
   CALL cl_cmdrun(l_cmd)
END FUNCTION
#FUN-9B0084---add----end---
 
FUNCTION i506_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680082 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用        #No.FUN-680082 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680082 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680082 VARCHAR(1)
    l_allow_insert  LIKE type_file.num5,    #可新增否          #No.FUN-680082 SMALLINT 
    l_allow_delete  LIKE type_file.num5     #可刪除否          #No.FUN-680082 SMALLINT  
 
    LET g_action_choice = ""
    
    IF s_shut(0) THEN RETURN END IF
 
    IF g_rpc02 IS NULL OR g_rpc21 IS NULL THEN
        RETURN 
    END IF
    IF g_rpc18 = 'Y' THEN
        CALL cl_err('','aap-005',0)
        RETURN
    END IF
    IF g_rpc19 = 'Y' THEN
        CALL cl_err('','9004',0)
        RETURN
    END IF
 
    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = 
    "SELECT rpc03,rpc01,'','','',rpc12,rpc13,rpc131,rpc13-rpc131,ta_rpc01,ta_rpc02,ta_rpc03,ta_rpc02-ta_rpc03,rpc17",   #no.FUN-6B0045 #darcy:2023/03/06 add
    "  FROM rpc_file   ",
    " WHERE rpc02=?  ",
    "   AND rpc21=?  ",       #no.FUN-6B0045 ADD  
    "   AND rpc03=?  ",
    "   FOR UPDATE     "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i506_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    DISPLAY g_forupd_sql
 
    INPUT ARRAY g_rpc WITHOUT DEFAULTS FROM s_rpc.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF 
            CALL cl_set_docno_format("rpc02")      #NO.Fun-550055
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            IF g_rec_b>=l_ac THEN
                BEGIN WORK
                LET p_cmd='u'
                LET g_rpc_t.* = g_rpc[l_ac].*  #BACKUP
                LET g_before_input_done = FALSE                                                                                     
                CALL i506_set_entry_b(p_cmd)          #no.FUN-6B0045                                                                                
                CALL i506_set_no_entry_b(p_cmd)       #no.FUN-6B0045                                                                                
                LET g_before_input_done = TRUE                                                                                      
                OPEN i506_bcl USING g_rpc02,g_rpc21,
                                    g_rpc_t.rpc03 
                IF STATUS THEN
                   CALL cl_err("OPEN i506_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH i506_bcl INTO g_rpc[l_ac].* 
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock rpc:',SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   END IF
                END IF
                SELECT ima02,ima021,ima25 INTO g_rpc[l_ac].ima02 ,g_rpc[l_ac].ima021,g_rpc[l_ac].ima25 FROM ima_file
                 WHERE ima01=g_rpc[l_ac].rpc01
                IF STATUS <> 0 THEN
                   LET g_rpc[l_ac].ima02=' '
                   LET g_rpc[l_ac].ima021=' '
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            LET g_rpc[l_ac].rpc131 = 0            #no.FUN-6B0045
            DISPLAY BY NAME g_rpc[l_ac].rpc131    #NO.FUN-6B0045
            LET g_before_input_done = FALSE                                                                                     
            CALL i506_set_no_entry_b(p_cmd)       #no.FUN-6B0045                                                                                
            CALL i506_set_no_entry_b(p_cmd)       #no.FUN-6B0045                                                                                
            LET g_before_input_done = TRUE                                                                                      
            INITIALIZE g_rpc[l_ac].* TO NULL      #900423
            LET g_rpc_t.* = g_rpc[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD rpc03            #No.MOD-820182 add
 
        AFTER INSERT
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
              CLOSE i506_bcl
           END IF
           LET b_rpc.rpc01 =g_rpc[l_ac].rpc01
           LET b_rpc.rpc03 =g_rpc[l_ac].rpc03   #no.FUN-6B0045 mark
           LET b_rpc.rpc12 =g_rpc[l_ac].rpc12
           LET b_rpc.rpc13 =g_rpc[l_ac].rpc13
           LET b_rpc.rpc131=g_rpc[l_ac].rpc131
           LET b_rpc.rpc14 =0
           LET b_rpc.rpc16_fac =1
           LET b_rpc.rpc17 =g_rpc[l_ac].rpc17
           LET b_rpc.rpcacti ='Y'
           LET b_rpc.rpcuser =g_user
           LET g_data_plant = g_plant #FUN-980030
           LET b_rpc.rpcgrup =g_grup
           LET b_rpc.rpcdate =TODAY
           LET b_rpc.rpcplant =g_plant #FUN-980004 add
           LET b_rpc.rpclegal =g_legal #FUN-980004 add
           #darcy:2023/03/06 add s---
           let b_rpc.ta_rpc01 = g_rpc[l_ac].ta_rpc01
           let b_rpc.ta_rpc02 = g_rpc[l_ac].ta_rpc02
           let b_rpc.ta_rpc03 = g_rpc[l_ac].ta_rpc03
           #darcy:2023/03/06 add e---
           IF g_rpc[l_ac].rpc03 IS NULL THEN LET g_rpc[l_ac].rpc03=0 END IF    #no.FUN-6B0045 mark
           INSERT INTO rpc_file(rpc01,rpc02,rpc03,rpc04,
                                rpc10,rpc11,rpc12,rpc13,
                                rpc131,rpc14,rpc15,rpc16,
                                rpc16_fac,rpc17,rpc18,rpc19,
                                rpc20,rpc21,rpcacti,rpcuser,rpcgrup,rpcdate,rpcmodu,rpcplant,rpclegal,rpcoriu,rpcorig
                                ,ta_rpc01,ta_rpc02,ta_rpc03 #darcy:2023/03/06 add
                                ,ta_rpc06 #darcy:2023/07/29 add
                                )  #FUN-980004 add rpcplant,rpclegal                           
                         VALUES(b_rpc.rpc01,g_rpc02,b_rpc.rpc03,b_rpc.rpc04,
                                b_rpc.rpc10,g_rpc11,b_rpc.rpc12,b_rpc.rpc13,
                                b_rpc.rpc131,b_rpc.rpc14,b_rpc.rpc15,b_rpc.rpc16,
                                b_rpc.rpc16_fac,b_rpc.rpc17,g_rpc18,g_rpc19,
                                g_rpc20,g_rpc21,b_rpc.rpcacti,
                                b_rpc.rpcuser,b_rpc.rpcgrup,
                                b_rpc.rpcdate,b_rpc.rpcmodu,b_rpc.rpcplant,b_rpc.rpclegal, g_user, g_grup
                                ,b_rpc.ta_rpc01,b_rpc.ta_rpc02,b_rpc.ta_rpc03 #darcy:2023/03/06 add
                                ,g_ta_rpc06 #darcy:2023/07/29 add
                                ) #FUN-980004 add rpcplant,rpclegal       #No.FUN-980030 10/01/04  insert columns oriu, orig
           IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rpc_file",b_rpc.rpc01,b_rpc.rpc10,SQLCA.SQLCODE,"","ins rpc:",1)       #NO.FUN-660107
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
           END IF
 
        BEFORE FIELD rpc03                        #default 序號
            IF g_rpc[l_ac].rpc03 IS NULL OR
               g_rpc[l_ac].rpc03 = 0 THEN
                SELECT max(rpc03)+1 INTO g_rpc[l_ac].rpc03
                   FROM rpc_file
                   WHERE rpc02 = g_rpc02
                     AND rpc21 = g_rpc21
                IF g_rpc[l_ac].rpc03 IS NULL THEN
                    LET g_rpc[l_ac].rpc03 = 1
                END IF
            END IF
 
        AFTER FIELD rpc03                        #check 序號是否重複
            IF NOT cl_null(g_rpc[l_ac].rpc03) THEN 
               IF g_rpc[l_ac].rpc03 != g_rpc_t.rpc03 OR
                  g_rpc_t.rpc03 IS NULL THEN
                   SELECT count(*) INTO l_n
                       FROM rpc_file
                       WHERE rpc02 = g_rpc02
                         AND rpc21 = g_rpc21
                         AND rpc03 = g_rpc[l_ac].rpc03
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_rpc[l_ac].rpc03 = g_rpc_t.rpc03
                       NEXT FIELD rpc03
                   END IF
               END IF
            END IF
 
        AFTER FIELD rpc01                        #check 編號是否重複
            IF g_rpc[l_ac].rpc01 IS NOT NULL THEN
             #FUN-AA0059 --------------------ad start----------
              IF NOT s_chk_item_no(g_rpc[l_ac].rpc01,'') THEN
                 CALL cl_err('',g_errno,1)
                 LET g_rpc[l_ac].rpc01 = g_rpc_t.rpc01
                 NEXT FIELD  rpc01
              END IF
             #FUN-AA0059 --------------------add end---------------
              CALL i506_rpc01('a') 
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,1)
                 LET g_rpc[l_ac].rpc01 = g_rpc_t.rpc01
                 NEXT FIELD  rpc01
              END IF  
            ELSE                                   #FUN-650143 add
               CALL cl_err ('rpc01','mfg0037',1)   #FUN-650143 add
               NEXT FIELD rpc01                    #FUN-650143 add
            END IF
         
         #darcy:2023/03/06 add s---
         after field ta_rpc01
            if g_rpc[l_ac].ta_rpc01 is not null then 
              if not s_chk_item_no(g_rpc[l_ac].ta_rpc01,'') then
                 call cl_err('',g_errno,1)
                 let g_rpc[l_ac].ta_rpc01 = g_rpc_t.ta_rpc01
                 next field  ta_rpc01
              end if 
            #   call i506_rpc01('a') 
            #   if not cl_null(g_errno) then
            #      call cl_err('',g_errno,1)
            #      let g_rpc[l_ac].tc_rpc01 = g_rpc_t.tc_rpc01
            #      next field  tc_rpc01
            #   end if   
            end if
         after field ta_rpc02
            if cl_null(g_rpc[l_ac].ta_rpc03) then
               let g_rpc[l_ac].ta_rpc03 = 0
            end if
            let g_rpc[l_ac].diff2 = g_rpc[l_ac].ta_rpc02-g_rpc[l_ac].ta_rpc03 
            display by name g_rpc[l_ac].ta_rpc03
            display by name g_rpc[l_ac].diff2
         before field ta_rpc02
            if cl_null(g_rpc[l_ac].ta_rpc02) then
               let g_rpc[l_ac].ta_rpc02 = 0
            end if
         after field ta_rpc03
            if g_rpc[l_ac].ta_rpc03 is null then
              let g_rpc[l_ac].ta_rpc03=0
            else
               if g_rpc[l_ac].ta_rpc03 < 0 then
                  call cl_err(g_rpc[l_ac].ta_rpc03,'amr-080',0)
                  next field ta_rpc03
               end if
 
               update rpc_file 
                  set ta_rpc03 =g_rpc[l_ac].ta_rpc03
                where rpc02  =g_rpc02
                  and rpc21  =g_rpc21
                  and rpc03  =g_rpc[l_ac].rpc03
            end if
            let g_rpc[l_ac].diff2=g_rpc[l_ac].rpc13-g_rpc[l_ac].ta_rpc03 
            display by name g_rpc[l_ac].ta_rpc03
            display by name g_rpc[l_ac].diff2
            
         #darcy:2023/03/06 add e---
 
 
      #   AFTER FIELD rpc11  
      #       IF cl_null(g_rpc[l_ac].rpc11) THEN 
      #          LET g_rpc[l_ac].rpc11=1
      #          NEXT FIELD rpc11
      #       END IF
      #       IF g_rpc[l_ac].rpc11 < 1 OR g_rpc[l_ac].rpc11 > 5 THEN 
      #          LET g_rpc[l_ac].rpc11=1
      #          NEXT FIELD rpc11
      #       END IF
 
        AFTER FIELD rpc12
            IF cl_null(g_rpc[l_ac].rpc12) THEN
               CALL cl_err ('rpc12','mfg0037',1)
               NEXT FIELD rpc12
            END IF
 
        AFTER FIELD rpc13 
            IF cl_null(g_rpc[l_ac].rpc13) THEN
               LET g_rpc[l_ac].rpc13=0
               NEXT FIELD rpc13
            ELSE
               IF g_rpc[l_ac].rpc13 < 0 THEN
                  CALL cl_err(g_rpc[l_ac].rpc13,'amr-079',0)
                  NEXT FIELD rpc13
               END IF
            END IF
            IF cl_null(g_rpc[l_ac].rpc131) THEN
               LET g_rpc[l_ac].rpc131 = 0
               DISPLAY BY NAME g_rpc[l_ac].rpc131
            END IF
            LET g_rpc[l_ac].diff=g_rpc[l_ac].rpc13-g_rpc[l_ac].rpc131
            DISPLAY g_rpc[l_ac].diff TO s_rpc[l_sl].diff 
 
 
        BEFORE DELETE                            #是否取消單身
            IF g_rpc_t.rpc03 IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                DELETE FROM rpc_file WHERE 
                                       rpc02 = g_rpc02                #no.FUN-6B0045
                                       AND rpc21 = g_rpc21            #NO.FUN-6B0045
                                       AND rpc03 = g_rpc_t.rpc03      #no.FUN-6B0045 mark
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","rpc_file",g_rpc_t.rpc01,'',SQLCA.SQLCODE,"","1+2+3+4:",1)       #NO.FUN-660107   #no.FUN-6B0045 
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                MESSAGE "Delete OK"
                CLOSE i506_bcl
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN                 #900423
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rpc[l_ac].* = g_rpc_t.*
              CLOSE i506_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_rpc[l_ac].rpc01,-263,1)
               LET g_rpc[l_ac].* = g_rpc_t.*
           ELSE
               UPDATE rpc_file SET rpc01=g_rpc[l_ac].rpc01,
                                   rpc03=g_rpc[l_ac].rpc03,  #no.FUN-6B0045
                                   rpc12=g_rpc[l_ac].rpc12,
                                   rpc13=g_rpc[l_ac].rpc13,
                                   rpc131=g_rpc[l_ac].rpc131,
                                   #darcy:2023/03/06 add s---
                                   ta_rpc01=g_rpc[l_ac].ta_rpc01,
                                   ta_rpc02=g_rpc[l_ac].ta_rpc02,
                                   ta_rpc03=g_rpc[l_ac].ta_rpc03,
                                   #darcy:2023/03/06 add e---
                                   rpc17=g_rpc[l_ac].rpc17
                 WHERE rpc02=g_rpc02
                  AND rpc21=g_rpc21
                  AND rpc03=g_rpc_t.rpc03
                 AND rpc12=g_rpc_t.rpc12
        
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","rpc_file",g_rpc_t.rpc01,'',SQLCA.SQLCODE,"","upd rpc:",1)       #NO.FUN-660107  #no.FUN-6B0045
                  LET g_rpc[l_ac].* = g_rpc_t.*
                  DISPLAY g_rpc[l_ac].* TO s_rpc[l_sl].*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  CLOSE i506_bcl
                  COMMIT WORK
               END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            IF INT_FLAG THEN                 #900423
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_rpc[l_ac].* = g_rpc_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_rpc.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE i506_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac
            CLOSE i506_bcl
            COMMIT WORK
 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(rpc01) AND l_ac > 1 THEN
                LET g_rpc[l_ac].* = g_rpc[l_ac-1].*
                DISPLAY g_rpc[l_ac].* TO s_rpc[l_sl].* 
                NEXT FIELD rpc01
            END IF
 
        ON ACTION controlp
           CASE WHEN INFIELD(rpc01) #料件主檔
#FUN-AA0059 --Begin--
               #  CALL cl_init_qry_var()
               #  LET g_qryparam.form = "q_ima"
               #  LET g_qryparam.default1 = g_rpc[l_ac].rpc01
               #  CALL cl_create_qry() RETURNING g_rpc[l_ac].rpc01
                  CALL q_sel_ima(FALSE, "q_ima", "", g_rpc[l_ac].rpc01, "", "", "", "" ,"",'' )  RETURNING g_rpc[l_ac].rpc01
#FUN-AA0059 --End--
                  DISPLAY g_rpc[l_ac].rpc01 TO rpc01            #No.MOD-490371
                 NEXT FIELD rpc01
               OTHERWISE EXIT CASE
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
 
    CLOSE i506_bcl
    COMMIT WORK
END FUNCTION
 
#----------------------------No:FUN-8C0120 add ----------------------------
FUNCTION i506_copy()
   DEFINE   li_result LIKE type_file.num5      
   DEFINE   l_t1      LIKE oay_file.oayslip  
   DEFINE   l_n       LIKE type_file.num5,      
            l_newno   LIKE rpc_file.rpc02,
            l_oldno   LIKE rpc_file.rpc02,
            l_newrpc21  LIKE rpc_file.rpc21,
            l_oldrpc21  LIKE rpc_file.rpc21

   IF s_shut(0) THEN                             # 檢查權限
      RETURN
   END IF
   IF g_rpc02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")   
   LET l_newno = NULL
   LET l_newrpc21 = g_today
   INPUT l_newno,l_newrpc21 WITHOUT DEFAULTS FROM rpc02,rpc21

        AFTER FIELD rpc02
              IF NOT cl_null(l_newno) THEN
                CALL s_check_no("asf",l_newno,'',"L","rpc_file","rpc02","")
                RETURNING li_result,l_newno
                DISPLAY l_newno TO rpc02
                IF (NOT li_result) THEN
                  NEXT FIELD rpc02
                END IF
              END IF

        AFTER FIELD rpc21
            IF cl_null(l_newrpc21) THEN NEXT FIELD rpc21 END IF

        ON ACTION controlp
           CASE
              WHEN INFIELD(rpc02)
                   LET l_t1 = s_get_doc_no(g_rpc02) 
                   CALL q_smy( FALSE,TRUE,l_t1,'ASF','L') RETURNING l_t1
                   LET l_newno=l_t1   
                   DISPLAY l_newno TO rpc02
                   NEXT FIELD rpc02
           END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION help
         CALL cl_show_help()
      ON ACTION controlg
         CALL cl_cmdask()
      ON ACTION about
         CALL cl_about()

   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_rpc02 TO rpc02 
      DISPLAY g_rpc21 TO rpc21 
      RETURN
   END IF

   CALL s_auto_assign_no("asf",l_newno,l_newrpc21,"L","rpc_file","rpc02","","","")
        RETURNING li_result,l_newno
   IF (NOT li_result) THEN
      DISPLAY g_rpc02 TO rpc02 
      DISPLAY g_rpc21 TO rpc21 
      RETURN
   END IF
   DISPLAY l_newno TO rpc02

   DROP TABLE x
   SELECT * FROM rpc_file
     WHERE rpc02=g_rpc02 
       AND rpc21=g_rpc21
     INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x",g_rpc02,g_rpc21,SQLCA.sqlcode,"","",0)  
      RETURN
   END IF
   UPDATE x
      SET rpc02 = l_newno,                       # 資料鍵值
          rpc21 = l_newrpc21,
          rpc18 = 'N',
          rpc19 = 'N',
          rpc20 = NULL

   INSERT INTO rpc_file SELECT * FROM x 

   IF SQLCA.SQLCODE THEN
      CALL cl_err3("ins","rpc_file",l_newno,'',SQLCA.sqlcode,"","rpc",0)  
      RETURN
   END IF
   LET l_oldno = g_rpc02
   LET l_oldrpc21 = g_rpc21
   LET g_rpc02 = l_newno
   LET g_rpc21 = l_newrpc21

    SELECT rpc18,rpc19,rpc20,rpc11,ta_rpc06  #darcy:2023/07/29 add ta_rpc06
      INTO g_rpc18,g_rpc19,g_rpc20,g_rpc11,g_ta_rpc06  #darcy:2023/07/29 add g_ta_rpc06
      FROM rpc_file
     WHERE rpc02 = l_newno
       AND rpc21 = l_newrpc21
    DISPLAY g_rpc02 TO rpc02
    DISPLAY g_rpc21 TO rpc21
    DISPLAY g_rpc18 TO rpc18
    DISPLAY g_rpc19 TO rpc19
    DISPLAY g_rpc20 TO rpc20
    DISPLAY g_rpc11 TO rpc11
    display g_ta_rpc06 TO ta_rpc06  #darcy:2023/07/29 add g_ta_rpc06
    CALL cl_set_field_pic(g_rpc18,"","",g_rpc19,"","")

   CALL i506_b()
   #LET g_rpc02 = l_oldno    #FUN-C80046
   #LET g_rpc21 = l_oldrpc21 #FUN-C80046
   #CALL i506_show()         #FUN-C80046
END FUNCTION
#----------------------------No:FUN-8C0120 end ----------------------------

FUNCTION i506_rpc01(p_cmd)
DEFINE p_cmd       LIKE type_file.chr1,   
       l_imaacti   LIKE type_file.chr1     
 
   LET g_errno = ''
   SELECT ima02,ima021,ima25,imaacti 
     INTO g_rpc[l_ac].ima02,g_rpc[l_ac].ima021,g_rpc[l_ac].ima25,l_imaacti
     FROM ima_file
    WHERE ima01=g_rpc[l_ac].rpc01
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'   
                                  LET g_rpc[l_ac].ima02 ='' 
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN 
       DISPLAY g_rpc[l_ac].ima02 TO s_rpc[l_sl].ima02
       DISPLAY g_rpc[l_ac].ima021 TO s_rpc[l_sl].ima021 
       DISPLAY g_rpc[l_ac].ima25 TO s_rpc[l_sl].ima25 
    END IF
END FUNCTION
 
FUNCTION i506_cs() 
    CLEAR FORM
    CALL g_rpc.clear()
    IF NOT cl_null(g_argv1) THEN  
      LET g_wc = " rpc02 ='",g_argv1,"'"
      LET g_wc2 = ' 1=1'
    ELSE #FUN-840156
        CONSTRUCT g_wc ON rpc02,rpc21,rpc18,rpc19,rpc20,rpc03,rpc01,rpc12,rpc11,rpc13,rpc131,
                          ta_rpc01,ta_rpc02,ta_rpc03,rpc17,ta_rpc04,ta_rpc05 #darcy:2023/06/15 ta_rpc04/05   #darcy:2023/03/06 add #no.FUN-6B0045  #MOD-C70001 add ,rpc21,rpc18,rpc19,rpc20
                      FROM rpc02,rpc21,rpc18,rpc19,rpc20,s_rpc[1].rpc03,        #no.FUN-6B0045 add   #MOD-C70001 add ,rpc21,rpc18,rpc19,rpc20
                           s_rpc[1].rpc01,
                           s_rpc[1].rpc12,
                           rpc11,s_rpc[1].rpc13,
                           s_rpc[1].rpc131,
                           s_rpc[1].ta_rpc01,s_rpc[1].ta_rpc02,s_rpc[1].ta_rpc03,
                           s_rpc[1].rpc17,ta_rpc04,ta_rpc05 #darcy:2023/06/15 ta_rpc04/05
    
           BEFORE CONSTRUCT
              CALL cl_qbe_init()
    
           ON ACTION controlp
              CASE WHEN INFIELD(rpc01) #料件主檔
#FUN-AA0059 --Begin--
                   #   CALL cl_init_qry_var()
                   #   LET g_qryparam.state="c"
                   #   LET g_qryparam.form = "q_ima"
                   #   LET g_qryparam.default1 = g_rpc[1].rpc01
                   #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                      CALL q_sel_ima( TRUE, "q_ima","",g_rpc[1].rpc01,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                      DISPLAY g_qryparam.multiret TO rpc01              #No.MOD-490371
                      NEXT FIELD rpc01
                   WHEN INFIELD(rpc02)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state    = "c"
                      LET g_qryparam.form     = "q_rpc" 
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO rpc02
                      NEXT FIELD rpc02
                  OTHERWISE EXIT CASE
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
     
           ON ACTION qbe_select
              CALL cl_qbe_select() 
           ON ACTION qbe_save
              CALL cl_qbe_save()
        END CONSTRUCT
        LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rpcuser', 'rpcgrup') #FUN-980030
    
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_wc2 = NULL
          RETURN
       END IF
 
    END IF  #FUN-840156
   
    LET g_sql= "SELECT UNIQUE rpc02,rpc21 FROM rpc_file ",
               " WHERE ", g_wc CLIPPED,
               " ORDER BY rpc02"
    PREPARE i506_prepare FROM g_sql      #預備一下
    DECLARE i506_bcs                     #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR i506_prepare
 
    LET g_sql_tmp = "SELECT UNIQUE rpc02,rpc21 FROM rpc_file ", 
                " WHERE ", g_wc CLIPPED,
                " INTO TEMP x "
    DROP TABLE x
    PREPARE i506_precount_x FROM g_sql_tmp 
    EXECUTE i506_precount_x
 
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE i506_precount FROM g_sql
    DECLARE i506_count CURSOR FOR i506_precount
 
END FUNCTION
 
FUNCTION i506_a()
DEFINE li_result   LIKE type_file.num5      #NO.FUN-6B0045
 
    MESSAGE ""
    CLEAR FORM
    CALL g_rpc.clear()
    LET g_rpc02 = NULL
    LET g_rpc02_t  = NULL
    LET g_rpc21 = g_today
    LET g_rpc21_t = NULL
    LET g_rpc18 = 'N'
    LET g_rpc19 = 'N'
    LET g_rpc20 =NULL
    let g_rpc11 = 1
    let g_ta_rpc06 = 0  #darcy:2023/07/29 add
    DISPLAY g_rpc21 TO rpc21
    DISPLAY g_rpc18 TO rpc18
    DISPLAY g_rpc19 TO rpc19
    DISPLAY g_rpc20 TO rpc20
    DISPLAY g_rpc11 TO rpc11
    display g_ta_rpc06 TO ta_rpc06  #darcy:2023/07/29 add
    LET g_rec_b =0      
    CALL cl_opmsg('a')
    WHILE TRUE
        CALL i506_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET g_rpc02=NULL
            LET g_rpc21=NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_rpc02 IS NULL OR g_rpc21 IS NULL THEN
           CONTINUE WHILE 
        END IF
 
        BEGIN WORK  #No:7829
        CALL s_auto_assign_no("asf",g_rpc02,g_rpc21,"L","rpc_file","rpc02","","","")
             RETURNING li_result,g_rpc02
        IF (NOT li_result) THEN
           ROLLBACK WORK
           CONTINUE WHILE
        END IF
        DISPLAY g_rpc02 TO rpc02
        CALL i506_b()                      #輸入單身
        LET g_rpc02_t = g_rpc02
        LET g_rpc21_t = g_rpc21
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i506_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,    #a:輸入 u:更改 #No.FUN-680082 VARCHAR(1)
    l_n             LIKE type_file.num5,    #No.FUN-680082 SMALLINT
    l_str           LIKE type_file.chr1000  #No.FUN-680082 VARCHAR(40)
DEFINE li_result    LIKE type_file.num5     #NO.FUN-6B0045 
 
    DISPLAY g_rpc02 TO rpc02
    DISPLAY g_rpc21 TO rpc21
    CALL cl_set_head_visible("","YES")   
    INPUT g_rpc02,g_rpc21,g_rpc11,g_ta_rpc06 WITHOUT DEFAULTS FROM rpc02,rpc21,rpc11,ta_rpc06  #darcy:2023/07/29 add ta_rpc06
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i506_set_entry(p_cmd)
           CALL i506_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        BEFORE FIELD rpc02
           CALL i506_set_entry(p_cmd)
           CALL i506_set_no_entry(p_cmd)
 
        AFTER FIELD rpc02
           #IF p_cmd = "a" THEN  #FUN-B50026 mark
              IF NOT cl_null(g_rpc02) THEN
                CALL s_check_no("asf",g_rpc02,g_rpc02_t,"L","rpc_file","rpc02","")
                RETURNING li_result,g_rpc02
                DISPLAY g_rpc21 TO rpc21
                IF (NOT li_result) THEN
                  NEXT FIELD rpc02
                END IF
              END IF
           #END IF  #FUN-B50026 mark
 
        AFTER FIELD rpc21
            IF cl_null(g_rpc21) THEN NEXT FIELD rpc21 END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(rpc02)
                   LET g_t1 = s_get_doc_no(g_rpc02) 
                   CALL q_smy( FALSE,TRUE,g_t1,'ASF','L') RETURNING g_t1
                   LET g_rpc02=g_t1   
                   DISPLAY BY NAME g_rpc02
                   NEXT FIELD rpc02
           END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
    END INPUT
END FUNCTION
 
#Query 查詢
FUNCTION i506_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rpc02 TO NULL   
    INITIALIZE g_rpc21 TO NULL
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_rpc.clear()
    DISPLAY '    ' TO FORMONLY.cnt
    CALL i506_cs()                      #取得查詢條件
    IF INT_FLAG THEN                    #使用者不玩了
        LET INT_FLAG = 0
        INITIALIZE g_rpc02 TO NULL
        INITIALIZE g_rpc21 TO NULL
        RETURN
    END IF
    OPEN i506_bcs                       #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN               #有問題
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_rpc02 TO NULL
        INITIALIZE g_rpc21 TO NULL
    ELSE
        OPEN i506_count
        FETCH i506_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL i506_fetch('F')            #讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION i506_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,     #處理方式    #No.FUN-680082 VARCHAR(1)
    l_abso          LIKE type_file.num10     #絕對的筆數  #No.FUN-680082 INTEGER 
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     i506_bcs INTO g_rpc02,g_rpc21
        WHEN 'P' FETCH PREVIOUS i506_bcs INTO g_rpc02,g_rpc21
        WHEN 'F' FETCH FIRST    i506_bcs INTO g_rpc02,g_rpc21
        WHEN 'L' FETCH LAST     i506_bcs INTO g_rpc02,g_rpc21
        WHEN '/'
            IF (NOT mi_no_ask) THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
               END PROMPT
               IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
           END IF
           FETCH ABSOLUTE g_jump i506_bcs INTO g_rpc02,g_rpc21
           LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                  #有麻煩
        CALL cl_err(g_rpc02,SQLCA.sqlcode,0)
        INITIALIZE g_rpc02 TO NULL
        INITIALIZE g_rpc21 TO NULL
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    CALL i506_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i506_show()
    SELECT rpc18,rpc19,rpc20,rpc11,ta_rpc04,ta_rpc05,ta_rpc06
      INTO g_rpc18,g_rpc19,g_rpc20,g_rpc11,g_ta_rpc04,g_ta_rpc05,g_ta_rpc06 
      FROM rpc_file
     WHERE rpc02 = g_rpc02
       AND rpc21 = g_rpc21
    DISPLAY g_rpc02 TO rpc02
    DISPLAY g_rpc21 TO rpc21
    DISPLAY g_rpc18 TO rpc18
    DISPLAY g_rpc19 TO rpc19
    DISPLAY g_rpc20 TO rpc20
    DISPLAY g_rpc11 TO rpc11
    display g_ta_rpc06 to ta_rpc06
    display g_ta_rpc04 to ta_rpc04
    display g_ta_rpc05 to ta_rpc05
    CALL cl_set_field_pic(g_rpc18,"","",g_rpc19,"","")
    CALL i506_b_fill(g_wc)                      #單身
    CALL cl_show_fld_cont()  
END FUNCTION
 
 
FUNCTION i506_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000     #No.FUN-680082 VARCHAR(200)
 
    LET g_sql =
        "SELECT rpc03,rpc01,ima02,ima021,ima25,rpc12,rpc13,rpc131,rpc13-rpc131,ta_rpc01,ta_rpc02,ta_rpc03,ta_rpc02-ta_rpc03,rpc17", #darcy:2023/03/06  #no.FUN-6B0045
        " FROM rpc_file,OUTER ima_file",
        " WHERE rpc_file.rpc01=ima_file.ima01 ",
        "   AND rpc02= '",g_rpc02,"'",   #no.FUN-6B0045
        "   AND rpc21= '",g_rpc21,"'",   #no.FUN-6B0045
        "   AND ", p_wc2 CLIPPED,                     #單身
        " ORDER BY rpc03,rpc01,rpc12"        #no.FUN-6B0045
    PREPARE i506_pb FROM g_sql
    DECLARE rpc_curs CURSOR FOR i506_pb
 
   #MOD-B50186---modify---start---
   #FOR g_cnt = 1 TO g_rpc.getLength()           #單身 ARRAY 乾洗
   #   INITIALIZE g_rpc[g_cnt].* TO NULL
   #END FOR
    CALL g_rpc.clear()
   #MOD-B50186---modify---end---
    LET g_cnt = 1
    MESSAGE "Searching!" 
    FOREACH rpc_curs INTO g_rpc[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    MESSAGE ""
    CALL g_rpc.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i506_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1       #No.FUN-680082 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rpc TO s_rpc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         #FUN-9B0084 add---str--
         IF g_sma.sma901 != 'Y' THEN
             CALL cl_set_act_visible("aps_document_tracing",FALSE)
         END IF
         #FUN-9B0084 add---end--
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION first
         CALL i506_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                  
      ON ACTION previous
         CALL i506_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   
      ON ACTION jump
         CALL i506_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                  
      ON ACTION next
         CALL i506_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                 
      ON ACTION last
         CALL i506_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY         
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      ON ACTION close_the_case
         LET g_action_choice="close_the_case"
         EXIT DISPLAY
      ON ACTION maintain_used_require
         LET g_action_choice="maintain_used_require"
         EXIT DISPLAY

      #FUN-9B0084---add-----str---
      ON ACTION aps_document_tracing
         LET g_action_choice="aps_document_tracing"
         EXIT DISPLAY
      #FUN-9B0084---add-----end---

      #darcy:2023/03/06 add s---
      on action maintain_used_require2
         let g_action_choice = "maintain_used_require2"
         exit display
      on action maintain_used_modify
         let g_action_choice = "maintain_used_modify"
         exit display
      #darcy:2023/03/06 add e---

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

     #-----------No:FUN-8C0120 add
      ON ACTION reproduce                        # C.複製
         LET g_action_choice="reproduce"
         EXIT DISPLAY
     #-----------No:FUN-8C0120 end
 
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
   
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION i506_out()
    DEFINE
        l_rpc           RECORD LIKE rpc_file.*,
        l_i             LIKE type_file.num5,          #No.FUN-680082 SMALLINT 
        l_name          LIKE type_file.chr20,         #No.FUN-680082 VARCHAR(20)
        l_za05          LIKE type_file.chr1000        #No.FUN-680082 VARCHAR(40)
     DEFINE g_str       STRING                        #No.FUN-850048   
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05    FROM zz_file WHERE zz01 = g_prog
     LET g_sql="SELECT rpc02,rpc21,rpc01,ima02,ima021,ima25,rpc03,rpc12,rpc13,rpc131 ",                                                          
               " FROM rpc_file LEFT OUTER JOIN ima_file ON rpc01 = ima01 ",                                                                                    
               " WHERE rpc02 = '",g_rpc02,"'",                                                                                      
               "    AND rpc21 = '",g_rpc21,"'",                                                                                      
               " "                                                                                              
    IF g_zz05 = 'Y' THEN                                                                                                            
        CALL cl_wcchp(g_wc,'rpc02,rpc03,rpc01,rpc12,rpc11,rpc13,rpc131,rpc17                                                        
                            FROM rpc02,s_rpc[1].rpc03,s_rpc[1].rpc01,                                                               
                            s_rpc[1].rpc12,rpc11,s_rpc[1].rpc13,                                                           
                            s_rpc[1].rpc131,s_rpc[1].rpc17')                                                                        
        RETURNING g_wc                                                                                                              
        LET g_str = g_wc                                                                                                            
     END IF                                                                                                                         
     LET g_str =g_str                                                                                                               
     CALL cl_prt_cs1('amri506','amri506',g_sql,g_str)     
END FUNCTION
 
FUNCTION i506_set_entry(p_cmd) 
DEFINE   p_cmd   LIKE type_file.chr1    
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("rpc02,rpc21",TRUE) 
   END IF
END FUNCTION
 
FUNCTION i506_set_no_entry(p_cmd)  
DEFINE   p_cmd   LIKE type_file.chr1 
   
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN                                                              
   END IF                                                                                                                           
END FUNCTION
 
FUNCTION i506_set_entry_maintain() 
    CALL cl_set_comp_entry("rpc131",TRUE) 
    CALL cl_set_comp_entry("ta_rpc03",TRUE) #darcy:2023/03/06 add 
END FUNCTION
 
FUNCTION i506_set_no_entry_maintain()  
      CALL cl_set_comp_entry("rpc01,rpc12,rpc03,rpc11,rpc13,rpc17,tc_rpc01",FALSE) #darcy:2023/03/06 mod
END FUNCTION
 
FUNCTION i506_set_entry_b(p_cmd)  #no.FUN-6B0045 add                                                                                                      
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680082 VARCHAR(1)
                                                                                                                                    
      CALL cl_set_comp_entry("rpc01,rpc12,rpc03,rpc11,rpc13,rpc131,rpc17,ta_rpc01,ta_rpc02",TRUE) #darcy:2023/03/06 mod #no.FUN-6B0045
END FUNCTION                                                                                                                        
                                                                                                                                    
FUNCTION i506_set_no_entry_b(p_cmd)       #NO.FUN-6B0045 ADD                                                                                                    
DEFINE   p_cmd   LIKE type_file.chr1      #No.FUN-680082 VARCHAR(1)
 
   CALL cl_set_comp_entry("rpc131",FALSE)   #no.FUN-6B0045
   CALL cl_set_comp_entry("ta_rpc03",FALSE)   #darcy:2023/03/06 add
END FUNCTION                                                                                                                        
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION i506_r()
    IF s_shut(0) THEN RETURN END IF
    IF g_rpc02 IS NULL OR g_rpc21 IS NULL THEN
       CALL cl_err("",-400,0)  
       RETURN
    END IF
    IF g_rpc18 = 'Y' THEN                                                                                                           
       CALL cl_err('','apm-067',0)                                                                                                  
       RETURN                                                                                                                       
    END IF                                                                                                                          
    BEGIN WORK
    IF cl_delh(0,0) THEN                   #確認一下
        DELETE FROM rpc_file 
         WHERE rpc02 = g_rpc02
           AND rpc21 = g_rpc21
        IF SQLCA.sqlcode THEN
             CALL cl_err3("del","rpc_file",g_rpc02,g_rpc21,SQLCA.SQLCODE,"","BODY DELETE:",1)    
        ELSE
            CLEAR FORM
            DROP TABLE x
            PREPARE i506_precount_x2 FROM g_sql_tmp 
            EXECUTE i506_precount_x2               
            CALL g_rpc.clear()
            LET g_cnt=SQLCA.SQLERRD[3]
            MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
            OPEN i506_count
            #FUN-B50063-add-start--
            IF STATUS THEN
               CLOSE i506_bcs
               CLOSE i506_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end-- 
            FETCH i506_count INTO g_row_count
            #FUN-B50063-add-start--
            IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
               CLOSE i506_bcs
               CLOSE i506_count
               COMMIT WORK
               RETURN
            END IF
            #FUN-B50063-add-end--
            DISPLAY g_row_count TO FORMONLY.cnt
            OPEN i506_bcs
            IF g_curs_index = g_row_count + 1 THEN
               LET g_jump = g_row_count
               CALL i506_fetch('L')
            ELSE
               LET g_jump = g_curs_index
               LET mi_no_ask = TRUE
               CALL i506_fetch('/')
            END IF
        END IF
    END IF
    COMMIT WORK
END FUNCTION
 
FUNCTION i506_x()
   IF s_shut(0) THEN RETURN END IF
   BEGIN WORK
 
   IF cl_null(g_rpc02) OR g_rpc21 IS NULL THEN 
       CALL cl_err('',-400,0) RETURN 
   END IF
   IF g_rpc18 ='N' THEN
       CALL cl_err('','9026',0)
       RETURN 
   END IF
   IF cl_close(0,0,g_rpc19)   THEN
        LET g_chr=g_rpc19
        IF g_rpc19='N' THEN
            LET g_rpc19='Y'
            LET g_rpc20=g_today
        ELSE
            LET g_rpc19='N'
            LET g_rpc20= NULL
        END IF
        UPDATE rpc_file                
            SET rpc19 =g_rpc19,
                rpc20 =g_rpc20
            WHERE rpc02 = g_rpc02
              AND rpc21 = g_rpc21
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
             CALL cl_err3("upd","rpc_file",g_rpc02,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660107
            LET g_rpc19=g_chr
            ROLLBACK WORK
        ELSE
            COMMIT WORK
        END IF
        DISPLAY g_rpc19 TO rpc19 
        DISPLAY g_rpc20 TO rpc20
   END IF 
END FUNCTION
 
FUNCTION i506_y()
DEFINE l_cnt       LIKE type_file.num5     #No.FUN-680096
DEFINE l_str       LIKE type_file.chr4     #No.FUN-680096 VARCHAR(04)
DEFINE l_rpc15     LIKE rpc_file.rpc15     #add FUN-AB0065
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_rpc02) AND cl_null(g_rpc21) THEN CALL cl_err('',-400,0) RETURN END IF
 
#CHI-C30107 ------------- add ------------- begin
   IF g_rpc18='Y'      THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF
   IF g_rpc19 = 'Y' THEN
      CALL cl_err('','axr-013',0)
      RETURN
   END IF
   IF g_action_choice CLIPPED = "confirm"       #按「確認」時
   THEN
        IF NOT cl_confirm('axm-108') THEN
           RETURN
        END IF
   END IF
   SELECT rpc18,rpc19 INTO g_rpc18,g_rpc19 FROM rpc_file
    WHERE rpc02 = g_rpc02
      AND rpc21 = g_rpc21
#CHI-C30107 ------------- add ------------- end
   IF g_rpc18='Y'      THEN
      CALL cl_err('','9023',0)
      RETURN
   END IF
   IF g_rpc19 = 'Y' THEN
      CALL cl_err('','axr-013',0)
      RETURN 
   END IF
 
   LET l_cnt =0
   SELECT COUNT(*) INTO l_cnt FROM rpc_file
    WHERE rpc02 = g_rpc02
      AND rpc21 = g_rpc21
   IF l_cnt=0 OR cl_null(l_cnt) THEN
      CALL cl_err('','mfg-008',0)
      RETURN
   END IF
 
#CHI-C30107 ---------- mark ---------- begin
#  IF g_action_choice CLIPPED = "confirm"       #按「確認」時
#  THEN
#       IF NOT cl_confirm('axm-108') THEN 
#          RETURN
#       END IF
#  END IF
#CHI-C30107 ---------- mark ---------- end
   #add FUN-AB0065
   DECLARE i506_rpc15 CURSOR FOR 
     SELECT rpc15 FROM rpc_file 
      WHERE rpc02 = g_rpc02
        AND rpc21 = g_rpc21
   FOREACH i506_rpc15 INTO l_rpc15
   IF NOT s_chk_ware(l_rpc15) THEN #检查仓库是否属于当前门店 
      LET g_success='N'
      RETURN
   END IF
   END FOREACH 
   #end FUN-AB0065
   LET g_chr = g_rpc18
   UPDATE rpc_file SET rpc18='Y' WHERE rpc02 = g_rpc02 AND rpc21 = g_rpc21  
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("upd","rpc_file",g_rpc02,"",SQLCA.SQLCODE,"","upd rpc18:",1) # TQC-660046
       LET g_rpc18 = g_chr
   ELSE
       LET g_rpc18 = 'Y'
   END IF
   DISPLAY g_rpc18 TO rpc18
END FUNCTION
 
FUNCTION i506_z()
DEFINE l_cnt       LIKE type_file.num5     #No.FUN-680096
DEFINE l_str       LIKE type_file.chr4     #No.FUN-680096 VARCHAR(04)
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_rpc02) AND cl_null(g_rpc21) THEN CALL cl_err('',-400,0) RETURN END IF
 
   IF g_rpc18='N'      THEN
      CALL cl_err('','9025',0)
      RETURN
   END IF
   IF g_rpc19 = 'Y' THEN
      CALL cl_err('','axr-013',0)
      RETURN 
   END IF
 
   IF g_action_choice CLIPPED = "undo_confirm"       #按「取消確認」時
   THEN
        IF NOT cl_confirm('aim-304') THEN 
           RETURN
        END IF
   END IF
   LET g_chr = g_rpc18
   UPDATE rpc_file SET rpc18='N' WHERE rpc02 = g_rpc02 AND rpc21 = g_rpc21  
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("upd","rpc_file",g_rpc02,"",SQLCA.SQLCODE,"","upd rpc18:",1) # TQC-660046
       LET g_rpc18 = g_chr
   ELSE
       LET g_rpc18 = 'N'
   END IF
   DISPLAY g_rpc18 TO rpc18
END FUNCTION
 
FUNCTION i506_require()
DEFINE rpc131  LIKE rpc_file.rpc131
DEFINE p_cmd           LIKE type_file.chr1
 
    IF s_shut(0) THEN RETURN END IF
    IF g_rpc02 IS NULL OR g_rpc21 IS NULL THEN
        RETURN 
    END IF
 
    IF g_rpc18 ='N' THEN
        CALL cl_err('','aap-717',0)
        RETURN 
    END IF
 
    IF g_rpc19 = 'Y' THEN
        CALL cl_err('','9004',0)
        RETURN
    END IF
 
    CALL i506_set_entry_maintain()
    CALL i506_set_no_entry_maintain()
 
    INPUT ARRAY g_rpc WITHOUT DEFAULTS FROM s_rpc.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
        BEFORE ROW
            LET l_ac = ARR_CURR()
 
        AFTER FIELD rpc131 
            IF g_rpc[l_ac].rpc131 IS NULL THEN
              LET g_rpc[l_ac].rpc131=0
            ELSE
               IF g_rpc[l_ac].rpc131 < 0 THEN
                  CALL cl_err(g_rpc[l_ac].rpc131,'amr-080',0)
                  NEXT FIELD rpc131
               END IF
 
               UPDATE rpc_file 
                  SET rpc131 =g_rpc[l_ac].rpc131
                WHERE rpc02  =g_rpc02
                  AND rpc21  =g_rpc21
                  AND rpc03  =g_rpc[l_ac].rpc03
            END IF
            LET g_rpc[l_ac].diff=g_rpc[l_ac].rpc13-g_rpc[l_ac].rpc131
            DISPLAY BY NAME g_rpc[l_ac].rpc131
            DISPLAY BY NAME g_rpc[l_ac].diff
         #darcy:2023/03/06 add s--- 

         after field ta_rpc03
            if g_rpc[l_ac].ta_rpc03 is null then
              let g_rpc[l_ac].ta_rpc03=0
            else
               if g_rpc[l_ac].ta_rpc03 < 0 then
                  call cl_err(g_rpc[l_ac].ta_rpc03,'amr-080',0)
                  next field ta_rpc03
               end if
 
               update rpc_file 
                  set ta_rpc03 =g_rpc[l_ac].ta_rpc03
                where rpc02  =g_rpc02
                  and rpc21  =g_rpc21
                  and rpc03  =g_rpc[l_ac].rpc03
            end if
            let g_rpc[l_ac].diff2=g_rpc[l_ac].ta_rpc02-g_rpc[l_ac].ta_rpc03 
            display by name g_rpc[l_ac].ta_rpc03
            display by name g_rpc[l_ac].diff2
         #darcy:2023/03/06 add e---
        ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
    END INPUT
    LET g_action_choice = ' '
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/14
#FUN-B50046

#darcy:2023/03/06 add s---
function i506_require2()
   define l_tc_rpc dynamic array of tc_rpc
   define l_tc_rpc_t tc_rpc
   define l_ac     like type_file.num5
   define l_sum    like type_file.num20_6
   define i        like type_file.num5
   define l_tc_rpc02 like type_file.num5
   define l_lock_sw like type_file.chr1
   define l_n like type_file.num5
   define l_sql  string

   if g_rpc02 is null or g_rpc21 is null then
      return 
   end if

   if g_rpc18 ='N' then
      call cl_err('','aap-717',0)
      return 
   end if

   if g_rpc19 = 'Y' then
      call cl_err('','9004',0)
      return
   end if

   let l_sql = "SELECT ROWNUM,ta_rpc01,ta_rpc02,0,0,ta_rpc02,'','','Y',to_date(to_char(SYSDATE, 'yymmdd'), 'yymmdd'),",
               "'",g_user,"',to_date(to_char(SYSDATE, 'yymmdd'), 'yymmdd'),'",g_user,"'",
               # ",tc_rpc",--需求数量
               "FROM (SELECT UNIQUE ta_rpc01,ta_rpc02 from rpc_file WHERE rpc02 = ? and rpc21 = ?)" 
   prepare b_require2_p from l_sql
   declare b_require2_c cursor for b_require2_p

   select max(tc_rpc02) into l_tc_rpc02 from tc_rpc_file where tc_rpc01= g_rpc02 and tc_rpc03 =g_rpc21
   if cl_null(l_tc_rpc02) or l_tc_rpc02 = 0 then
      let l_tc_rpc02 = 1
   else
      let l_tc_rpc02 = l_tc_rpc02 + 1
   end if

   let l_ac = 1
   call l_tc_rpc.clear()
   foreach b_require2_c using g_rpc02,g_rpc21
      into l_tc_rpc[l_ac].*
      if status then
         call cl_err('b_require2_c',status,1)
         exit foreach
      end if
      # 非本单已耗用
      select sum(tc_rpc06) into l_tc_rpc[l_ac].ta_rpc03_2 from tc_rpc_file 
       where tc_rpc01 = g_rpc02  --单号
         and tc_rpc03=g_rpc21 --单据日期
         and tc_rpc05 = l_tc_rpc[l_ac].tc_rpc05 --成品料号
         and tc_rpc14 = l_tc_rpc[l_ac].ta_rpc02_2  --需求数量 可以区分不同需求数量的成品料号
         and tc_rpc02 != l_tc_rpc02 --项序排除当前版本
         and tc_rpc09 = 'Y' --有效状态才计算

      let l_tc_rpc[l_ac].tc_rpc02 = l_tc_rpc02

      if cl_null(l_tc_rpc[l_ac].ta_rpc03_2) then
         let l_tc_rpc[l_ac].ta_rpc03_2 = 0
      end if

      let l_tc_rpc[l_ac].diff3 = l_tc_rpc[l_ac].ta_rpc02_2-l_tc_rpc[l_ac].ta_rpc03_2-l_tc_rpc[l_ac].tc_rpc06

      let l_ac = l_ac + 1
   end foreach
   call l_tc_rpc.deleteElement(l_ac)
   let l_ac = l_ac - 1

   open window i506_1_w at 3,2 with form "amr/42f/amri506_1"
         attribute (style = g_win_style clipped)
   
   call cl_ui_init()

   input array l_tc_rpc without defaults from s_tc_rpc.*
         attribute (count=g_rec_b,maxcount=g_max_rec,unbuffered,
                    insert row = false,delete row = false,append row = false)

      before input
         if g_rec_b !=0 then
            call fgl_set_arr_curr(l_ac)
         end if
      
      before row
         let l_ac = arr_curr()
         let l_lock_sw = 'N'
         let l_n = arr_count()
 
         let l_tc_rpc_t.* = l_tc_rpc[l_ac].*
         let g_before_input_done  = false
         #TODO: entry
         call cl_set_comp_entry("tc_rpc06,tc_rpc07,tc_rpc08",true)
         call cl_set_comp_entry("tc_rpc04,tc_rpc05,ta_rpc02_2,ta_rpc03_2,diff3,tc_rpc09,tc_rpc10,tc_rpc11,tc_rpc12,tc_rpc13,tc_rpc02",false)

      after field tc_rpc06
         if not cl_null(l_tc_rpc[l_ac].tc_rpc06) and l_tc_rpc[l_ac].tc_rpc06 !=0 then
            if l_tc_rpc[l_ac].tc_rpc06 <0 then
               call cl_err('不可小于0','!',1)
               next field tc_rpc06
            end if
            #检查数量是否超过需求数量
            select sum(tc_rpc06) into l_sum from tc_rpc_file 
             where tc_rpc01 = g_rpc02  --单号
               and tc_rpc03=g_rpc21 --单据日期
               and tc_rpc05 = l_tc_rpc[l_ac].tc_rpc05 --成品料号
               and tc_rpc14 = l_tc_rpc[l_ac].ta_rpc02_2  --需求数量 可以区分不同需求数量的成品料号
               and tc_rpc02 != l_tc_rpc02 --项序排除当前版本
               and tc_rpc09 = 'Y' --有效状态才计算
            if cl_null(l_sum) then
               let l_sum = 0
            end if
            if l_tc_rpc[l_ac].tc_rpc06+l_sum > l_tc_rpc[l_ac].ta_rpc02_2 then
            #大于需求数量
               call cl_err(l_tc_rpc[l_ac].tc_rpc06+l_sum,'!',1)
               next field tc_rpc06
            end if
            let l_tc_rpc[l_ac].ta_rpc03_2 = l_sum
            let l_tc_rpc[l_ac].diff3 = l_tc_rpc[l_ac].ta_rpc02_2-l_tc_rpc[l_ac].ta_rpc03_2-l_tc_rpc[l_ac].tc_rpc06
         end if
      
      on change tc_rpc06

      on row change
      
      after row 
 
      on idle g_idle_seconds
           call cl_on_idle()
           continue input
 
      on action about         #mod-4c0121
         call cl_about()      #mod-4c0121

      on action help          #mod-4c0121
         call cl_show_help()

      on action accept
         begin work
         let g_success = 'Y'
         for i=1 to l_tc_rpc.getLength()
            insert into tc_rpc_file 
            (tc_rpc01,tc_rpc02,tc_rpc03,tc_rpc04,tc_rpc05,
             tc_rpc06,tc_rpc07,tc_rpc08,tc_rpc09,tc_rpc10,
             tc_rpc11,tc_rpc12,tc_rpc13,tc_rpc14)
            values (g_rpc02,l_tc_rpc02,g_rpc21,l_tc_rpc[i].tc_rpc04,l_tc_rpc[i].tc_rpc05,
                    l_tc_rpc[i].tc_rpc06,l_tc_rpc[i].tc_rpc07,l_tc_rpc[i].tc_rpc08,l_tc_rpc[i].tc_rpc09,l_tc_rpc[i].tc_rpc10,
                    l_tc_rpc[i].tc_rpc11,l_tc_rpc[i].tc_rpc12,l_tc_rpc[i].tc_rpc13,l_tc_rpc[i].ta_rpc02_2)
            if status then
               call cl_err('ins tc_rpc_file',status,1)
               rollback work
               exit for
               let g_success = 'N'
            end if

            select sum(tc_rpc06) into l_sum from tc_rpc_file 
             where tc_rpc01 = g_rpc02  --单号
               and tc_rpc03= g_rpc21 --单据日期
               and tc_rpc05 = l_tc_rpc[i].tc_rpc05 --成品料号
               and tc_rpc14 = l_tc_rpc[i].ta_rpc02_2  --需求数量 可以区分不同需求数量的成品料号
               and tc_rpc09 = 'Y' --有效状态才计算
            if cl_null(l_sum) then
               let l_sum = 0
            end if

            #更新rpc_file
            update rpc_file 
               set ta_rpc03 = l_sum,
                     rpc131 = rpc13/ta_rpc02*l_sum
               where rpc02 = g_rpc02 and rpc21 = g_rpc21
               and ta_rpc01 = l_tc_rpc[i].tc_rpc05 and ta_rpc02 = l_tc_rpc[i].ta_rpc02_2
            if sqlca.sqlcode then
               call cl_err3("upd","rpc_file",l_tc_rpc_t.tc_rpc05,'',sqlca.sqlcode,"","upd tc_rpc:",1)       #no.fun-660107  #no.fun-6b0045
               let l_tc_rpc[i].* = l_tc_rpc_t.*
               display l_tc_rpc[i].* to s_tc_rpc[l_sl].*
               rollback work
            else
               message 'update o.k'
               commit work
            end if
         end for
         if g_success = 'Y' then
            commit work
         end if

         exit input

      on action cancel
         exit input

   end input

   close window i506_1_w
   call i506_b_fill(g_wc)
end function

# 修改已有的需求量
function i506_require_modify()
   define l_tc_rpc dynamic array of tc_rpc
   define l_tc_rpc_t tc_rpc
   define l_ac,l_ac_t  like type_file.num5
   define l_sum    like type_file.num20_6
   define i        like type_file.num5
   define l_sql    string
   define l_lock_sw like type_file.chr1
   define l_n like type_file.num5

   if g_rpc02 is null or g_rpc21 is null then
      return 
   end if

   if g_rpc18 ='N' then
      call cl_err('','aap-717',0)
      return 
   end if

   if g_rpc19 = 'Y' then
      call cl_err('','9004',0)
      return
   end if

   let l_sql = "select tc_rpc04,tc_rpc05,tc_rpc14,0,tc_rpc06,tc_rpc14-tc_rpc06,tc_rpc07,",
               " tc_rpc08,tc_rpc09,tc_rpc10,tc_rpc11,tc_rpc12,tc_rpc13,tc_rpc02",
               " from tc_rpc_file where tc_rpc01 = ? and tc_rpc03 = ? "
   prepare p_i506_req_mod_p from l_sql
   declare p_i506_req_mod_c cursor for p_i506_req_mod_p

   let l_ac = 1
   call l_tc_rpc.clear()

   foreach p_i506_req_mod_c using g_rpc02,g_rpc21
      into l_tc_rpc[l_ac].*
      if status then
         call cl_err('p_i506_req_mod_c','!',1)
         exit foreach
      end if
      # 非本单已耗用
      select sum(tc_rpc06) into l_tc_rpc[l_ac].ta_rpc03_2 from tc_rpc_file 
       where tc_rpc01 = g_rpc02  --单号
         and tc_rpc03=g_rpc21 --单据日期
         and tc_rpc05 = l_tc_rpc[l_ac].tc_rpc05 --成品料号
         and tc_rpc14 = l_tc_rpc[l_ac].ta_rpc02_2  --需求数量 可以区分不同需求数量的成品料号
         and tc_rpc02 != l_tc_rpc[l_ac].tc_rpc02 --项序排除当前版本
         and tc_rpc09 = 'Y' --有效状态才计算

      if cl_null(l_tc_rpc[l_ac].ta_rpc03_2) then
         let l_tc_rpc[l_ac].ta_rpc03_2 = 0
      end if

      let l_ac = l_ac + 1
   end foreach
   # 如果没有直接返回
   if l_ac = 1 then
      message "无资料维护，请先新增"
   end if
   call l_tc_rpc.deleteElement(l_ac)
   let l_ac = 1

   open window i506_1_w at 3,2 with form "amr/42f/amri506_1"
         attribute (style = g_win_style clipped)
   
   call cl_ui_init()

   let g_forupd_sql = "select tc_rpc04,tc_rpc05,tc_rpc14,0,tc_rpc06,tc_rpc14-tc_rpc06,tc_rpc07,",
                      " tc_rpc08,tc_rpc09,tc_rpc10,tc_rpc11,tc_rpc12,tc_rpc13,tc_rpc02",
                      " from tc_rpc_file where tc_rpc01 = ? and tc_rpc02 = ?  and tc_rpc03 = ? and tc_rpc04 = ?",
                      " for update"
   let g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   declare i506_req_mod cursor from g_forupd_sql
   display g_forupd_sql

   # 修改历史记录，只允许修改，不能新增删除
   input array l_tc_rpc without defaults from s_tc_rpc.*
         attribute (count=g_rec_b,maxcount=g_max_rec,unbuffered,
                    insert row = false,delete row = false,append row = true)

      before input

      before row
         let l_ac = arr_curr()
         let l_lock_sw = 'N'
         let l_n = arr_count()
         begin work
         let l_tc_rpc_t.* = l_tc_rpc[l_ac].*
         let g_before_input_done = false
         #entry s---
         if l_tc_rpc[l_ac].tc_rpc09 ='Y' then
            call cl_set_comp_entry('tc_rpc06,tc_rpc07,tc_rpc08',true)
         else
            call cl_set_comp_entry('tc_rpc07,tc_rpc08',true)
         end if
         call cl_set_comp_entry('tc_rpc04,tc_rpc05,ta_rpc02_2,ta_rpc03_2,diff3,tc_rpc10,tc_rpc11,tc_rpc12,tc_rpc13,tc_rpc02',false)
         #entry e---
         call cl_set_comp_visible('ta_rpc03_2,diff3',false)
         open i506_req_mod using g_rpc02,l_tc_rpc_t.tc_rpc02,g_rpc21,l_tc_rpc_t.tc_rpc04
         if status then
            call cl_err("open i506_req_mod:", status, 1)
            let l_lock_sw = "Y"
         else
            fetch i506_req_mod into l_tc_rpc[l_ac].*
            if sqlca.sqlcode then
               call cl_err('lock tc_rpc:',sqlca.sqlcode,1)
               let l_lock_sw = "Y"
            end if
            select sum(tc_rpc06) into l_tc_rpc[l_ac].ta_rpc03_2 from tc_rpc_file 
             where tc_rpc01 = g_rpc02  --单号
               and tc_rpc03=g_rpc21 --单据日期
               and tc_rpc05 = l_tc_rpc[l_ac].tc_rpc05 --成品料号
               and tc_rpc14 = l_tc_rpc[l_ac].ta_rpc02_2  --需求数量 可以区分不同需求数量的成品料号
               and tc_rpc02 != l_tc_rpc[l_ac].tc_rpc02 --项序排除当前版本
               and tc_rpc09 = 'Y' --有效状态才计算
            if cl_null(l_tc_rpc[l_ac].ta_rpc03_2) then
               let l_tc_rpc[l_ac].ta_rpc03_2 = 0
            end if
         end if

         call cl_show_fld_cont()
      
      on row change
         if int_flag then                 #900423
            call cl_err('',9001,0)
            let int_flag = 0
            let l_tc_rpc[l_ac].* = l_tc_rpc_t.*
            close i506_req_mod
            rollback work
            exit input
         end if
         if l_lock_sw = 'y' then
            call cl_err(l_tc_rpc[l_ac].tc_rpc05,-263,1)
            let l_tc_rpc[l_ac].* = l_tc_rpc_t.*
         else
            update tc_rpc_file
               set tc_rpc06 = l_tc_rpc[l_ac].tc_rpc06
             where tc_rpc01 = g_rpc02 and tc_rpc02 = l_tc_rpc_t.tc_rpc02
               and tc_rpc03 = g_rpc21 and tc_rpc04 = l_tc_rpc_t.tc_rpc04
            if sqlca.sqlcode then
               call cl_err3("upd","rpc_file",l_tc_rpc_t.tc_rpc05,'',sqlca.sqlcode,"","upd tc_rpc:",1)       #no.fun-660107  #no.fun-6b0045
               let l_tc_rpc[l_ac].* = l_tc_rpc_t.*
               display l_tc_rpc[l_ac].* to s_tc_rpc[l_sl].*
            else
               #close i506_req_mod
                  #commit work
                  let l_tc_rpc[l_ac].tc_rpc09 = 'N'

                  select sum(tc_rpc06) into l_sum from tc_rpc_file 
                   where tc_rpc01 = g_rpc02  --单号
                     and tc_rpc03= g_rpc21 --单据日期
                     and tc_rpc05 = l_tc_rpc[l_ac].tc_rpc05 --成品料号
                     and tc_rpc14 = l_tc_rpc[l_ac].ta_rpc02_2  --需求数量 可以区分不同需求数量的成品料号
                     and tc_rpc09 = 'Y' --有效状态才计算
                  if cl_null(l_sum) then
                     let l_sum = 0
                  end if

                  #更新rpc_file
                  update rpc_file 
                     set ta_rpc03 = l_sum,
                         rpc131 = rpc13/ta_rpc02*l_sum
                   where rpc02 = g_rpc02 and rpc21 = g_rpc21
                     and ta_rpc01 = l_tc_rpc[l_ac].tc_rpc05 and ta_rpc02 = l_tc_rpc[l_ac].ta_rpc02_2
                  if sqlca.sqlcode then
                     call cl_err3("upd","rpc_file",l_tc_rpc_t.tc_rpc05,'',sqlca.sqlcode,"","upd tc_rpc:",1)       #no.fun-660107  #no.fun-6b0045
                     let l_tc_rpc[l_ac].* = l_tc_rpc_t.*
                     display l_tc_rpc[l_ac].* to s_tc_rpc[l_sl].*
                     rollback work
                  else
                     message 'update o.k'
                     close i506_req_mod
                     commit work
                  end if
            end if
         end if

      after row
         let l_ac = arr_curr()
         if int_flag then
            call cl_err('',9001,0)
            let int_flag = 0
            LET l_tc_rpc[l_ac].* = l_tc_rpc_t.*

            close i506_req_mod
         end if
         let l_ac_t = l_ac
         commit work

      on change tc_rpc06
         if not cl_null(l_tc_rpc[l_ac].tc_rpc06) and l_tc_rpc[l_ac].tc_rpc06 !=0 then
            if l_tc_rpc[l_ac].tc_rpc06 <0 then
               call cl_err('不可小于0','!',1)
               next field tc_rpc06
            end if
            #检查数量是否超过需求数量
            select sum(tc_rpc06) into l_sum from tc_rpc_file 
             where tc_rpc01 = g_rpc02  --单号
               and tc_rpc03=g_rpc21 --单据日期
               and tc_rpc05 = l_tc_rpc[l_ac].tc_rpc05 --成品料号
               and tc_rpc14 = l_tc_rpc[l_ac].ta_rpc02_2  --需求数量 可以区分不同需求数量的成品料号
               and tc_rpc02 != l_tc_rpc[l_ac].tc_rpc02 --项序排除当前版本
               and tc_rpc09 = 'Y'
            if cl_null(l_sum) then
               let l_sum = 0
            end if
            if l_tc_rpc[l_ac].tc_rpc06+l_sum > l_tc_rpc[l_ac].ta_rpc02_2 then
            #大于需求数量
               call cl_err(l_tc_rpc[l_ac].tc_rpc06+l_sum,'!',1)
               next field tc_rpc06
            end if 
         end if

      on change tc_rpc09

 
         
      on idle g_idle_seconds
         call cl_on_idle()
         continue input

      on action about
         call cl_about()

      on action help
         call cl_show_help()
      
      on action require_void
         if l_tc_rpc[l_ac].tc_rpc09 = 'Y' then
            if int_flag then                 #900423
               call cl_err('',9001,0)
               let int_flag = 0
               let l_tc_rpc[l_ac].* = l_tc_rpc_t.*
               close i506_req_mod
               rollback work
               exit input
            end if
            if l_lock_sw = 'Y' then
               call cl_err(l_tc_rpc[l_ac].tc_rpc05,-263,1)
               let l_tc_rpc[l_ac].* = l_tc_rpc_t.*
            else
               update tc_rpc_file
                  set tc_rpc09 = 'N'
               where tc_rpc01 = g_rpc02 and tc_rpc02 = l_tc_rpc_t.tc_rpc02
                  and tc_rpc03 = g_rpc21 and tc_rpc04 = l_tc_rpc_t.tc_rpc04
               if sqlca.sqlcode then
                  call cl_err3("upd","tc_rpc_file",l_tc_rpc_t.tc_rpc05,'',sqlca.sqlcode,"","upd tc_rpc:",1)       #no.fun-660107  #no.fun-6b0045
                  let l_tc_rpc[l_ac].* = l_tc_rpc_t.*
                  display l_tc_rpc[l_ac].* to s_tc_rpc[l_sl].*
               else
                  #close i506_req_mod
                  #commit work
                  let l_tc_rpc[l_ac].tc_rpc09 = 'N'
                  #更新rpc_file
                  select sum(tc_rpc06) into l_sum from tc_rpc_file 
                   where tc_rpc01 = g_rpc02  --单号
                     and tc_rpc03= g_rpc21 --单据日期
                     and tc_rpc05 = l_tc_rpc[l_ac].tc_rpc05 --成品料号
                     and tc_rpc14 = l_tc_rpc[l_ac].ta_rpc02_2  --需求数量 可以区分不同需求数量的成品料号
                     and tc_rpc09 = 'Y' --有效状态才计算
                  if cl_null(l_sum) then
                     let l_sum = 0
                  end if

                  #更新rpc_file
                  update rpc_file 
                     set ta_rpc03 = l_sum,
                         rpc131 = rpc13/ta_rpc02*l_sum
                   where rpc02 = g_rpc02 and rpc21 = g_rpc21
                     and ta_rpc01 = l_tc_rpc[l_ac].tc_rpc05 and ta_rpc02 = l_tc_rpc[l_ac].ta_rpc02_2

                  if sqlca.sqlcode then
                     call cl_err3("upd","rpc_file",l_tc_rpc_t.tc_rpc05,'',sqlca.sqlcode,"","upd tc_rpc:",1)       #no.fun-660107  #no.fun-6b0045
                     let l_tc_rpc[l_ac].* = l_tc_rpc_t.*
                     display l_tc_rpc[l_ac].* to s_tc_rpc[l_sl].*
                     rollback work
                  else
                     message 'update o.k'
                     close i506_req_mod
                     commit work
                  end if
               end if
            end if
         end if
      on action require_unvoid
         if l_tc_rpc[l_ac].tc_rpc09 = 'N' then
            if int_flag then                 #900423
               call cl_err('',9001,0)
               let int_flag = 0
               let l_tc_rpc[l_ac].* = l_tc_rpc_t.*
               close i506_req_mod
               rollback work
               exit input
            end if
            if l_lock_sw = 'Y' then
               call cl_err(l_tc_rpc[l_ac].tc_rpc05,-263,1)
               let l_tc_rpc[l_ac].* = l_tc_rpc_t.*
            else
               update tc_rpc_file
                  set tc_rpc09 = 'Y'
               where tc_rpc01 = g_rpc02 and tc_rpc02 = l_tc_rpc_t.tc_rpc02
                  and tc_rpc03 = g_rpc21 and tc_rpc04 = l_tc_rpc_t.tc_rpc04
               if sqlca.sqlcode then
                  call cl_err3("upd","tc_rpc_file",l_tc_rpc_t.tc_rpc05,'',sqlca.sqlcode,"","upd tc_rpc:",1)       #no.fun-660107  #no.fun-6b0045
                  let l_tc_rpc[l_ac].* = l_tc_rpc_t.*
                  display l_tc_rpc[l_ac].* to s_tc_rpc[l_sl].*
               else
                  #close i506_req_mod
                  #commit work
                  let l_tc_rpc[l_ac].tc_rpc09 = 'Y'
                  #更新rpc_file
                  select sum(tc_rpc06) into l_sum from tc_rpc_file 
                   where tc_rpc01 = g_rpc02  --单号
                     and tc_rpc03= g_rpc21 --单据日期
                     and tc_rpc05 = l_tc_rpc[l_ac].tc_rpc05 --成品料号
                     and tc_rpc14 = l_tc_rpc[l_ac].ta_rpc02_2  --需求数量 可以区分不同需求数量的成品料号
                     and tc_rpc09 = 'Y' --有效状态才计算
                  if cl_null(l_sum) then
                     let l_sum = 0
                  end if

                  #更新rpc_file
                  update rpc_file 
                     set ta_rpc03 = l_sum,
                         rpc131 = rpc13/ta_rpc02*l_sum
                   where rpc02 = g_rpc02 and rpc21 = g_rpc21
                     and ta_rpc01 = l_tc_rpc[l_ac].tc_rpc05 and ta_rpc02 = l_tc_rpc[l_ac].ta_rpc02_2

                  if sqlca.sqlcode then
                     call cl_err3("upd","rpc_file",l_tc_rpc_t.tc_rpc05,'',sqlca.sqlcode,"","upd tc_rpc:",1)       #no.fun-660107  #no.fun-6b0045
                     let l_tc_rpc[l_ac].* = l_tc_rpc_t.*
                     display l_tc_rpc[l_ac].* to s_tc_rpc[l_sl].*
                     rollback work
                  else
                     message 'update o.k'
                     close i506_req_mod
                     commit work
                  end if
               end if
            end if
         end if
   end input
   close window i506_1_w
   call i506_b_fill(g_wc)
end function
#darcy:2023/03/06 add e---

