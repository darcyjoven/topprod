# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apmi258.4gl
# Descriptions...: 供應商/料件維護作業
# Date & Author..: 01/04/30 By jacky
# Modify.........: No.MOD-490280 04/09/16 Melody 新增第二張以上單據時，由單頭至單身新增時會SHOW 100找不到資料的問題
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4B0051 04/11/24 By Mandy 匯率加開窗功能
# Modify.........: No.FUN-4C0074 04/12/14 By pengu 匯率幣別欄位修改，與aoos010的azi17做判斷，
                                                   #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.FUN-530016 05/03/15 By kim (p_per 中,"匯率"欄位 增加 rate(對應幣別))
# Modify.........: No.FUN-550037 05/05/13 By saki 欄位comment顯示
# Modify.........: No.FUN-560193 05/06/27 By kim 單身增秀'計價單位'
# Modify.........: NO.MOD-5B0316 05/12/05 BY Nicola INSERT pmh_file之前，給pmh09,15,16預設值
# Modify.........: No.FUN-610018 06/01/05 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.FUN-640012 06/04/07 By kim GP3.0 匯率參數功能改善
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-660099 06/08/08 By Nicola 價格管理修改-新增欄位作業編號，用傳參數的方式決定採購委外
# Modify.........: No.FUN-680136 06/09/13 By Jackho 欄位類型修改
# Modify.........: No.FUN-690022 06/09/21 By jamie 判斷imaacti
# Modify.........: No.FUN-690024 06/09/21 By jamie 判斷pmcacti
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.MOD-690034 06/11/15 By Claire 狀態頁不可查詢
# Modify.........: No.FUN-6B0079 06/12/04 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6C0055 07/01/08 By Joe 新增與GPM整合的顯示及查詢的Toolbar
# Modify.........: No.TQC-710042 07/01/11 By Joe 解決未經設定整合之工廠,會有Action顯示異常情況出現
# Modify.........: No.TQC-730102 07/04/09 By Smapmin 增加資料所有者等欄位
# Modify.........: No.TQC-740086 07/04/13 By wujie  委外時，b_fill()的sql條件錯
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-760048 07/06/11 By claire 查詢多個廠商卻只有一筆被查出
# MOdify.........: No.CHI-790003 07/09/02 By Nicole 修正Insert Into pmh_file Error
# Modify.........: No.TQC-7B0089 07/11/15 By lumxa  apmi254&apmi264&apmi258&apmi268.dbo.update pmh_file r l件 ]有考 ]新增加的key值字段pmh21,pmh22,會導致問題
# Modify.........: No.TQC-810025 08/01/08 By lumxa 在程序apmi254 apmi255 apmi258中增加了新增的key值的 在修改單身時 key值賦值錯誤
# Modify.........: No.FUN-810017 08/01/09 By jan 增加服飾作業
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-830114 08/03/31 By jan 若料件編號字段輸入的是多屬性的分段定價資料且不存在于ima_file中                     
#                                                那麼單身輸入料號后需帶出的默認資料
# Modify.........: No.FUN-880121 08/09/01 By Smamin 增加QVL及AVL的串連功能
# Modify.........: No.FUN-870124 08/09/23 By jan 服飾作業修改
# Modify.........: No.MOD-910087 09/01/08 By Smapmin 單身有效碼無法修改
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.TQC-920075 09/02/23 By xiaofeizhu _curs段之組sql及_b段之lock cursor及_i段的lock cursor及b_fill段的sql不要加有效無效判斷
# Modify.........: No.FUN-930108 09/03/30 By zhaijie若aoos010勾選使用料件承認申請作業,則此作業不直接產生bmj_file料件承認資料
# Modify.........: No.FUN-940083 09/05/05 By zhaijie新增字段pmh24-VMI采購
# Modify.........: No.FUN-980006 09/08/13 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-930061 09/08/27 By chenmoyan 增加作業名稱的欄位
# Modify.........: No.TQC-9A0145 09/10/28 By Carrier SQL STANDARDIZE
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No.FUN-9B0098 10/02/24 By tommas delete cl_doc
# Modify.........: No.FUN-A90050 10/09/20 By yinhy 單身增加一個欄位，電子採購料件
# Modify.........: No.FUN-AA0059 10/10/25 By huangtao 修改料號的管控
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No:FUN-9A0056 11/04/01 By abby MES整合追版
# Modify.........: No:TQC-B50017 11/05/18 By lilingyu MISC料號控管
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:TQC-B60031 11/06/08 By yinhy MISC料號控管
# Modify.........: No.FUN-B80093 11/10/03 By pauline 控管VIM相關欄位											
# Modify.........: No:MOD-BC0309 11/12/30 By suncx 管控同一料號的pmh11總和不能超過100
# Modify.........: No:TQC-BB0239 11/11/29 By Carrier 核准日修改,汇率重取
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:MOD-CB0132 12/11/23 By jt_chen 單身輸入時之核准日期是否可預設g_today,且該欄位是否應該不可空白
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D60003 13/06/01 By SunLM 防止提示报错导致资料不能从excel批量复制进去单身
# Modify.........: No:MOD-DA0088 13/11/12 By SunLM default pmh24若為空,則值為"N"

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pmh02         LIKE pmh_file.pmh02,   #類別代號 (假單頭)
       g_pmh02_t       LIKE pmh_file.pmh02,   #類別代號 (舊值)
       g_pmh           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                          pmh01       LIKE pmh_file.pmh01,
                          ima02       LIKE ima_file.ima02,
                          ima021      LIKE ima_file.ima021,
                          pmh21       LIKE pmh_file.pmh21,  #No.FUN-670099
                          ecd02       LIKE ecd_file.ecd02,  #No.FUN-930061
                          pmh23       LIKE pmh_file.pmh23,  #No.FUN-810017
                          pmh05       LIKE pmh_file.pmh05,
                          pmh08       LIKE pmh_file.pmh08,
                          pmh24       LIKE pmh_file.pmh24,  #FUN-940083 add
                          pmh25       LIKE pmh_file.pmh25,  #FUN-A90050 add
                          pmh06       LIKE pmh_file.pmh06,
                          pmh13       LIKE pmh_file.pmh13,
                          pmh14       LIKE pmh_file.pmh14,
                          pmh17       LIKE pmh_file.pmh17,
                          pmh18       LIKE pmh_file.pmh18,
                          pmh12       LIKE pmh_file.pmh12,
                          pmh19       LIKE pmh_file.pmh19,
                          pmh11       LIKE pmh_file.pmh11,
                          pmh04       LIKE pmh_file.pmh04,
                          pmh07       LIKE pmh_file.pmh07,
                          mse02       LIKE mse_file.mse02,
                          ima25       LIKE ima_file.ima25,
                          ima44       LIKE ima_file.ima44,
                          ima908      LIKE ima_file.ima908,  #FUN-560193
                          pmhuser   LIKE pmh_file.pmhuser,
                          pmhgrup   LIKE pmh_file.pmhgrup,
                          pmhmodu   LIKE pmh_file.pmhmodu,
                          pmhdate   LIKE pmh_file.pmhdate,
                          pmhacti   LIKE pmh_file.pmhacti
                       END RECORD,
       g_pmh_t         RECORD                 #程式變數 (舊值)
                          pmh01       LIKE pmh_file.pmh01,
                          ima02       LIKE ima_file.ima02,
                          ima021      LIKE ima_file.ima021,
                          pmh21       LIKE pmh_file.pmh21,  #No.FUN-670099
                          ecd02       LIKE ecd_file.ecd02,  #No.FUN-930061
                          pmh23       LIKE pmh_file.pmh23,  #No.FUN-810017
                          pmh05       LIKE pmh_file.pmh05,
                          pmh08       LIKE pmh_file.pmh08,
                          pmh24       LIKE pmh_file.pmh24,  #FUN-940083 add
                          pmh25       LIKE pmh_file.pmh25,  #FUN-A90050 add
                          pmh06       LIKE pmh_file.pmh06,
                          pmh13       LIKE pmh_file.pmh13,
                          pmh14       LIKE pmh_file.pmh14,
                          pmh17       LIKE pmh_file.pmh17,
                          pmh18       LIKE pmh_file.pmh18,
                          pmh12       LIKE pmh_file.pmh12,
                          pmh19       LIKE pmh_file.pmh19,
                          pmh11       LIKE pmh_file.pmh11,
                          pmh04       LIKE pmh_file.pmh04,
                          pmh07       LIKE pmh_file.pmh07,
                          mse02       LIKE mse_file.mse02,
                          ima25       LIKE ima_file.ima25,
                          ima44       LIKE ima_file.ima44,
                          ima908      LIKE ima_file.ima908,  #FUN-560193
                          pmhuser   LIKE pmh_file.pmhuser,
                          pmhgrup   LIKE pmh_file.pmhgrup,
                          pmhmodu   LIKE pmh_file.pmhmodu,
                          pmhdate   LIKE pmh_file.pmhdate,
                          pmhacti   LIKE pmh_file.pmhacti
                       END RECORD,
       tm              RECORD                 #程式變數 (舊值)
                          pmc03       LIKE pmc_file.pmc03
                       END RECORD,
       g_argv1         LIKE pmh_file.pmh01,
       g_wc,g_sql      STRING,      #No.FUN-580092 HCN
       g_ss            LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(01) #決定後續步驟
       g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-680136 SMALLINT
       l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
DEFINE g_gec07         LIKE gec_file.gec07    #FUN-610018
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_msg           LIKE ze_file.ze03      #No.FUN-680136 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_no_ask       LIKE type_file.num5    #No.FUN-680136 SMALLINT
DEFINE g_argv2         LIKE pmh_file.pmh22    #No.FUN-670099
DEFINE g_pmh22         LIKE pmh_file.pmh22    #No.FUN-670099
DEFINE g_buf           string                 #No.TQC-9A0145
DEFINE i               SMALLINT               #count/index for any purpose  #FUN-9A0056 add
DEFINE l_par           STRING                 #MES合併字串                  #FUN-9A0056 add
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1  = ARG_VAL(1)              #料件編號
   LET g_argv2=ARG_VAL(2)
   IF g_argv2 = "1" THEN
      LET g_prog="apmi258"
      LET g_pmh22 = "1"
   ELSE
      LET g_prog="apmi268"
      LET g_pmh22 = "2"
   END IF 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_pmh02 = NULL                     #清除鍵值
   LET g_pmh02_t = NULL
   LET g_pmh02 = g_argv1
 
   OPEN WINDOW i258_w WITH FORM "apm/42f/apmi258"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_set_locale_frm_name("apmi258")   #No.FUN-670099
   CALL cl_ui_init()
 
   IF g_aza.aza71 MATCHES '[Yy]' THEN 
      CALL aws_gpmcli_toolbar()
      CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
   ELSE
      CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)
   END IF
 
   IF (g_sma.sma116 MATCHES '[02]') THEN    #No.FUN-610076
      CALL cl_set_comp_visible("ima908",FALSE)
   END IF
 
   IF g_pmh22 = "1" THEN
      CALL cl_set_comp_visible("pmh21,ecd02",FALSE)  #No.FUN-930061 add ecd02
   END IF
   
   IF g_pmh22 = "1" THEN
      CALL cl_set_comp_visible("pmh23",FALSE)
   END IF
# FUN-B80093 add START											
  IF g_sma.sma93="Y" THEN											
     CALL cl_set_comp_visible("pmh24", TRUE)											
  ELSE											
     CALL cl_set_comp_visible("pmh24", FALSE)											
  END IF											
# FUN-B80093 add END											

   #No.FUN-A90050 --start--
   IF (g_aza.aza95 = "N" OR g_pmh22 = "2" ) THEN    
      CALL cl_set_comp_visible("pmh25",FALSE)
   END IF
   #No.FUN-A90050 --end--
   IF NOT cl_null(g_argv1) THEN
      CALL  i258_q()
   END IF
 
   CALL i258_menu()
   CLOSE WINDOW i258_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i258_curs()
 
   CLEAR FORM                             #清除畫面
   CALL g_pmh.clear()
 
   IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
      INITIALIZE g_pmh02 TO NULL                   #No.FUN-750051
      CONSTRUCT g_wc ON pmh02,pmh01,pmh21,pmh05,pmh08,pmh24,pmh25,pmh06,pmh13,  #No.FUN-670099 #FUN-940083 add pmh24  #FUN-A90050 add pmh25
                        pmh14,pmh17,pmh18,pmh12,pmh19,pmh23,  #No.FUN-610018 #No.FUN-810017 add pmh23
                        pmh11,pmh04,pmh07,pmhuser,pmhgrup,pmhmodu,pmhdate,pmhacti           #MOD-690034 add 狀態頁   #TQC-730102
                   FROM pmh02,s_pmh[1].pmh01,s_pmh[1].pmh21,s_pmh[1].pmh05,s_pmh[1].pmh08,s_pmh[1].pmh24,s_pmh[1].pmh25,s_pmh[1].pmh06,  #No.FUN-670099 #FUN-940083 add pmh24 #FUN-A90050 add pmh25
                        s_pmh[1].pmh13,s_pmh[1].pmh14,s_pmh[1].pmh17,s_pmh[1].pmh18,        #No.FUN-610018
                        s_pmh[1].pmh12,s_pmh[1].pmh19,s_pmh[1].pmh23,                       #No.FUN-810017 add pmh23
                        s_pmh[1].pmh11,s_pmh[1].pmh04,s_pmh[1].pmh07  #No.FUN-610018
                       ,s_pmh[1].pmhuser,s_pmh[1].pmhgrup,s_pmh[1].pmhmodu,s_pmh[1].pmhdate,s_pmh[1].pmhacti #TQC-730102
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmh02)     #廠商編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state ="c"
                  LET g_qryparam.form ="q_pmc1"
                  LET g_qryparam.default1 = g_pmh02
                  CALL cl_create_qry() RETURNING g_qryparam.multiret 
                  DISPLAY g_qryparam.multiret TO pmh02
                  NEXT FIELD pmh02
              WHEN INFIELD(pmh21)     #作業編號
                 CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmh21
                 NEXT FIELD pmh21
               WHEN INFIELD(pmh23)     #單元編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state ="c"
                  LET g_qryparam.form ="q_sga"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmh23
                  NEXT FIELD pmh23
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmhuser', 'pmhgrup') #FUN-980030
 
      IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc = " pmh02 = '",g_argv1,"'"
   END IF
 
   LET g_wc = g_wc CLIPPED," AND pmh22 ='",g_pmh22,"'"  #No.FUN-670099
 
   LET g_sql= "SELECT UNIQUE pmh02 FROM pmh_file ",
              " WHERE ", g_wc CLIPPED,
              " ORDER BY 1"
   PREPARE i258_prepare FROM g_sql      #預備一下
   DECLARE i258_b_curs                  #宣告成可捲動的
       SCROLL CURSOR WITH HOLD FOR i258_prepare
 
   LET g_sql="SELECT COUNT(DISTINCT pmh02) FROM pmh_file WHERE ",g_wc CLIPPED
   PREPARE i258_precount FROM g_sql
   DECLARE i258_count CURSOR FOR i258_precount
 
END FUNCTION
 
FUNCTION i258_menu()
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
 
   WHILE TRUE
      CALL i258_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i258_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i258_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i258_r()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i258_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i258_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmh),'','')
            END IF
 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_pmh02 IS NOT NULL THEN
                 LET g_doc.column1 = "pmh02"
                 LET g_doc.value1 = g_pmh02
                 CALL cl_doc()
               END IF
         END IF
 
         #@WHEN GPM規範顯示   
         WHEN "gpm_show"
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN LET l_partnum = g_pmh[l_ac].pmh01 END IF
              LET l_supplierid = g_pmh02
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
 
         #@WHEN GPM規範查詢
         WHEN "gpm_query"
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN LET l_partnum = g_pmh[l_ac].pmh01 END IF
              LET l_supplierid = g_pmh02
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
 
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i258_a()
 
   MESSAGE ""
   CLEAR FORM
   CALL g_pmh.clear()
   INITIALIZE g_pmh02 LIKE pmh_file.pmh02
   LET g_pmh02_t = NULL
   #預設值及將數值類變數清成零
   CALL cl_opmsg('a')
 
   WHILE TRUE
      CALL i258_i("a")                #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         LET g_pmh02=NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF g_ss='N' THEN
         CALL g_pmh.clear()
      ELSE
         CALL i258_b_fill('1=1')         #單身
      END IF
 
      LET g_rec_b=0   #No.MOD-490280
      CALL i258_b()                   #輸入單身
 
      LET g_pmh02_t = g_pmh02            #保留舊值
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i258_i(p_cmd)
DEFINE p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改  #No.FUN-680136 VARCHAR(1)
 
   LET g_ss='Y'
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INPUT g_pmh02 WITHOUT DEFAULTS FROM pmh02
 
      AFTER FIELD pmh02                        #check 序號是否重複
         IF NOT cl_null(g_pmh02) THEN
            CALL i258_pmh02('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pmh02,g_errno,0)
               NEXT FIELD pmh02
            END IF
            CALL i258_pmh17('d')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pmh02,g_errno,0)
               NEXT FIELD pmh02
            END IF
         END IF
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pmh02)     #廠商編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pmc1"
               LET g_qryparam.default1 = g_pmh02
               CALL cl_create_qry() RETURNING g_pmh02
               DISPLAY g_pmh02 TO pmh02
               NEXT FIELD pmh02
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION supplier_data
         CASE
            WHEN INFIELD(pmh02)     #廠商編號
               CALL cl_cmdrun("apmi600 ")
            OTHERWISE EXIT CASE
         END CASE
 
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
 
FUNCTION i258_pmh01(p_cmd,l_pmh01)
DEFINE p_cmd           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
       l_desc          LIKE gfe_file.gfe01,    #No.FUN-680136 VARCHAR(04)
       l_pmh01         LIKE pmh_file.pmh01,
       l_ima02         LIKE ima_file.ima02,
       l_ima021        LIKE ima_file.ima021,
       l_ima25         LIKE ima_file.ima25,
       l_ima44         LIKE ima_file.ima44,
       l_ima54         LIKE ima_file.ima54,
       l_ima103        LIKE ima_file.ima103,
       l_ima104        LIKE ima_file.ima104,
       l_ima53         LIKE ima_file.ima53,
       l_ima91         LIKE ima_file.ima91,
       l_ima531        LIKE ima_file.ima531,
       l_ima532        LIKE ima_file.ima532,
       l_ima45         LIKE ima_file.ima45,
       l_imaacti       LIKE ima_file.imaacti          #資料有效碼
 
   LET g_errno = ' '
   SELECT ima02,ima021,ima25,ima44,imaacti,ima908 #FUN-560193 add ima908
     INTO g_pmh[l_ac].ima02,g_pmh[l_ac].ima021,g_pmh[l_ac].ima25,
          g_pmh[l_ac].ima44,l_imaacti,g_pmh[l_ac].ima908
     FROM ima_file
    WHERE ima01 = l_pmh01
 
   CASE WHEN SQLCA.SQLCODE=100
             LET g_errno = 'mfg0002'
             LET g_pmh[l_ac].ima02   =  NULL
             LET g_pmh[l_ac].ima021  =  NULL
             LET g_pmh[l_ac].ima25   =  NULL
             LET g_pmh[l_ac].ima44   =  NULL
             LET g_pmh[l_ac].ima908  =  NULL #FUN-560193
        WHEN l_imaacti='N' LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'   #No.FUN-690022 add
        OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
 
END FUNCTION
FUNCTION i258_pmh01_1(p_cmd,l_m)
DEFINE p_cmd           LIKE type_file.chr1,   
       l_desc          LIKE gfe_file.gfe01,  
       l_m             LIKE pmh_file.pmh01,
       l_ima02         LIKE ima_file.ima02,
       l_ima021        LIKE ima_file.ima021,
       l_ima25         LIKE ima_file.ima25,
       l_ima44         LIKE ima_file.ima44,
       l_ima54         LIKE ima_file.ima54,
       l_ima53         LIKE ima_file.ima53,
       l_ima91         LIKE ima_file.ima91,
       l_ima531        LIKE ima_file.ima531,
       l_ima532        LIKE ima_file.ima532,
       l_ima45         LIKE ima_file.ima45,
       l_imaacti       LIKE ima_file.imaacti          #資料有效碼
 
   LET g_errno = ' '
   SELECT ima02,ima021,ima25,ima44,imaacti,ima908 #FUN-560193 add ima908
     INTO g_pmh[l_ac].ima02,g_pmh[l_ac].ima021,g_pmh[l_ac].ima25,
          g_pmh[l_ac].ima44,l_imaacti,g_pmh[l_ac].ima908
     FROM ima_file
    WHERE ima01 = l_m
 
   CASE WHEN SQLCA.SQLCODE=100
             LET g_errno = 'mfg0002'
             LET g_pmh[l_ac].ima02   =  NULL
             LET g_pmh[l_ac].ima021  =  NULL
             LET g_pmh[l_ac].ima25   =  NULL
             LET g_pmh[l_ac].ima44   =  NULL
             LET g_pmh[l_ac].ima908  =  NULL #FUN-560193
        WHEN l_imaacti='N' LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'   #No.FUN-690022 add
        OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
 
END FUNCTION
FUNCTION i258_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
 
   MESSAGE ""
   CALL cl_opmsg('q')
 
   CALL i258_curs()                    #取得查詢條件
 
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_pmh02 TO NULL
      RETURN
   END IF
 
   OPEN i258_b_curs                    #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                         #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pmh02 TO NULL
   ELSE
      OPEN i258_count
      FETCH i258_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i258_fetch('F')            #讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i258_fetch(p_flag)
DEFINE p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-680136 VARCHAR(1)
 
   MESSAGE ""
   CASE p_flag
       WHEN 'N' FETCH NEXT     i258_b_curs INTO g_pmh02
       WHEN 'P' FETCH PREVIOUS i258_b_curs INTO g_pmh02
       WHEN 'F' FETCH FIRST    i258_b_curs INTO g_pmh02
       WHEN 'L' FETCH LAST     i258_b_curs INTO g_pmh02
       WHEN '/'
           IF (NOT g_no_ask) THEN
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
           FETCH ABSOLUTE g_jump i258_b_curs INTO g_pmh02
           LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                         #有麻煩
      CALL cl_err(g_pmh02,SQLCA.sqlcode,0)
      INITIALIZE g_pmh02 TO NULL
   ELSE
      CALL i258_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
END FUNCTION
 
FUNCTION i258_show()
 DEFINE  l_tot    LIKE pmh_file.pmh11
 
   DISPLAY g_pmh02 TO pmh02               #單頭
 
   CALL i258_pmh02('d')                   #單身
   CALL i258_b_fill(g_wc)                 #單身
 
   CALL cl_show_fld_cont()                #No.FUN-550037 hmf
 
END FUNCTION
 
FUNCTION i258_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pmh02 IS NULL THEN
      CALL cl_err("",-400,0)                 #No.FUN-6B0079
      RETURN
   END IF
 
   LET g_success = 'Y'                    #FUN-9A0056 Add
  #BEGIN WORK                             #FUN-9A0056 mark
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL       #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pmh02"      #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pmh02       #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      BEGIN WORK                          #FUN-9A0056 Add
      DELETE FROM pmh_file WHERE pmh02 = g_pmh02
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","pmh_file","","",SQLCA.sqlcode,"","BODY DELETE:",1)  #No.FUN-660129
         LET g_success = 'N'                                                     #FUN-9A0056 add
      ELSE
        #FUN-9A0056 add begin ---------
        #當資料狀態為已核准且有效時,需傳送MES執行刪除料件供應商資料
         IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
           FOR i = 1 TO g_pmh.getLength()
             IF g_pmh[i].pmhacti='Y' AND g_pmh[i].pmh05 = '0' THEN
                LET l_par = g_pmh[i].pmh01,"{+}",g_pmh02
                CALL i258_mes('delete',l_par)
                IF g_success = 'N' THEN
                   EXIT FOR
                END IF
             END IF
           END FOR
         END IF
        #FUN-9A0056 add end -----------

         IF g_success = 'Y' THEN                             #FUN-9A0056 add
         CLEAR FORM
         CALL g_pmh.clear()
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE 'Remove (',g_cnt USING '####&',') Row(s)'
         LET g_msg=TIME
         INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980006 add azoplant,azolegal
            VALUES ('apmi258',g_user,g_today,g_msg,g_pmh02,'delete',g_plant,g_legal) #FUN-980006 add g_plant,g_legal
        #FUN-9A0056 add begin -----
            IF SQLCA.sqlcode THEN
               CALL cl_err('ins azo_file',SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF
         END IF

         IF g_success = 'N' THEN
           ROLLBACK WORK
           RETURN
         ELSE
           COMMIT WORK
         END IF
        #FUN-9A0056 add end -------
         OPEN i258_count
         #FUN-B50063-add-start--
         IF STATUS THEN
            CLOSE i258_b_curs
            CLOSE i258_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end-- 
         FETCH i258_count INTO g_row_count
         #FUN-B50063-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE i258_b_curs
            CLOSE i258_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50063-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i258_b_curs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i258_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL i258_fetch('/')
         END IF
      END IF
   END IF
  #COMMIT WORK     #FUN-9A0056 mark
 
END FUNCTION
 
FUNCTION i258_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
       l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
       l_n1            LIKE type_file.num5,                #No.FUN-810017
       l_n3            LIKE type_file.num5,                #No.FUN-810017
       l_n2            LIKE type_file.num5,                #No.FUN-810017
       l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680136 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-680136 VARCHAR(1)
       l_cmd           LIKE type_file.chr1000,             #可新增否  #No.FUN-680136 VARCHAR(80)
       l_tot           LIKE pmh_file.pmh11,
       l_pmh09         LIKE pmh_file.pmh09,
       l_pmh15         LIKE pmh_file.pmh15,
       l_pmh16         LIKE pmh_file.pmh16,
       l_ima927        LIKE ima_file.ima927,               #No.FUN-A90050 
       l_wpa02         LIKE wpa_file.wpa02,                 #No.FUN-A90050     
       l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680136 SMALLINT
       l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-680136 SMALLINT
DEFINE  l_s      LIKE type_file.chr1000                                                                                             
DEFINE  l_m      LIKE type_file.chr1000                                                                                             
DEFINE  i        LIKE type_file.num5                                                                                                
DEFINE  l_s1     LIKE type_file.chr1000                                                                                             
DEFINE  l_m1     LIKE type_file.chr1000                                                                                             
DEFINE  i1       LIKE type_file.num5                                                                                                
DEFINE  l_pmh11  LIKE pmh_file.pmh11  #MOD-BC0309

 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pmh02 IS NULL THEN
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT pmh01,' ',' ',pmh21,'',pmh23,pmh05,pmh08,pmh24,pmh25,pmh06,pmh13,pmh14,pmh17,pmh18,pmh12,pmh19,pmh11,",   #No.FUN-610018  #No.FUN-670099 #No.FUN-810017 #FUN-940083 add pmh24#FUN-930061 #FUN-A90050 add pmh25
                      "       pmh04,pmh07,' ',' ',' ',' ', ", #FUN-560193 add ' '
                      "       pmhuser,pmhgrup,pmhmodu,pmhdate,pmhacti ",   #TQC-730102
                      "  FROM pmh_file",
                      "  WHERE pmh02=? AND pmh01=? AND pmh13=? ",
                      "   AND pmh21=? AND pmh23=? ",  #No.FUN-870124
                      "   AND pmh22='",g_pmh22,"' FOR UPDATE"  #No.FUN-670099
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i258_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_pmh WITHOUT DEFAULTS FROM s_pmh.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         LET g_rec_b  = ARR_COUNT()
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK   #FUN-880121
 
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_pmh_t.* = g_pmh[l_ac].*  #BACKUP
            OPEN i258_bcl USING g_pmh02,g_pmh_t.pmh01,g_pmh_t.pmh13,g_pmh_t.pmh21,g_pmh_t.pmh23  #No.FUN-870124
            IF STATUS THEN
               CALL cl_err("OPEN i258_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i258_bcl INTO g_pmh[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_pmh_t.pmh01,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  #-->讀取付款方式說明
                  SELECT ima02,ima021,ima25,ima44,ima908 #FUN-560193 add aim908
                    INTO g_pmh[l_ac].ima02,g_pmh[l_ac].ima021,
                         g_pmh[l_ac].ima25,g_pmh[l_ac].ima44,g_pmh[l_ac].ima908 #FUN-560193 add aim908
                    FROM ima_file
                   WHERE ima01 = g_pmh[l_ac].pmh01
                CALL i258_pmh01('a',g_pmh[l_ac].pmh01)
                  SELECT ecd02 INTO g_pmh[l_ac].ecd02 FROM ecd_file
                   WHERE ecd01 = g_pmh[l_ac].pmh21
                  IF SQLCA.sqlcode = 100 THEN
                     LET g_pmh[l_ac].pmh21 = ' '
                  END IF
                IF g_sma.sma120 = 'Y' THEN
                 IF NOT cl_null(g_errno) THEN
                    LET g_buf = g_pmh[l_ac].pmh01
                    LET l_s1 = g_buf.trim()
                      LET l_m1 = ' '
                     FOR i1=1 TO length(l_s1)                                                                                                  
                     IF l_s1[i1,i1] = '_' THEN                                                                                              
                        LET l_m1 = l_s1[1,i1-1]                                                                                             
                        EXIT FOR                                                                                                         
                     ELSE                                                                                                                
                        CONTINUE FOR                                                                                                     
                     END IF                                                                                                              
                     IF l_s1[i1,i1] = '-' THEN                                                                                               
                        LET l_m1 = l_s1[1,i1-1]                                                                                              
                        EXIT FOR                                                                                                          
                     ELSE                                                                                                                 
                        CONTINUE FOR                                                                                                       
                     END IF                                                                                                               
                     IF l_s1[i1,i1] = ' ' THEN                                                                                               
                        LET l_m1 = l_s1[1,i1-1]                                                                                              
                        EXIT FOR                                                                                                          
                     ELSE                                                                                                                 
                        CONTINUE FOR                                                                                                       
                     END IF                                                                                                               
                   END FOR
                   IF NOT cl_null(l_m1) THEN                 
                      SELECT ima02,ima021,ima25,ima44,ima908 #FUN-560193 add aim908
                        INTO g_pmh[l_ac].ima02,g_pmh[l_ac].ima021,
                             g_pmh[l_ac].ima25,g_pmh[l_ac].ima44,g_pmh[l_ac].ima908 #FUN-560193 add aim908
                        FROM ima_file
                       WHERE ima01 = l_m1
                   END IF
                 END IF
                END IF   
                  SELECT mse02 INTO g_pmh[l_ac].mse02
                    FROM mse_file
                   WHERE mse01 = g_pmh[l_ac].pmh07
                  CALL i258_pmh17('a')           #No.FUN-610018
                  DISPLAY g_pmh[l_ac].pmh17 TO pmh17
                  DISPLAY g_pmh[l_ac].pmh18 TO pmh18
                  DISPLAY g_pmh[l_ac].pmh19 TO pmh19
                  CALL i258_set_entry(p_cmd)     #No.FUN-610018
                  CALL i258_set_no_entry(p_cmd)  #No.FUN-610018                
                  LET g_pmh_t.*=g_pmh[l_ac].*
               END IF
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
         #No.TQC-B60031  --Begin
         IF g_pmh[l_ac].pmh01[1,4]='MISC' THEN 
            LET g_pmh[l_ac].pmh08 = 'N'
            DISPLAY BY NAME g_pmh[l_ac].pmh08
            CALL cl_set_comp_entry("pmh08",FALSE)
         ELSE 
            CALL cl_set_comp_entry("pmh08",TRUE)         	    
         END IF 
         #No.TQC-B60031  --End
         DISPLAY BY NAME g_pmh[l_ac].*   #MOD-CB0132 add
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_pmh[l_ac].* TO NULL      #900423
         LET g_pmh[l_ac].pmh12 = 0
         LET g_pmh[l_ac].pmh11 = 0
         LET g_pmh[l_ac].pmh05 = '0'
         LET g_pmh[l_ac].pmh06 = g_today       #MOD-CB0132
         LET g_pmh[l_ac].pmh08 = 'Y'
         LET g_pmh[l_ac].pmh25 = "N"           #No.FUN-A90050
         SELECT pmc914 INTO g_pmh[l_ac].pmh24
           FROM pmc_file 
           WHERE pmc01=g_pmh02
         LET g_pmh[l_ac].pmh23 = " "           #No.FUN-810017
         CALL i258_pmh17('a')
         CALL i258_set_entry(p_cmd)
         CALL i258_set_no_entry(p_cmd)  
         LET g_pmh[l_ac].pmhuser = g_user
         LET g_pmh[l_ac].pmhgrup = g_grup
         LET g_pmh[l_ac].pmhdate = g_today
         LET g_pmh[l_ac].pmhacti = 'Y'
         LET g_pmh_t.* = g_pmh[l_ac].*         #新輸入資料
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD pmh01
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         #MOD-BC0309 add begin----------------------
         CALL i258_chk_pmh11() RETURNING l_pmh11
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(l_pmh11,g_errno,1)
            CANCEL INSERT
         END IF
         #MOD-BC0309 add end------------------------

         SELECT ima100,ima101,ima102 INTO l_pmh09,l_pmh15,l_pmh16
           FROM ima_file
          WHERE ima01 = g_pmh[l_ac].pmh01
         
         IF cl_null(g_pmh[l_ac].pmh21) THEN
            LET g_pmh[l_ac].pmh21 = " "
            LET g_pmh[l_ac].ecd02 = " "
         END IF

         LET g_success = 'Y'                #FUN-9A0056 add

         IF cl_null(g_pmh[l_ac].pmh23) THEN
            LET g_pmh[l_ac].pmh23= " "
         END IF
         IF cl_null(g_pmh[l_ac].pmh13) THEN 
            LET g_pmh[l_ac].pmh13=' ' END IF
         IF cl_null(g_pmh[l_ac].pmh24) THEN LET g_pmh[l_ac].pmh24 ='N' END IF #MOD-DA0088 add   
         
         INSERT INTO pmh_file(pmh02,pmh01,pmh05,pmh08,pmh13,pmh17,pmh18,pmh12,pmh19,pmh11,pmh23,   #No.FUN-610018 #No.FUN-810017 add pmh23
                              pmh04,pmh06,pmh14,pmh07,pmhacti,pmhuser,
                              pmhgrup,pmhdate,pmh09,pmh15,pmh16,pmh21,pmh22,pmh24,pmh25)  #No.FUN-670099   #TQC-730102 #FUN-940083 add pmh24 #FUN-A90025 add pmh25
                       VALUES(g_pmh02,g_pmh[l_ac].pmh01,g_pmh[l_ac].pmh05,
                              g_pmh[l_ac].pmh08,g_pmh[l_ac].pmh13,
                              g_pmh[l_ac].pmh17,g_pmh[l_ac].pmh18,   #No.FUN-610018
                              g_pmh[l_ac].pmh12,g_pmh[l_ac].pmh19,   #No.FUN-610018
                              g_pmh[l_ac].pmh11,g_pmh[l_ac].pmh23,   #No.FUN-810017 add pmh23
                              g_pmh[l_ac].pmh04,g_pmh[l_ac].pmh06,
                              g_pmh[l_ac].pmh14,g_pmh[l_ac].pmh07,
                              g_pmh[l_ac].pmhacti,g_pmh[l_ac].pmhuser,
                              g_pmh[l_ac].pmhgrup,g_pmh[l_ac].pmhdate,
                              l_pmh09,l_pmh15,l_pmh16,g_pmh[l_ac].pmh21,g_pmh22,
                              g_pmh[l_ac].pmh24,g_pmh[l_ac].pmh25)     #FUN-940083 add pmh24 #FUN-A90050 add pmh25
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pmh_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CANCEL INSERT
            ROLLBACK WORK
         ELSE
            IF NOT i258_ins_bmj() THEN  
              #CANCEL INSERT                 #FUN-9A0056 mark
              #ROLLBACK WORK                 #FUN-9A0056 mark
               LET g_success = 'N'           #FUN-9A0056 add
           #ELSE                             #FUN-9A0056 mark
            END IF                           #FUN-9A0056 add

           #FUN-9A0056 add begin -------
           #新增時,有效欄位(pmhacti)為有效,且核准欄位(pmh05)為核准:0,才要傳送MES
            IF g_success='Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
               LET l_par = g_pmh[l_ac].pmh01,"{+}",g_pmh02
               IF g_pmh[l_ac].pmhacti = 'Y' AND g_pmh[l_ac].pmh05 = '0' THEN
                  CALL i258_mes('insert',l_par)
               END IF
            END IF

            IF g_success = 'N' THEN
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
           #FUN-9A0056 add end ---------
               MESSAGE 'INSERT O.K'
               COMMIT WORK
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF   #FUN-880121
         END IF
 
      AFTER FIELD pmh01
         IF NOT cl_null(g_pmh[l_ac].pmh01) THEN
#FUN-AA0059 ---------------------start----------------------------
            IF NOT s_chk_item_no(g_pmh[l_ac].pmh01,"") THEN
             CALL cl_err('',g_errno,1)
             LET g_pmh[l_ac].pmh01= g_pmh_t.pmh01
             NEXT FIELD pmh01
            END IF
#FUN-AA0059 ---------------------end-------------------------------

#TQC-B50017 --begin--
         IF g_pmh[l_ac].pmh01[1,4]='MISC' THEN 
            LET g_pmh[l_ac].pmh08 = 'N'
            DISPLAY BY NAME g_pmh[l_ac].pmh08
            CALL cl_set_comp_entry("pmh08",FALSE)
         ELSE 
            CALL cl_set_comp_entry("pmh08",TRUE)         	    
         END IF 
#TQC-B50017 --end--    

            CALL i258_pmh01('a',g_pmh[l_ac].pmh01)
           LET l_m = ' '
          #No.FUN-A90050  --start--
          SELECT ima927 INTO l_ima927
            FROM ima_file
           WHERE ima01 = g_pmh[l_ac].pmh01

          SELECT wpa02 INTO l_wpa02 
            FROM wpa_file 
           WHERE wpa01=g_pmh02

           IF l_ima927="Y" AND l_wpa02="Y" THEN
              LET g_pmh[l_ac].pmh25="Y"
           END IF
           #No.FUN-A90050  --end--
           IF g_sma.sma120 = 'Y' THEN                                                                                         
              IF NOT cl_null(g_errno) THEN
                 SELECT count(*) INTO l_n3                                                                                    
                   FROM imx_file,sma_file                                                                                     
                  WHERE (imx00||sma46||imx01||sma46||imx02||sma46||imx03||sma46||imx04=g_pmh[l_ac].pmh01)                     
                     OR (imx00||sma46||imx01||sma46||imx02||sma46||imx03=g_pmh[l_ac].pmh01)                                   
                     OR (imx00||sma46||imx01||sma46||imx02=g_pmh[l_ac].pmh01)                                                 
                     OR (imx00||sma46||imx01=g_pmh[l_ac].pmh01)                                                               
                     OR imx00=g_pmh[l_ac].pmh01                                                                               
                 IF l_n3 > 0 THEN 
                    LET g_errno = ' ' 
                    LET g_buf = g_pmh[l_ac].pmh01
                    LET l_s = g_buf.trim()
                    FOR i=1 TO length(l_s)                                                                                          
                        IF l_s[i,i] = '_' THEN                                                                                      
                           LET l_m = l_s[1,i-1]                                                                                     
                           CALL i258_pmh01_1('a',l_m)                                                                               
                           EXIT FOR                                                                                                 
                        ELSE                                                                                                        
                           CONTINUE FOR                                                                                             
                        END IF                                                                                                      
                        IF l_s[i,i] = '-' THEN                                                                                      
                           LET l_m = l_s[1,i-1]                                                                                     
                           CALL i258_pmh01_1('a',l_m)                                                                               
                           EXIT FOR                                                                                                 
                        ELSE                                                                                                        
                           CONTINUE FOR                                                                                             
                        END IF                                                                                                      
                        IF l_s[i,i] = ' ' THEN                                                                                      
                           LET l_m = l_s[1,i-1]                                                                                     
                           CALL i258_pmh01_1('a',l_m)                                                                               
                           EXIT FOR                                                                                                 
                        ELSE                                                                                                        
                           CONTINUE FOR                                                                                             
                        END IF                                                                                                      
                    END FOR
                 ELSE                                                                                            
                    CALL cl_err('','apm-828',0)                                                                               
                    NEXT FIELD pmh01                                                                                          
                 END IF                                                                                                       
              END IF                                                                                                          
           END IF                                                                                                             
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pmh[l_ac].pmh01,g_errno,0)
               NEXT FIELD pmh01
            END IF
         END IF
 
      AFTER FIELD pmh05
         IF NOT cl_null(g_pmh[l_ac].pmh05) THEN
            IF g_pmh[l_ac].pmh05 NOT MATCHES'[012]' THEN
               NEXT FIELD pmh05
            END IF
            CALL cl_set_comp_required("pmh06",g_pmh[l_ac].pmh05='0')   #MOD-CB0132
         END IF

      #MOD-CB0132 -- add start --
      BEFORE FIELD pmh06
         IF g_pmh[l_ac].pmh05 = '0' THEN
            CALL cl_set_comp_required("pmh06",TRUE)
         ELSE
            CALL cl_set_comp_required("pmh06",FALSE)
         END IF
      #MOD-CB0132 -- add end --
 
      AFTER FIELD pmh08
         IF NOT cl_null(g_pmh[l_ac].pmh08) THEN
            IF g_pmh[l_ac].pmh08 NOT MATCHES'[yYnN]' THEN
               NEXT FIELD pmh08
            END IF
         END IF
 
      AFTER FIELD pmh24
         IF NOT cl_null(g_pmh[l_ac].pmh24) THEN
            IF g_pmh[l_ac].pmh24 NOT MATCHES'[yYnN]' THEN
               NEXT FIELD pmh24
            END IF
         END IF
      #No.FUN-A90050  --start--     
        AFTER FIELD pmh25
           IF NOT cl_null(g_pmh[l_ac].pmh25) THEN
              IF g_pmh[l_ac].pmh25 NOT MATCHES'[yYnN]' THEN
                 NEXT FIELD pmh25
              ELSE              
              	IF l_ima927='N' AND g_pmh[l_ac].pmh25='Y' THEN
              	   CALL cl_err(g_pmh[l_ac].pmh01,'pmh-251',1)               	   
              	   LET g_pmh[l_ac].pmh25='N'
                   DISPLAY BY NAME g_pmh[l_ac].pmh25  
                   NEXT FIELD pmh25 
                END IF
                IF l_wpa02='N' AND g_pmh[l_ac].pmh25='Y'THEN
                   CALL cl_err(g_pmh02,'pmh-252',1)
                   LET g_pmh[l_ac].pmh25='N'
                   DISPLAY BY NAME g_pmh[l_ac].pmh25  
                   NEXT FIELD pmh25
                END IF 
              END IF                                     
           END IF
        #No.FUN-A90050  --end--     
      AFTER FIELD pmh13
         IF NOT cl_null(g_pmh[l_ac].pmh13) THEN
            IF g_pmh[l_ac].pmh13 IS NOT NULL AND
               (g_pmh[l_ac].pmh13 != g_pmh_t.pmh13 OR
                cl_null(g_pmh_t.pmh13)) THEN
                  CALL i258_pmh13('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_pmh[l_ac].pmh13,g_errno,0)
                     NEXT FIELD pmh13
                  END IF
                  IF g_aza.aza17 = g_pmh[l_ac].pmh13 THEN   #本幣
                     LET g_pmh[l_ac].pmh14 = 1
                  ELSE
                     CALL s_curr3(g_pmh[l_ac].pmh13,g_pmh[l_ac].pmh06,g_sma.sma904) #FUN-640012
                          RETURNING g_pmh[l_ac].pmh14
                  END IF
            END IF
         END IF
 
      #No.TQC-BB0239  --Begin
      AFTER FIELD pmh06
         IF NOT cl_null(g_pmh[l_ac].pmh06) THEN
            IF g_pmh[l_ac].pmh06 != g_pmh_t.pmh06 OR cl_null(g_pmh_t.pmh06) THEN
               IF NOT cl_null(g_pmh[l_ac].pmh13) THEN #MOD-D60003 add
                  IF g_aza.aza17 = g_pmh[l_ac].pmh13 THEN   #本幣
                     LET g_pmh[l_ac].pmh14 = 1
                  ELSE
                     CALL s_curr3(g_pmh[l_ac].pmh13,g_pmh[l_ac].pmh06,g_sma.sma904) #FUN-640012
                          RETURNING g_pmh[l_ac].pmh14
                  END IF
               END IF #MOD-D60003 add
            END IF
         END IF
        #No.TQC-BB0239  --End

        AFTER FIELD pmh21
           IF NOT cl_null(g_pmh[l_ac].pmh21) THEN
              SELECT COUNT(*) INTO g_cnt FROM ecd_file
               WHERE ecd01=g_pmh[l_ac].pmh21
              IF g_cnt=0 THEN
                 CALL cl_err('sel ecd_file',100,0)
                 NEXT FIELD pmh21
              END IF
           END IF
           IF cl_null(g_pmh[l_ac].pmh21) THEN
              LET g_pmh[l_ac].pmh21=" "
              LET g_pmh[l_ac].ecd02=" "   #No.FUN-930061
           END IF
           IF g_pmh[l_ac].pmh13 != g_pmh_t.pmh13 OR g_pmh_t.pmh13 IS NULL THEN
              IF NOT cl_null(g_pmh[l_ac].pmh23) THEN    #No.FUN-870124
              SELECT COUNT(*) INTO l_n FROM pmh_file
               WHERE pmh02 = g_pmh02
                 AND pmh01 = g_pmh[l_ac].pmh01
                 AND pmh13 = g_pmh[l_ac].pmh13
                 AND pmh21 = g_pmh[l_ac].pmh21    #No.FUN-870124
                 AND pmh23 = g_pmh[l_ac].pmh23
                 AND pmh22 = g_pmh22
                 AND pmhacti = 'Y'                                           #CHI-910021
              IF l_n > 0 THEN
                 CALL cl_err('',-239,0)
                 NEXT FIELD pmh21
              END IF
              END IF
           END IF
         IF NOT cl_null(g_pmh[l_ac].pmh23) AND g_pmh[l_ac].pmh23 != " " THEN                                                  
            IF g_pmh[l_ac].pmh21 IS NULL OR g_pmh[l_ac].pmh21 = " " THEN                                                      
               CALL cl_err('','aap-099',0)                                                                                    
               NEXT FIELD pmh21                                                                                               
            END IF                                                                                                            
         END IF                
         
         SELECT ecd02 INTO g_pmh[l_ac].ecd02 FROM ecd_file
          WHERE ecd01 = g_pmh[l_ac].pmh21
         IF SQLCA.sqlcode = 100 THEN
            LET g_pmh[l_ac].pmh21 = ' '
         END IF
      AFTER FIELD pmh23                                                                                                       
         IF cl_null(g_pmh[l_ac].pmh23) THEN                                                                                   
            LET g_pmh[l_ac].pmh23 = " "                                                                                       
         END IF                                                                                                               
         IF NOT cl_null(g_pmh[l_ac].pmh23) AND g_pmh[l_ac].pmh23 != " " THEN                                                  
            SELECT count(*) INTO l_n1 FROM sga_file                                                                           
             WHERE sga01 = g_pmh[l_ac].pmh23                                                                                  
               AND sgaacti = 'Y'                                                                                              
            IF l_n1 = 0 THEN                                                                                                  
               CALL cl_err('','apm-105',0)                                                                                    
               NEXT FIELD pmh23                                                                                               
            END IF                                                                                                            
            IF g_pmh[l_ac].pmh21 IS NULL OR g_pmh[l_ac].pmh21 = " " THEN                                                      
               CALL cl_err('','aap-099',0)                                                                                    
               NEXT FIELD pmh21                                                                                               
            END IF                                                                                                            
         END IF                                                                                                               
 
      AFTER FIELD pmh14
         IF NOT cl_null(g_pmh[l_ac].pmh14) THEN
            IF g_pmh[l_ac].pmh14 = 0 THEN
               NEXT FIELD pmh14
            END IF
 
            IF g_pmh[l_ac].pmh13 =g_aza.aza17 THEN
               LET g_pmh[l_ac].pmh14 =1
               DISPLAY g_pmh[l_ac].pmh14  TO pmh14
            END IF
 
         END IF
 
      AFTER FIELD pmh12
         IF NOT cl_null(g_pmh[l_ac].pmh12) THEN
            SELECT azi03 INTO t_azi03
              FROM azi_file
             WHERE azi01 = g_pmh[l_ac].pmh13
            IF cl_null(t_azi03) THEN
               LET t_azi03 = g_azi03
            END IF
            LET g_pmh[l_ac].pmh12 = cl_digcut(g_pmh[l_ac].pmh12,t_azi03)
            LET g_pmh[l_ac].pmh19 = g_pmh[l_ac].pmh12 * (1 + g_pmh[l_ac].pmh18/100)
            LET g_pmh[l_ac].pmh19 = cl_digcut(g_pmh[l_ac].pmh19,t_azi03)
            DISPLAY g_pmh[l_ac].pmh12 TO pmh12
            DISPLAY g_pmh[l_ac].pmh19 TO pmh19
         END IF
 
      AFTER FIELD pmh19
         IF NOT cl_null(g_pmh[l_ac].pmh19) THEN
            SELECT azi03 INTO t_azi03
              FROM azi_file
             WHERE azi01 = g_pmh[l_ac].pmh13
            IF cl_null(t_azi03) THEN
               LET t_azi03 = g_azi03
            END IF
            LET g_pmh[l_ac].pmh19 = cl_digcut(g_pmh[l_ac].pmh19,t_azi03)
            LET g_pmh[l_ac].pmh12 = g_pmh[l_ac].pmh19 / (1 + g_pmh[l_ac].pmh18/100)
            LET g_pmh[l_ac].pmh12 = cl_digcut(g_pmh[l_ac].pmh12,t_azi03)
            DISPLAY g_pmh[l_ac].pmh12 TO pmh12
            DISPLAY g_pmh[l_ac].pmh19 TO pmh19
         END IF
 
      AFTER FIELD pmh11
         IF NOT cl_null(g_pmh[l_ac].pmh11) THEN
            IF g_pmh[l_ac].pmh11 < 0 THEN
               NEXT FIELD pmh11
            END IF
            #MOD-BC0309 add begin----------------------
            CALL i258_chk_pmh11() RETURNING l_pmh11
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(l_pmh11,g_errno,1)
               NEXT FIELD pmh11
            END IF
            #MOD-BC0309 add end------------------------
         END IF
 
      AFTER FIELD pmh07
         IF NOT cl_null(g_pmh[l_ac].pmh07) THEN
            SELECT mse02 INTO g_pmh[l_ac].mse02
              FROM mse_file
             WHERE mse01=g_pmh[l_ac].pmh07
            IF STATUS THEN 
               CALL cl_err3("sel","mse_file",g_pmh[l_ac].pmh07,"",STATUS,"sel mse:","",1)  #No.FUN-660129
               NEXT FIELD pmh07
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF NOT cl_null(g_pmh_t.pmh01) THEN
            IF NOT cl_delb(0,0) THEN
               ROLLBACK WORK
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            LET g_success = 'Y'               #FUN-9A0056 add
            DELETE FROM pmh_file
             WHERE pmh02=g_pmh02
               AND pmh01=g_pmh_t.pmh01
               AND pmh13=g_pmh_t.pmh13
               AND pmh21=g_pmh_t.pmh21        #No.FUN-870124              
               AND pmh22=g_pmh22              #No.FUN-870124
               AND pmh23=g_pmh_t.pmh23        #No.FUN-870124
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","pmh_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
              #ROLLBACK WORK                                               #FUN-9A0056 mark
              #CANCEL DELETE                                               #FUN-9A0056 mark
               LET g_success = 'N'                                         #FUN-9A0056 add
            END IF
           #FUN-9A0056 add begin------------
            IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" AND g_pmh_t.pmhacti='Y' THEN
               LET l_par = g_pmh_t.pmh01,"{+}",g_pmh02
               CALL i258_mes('delete',l_par)
            END IF
           #FUN-9A0056 add end--------------
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
        #FUN-9A0056 add begin--
         IF g_success = 'N' THEN
            ROLLBACK WORK
            CANCEL DELETE
         ELSE
            COMMIT WORK
         END IF
        #FUN-9A0056 add end----
        #COMMIT WORK                   #FUN-9A0056 mark
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_pmh[l_ac].* = g_pmh_t.*
            CLOSE i258_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET g_success = 'Y'                        #FUN-9A0056 add
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_pmh[l_ac].pmh01,-263,1)
            LET g_pmh[l_ac].* = g_pmh_t.*
            LET g_success = 'N'                     #FUN-9A0056 add
         ELSE
            IF cl_null(g_pmh[l_ac].pmh21) THEN
               LET g_pmh[l_ac].pmh21 = " "
               LET g_pmh[l_ac].ecd02 = " "   #No.FUN-930061
            END IF
            IF cl_null(g_pmh[l_ac].pmh23) THEN
               LET g_pmh[l_ac].pmh23 = " "
            END IF

            LET g_pmh[l_ac].pmhmodu = g_user
            LET g_pmh[l_ac].pmhdate = g_today
            IF cl_null(g_pmh[l_ac].pmh24) THEN LET g_pmh[l_ac].pmh24 ='N' END IF #MOD-DA0088 add
            UPDATE pmh_file SET pmh01=g_pmh[l_ac].pmh01,
                                pmh05=g_pmh[l_ac].pmh05,
                                pmh08=g_pmh[l_ac].pmh08,
                                pmh24=g_pmh[l_ac].pmh24,   #FUN-940083 add
                                pmh25=g_pmh[l_ac].pmh25,   #FUN-A90050 add
                                pmh13=g_pmh[l_ac].pmh13,
                                pmh17=g_pmh[l_ac].pmh17,   #No.FUN-610018
                                pmh18=g_pmh[l_ac].pmh18,   #No.FUN-610018
                                pmh12=g_pmh[l_ac].pmh12,
                                pmh19=g_pmh[l_ac].pmh19,   #No.FUN-610018
                                pmh11=g_pmh[l_ac].pmh11,
                                pmh04=g_pmh[l_ac].pmh04,
                                pmh06=g_pmh[l_ac].pmh06,
                                pmh14=g_pmh[l_ac].pmh14,
                                pmh07=g_pmh[l_ac].pmh07,
                                pmh21=g_pmh[l_ac].pmh21,  #No.FUN-670099
                                pmh23=g_pmh[l_ac].pmh23,  #No.FUN-810017
                                pmhacti=g_pmh[l_ac].pmhacti,   #MOD-910087
                                pmhmodu=g_pmh[l_ac].pmhmodu,
                                pmhdate=g_pmh[l_ac].pmhdate
             WHERE pmh02=g_pmh02
               AND pmh01=g_pmh_t.pmh01
               AND pmh13=g_pmh_t.pmh13
               AND pmh21=g_pmh_t.pmh21         #TQC-810025              
               AND pmh22=g_pmh22              #TQC-7B0089
               AND pmh23=g_pmh_t.pmh23        #No.FUN-810017
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","pmh_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
               LET g_pmh[l_ac].* = g_pmh_t.*
              #ROLLBACK WORK                                               #FUN-9A0056 mark
               LET g_success = 'N'                                         #FUN-9A0056 add
            ELSE
              #FUN-9A0056 mark str -----
              ##-----FUN-880121---------
              #IF NOT i258_ins_bmj() THEN
              #   LET g_pmh[l_ac].* = g_pmh_t.*
              #   ROLLBACK WORK
              #ELSE
              ##-----END FUN-880121-----
              #   MESSAGE 'UPDATE O.K'
              #   COMMIT WORK
              #END IF   #FUN-880121
              #FUN-9A0056 mark end -----

              #FUN-9A0056 add begin --------------
               IF NOT i258_ins_bmj() THEN
                  LET g_success='N'
               END IF

               IF g_success='Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
                  LET l_par = g_pmh[l_ac].pmh01,"{+}",g_pmh02

                  CASE
                   #若原為有效資料,且狀態為由已核准改為非已核准,傳送刪除MES
                    WHEN (g_pmh_t.pmhacti='Y' AND g_pmh_t.pmh05 ='0' AND g_pmh[l_ac].pmh05 != '0')
                         CALL i258_mes('delete',l_par)

                   #若為有效資料,且狀態為由非已核准改為已核准,傳送新增MES
                    WHEN (g_pmh[l_ac].pmhacti='Y' AND g_pmh_t.pmh05 !='0' AND g_pmh[l_ac].pmh05 ='0')
                         CALL i258_mes('insert',l_par)

                   #若原狀態為已核准,且資料為有效變無效,則傳送刪除MES
                    WHEN (g_pmh_t.pmh05 ='0' AND g_pmh_t.pmhacti='Y' AND g_pmh[l_ac].pmhacti != 'Y')
                         CALL i258_mes('delete',l_par)

                   #若狀態為已核准,且資料為無效變有效,則傳送新增MES
                    WHEN (g_pmh[l_ac].pmh05 ='0' AND g_pmh_t.pmhacti !='Y' AND g_pmh[l_ac].pmhacti='Y')
                         CALL i258_mes('insert',l_par)

                   #若為有效且已核准資料,則傳送異動MES資料
                    WHEN (g_pmh_t.pmh05 ='0' AND g_pmh[l_ac].pmh05 = '0') AND
                         (g_pmh_t.pmhacti='Y' AND g_pmh[l_ac].pmhacti = 'Y')
                         CALL i258_mes('update',l_par)
                  END CASE
               END IF

               IF g_success = 'N' THEN
                  LET g_pmh[l_ac].* = g_pmh_t.*
                  ROLLBACK WORK
                  EXIT INPUT
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
              #FUN-9A0056 add end -----------------
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac           #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_pmh[l_ac].* = g_pmh_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_pmh.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE i258_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac           #FUN-D30034 add
         CLOSE i258_bcl
         COMMIT WORK
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pmh01)
#FUN-AA0059 --Begin--
             #  CALL cl_init_qry_var()
             #  LET g_qryparam.form ="q_ima"
             #  LET g_qryparam.default1 = g_pmh[l_ac].pmh01
             #  CALL cl_create_qry() RETURNING g_pmh[l_ac].pmh01
                CALL q_sel_ima(FALSE, "q_ima", "", g_pmh[l_ac].pmh01, "", "", "", "" ,"",'' )  RETURNING g_pmh[l_ac].pmh01
#FUN-AA0059 --End--
                DISPLAY BY NAME g_pmh[l_ac].pmh01           #No.MOD-490371
               NEXT FIELD pmh01
            WHEN INFIELD(pmh13)     #幣別
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azi"
               LET g_qryparam.default1 = ''
               CALL cl_create_qry() RETURNING g_pmh[l_ac].pmh13
                DISPLAY BY NAME g_pmh[l_ac].pmh13           #No.MOD-490371
               NEXT FIELD pmh13
              WHEN INFIELD(pmh14)
                 CALL s_rate(g_pmh[l_ac].pmh13,g_pmh[l_ac].pmh14) RETURNING g_pmh[l_ac].pmh14
                 DISPLAY g_pmh[l_ac].pmh14 TO pmh14
                 NEXT FIELD pmh14
            WHEN INFIELD(pmh07)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_mse"
               LET g_qryparam.default1 = ''
               CALL cl_create_qry() RETURNING g_pmh[l_ac].pmh07
                DISPLAY BY NAME g_pmh[l_ac].pmh07           #No.MOD-490371
               NEXT FIELD pmh07
              WHEN INFIELD(pmh23)                                                                                                   
                 CALL cl_init_qry_var()                                                                                             
                 LET g_qryparam.form ="q_sga"                                                                                       
                 LET g_qryparam.default1 = g_pmh[l_ac].pmh23                                                                        
                 CALL cl_create_qry() RETURNING g_pmh[l_ac].pmh23                                                                   
                 DISPLAY BY NAME g_pmh[l_ac].pmh23                                                                                  
              WHEN INFIELD(pmh21)     #作業編號
                 CALL q_ecd(FALSE,TRUE,'') RETURNING g_pmh[l_ac].pmh21
                 DISPLAY BY NAME g_pmh[l_ac].pmh21 
                 SELECT ecd02 INTO g_pmh[l_ac].ecd02 FROM ecd_file
                  WHERE ecd01 = g_pmh[l_ac].pmh21
                 IF SQLCA.sqlcode = 100 THEN
                    LET g_pmh[l_ac].pmh21 = ' '
                 END IF
                 NEXT FIELD pmh21
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION item_vender
         CASE
             WHEN INFIELD(pmh04)     #廠商料號
                LET l_cmd ='apmi253 ','"',g_pmh[l_ac].pmh01,'"',' ','"',g_pmh02,'"  "Y" '
                CALL cl_cmdrun(l_cmd)
             OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(pmh01) AND l_ac > 1 THEN
            LET g_pmh[l_ac].* = g_pmh[l_ac-1].*
            NEXT FIELD pmh01
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
   END INPUT
 
   CLOSE i258_bcl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i258_pmh02(p_cmd)  #供應廠商
   DEFINE p_cmd        LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
          l_pmcacti    LIKE pmc_file.pmcacti
 
   LET g_errno = ' '
   SELECT pmc03,pmcacti
     INTO tm.pmc03,l_pmcacti
     FROM pmc_file
    WHERE pmc01 = g_pmh02
 
   CASE WHEN SQLCA.SQLCODE=100
             LET g_errno = 'mfg3001'
             LET  tm.pmc03 = NULL
        WHEN l_pmcacti='N' LET g_errno = '9028'
        WHEN l_pmcacti MATCHES '[PH]'  LET g_errno = '9038'  #No.FUN-690024 add
        OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY BY NAME tm.pmc03
   END IF
 
END FUNCTION
 
FUNCTION i258_pmh13(p_cmd)  #幣別
   DEFINE p_cmd        LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
          l_aziacti    LIKE pmc_file.pmcacti
 
   LET g_errno = ' '
   SELECT azi02,aziacti
     FROM azi_file
    WHERE azi01 = g_pmh[l_ac].pmh13
 
   CASE WHEN SQLCA.SQLCODE=100
             LET g_errno = 'mfg3008'
        WHEN l_aziacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
 
END FUNCTION
 
FUNCTION i258_b_askkey()
DEFINE
   l_wc            LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(200)
 
   CONSTRUCT l_wc ON pmh01,pmh21,pmh23,pmh05,pmh08,pmh24,pmh25,pmh06,pmh13,pmh14,pmh17,pmh18,pmh12,pmh19,pmh11,pmh04,pmh07   #No.FUN-610018  #No.FUN-670099 #No.FUN-810017 add pmh23 #FUN-940083 add pmh24 #FUN-A90050 add pmh25
                FROM s_pmh[1].pmh01,s_pmh[1].pmh21,s_pmh[1].pmh23,s_pmh[1].pmh05,s_pmh[1].pmh08,s_pmh[1].pmh24,s_pmh[1].pmh25,s_pmh[1].pmh06,  #No.FUN-670099 3	No;FUN-810017  #FUN-940083 add pmh24  #FUN-A90050 add pmh25
                     s_pmh[1].pmh13,s_pmh[1].pmh14,s_pmh[1].pmh17,s_pmh[1].pmh18,                    #No.FUN-610018
                     s_pmh[1].pmh12,s_pmh[1].pmh19,s_pmh[1].pmh11,                                   #No.FUN-610018
                     s_pmh[1].pmh04,s_pmh[1].pmh07
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
 
   IF INT_FLAG THEN RETURN END IF
 
    LET l_wc = l_wc CLIPPED," AND pmh22 ='",g_pmh22,"'"  #No.FUN-670099
 
   CALL i258_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION i258_b_fill(p_wc)              #BODY FILL UP
DEFINE p_wc            LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(200)
DEFINE l_ima02    LIKE ima_file.ima02,                                                                                              
       l_ima44    LIKE ima_file.ima44,           
       l_ima25    LIKE ima_file.ima25,
       l_ima908   LIKE ima_file.ima908,                                                                                   
       l_ima021   LIKE ima_file.ima021,                                                                                             
       l_imaacti  LIKE ima_file.imaacti                                                                                             
DEFINE  l_s      LIKE type_file.chr1000                                                                                             
DEFINE  l_m      LIKE type_file.chr1000                                                                                             
DEFINE  i        LIKE type_file.num5                                                                                                
 
   LET g_sql = " SELECT pmh01,ima02,ima021,pmh21,ecd02,pmh23,pmh05,pmh08,pmh24,pmh25,pmh06,pmh13,pmh14,pmh17,pmh18,pmh12,pmh19,pmh11, ",  #No.FUN-610018  #No.FUN-670099 #No.FUN-810017 #FUN-940083 add pmh24#No.FUN-930061 add ecd02 #FUN-A90050 add pmh25
               "        pmh04,pmh07,mse02,ima25,ima44,ima908, ", #FUN-560193 add ima908
               " pmhuser,pmhgrup,pmhmodu,pmhdate,pmhacti ",   #TQC-730102
               " FROM pmh_file,OUTER ima_file,OUTER mse_file,OUTER ecd_file ",#No.FUN-930061 add ecd_file
               " WHERE pmh02 = '",g_pmh02,"'",
               "   AND pmh_file.pmh01 = ima_file.ima01 AND pmh_file.pmh07 = mse_file.mse01",
               "   AND pmh_file.pmh21 = ecd_file.ecd01 ",      #No.FUN-930061
               "   AND pmh22='",g_pmh22,"'",          #No.TQC-740086 
               "   AND ",p_wc CLIPPED,
               " ORDER BY 1"
   PREPARE i258_prepare2 FROM g_sql      #預備一下
   DECLARE pmh_curs CURSOR FOR i258_prepare2
 
   CALL g_pmh.clear()
   LET g_cnt = 1
 
   FOREACH pmh_curs INTO g_pmh[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_errno = ' '
      SELECT ima02,ima021,ima25,ima44,imaacti,ima908
        INTO l_ima02,l_ima021,l_ima25,l_ima44,l_imaacti,l_ima908
        FROM ima_file
       WHERE ima01 = g_pmh[g_cnt].pmh01
      CASE WHEN SQLCA.SQLCODE=100
                LET g_errno = 'mfg0002'
           WHEN l_imaacti='N' LET g_errno = '9028'
           WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'  
           OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
      END CASE
      LET l_m = ' '
      IF g_sma.sma120 = 'Y' THEN
       IF NOT cl_null(g_errno) THEN
          LET g_buf = g_pmh[g_cnt].pmh01
          LET l_s = g_buf.trim()
            FOR i=1 TO length(l_s)                                                                                                  
                IF l_s[i,i] = '_' THEN                                                                                              
                   LET l_m = l_s[1,i-1]                                                                                             
                   EXIT FOR                                                                                                         
                ELSE                                                                                                                
                   CONTINUE FOR                                                                                                     
                END IF                                                                                                              
               IF l_s[i,i] = '-' THEN                                                                                               
                  LET l_m = l_s[1,i-1]                                                                                              
                  EXIT FOR                                                                                                          
               ELSE                                                                                                                 
                 CONTINUE FOR                                                                                                       
               END IF                                                                                                               
               IF l_s[i,i] = ' ' THEN                                                                                               
                  LET l_m = l_s[1,i-1]                                                                                              
                  EXIT FOR                                                                                                          
               ELSE                                                                                                                 
                 CONTINUE FOR                                                                                                       
               END IF                                                                                                               
            END FOR
            IF NOT cl_null(l_m) THEN
               SELECT ima02,ima021,ima25,ima44,ima908 
                 INTO g_pmh[g_cnt].ima02,g_pmh[g_cnt].ima021,g_pmh[g_cnt].ima25,
                      g_pmh[g_cnt].ima44,g_pmh[g_cnt].ima908
                 FROM ima_file
               WHERE ima01 = l_m
            END IF
       END IF
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_pmh.deleteElement(g_cnt)
 
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i258_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmh TO s_pmh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i258_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i258_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i258_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i258_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i258_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
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
         IF g_aza.aza71 MATCHES '[Yy]' THEN       
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
         END IF 
 
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
             LET INT_FLAG=FALSE                 #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DISPLAY
         
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
         EXIT DISPLAY
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i258_copy()
DEFINE l_newno,l_oldno1  LIKE pmh_file.pmh02,
       l_n               LIKE type_file.num5,    #No.FUN-680136 SMALLINT
       l_ima02           LIKE ima_file.ima02,
       l_ima021          LIKE ima_file.ima021
DEFINE l_x               RECORD LIKE pmh_file.*  #FUN-9A0056 add
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pmh02 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   DISPLAY ' ' TO pmh02
 
   CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INPUT l_newno FROM pmh02
 
      AFTER FIELD pmh02
         IF NOT cl_null(l_newno) THEN
            LET l_n = 0
            SELECT count(*) INTO l_n FROM pmc_file WHERE pmc01 = l_newno
            IF l_n = 0 THEN
               CALL cl_err(l_newno,'mfg3001',0)
               NEXT FIELD pmh02
            END IF
            LET l_n = 0
            SELECT count(*) INTO l_n FROM pmh_file WHERE pmh02 = l_newno
                                                     AND pmhacti = 'Y'                                           #CHI-910021
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               NEXT FIELD pmh02
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pmh02)
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pmc1"
               LET g_qryparam.default1 = l_newno
               CALL cl_create_qry() RETURNING l_newno
               DISPLAY l_newno TO pmh02
               NEXT FIELD pmh02
            OTHERWISE EXIT CASE
         END CASE
 
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY g_pmh02 TO pmh02
      RETURN
   END IF
 
   DROP TABLE x
 
   SELECT * FROM pmh_file WHERE pmh02 = g_pmh02 AND pmhacti = 'Y' INTO TEMP x           #CHI-910021 Add  AND pmhacti = 'Y'                                  
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","pmh_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      RETURN
   END IF
 
   UPDATE x SET pmh02 = l_newno

   BEGIN WORK                                                     #FUN-9A0056 add
   LET g_success = 'Y'                                            #FUN-9A0056 add
 
   INSERT INTO pmh_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pmh_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
     #RETURN                                                      #FUN-9A0056 mark
  #FUN-9A0056 add begin-----------------------
      LET g_success = 'N'
   ELSE
     IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
        DECLARE i258_dec_x CURSOR FOR SELECT * FROM x
        FOREACH i258_dec_x INTO l_x.*
          LET l_par = l_x.pmh01,"{+}",l_x.pmh02
          IF l_x.pmhacti='Y' AND l_x.pmh05 = '0' THEN
             CALL i258_mes('insert',l_par)

             IF g_success = 'N' THEN
                EXIT FOREACH
             END IF
          END IF
        END FOREACH
      END IF
  #FUN-9A0056 add end-------------------------
   END IF

  #FUN-9A0056 add str -----
   IF g_success = 'N' THEN
     ROLLBACK WORK
     RETURN
   ELSE
     COMMIT WORK
   END IF
  #FUN-9A0056 add end------
 
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno1= g_pmh02
   LET g_pmh02=l_newno
 
   CALL i258_b()
   #LET g_pmh02=l_oldno1  #FUN-C80046
 
   #CALL i258_show()      #FUN-C80046
 
END FUNCTION
 
FUNCTION i258_pmh17(p_cmd)
   DEFINE p_cmd      LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
          l_pmh17    LIKE pmh_file.pmh17,
          l_pmh18    LIKE pmh_file.pmh18,
          l_gecacti  LIKE gec_file.gecacti
 
   LET g_errno = ' '
   SELECT pmc47,gec04,gec07,gecacti
     INTO l_pmh17,l_pmh18,g_gec07,l_gecacti
     FROM pmc_file,gec_file
    WHERE pmc01 = g_pmh02
      AND gec011 = '1'
      AND gec01 = pmc47
 
   CASE WHEN SQLCA.SQLCODE=100 LET g_errno = 'tis-203'
                               LET l_pmh17 = NULL
                               LET l_pmh18 = NULL
                               LET g_gec07 = NULL
        WHEN l_gecacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.sqlcode USING '-------'
   END CASE
   IF cl_null(g_gec07) THEN
      LET g_gec07 = 'N'
   END IF
   IF p_cmd = 'a' THEN
      IF cl_null(g_pmh[l_ac].pmh17) OR cl_null(g_pmh[l_ac].pmh18) THEN
         LET g_pmh[l_ac].pmh17 = l_pmh17
         LET g_pmh[l_ac].pmh18 = l_pmh18
         LET g_pmh[l_ac].pmh19 = g_pmh[l_ac].pmh12 * (1 + g_pmh[l_ac].pmh18/100)
         LET g_pmh[l_ac].pmh19 = cl_digcut(g_pmh[l_ac].pmh19,g_azi03)
      END IF
   END IF
 
END FUNCTION
 
 
FUNCTION i258_ins_bmj()         
  DEFINE  l_cnt      LIKE type_file.num5,    
          l_bmj      RECORD LIKE bmj_file.*,
          l_ima926   LIKE ima_file.ima926,         #FUN-930108
          l_pmh05    LIKE pmh_file.pmh05,
          l_pmh06    LIKE pmh_file.pmh06,
          l_pmc22    LIKE pmc_file.pmc22
 
     IF g_aza.aza92 ='Y' THEN RETURN TRUE END IF   #FUN-930108
     IF g_sma.sma102='N' THEN RETURN TRUE END IF
     SELECT ima926 INTO l_ima926 FROM ima_file
        WHERE ima01 = g_pmh[l_ac].pmh01
     IF l_ima926 != 'Y' THEN
        CALL cl_err(g_pmh[l_ac].pmh01,'apm-209',0)
        RETURN TRUE
     END IF
 
     SELECT COUNT(*) INTO l_cnt FROM bmj_file
         WHERE bmj01 = g_pmh[l_ac].pmh01
           AND bmj02 = g_pmh[l_ac].pmh07
           AND bmj03 = g_pmh02
 
     IF l_cnt = 0 AND NOT cl_null(g_pmh[l_ac].pmh07) AND
        NOT cl_null(g_pmh[l_ac].pmh01) THEN
        LET l_bmj.bmj01 = g_pmh[l_ac].pmh01
        LET l_bmj.bmj02 = g_pmh[l_ac].pmh07
        LET l_bmj.bmj03 = g_pmh02
        LET l_bmj.bmj04 = g_pmh[l_ac].pmh04
        LET l_bmj.bmj05 = ''
        LET l_bmj.bmj06 = ''
        LET l_bmj.bmj07 = ''
        LET l_bmj.bmj08 = '0'
        LET l_bmj.bmj09 = ''
        LET l_bmj.bmj10 = ''
        LET l_bmj.bmj11 = ''
        LET l_bmj.bmj12 = ''
        LET l_bmj.bmj13 = ''
        LET l_bmj.bmj14 = ''
        LET l_bmj.bmj15 = ''
        LET l_bmj.bmjacti = 'Y'
        LET l_bmj.bmjuser = g_user
        LET l_bmj.bmjgrup = g_grup
        LET l_bmj.bmjdate = g_today
 
        LET l_bmj.bmjoriu = g_user      #No.FUN-980030 10/01/04
        LET l_bmj.bmjorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO bmj_file VALUES(l_bmj.*)
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3("ins","bmj_file","","",SQLCA.sqlcode,"","ins_bmj_err",1)  
           RETURN FALSE
        END IF
        RETURN TRUE
     ELSE
        RETURN TRUE
     END IF
END FUNCTION
 
FUNCTION i258_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
   CALL cl_set_comp_entry("pmh12,pmh19",TRUE)
END FUNCTION
 
FUNCTION i258_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
   IF g_gec07 = 'N' THEN
      CALL cl_set_comp_entry("pmh19",FALSE)
   ELSE
      CALL cl_set_comp_entry("pmh12",FALSE)
   END IF
END FUNCTION
#No:FUN-9C0071--------精簡程式-----

#FUN-9A0056 add begin -----------
FUNCTION i258_mes(p_key1,p_key2)
  DEFINE p_key1   varchar(6)
  DEFINE p_key2   LIKE type_file.chr500
  DEFINE l_mesg01 varchar(30)

  CASE p_key1
     WHEN 'insert'  #新增
          LET l_mesg01 = 'INSERT O.K, INSERT MES O.K'
     WHEN 'update'  #修改
          LET l_mesg01 = 'UPDATE O.K, UPDATE MES O.K'
     WHEN 'delete'  #刪除
          LET l_mesg01 = 'DELETE O.K, DELETE MES O.K'
     OTHERWISE
  END CASE

 #CALL aws_mescli
 #傳入參數: (1)程式代號
 #          (2)功能選項：insert(新增),update(修改),delete(刪除)
 #          (3)Key
  CASE aws_mescli('apmi258',p_key1,p_key2)
     WHEN 1  #呼叫 MES 成功
          MESSAGE l_mesg01
          LET g_success = 'Y'
     WHEN 2  #呼叫 MES 失敗
          LET g_success = 'N'
     OTHERWISE  #其他異常
          LET g_success = 'N'
  END CASE
END FUNCTION
#FUN-9A0056 add end--------------
#MOD-BC0309 add begin----------------------
FUNCTION i258_chk_pmh11()
DEFINE l_pmh11 LIKE pmh_file.pmh11

   LET g_errno = ''
   SELECT SUM(pmh11) INTO l_pmh11 FROM pmh_file
    WHERE pmh01 = g_pmh[l_ac].pmh01
      AND pmh22 = g_pmh22
      AND pmhacti = 'Y'
   IF cl_null(l_pmh11) THEN LET l_pmh11 = 0 END IF
   LET l_pmh11 = g_pmh[l_ac].pmh11 + l_pmh11
   IF NOT cl_null(g_pmh_t.pmh11) THEN
      LET l_pmh11 = l_pmh11 - g_pmh_t.pmh11
   END IF
   IF l_pmh11 > 100 THEN
      LET g_errno = 'apm-986'
   END IF
   RETURN l_pmh11
END FUNCTION
#MOD-BC0309 add end------------------------
