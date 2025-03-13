# Prog. Version..: '5.10.00-08.01.04(00006)'     #
#
# Pattern name...: axdi010.4gl
# Descriptions...: 分銷系統單據性質維護作業
# Date & Author..: 03/12/5 By Hawk
# Modify.........: No.MOD-4B0067 04/11/08 By Elva 將變數用Like方式定義,報表拉成一行
# Modify.........: No.FUN-520024 05/02/24 報表轉XML  By wujie
# Modify.........: No.MOD-540145 05/05/10 By vivien  刪除HELP FILE
# Modify.........: No.FUN-560150 05/06/21 By ice 編碼方法增加4.依年月日,
#                                                輸入的單別按整體定義的參數位數輸入
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制
# Modify.........: No:TQC-660133 06/07/03 By rainy s_xxxslip(),s_smu(),s_smv()中的參數 g_sys 改寫死系統別(ex:AAP)中的參數 g_sys 改寫死系統別(ex:AAP)
# Modify.........: No:TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No:TQC-670042 06/07/13 By Claire 使用者設限,部門設限無法使用
# Modify.........: No:FUN-680108 06/09/13 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No:FUN-6A0091 06/10/27 By douzh l_time轉g_time
# Modify.........: No:TQC-710076 07/03/01 By johnray 單檔多欄打印BUG修改

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_adz_1         DYNAMIC ARRAY OF RECORD         #程式變數(Program Variables)
     adzslip     LIKE adz_file.adzslip,
        adzdesc     LIKE adz_file.adzdesc,
        adzauno     LIKE adz_file.adzauno,
        adzconf     LIKE adz_file.adzconf,
        adzprnt     LIKE adz_file.adzprnt,
        adzdmy6     LIKE adz_file.adzdmy6,
        adztype     LIKE adz_file.adztype,
        adz11       LIKE adz_file.adz11,            #是否產生AR
        adzapr      LIKE adz_file.adzapr,
        adzsign     LIKE adz_file.adzsign
                    END RECORD,
    g_buf           LIKE type_file.chr1000,         #No.FUN-680108 VARCHAR(40) 
    g_adz_t         RECORD                          #程式變數 (舊值)
     adzslip     LIKE adz_file.adzslip,
        adzdesc     LIKE adz_file.adzdesc,
        adzauno     LIKE adz_file.adzauno,
        adzconf     LIKE adz_file.adzconf,
        adzprnt     LIKE adz_file.adzprnt,
        adzdmy6     LIKE adz_file.adzdmy6,
        adztype     LIKE adz_file.adztype,
        adz11       LIKE adz_file.adz11,            #是否產生AR
        adzapr      LIKE adz_file.adzapr,
        adzsign     LIKE adz_file.adzsign
                    END RECORD,
    g_wc2,g_sql     string,                         #No:FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,            #單身筆數  #No.FUN-680108 SMALLINT
    l_ac            LIKE type_file.num5             #目前處理的ARRAY CNT #No.FUN-680108 SMALLINT
DEFINE   p_row,p_col     LIKE type_file.num5        #No.FUN-680108 SMALLINT
DEFINE   g_forupd_sql    STRING                     #SELECT ... FOR UPDATE NOWAIT SQL
DEFINE   g_cnt           LIKE type_file.num10       #No.FUN-680108 INTEGER
DEFINE   g_i             LIKE type_file.num5        #count/index for any purpose #No.FUN-680108 SMALLINT
DEFINE   g_before_input_done LIKE type_file.num5    #No.FUN-680108 SMALLINT

MAIN
#     DEFINEl_time LIKE type_file.chr8            #No.FUN-6A0091

    OPTIONS                                #改變一些系統預設值
        FORM LINE       FIRST + 2,         #畫面開始的位置
        MESSAGE LINE    LAST,              #訊息顯示的位置
        PROMPT LINE     LAST,              #提示訊息的位置
        INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("AXD")) THEN
       EXIT PROGRAM
    END IF

      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
    LET p_row = 3 LET p_col = 3

    OPEN WINDOW i010_w AT p_row,p_col WITH FORM "axd/42f/axdi010"
        ATTRIBUTE(STYLE = g_win_style)

    CALL cl_ui_init()
    CALL g_x.clear()
    LET g_wc2 = '1=1' CALL i010_b_fill(g_wc2)
    CALL i010_menu()
    CLOSE WINDOW i010_w                   #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No:MOD-580088  HCN 20050818  #No.FUN-6A0091
         RETURNING g_time    #No.FUN-6A0091
END MAIN

FUNCTION i010_menu()
   WHILE TRUE
      CALL i010_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i010_q()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i010_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i010_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION

FUNCTION i010_q()
   CALL i010_b_askkey()
END FUNCTION

FUNCTION i010_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT #No.FUN-680108 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用 #No.FUN-680108 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否 #No.FUN-680108 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態 #No.FUN-680108 VARCHAR(1)
    l_allow_insert  LIKE type_file.chr1,   #可新增否 #No.FUN-680108 VARCHAR(1)
    l_allow_delete  LIKE type_file.chr1    #可刪除否 #No.FUN-680108 VARCHAR(1)
DEFINE l_i          LIKE type_file.num5    #No.FUN-680108 SMALLINT   #No.FUN-560150

    IF s_shut(0) THEN RETURN END IF
    CALL cl_opmsg('b')
    LET g_action_choice = ""

    LET l_allow_insert = cl_detail_input_auth('insert')
    LET l_allow_delete = cl_detail_input_auth('delete')

    LET g_forupd_sql = "SELECT adzslip,adzdesc,adzauno,adzconf,adzprnt,",
                       "       adzdmy6,adztype,adz11,adzapr,adzsign",
                       "  FROM adz_file WHERE adzslip = ? FOR UPDATE NOWAIT"
 
    DECLARE i010_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

    LET l_ac_t=0
    INPUT ARRAY g_adz_1 WITHOUT DEFAULTS FROM s_adz.*
              ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW = l_allow_insert,DELETE ROW=l_allow_delete,
                     APPEND ROW = l_allow_insert)
 
    BEFORE INPUT
        DISPLAY "BEFORE INPUT"
        IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(l_ac)
        END IF
#No.FUN-570109 --start
#       LET g_before_input_done = FALSE
#       CALL i010_set_entry(p_cmd)
#       CALL i010_set_no_entry(p_cmd)
#       LET g_before_input_done = TRUE
#No.FUN-570109 --end
        #NO.FUN-560150 --start--
        CALL cl_set_doctype_format("adzslip")
        #NO.FUN-560150 --end--

    BEFORE ROW
        DISPLAY "BEFORE ROW"
        LET p_cmd=' '
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_adz_t.* = g_adz_1[l_ac].*  #BACKUP
#No.FUN-570109 --start
            LET g_before_input_done = FALSE
            CALL i010_set_entry(p_cmd)
            CALL i010_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570109 --end
            OPEN i010_bcl USING g_adz_t.adzslip       #表示更改狀態
            IF STATUS THEN
               CALL cl_err("OPEN i010_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               IF SQLCA.sqlcode THEN
                      CALL cl_err(g_adz_t.adzslip,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
               END IF
               FETCH i010_bcl INTO g_adz_1[l_ac].*
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF

    BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
#No.FUN-570109 --start
            LET g_before_input_done = FALSE
            CALL i010_set_entry(p_cmd)
            CALL i010_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-570109 --end
         INITIALIZE g_adz_1[l_ac].* TO NULL      #900423
            LET g_adz_t.* = g_adz_1[l_ac].*         #新輸入資料
            LET g_adz_1[l_ac].adzapr = 'N'
            LET g_adz_1[l_ac].adzsign= ''
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD adzslip
 
    AFTER INSERT
        DISPLAY "AFTER INSERT"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO adz_file(adzslip,adzdesc,adzauno,
                                adzconf,adzprnt,adzdmy6,
                                adztype,adz11,adzapr,adzsign)
                         VALUES(g_adz_1[l_ac].adzslip,g_adz_1[l_ac].adzdesc,
                                g_adz_1[l_ac].adzauno,g_adz_1[l_ac].adzconf,
                                g_adz_1[l_ac].adzprnt,g_adz_1[l_ac].adzdmy6,
                                g_adz_1[l_ac].adztype,g_adz_1[l_ac].adz11,
                                g_adz_1[l_ac].adzapr,g_adz_1[l_ac].adzsign)
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_adz_1[l_ac].adzslip,SQLCA.sqlcode,0)
              CANCEL INSERT
           ELSE
              IF g_adz_1[l_ac].adztype MATCHES '1[3-8]' THEN
                 CALL i010_ins_smy()
              END IF
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
           END IF

         AFTER FIELD adzslip                       #check 編號是否重複
           IF NOT cl_null(g_adz_1[l_ac].adzslip) THEN
              IF g_adz_1[l_ac].adzslip != g_adz_t.adzslip
                 OR cl_null(g_adz_t.adzslip) THEN    #No.FUN-560150
                   SELECT count(*) INTO l_n FROM adz_file
                       WHERE adzslip = g_adz_1[l_ac].adzslip
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_adz_1[l_ac].adzslip = g_adz_t.adzslip
                       NEXT FIELD adzslip
                   END IF
                   #NO.FUN-560150 --start--
                   FOR l_i = 1 TO g_doc_len
                      IF cl_null(g_adz_1[l_ac].adzslip[l_i,l_i]) THEN
                        CALL cl_err('','sub-146',0)
                        LET g_adz_1[l_ac].adzslip = g_adz_t.adzslip
                        NEXT FIELD adzslip
                      END IF
                   END FOR
                   #NO.FUN-560150 --end--
              END IF
              IF g_adz_1[l_ac].adzslip != g_adz_t.adzslip THEN  #NO:6842
                 UPDATE smv_file  SET smv01=g_adz_1[l_ac].adzslip
                  WHERE smv01=g_adz_t.adzslip   #NO:單別
                    #AND smv03=g_sys             #NO:系統別 #TQC-670008 remark
                    AND upper(smv03)='AXD'       #NO:系統別 #TQC-670008
                 IF SQLCA.sqlcode THEN
                     CALL cl_err('UPDATE smv_file',SQLCA.sqlcode,0)
                     LET l_ac_t = l_ac
                     EXIT INPUT
                 END IF
                 UPDATE smu_file  SET smu01=g_adz_1[l_ac].adzslip
                  WHERE smu01=g_adz_t.adzslip   #NO:單別
                    #AND smu03=g_sys             #NO:系統別  #TQC-670008 remark
                    AND upper(smu03)='AXD'       #NO:系統別  #TQC-670008
                 IF SQLCA.sqlcode THEN
                     CALL cl_err('UPDATE smu_file',SQLCA.sqlcode,0)
                     LET l_ac_t = l_ac
                     EXIT INPUT
                 END IF
              END IF
           END IF

        BEFORE FIELD adzapr
           CALL i010_set_entry(p_cmd)

        AFTER FIELD adzapr
           IF g_adz_1[l_ac].adzapr IS NOT NULL  THEN
              IF g_adz_1[l_ac].adzapr ='N'  THEN
                 LET g_adz_1[l_ac].adzsign = ''
              END IF
              CALL i010_set_no_entry(p_cmd)
           END IF

        AFTER FIELD adzsign
           SELECT COUNT(*) INTO g_cnt FROM aze_file
            WHERE aze01 = g_adz_1[l_ac].adzsign
           IF g_cnt=0 THEN
              CALL cl_err('sel aze','aoo-013',0)
              NEXT FIELD adzsign
           END IF

        BEFORE DELETE                            #是否取消單身
            IF g_adz_t.adzslip IS NOT NULL THEN
                IF NOT cl_delete() THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
{ckp#1}         DELETE FROM adz_file WHERE adzslip = g_adz_t.adzslip
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_adz_t.adzslip,SQLCA.sqlcode,0)
                    LET l_ac_t = l_ac
                    EXIT INPUT
                END IF
                DELETE FROM smv_file
                 #WHERE smv01 = g_adz_t.adzslip AND smv03=g_sys       #TQC-670008 remark
                 WHERE smv01 = g_adz_t.adzslip AND upper(smv03)='AXD' #TQC-670008 
                IF SQLCA.sqlcode THEN
                    CALL cl_err('smv_file',SQLCA.sqlcode,0)
                    EXIT INPUT
                END IF
                DELETE FROM smu_file
                 #WHERE smu01 = g_adz_t.adzslip AND smu03=g_sys       #TQC-670008 remark
                 WHERE smu01 = g_adz_t.adzslip AND upper(smu03)='AXD' #TQC-670008
                IF SQLCA.sqlcode THEN
                    CALL cl_err('smu_file',SQLCA.sqlcode,0)
                    EXIT INPUT
                END IF
                IF g_adz_t.adztype MATCHES '1[3-8]' THEN
                   DELETE FROM smy_file WHERE smyslip = g_adz_t.adzslip
                   IF SQLCA.sqlcode OR STATUS=100 THEN
 		      CALL cl_err('del smy:','axm-279',1)
 		   END IF
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2  #ATTRIBUTE(RED)
                MESSAGE "Delete Ok"
            END IF
            COMMIT WORK

    ON ROW CHANGE
        DISPLAY "ON ROW CHANGE"
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_adz_1[l_ac].* = g_adz_t.*
              CLOSE i010_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
              CALL cl_err(g_adz_1[l_ac].adzslip,-263,0)
              LET g_adz_1[l_ac].* = g_adz_t.*
           ELSE
              UPDATE adz_file
                 SET adzslip=g_adz_1[l_ac].adzslip,adzdesc=g_adz_1[l_ac].adzdesc,
                     adzauno=g_adz_1[l_ac].adzauno,adzconf=g_adz_1[l_ac].adzconf,
                     adzprnt=g_adz_1[l_ac].adzprnt,adzdmy6=g_adz_1[l_ac].adzdmy6,
                     adztype=g_adz_1[l_ac].adztype,adz11=g_adz_1[l_ac].adz11,
                     adzapr=g_adz_1[l_ac].adzapr,adzsign=g_adz_1[l_ac].adzsign
               WHERE adzslip = g_adz_t.adzslip
              IF SQLCA.sqlcode THEN
                 CALL cl_err('upd adz:','axd-277',1)
                 LET g_adz_1[l_ac].* = g_adz_t.*
                 ROLLBACK WORK
              ELSE
                 IF g_adz_1[l_ac].adztype MATCHES '1[3-8]' THEN
                    UPDATE smy_file
                      SET  smyslip=g_adz_1[l_ac].adzslip,
                           smydesc=g_adz_1[l_ac].adzdesc,
                           smyauno=g_adz_1[l_ac].adzauno,
                           smydmy4=g_adz_1[l_ac].adzconf,
                           smyprint=g_adz_1[l_ac].adzprnt,
                           smydmy5=g_adz_1[l_ac].adzdmy6
                     WHERE smyslip = g_adz_t.adzslip
                    IF STATUS = 100 THEN
                       CALL cl_err('upd smy:','axd-277',1)
                       ROLLBACK WORK
                    ELSE
                       MESSAGE 'UPDATE O.K'
                       COMMIT WORK
                    END IF
                 END IF
              END IF
           END IF

    AFTER ROW
        DISPLAY "AFTER ROW"
           LET l_ac = ARR_CURR()         # 新增
           LET l_ac_t = l_ac                # 新增
 
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_adz_1[l_ac].* = g_adz_t.*
              END IF
              CLOSE i010_bcl            # 新增
              ROLLBACK WORK         # 新增
              EXIT INPUT
           END IF
           CLOSE i010_bcl
           COMMIT WORK

        ON ACTION CONTROLN
            CALL i010_b_askkey()
            EXIT INPUT

       #TQC-670042-begin
        ON ACTION user_auth
       #ON ACTION CONTROLY   
       #    CASE
       #         WHEN INFIELD(adzslip)
           LET g_action_choice='user_auth' #TQC-670042 add
       #TQC-670042-end
                     IF NOT cl_null(g_adz_1[l_ac].adzslip) THEN
                   #    LET g_action_choice='controly'            #TQC-670042 mark
                        IF cl_chk_act_auth() THEN
                          #CALL s_smu(g_adz_1[l_ac].adzslip,g_sys)  #TQC-660133 remark
                           CALL s_smu(g_adz_1[l_ac].adzslip,"AXD")  #TQC-660133
                        END IF
                     ELSE
                         CALL cl_err('','anm-217',0)
                     END IF
       #   END CASE    #TQC-670042 add
       #TQC-670042-begin
       #ON ACTION CONTROLU
       #   CASE
       #        WHEN INFIELD(adzslip)
       ON ACTION dept_auth #NO:6842
          LET g_action_choice='dept_auth' #TQC-670042 add
       #TQC-670042-end
            IF NOT cl_null(g_adz_1[l_ac].adzslip) THEN
        #      LET g_action_choice='controly' #TQC-670042 mark
                        IF cl_chk_act_auth() THEN
                          #CALL s_smv(g_adz_1[l_ac].adzslip,g_sys) #TQC-660133 remark
                           CALL s_smv(g_adz_1[l_ac].adzslip,"AXD") #TQC-660133
                        END IF
                     ELSE
                        CALL cl_err('','anm-217',0)
                     END IF
        #  END CASE     #TQC-670042 mark
        ON ACTION CONTROLO
            IF INFIELD(adzslip) AND l_ac > 1 THEN
                LET g_adz_1[l_ac].* = g_adz_1[l_ac-1].*
                NEXT FIELD adzslip
            END IF

        ON ACTION CONTROLZ
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
            CALL cl_cmdask()

        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(adzsign)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aze"
               LET g_qryparam.default1 = g_adz_1[l_ac].adzsign
               CALL cl_create_qry() RETURNING g_adz_1[l_ac].adzsign
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

    CLOSE i010_bcl
    COMMIT WORK
END FUNCTION

FUNCTION i010_ins_smy()
  DEFINE l_smy   RECORD LIKE smy_file.*
   INITIALIZE l_smy.* TO NULL
      LET l_smy.smyslip = g_adz_1[l_ac].adzslip
      LET l_smy.smydesc = g_adz_1[l_ac].adzdesc
      LET l_smy.smyauno = g_adz_1[l_ac].adzauno
      LET l_smy.smydmy5 = g_adz_1[l_ac].adzdmy6       #編號方式
      LET l_smy.smysys  = 'aim'                     #系統別
      LET l_smy.smykind = '9'                       #單據性質(mfg出貨單)
      IF g_adz_1[l_ac].adztype MATCHES '1[345]' THEN
         LET l_smy.smydmy2 = '4'
      END IF
      IF g_adz_1[l_ac].adztype MATCHES '1[678]' THEN
         LET l_smy.smydmy2 = '5'
      END IF                                        #成會分類(銷)
      LET l_smy.smydmy1 = 'Y'                       #成本入項
      LET l_smy.smyapr  = g_adz_1[l_ac].adzapr        #簽核處理
      LET l_smy.smysign = g_adz_1[l_ac].adzsign
      LET l_smy.smyatsg = 'N'                       #自動簽核
      LET l_smy.smyprint= g_adz_1[l_ac].adzprnt       #立即列印
      LET l_smy.smydmy4 = g_adz_1[l_ac].adzconf       #立即確認
      LET l_smy.smyware = '0'                       #倉庫設限方式
      LET l_smy.smyuser = g_user
      LET l_smy.smygrup = g_grup
      LET l_smy.smydate = g_today
      LET l_smy.smyacti = 'Y'

     If NOT cl_null(l_smy.smydmy2) THEN
        INSERT INTO smy_file VALUES(l_smy.*)
        IF SQLCA.sqlcode OR STATUS=100 THEN
            CALL cl_err('ins smy:','axd-278',1)
        END IF
     END IF
END FUNCTION

FUNCTION i010_b_askkey()
    CLEAR FORM
    CALL g_adz_1.clear()
 CONSTRUCT g_wc2 ON adzslip,adzdesc,adzauno,adzconf,adzprnt,
                       adzdmy6,adztype,adz11,adzapr,adzsign
            FROM s_adz[1].adzslip,s_adz[1].adzdesc,s_adz[1].adzauno,
                 s_adz[1].adzconf,s_adz[1].adzprnt,
                 s_adz[1].adzdmy6,s_adz[1].adztype,s_adz[1].adz11,
                 s_adz[1].adzapr,s_adz[1].adzsign

        ON ACTION CONTROLP
           CASE
               WHEN INFIELD(adzsign)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aze"
               LET g_qryparam.state = "c"
               LET g_qryparam.default1 = g_adz_1[l_ac].adzsign
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO s_adz[1].adzsign
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
 
    END CONSTRUCT
#No.TQC-710076 -- begin --
#    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_wc2 = NULL
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL i010_b_fill(g_wc2)
END FUNCTION

FUNCTION i010_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000     #No.FUN-680108 VARCHAR(200)

    LET g_sql =
        "SELECT adzslip,adzdesc,adzauno,adzconf,adzprnt,",
        " adzdmy6,adztype,adz11,adzapr,adzsign,''",
        " FROM adz_file",
        " WHERE ", p_wc2 CLIPPED,                     #單身
        " ORDER BY adztype,adzslip"
    PREPARE i010_pb FROM g_sql
    DECLARE adz_curs CURSOR FOR i010_pb

    CALL g_adz_1.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH adz_curs INTO g_adz_1[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
            CALL cl_err('',9035,0)
            EXIT FOREACH
        END IF
    END FOREACH
    CALL g_adz_1.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION

FUNCTION i010_bp(p_ud)
DEFINE
   p_ud            LIKE type_file.chr1    #No.FUN-680108 VARCHAR(1)

   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_adz_1 TO s_adz.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No:FUN-550037 hmf

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
          CALL cl_show_fld_cont()                   #No:FUN-550037 hmf
 
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

      ON ACTION close
         LET g_action_choice="exit"
         EXIT DISPLAY
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      # No:FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No:FUN-530067 ---end---

 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

FUNCTION i010_out()
    DEFINE
        l_adz           RECORD LIKE adz_file.*,
        l_i             LIKE type_file.num5,     #No.FUN-680108 SMALLINT 
        l_name          LIKE type_file.chr20,    #No.FUN-680108 VARCHAR(20)                 # External(Disk) file name
        l_za05          LIKE za_file.za05        # MOD-4B0067
#No.TQC-710076 -- begin --
#    IF g_wc2 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF cl_null(g_wc2) THEN
      CALL cl_err('','9057',0)
      RETURN
   END IF
#No.TQC-710076 -- end --
    CALL cl_wait()
    CALL cl_outnam('axdi010') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM adz_file ",          # 組合出 SQL 指令
              " WHERE ",g_wc2 CLIPPED
    PREPARE i010_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE i010_co                         # CURSOR
        CURSOR FOR i010_p1

    START REPORT i010_rep TO l_name

    FOREACH i010_co INTO l_adz.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
        OUTPUT TO REPORT i010_rep(l_adz.*)
    END FOREACH

    FINISH REPORT i010_rep

    CLOSE i010_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION

REPORT i010_rep(sr)
    DEFINE
        l_trailer_sw    LIKE type_file.chr1,   #No.FUN-680108 VARCHAR(1) 
        sr RECORD LIKE adz_file.*

   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line

    ORDER BY sr.adztype,sr.adzslip

    FORMAT
        PAGE HEADER
            PRINT COLUMN((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
            LET g_pageno = g_pageno + 1
            LET pageno_total = PAGENO USING '<<<',"/pageno"
            PRINT g_head CLIPPED,pageno_total
            PRINT COLUMN((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
            PRINT ' '
            PRINT g_dash[1,g_len]
 #MOD-4B0067(BEGIN)--BY DAY
            PRINT g_x[31],g_x[32],g_x[33],g_x[34],
                  g_x[35],g_x[36],g_x[37],g_x[38]
 
            PRINT g_dash1
            LET l_trailer_sw = 'y'

        ON EVERY ROW
            PRINT COLUMN g_c[31],sr.adzslip,
                  COLUMN g_c[32],sr.adzdesc,
                  COLUMN g_c[33],sr.adzauno,
                  COLUMN g_c[34],sr.adzdmy6,
                  COLUMN g_c[35],sr.adztype,
                  COLUMN g_c[36],sr.adz11,
                  COLUMN g_c[37],sr.adzapr,
                  COLUMN g_c[38],sr.adzsign
 #MOD-4B0067(END)--BY DAY
        ON LAST ROW
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'

        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT

#genero
FUNCTION i010_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680108 VARCHAR(1)
 
   IF INFIELD(adzapr) OR (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("adzsign",TRUE)
   END IF
 
#No.FUN-570109 --start
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("adzslip",TRUE)
   END IF
#No.FUN-570109 --end
END FUNCTION

FUNCTION i010_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680108 VARCHAR(1)
 
   IF INFIELD(adzapr) OR (NOT g_before_input_done) THEN
        IF g_adz_1[l_ac].adzapr = 'N' THEN
            CALL cl_set_comp_entry("adzsign",FALSE)
        END IF
   END IF

#No.FUN-570109 --start
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("adzslip",FALSE)
   END IF
#No.FUN-570109 --end
END FUNCTION
#Patch....NO:TQC-610037 <001,002,003,004,005,006,008,009,010,011,012,013,014,015,016,017,018,019> #
