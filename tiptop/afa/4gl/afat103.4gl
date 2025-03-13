# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afat103.4gl
# Descriptions...: 資料外送資料維護作業
# Date & Author..: 96/05/27 By Sophia
# Modify ........: 99/04/28 By Kitty 增加insert fap_file
# Modify.........: No:7837 03/08/19 By Wiky 呼叫自動取單號時應在 Transction中
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.MOD-470515 04/07/30 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-490162 04/09/10 By Nicola 進入單身時，中文名稱及單位會不見
# Modify.........: No.MOD-490235 04/09/13 By Yuna 自動生成改成用confirm的方式
# Modify.........: No.MOD-490344 04/09/20 By Kitty controlp 少display補入
# Modify.........: No.MOD-4A0113 04/10/13 By Yuna 輸入員工代號, 請順便代出部門代號
#                                                 單身輸入時, 需代出外送數量=財產數量
# Modify.........: No.MOD-4A0248 04/10/25 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.MOD-530810 05/03/29 By Smapmin 無法過帳
# Modify.........: NO.FUN-550034 05/05/17 By jackie 單據編號加大
# Modify.........: No.MOD-570147 05/08/03 By Smapmin 數量不可小於0
# Modify.........: No.MOD-590470 05/10/21 By Sarah 判斷筆數之條件應排除已作廢之單據(找afa-309)
# Modify.........: No.FUN-580109 05/10/21 By Sarah 以EF為backend engine,由TIPTOP處理前端簽核動作
# Modify.........: No.FUN-5B0018 05/11/04 By Sarah 外送日期沒有判斷關帳日
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-620120 06/03/02 By Smapmin 當附號為NULL時,LET 附號為空白
# Modify.........: No.TQC-630073 06/03/07 By Mandy 流程訊息通知功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-640243 06/05/15 By Echo 自動執行確認功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.TQC-610055 06/06/27 By Smapmin 修改報表列印所傳遞的參數
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0001 06/10/11 By jamie FUNCTION t103()_q 一開始應清空g_fau.*值
# Modify.........: No.FUN-680064 06/10/18 By dxfwo 在新增函數_a()中的單身函數_b()前添加                                             
#                                                           g_rec_b初始化命令                                                       
#                                                          "LET g_rec_b =0" 
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time 
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.MOD-690117 06/12/14 By Mandy 過帳還原狀態調整
# Modify.........: No.FUN-710028 07/01/26 By cheunl錯誤訊息匯整
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740266 07/04/23 By Sarah 新增輸入單號沒有檢查單別是否存在單據性質檔中
# Modify.........: No.MOD-750017 07/05/04 By Smapmin 自動產生單身時,收回數量Default為0
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760102 07/06/22 By rainy 新增自動產生單身時，外送數量=0的不需產生
# Modify.........: No.TQC-760182 07/06/28 By chenl 自動產生QBE條件不可為空。
# Modify.........: No.MOD-780228 07/08/22 By jamie 輸入時【外送數量】應控管不可大於 (資產數量-外送數量)
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-840111 08/04/23 By lilingyu 預設申請人員登入帳號
# Modify.........: No.FUN-850068 08/05/14 By TSD.zeak 自訂欄位功能修改 
# Modify.........: No.MOD-890231 08/09/24 By Sarah 當l_fav04_n為null時給予值為0
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.FUN-980003 09/08/10 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9B0032 09/11/30 By Sarah 寫入fap_file時,也應寫入fap77=faj43
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A80137 10/08/19 By Dido 確認與取消確認;過帳與取消過帳應檢核關帳日
# Modify.........: No:TQC-AB0257 10/11/30 By suncx 新增fav03欄位的控管
# Modify.........: NO.MOD-B30050 11/03/08 BY Dido 計算外送數量需排除作廢資料 
# Modify.........: No.FUN-AB0088 11/04/02 By chenying 因固資拆出財二功能，原本寫入fap亦有新增欄位，增加對應處理
# Modify.........: No.TQC-B30156 11/05/12 By Dido 預設 fap56 為 0
# Modify.........: No.FUN-B50090 11/05/17 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50118 11/06/13 By belle 自動產生鍵, 增加QBE條件-族群編號
# Modify.........: No.FUN-B80054 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: NO:FUN-B80081 11/11/01 By Sakura faj105相關程式段Mark,停用(fav08)欄位及相關程式段移除
# Modify.........: NO:FUN-B90096 11/11/03 By Sakura 將UPDATE faj_file拆分出財一、財二
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20012 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No:FUN-C30017 12/03/07 By Mandy 送簽中,應不可執行"自動產生" ACTION
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C60010 12/06/14 By jinjj 財簽二欄位需依財簽二幣別做取位
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No.MOD-C70265 12/07/27 By Polly 資產不存在時,將 afa-093 改用訊息 afa-134
# Modify.........: No.MOD-C80139 12/08/21 By Polly INSERT INTO fav_file個數調整
# Modify.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料控制
# Modify.........: No.FUN-D10098 13/02/04 By lujh 大陸版本用gfag103
# Modify.........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fau    RECORD LIKE fau_file.*,
    g_fau_t  RECORD LIKE fau_file.*,
    g_fau_o  RECORD LIKE fau_file.*,
    g_fahprt        LIKE fah_file.fahprt,
    g_fahconf       LIKE fah_file.fahconf,
    g_fahpost       LIKE fah_file.fahpost,
    g_fahapr        LIKE fah_file.fahapr,             #FUN-640243
    g_fav           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    fav02     LIKE fav_file.fav02,
                    fav03     LIKE fav_file.fav03,
                    fav031     LIKE fav_file.fav031,
                    faj06     LIKE faj_file.faj06,
                    faj18     LIKE faj_file.faj18,
                    fav04     LIKE fav_file.fav04,
                    fav05     LIKE fav_file.fav05,
                    fav06     LIKE fav_file.fav06,
                    #fav08     LIKE fav_file.fav08, #No.FUN-B80081 mark
                    fav07     LIKE fav_file.fav07
                    #FUN-850068 --start---
                    ,favud01 LIKE fav_file.favud01,
                    favud02 LIKE fav_file.favud02,
                    favud03 LIKE fav_file.favud03,
                    favud04 LIKE fav_file.favud04,
                    favud05 LIKE fav_file.favud05,
                    favud06 LIKE fav_file.favud06,
                    favud07 LIKE fav_file.favud07,
                    favud08 LIKE fav_file.favud08,
                    favud09 LIKE fav_file.favud09,
                    favud10 LIKE fav_file.favud10,
                    favud11 LIKE fav_file.favud11,
                    favud12 LIKE fav_file.favud12,
                    favud13 LIKE fav_file.favud13,
                    favud14 LIKE fav_file.favud14,
                    favud15 LIKE fav_file.favud15
                    #FUN-850068 --end--
                    END RECORD,
    g_fav_t         RECORD
                    fav02     LIKE fav_file.fav02,
                    fav03     LIKE fav_file.fav03,
                    fav031     LIKE fav_file.fav031,
                    faj06     LIKE faj_file.faj06,
                    faj18     LIKE faj_file.faj18,
                    fav04     LIKE fav_file.fav04,
                    fav05     LIKE fav_file.fav05,
                    fav06     LIKE fav_file.fav06,
                    #fav08     LIKE fav_file.fav08, #No.FUN-B80081 mark
                    fav07     LIKE fav_file.fav07
                    #FUN-850068 --start---
                    ,favud01 LIKE fav_file.favud01,
                    favud02 LIKE fav_file.favud02,
                    favud03 LIKE fav_file.favud03,
                    favud04 LIKE fav_file.favud04,
                    favud05 LIKE fav_file.favud05,
                    favud06 LIKE fav_file.favud06,
                    favud07 LIKE fav_file.favud07,
                    favud08 LIKE fav_file.favud08,
                    favud09 LIKE fav_file.favud09,
                    favud10 LIKE fav_file.favud10,
                    favud11 LIKE fav_file.favud11,
                    favud12 LIKE fav_file.favud12,
                    favud13 LIKE fav_file.favud13,
                    favud14 LIKE fav_file.favud14,
                    favud15 LIKE fav_file.favud15
                    #FUN-850068 --end--
                    END RECORD,
    g_fah           RECORD LIKE fah_file.*,
    g_fau01_t       LIKE fau_file.fau01,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    l_modify_flag       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    l_flag              LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
#    g_t1                LIKE type_file.chr3,         #No.FUN-680070 VARCHAR(3)
    g_t1                LIKE type_file.chr5,       #No.FUN-550034       #No.FUN-680070 VARCHAR(5)
    g_buf               LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
    g_rec_b             LIKE type_file.num5,                #單身筆數       #No.FUN-680070 SMALLINT
    l_ac                LIKE type_file.num5                 #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
DEFINE g_argv1          LIKE fau_file.fau01    #外送單號   #FUN-580109
DEFINE g_argv2          STRING                 # 指定執行功能:query or inser  #TQC-630073
DEFINE g_laststage      LIKE type_file.chr1                              #FUN-580109       #No.FUN-680070 VARCHAR(1)
DEFINE g_forupd_sql     STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_chr            LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE g_chr2           LIKE type_file.chr1      #FUN-580109       #No.FUN-680070 VARCHAR(1)
DEFINE g_cnt            LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_i              LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE g_msg            LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE g_row_count      LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_curs_index     LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_jump           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE mi_no_ask        LIKE type_file.num5         #No.FUN-680070 SMALLINT
#CHI-C60010---str---
DEFINE g_azi04_1  LIKE azi_file.azi04,
       g_faj143   LIKE faj_file.faj143
#CHI-C60010---end---
 
MAIN
DEFINE
#    l_time          LIKE type_file.chr8,                 #計算被使用時間       #No.FUN-680070 VARCHAR(8) #NO.FUN-6A0069
    l_sql           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
DEFINE p_row,p_col  LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    #FUN-640243
    IF FGL_GETENV("FGLGUI") <> "0" THEN
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP
    END IF
    #END FUN-640243
 
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AFA")) THEN
       EXIT PROGRAM
    END IF
 
    IF INT_FLAG THEN EXIT PROGRAM END IF
    LET g_wc2 = ' 1=1'
 
    LET g_forupd_sql = " SELECT * FROM fau_file WHERE fau01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t103_cl CURSOR FROM g_forupd_sql
 
    CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
         RETURNING g_time                      #NO.FUN-6A0069
 
    LET g_argv1=ARG_VAL(1)  #TQC-630073
    LET g_argv2=ARG_VAL(2)  #TQC-630073
 
    #FUN-640243
    IF g_bgjob='N' OR cl_null(g_bgjob) THEN
       LET p_row = 3 LET p_col = 13
       OPEN WINDOW t103_w AT p_row,p_col              #顯示畫面
            WITH FORM "afa/42f/afat103"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
       CALL cl_ui_init()
    END IF
    #END FUN-640243
 
    #start FUN-580109
    IF fgl_getenv('EASYFLOW') = "1" THEN
       LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
    END IF
 
    #建立簽核模式時的 toolbar icon
    CALL aws_efapp_toolbar()
 
   #TQC-630073 mark
   #IF NOT cl_null(g_argv1) THEN
   #   CALL t103_q()
   #END IF
   #TQC-630073 add-----------------------
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t103_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t103_a()
            END IF
         #FUN-640243
         WHEN "efconfirm"
            CALL t103_q()
            CALL t103_y_chk()          #CALL 原確認的 check 段
            IF g_success = "Y" THEN
               LET l_ac = 1
               CALL t103_y_upd()       #CALL 原確認的 update 段
            END IF
            EXIT PROGRAM
         #END FUN-640243
         OTHERWISE
            CALL t103_q()
      END CASE
   END IF
   #TQC-630073(end)-----------------
 
    #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
    CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, confirm, undo_confirm,easyflow_approval, auto_generate, post, undo_post")
         RETURNING g_laststage
    #end FUN-580109
 
    CALL t103_menu()
    CLOSE WINDOW t103_w                    #結束畫面
    CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
         RETURNING g_time                          #NO.FUN-6A0069
END MAIN
 
FUNCTION t103_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM                             #清除畫面
   CALL g_fav.clear()
 
   #start FUN-580109
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " fau01 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"
   ELSE
   #end FUN-580109
      CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INITIALIZE g_fau.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        fau01,fau02,fau03,fau04,fau05,
        faumksg,fau06,   #FUN-580109
        fauconf,faupost,fauuser,faugrup,faumodu,faudate
        #FUN-850068   ---start---
        ,fauud01,fauud02,fauud03,fauud04,fauud05,
        fauud06,fauud07,fauud08,fauud09,fauud10,
        fauud11,fauud12,fauud13,fauud14,fauud15
        #FUN-850068    ----end----
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(fau01)    #查詢單據性質
                #LET g_t1=g_fau.fau01[1,3]
                #CALL q_fah( FALSE, TRUE,g_t1,'A',g_sys) RETURNING g_t1
                #LET g_fau.fau01[1,3]=g_t1
                #DISPLAY BY NAME g_fau.fau01
                 #--No.MOD-4A0248--------
                 CALL cl_init_qry_var()
                 LET g_qryparam.state= "c"
                 LET g_qryparam.form = "q_fau"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fau01
                #--END---------------
                 NEXT FIELD fau01
              WHEN INFIELD(fau03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fau03
                 NEXT FIELD fau03
              WHEN INFIELD(fau04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fau04
                 NEXT FIELD fau04
              OTHERWISE
                 EXIT CASE
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF
 
      #No:A099
      #CONSTRUCT g_wc2 ON fav02,fav03,fav031,faj06,faj18,fav04,fav05,fav06,fav08, #No.FUN-B80081 mark
       CONSTRUCT g_wc2 ON fav02,fav03,fav031,faj06,faj18,fav04,fav05,fav06, #No.FUN-B80081 add,移除fav08
                         fav07
                         #No.FUN-850068 --start--
                         ,favud01,favud02,favud03,favud04,favud05,
                         favud06,favud07,favud08,favud09,favud10,
                         favud11,favud12,favud13,favud14,favud15
                         #No.FUN-850068 ---end---
              FROM s_fav[1].fav02,s_fav[1].fav03,s_fav[1].fav031,s_fav[1].faj06,
                   s_fav[1].faj18,s_fav[1].fav04,s_fav[1].fav05, s_fav[1].fav06,
                   #s_fav[1].fav08,s_fav[1].fav07 #No.FUN-B80081 mark
                   s_fav[1].fav07 #No.FUN-B80081 add,移除fav08
                   #No.FUN-850068 --start--
                   ,s_fav[1].favud01,s_fav[1].favud02,s_fav[1].favud03,
                   s_fav[1].favud04,s_fav[1].favud05,s_fav[1].favud06,
                   s_fav[1].favud07,s_fav[1].favud08,s_fav[1].favud09,
                   s_fav[1].favud10,s_fav[1].favud11,s_fav[1].favud12,
                   s_fav[1].favud13,s_fav[1].favud14,s_fav[1].favud15
                   #No.FUN-850068 ---end---
      #end No:A099
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(fav03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fav03
                 NEXT FIELD fav03
           WHEN INFIELD(fav06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fag"
                 LET g_qryparam.state = "c"
                 LET g_qryparam.arg1 = "A"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fav06
                 NEXT FIELD fav06
              OTHERWISE
                 EXIT CASE
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   END IF   #FUN-580109
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN                           #只能使用自己的資料
   #       LET g_wc = g_wc clipped," AND fauuser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN                           #只能使用相同群的資料
   #       LET g_wc = g_wc clipped," AND faugrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #       LET g_wc = g_wc clipped," AND faugrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fauuser', 'faugrup')
   #End:FUN-980030
 
 
   IF g_wc2 = " 1=1" THEN		# 若單身未輸入條件
      LET g_sql = "SELECT fau01 FROM fau_file",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY 1"
   ELSE					# 若單身有輸入條件
      LET g_sql = "SELECT DISTINCT fau01 ",
                  "  FROM fau_file, fav_file",
                  " WHERE fau01 = fav01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY 1"
   END IF
 
   PREPARE t103_prepare FROM g_sql
   DECLARE t103_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t103_prepare
 
   IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
       LET g_sql="SELECT COUNT(*) FROM fau_file WHERE ",g_wc CLIPPED
   ELSE
       LET g_sql="SELECT COUNT(DISTINCT fau01) FROM fau_file,fav_file",
                 " WHERE fav01 = fau01 ",
                 "   AND ",g_wc CLIPPED,
                 "   AND ",g_wc2 CLIPPED
   END IF
   PREPARE t103_count_pre FROM g_sql
   DECLARE t103_count CURSOR FOR t103_count_pre
END FUNCTION
 
FUNCTION t103_menu()
   DEFINE l_creator    LIKE type_file.chr1           #「不准」時是否退回填表人 #FUN-580109       #No.FUN-680070 VARCHAR(1)
   DEFINe l_flowuser   LIKE type_file.chr1           # 是否有指定加簽人員      #FUN-580109       #No.FUN-680070 VARCHAR(1)
 
   LET l_flowuser = "N"   #FUN-580109
 
   WHILE TRUE
      CALL t103_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t103_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t103_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t103_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t103_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t103_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t103_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "auto_generate"
            IF cl_chk_act_auth() THEN
              #CALL t103_g() #FUN-C30017 mark
              #CALL t103_b() #FUN-C30017 mark
               #FUN-C30017 add---str---
               IF g_fau.fau06 NOT MATCHES '[Ss]' THEN 
                   CALL t103_g()
                   CALL t103_b()
               ELSE
                   CALL cl_err('','mfg3557',0) #本單據目前已送簽或已核准
               END IF 
               #FUN-C30017 add---end---
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t103_x()                   #FUN-D20035
               CALL t103_x(1)           #FUN-D20035
            END IF

         #FUN-D20035---add--str
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t103_x(2)
            END IF
         #FUN-D20035---add---end

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               #start FUN-580109
               #CALL t103_y()
               CALL t103_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t103_y_upd()       #CALL 原確認的 update 段
               END IF
               #end FUN-580109
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t103_z()
            END IF
         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t103_s()
            END IF
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t103_w()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fau.fau01 IS NOT NULL THEN
                  LET g_doc.column1 = "fau01"
                  LET g_doc.value1 = g_fau.fau01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fav),'','')
            END IF
#start FUN-580109
        #@WHEN "簽核狀況"
        WHEN "approval_status"
             IF cl_chk_act_auth() THEN  #DISPLAY ONLY
                IF aws_condition2() THEN
                   CALL aws_efstat2()
                END IF
             END IF
        ##EasyFlow送簽
        WHEN "easyflow_approval"
             IF cl_chk_act_auth() THEN
               #FUN-C20012 add str---
                SELECT * INTO g_fau.* FROM fau_file
                 WHERE fau01 = g_fau.fau01
                CALL t103_show()
                CALL t103_b_fill(' 1=1')
               #FUN-C20012 add end---
                CALL t103_ef()
                CALL t103_show()  #FUN-C20012 add
             END IF
        #@WHEN "准"
        WHEN "agree"
             IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
                CALL t103_y_upd()      #CALL 原確認的 update 段
             ELSE
                LET g_success = "Y"
                IF NOT aws_efapp_formapproval() THEN
                   LET g_success = "N"
                END IF
             END IF
             IF g_success = 'Y' THEN
                IF cl_confirm('aws-081') THEN
                   IF aws_efapp_getnextforminfo() THEN
                      LET l_flowuser = 'N'
                      LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                      IF NOT cl_null(g_argv1) THEN
                         CALL t103_q()
                         #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                         CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, confirm, undo_confirm,easyflow_approval, auto_generate, post, undo_post")
                              RETURNING g_laststage
                      ELSE
                         EXIT WHILE
                      END IF
                   ELSE
                      EXIT WHILE
                   END IF
                ELSE
                   EXIT WHILE
                END IF
             END IF
 
        #@WHEN "不准"
        WHEN "deny"
            IF ( l_creator := aws_efapp_backflow()) IS NOT NULL THEN
               IF aws_efapp_formapproval() THEN
                  IF l_creator = "Y" THEN
                     LET g_fau.fau06 = 'R'
                     DISPLAY BY NAME g_fau.fau06
                  END IF
                  IF cl_confirm('aws-081') THEN
                     IF aws_efapp_getnextforminfo() THEN
                        LET l_flowuser = 'N'
                        LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                        IF NOT cl_null(g_argv1) THEN
                           CALL t103_q()
                           #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                           CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, confirm, undo_confirm,easyflow_approval, auto_generate, post, undo_post")
                                RETURNING g_laststage
                        ELSE
                           EXIT WHILE
                        END IF
                     ELSE
                        EXIT WHILE
                     END IF
                  ELSE
                     EXIT WHILE
                  END IF
               END IF
             END IF
 
        #@WHEN "加簽"
        WHEN "modify_flow"
             IF aws_efapp_flowuser() THEN   #選擇欲加簽人員
                LET l_flowuser = 'Y'
             ELSE
                LET l_flowuser = 'N'
             END IF
 
        #@WHEN "撤簽"
        WHEN "withdraw"
             IF cl_confirm("aws-080") THEN
                IF aws_efapp_formapproval() THEN
                   EXIT WHILE
                END IF
             END IF
 
        #@WHEN "抽單"
        WHEN "org_withdraw"
             IF cl_confirm("aws-079") THEN
                IF aws_efapp_formapproval() THEN
                   EXIT WHILE
                END IF
             END IF
 
        #@WHEN "簽核意見"
        WHEN "phrase"
             CALL aws_efapp_phrase()
#end FUN-580109
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t103_a()
DEFINE li_result  LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_fav.clear()
    INITIALIZE g_fau.* TO NULL
    LET g_fau01_t = NULL
    LET g_fau_o.* = g_fau.*
    LET g_fau_t.* = g_fau.*
 
   #NO.FUN-840111  --Begin--
    LET g_fau.fau03 = g_user
    CALL t103_fau03('d')
   #NO.FUN-840111  --End--
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fau.fau02  =g_today
        LET g_fau.fau05  =g_today
        LET g_fau.fauconf='N'
        LET g_fau.faupost='N'
        LET g_fau.fauprsw=0
        LET g_fau.fauuser=g_user
        LET g_fau.fauoriu = g_user #FUN-980030
        LET g_fau.fauorig = g_grup #FUN-980030
        LET g_fau.faugrup=g_grup
        LET g_fau.faudate=g_today
        LET g_fau.faumksg = "N"   #FUN-580109
        LET g_fau.fau06 = "0"     #FUN-580109
        LET g_fau.faulegal= g_legal    #FUN-980003 add
 
        CALL t103_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0
           INITIALIZE g_fau.* TO NULL
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        IF g_fau.fau01 IS NULL THEN       #KEY不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK  #No:7837
#No.FUN-550034 --start--
        CALL s_auto_assign_no("afa",g_fau.fau01,g_fau.fau02,"A","fau_file","fau01","","","")
             RETURNING li_result,g_fau.fau01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_fau.fau01
#       IF g_fah.fahauno='Y' THEN
#   CALL s_afaauno(g_fau.fau01,g_fau.fau02)
#               RETURNING g_i,g_fau.fau01
#          IF g_i THEN CONTINUE WHILE END IF	#有問題
#   DISPLAY BY NAME g_fau.fau01 #
#       END IF
#No.FUN-550034 ---end--
        INSERT INTO fau_file VALUES (g_fau.*)
        IF SQLCA.SQLCODE THEN
           CALL cl_err3("ins","fau_file",g_fau.fau01,"",SQLCA.sqlcode,"","Ins:",1)  #No.FUN-660136 #No.FUN-B80054---調整至回滾事務前---
           ROLLBACK WORK  #No:7837
#          CALL cl_err('Ins:',SQLCA.SQLCODE,1)   #No.FUN-660136
           CONTINUE WHILE
        ELSE
           COMMIT WORK   #No:7837
           CALL cl_flow_notify(g_fau.fau01,'I')
        END IF
        COMMIT WORK
        CALL g_fav.clear()
        LET g_rec_b=0                       #NO.FUN-680064
        LET g_fau_t.* = g_fau.*
        LET g_fau01_t = g_fau.fau01
        SELECT fau01 INTO g_fau.fau01
          FROM fau_file
         WHERE fau01 = g_fau.fau01
 
        CALL t103_g()
        CALL t103_b()
        #---判斷是否直接列印,確認,過帳---------
#        LET g_t1 = g_fau.fau01[1,3]
        LET g_t1 = s_get_doc_no(g_fau.fau01) ##No.FUN-550034
        #FUN-640243
        SELECT fahprt,fahconf,fahpost,fahapr
             INTO g_fahprt,g_fahconf,g_fahpost,g_fahapr
          FROM fah_file
         WHERE fahslip = g_t1
        IF g_fahprt = 'Y' THEN
           IF NOT cl_confirm('afa-128') THEN RETURN END IF
           CALL t103_out()
        END IF
        IF g_fahconf = 'Y' AND g_fahapr <> 'Y' THEN
           LET g_action_choice = "insert"
        #END FUN-640243
 
           #start FUN-580109
           #CALL t103_y()
           CALL t103_y_chk()          #CALL 原確認的 check 段
           IF g_success = "Y" THEN
              CALL t103_y_upd()       #CALL 原確認的 update 段
           END IF
           #end FUN-580109
        END IF
        IF g_fahpost = 'Y' THEN
           CALL t103_s()
        END IF
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t103_u()
   IF s_shut(0) THEN RETURN END IF
 
    IF g_fau.fau01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_fau.* FROM fau_file WHERE fau01 = g_fau.fau01
    IF g_fau.fauconf = 'X' THEN
       CALL cl_err(' ','9024',0)
       RETURN
    END IF
    IF g_fau.fauconf = 'Y' THEN
       CALL cl_err(' ','afa-096',0)
       RETURN
    END IF
    IF g_fau.faupost = 'Y' THEN
       CALL cl_err(' ','afa-101',0)
       RETURN
    END IF
   #start FUN-580109
    IF g_fau.fau06 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
   #end FUN-580109
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fau01_t = g_fau.fau01
    LET g_fau_o.* = g_fau.*
    BEGIN WORK
 
    OPEN t103_cl USING g_fau.fau01
    IF STATUS THEN
       CALL cl_err("OPEN t103_cl:", STATUS, 1)
       CLOSE t103_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t103_cl INTO g_fau.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fau.fau01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t103_cl ROLLBACK WORK RETURN
    END IF
    CALL t103_show()
    WHILE TRUE
        LET g_fau01_t = g_fau.fau01
        LET g_fau.faumodu=g_user
        LET g_fau.faudate=g_today
        CALL t103_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fau.*=g_fau_t.*
            CALL t103_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        LET g_fau.fau06 = '0'   #FUN-580109
        IF g_fau.fau01 != g_fau_t.fau01 THEN
           UPDATE fav_file SET fav01=g_fau.fau01 WHERE fav01=g_fau_t.fau01
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#             CALL cl_err('upd fav01',SQLCA.SQLCODE,1)   #No.FUN-660136
              CALL cl_err3("upd","fav_file",g_fau_t.fau01,"",SQLCA.sqlcode,"","upd fav01",1)  #No.FUN-660136
              LET g_fau.*=g_fau_t.*
              CALL t103_show()
              CONTINUE WHILE
           END IF
        END IF
        UPDATE fau_file SET * = g_fau.*
         WHERE fau01 = g_fau.fau01
        IF SQLCA.SQLERRD[3] = 0 OR SQLCA.SQLCODE THEN
#          CALL cl_err(g_fau.fau01,SQLCA.SQLCODE,0)   #No.FUN-660136
           CALL cl_err3("upd","fau_file",g_fau01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
           CONTINUE WHILE
        END IF
       #start FUN-580109
        DISPLAY BY NAME g_fau.fau06
        IF g_fau.fauconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_fau.fau06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        CALL cl_set_field_pic(g_fau.fauconf,g_chr2,g_fau.faupost,"",g_chr,"")
       #end FUN-580109
        EXIT WHILE
    END WHILE
    CLOSE t103_cl
    COMMIT WORK
    CALL cl_flow_notify(g_fau.fau01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION t103_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
         l_flag          LIKE type_file.chr1,                #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
         l_bdate,l_edate LIKE type_file.dat,          #No.FUN-680070 DATE
         l_n1            LIKE type_file.num5         #No.FUN-680070 SMALLINT
  DEFINE li_result       LIKE type_file.num5         #No.FUN-680070 SMALLINT
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
    INPUT BY NAME g_fau.fauoriu,g_fau.fauorig,
        g_fau.fau01,g_fau.fau02,g_fau.fau03,g_fau.fau04,g_fau.fau05,
        g_fau.fauconf,g_fau.faupost,
        g_fau.faumksg,g_fau.fau06,   #FUN-580109
        g_fau.fauuser,g_fau.faugrup,g_fau.faumodu,g_fau.faudate
        #FUN-850068     ---start---
        ,g_fau.fauud01,g_fau.fauud02,g_fau.fauud03,g_fau.fauud04,
        g_fau.fauud05,g_fau.fauud06,g_fau.fauud07,g_fau.fauud08,
        g_fau.fauud09,g_fau.fauud10,g_fau.fauud11,g_fau.fauud12,
        g_fau.fauud13,g_fau.fauud14,g_fau.fauud15 
        #FUN-850068     ----end----
           WITHOUT DEFAULTS
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t103_set_entry(p_cmd)
          CALL t103_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
#No.FUN-550034 --start--
         CALL cl_set_docno_format("fau01")
#No.FUN-550034 ---end---
 
        AFTER FIELD fau01
         #IF NOT cl_null(g_fau.fau01) AND (g_fau.fau01!=g_fau01_t) THEN                         #MOD-740266 mark
          IF NOT cl_null(g_fau.fau01) AND (cl_null(g_fau01_t) OR g_fau.fau01!=g_fau01_t) THEN   #MOD-740266
#No.FUN-550034 --start--
             CALL s_check_no("afa",g_fau.fau01,g_fau01_t,"A","fau_file","fau01","")
                  RETURNING li_result,g_fau.fau01
             DISPLAY BY NAME g_fau.fau01
             IF (NOT li_result) THEN
                NEXT FIELD fau01
             END IF
 
#            LET g_t1=g_fau.fau01[1,3]
#            CALL s_afaslip(g_t1,'A',g_sys)	    #檢查外送單別
#            IF NOT cl_null(g_errno) THEN	    #抱歉, 有問題
#               CALL cl_err(g_t1,g_errno,0)
#                      LET g_fau.fau01 = g_fau_o.fau01
#                      NEXT FIELD fau01
#            END IF
             LET g_t1 = s_get_doc_no(g_fau.fau01)       #No.FUN-550034
             SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
#            IF p_cmd = 'a' THEN
#               IF g_fau.fau01[1,3] IS NOT NULL  AND
#                  cl_null(g_fau.fau01[g_no_sp,g_no_ep]) AND g_fah.fahauno = 'N' THEN
#                  NEXT FIELD fau01
#               ELSE
#                  NEXT FIELD fau02
#               END IF
#            END IF
#            IF g_fau.fau01 != g_fau_t.fau01 OR g_fau_t.fau01 IS NULL THEN
#               IF g_fah.fahauno = 'Y' AND NOT cl_chk_data_continue(g_fau.fau01[g_no_sp,g_no_ep]) THEN
#                  CALL cl_err('','9056',1)
#                  NEXT FIELD fau01
#               END IF
#               SELECT count(*) INTO g_cnt FROM fau_file
#                WHERE fau01 = g_fau.fau01
#               IF g_cnt > 0 THEN   #資料重複
#                  CALL cl_err(g_fau.fau01,-239,1)
#                  LET g_fau.fau01 = g_fau_t.fau01
#                  DISPLAY BY NAME g_fau.fau01 #
#                  NEXT FIELD fau01
#               END IF
#            END IF
          END IF
         #start FUN-580109 帶出單據別設定的"簽核否"值,狀況碼預設為0
          SELECT fahapr,'0' INTO g_fau.faumksg,g_fau.fau06
            FROM fah_file
           WHERE fahslip = g_t1
          IF cl_null(g_fau.faumksg) THEN            #FUN-640243
               LET g_fau.faumksg = 'N'
          END IF
          DISPLAY BY NAME g_fau.faumksg,g_fau.fau06
         #end FUN-580109
          LET g_fau_o.fau01 = g_fau.fau01
 
        AFTER FIELD fau02
            IF NOT cl_null(g_fau.fau02) THEN
               CALL s_azn01(g_faa.faa07,g_faa.faa08) RETURNING l_bdate,l_edate
               IF g_fau.fau02 < l_bdate
               THEN CALL cl_err(g_fau.fau02,'afa-130',0)
                    NEXT FIELD fau02
               END IF
            END IF
           #start FUN-5B0018
            IF NOT cl_null(g_fau.fau02) THEN
               IF g_fau.fau02 <= g_faa.faa09 THEN
                  CALL cl_err('','mfg9999',1)
                  NEXT FIELD fau02
               END IF
            END IF
           #end FUN-5B0018
 
        AFTER FIELD fau03
              IF NOT cl_null(g_fau.fau03) THEN
                 CALL t103_fau03('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fau.fau03,g_errno,0)
                    LET g_fau.fau03 = g_fau_t.fau03
                    DISPLAY BY NAME g_fau.fau03
                    NEXT FIELD fau03
                 END IF
              END IF
 
        AFTER FIELD fau04
              IF NOT cl_null(g_fau.fau04) THEN
                 CALL t103_fau04('a')
                 IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_fau.fau04,g_errno,0)
                     LET g_fau.fau04 = g_fau_t.fau04
                     DISPLAY BY NAME g_fau.fau04
                     NEXT FIELD fau04
                 END IF
              END IF
 
        #FUN-850068     ---start---
        AFTER FIELD fauud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fauud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fauud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fauud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fauud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fauud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fauud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fauud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fauud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fauud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fauud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fauud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fauud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fauud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fauud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-850068     ----end----
        AFTER INPUT  #97/05/22modify
           LET g_fau.fauuser = s_get_data_owner("fau_file") #FUN-C10039
           LET g_fau.faugrup = s_get_data_group("fau_file") #FUN-C10039
              IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp    #ok!
           CASE
              WHEN INFIELD(fau01)    #查詢單據性質
#                 LET g_t1=g_fau.fau01[1,3]
 
                   LET g_t1 = s_get_doc_no(g_fau.fau01) ##No.FUN-550034
                 #CALL q_fah( FALSE, TRUE,g_t1,'A',g_sys) RETURNING g_t1 #TQC-670008
                 CALL q_fah( FALSE, TRUE,g_t1,'A','AFA') RETURNING g_t1  #TQC-670008
#                 CALL FGL_DIALOG_SETBUFFER( g_t1 )
#                 LET g_fau.fau01[1,3]=g_t1
                 LET g_fau.fau01 =g_t1  #No.FUN-550034
                 DISPLAY BY NAME g_fau.fau01
                 NEXT FIELD fau01
              WHEN INFIELD(fau03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_fau.fau03
                 CALL cl_create_qry() RETURNING g_fau.fau03
#                 CALL FGL_DIALOG_SETBUFFER( g_fau.fau03 )
                 DISPLAY BY NAME g_fau.fau03
                 NEXT FIELD fau03
              WHEN INFIELD(fau04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fau.fau04
                 CALL cl_create_qry() RETURNING g_fau.fau04
#                 CALL FGL_DIALOG_SETBUFFER( g_fau.fau04 )
                 DISPLAY BY NAME g_fau.fau04
                 NEXT FIELD fau04
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #MOD-650015 --start 
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(fau01) THEN
       #         LET g_fau.* = g_fau_t.*
       #         LET g_fau.fau01 = ' '
       #         LET g_fau.fauconf = 'N'
       #         LET g_fau.faupost = 'N'
       #         CALL t103_show()
       #         NEXT FIELD fau01
       #     END IF
        #MOD-650015 --end
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end  
 
    END INPUT
END FUNCTION
FUNCTION t103_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fau01",TRUE)
    END IF
 
END FUNCTION
FUNCTION t103_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fau01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t103_fau03(p_cmd)
 DEFINE   p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_gen02    LIKE gen_file.gen02,
           l_gen03    LIKE gen_file.gen03,   #No.MOD-4A0113
          l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
     SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti  #No.MOD-4A0113
      FROM gen_file
     WHERE gen01 = g_fau.fau03
    CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno ='afa-034'
                                 LET l_gen02 = NULL
                                 LET l_genacti = NULL
        WHEN l_genacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd'
   THEN DISPLAY l_gen02 TO FORMONLY.gen02
   END IF
    #---No.MOD-4A0113----
    IF cl_null(g_errno) AND p_cmd = 'a' AND cl_null(g_fau.fau04) THEN
       LET g_fau.fau04=l_gen03
       DISPLAY BY NAME g_fau.fau04
    END IF
   #--END---------------
 
END FUNCTION
 
FUNCTION t103_fau04(p_cmd)
 DEFINE   p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_gem02    LIKE gem_file.gem02,
          l_gemacti  LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti INTO l_gem02,l_gemacti
      FROM gem_file
     WHERE gem01 = g_fau.fau04
    CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno ='afa-038'
                                 LET l_gem02 = NULL
                                 LET l_gemacti = NULL
        WHEN l_gemacti = 'N' LET g_errno = '9028'
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd'
   THEN DISPLAY l_gem02 TO FORMONLY.gem02
   END IF
END FUNCTION
 
FUNCTION t103_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fau.* TO NULL                   #No.FUN-6A0001
   #MESSAGE ""
    CALL cl_msg("")                              #FUN-640243
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t103_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_fau.* TO NULL
       RETURN
    END IF
   #MESSAGE " SEARCHING ! "
    CALL cl_msg(" SEARCHING ! ")                 #FUN-640243
    OPEN t103_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fau.* TO NULL
    ELSE
        OPEN t103_count
        FETCH t103_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t103_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
   #MESSAGE ""
    CALL cl_msg("")#FUN-640243
 
END FUNCTION
 
FUNCTION t103_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t103_cs INTO g_fau.fau01
        WHEN 'P' FETCH PREVIOUS t103_cs INTO g_fau.fau01
        WHEN 'F' FETCH FIRST    t103_cs INTO g_fau.fau01
        WHEN 'L' FETCH LAST     t103_cs INTO g_fau.fau01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                 PROMPT g_msg CLIPPED, ': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
##                      CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                 END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE  g_jump t103_cs INTO g_fau.fau01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fau.fau01,SQLCA.sqlcode,0)
        INITIALIZE g_fau.* TO NULL  #TQC-6B0105
        RETURN
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
    SELECT * INTO g_fau.* FROM fau_file WHERE fau01 = g_fau.fau01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fau.fau01,SQLCA.sqlcode,0)   #No.FUN-660136
        CALL cl_err3("sel","fau_file",g_fau.fau01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
        INITIALIZE g_fau.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_fau.fauuser   #FUN-4C0059
    LET g_data_group = g_fau.faugrup   #FUN-4C0059
    CALL t103_show()
END FUNCTION
 
FUNCTION t103_show()
    LET g_fau_t.* = g_fau.*                #保存單頭舊值
    DISPLAY BY NAME g_fau.fauoriu,g_fau.fauorig,
        g_fau.fau01,g_fau.fau02,g_fau.fau03,g_fau.fau04,g_fau.fau05,
        g_fau.fauconf,g_fau.faupost,
        g_fau.faumksg,g_fau.fau06,   #FUN-580109 增加簽核,狀況碼
        g_fau.fauuser,g_fau.faugrup,g_fau.faumodu,g_fau.faudate
        #FUN-850068     ---start---
        ,g_fau.fauud01,g_fau.fauud02,g_fau.fauud03,g_fau.fauud04,
        g_fau.fauud05,g_fau.fauud06,g_fau.fauud07,g_fau.fauud08,
        g_fau.fauud09,g_fau.fauud10,g_fau.fauud11,g_fau.fauud12,
        g_fau.fauud13,g_fau.fauud14,g_fau.fauud15 
        #FUN-850068     ----end----
    IF g_fau.fauconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   #start FUN-580109
    IF g_fau.fau06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   #CALL cl_set_field_pic(g_fau.fauconf,"",g_fau.faupost,"",g_chr,"")
    CALL cl_set_field_pic(g_fau.fauconf,g_chr2,g_fau.faupost,"",g_chr,"")
   #end FUN-580109
    CALL t103_fau03('d')
    CALL t103_fau04('d')
    CALL t103_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t103_r()
 DEFINE l_chr,l_sure LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fau.fau01 IS NULL THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    SELECT * INTO g_fau.* FROM fau_file WHERE fau01 = g_fau.fau01
    IF g_fau.fauconf = 'X' THEN
       CALL cl_err(' ','9024',0)
       RETURN
    END IF
    IF g_fau.fauconf = 'Y' THEN
       CALL cl_err('','afa-096',0) RETURN
    END IF
    IF g_fau.faupost = 'Y' THEN
       CALL cl_err(' ','afa-101',0) RETURN
    END IF
   #start FUN-580109
    IF g_fau.fau06 matches '[Ss1]' THEN
       CALL cl_err('','mfg3557',0)
       RETURN
    END IF
   #end FUN-580109
 
    BEGIN WORK
 
    OPEN t103_cl USING g_fau.fau01
    IF STATUS THEN
       CALL cl_err("OPEN t103_cl:", STATUS, 1)
       CLOSE t103_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t103_cl INTO g_fau.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_fau.fau01,SQLCA.sqlcode,0)
       CLOSE t103_cl ROLLBACK WORK  RETURN
    END IF
    CALL t103_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fau01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fau.fau01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete fau,fav!"
        DELETE FROM fau_file WHERE fau01 = g_fau.fau01
        IF SQLCA.SQLERRD[3]=0 THEN
            #CALL cl_err('No fau deleted','',0)   #No.+045 010403 by plum 
#          CALL cl_err('No fau deleted',SQLCA.SQLCODE,0)   #No.FUN-660136
           CALL cl_err3("del","fau_file",g_fau.fau01,"",SQLCA.sqlcode,"","No fau deleted",1)  #No.FUN-660136
        ELSE
           DELETE FROM fav_file WHERE fav01 = g_fau.fau01
           CLEAR FORM
           CALL g_fav.clear()
           CALL g_fav.clear()
           INITIALIZE g_fau.* LIKE fau_file.*
           OPEN t103_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE t103_cs
             CLOSE t103_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
           FETCH t103_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE t103_cs
             CLOSE t103_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN t103_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL t103_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL t103_fetch('/')
           END IF
 
        END IF
    END IF
    CLOSE t103_cl
    COMMIT WORK
    CALL cl_flow_notify(g_fau.fau01,'D')
END FUNCTION
 
FUNCTION t103_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
       l_row,l_col     LIKE type_file.num5,  	      #分段輸入之行,列數       #No.FUN-680070 SMALLINT
       l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
       l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
       l_b2            LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
       l_faj06         LIKE faj_file.faj06,
       l_faj18         LIKE faj_file.faj18,
       l_qty	       LIKE type_file.num20_6,      #No.FUN-680070 DECIMAL(15,3)
       l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
       l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
DEFINE l_fau06         LIKE fau_file.fau06    #FUN-580109
DEFINE l_fav04_n       LIKE fav_file.fav04    #MOD-780228 add
 
    LET g_action_choice = ""
    LET l_fau06 = g_fau.fau06   #FUN-580109
    IF g_fau.fau01 IS NULL THEN RETURN END IF
    IF g_fau.fauconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
    IF g_fau.fauconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_fau.faupost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
   #start FUN-580109
    IF g_fau.fau06 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
   #end FUN-580109
 
    CALL cl_opmsg('b')
    #No:A099
    LET g_forupd_sql = " SELECT fav02,fav03,fav031,'','',fav04,fav05,fav06,",
                       #"        fav08,fav07 ",     #end No:A099 #No.FUN-B80081 mark
                        "        fav07 ",     #end No:A099 #No.FUN-B80081 add,移除fav08
                       " FROM fav_file ",
                       " WHERE fav01 = ? ",
                       " AND fav02 = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t103_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
 
   IF g_rec_b=0 THEN CALL g_fav.clear() END IF
 
 
      INPUT ARRAY g_fav WITHOUT DEFAULTS FROM s_fav.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            DISPLAY l_ac TO FORMONLY.cn3
           #LET g_fav_t.* = g_fav[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
	    BEGIN WORK
 
            OPEN t103_cl USING g_fau.fau01
            IF STATUS THEN
               CALL cl_err("OPEN t103_cl:", STATUS, 1)
               CLOSE t103_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t103_cl INTO g_fau.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fau.fau01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t103_cl ROLLBACK WORK RETURN
            END IF
 
           #IF g_fav[l_ac].fav02 IS NOT NULL THEN
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_fav_t.* = g_fav[l_ac].*  #BACKUP
                LET l_flag='Y'
 
                OPEN t103_bcl USING g_fau.fau01,g_fav_t.fav02
                IF STATUS THEN
                   CALL cl_err("OPEN t103_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t103_bcl INTO g_fav[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('lock fav',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                    ELSE     #No.MOD-490162
                      SELECT faj06,faj18 INTO g_fav[l_ac].faj06,g_fav[l_ac].faj18
                        FROM faj_file
                       WHERE faj02=g_fav[l_ac].fav03
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
           #ELSE
           #    LET l_flag='N'
            END IF
           #LET g_fav_t.* = g_fav[l_ac].*  #BACKUP
           #NEXT FIELD fav02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
             #No.MOD-470572
            IF ((g_fav[l_ac].fav03 != g_fav_t.fav03
                  OR g_fav_t.fav03 IS NULL)                #No.MOD-490096
              OR (g_fav[l_ac].fav031 != g_fav_t.fav031)
                  OR g_fav_t.fav031 IS NULL) THEN          #No.MOD-490096
              SELECT count(*) INTO l_n FROM fav_file
               WHERE fav01  = g_fau.fau01
                 AND fav03  = g_fav[l_ac].fav03
                 AND fav031 = g_fav[l_ac].fav031
             IF l_n > 0 THEN
                CALL cl_err('','afa-105',1)
                NEXT FIELD fav02
                CANCEL INSERT
             END IF
            END IF
             #No.MOD-470572 (end)
            IF cl_null(g_fav[l_ac].fav04) THEN
               LET g_fav[l_ac].fav04 = 0
            END IF
            IF cl_null(g_fav[l_ac].fav07) THEN
               LET g_fav[l_ac].fav07 = 0
            END IF
            #No:A099
            #-----TQC-620120---------
            IF cl_null(g_fav[l_ac].fav031) THEN
               LET g_fav[l_ac].fav031 = ' '
            END IF
            #-----END TQC-620120-----
            INSERT INTO fav_file(fav01,fav02,fav03,fav031,fav04,fav05,
                                 #fav06,fav07,fav08, #No.FUN-B80081 mark
                                  fav06,fav07, #No.FUN-B80081 add,移除fav08
                                #FUN-850068 --start--
                                 favud01,favud02,favud03,favud04,favud05,
                                 favud06,favud07,favud08,favud09,favud10,
                                 favud11,favud12,favud13,favud14,favud15,
                                #FUN-850068 --end--
                                 favlegal #FUN-980003 add
                                )
                          VALUES(g_fau.fau01,g_fav[l_ac].fav02,
                                 g_fav[l_ac].fav03,g_fav[l_ac].fav031,
                                 g_fav[l_ac].fav04,g_fav[l_ac].fav05,
                                 g_fav[l_ac].fav06,g_fav[l_ac].fav07,
                                 #g_fav[l_ac].fav08, #No.FUN-B80081 add,移除fav08
                                #FUN-850068 --start--
                                 g_fav[l_ac].favud01,g_fav[l_ac].favud02,
                                 g_fav[l_ac].favud03,g_fav[l_ac].favud04,
                                 g_fav[l_ac].favud05,g_fav[l_ac].favud06,
                                 g_fav[l_ac].favud07,g_fav[l_ac].favud08,
                                 g_fav[l_ac].favud09,g_fav[l_ac].favud10,
                                 g_fav[l_ac].favud11,g_fav[l_ac].favud12,
                                 g_fav[l_ac].favud13,g_fav[l_ac].favud14,
                                 g_fav[l_ac].favud15,
                                #FUN-850068 --end--
                                 g_legal #FUN-980003 add
                                )
            #end No:A099
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0  THEN
#              CALL cl_err('ins fav',SQLCA.sqlcode,0)   #No.FUN-660136
               CALL cl_err3("ins","fav_file",g_fau.fau01,g_fav[l_ac].fav02,SQLCA.sqlcode,"","ins fav",1)  #No.FUN-660136
              #LET g_fav[l_ac].* = g_fav_t.*
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET l_fau06 = '0'   #FUN-580109
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd = 'a'
            INITIALIZE g_fav[l_ac].* TO NULL      #900423
            LET g_fav[l_ac].fav04=0               #Genero add
            #LET g_fav[l_ac].fav08='N'             #No:A099 #No.FUN-B80081 mark
            #Gener modi
            SELECT faj06,faj18 INTO g_fav[l_ac].faj06,g_fav[l_ac].faj18
              FROM faj_file
             WHERE faj02=g_fav[l_ac].fav03
            #end
            LET g_fav_t.* = g_fav[l_ac].*             #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fav02                  #跳下一ROW
 
        BEFORE FIELD fav02                            #default 序號
            IF p_cmd = 'a' OR p_cmd = 'u' THEN
               IF g_fav[l_ac].fav02 IS NULL OR g_fav[l_ac].fav02 = 0 THEN
                   SELECT max(fav02)+1 INTO g_fav[l_ac].fav02
                      FROM fav_file WHERE fav01 = g_fau.fau01
                   IF g_fav[l_ac].fav02 IS NULL THEN
                       LET g_fav[l_ac].fav02 = 1
                   END IF
               END IF
            END IF
 
        AFTER FIELD fav02                        #check 序號是否重複
            IF cl_null(g_fav[l_ac].fav02) THEN NEXT FIELD fav02 END IF
            IF g_fav[l_ac].fav02 != g_fav_t.fav02 OR
               g_fav_t.fav02 IS NULL THEN
                SELECT count(*) INTO l_n FROM fav_file
                 WHERE fav01 = g_fau.fau01
                   AND fav02 = g_fav[l_ac].fav02
                IF l_n > 0 THEN
                    LET g_fav[l_ac].fav02 = g_fav_t.fav02
                    CALL cl_err('',-239,0)
                    NEXT FIELD fav02
                END IF
            END IF

        #TQC-AB0257 modify ---begin----------------------------
        AFTER FIELD fav03
            IF g_fav[l_ac].fav03 != g_fav_t.fav03 OR
               g_fav_t.fav03 IS NULL THEN
                LET l_n = 0
                SELECT COUNT(*) INTO l_n FROM faj_file
                 WHERE fajconf='Y'
                   AND faj02 = g_fav[l_ac].fav03
                IF l_n = 0 THEN
                    LET g_fav[l_ac].fav03 = g_fav_t.fav03
                    CALL cl_err('','afa-911',0)
                    NEXT FIELD fav03
                END IF
            END IF
        #TQC-AB0257 modify ----end-----------------------------
 
        AFTER FIELD fav031
           IF g_fav[l_ac].fav031 IS NULL THEN
              LET g_fav[l_ac].fav031 = ' '
           END IF
            #No.MOD-470572
           IF ((g_fav[l_ac].fav03 != g_fav_t.fav03
                 OR g_fav_t.fav03 IS NULL)               #No.MOD-490096
             OR (g_fav[l_ac].fav031 != g_fav_t.fav031)
                 OR g_fav_t.fav031 IS NULL) THEN         #No.MOD-490096
             SELECT count(*) INTO l_n FROM fav_file
              WHERE fav01  = g_fau.fau01
                AND fav03  = g_fav[l_ac].fav03
                AND fav031 = g_fav[l_ac].fav031
            IF l_n > 0 THEN
               CALL cl_err('','afa-105',1)
               NEXT FIELD fav03
            END IF
           END IF
            #No.MOD-470572 (end)
           SELECT COUNT(*) INTO g_cnt FROM fca_file
            WHERE fca03  = g_fav[l_ac].fav03
              AND fca031 = g_fav[l_ac].fav031
              AND fca15  = 'N'
            IF g_cnt > 0 THEN
               CALL cl_err(g_fav[l_ac].fav03,'afa-097',1)
               NEXT FIELD fav03
            END IF
            CALL t103_fav031(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_fav[l_ac].fav031,g_errno,1)
               NEXT FIELD fav03
            END IF
            LET g_fav_t.fav03  = g_fav[l_ac].fav03
            LET g_fav_t.fav031 = g_fav[l_ac].fav031
 
        AFTER FIELD fav04
           IF NOT cl_null(g_fav[l_ac].fav04) THEN
              SELECT faj17-faj58-faj171 INTO g_cnt FROM faj_file
               WHERE faj02  = g_fav[l_ac].fav03
                 AND faj022 = g_fav[l_ac].fav031
 
             #MOD-780228---add---str---
              SELECT SUM(fav04) INTO l_fav04_n FROM fav_file,fau_file
               WHERE fav01 = fau01
                 AND fau01 <> g_fau.fau01 
                 AND fav03 = g_fav[l_ac].fav03
                 AND fav031= g_fav[l_ac].fav031
                 AND faupost='N'
                 AND fauconf <> 'X'     #MOD-B30050
              IF cl_null(l_fav04_n) THEN LET l_fav04_n=0 END IF 
              LET g_cnt=g_cnt-l_fav04_n
             #MOD-780228---add---end---
 
              IF STATUS THEN
#                CALL cl_err(g_cnt,STATUS,0)   #No.FUN-660136
                 CALL cl_err3("sel","faj_file",g_fav[l_ac].fav03,g_fav[l_ac].fav031,STATUS,"","",1)  #No.FUN-660136
              ELSE
                 IF g_fav[l_ac].fav04 > g_cnt THEN
                    CALL cl_err(g_fav[l_ac].fav04,'afa-098',0)  
                    NEXT FIELD fav04
                 END IF
              END IF
 #MOD-570147
              IF NOT g_fav[l_ac].fav04 > 0 THEN
                 CALL cl_err('','afa-043',0)
                 NEXT FIELD fav04
              END IF
           ELSE
              CALL cl_err('','afa-043',0)
              NEXT FIELD fav04
 #END MOD-570147
           END IF
 
        AFTER FIELD fav06
           IF NOT cl_null(g_fav[l_ac].fav06) THEN
              CALL t103_fav06('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fav[l_ac].fav06,g_errno,0)
                  NEXT FIELD fav06
               END IF
           END IF
 
        #No.FUN-850068 --start--
        AFTER FIELD favud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD favud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD favud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD favud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD favud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD favud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD favud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD favud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD favud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD favud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD favud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD favud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD favud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD favud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD favud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-850068 ---end---
        BEFORE DELETE                            #是否取消單身
            IF g_fav_t.fav02 > 0 AND g_fav_t.fav02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM fav_file
                 WHERE fav01 = g_fau.fau01
                   AND fav02 = g_fav_t.fav02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_fav_t.fav02,SQLCA.sqlcode,0)   #No.FUN-660136
                    CALL cl_err3("del","fav_file",g_fau.fau01,g_fav_t.fav02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET l_fau06 = '0'   #FUN-580109
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fav[l_ac].* = g_fav_t.*
               CLOSE t103_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fav[l_ac].fav02,-263,1)
               LET g_fav[l_ac].* = g_fav_t.*
            ELSE
                #No.MOD-470572
               IF ((g_fav[l_ac].fav03 != g_fav_t.fav03
                     OR g_fav_t.fav03 IS NULL)             #No.MOD-490096
                 OR (g_fav[l_ac].fav031 != g_fav_t.fav031)
                     OR g_fav_t.fav031 IS NULL) THEN       #No.MOD-490096
                 SELECT count(*) INTO l_n FROM fav_file
                  WHERE fav01  = g_fau.fau01
                    AND fav03  = g_fav[l_ac].fav03
                    AND fav031 = g_fav[l_ac].fav031
                IF l_n > 0 THEN
                   CALL cl_err('','afa-105',1)
                   NEXT FIELD fav02
                END IF
               END IF
                #No.MOD-470572 (end)
               IF cl_null(g_fav[l_ac].fav04) THEN
                  LET g_fav[l_ac].fav04=0
               END IF
               IF cl_null(g_fav[l_ac].fav07) THEN
                  LET g_fav[l_ac].fav07=0
               END IF
               UPDATE fav_file SET
                      fav01=g_fau.fau01,fav02=g_fav[l_ac].fav02,
                      fav03=g_fav[l_ac].fav03,fav031=g_fav[l_ac].fav031,
                      fav04=g_fav[l_ac].fav04,fav05=g_fav[l_ac].fav05,
                      fav06=g_fav[l_ac].fav06,fav07=g_fav[l_ac].fav07,
                      #fav08=g_fav[l_ac].fav08          #No:A099 #No.FUN-B80081 mark
                      #No.FUN-850068 --start--
                      favud01 = g_fav[l_ac].favud01,
                      favud02 = g_fav[l_ac].favud02,
                      favud03 = g_fav[l_ac].favud03,
                      favud04 = g_fav[l_ac].favud04,
                      favud05 = g_fav[l_ac].favud05,
                      favud06 = g_fav[l_ac].favud06,
                      favud07 = g_fav[l_ac].favud07,
                      favud08 = g_fav[l_ac].favud08,
                      favud09 = g_fav[l_ac].favud09,
                      favud10 = g_fav[l_ac].favud10,
                      favud11 = g_fav[l_ac].favud11,
                      favud12 = g_fav[l_ac].favud12,
                      favud13 = g_fav[l_ac].favud13,
                      favud14 = g_fav[l_ac].favud14,
                      favud15 = g_fav[l_ac].favud15
                      #No.FUN-850068 ---end---
               WHERE fav01=g_fau.fau01 AND fav02=g_fav_t.fav02
 
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#                 CALL cl_err('upd fav',SQLCA.sqlcode,0)   #No.FUN-660136
                  CALL cl_err3("upd","fav_file",g_fau.fau01,g_fav_t.fav02,SQLCA.sqlcode,"","upd fav",1)  #No.FUN-660136
                  LET g_fav[l_ac].* = g_fav_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  LET l_fau06 = '0'   #FUN-580109
                  COMMIT WORK
               END IF
               LET g_fav_t.* = g_fav[l_ac].*
            END IF
 
        AFTER ROW
             LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac   #FUN-D30032 mark
             IF INT_FLAG THEN                 #900423
                CALL cl_err('',9001,0)
                LET INT_FLAG = 0
                IF p_cmd='u' THEN
                   LET g_fav[l_ac].* = g_fav_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_fav.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
                END IF
                CLOSE t103_bcl
                ROLLBACK WORK
                EXIT INPUT
             END IF
             LET l_ac_t = l_ac   #FUN-D30032 add
            #LET g_fav_t.* = g_fav[l_ac].*  #FUN-D30032 mark
             CLOSE t103_bcl
             COMMIT WORK
            #CALL g_fav.deleteElement(g_rec_b+1) #FUN-D30032 mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fav02) AND l_ac > 1 THEN
                LET g_fav[l_ac].* = g_fav[l_ac-1].*
                LET g_fav[l_ac].fav02 = NULL
                NEXT FIELD fav02
            END IF
 
        ON ACTION controlp  #ok!
           CASE
              WHEN INFIELD(fav03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj"
                 LET g_qryparam.default1 = g_fav[l_ac].fav03
                 LET g_qryparam.default2 = g_fav[l_ac].fav031
                 CALL cl_create_qry() RETURNING g_fav[l_ac].fav03,g_fav[l_ac].fav031
                 DISPLAY g_fav[l_ac].fav03 TO fav03
                 DISPLAY g_fav[l_ac].fav031 TO fav031
                 IF cl_null(g_fav[l_ac].fav031) THEN LET g_fav[l_ac].fav031=' ' END IF
                 CALL t103_fav031(p_cmd)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(' ',g_errno,0)
                    NEXT FIELD fav03
                 END IF
                 NEXT FIELD fav03
           WHEN INFIELD(fav06)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fag"
                 LET g_qryparam.arg1 = "A"
                 LET g_qryparam.default1 = g_fav[l_ac].fav06
                 CALL cl_create_qry() RETURNING g_fav[l_ac].fav06
                  DISPLAY g_fav[l_ac].fav06 TO fav06               #No.MOD-490344
                 NEXT FIELD fav06
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
      END INPUT
 
     #start FUN-5A0029
      LET g_fau.faumodu = g_user
      LET g_fau.faudate = g_today
      UPDATE fau_file SET faumodu = g_fau.faumodu,faudate = g_fau.faudate
       WHERE fau01 = g_fau.fau01
      DISPLAY BY NAME g_fau.faumodu,g_fau.faudate
     #end FUN-5A0029
 
     #start FUN-580109
      UPDATE fau_file SET fau06=l_fau06 WHERE fau01 = g_fau.fau01
      LET g_fau.fau06 = l_fau06
      DISPLAY BY NAME g_fau.fau06
      IF g_fau.fauconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
      IF g_fau.fau06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
      CALL cl_set_field_pic(g_fau.fauconf,g_chr2,g_fau.faupost,"",g_chr,"")
     #end FUN-580109
 
      CLOSE t103_bcl
      COMMIT WORK
      CALL t103_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t103_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_fau.fau01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM fau_file ",
                  "  WHERE fau01 LIKE '",l_slip,"%' ",
                  "    AND fau01 > '",g_fau.fau01,"'"
      PREPARE t103_pb1 FROM l_sql 
      EXECUTE t103_pb1 INTO l_cnt 
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
        #CALL t103_x()         #FUN-D20035
         CALL t103_x(1)         #FUN-D20035
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM fau_file WHERE fau01 = g_fau.fau01
         INITIALIZE g_fau.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t103_fav031(p_cmd)
DEFINE   p_cmd       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_n         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
         l_faj06     LIKE faj_file.faj06,
         l_faj18     LIKE faj_file.faj18,
         l_fav04     LIKE fav_file.fav04,
         l_faj43     LIKE faj_file.faj43,
         l_fajconf   LIKE faj_file.fajconf
DEFINE   l_fav04_n   LIKE fav_file.fav04          #MOD-780228 add
 
      LET g_errno = ''
      SELECT faj06,faj18,faj17-faj58-faj171,faj43,fajconf
        INTO l_faj06,l_faj18,l_fav04,l_faj43,l_fajconf
        FROM faj_file
       WHERE faj02  = g_fav[l_ac].fav03
         AND (faj022 = g_fav[l_ac].fav031 or faj022 is null)
        #AND faj43 NOT MATCHES '[056X]'
        #AND fajconf = 'Y'
     #MOD-780228---add---str---
      SELECT SUM(fav04) INTO l_fav04_n FROM fav_file,fau_file 
       WHERE fav01 = fau01
         AND fau01 <> g_fau.fau01
         AND fav03 = g_fav[l_ac].fav03
         AND fav031= g_fav[l_ac].fav031 
         AND faupost='N'
         AND fauconf <> 'X'      #MOD-B30050
      IF cl_null(l_fav04_n) THEN LET l_fav04_n=0 END IF
      LET l_fav04=l_fav04-l_fav04_n
     #MOD-780228---add---end---
 
     CASE
        #WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-093'    #MOD-C70265 mark
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-134'    #MOD-C70265 add
                                  LET l_faj06 = ''
                                  LET l_faj18 = ''
                                  LET l_faj43 = 0
          WHEN l_faj43 MATCHES '[056X]' LET g_errno = 'afa-313' #No.MOD-470572
          WHEN l_fajconf = 'N'          LET g_errno = 'afa-312' #No.MOD-470572
         OTHERWISE  LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     LET g_fav[l_ac].faj06 = l_faj06
     LET g_fav[l_ac].faj18 = l_faj18
     DISPLAY p_cmd
     DISPLAY g_errno
      IF cl_null(g_errno) OR p_cmd = 'a' THEN   #No.MOD-4A0113
        LET g_fav[l_ac].fav04 = l_fav04
     END IF
     IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY g_fav[l_ac].faj06 TO faj06
        DISPLAY g_fav[l_ac].faj18 TO faj18
        DISPLAY g_fav[l_ac].fav04 TO fav04
     END IF
END FUNCTION
 
FUNCTION t103_fav06(p_cmd)
DEFINE   p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         l_fag01    LIKE fag_file.fag01,
         l_fagacti  LIKE fag_file.fagacti
 
   LET g_errno = ' '
   SELECT fag01,fagacti INTO l_fag01,l_fagacti
     FROM fag_file
    WHERE fag01 = g_fav[l_ac].fav06
      AND fag02 = 'A'
   CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-099'
                                LET l_fag01 = NULL
                                LET l_fagacti = NULL
       WHEN l_fagacti = 'N' LET g_errno = '9028'
       OTHERWISE   LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION t103_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    #No:A099
    #CONSTRUCT l_wc2 ON fav02,fav03,fav031,fav04,fav05,fav06,fav08, #No.FUN-B80081 mark 
    CONSTRUCT l_wc2 ON fav02,fav03,fav031,fav04,fav05,fav06, #No.FUN-B80081 add,移除fav08
                       fav07,faj06,faj18
         FROM s_fav[1].fav02, s_fav[1].fav03,s_fav[1].fav031,s_fav[1].fav04,
              #s_fav[1].fav05,s_fav[1].fav06,s_fav[1].fav08,s_fav[1].fav07, #No.FUN-B80081 mark
              s_fav[1].fav05,s_fav[1].fav06,s_fav[1].fav07, #No.FUN-B80081 add,移除fav08
              s_fav[1].faj06,s_fav[1].faj18
    #end No:A099
 
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
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
    END IF
    CALL t103_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t103_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    #No:A099
    LET g_sql =
        "SELECT fav02,fav03,fav031,faj06,faj18,fav04,fav05,fav06,",
        #"       fav08,fav07",      #end No:A099 #No.FUN-B80081 mark
        "        fav07",      #end No:A099 #No.FUN-B80081 add,移除fav08
        #No.FUN-850068 --start--
        "       ,favud01,favud02,favud03,favud04,favud05,",
        "       favud06,favud07,favud08,favud09,favud10,",
        "       favud11,favud12,favud13,favud14,favud15", 
        #No.FUN-850068 ---end---
        "  FROM fav_file LEFT OUTER JOIN faj_file ON fav03 = faj02 AND fav031 = faj022 ",
        " WHERE fav01  ='",g_fau.fau01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE t103_pb FROM g_sql
    DECLARE fav_curs                       #SCROLL CURSOR
        CURSOR FOR t103_pb
    CALL g_fav.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fav_curs INTO g_fav[g_cnt].*   #單身 ARRAY 填充
        LET g_rec_b = g_rec_b+1
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_fav.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t103_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_fav TO s_fav.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
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
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t103_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t103_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t103_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t103_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t103_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
 
         CALL cl_set_field_pic("","","","","","")
         IF g_fau.fauconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        #start FUN-580109
         IF g_fau.fau06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        #CALL cl_set_field_pic(g_fau.fauconf,"",g_fau.faupost,"",g_chr,"")
         CALL cl_set_field_pic(g_fau.fauconf,g_chr2,g_fau.faupost,"",g_chr,"")
        #end FUN-580109
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 自動產生
      ON ACTION auto_generate
         LET g_action_choice="auto_generate"
         EXIT DISPLAY
      #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #FUN-D20035---add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20035---add--end

      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #@ON ACTION 過帳
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY
      #@ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
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
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
#start FUN-580109
     ON ACTION easyflow_approval
        LET g_action_choice = 'easyflow_approval'
        EXIT DISPLAY
 
     ON ACTION approval_status
        LET g_action_choice="approval_status"
        EXIT DISPLAY
 
     ON ACTION agree
        LET g_action_choice = 'agree'
        EXIT DISPLAY
 
     ON ACTION deny
        LET g_action_choice = 'deny'
        EXIT DISPLAY
 
     ON ACTION modify_flow
        LET g_action_choice = 'modify_flow'
        EXIT DISPLAY
 
     ON ACTION withdraw
        LET g_action_choice = 'withdraw'
        EXIT DISPLAY
 
     ON ACTION org_withdraw
        LET g_action_choice = 'org_withdraw'
        EXIT DISPLAY
 
     ON ACTION phrase
        LET g_action_choice = 'phrase'
        EXIT DISPLAY
#end FUN-580109
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
 
      #FUN-810046
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t103_out()
   DEFINE l_cmd        LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(200)
          l_wc,l_wc2    LIKE type_file.chr50,        #No.FUN-680070 VARCHAR(50)
          l_prtway    LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
      CALL cl_wait()
      LET l_wc='fau01="',g_fau.fau01,'"'
     # SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'afar103'  #FUN-C30085 mark
      #FUN-D10098--add--str--
      IF g_aza.aza26 = '2' THEN
         SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'gfag103' 
      ELSE
      #FUN-D10098--add--end--
         SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file WHERE zz01 = 'afag103'  #FUN-C30085 add
      END IF   #FUN-D10098 add
      IF SQLCA.sqlcode OR l_wc2 IS NULL THEN
         #LET l_wc2 = " '3' '3' 'N' "   #TQC-610055
         LET l_wc2 = " '3' '3' "   #TQC-610055
      END IF
     # LET l_cmd = "afar103", #FUN-C30085 mark
      #FUN-D10098--add--str--
      IF g_aza.aza26 = '2' THEN
         LET l_cmd = "gfag103", 
                     " '",g_today CLIPPED,"' ''",
                     " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                     " '",l_wc CLIPPED,"' ",l_wc2
      ELSE
      #FUN-D10098--add--end--
         LET l_cmd = "afag103", #FUN-C30085 add
                     " '",g_today CLIPPED,"' ''",
                     " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                     " '",l_wc CLIPPED,"' ",l_wc2
      END IF   #FUN-D10098 add
      CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION
 
#---自動產生-------
FUNCTION t103_g()
 DEFINE  l_wc        LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(600)
         l_sql       LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(600)
         l_faj       RECORD
               faj02     LIKE faj_file.faj02,
               faj022    LIKE faj_file.faj022,
               faj06     LIKE faj_file.faj06,
               faj17     LIKE faj_file.faj17,  #No.MOD-4A0113
               faj58     LIKE faj_file.faj58,  #No.MOD-4A0113
               faj171    LIKE faj_file.faj171,
               faj18     LIKE faj_file.faj18
               END RECORD,
         ans         LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
         i           LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE p_row,p_col   LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE ls_tmp STRING
DEFINE l_fav04       LIKE fav_file.fav04    #No.MOD-4A0113
DEFINE l_fav04_n     LIKE fav_file.fav04    #MOD-780228 add
 
   IF s_shut(0) THEN RETURN END IF
   IF g_fau.fau01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fau.fauconf='Y' THEN CALL cl_err(g_fau.fau01,'afa-107',0) RETURN END IF
   IF g_fau.fauconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
    IF NOT cl_confirm('afa-103') THEN RETURN END IF     #No.MOD-490235
   LET INT_FLAG = 0
 
  # CALL cl_getmsg('afa-103',g_lang) RETURNING g_msg
  #          LET INT_FLAG = 0  ######add for prompt bug
  # PROMPT g_msg CLIPPED ,': ' FOR ans
  #    ON IDLE g_idle_seconds
  #       CALL cl_on_idle()
  #        CONTINUE PROMPT
 
   #   ON ACTION about         #MOD-4C0121
   #      CALL cl_about()      #MOD-4C0121
 
   #   ON ACTION help          #MOD-4C0121
   #      CALL cl_show_help()  #MOD-4C0121
 
   #   ON ACTION controlg      #MOD-4C0121
   #      CALL cl_cmdask()     #MOD-4C0121
 
  # END PROMPT
  #---------詢問是否自動新增單身--------------
  # IF ans MATCHES  '[yY]' THEN
      LET p_row = 8 LET p_col = 20
      OPEN WINDOW t103_w2 AT p_row,p_col WITH FORM "afa/42f/afat1032"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
      CALL cl_ui_locale("afat1032")
 
     #CONSTRUCT l_wc ON faj01,faj02,faj022,faj53,faj19,faj20,faj21,faj33          #No.FUN-B50118 mark
     #             FROM faj01,faj02,faj022,faj53,faj19,faj20,faj21,faj33          #No.FUN-B50118 mark
      CONSTRUCT l_wc ON faj01,faj93,faj02,faj022,faj53,faj19,faj20,faj21,faj33    #No.FUN-B50118 add
                   FROM faj01,faj93,faj02,faj022,faj53,faj19,faj20,faj21,faj33    #No.FUN-B50118 add
 
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
     #No.TQC-760182--begin--
      IF l_wc = " 1=1" THEN
         CALL cl_err('','abm-997',1)
         LET INT_FLAG = 1
      END IF
     #No.TQC-760182--end--
      IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t103_w2 RETURN END IF
      #------自動產生------
      BEGIN WORK
 
      OPEN t103_cl USING g_fau.fau01
      IF STATUS THEN
         CALL cl_err("OPEN t103_cl:", STATUS, 1)
         CLOSE t103_cl
         ROLLBACK WORK
         RETURN
      END IF
      FETCH t103_cl INTO g_fau.*          # 鎖住將被更改或取消的資料
      IF SQLCA.sqlcode THEN
         CALL cl_err(g_fau.fau01,SQLCA.sqlcode,0)     # 資料被他人LOCK
         CLOSE t103_cl ROLLBACK WORK RETURN
      END IF
       LET l_sql ="SELECT faj02,faj022,faj06,faj17,faj58,faj171,faj18",  #No.MOD-4A0113
                 "  FROM faj_file",
                 " WHERE faj43 NOT IN ('0','5','6','X')",
                 "   AND fajconf = 'Y'",
                 "   AND faj02 NOT IN (SELECT fca03 FROM fca_file",
                 " WHERE fca03  = faj02 ",
                 "   AND fca031 = faj022 ",
                 "   AND fca15  = 'N')",
                 "   AND faj02 NOT IN (SELECT fav03 FROM fav_file",
                 " WHERE fav03  = faj02 ",
                 "   AND fav01 = '",g_fau.fau01,"')",
                 "   AND ",l_wc CLIPPED,
                 " ORDER BY 1"
     PREPARE t103_prepare_g FROM l_sql
     IF SQLCA.SQLCODE != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0)
        ROLLBACK WORK RETURN
     END IF
     DECLARE t103_curs2 CURSOR FOR t103_prepare_g
 
     SELECT MAX(fav02)+1 INTO i FROM fav_file
      WHERE fav01 = g_fau.fau01
     IF i IS NULL THEN
        LET i = 1
     END IF
     LET g_success = 'Y'                       #No.FUN-8A0086
     CALL s_showmsg_init()                     #No.FUN-710028
     FOREACH t103_curs2 INTO l_faj.*
       IF SQLCA.sqlcode != 0 THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,0)           #No.FUN-710028                                                                                
          CALL s_errmsg('','','foreach:',SQLCA.sqlcode,0)   #No.FUN-710028 
          LET g_success = 'N'                               #No.FUN-8A0086
          EXIT FOREACH
       END IF
#No.FUN-710028 ----------------Begin------------------                                                                              
    IF g_success='N' THEN                                                                                                           
       LET g_totsuccess='N'                                                                                                         
       LET g_success="Y"                                                                                                            
    END IF                                                                                                                          
#No.FUN-710028 ----------------End------------------
       #no:4532檢查資產盤點期間應不可做異動
       SELECT COUNT(*) INTO g_cnt FROM fca_file
        WHERE fca03  = l_faj.faj02
          AND fca031 = l_faj.faj022
          AND fca15  = 'N'
           IF g_cnt > 0 THEN
              CONTINUE FOREACH
           END IF
       #no:4532
 
       #No:A099
       #LET l_fav04 = l_faj.faj17 - l_faj.faj58 - l_faj.faj171  #MOD-780228 mark #No.MOD-4A0113
       #MOD-780228---add---str---
        SELECT SUM(fav04) INTO l_fav04_n FROM fav_file,fau_file
         WHERE fav01 = fau01
           AND fav03 =l_faj.faj02
           AND fav031=l_faj.faj022
           AND faupost='N'
           AND fauconf <> 'X'      #MOD-B30050
        IF cl_null(l_fav04_n) THEN LET l_fav04_n=0 END IF    #MOD-890231 add
        LET l_fav04 = l_faj.faj17 - l_faj.faj58 - l_faj.faj171 - l_fav04_n  
       #MOD-780228---add---end---
         
       #-----TQC-620120---------
       IF cl_null(l_faj.faj022) THEN
          LET l_faj.faj022 = ' '
       END IF
       #-----END TQC-620120-----
       IF l_fav04 > 0 THEN     #TQC-760102 add  外送數量>0的才產生單身
         #----------------------------MOD-C80139----------------------------(S)
         #-MOD-C80139--mark
         #INSERT INTO fav_file(fav01,fav02,fav03,fav031,fav04,fav05,fav06,
         #                    #fav07,fav08,favlegal)                 #FUN-980003 add #No.FUN-B80081 mark
         #                     fav07,favlegal)                       #FUN-980003 add #No.FUN-B80081 add,移除fav08
         #              VALUES(g_fau.fau01,i,l_faj.faj02,l_faj.faj022,
         #                    #l_fav04,'','','','N')                 #MOD-750017
         #                     l_fav04,'','',0,'N',g_legal)   #MOD-750017 #FUN-980003 add
         #-MOD-C80139--mark
          INSERT INTO fav_file(fav01,fav02,fav03,fav031,fav04,
                               fav05,fav06,fav07,favlegal)
                        VALUES(g_fau.fau01,i,l_faj.faj02,l_faj.faj022,l_fav04,
                               '','',0,g_legal)
         #----------------------------MOD-C80139----------------------------(E)
          #end No:A099
          IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
   #         CALL cl_err('ins fav',STATUS,1)   #No.FUN-660136
   #         CALL cl_err3("ins","fav_file",g_fau.fau01,i,STATUS,"","ins fav",1)  #No.FUN-660136  #No.FUN-710028
   #         ROLLBACK WORK                 #No.FUN-710028
   #         RETURN                        #No.FUN-710028
             CALL s_errmsg("fav01",g_fau.fau01,"INS fav_file",SQLCA.sqlcode,0)   #No.FUN-710028
             CONTINUE FOREACH              #No.FUN-710028
          END IF
          LET i = i + 1
       END IF     #TQC-760102 add
     END FOREACH
#No.FUN-710028--------------Begin---------------                                                                                    
  IF g_totsuccess="N" THEN                                                                                                          
     LET g_success="N"                                                                                                        
  END IF   
  CALL s_showmsg()                                                                                                                       
#No.FUN-710028--------------End---------------
     CLOSE t103_cl
     COMMIT WORK
     CLOSE WINDOW t103_w2
     CALL t103_b_fill(l_wc)
  #END IF
END FUNCTION
 
FUNCTION t103_y() 			# when g_fau.fauconf='N' (Turn to 'Y')
  DEFINE g_start,g_end	 LIKE type_file.chr20        #No.FUN-680070 VARCHAR(10)
  DEFINE l_cnt           LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
   SELECT * INTO g_fau.* FROM fau_file WHERE fau01 = g_fau.fau01
   IF g_fau.fauconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF g_fau.fauconf='Y' THEN RETURN END IF
   #bugno:7341 add......................................................
   SELECT COUNT(*) INTO l_cnt FROM fav_file
    WHERE fav01= g_fau.fau01
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   #bugno:7341 end......................................................
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   BEGIN WORK
 
    OPEN t103_cl USING g_fau.fau01
    IF STATUS THEN
       CALL cl_err("OPEN t103_cl:", STATUS, 1)
       CLOSE t103_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t103_cl INTO g_fau.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fau.fau01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t103_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   UPDATE fau_file SET fauconf = 'Y'
    WHERE fau01 = g_fau.fau01
   IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd fauconf',STATUS,1)   #No.FUN-660136
      CALL cl_err3("upd","fau_file",g_fau.fau01,"",STATUS,"","upd fauconf",1)  #No.FUN-660136
      LET g_success = 'N'
   END IF
   CLOSE t103_cl
   IF g_success = 'Y' THEN
      LET g_fau.fauconf='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_fau.fau01,'Y')
      DISPLAY BY NAME g_fau.fauconf
   ELSE
      LET g_fau.fauconf='N'
      ROLLBACK WORK
   END IF
   CALL cl_set_field_pic("","","","","","")
   IF g_fau.fauconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  #start FUN-580109
   IF g_fau.fau06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
  #CALL cl_set_field_pic(g_fau.fauconf,"",g_fau.faupost,"",g_chr,"")
   CALL cl_set_field_pic(g_fau.fauconf,g_chr2,g_fau.faupost,"",g_chr,"")
  #end FUN-580109
END FUNCTION
 
#start FUN-580109
FUNCTION t103_y_chk()
  DEFINE l_cnt          LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
  LET g_success = 'Y'              #FUN-580109
#CHI-C30107 ----------- add ------------ begin
  IF g_fau.fauconf = 'X' THEN
     LET g_success = 'N'           
     CALL cl_err(' ','9024',0)
     RETURN
  END IF
  IF g_fau.fauconf='Y' THEN
     LET g_success = 'N'      
     CALL cl_err('','9023',0)  
     RETURN
  END IF
   IF g_action_choice CLIPPED = "confirm"    #按「確認」時  
   OR g_action_choice CLIPPED = "insert"     
   THEN
      IF NOT cl_confirm('axm-108') THEN  LET g_success = 'N' RETURN END IF
   END IF
#CHI-C30107 ------------- add -------------- end  
  SELECT * INTO g_fau.* FROM fau_file WHERE fau01 = g_fau.fau01
  IF g_fau.fauconf = 'X' THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err(' ','9024',0)
     RETURN
  END IF
  IF g_fau.fauconf='Y' THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err('','9023',0)      #FUN-580109
     RETURN
  END IF
  #MODNO:7341 add......................................................
  SELECT COUNT(*) INTO l_cnt FROM fav_file
   WHERE fav01= g_fau.fau01
  IF l_cnt = 0 THEN
     LET g_success = 'N'   #FUN-580109
     CALL cl_err('','mfg-009',0)
     RETURN
  END IF
  #MODNO:7341 end......................................................
  #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
  #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fau.fau02 < g_faa.faa09 THEN
      LET g_success = 'N'  
      CALL cl_err(g_fau.fau01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end-
 
  IF g_success = 'N' THEN RETURN END IF   #FUN-580109
 
END FUNCTION
 
FUNCTION t103_y_upd()
 
  LET g_success = 'Y'
  IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
     g_action_choice CLIPPED = "insert"     #FUN-640243
  THEN
 
     IF g_fau.faumksg='Y'   THEN
         IF g_fau.fau06 != '1' THEN
            CALL cl_err('','aws-078',1)
            LET g_success = 'N'
            RETURN
         END IF
     END IF
#    IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
  END IF
 
  BEGIN WORK
  OPEN t103_cl USING g_fau.fau01
  IF STATUS THEN
     CALL cl_err("OPEN t103_cl:", STATUS, 1)
     CLOSE t103_cl
     ROLLBACK WORK
     RETURN
  END IF
  FETCH t103_cl INTO g_fau.*          # 鎖住將被更改或取消的資料
  IF SQLCA.sqlcode THEN
      CALL cl_err(g_fau.fau01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t103_cl ROLLBACK WORK RETURN
  END IF
 
  LET g_success = 'Y'
  UPDATE fau_file SET fauconf = 'Y'
   WHERE fau01 = g_fau.fau01
  IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
#    CALL cl_err('upd fauconf',STATUS,1)   #No.FUN-660136
     CALL cl_err3("upd","fau_file",g_fau.fau01,"",STATUS,"","upd fauconf",1)  #No.FUN-660136
     LET g_success = 'N'
  END IF
 
 #start FUN-580109
  IF g_success = 'Y' THEN
     IF g_fau.faumksg = 'Y' THEN #簽核模式
        CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
            WHEN 0  #呼叫 EasyFlow 簽核失敗
                 LET g_fau.fauconf="N"
                 LET g_success = "N"
                 ROLLBACK WORK
                 RETURN
            WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                 LET g_fau.fauconf="N"
                 ROLLBACK WORK
                 RETURN
        END CASE
     END IF
 #end FUN-580109
     CLOSE t103_cl
     IF g_success = 'Y' THEN
       #start FUN-580109
        LET g_fau.fau06='1'      #執行成功, 狀態值顯示為 '1' 已核准
        UPDATE fau_file SET fau06 = g_fau.fau06 WHERE fau01=g_fau.fau01
        IF SQLCA.sqlerrd[3]=0 THEN
           LET g_success='N'
        END IF
       #end FUN-580109
        LET g_fau.fauconf='Y'    #執行成功, 確認碼顯示為 'Y' 已確認
        COMMIT WORK
        CALL cl_flow_notify(g_fau.fau01,'Y')
        DISPLAY BY NAME g_fau.fauconf
        DISPLAY BY NAME g_fau.fau06   #FUN-580109
     ELSE
        LET g_fau.fauconf='N'
        LET g_success = 'N'   #FUN-580109
        ROLLBACK WORK
     END IF
 #start FUN-580109
  ELSE
     LET g_fau.fauconf='N'
     LET g_success = 'N'
     ROLLBACK WORK
  END IF
 #end FUN-580109
 
  CALL cl_set_field_pic("","","","","","")
  IF g_fau.fauconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
 #start FUN-580109
  IF g_fau.fau06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
 #CALL cl_set_field_pic(g_fau.fauconf,"",g_fau.faupost,"",g_chr,"")
  CALL cl_set_field_pic(g_fau.fauconf,g_chr2,g_fau.faupost,"",g_chr,"")
 #end FUN-580109
 
END FUNCTION
 
FUNCTION t103_ef()
 
  CALL t103_y_chk()      #CALL 原確認的 check 段
  IF g_success = "N" THEN
     RETURN
  END IF
 
  CALL aws_condition()   #判斷送簽資料
  IF g_success = 'N' THEN
     RETURN
  END IF
 
######################################
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
######################################
 
  IF aws_efcli2(base.TypeInfo.create(g_fau),base.TypeInfo.create(g_fav),'','','','')
  THEN
     LET g_success='Y'
     LET g_fau.fau06='S'
     DISPLAY BY NAME g_fau.fau06
  ELSE
     LET g_success='N'
  END IF
END FUNCTION
#end FUN-580109
 
FUNCTION t103_z() 			# when g_fau.fauconf='Y' (Turn to 'N')
 
   SELECT * INTO g_fau.* FROM fau_file WHERE fau01 = g_fau.fau01
   IF g_fau.fau06  ='S' THEN CALL cl_err("","mfg3557",0) RETURN END IF   #FUN-580109
   IF g_fau.fauconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF g_fau.fauconf='N' THEN RETURN END IF
   IF g_fau.faupost='Y' THEN
      CALL cl_err(g_fau.faupost,'afa-106',0)
      RETURN
   END IF
  #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
  #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fau.fau02 < g_faa.faa09 THEN
      CALL cl_err(g_fau.fau01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end-
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
 
    OPEN t103_cl USING g_fau.fau01
    IF STATUS THEN
       CALL cl_err("OPEN t103_cl:", STATUS, 1)
       CLOSE t103_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t103_cl INTO g_fau.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fau.fau01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t103_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
  #UPDATE fau_file SET fauconf = 'N'               #FUN-580109 mark
   UPDATE fau_file SET fauconf = 'N',fau06 = '0'   #FUN-580109
    WHERE fau01 = g_fau.fau01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('z_upd fau',STATUS,1)   #No.FUN-660136
      CALL cl_err3("upd","fau_file",g_fau.fau01,"",STATUS,"","z_upd fau",1)  #No.FUN-660136
      LET g_success='N'
   END IF
   CLOSE t103_cl
   IF g_success = 'Y' THEN
      LET g_fau.fauconf='N'
      LET g_fau.fau06='0'   #FUN-580109
      COMMIT WORK
      DISPLAY BY NAME g_fau.fauconf
      DISPLAY BY NAME g_fau.fau06   #FUN-580109
   ELSE
      LET g_fau.fauconf='Y'
      ROLLBACK WORK
   END IF
   CALL cl_set_field_pic("","","","","","")
   IF g_fau.fauconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  #start FUN-580109
   IF g_fau.fau06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
  #CALL cl_set_field_pic(g_fau.fauconf,"",g_fau.faupost,"",g_chr,"")
   CALL cl_set_field_pic(g_fau.fauconf,g_chr2,g_fau.faupost,"",g_chr,"")
  #end FUN-580109
END FUNCTION
 
#----過帳--------
FUNCTION t103_s()
 DEFINE
        l_sql           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(200)
        l_msg           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
        l_cnt           LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_faj           RECORD LIKE faj_file.*,
        l_fav           RECORD
          fav01         LIKE fav_file.fav01,
          fav02         LIKE fav_file.fav02,
          fav03         LIKE fav_file.fav03,
          fav031        LIKE fav_file.fav031,
          fav04         LIKE fav_file.fav04,
          fav05         LIKE fav_file.fav05,
          #fav08         LIKE fav_file.fav08,       #No:A099 #No.FUN-B80081 mark 
          faj171        LIKE faj_file.faj171
         END RECORD
 
   SELECT * INTO g_fau.* FROM fau_file WHERE fau01 = g_fau.fau01
   IF g_fau.fauconf <> 'Y' THEN
      CALL cl_err(' ','afa-100',0)
      RETURN END IF
   IF g_fau.faupost = 'Y' THEN
      CALL cl_err(' ','afa-101',0)
      RETURN END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fau.fau02 < g_faa.faa09 THEN
      CALL cl_err(g_fau.fau01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end-
 
   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK
 
    OPEN t103_cl USING g_fau.fau01
    IF STATUS THEN
       CALL cl_err("OPEN t103_cl:", STATUS, 1)
       CLOSE t103_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t103_cl INTO g_fau.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fau.fau01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t103_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   UPDATE fau_file SET faupost='Y' WHERE fau01=g_fau.fau01 #更改過帳碼
                                     AND faupost = 'N'
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('Update:',SQLCA.sqlcode,1)   #No.FUN-660136
      CALL cl_err3("upd","fau_file",g_fau.fau01,"",SQLCA.sqlcode,"","Update:",1)  #No.FUN-660136
      LET g_success = 'N'
   END IF
   #No:A099
   LET l_sql = "SELECT fav01,fav02,fav03,fav031,fav04,fav05,",
               #"       fav08,faj171",      #end No:A099 #No.FUN-B80081 mark 
               "        faj171",      #end No:A099 #No.FUN-B80081 add,移除fav08 
               "  FROM faj_file,fav_file",
               " WHERE faj02  = fav03",
               "   AND faj022 = fav031",
               "   AND fav01  = '",g_fau.fau01,"'"
   PREPARE t103_prepare3 FROM l_sql
   IF STATUS THEN
      CALL cl_err('Sel :',STATUS,1)
      LET g_success = 'N'
   END IF
   DECLARE t103_curs3 CURSOR FOR t103_prepare3
   CALL s_showmsg_init()                   #No.FUN-710028 
   FOREACH t103_curs3 INTO l_fav.*
     IF SQLCA.sqlcode != 0 THEN
#       CALL cl_err('foreach:',SQLCA.sqlcode,1)           #No.FUN-710028                                                                                
        CALL s_errmsg('','','foreach:',SQLCA.sqlcode,0)   #No.FUN-710028 
        LET g_success = 'N'                               #No.FUN-8A0086
        EXIT FOREACH
     END IF
#No.FUN-710028 ----------------Begin------------------                                                                              
    IF g_success='N' THEN                                                                                                           
       LET g_totsuccess='N'                                                                                                         
       LET g_success="Y"                                                                                                            
    END IF                                                                                                                          
#No.FUN-710028 ----------------End------------------
     LET l_fav.faj171 = l_fav.faj171 + l_fav.fav04
     #------- 先找出對應之 faj_file 資料 99-04-28 modi by kitty
   SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fav.fav03
      AND faj022=l_fav.fav031
   IF STATUS THEN
      CALL cl_err('sel faj',STATUS,0)
      LET g_success = 'N'
   END IF
    #MOD-780228---mark---str---
    ##-->判斷輸入日期之前是否有未過帳  99-04-28 add by kitty
    #SELECT count(*) INTO l_cnt FROM fau_file,fav_file
    #                WHERE fau01 = fav01
    #                  AND fav03 = l_fav.fav03
    #                  AND fav031= l_fav.fav031
    #                  AND fau02 <= g_fau.fau02
    #                  AND faupost = 'N'
    #                  AND fau01 != g_fau.fau01
    #                  AND fauconf <> 'X'   #MOD-590470
    #IF l_cnt  > 0 THEN
    #   LET l_msg = l_fav.fav01,' ',l_fav.fav02,' ',
    #               l_fav.fav03,' ',l_fav.fav031
#   #   CALL cl_err(l_msg,'afa-309',1)          #No.FUN-710028
    #   LET g_success = 'N'
#   #   EXIT FOREACH                            #No.FUN-710028
    #   CALL s_errmsg('','',l_msg,"afa-309",1)  #No.FUN-710028
    #   CONTINUE FOREACH                        #No.FUN-710028
    #END IF
    #MOD-780228---mark---end---
     #----insert fap  99-04-29 add by kitty
     #-----TQC-620120---------
     IF cl_null(l_fav.fav031) THEN
        LET l_fav.fav031 = ' '
     END IF
     #-----END TQC-620120-----
     #CHI-C60010---str---
      SELECT aaa03 INTO g_faj143 FROM aaa_file
       WHERE aaa01 = g_faa.faa02c
      IF NOT cl_null(g_faj143) THEN
         SELECT azi04 INTO g_azi04_1 FROM azi_file
          WHERE azi01 = g_faj143
      END IF
      CALL cl_digcut(l_faj.faj142,g_azi04_1) RETURNING l_faj.faj142
      CALL cl_digcut(l_faj.faj312,g_azi04_1) RETURNING l_faj.faj312
      CALL cl_digcut(l_faj.faj332,g_azi04_1) RETURNING l_faj.faj332
      CALL cl_digcut(l_faj.faj1412,g_azi04_1) RETURNING l_faj.faj1412
      CALL cl_digcut(l_faj.faj322,g_azi04_1) RETURNING l_faj.faj322
      CALL cl_digcut(l_faj.faj592,g_azi04_1) RETURNING l_faj.faj592
      CALL cl_digcut(l_faj.faj602,g_azi04_1) RETURNING l_faj.faj602
      CALL cl_digcut(l_faj.faj352,g_azi04_1) RETURNING l_faj.faj352
     #CHI-C60010---end---
     INSERT INTO fap_file (fap01,fap02,fap021,fap03,
                           fap04,fap05,fap06,fap07,
                           fap08,fap09,fap10,fap101,
                           fap11,fap12,fap13,fap14,
                           fap15,fap16,fap17,fap18,
                           fap19,fap20,fap201,fap21,
                           fap22,fap23,fap24,fap25,
                           fap26,fap30,fap31,fap32,
                           fap33,fap34,fap341,fap35,
                           fap36,fap37,fap38,fap39,
                           fap40,fap41,fap50,fap501,
                           #fap65,fap66,fap44,fap77,fap56,  #CHI-9B0032 add fap77  #TQC-B30156 add fap56 #FUN-B80081 mark
                           fap65,fap66,fap77,fap56,  #CHI-9B0032 add fap77  #TQC-B30156 add fap56 #FUN-B80081 add,移掉fap44
                           #FUN-AB0088---add---str---
                           fap052,fap062,fap072,fap082,
                           fap092,fap103,fap1012,fap112,
                           fap152,fap162,fap212,fap222,
                           fap232,fap242,fap252,fap262,fap772,     
                           #FUN-AB0088---add---end---
                           faplegal)       #No:A099 #FUN-980003 add
                   VALUES (l_faj.faj01,l_fav.fav03,l_fav.fav031,'A',
                           g_fau.fau02,l_faj.faj43,l_faj.faj28,l_faj.faj30,
                           l_faj.faj31,l_faj.faj14,l_faj.faj141,l_faj.faj33,
                           l_faj.faj32,l_faj.faj53,l_faj.faj54,l_faj.faj55,
                           l_faj.faj23,l_faj.faj24,l_faj.faj20,l_faj.faj19,
                           l_faj.faj21,l_faj.faj17,l_faj.faj171,l_faj.faj58,
                           l_faj.faj59,l_faj.faj60,l_faj.faj34,l_faj.faj35,
                           l_faj.faj36,l_faj.faj61,l_faj.faj65,l_faj.faj66,
                           l_faj.faj62,l_faj.faj63,l_faj.faj68,l_faj.faj67,
                           l_faj.faj69,l_faj.faj70,l_faj.faj71,l_faj.faj72,
                           l_faj.faj73,l_faj.faj100,l_fav.fav01,l_fav.fav02,
                           #l_fav.fav05,l_fav.fav04,l_faj.faj105,l_faj.faj43,0, #CHI-9B0032 add faj43  #TQC-B30156 add 0 #No.FUN-B80081 mark 
                           l_fav.fav05,l_fav.fav04,l_faj.faj43,0, #CHI-9B0032 add faj43  #TQC-B30156 add 0 #No.FUN-B80081 add,移除l_faj.faj105
                           #FUN-AB0088---add---str---
                           l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,
                           l_faj.faj142,l_faj.faj1412,l_faj.faj332,l_faj.faj322,
                           l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
                           l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,l_faj.faj432, 
                           #FUN-AB0088---add---end---
                           g_legal)   #No:A099 #FUN-980003 add
       IF STATUS {OR SQLCA.sqlerrd[3]= 0} THEN   #MOD-530810
#       CALL cl_err('ins fap',STATUS,0)   #No.FUN-660136
#       CALL cl_err3("ins","fap_file",l_faj.faj01,l_fav.fav03,STATUS,"","ins fap",1)  #No.FUN-660136  #No.FUN-710028
        LET g_showmsg=l_faj.faj01,"/",l_faj.faj03                #No.FUN-710028
        CALL s_errmsg("fap01,fap03",g_showmsg,"INS fap_file",SQLCA.sqlcode,1)    #No.FUN-710028
        LET g_success = 'N'
      END IF
     #----
     UPDATE faj_file SET faj171 = l_fav.faj171,
                         faj43 ='3'
                         #faj432 ='3'    #FUN-AB0088 #FUN-B90096 mark
                         #faj105 = l_fav.fav08    #No:A099 #No.FUN-B80081 mark
                   WHERE faj02  = l_fav.fav03    #更新資產基本檔
                     AND faj022 = l_fav.fav031
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#       CALL cl_err('Update3:',SQLCA.sqlcode,1)   #No.FUN-660136
#       CALL cl_err3("upd","faj_file",l_fav.fav03,l_fav.fav031,SQLCA.sqlcode,"","Update3:",1)  #No.FUN-660136  #No.FUN-710028
        LET g_showmsg=l_fav.fav03,"/",l_fav.fav031            #No.FUN-710028
        CALL s_errmsg("faj02,faj022",g_showmsg,"UPD faj_file",SQLCA.sqlcode,1)     #No.FUN-710028
        LET g_success = 'N'
     END IF
    #FUN-B90096----------add-------str
     IF g_faa.faa31 = 'Y' THEN
        UPDATE faj_file SET faj432 ='3'
           WHERE faj02  = l_fav.fav03    #更新資產基本檔
             AND faj022 = l_fav.fav031
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           LET g_showmsg=l_fav.fav03,"/",l_fav.fav031
           CALL s_errmsg("faj02,faj022",g_showmsg,"UPD faj_file",SQLCA.sqlcode,1)
           LET g_success = 'N'
        END IF
     END IF 
    #FUN-B90096----------add-------end     
   END FOREACH
#No.FUN-710028--------------Begin---------------                                                                                    
  IF g_totsuccess="N" THEN                                                                                                          
     LET g_success="N"                                                                                                        
  END IF     
  CALL s_showmsg()                                                                                                                     
#No.FUN-710028--------------End---------------
   CLOSE t103_cl
   IF g_success = 'Y' THEN
      LET g_fau.faupost='Y'
      COMMIT WORK
      DISPLAY BY NAME g_fau.faupost
      CALL cl_flow_notify(g_fau.fau01,'S')
   ELSE
      LET g_fau.faupost='N'
      ROLLBACK WORK
   END IF
   CALL cl_set_field_pic("","","","","","")
   IF g_fau.fauconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  #start FUN-580109
   IF g_fau.fau06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
  #CALL cl_set_field_pic(g_fau.fauconf,"",g_fau.faupost,"",g_chr,"")
   CALL cl_set_field_pic(g_fau.fauconf,g_chr2,g_fau.faupost,"",g_chr,"")
  #end FUN-580109
END FUNCTION
 
#------過帳還原--------
FUNCTION t103_w()
 DEFINE l_faj43       LIKE faj_file.faj43       #MOD-690117
 DEFINE
        l_sql         LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(200)
        l_cnt         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_fap05       LIKE fap_file.fap05,
        l_fap44       LIKE fap_file.fap44,        #No:A099
        l_fav         RECORD
          fav01       LIKE fav_file.fav01,
          fav02       LIKE fav_file.fav02,
          fav03       LIKE fav_file.fav03,
          fav031      LIKE fav_file.fav031,
          fav04       LIKE fav_file.fav04,
          faj171      LIKE faj_file.faj171
          END RECORD
DEFINE l_fap052        LIKE fap_file.fap052    #FUN-AB0088
DEFINE l_faj432        LIKE faj_file.faj432    #FUN-AB0088

   SELECT * INTO g_fau.* FROM fau_file WHERE fau01 = g_fau.fau01
   IF g_fau.fauconf <> 'Y' THEN RETURN END IF
   IF g_fau.faupost = 'N' THEN RETURN END IF
   #---->已有收回量則不可還原
   SELECT sum(fav07) INTO l_cnt FROM fav_file WHERE fav01 = g_fau.fau01
   IF l_cnt > 0 THEN
      CALL cl_err(g_fau.fau01,'afa-340',0) RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_fau.fau02 < g_faa.faa09 THEN
      CALL cl_err(g_fau.fau01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end-
   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK
 
    OPEN t103_cl USING g_fau.fau01
    IF STATUS THEN
       CALL cl_err("OPEN t103_cl:", STATUS, 1)
       CLOSE t103_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t103_cl INTO g_fau.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fau.fau01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t103_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   UPDATE fau_file SET faupost='N' WHERE fau01=g_fau.fau01 #更改過帳碼
                                     AND faupost = 'Y'
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('Update:',SQLCA.sqlcode,1)   #No.FUN-660136
      CALL cl_err3("upd","fau_file",g_fau.fau01,"",SQLCA.sqlcode,"","Update:",1)  #No.FUN-660136
      LET g_success = 'N'
   END IF
   LET l_sql = "SELECT fav01,fav02,fav03,fav031,fav04,faj171 ",
               "  FROM faj_file,fav_file",
               " WHERE faj02  = fav03",
               "   AND faj022 = fav031",
               "   AND fav01  = '",g_fau.fau01,"'"
   PREPARE t103_prepare4 FROM l_sql
   IF STATUS THEN
      CALL cl_err('Prepare :',STATUS,0)
      LET g_success = 'N'
   END IF
   DECLARE t103_curs4 CURSOR FOR t103_prepare4
   CALL s_showmsg_init()               #No.FUN-710028
   FOREACH t103_curs4 INTO l_fav.*
      IF SQLCA.sqlcode THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)            #No.FUN-710028                                                                                
         CALL s_errmsg('','','foreach:',SQLCA.sqlcode,0)    #No.FUN-710028
         LET g_success = 'N'                                #No.FUN-8A0086
         EXIT FOREACH
      END IF
     #SELECT fap05,fap44 INTO l_fap05,l_fap44                       #No:A099   #FUN-AB0088 mark
      SELECT fap05,fap052,fap44 INTO l_fap05,l_fap052,l_fap44       #No:A099   #FUN-AB0088 add
        FROM fap_file   #update回faj43
       WHERE fap03='A'
         AND fap50=g_fau.fau01
         AND fap02=l_fav.fav03
         AND fap021=l_fav.fav031
      IF SQLCA.sqlcode THEN
#        CALL cl_err('update faj43:',SQLCA.sqlcode,1)   #No.FUN-660136
#        CALL cl_err3("sel","fap_file",g_fau.fau01,l_fav.fav03,SQLCA.sqlcode,"","update faj43:",1)  #No.FUN-660136  #No.FUN-710028
         LET g_showmsg=g_fau.fau01,"/",l_fav.fav03,"/",l_fav.fav031    #No.FUN-710028
         CALL s_errmsg("fap50,fap02,fap021",g_showmsg,"SEL fap_file",SQLCA.sqlcode,1)  #No.FUN-710028
         LET g_success = 'N'
      END IF
      #--------- 還原過帳 delete fap_file   99-04-29 add by kitty
 
      LET l_fav.faj171 = l_fav.faj171 - l_fav.fav04
      #MOD-690117-----add-----str----
     #SELECT faj43 INTO l_faj43 FROM faj_file                   #FUN-AB0088 mark 
      SELECT faj43,faj432 INTO l_faj43,l_faj432 FROM faj_file   #FUN-AB0088 add
       WHERE faj02=l_fav.fav03
         AND faj022=l_fav.fav031
      IF STATUS THEN 
#        CALL cl_err('sel faj',STATUS,0)     #No.FUN-710028
         LET g_success = 'N'
#        RETURN                              #No.FUN-710028
         LET g_showmsg=l_fav.fav03,"/",l_fav.fav031   #No.FUN-710028
         CALL s_errmsg("faj02,faj022",g_showmsg,"SEL faj",SQLCA.sqlcode,1)  #No.FUN-710028
         CONTINUE FOREACH                    #No.FUN-710028
      END IF
      IF l_faj43 <> '3' THEN
          LET l_fap05 = l_faj43
          LET l_fap052 = l_faj432     #FUN-AB0088 add
      END IF
      #MOD-690117-----add-----end----
      UPDATE faj_file SET faj171 = l_fav.faj171,
                          faj43 =l_fap05
                          #faj432 = l_fap052    #FUN-AB0088 #FUN-B90096 mark
                          #faj105=l_fap44        #No:A099 #No.FUN-B80081 mark
                      WHERE faj02  = l_fav.fav03    #更新資產基本檔
                        AND faj022 = l_fav.fav031
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#        CALL cl_err('Update3:',SQLCA.sqlcode,1)   #No.FUN-660136
#        CALL cl_err3("upd","faj_file",l_fav.fav03,l_fav.fav031,SQLCA.sqlcode,"","Update3:",1)  #No.FUN-660136  #No.FUN-710028
         LET g_showmsg=l_fav.fav03,"/",l_fav.fav031     #No.FUN-710028
         CALL s_errmsg("faj02,faj022",g_showmsg,"UPD faj_file",SQLCA.sqlcode,1)    #No.FUN-710028
         LET g_success = 'N'
      END IF
     #FUN-B90096----------add-------str
      IF g_faa.faa31 = 'Y' THEN
         UPDATE faj_file SET faj432 = l_fap052
            WHERE faj02  = l_fav.fav03    #更新資產基本檔
              AND faj022 = l_fav.fav031
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_showmsg=l_fav.fav03,"/",l_fav.fav031
            CALL s_errmsg("faj02,faj022",g_showmsg,"UPD faj_file",SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
      END IF 
     #FUN-B90096----------add-------end       
      #--------- 還原過帳 delete fap_file   99-04-29 add by kitty
      DELETE FROM fap_file WHERE fap50=l_fav.fav01 AND fap501= l_fav.fav02
                             AND fap03 = 'A'
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#        CALL cl_err('del fap',STATUS,0)   #No.FUN-660136
#        CALL cl_err3("del","fap_file",l_fav.fav01,l_fav.fav02,STATUS,"","del fap",1)  #No.FUN-660136   #No.FUN-710028
         LET g_showmsg=l_fav.fav01,"/",l_fav.fav02      #No.FUN-710028
         CALL s_errmsg("fap50,fap501",g_showmsg,"DEL fap_file",SQLCA.sqlcode,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
   END FOREACH
#No.FUN-710028--------------Begin---------------                                                                                    
  IF g_totsuccess="N" THEN                                                                                                          
     LET g_success="N"                                                                                                        
  END IF       
  CALL s_showmsg()                                                                                                                   
#No.FUN-710028--------------End---------------
   CLOSE t103_cl
   IF g_success = 'Y' THEN
      LET g_fau.faupost='N'
      COMMIT WORK
      DISPLAY BY NAME g_fau.faupost
   ELSE
      LET g_fau.faupost='Y'
      ROLLBACK WORK
   END IF
   CALL cl_set_field_pic("","","","","","")
   IF g_fau.fauconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  #start FUN-580109
   IF g_fau.fau06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
  #CALL cl_set_field_pic(g_fau.fauconf,"",g_fau.faupost,"",g_chr,"")
   CALL cl_set_field_pic(g_fau.fauconf,g_chr2,g_fau.faupost,"",g_chr,"")
  #end FUN-580109
END FUNCTION

#1.作废、2.取消作废 
#FUNCTION t103_x()             #FUN-D20035
FUNCTION t103_x(p_type)                  #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_fau.* FROM fau_file WHERE fau01=g_fau.fau01
  #start FUN-580109
   IF g_fau.fau06 MATCHES '[Ss1]' THEN
      CALL cl_err("","mfg3557",0) RETURN
   END IF
  #end FUN-580109
   IF g_fau.fau01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fau.fauconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF

   #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_fau.fauconf='X' THEN RETURN END IF
   ELSE
      IF g_fau.fauconf<>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   BEGIN WORK
   LET g_success='Y'
 
   OPEN t103_cl USING g_fau.fau01
   IF STATUS THEN
      CALL cl_err("OPEN t103_cl:", STATUS, 1)
      CLOSE t103_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t103_cl INTO g_fau.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fau.fau01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t103_cl ROLLBACK WORK RETURN
   END IF
  #-->作廢轉換01/08/01
  #IF cl_void(0,0,g_fau.fauconf)   THEN                                #FUN-D20035
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #FUN-D20035
   IF cl_void(0,0,l_flag) THEN                                         #FUN-D20035
      LET g_chr=g_fau.fauconf
     #IF g_fau.fauconf ='N' THEN                                       #FUN-D20035
      IF p_type = 1 THEN                                               #FUN-D20035
         LET g_fau.fauconf='X'
         LET g_fau.fau06 = '9'   #FUN-580109
      ELSE
         LET g_fau.fauconf='N'
         LET g_fau.fau06 = '0'   #FUN-580109
      END IF
 
      UPDATE fau_file SET fauconf=g_fau.fauconf,
                          fau06  =g_fau.fau06,   #FUN-580109
                          faumodu=g_user,
                          faudate=TODAY
       WHERE fau01 = g_fau.fau01
      IF STATUS THEN 
#        CALL cl_err('upd fauconf:',STATUS,1) #No.FUN-660136
         CALL cl_err3("upd","fau_file",g_fau.fau01,g_fav_t.fav02,STATUS,"","upd fauconf:",1)  #No.FUN-660136
         LET g_success='N' 
      END IF
      IF g_success='Y' THEN
         COMMIT WORK
        #start FUN-580109
         IF g_fau.fauconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_fau.fau06 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_fau.fauconf,g_chr2,g_fau.faupost,"",g_chr,"")
        #end FUN-580109
         CALL cl_flow_notify(g_fau.fau01,'V')
      ELSE
         ROLLBACK WORK
      END IF
     #SELECT fauconf INTO g_fau.fauconf                     #FUN-580109 mark
      SELECT fauconf,fau06 INTO g_fau.fauconf,g_fau.fau06   #FUN-580109
        FROM fau_file
       WHERE fau01 = g_fau.fau01
      DISPLAY BY NAME g_fau.fauconf
      DISPLAY BY NAME g_fau.fau06   #FUN-580109
   END IF
  #CALL cl_set_field_pic("","","","","","")                            #FUN-580109 mark
  #IF g_fau.fauconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF   #FUN-580109 mark
  #CALL cl_set_field_pic(g_fau.fauconf,"",g_fau.faupost,"",g_chr,"")   #FUN-580109 mark
END FUNCTION

