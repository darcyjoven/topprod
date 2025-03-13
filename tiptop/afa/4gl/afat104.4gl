# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afat104.4gl
# Descriptions...: 外送資產收回維護作業
# Date & Author..: 96/05/31 By Sophia
# Modify.........: No:7837 03/08/19 By Wiky 呼叫自動取單號時應在 Transction中
# Modify.........: No:8466 03/10/14 By Kitty 回寫固資狀態時變成空值
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.MOD-470515 04/07/30 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-4A0248 04/10/25 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.FUN-550034 05/05/16 By jackie 單據編號加大
# Modify.........: No.FUN-550129 05/06/02 By Smapmin afat104.單頭外送單號應提供開窗查詢
# Modify.........: No.FUN-560002 05/06/06 By vivien 單據編號修改
# Modify.........: No.FUN-560060 05/06/16 By day    單據編號修改
# Modify.........: No.MOD-570146 05/08/03 By Smapmin 提供單頭查詢未收回外送單之功能
# Modify.........: No.MOD-590470 05/10/21 By Sarah 判斷筆數之條件應排除已作廢之單據(找
# Modify.........: No.FUN-580109 05/10/21 By Sarah 以EF為backend engine,由TIPTOP處理前端簽核動作
# Modify.........: No.FUN-5B0018 05/11/04 By Sarah 收回日期沒有判斷關帳日
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-620120 06/03/02 By Smapmin 當附號為NULL時,LET 附號為空白
# Modify.........: No.TQC-630073 06/03/07 By Mandy 流程訊息通知功能
# Modify.........: No.FUN-630045 06/03/15 BY Alexstar 新增申請人(表單關係人)欄位
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-640243 06/05/10 By Echo 自動執行確認功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0001 06/10/11 By jamie FUNCTION t104()_q 一開始應清空g_faw.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time 
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.MOD-690117 06/12/14 By Mandy 資產回收若是跨月的時候會將原折舊的狀態回寫為資本化,造成可以被取消確認
# Modify.........: No.FUN-710028 07/01/31 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-720074 07/03/01 By Smapmin 檢查資產盤點期間應不可做異動
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-730083 07/03/19 By Smapmin 變數使用有誤
# Modify.........: No.MOD-740266 07/04/23 By Sarah 新增輸入單號沒有檢查單別是否存在單據性質檔中
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760182 07/06/26 By chenl   增加打印功能。
# Modify.........: No.TQC-770108 07/07/24 By Rayven 單身收回數量欄位對負數未控管
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-840111 08/04/23 By lilingyu 預設申請人員登入帳號
# Modify.........: No.FUN-850068 08/05/14 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No.MOD-890275 08/10/01 By clover 資產回收單,在確認時卡: 回收日 < 外送日
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980003 09/08/10 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9B0032 09/11/30 By Sarah 寫入fap_file時,也應寫入fap77=faj43
# Modify.........: No.MOD-9C0281 09/12/23 By sabrina 單頭與單身的外送單需一致
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A40039 10/04/09 by houlia 跟TQC-770108添加0的控管
# Modify.........: No:CHI-A50036 10/06/08 By Summer fax03開窗前檢核若faw03有值時,依此為條件顯示,若為空值,則全部顯示
# Modify.........: No:MOD-A80137 10/08/19 By Dido 確認與取消確認;過帳與取消過帳應檢核關帳日
# Modify.........: No:MOD-B30123 11/03/11 By Sarah FUNCTION t104_fax04()請增加抓取fav08->fax08
# Modify.........: No:MOD-B30624 11/03/21 By Dido 列印重新給予 g_wc 值 
# Modify.........: No.FUN-AB0088 11/04/02 By chenying 因固資拆出財二功能，原本寫入fap亦有新增欄位，增加對應處理
# Modify.........: No.TQC-B30156 11/05/12 By Dido 預設 fap56 為 0
# Modify.........: No.FUN-B50090 11/05/17 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80054 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: NO:FUN-B80081 11/11/01 By Sakura faj105相關程式段Mark,停用(fax08/fav08)欄位及相關程式段移除
# Modify.........: NO:FUN-B90096 11/11/03 By Sakura 將UPDATE faj_file拆分出財一、財二
# Modify.........: No:MOD-BB0240 11/11/22 By Sarah 確認段增加afa-309檢查段
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20012 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/06 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C60010 12/06/14 By jinjj 財簽二欄位需依財簽二幣別做取位
# Modify.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_faw     RECORD LIKE faw_file.*,
    g_faw_t   RECORD LIKE faw_file.*,
    g_faw_o   RECORD LIKE faw_file.*,
    g_fahconf        LIKE fah_file.fahconf,
    g_fahpost        LIKE fah_file.fahpost,
    g_fahapr        LIKE fah_file.fahapr,             #FUN-640243
    g_fax            DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                     fax02     LIKE fax_file.fax02,
                     fax03     LIKE fax_file.fax03,
                     fax04     LIKE fax_file.fax04,
                     fax05     LIKE fax_file.fax05,
                     fax051    LIKE fax_file.fax051,
                     faj06     LIKE faj_file.faj06,
                     faj18     LIKE faj_file.faj18,
                     #fax08     LIKE fax_file.fax08,        #No:A099 #No.FUN-B80081 mark
                     fax06     LIKE fax_file.fax06,
                     fax07     LIKE fax_file.fax07
                     #FUN-850068 --start---
                     ,faxud01 LIKE fax_file.faxud01,
                     faxud02 LIKE fax_file.faxud02,
                     faxud03 LIKE fax_file.faxud03,
                     faxud04 LIKE fax_file.faxud04,
                     faxud05 LIKE fax_file.faxud05,
                     faxud06 LIKE fax_file.faxud06,
                     faxud07 LIKE fax_file.faxud07,
                     faxud08 LIKE fax_file.faxud08,
                     faxud09 LIKE fax_file.faxud09,
                     faxud10 LIKE fax_file.faxud10,
                     faxud11 LIKE fax_file.faxud11,
                     faxud12 LIKE fax_file.faxud12,
                     faxud13 LIKE fax_file.faxud13,
                     faxud14 LIKE fax_file.faxud14,
                     faxud15 LIKE fax_file.faxud15
                     #FUN-850068 --end--
                     END RECORD,
    g_fax_t          RECORD
                     fax02     LIKE fax_file.fax02,
                     fax03     LIKE fax_file.fax03,
                     fax04     LIKE fax_file.fax04,
                     fax05     LIKE fax_file.fax05,
                     fax051    LIKE fax_file.fax051,
                     faj06     LIKE faj_file.faj06,
                     faj18     LIKE faj_file.faj18,
                     #fax08     LIKE fax_file.fax08,        #No:A099 #No.FUN-B80081 mark
                     fax06     LIKE fax_file.fax06,
                     fax07     LIKE fax_file.fax07
                     #FUN-850068 --start---
                     ,faxud01 LIKE fax_file.faxud01,
                     faxud02 LIKE fax_file.faxud02,
                     faxud03 LIKE fax_file.faxud03,
                     faxud04 LIKE fax_file.faxud04,
                     faxud05 LIKE fax_file.faxud05,
                     faxud06 LIKE fax_file.faxud06,
                     faxud07 LIKE fax_file.faxud07,
                     faxud08 LIKE fax_file.faxud08,
                     faxud09 LIKE fax_file.faxud09,
                     faxud10 LIKE fax_file.faxud10,
                     faxud11 LIKE fax_file.faxud11,
                     faxud12 LIKE fax_file.faxud12,
                     faxud13 LIKE fax_file.faxud13,
                     faxud14 LIKE fax_file.faxud14,
                     faxud15 LIKE fax_file.faxud15
                     #FUN-850068 --end--
                     END RECORD,
    g_fah            RECORD LIKE fah_file.*,
    g_faw01_t        LIKE faw_file.faw01,
    g_faw03_t        LIKE faw_file.faw03,  #No.FUN-550034
    g_fax06          LIKE fax_file.fax06,
#   g_wc,g_wc2,g_sql LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(300)
    g_wc,g_wc2,g_sql STRING,   #No.TQC-630166  
    g_t1             LIKE type_file.chr5,    #No.FUN-550034       #No.FUN-680070 VARCHAR(5)
    g_buf            LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
    g_rec_b          LIKE type_file.num5,               #單身筆數       #No.FUN-680070 SMALLINT
    l_ac             LIKE type_file.num5                #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
DEFINE g_argv1       LIKE faw_file.faw01   #收回單號   #FUN-580109
DEFINE g_argv2       STRING                 # 指定執行功能:query or inser  #TQC-630073
DEFINE g_laststage   LIKE type_file.chr1                             #FUN-580109       #No.FUN-680070 VARCHAR(1)
DEFINE g_forupd_sql  STRING     #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_chr         LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE g_chr2        LIKE type_file.chr1      #FUN-580109       #No.FUN-680070 VARCHAR(1)
DEFINE g_cnt         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_i           LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE g_msg         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE g_row_count   LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_curs_index  LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_jump        LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE mi_no_ask     LIKE type_file.num5         #No.FUN-680070 SMALLINT
#CHI-C60010---str---
DEFINE g_azi04_1  LIKE azi_file.azi04,
       g_faj143   LIKE faj_file.faj143
#CHI-C60010---end---
 
MAIN
DEFINE
#    l_time           LIKE type_file.chr8,                #計算被使用時間       #No.FUN-680070 VARCHAR(8)  #NO.FUN-6A0069
   #l_sql            LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
    l_sql            STRING                #TQC-630166
DEFINE p_row,p_col   LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
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
   CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                        #NO.FUN-6A0069
 
   LET g_forupd_sql = " SELECT * FROM faw_file WHERE faw01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t104_cl CURSOR FROM g_forupd_sql
 
   LET g_argv1=ARG_VAL(1)  #TQC-630073
   LET g_argv2=ARG_VAL(2)  #TQC-630073
   LET g_wc2 = ' 1=1'
 
    #FUN-640243
    IF g_bgjob='N' OR cl_null(g_bgjob) THEN
 
       LET p_row = 4 LET p_col = 7
       OPEN WINDOW t104_w AT p_row,p_col              #顯示畫面
             WITH FORM "afa/42f/afat104"
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
  #   CALL t104_q()
  #END IF
  #TQC-630073 add-----------------------
  IF NOT cl_null(g_argv1) THEN
     CASE g_argv2
        WHEN "query"
           LET g_action_choice = "query"
           IF cl_chk_act_auth() THEN
              CALL t104_q()
           END IF
        WHEN "insert"
           LET g_action_choice = "insert"
           IF cl_chk_act_auth() THEN
              CALL t104_a()
           END IF
         #FUN-640243
         WHEN "efconfirm"
            CALL t104_q()
            CALL t104_y_chk()          #CALL 原確認的 check 段
            IF g_success = "Y" THEN
               LET l_ac = 1
               CALL t104_y_upd()       #CALL 原確認的 update 段
            END IF
            EXIT PROGRAM
         #END FUN-640243
        OTHERWISE
           CALL t104_q()
     END CASE
  END IF
  #TQC-630073(end)-----------------
 
   #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
   CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,   #FUN-D20035
                              confirm, undo_confirm, easyflow_approval, post, undo_post")
        RETURNING g_laststage
   #end FUN-580109
 
   CALL t104_menu()
   CLOSE WINDOW t104_w                    #結束畫面
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                 #NO.FUN-6A0069
END MAIN
 
FUNCTION t104_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
  CLEAR FORM                             #清除畫面
  CALL g_fax.clear()
  #start FUN-580109
  IF NOT cl_null(g_argv1) THEN
     LET g_wc = " faw01 = '",g_argv1,"'"
     LET g_wc2 = " 1=1"
  ELSE
  #end FUN-580109
     CALL cl_set_head_visible("","YES")   #No.FUN-6B0029
   INITIALIZE g_faw.* TO NULL    #No.FUN-750051
     CONSTRUCT BY NAME g_wc ON            # 螢幕上取單頭條件
       faw01,faw02,faw05,faw03,fawconf,fawpost,#FUN-630045
       fawmksg,faw04,   #FUN-580109
       fawuser,fawgrup,fawmodu,fawdate
       #FUN-850068   ---start---
       ,fawud01,fawud02,fawud03,fawud04,fawud05,
       fawud06,fawud07,fawud08,fawud09,fawud10,
       fawud11,fawud12,fawud13,fawud14,fawud15
       #FUN-850068    ----end----
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
       ON ACTION controlp
          CASE
             WHEN INFIELD(faw01)    #查詢單據性質
               #LET g_t1=g_faw.faw01[1,3]
               #CALL q_fah( FALSE, TRUE,g_t1,'B',g_sys) RETURNING g_t1
               #LET g_faw.faw01[1,3]=g_t1
               #DISPLAY BY NAME g_faw.faw01
                 #--No.MOD-4A0248--------
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_faw"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO faw01
                #--END---------------
                NEXT FIELD faw01
 #MOD-570146
##FUN-550129
#             WHEN INFIELD(faw03)    #查詢外送單號
#                CALL cl_init_qry_var()
#                LET g_qryparam.state= "c"
#                LET g_qryparam.form = "q_fau"
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
#                DISPLAY g_qryparam.multiret TO faw03
#                NEXT FIELD faw03
##END FUN-550129
             WHEN INFIELD(faw03)    #查詢外送單號
               CALL q_fau1(TRUE,TRUE,'') RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO faw03
               NEXT FIELD faw03
 #END MOD-570146
             #FUN-630045
             WHEN INFIELD(faw05) #申請人
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO faw05
               NEXT FIELD faw05
             #END FUN-630045
 
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
    #CONSTRUCT g_wc2 ON fax02,fax03,fax04,fax05,fax051,fax08,fax06,fax07 #No.FUN-B80081 mark
     CONSTRUCT g_wc2 ON fax02,fax03,fax04,fax05,fax051,fax06,fax07 #FUN-B80081 add,移除fax08
                        #No.FUN-850068 --start--
                        ,faxud01,faxud02,faxud03,faxud04,faxud05,
                        faxud06,faxud07,faxud08,faxud09,faxud10,
                        faxud11,faxud12,faxud13,faxud14,faxud15
                        #No.FUN-850068 ---end---
             FROM s_fax[1].fax02, s_fax[1].fax03, s_fax[1].fax04,
                  #s_fax[1].fax05, s_fax[1].fax051,s_fax[1].fax08, #No.FUN-B80081 mark 
                  s_fax[1].fax05, s_fax[1].fax051, #No.FUN-B80081 add,移除fax08
                  s_fax[1].fax06, s_fax[1].fax07
                  #No.FUN-850068 --start--
                  ,s_fax[1].faxud01,s_fax[1].faxud02,s_fax[1].faxud03,
                  s_fax[1].faxud04,s_fax[1].faxud05,s_fax[1].faxud06,
                  s_fax[1].faxud07,s_fax[1].faxud08,s_fax[1].faxud09,
                  s_fax[1].faxud10,s_fax[1].faxud11,s_fax[1].faxud12,
                  s_fax[1].faxud13,s_fax[1].faxud14,s_fax[1].faxud15
                  #No.FUN-850068 ---end---
     #end No:A099
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
       ON ACTION controlp
          CASE
             WHEN INFIELD(fax03)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_fav"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO fax03
                NEXT FIELD fax03
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
  #  IF g_priv2='4' THEN                           #只能使用自己的資料
  #      LET g_wc = g_wc clipped," AND fawuser = '",g_user,"'"
  #  END IF
  #  IF g_priv3='4' THEN                           #只能使用相同群的資料
  #      LET g_wc = g_wc clipped," AND fawgrup MATCHES '",g_grup CLIPPED,"*'"
  #  END IF
 
  #  IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
  #      LET g_wc = g_wc clipped," AND fawgrup IN ",cl_chk_tgrup_list()
  #  END IF
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fawuser', 'fawgrup')
  #End:FUN-980030
 
 
  IF g_wc2 = " 1=1" THEN		# 若單身未輸入條件
     LET g_sql = "SELECT faw01 FROM faw_file",
                 " WHERE ", g_wc CLIPPED,
                 " ORDER BY 1"
  ELSE					# 若單身有輸入條件
     LET g_sql = "SELECT DISTINCT faw01 ",
                 "  FROM faw_file, fax_file",
                 " WHERE faw01 = fax01",
                 "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                 " ORDER BY 1"
  END IF
 
  PREPARE t104_prepare FROM g_sql
  DECLARE t104_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR t104_prepare
 
  IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM faw_file WHERE ",g_wc CLIPPED
  ELSE
      LET g_sql="SELECT COUNT(DISTINCT faw01) FROM faw_file,fax_file",
                " WHERE fax01 = faw01 ",
                "   AND ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED
  END IF
  PREPARE t104_count_pre FROM g_sql
  DECLARE t104_count CURSOR FOR t104_count_pre
END FUNCTION
 
FUNCTION t104_menu()
   DEFINE l_creator    LIKE type_file.chr1           #「不准」時是否退回填表人 #FUN-580109       #No.FUN-680070 VARCHAR(1)
   DEFINe l_flowuser   LIKE type_file.chr1           # 是否有指定加簽人員      #FUN-580109       #No.FUN-680070 VARCHAR(1)
 
   LET l_flowuser = "N"   #FUN-580109
 
   WHILE TRUE
      CALL t104_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t104_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t104_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t104_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t104_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t104_b()
            ELSE
               LET g_action_choice = NULL
            END IF
        #No.TQC-760182--begin--
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t104_o()
            END IF
        #No.TQC-760182--end--
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t104_x()            #FUN-D20035
               CALL t104_x(1)           #FUN-D20035
            END IF

         #FUN-D20035---add--str
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t104_x(2)
            END IF
         #FUN-D20035---add---end

         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               #start FUN-580109
               #CALL t104_y()
               CALL t104_y_chk()          #CALL 原確認的 check 段
               IF g_success = "Y" THEN
                  CALL t104_y_upd()       #CALL 原確認的 update 段
               END IF
               #end FUN-580109
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t104_z()
            END IF
         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t104_s()
            END IF
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t104_w()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_faw.faw01 IS NOT NULL THEN
                  LET g_doc.column1 = "faw01"
                  LET g_doc.value1 = g_faw.faw01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fax),'','')
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
                SELECT * INTO g_faw.* FROM faw_file
                 WHERE faw01 = g_faw.faw01
                CALL t104_show()
                CALL t104_b_fill(' 1=1')
               #FUN-C20012 add end---
                CALL t104_ef()
                CALL t104_show()  #FUN-C20012 add
             END IF
        #@WHEN "准"
        WHEN "agree"
             IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加簽人員
                CALL t104_y_upd()      #CALL 原確認的 update 段
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
                         CALL t104_q()
                         #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                         CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,    #FUN-D20035 add--undo_void
                                                    confirm, undo_confirm, easyflow_approval, post, undo_post")
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
                     LET g_faw.faw04 = 'R'
                     DISPLAY BY NAME g_faw.faw04
                  END IF
                  IF cl_confirm('aws-081') THEN
                     IF aws_efapp_getnextforminfo() THEN
                        LET l_flowuser = 'N'
                        LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
                        IF NOT cl_null(g_argv1) THEN
                           CALL t104_q()
                           #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                           CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, void, undo_void,    #FUN-D20035 add--undo_void
                                                      confirm, undo_confirm, easyflow_approval, post, undo_post")
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
 
FUNCTION t104_a()
DEFINE li_result   LIKE type_file.num5         #No.FUN-680070 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_fax.clear()
    INITIALIZE g_faw.* TO NULL
    LET g_faw01_t = NULL
    LET g_faw_o.* = g_faw.*
    LET g_faw_t.* = g_faw.*
 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_faw.faw02  =g_today
        LET g_faw.fawconf='N'
        LET g_faw.fawpost='N'
        LET g_faw.fawprsw=0
        LET g_faw.fawuser=g_user
        LET g_faw.faworiu = g_user #FUN-980030
        LET g_faw.faworig = g_grup #FUN-980030
        LET g_faw.fawgrup=g_grup
        LET g_faw.fawdate=g_today
        LET g_faw.fawmksg = "N"   #FUN-580109
        LET g_faw.faw04 = "0"     #FUN-580109
        LET g_faw.fawlegal= g_legal    #FUN-980003 add
 
        #FUN-630045
        LET g_faw.faw05=g_user                            
        CALL t104_faw05('d')
#        IF NOT cl_null(g_errno) THEN    #NO.FUN-840111
#           LET g_faw.faw05 = ''         #NO.FUN-840111
#        END IF                          #NO.FUN-840111         
        #END FUN-630045
        
        CALL t104_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0
           INITIALIZE g_faw.* TO NULL
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        IF g_faw.faw01 IS NULL THEN       #KEY不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK  #No:7837
#No.FUN-550034 --start--
        CALL s_auto_assign_no("afa",g_faw.faw01,g_faw.faw02,"B","faw_file","faw01","","","")
             RETURNING li_result,g_faw.faw01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_faw.faw01
 
#        CALL s_auto_assign_no("afa",g_faw.faw03,g_faw.faw02,"B","faw_file","faw01","","","")
#             RETURNING li_result,g_faw.faw01
#        IF (NOT li_result) THEN
#           CONTINUE WHILE
#        END IF
#        DISPLAY BY NAME g_faw.faw01
 
#        IF g_fah.fahauno='Y' THEN
#	   CALL s_afaauno(g_faw.faw01,g_faw.faw02)
#                RETURNING g_i,g_faw.faw01
#           IF g_i THEN CONTINUE WHILE END IF	#有問題
#	   DISPLAY BY NAME g_faw.faw01
#        END IF
        INSERT INTO faw_file VALUES (g_faw.*)
        IF SQLCA.SQLCODE THEN
           CALL cl_err3("ins","faw_file",g_faw.faw01,"",SQLCA.sqlcode,"","Ins:",1)  #No.FUN-660136 #No.FUN-B80054---調整至回滾事務前---
           ROLLBACK WORK  #No:7837
#          CALL cl_err('Ins:',SQLCA.SQLCODE,1)   #No.FUN-660136
           CONTINUE WHILE
        ELSE
           COMMIT WORK   #No:7837
           CALL cl_flow_notify(g_faw.faw01,'I')
        END IF
        CALL g_fax.clear()
        LET g_rec_b=0
        LET g_faw_t.* = g_faw.*
        LET g_faw01_t = g_faw.faw01
 
        SELECT faw01 INTO g_faw.faw01
          FROM faw_file
         WHERE faw01 = g_faw.faw01
 
        IF NOT cl_null(g_faw.faw03) THEN
           CALL t104_g()
           CALL t104_b()
        ELSE
           CALL t104_b()
        END IF
        #---判斷是否直接列印,確認,過帳---------
#        LET g_t1 = g_faw.faw01[1,3]
        LET g_t1 = s_get_doc_no(g_faw.faw01) #No.FUN-550034
        #FUN-640243
        SELECT fahconf,fahpost,fahapr INTO g_fahconf,g_fahpost,g_fahapr
          FROM fah_file
         WHERE fahslip = g_t1
 
        IF g_fahconf = 'Y' AND g_fahapr <> 'Y' THEN
           LET g_action_choice = "insert"
        #END FUN-640243
 
           #start FUN-580109
           #CALL t104_y()
           CALL t104_y_chk()          #CALL 原確認的 check 段
           IF g_success = "Y" THEN
              CALL t104_y_upd()       #CALL 原確認的 update 段
           END IF
           #end FUN-580109
        END IF
        IF g_fahpost = 'Y' THEN
           CALL t104_s()
        END IF
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t104_u()
   IF s_shut(0) THEN RETURN END IF
 
    IF g_faw.faw01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    SELECT * INTO g_faw.* FROM faw_file WHERE faw01 = g_faw.faw01
    IF g_faw.fawconf = 'X' THEN
       CALL cl_err(' ','9024',0)
       RETURN
    END IF
    IF g_faw.fawconf = 'Y' THEN
       CALL cl_err(' ','afa-096',0)
       RETURN
    END IF
    IF g_faw.fawpost = 'Y' THEN
       CALL cl_err(' ','afa-101',0)
       RETURN
    END IF
   #start FUN-580109
    IF g_faw.faw04 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
   #end FUN-580109
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_faw01_t = g_faw.faw01
    LET g_faw_o.* = g_faw.*
    BEGIN WORK
 
    OPEN t104_cl USING g_faw.faw01
    IF STATUS THEN
       CALL cl_err("OPEN t104_cl:", STATUS, 1)
       CLOSE t104_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t104_cl INTO g_faw.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_faw.faw01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t104_cl ROLLBACK WORK RETURN
    END IF
    CALL t104_show()
    WHILE TRUE
        LET g_faw01_t = g_faw.faw01
        LET g_faw.fawmodu=g_user
        LET g_faw.fawdate=g_today
        CALL t104_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_faw.*=g_faw_t.*
            CALL t104_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        LET g_faw.faw04 = '0'   #FUN-580109
        IF g_faw.faw01 != g_faw_t.faw01 THEN
           UPDATE fax_file SET fax01=g_faw.faw01 WHERE fax01=g_faw_t.faw01
           IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#             CALL cl_err('upd fax01',SQLCA.SQLCODE,1)   #No.FUN-660136
              CALL cl_err3("upd","fax_file",g_faw_t.faw01,"",SQLCA.sqlcode,"","upd fax01",1)  #No.FUN-660136
              LET g_faw.*=g_faw_t.*
              CALL t104_show()
              CONTINUE WHILE
           END IF
        END IF
        UPDATE faw_file SET * = g_faw.*
         WHERE faw01 = g_faw.faw01
        IF SQLCA.SQLERRD[3] = 0 OR SQLCA.SQLCODE THEN
#          CALL cl_err(g_faw.faw01,SQLCA.SQLCODE,0)   #No.FUN-660136
           CALL cl_err3("upd","faw_file",g_faw01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
           CONTINUE WHILE
        END IF
       #start FUN-580109
        DISPLAY BY NAME g_faw.faw04
        IF g_faw.fawconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_faw.faw04 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        CALL cl_set_field_pic(g_faw.fawconf,g_chr2,g_faw.fawpost,"",g_chr,"")
       #end FUN-580109
        EXIT WHILE
    END WHILE
    CLOSE t104_cl
    COMMIT WORK
    CALL cl_flow_notify(g_faw.faw01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION t104_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1,   #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
         l_flag          LIKE type_file.chr1,   #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
         l_n1            LIKE type_file.num5,   #No.FUN-680070 SMALLINT
         l_bdate,l_edate LIKE type_file.dat     #No.FUN-680070 DATE
  DEFINE l_fau02         LIKE type_file.dat     #NO.MOD-890275
  DEFINE l_cnt           LIKE type_file.num10   #NO.MOD-9C0281 add
 
DEFINE li_result   LIKE type_file.num5          #No.FUN-680070 SMALLINT
    CALL cl_set_head_visible("","YES")          #No.FUN-6B0029
    INPUT BY NAME g_faw.faworiu,g_faw.faworig,
        g_faw.faw01,g_faw.faw02,g_faw.faw05,g_faw.faw03,#FUN-630045
        g_faw.fawconf,g_faw.fawpost,
        g_faw.fawmksg,g_faw.faw04,   #FUN-580109
        g_faw.fawuser,g_faw.fawgrup,g_faw.fawmodu,g_faw.fawdate
        #FUN-850068     ---start---
        ,g_faw.fawud01,g_faw.fawud02,g_faw.fawud03,g_faw.fawud04,
        g_faw.fawud05,g_faw.fawud06,g_faw.fawud07,g_faw.fawud08,
        g_faw.fawud09,g_faw.fawud10,g_faw.fawud11,g_faw.fawud12,
        g_faw.fawud13,g_faw.fawud14,g_faw.fawud15 
        #FUN-850068     ----end----
           WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t104_set_entry(p_cmd)
            CALL t104_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
#No.FUN-550034 --start--
            CALL cl_set_docno_format("faw01")
            CALL cl_set_docno_format("faw03")    #No.FUN-560060
#No.FUN-550034 ---end---
 
        AFTER FIELD faw01
           #IF NOT cl_null(g_faw.faw01) AND (g_faw.faw01!=g_faw01_t) THEN                         #MOD-740266 mark
            IF NOT cl_null(g_faw.faw01) AND (cl_null(g_faw01_t) OR g_faw.faw01!=g_faw01_t) THEN   #MOD-740266
#No.FUN-550034 --start--
    CALL s_check_no("afa",g_faw.faw01,g_faw01_t,"B","faw_file","faw01","")
         RETURNING li_result,g_faw.faw01
    DISPLAY BY NAME g_faw.faw01
       IF (NOT li_result) THEN
          NEXT FIELD faw01
       END IF
 
#No.FUN-560002 --start--
#              LET g_t1=g_faw.faw01[1,3]
#       CALL s_afaslip(g_t1,'B',g_sys)	    #檢查外送單別
#       IF NOT cl_null(g_errno) THEN	    #抱歉, 有問題
#          CALL cl_err(g_t1,g_errno,0)
#                 LET g_faw.faw01 = g_faw_o.faw01
#                 NEXT FIELD faw01
#       END IF
#
               SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1
#
#              IF p_cmd = 'a' THEN
#                 IF g_faw.faw01[1,5] IS NOT NULL  AND
#                    cl_null(g_faw.faw01[g_no_sp,g_no_ep]) AND g_fah.fahauno = 'N' THEN
#                    NEXT FIELD faw01
#                 ELSE
#                    NEXT FIELD faw02
#                 END IF
#              END IF
#              IF g_faw.faw01 != g_faw_t.faw01 OR g_faw_t.faw01 IS NULL THEN
#                  IF g_fah.fahauno = 'Y' AND NOT cl_chk_data_continue(g_faw.faw01[g_no_sp,g_no_ep]) THEN
#                     CALL cl_err('','9056',0)
#                     NEXT FIELD faw01
#                  END IF
#                  SELECT count(*) INTO g_cnt FROM faw_file
#                   WHERE faw01 = g_faw.faw01
#                  IF g_cnt > 0 THEN   #資料重複
#                      CALL cl_err(g_faw.faw01,-239,0)
#                      LET g_faw.faw01 = g_faw_t.faw01
#                      DISPLAY BY NAME g_faw.faw01
#                      NEXT FIELD faw01
#                  END IF
#              END IF
#
#No.FUN-560002 --end--
#No.FUN-550034 ---end--
            END IF
           #start FUN-580109 帶出單據別設定的"簽核否"值,狀況碼預設為0
            SELECT fahapr,'0' INTO g_faw.fawmksg,g_faw.faw04
              FROM fah_file
             WHERE fahslip = g_t1
            IF cl_null(g_faw.fawmksg) THEN            #FUN-640243
                 LET g_faw.fawmksg = 'N'
            END IF
            DISPLAY BY NAME g_faw.fawmksg,g_faw.faw04
           #end FUN-580109
            LET g_faw_o.faw01 = g_faw.faw01
 
        AFTER FIELD faw02
           IF NOT cl_null(g_faw.faw02) THEN
               CALL s_azn01(g_faa.faa07,g_faa.faa08) RETURNING l_bdate,l_edate
               IF g_faw.faw02 < l_bdate
               THEN CALL cl_err(g_faw.faw02,'afa-130',0)
                    NEXT FIELD faw02
               END IF
           END IF
          #start FUN-5B0018
           IF NOT cl_null(g_faw.faw02) THEN
              IF g_faw.faw02 <= g_faa.faa09 THEN
                 CALL cl_err('','mfg9999',1)
                 NEXT FIELD faw02
              END IF
           END IF
          #end FUN-5B0018
 
        #FUN-630045 
        AFTER FIELD faw05
            IF NOT cl_null(g_faw.faw05) THEN
               CALL t104_faw05('a')
               IF NOT cl_null(g_errno) THEN
                  LET g_faw.faw05 = g_faw_t.faw05
                  CALL cl_err(g_faw.faw05,g_errno,0)
                  DISPLAY BY NAME g_faw.faw05 #
                  NEXT FIELD faw05
               END IF
            ELSE
               DISPLAY '' TO FORMONLY.gen02
            END IF
        #END FUN-630045 
 
        AFTER FIELD faw03
              IF NOT cl_null(g_faw.faw03) THEN
              CALL t104_faw03('a')
                  IF NOT cl_null(g_errno) THEN
                     LET g_faw.faw03 = g_faw_t.faw03
                     DISPLAY BY NAME g_faw.faw03
                     NEXT FIELD faw03
                  END IF
                 #MOD-9C0281---add---start---
                  SELECT COUNT(*) INTO l_cnt FROM fax_file
                   WHERE fax01=g_faw.faw01
                     AND fax03 <> g_faw.faw03
                  IF l_cnt > 0 THEN
                     CALL cl_err('','afa-157',0)
                     NEXT FIELD faw03
                  END IF
                 #MOD-9C0281---add---end---
              END IF
              IF cl_null(g_faw.faw03) THEN
                 LET g_faw.faw03 = ' '
              END IF
              #MOD-890275--start--
              SELECT fau02 INTO l_fau02 from fau_file where fau01=g_faw.faw03
              IF g_faw.faw02<l_fau02 THEN
                 CALL cl_err('','afa-527',0)
                 NEXT FIELD faw03
              END IF
              #MOD-890275--end--
        #FUN-850068     ---start---
        AFTER FIELD fawud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fawud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fawud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fawud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fawud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fawud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fawud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fawud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fawud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fawud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fawud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fawud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fawud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fawud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fawud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-850068     ----end----
 
         AFTER INPUT  #97/05/22 modify
            LET g_faw.fawuser = s_get_data_owner("faw_file") #FUN-C10039
            LET g_faw.fawgrup = s_get_data_group("faw_file") #FUN-C10039
              IF INT_FLAG THEN EXIT INPUT END IF
 
       ON ACTION controlp
           CASE
              WHEN INFIELD(faw01)    #查詢單據性質
#                 LET g_t1=g_faw.faw01[1,3]
                  LET g_t1 = s_get_doc_no(g_faw.faw01)  #No.FUN-550034
                #CALL q_fah( FALSE, TRUE,g_t1,'B',g_sys) RETURNING g_t1  #TQC-670008
                CALL q_fah( FALSE, TRUE,g_t1,'B','AFA') RETURNING g_t1   #TQC-670008
#                 CALL FGL_DIALOG_SETBUFFER( g_t1 )
#                 LET g_faw.faw01[1,3]=g_t1
                 LET g_faw.faw01= g_t1  #No.FUN-550034
                 DISPLAY BY NAME g_faw.faw01 #
                 NEXT FIELD faw01
 #MOD-570146
##FUN-550129
#              WHEN INFIELD(faw03)    #查詢外送單號
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.state= "i"
#                 LET g_qryparam.form = "q_fau"
#                 CALL cl_create_qry() RETURNING g_faw.faw03
#                 DISPLAY BY NAME g_faw.faw03
#                 NEXT FIELD faw03
##END FUN-550129
              WHEN INFIELD(faw03)    #查詢外送單號
                 CALL q_fau1(FALSE,TRUE,'') RETURNING g_faw.faw03
                 DISPLAY BY NAME g_faw.faw03
                 NEXT FIELD faw03
 #END MOD-570146
              #FUN-630045
              WHEN INFIELD(faw05)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.default1 = g_faw.faw05
                   CALL cl_create_qry() RETURNING g_faw.faw05
#                   CALL FGL_DIALOG_SETBUFFER( g_faw.faw05 )
                   DISPLAY BY NAME g_faw.faw05
                   NEXT FIELD faw05
              #END FUN-630045
 
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #MOD-650015 --start 
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(faw01) THEN
       #         LET g_faw.* = g_faw_t.*
       #         LET g_faw.faw01 = ' '
       #         LET g_faw.fawconf = 'N'
       #         LET g_faw.fawpost = 'N'
       #         CALL t104_show()
       #         NEXT FIELD faw01
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
 
 
    END INPUT
END FUNCTION
FUNCTION t104_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("faw01",TRUE)
    END IF
 
END FUNCTION
FUNCTION t104_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("faw01",FALSE)
    END IF
END FUNCTION
 
FUNCTION t104_faw03(p_cmd)
 DEFINE   p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
          l_fau01    LIKE fau_file.fau01
 
    LET g_errno = ' '
 
    SELECT fau01 INTO l_fau01
      FROM fau_file
     WHERE fau01 = g_faw.faw03
       AND fauconf = 'Y'
       AND faupost = 'Y'
    CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno ='afa-102'
                                 LET l_fau01 = NULL
        OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
END FUNCTION
 
FUNCTION t104_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_faw.* TO NULL             #No.FUN-6A0001
   #MESSAGE ""
    CALL cl_msg("")                              #FUN-640243
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t104_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_faw.* TO NULL
       RETURN
    END IF
   #MESSAGE " SEARCHING ! "
    CALL cl_msg(" SEARCHING ! ")                 #FUN-640243
    OPEN t104_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_faw.* TO NULL
    ELSE
        OPEN t104_count
        FETCH t104_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t104_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
   #MESSAGE ""
    CALL cl_msg("")                              #FUN-640243
 
END FUNCTION
 
FUNCTION t104_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t104_cs INTO g_faw.faw01
        WHEN 'P' FETCH PREVIOUS t104_cs INTO g_faw.faw01
        WHEN 'F' FETCH FIRST    t104_cs INTO g_faw.faw01
        WHEN 'L' FETCH LAST     t104_cs INTO g_faw.faw01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump t104_cs INTO g_faw.faw01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_faw.faw01,SQLCA.sqlcode,0)
        INITIALIZE g_faw.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_faw.* FROM faw_file WHERE faw01 = g_faw.faw01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_faw.faw01,SQLCA.sqlcode,0)   #No.FUN-660136
        CALL cl_err3("sel","faw_file",g_faw.faw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
        INITIALIZE g_faw.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_faw.fawuser   #FUN-4C0059
    LET g_data_group = g_faw.fawgrup   #FUN-4C0059
    CALL t104_show()
END FUNCTION
 
FUNCTION t104_show()
    LET g_faw_t.* = g_faw.*                #保存單頭舊值
    DISPLAY BY NAME g_faw.faworiu,g_faw.faworig,
        g_faw.faw01,g_faw.faw02,g_faw.faw05,g_faw.faw03,#FUN-630045
        g_faw.fawconf,g_faw.fawpost,
        g_faw.fawmksg,g_faw.faw04,   #FUN-580109 增加簽核,狀況碼
        g_faw.fawuser,g_faw.fawgrup,g_faw.fawmodu,g_faw.fawdate
        #FUN-850068     ---start---
        ,g_faw.fawud01,g_faw.fawud02,g_faw.fawud03,g_faw.fawud04,
        g_faw.fawud05,g_faw.fawud06,g_faw.fawud07,g_faw.fawud08,
        g_faw.fawud09,g_faw.fawud10,g_faw.fawud11,g_faw.fawud12,
        g_faw.fawud13,g_faw.fawud14,g_faw.fawud15 
        #FUN-850068     ----end----
    CALL t104_b_fill(g_wc2)
    CALL cl_set_field_pic("","","","","","")
    IF g_faw.fawconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   #start FUN-580109
    IF g_faw.faw04 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   #CALL cl_set_field_pic(g_faw.fawconf,"",g_faw.fawpost,"",g_chr,"")
    CALL cl_set_field_pic(g_faw.fawconf,g_chr2,g_faw.fawpost,"",g_chr,"")
   #end FUN-580109
    CALL t104_faw05('d')                      #FUN-630045
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t104_r()
 DEFINE l_chr,l_sure LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_faw.faw01 IS NULL THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    SELECT * INTO g_faw.* FROM faw_file WHERE faw01 = g_faw.faw01
    IF g_faw.fawconf = 'X' THEN
       CALL cl_err(' ','9024',0)
       RETURN
    END IF
    IF g_faw.fawconf = 'Y' THEN
       CALL cl_err('','afa-096',0) RETURN
    END IF
    IF g_faw.fawpost = 'Y' THEN
       CALL cl_err(' ','afa-101',0) RETURN
    END IF
   #start FUN-580109
    IF g_faw.faw04 matches '[Ss1]' THEN
       CALL cl_err('','mfg3557',0)
       RETURN
    END IF
   #end FUN-580109
    BEGIN WORK
 
    OPEN t104_cl USING g_faw.faw01
    IF STATUS THEN
       CALL cl_err("OPEN t104_cl:", STATUS, 1)
       CLOSE t104_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t104_cl INTO g_faw.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_faw.faw01,SQLCA.sqlcode,0)
       CLOSE t104_cl ROLLBACK WORK RETURN
    END IF
    CALL t104_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "faw01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_faw.faw01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete faw,fax!"
        DELETE FROM faw_file WHERE faw01 = g_faw.faw01
        IF SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err('No faw deleted',SQLCA.SQLCODE,0)   #No.FUN-660136
           CALL cl_err3("del","faw_file",g_faw.faw01,"",SQLCA.sqlcode,"","No faw deleted",1)  #No.FUN-660136
        ELSE
           DELETE FROM fax_file WHERE fax01 = g_faw.faw01
           CLEAR FORM
           CALL g_fax.clear()
           CALL g_fax.clear()
           INITIALIZE g_faw.* LIKE faw_file.*
           OPEN t104_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE t104_cs
             CLOSE t104_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
           FETCH t104_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE t104_cs
             CLOSE t104_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
           DISPLAY g_row_count TO FORMONLY.cnt
           OPEN t104_cs
           IF g_curs_index = g_row_count + 1 THEN
              LET g_jump = g_row_count
              CALL t104_fetch('L')
           ELSE
              LET g_jump = g_curs_index
              LET mi_no_ask = TRUE
              CALL t104_fetch('/')
           END IF
 
        END IF
    END IF
    CLOSE t104_cl
    COMMIT WORK
    CALL cl_flow_notify(g_faw.faw01,'D')
END FUNCTION
 
FUNCTION t104_b()
DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
       l_row,l_col     LIKE type_file.num5,  		   #分段輸入之行,列數       #No.FUN-680070 SMALLINT
       l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
       l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
       l_b2      	    LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
       l_faj06         LIKE faj_file.faj06,
       l_faj18         LIKE faj_file.faj18,
       l_qty	       LIKE type_file.num20_6,      #No.FUN-680070 DECIMAL(15,3)
       l_flag          LIKE type_file.num10,        #No.FUN-680070 INTEGER
       l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
       l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
DEFINE l_faw04         LIKE faw_file.faw04    #FUN-580109
DEFINE l_fau02         LIKE type_file.dat     #MOD-890275
 
    LET g_action_choice = ""
    LET l_faw04 = g_faw.faw04   #FUN-580109
    IF g_faw.faw01 IS NULL THEN RETURN END IF
    IF g_faw.fawconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
    IF g_faw.fawconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    IF g_faw.fawpost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF
   #start FUN-580109
    IF g_faw.faw04 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
   #end FUN-580109
    CALL cl_opmsg('b')
 
    #No:A099
    #LET g_forupd_sql = "SELECT fax02,fax03,fax04,fax05,fax051,'','',fax08,", #No.FUN-B80081 mark
    LET g_forupd_sql = "SELECT fax02,fax03,fax04,fax05,fax051,'','',",  #No.FUN-B80081 add,移除fax08
                       "       fax06,fax07 ",            #end No:A099
                       "  FROM fax_file  ",
                       " WHERE fax01 = ? ",
                       " AND fax02 = ? ",
                        " FOR UPDATE "              #No.MOD-490098
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t104_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
   #CKP2
   IF g_rec_b=0 THEN CALL g_fax.clear() END IF
 
 
      INPUT ARRAY g_fax WITHOUT DEFAULTS FROM s_fax.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
#           DISPLAY l_ac TO FORMONLY.cn3
           #LET g_fax_t.* = g_fax[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
	    BEGIN WORK
 
            OPEN t104_cl USING g_faw.faw01
            IF STATUS THEN
               CALL cl_err("OPEN t104_cl:", STATUS, 1)
               CLOSE t104_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t104_cl INTO g_faw.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_faw.faw01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t104_cl ROLLBACK WORK RETURN
            END IF
 
           #IF g_fax[l_ac].fax02 IS NOT NULL THEN
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_fax_t.* = g_fax[l_ac].*  #BACKUP
 
                OPEN t104_bcl USING g_faw.faw01,g_fax_t.fax02
                IF STATUS THEN
                   CALL cl_err("OPEN t104_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                   FETCH t104_bcl INTO g_fax[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock fax',SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE SELECT faj06,faj18
                          INTO g_fax[l_ac].faj06,g_fax[l_ac].faj18
                          FROM faj_file
                         WHERE faj02  = g_fax[l_ac].fax05
                           AND faj022 = g_fax[l_ac].fax051
                        IF SQLCA.sqlcode THEN
                           LET g_fax[l_ac].faj06 = ' '
                           LET g_fax[l_ac].faj18 = ' '
                        END IF
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
           #LET g_fax_t.* = g_fax[l_ac].*  #BACKUP
           #NEXT FIELD fax02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_fax[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_fax[l_ac].* TO s_fax.*
              CALL g_fax.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
               CANCEL INSERT
            END IF
            IF cl_null(g_fax[l_ac].fax07) THEN
               LET g_fax[l_ac].fax07 = 0
            END IF
            #No:A099
            #-----TQC-620120---------
            IF cl_null(g_fax[l_ac].fax051) THEN
               LET g_fax[l_ac].fax051 = ' '
            END IF
            #-----END TQC-620120-----
            INSERT INTO fax_file(fax01,fax02,fax03,fax04,fax05,fax051,
                                 #fax06,fax07,fax08 #No.FUN-B80081 mark
                                 fax06,fax07  #No.FUN-B80081 add,移除fax08
                                #No.FUN-850068 --start--
                                ,faxud01,faxud02,faxud03,faxud04,faxud05,
                                faxud06,faxud07,faxud08,faxud09,faxud10,
                                faxud11,faxud12,faxud13,faxud14,faxud15,
                                #No.FUN-850068 ---end---
                                 faxlegal) #FUN-980003 add
             VALUES(g_faw.faw01,g_fax[l_ac].fax02,
                    g_fax[l_ac].fax03,g_fax[l_ac].fax04,
                    g_fax[l_ac].fax05,g_fax[l_ac].fax051,
                    g_fax[l_ac].fax06,g_fax[l_ac].fax07,
                    #g_fax[l_ac].fax08 #No.FUN-B80081 mark
                    #No.FUN-850068 --start--
                    g_fax[l_ac].faxud01,g_fax[l_ac].faxud02,g_fax[l_ac].faxud03,
                    g_fax[l_ac].faxud04,g_fax[l_ac].faxud05,g_fax[l_ac].faxud06,
                    g_fax[l_ac].faxud07,g_fax[l_ac].faxud08,g_fax[l_ac].faxud09,
                    g_fax[l_ac].faxud10,g_fax[l_ac].faxud11,g_fax[l_ac].faxud12,
                    g_fax[l_ac].faxud13,g_fax[l_ac].faxud14,g_fax[l_ac].faxud15,
                         #No.FUN-850068 ---end---
                    g_legal) #FUN-980003 add
            #end No:A099
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0  THEN
#              CALL cl_err('ins fax',SQLCA.sqlcode,0)   #No.FUN-660136
               CALL cl_err3("ins","fax_file",g_faw.faw01,g_fax[l_ac].fax02,SQLCA.sqlcode,"","ins fax",1)  #No.FUN-660136
              #LET g_fax[l_ac].* = g_fax_t.*
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET l_faw04 = '0'   #FUN-580109
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd = 'a'
            INITIALIZE g_fax[l_ac].* TO NULL      #900423
            #LET g_fax[l_ac].fax08 = 'N'           #No:A099 #No.FUN-B80081 mark
            LET g_fax_t.* = g_fax[l_ac].*             #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fax02
 
        BEFORE FIELD fax02                            #defawlt 序號
            IF p_cmd = 'a' OR p_cmd = 'u' THEN
              IF g_fax[l_ac].fax02 IS NULL OR g_fax[l_ac].fax02 = 0 THEN
                  SELECT max(fax02)+1 INTO g_fax[l_ac].fax02
                     FROM fax_file WHERE fax01 = g_faw.faw01
                  IF g_fax[l_ac].fax02 IS NULL THEN
                      LET g_fax[l_ac].fax02 = 1
                  END IF
              END IF
            END IF
 
        AFTER FIELD fax02                        #check 序號是否重複
            IF NOT cl_null(g_fax[l_ac].fax02) THEN
               IF g_fax[l_ac].fax02 != g_fax_t.fax02 OR
                  g_fax_t.fax02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM fax_file
                    WHERE fax01 = g_faw.faw01
                      AND fax02 = g_fax[l_ac].fax02
                   IF l_n > 0 THEN
                       LET g_fax[l_ac].fax02 = g_fax_t.fax02
                       CALL cl_err('',-239,0)
                       NEXT FIELD fax02
                   END IF
               END IF
            END IF
 
        AFTER FIELD fax03
            IF not cl_null(g_fax[l_ac].fax03) THEN
              #MOD-9C0281---add---start---
               IF not cl_null(g_faw.faw03) THEN
                  IF g_faw.faw03 <> g_fax[l_ac].fax03 THEN
                     CALL cl_err('','afa-157',1)
                     NEXT FIELD fax03
                  END IF
               END IF
              #MOD-9C0281---add---end
               SELECT COUNT(*) INTO g_cnt FROM fav_file
                WHERE fav01 = g_fax[l_ac].fax03
                 IF g_cnt = 0 THEN
                    CALL cl_err(g_fax[l_ac].fax03,'afa-102',0)
                    LET g_fax[l_ac].fax03 = g_fax_t.fax03
                    NEXT FIELD fax03
                 END IF
            END IF
            #MOD-890275 --start
            SELECT fau02 INTO l_fau02 from fau_file where fau01=g_fax[l_ac].fax03
            IF g_faw.faw02<l_fau02 THEN
               CALL cl_err('','afa-527',0)
               NEXT FIELD fax03
            END IF
            #MOD-890275--end--
 
        AFTER FIELD fax04
           IF NOT cl_null(g_fax[l_ac].fax04) THEN
              SELECT COUNT(*) INTO g_cnt FROM fav_file
               WHERE fav01 = g_fax[l_ac].fax03
                 AND fav02 = g_fax[l_ac].fax04
                IF g_cnt = 0 THEN
                   CALL cl_err(g_fax[l_ac].fax04,'afa-102',0)
                   LET g_fax[l_ac].fax04 = g_fax_t.fax04
                   NEXT FIELD fax04
                END IF
                CALL t104_fax04('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fax[l_ac].fax04,g_errno,0)
                  LET g_fax[l_ac].fax04 = g_fax_t.fax04
                  NEXT FIELD fax04
               END IF
           END IF
 
        AFTER FIELD fax07
           IF NOT cl_null(g_fax[l_ac].fax07) THEN
              IF g_fax[l_ac].fax07 > g_fax[l_ac].fax06 THEN
                 CALL cl_err(g_fax[l_ac].fax07,'afa-104',0)
                 NEXT FIELD fax07
              END IF
              #No.TQC-770108 --start--   #TQC-A40039
             #IF g_fax[l_ac].fax07 < 0 THEN  #TQC-A40039
              IF g_fax[l_ac].fax07 <= 0 THEN #TQC-A40039
                 CALL cl_err('','mfg4012',0)
                 NEXT FIELD fax07
              END IF
              #No.TQC-770108 --end--
           END IF
 
        #No.FUN-850068 --start--
        AFTER FIELD faxud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faxud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faxud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faxud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faxud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faxud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faxud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faxud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faxud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faxud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faxud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faxud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faxud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faxud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD faxud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-850068 ---end---
        BEFORE DELETE                            #是否取消單身
            IF g_fax_t.fax02 > 0 AND g_fax_t.fax02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                # genero shell add start
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                # genero shell add end
                DELETE FROM fax_file
                 WHERE fax01 = g_faw.faw01
                   AND fax02 = g_fax_t.fax02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_fax_t.fax02,SQLCA.sqlcode,0)   #No.FUN-660136
                    CALL cl_err3("del","fax_file",g_faw.faw01,g_fax_t.fax02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET l_faw04 = '0'   #FUN-580109
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fax[l_ac].* = g_fax_t.*
               CLOSE t104_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fax[l_ac].fax02,-263,1)
               LET g_fax[l_ac].* = g_fax_t.*
            ELSE
               UPDATE fax_file SET
                      fax01=g_faw.faw01,fax02=g_fax[l_ac].fax02,
                      fax03=g_fax[l_ac].fax03,fax04=g_fax[l_ac].fax04,
                      fax05=g_fax[l_ac].fax05,fax051=g_fax[l_ac].fax051,
                      fax06=g_fax[l_ac].fax06,fax07=g_fax[l_ac].fax07,
                      #fax08=g_fax[l_ac].fax08      #No:A099 #No.FUN-B80081 mark
                      #No.FUN-850068 --start--
                      faxud01 = g_fax[l_ac].faxud01,
                      faxud02 = g_fax[l_ac].faxud02,
                      faxud03 = g_fax[l_ac].faxud03,
                      faxud04 = g_fax[l_ac].faxud04,
                      faxud05 = g_fax[l_ac].faxud05,
                      faxud06 = g_fax[l_ac].faxud06,
                      faxud07 = g_fax[l_ac].faxud07,
                      faxud08 = g_fax[l_ac].faxud08,
                      faxud09 = g_fax[l_ac].faxud09,
                      faxud10 = g_fax[l_ac].faxud10,
                      faxud11 = g_fax[l_ac].faxud11,
                      faxud12 = g_fax[l_ac].faxud12,
                      faxud13 = g_fax[l_ac].faxud13,
                      faxud14 = g_fax[l_ac].faxud14,
                      faxud15 = g_fax[l_ac].faxud15
                      #No.FUN-850068 ---end---
               WHERE fax01=g_faw.faw01 AND fax02=g_fax_t.fax02
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#                 CALL cl_err('upd fax',SQLCA.sqlcode,0)   #No.FUN-660136
                  CALL cl_err3("upd","fax_file",g_faw.faw01,g_fax_t.fax02,SQLCA.sqlcode,"","upd fax",1)  #No.FUN-660136
                  LET g_fax[l_ac].* = g_fax_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  LET l_faw04 = '0'   #FUN-580109
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_fax[l_ac].* = g_fax_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_fax.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE t104_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac #FUN-D30032 add
           #LET g_fax_t.* = g_fax[l_ac].*  #FUN-D30032 mark
            CLOSE t104_bcl
            COMMIT WORK
            #CKP2
           #CALL g_fax.deleteElement(g_rec_b+1) #FUN-D30032 mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fax02) AND l_ac > 1 THEN
                LET g_fax[l_ac].* = g_fax[l_ac-1].*
                LET g_fax[l_ac].fax02 = NULL
                NEXT FIELD fax02
            END IF
        ON ACTION controlp
           CASE
              WHEN INFIELD(fax03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fav"
                 #CHI-A50036 add --start--
                 IF g_faw.faw03 <> ' ' THEN
                    LET g_qryparam.where = "fau01='",g_faw.faw03,"'"
                 END IF
                 #CHI-A50036 add --end--
                 LET g_qryparam.default1 = g_fax[l_ac].fax03
                 CALL cl_create_qry() RETURNING g_fax[l_ac].fax03,
                                      g_fax[l_ac].fax04, g_fax[l_ac].fax05
#                 CALL FGL_DIALOG_SETBUFFER( g_fax[l_ac].fax03 )
#                 CALL FGL_DIALOG_SETBUFFER( g_fax[l_ac].fax04 )
#                 CALL FGL_DIALOG_SETBUFFER(  g_fax[l_ac].fax05 )
                 SELECT fav031,faj06 INTO g_fax[l_ac].fax051, g_fax[l_ac].faj06
                   FROM fav_file LEFT OUTER JOIN faj_file ON fav03 = faj02 AND fav031 = faj022
                  WHERE fav01 = g_fax[l_ac].fax03 AND fav02 = g_fax[l_ac].fax04
                 DISPLAY g_fax[l_ac].fax03 TO fax03
                 DISPLAY g_fax[l_ac].fax04 TO fax04
                 DISPLAY g_fax[l_ac].fax05 TO fax05
                 DISPLAY g_fax[l_ac].fax051 TO fax051
                 DISPLAY g_fax[l_ac].faj06 TO faj06
                 CALL t104_fax04('d')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(' ',g_errno,0)
                    NEXT FIELD fax03
                 END IF
                 NEXT FIELD fax03
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
#No.FUN-6B0029--begin                                             
        ON ACTION controls                                        
           CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end  
    END INPUT
 
   #start FUN-5A0029
    LET g_faw.fawmodu = g_user
    LET g_faw.fawdate = g_today
    UPDATE faw_file SET fawmodu = g_faw.fawmodu,fawdate = g_faw.fawdate
     WHERE faw01 = g_faw.faw01
    DISPLAY BY NAME g_faw.fawmodu,g_faw.fawdate
   #end FUN-5A0029
 
   #start FUN-580109
    UPDATE faw_file SET faw04=l_faw04 WHERE faw01 = g_faw.faw01
    LET g_faw.faw04 = l_faw04
    DISPLAY BY NAME g_faw.faw04
    IF g_faw.fawconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_faw.faw04 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    CALL cl_set_field_pic(g_faw.fawconf,g_chr2,g_faw.fawpost,"",g_chr,"")
   #end FUN-580109
 
    CLOSE t104_bcl
    COMMIT WORK
    CALL t104_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t104_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_faw.faw01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM faw_file ",
                  "  WHERE faw01 LIKE '",l_slip,"%' ",
                  "    AND faw01 > '",g_faw.faw01,"'"
      PREPARE t104_pb1 FROM l_sql 
      EXECUTE t104_pb1 INTO l_cnt 
      
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
        #CALL t104_x()            #FUN-D20035
         CALL t104_x(1)           #FUN-D20035
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM faw_file WHERE faw01 = g_faw.faw01
         INITIALIZE g_faw.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t104_fax04(p_cmd)
 DEFINE   p_cmd          LIKE type_file.chr1,  #No.FUN-680070 VARCHAR(1)
          l_cnt          LIKE type_file.num5,  #No.FUN-680070 SMALLINT
          l_fav03        LIKE fav_file.fav03,
          l_fav031       LIKE fav_file.fav031,
          l_faj06        LIKE faj_file.faj06,
          l_faj18        LIKE faj_file.faj18,
          l_cnt2         LIKE type_file.num5  #MOD-730083
         #l_fav08        LIKE fav_file.fav08   #MOD-B30123 add #No.FUN-B80081 mark
 
 
    LET g_errno = ' '
    #SELECT fav03,fav031,faj06,faj18,fav04-fav07,fav08       #MOD-B30123 add fav08 #No.FUN-B80081 mark 
    SELECT fav03,fav031,faj06,faj18,fav04-fav07       #MOD-B30123 add fav08 #No.FUN-B80081 add,移除fav08 
     #INTO l_fav03,l_fav031,l_faj06,l_faj18,l_cnt,l_fav08   #MOD-B30123 add l_fav08 #No.FUN-B80081 mark
      INTO l_fav03,l_fav031,l_faj06,l_faj18,l_cnt   #MOD-B30123 add l_fav08 #No.FUN-B80081 add,移除l_fav08
      FROM fav_file,fau_file,faj_file
     WHERE fav01 = g_fax[l_ac].fax03
       AND fav02 = g_fax[l_ac].fax04
       AND (fav04-fav07 > 0 )
       AND fav01 = fau01
       AND fauconf = 'Y'
       AND faupost = 'Y'
       AND fav03 = faj02
       AND fav031 = faj022
    CASE
        WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-102'
                                 LET l_fav03  = NULL
                                 LET l_fav031 = NULL
                                 LET l_faj06  = NULL
                                 LET l_faj18  = NULL
                                 LET l_cnt    = NULL
                                #LET l_fav08  = NULL   #MOD-B30123 add #No.FUN-B80081 mark 
        OTHERWISE  LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    #-----MOD-720074---------
    #SELECT COUNT(*) INTO l_cnt FROM fca_file   #MOD-730083
    SELECT COUNT(*) INTO l_cnt2 FROM fca_file   #MOD-730083
     WHERE fca03  = l_fav03
       AND fca031 = l_fav031
       AND fca15  = 'N'
    #IF l_cnt > 0 THEN   #MOD-730083
    IF l_cnt2 > 0 THEN   #MOD-730083
       LET g_errno = 'afa-097'
       LET l_fav03  = NULL
       LET l_fav031 = NULL
       LET l_faj06  = NULL
       LET l_faj18  = NULL
       LET l_cnt    = NULL
      #LET l_fav08  = NULL   #MOD-B30123 add #No.FUN-B80081 mark
    END IF
    #-----END MOD-720074-----
    IF p_cmd = 'a' THEN
       LET g_fax[l_ac].fax05  = l_fav03
       LET g_fax[l_ac].fax051 = l_fav031
       LET g_fax[l_ac].fax06  = l_cnt
       LET g_fax[l_ac].faj06  = l_faj06
       LET g_fax[l_ac].faj18  = l_faj18
      #LET g_fax[l_ac].fax08  = l_fav08   #MOD-B30123 add #No.FUN-B80081 mark
    END IF
END FUNCTION
 
{
FUNCTION t104_delall()
 
   SELECT COUNT(*) INTO g_cnt FROM fax_file
    WHERE fax01 = g_faw.faw01
   IF g_cnt = 0 THEN
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM faw_file
       WHERE faw01 = g_faw.faw01
   END IF
END FUNCTION
}
 
FUNCTION t104_b_askkey()
#DEFINE l_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
DEFINE l_wc2           STRING     #TQC-630166
 
    #No:A099
    #CONSTRUCT l_wc2 ON fax02,fax03,fax04,fax05,fax051,fax08,fax06,fax07, #No.FUN-B80081 mark 
    CONSTRUCT l_wc2 ON fax02,fax03,fax04,fax05,fax051,fax06,fax07, #No.FUN-B80081 add,移除fax08
                       faj06,faj18
         FROM s_fax[1].fax02,s_fax[1].fax03,s_fax[1].fax04,
             #s_fax[1].fax05,s_fax[1].fax051,s_fax[1].fax08, #No.FUN-B80081 mark
              s_fax[1].fax05,s_fax[1].fax051,                #No.FUN-B80081 add,移除fax08
              s_fax[1].fax06,s_fax[1].fax07,s_fax[1].faj06,s_fax[1].faj18
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
    CALL t104_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t104_b_fill(p_wc2)              #BODY FILL UP
#DEFINE p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
DEFINE p_wc2           STRING            #TQC-630166
 
    #No:A099
    LET g_sql =
       #"SELECT fax02,fax03,fax04,fax05,fax051,faj06,faj18,fax08,fax06,fax07", #No.FUN-B80081 mark 
        "SELECT fax02,fax03,fax04,fax05,fax051,faj06,faj18,fax06,fax07", #No.FUN-B80081 add,移除fax08
        #No.FUN-850068 --start--
        "       ,faxud01,faxud02,faxud03,faxud04,faxud05,",
        "       faxud06,faxud07,faxud08,faxud09,faxud10,",
        "       faxud11,faxud12,faxud13,faxud14,faxud15", 
        #No.FUN-850068 ---end---
        "  FROM fax_file LEFT OUTER JOIN faj_file ON fax05 = faj02 AND fax051 = faj022",
        " WHERE fax01  ='",g_faw.faw01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE t104_pb FROM g_sql
    DECLARE fax_curs                       #SCROLL CURSOR
        CURSOR FOR t104_pb
 
    CALL g_fax.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fax_curs INTO g_fax[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_fax.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t104_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fax TO s_fax.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t104_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t104_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t104_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t104_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t104_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
     
     #No.TQC-760182--begin-- 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
     #No.TQC-760182--end--
 
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
         CALL cl_set_field_pic("","","","","","")
         IF g_faw.fawconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        #start FUN-580109
         IF g_faw.fawconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_faw.faw04 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        #CALL cl_set_field_pic(g_faw.fawconf,"",g_faw.fawpost,"",g_chr,"")
         CALL cl_set_field_pic(g_faw.fawconf,g_chr2,g_faw.fawpost,"",g_chr,"")
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
 
 
{FUNCTION t104_out()
DEFINE
    l_i             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    sr              RECORD
        faw00       LIKE faw_file.faw00,   #
        faw01       LIKE faw_file.faw01,   #
        faw02       LIKE faw_file.faw02,   #
        faw03       LIKE faw_file.faw03,   #
        faw14       LIKE faw_file.faw14,   #
        faw15       LIKE faw_file.faw15,   #
        faw52       LIKE faw_file.faw52
                    END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name       #No.FUN-680070 VARCHAR(20)
    l_za05          LIKE type_file.chr1000              #       #No.FUN-680070 VARCHAR(40)
 
    IF g_wc IS NULL THEN
    #  CALL cl_err('',-400,0) RETURN END IF
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    CALL cl_outnam('afat104') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'afat104'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET g_sql="SELECT faw00,faw01,faw02,faw03,faw14,faw15,faw52",
              " FROM faw_file",
              " WHERE ",g_wc CLIPPED,
              " ORDER BY 1"
    PREPARE t104_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t104_co                         # SCROLL CURSOR
         CURSOR FOR t104_p1
 
    START REPORT t104_rep TO l_name
 
    FOREACH t104_co INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        OUTPUT TO REPORT t104_rep(sr.*)
    END FOREACH
 
    FINISH REPORT t104_rep
 
    CLOSE t104_co
    ERROR ""
    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
 
REPORT t104_rep(sr)
 DEFINE
    l_trailer_sw    LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
    l_i             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    sr              RECORD
        faw00       LIKE faw_file.faw00,   #
        faw01       LIKE faw_file.faw01,   #
        faw02       LIKE faw_file.faw02,   #
        faw03       LIKE faw_file.faw03,   #
        faw14       LIKE faw_file.faw14,   #
        faw15       LIKE faw_file.faw15,   #
        faw52       LIKE faw_file.faw52
                    END RECORD
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 
    ORDER BY sr.faw01
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
            PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
            PRINT ' '
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                COLUMN g_len-7,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            PRINT ' -----   -     ----- --------------------',
                  ' ------------------------------'
            LET l_trailer_sw = 'y'
 
        ON EVERY ROW
           PRINT sr.faw00,' ', sr.faw01,' ', sr.faw02,' ', sr.faw03,' ',
                 sr.faw14,' ', sr.faw15,' ', sr.faw52
 
        ON LAST ROW
            PRINT g_dash[1,g_len]
            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
               THEN 
                   #TQC-630166
                   #IF g_wc[001,080] > ' ' THEN
	           #   PRINT g_x[8] CLIPPED,g_wc[001,070] CLIPPED END IF
                   #IF g_wc[071,140] > ' ' THEN
	           #   PRINT COLUMN 10,     g_wc[071,140] CLIPPED END IF
                   #IF g_wc[141,210] > ' ' THEN
	           #   PRINT COLUMN 10,     g_wc[141,210] CLIPPED END IF
                   #PRINT g_dash[1,g_len]
                   CALL cl_prt_pos_wc(g_wc)  
            END IF
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
            LET l_trailer_sw = 'n'
 
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT}
 
#------外送單號存在外送檔中,自動將未收回數量之資料新增至單身-----
FUNCTION t104_g()
#DEFINE  l_wc        LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(300)
#        l_sql       LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(400)
 DEFINE  l_wc        STRING,     #TQC-630166
         l_sql       STRING,     #TQC-630166
         l_fav       RECORD
               fav01     LIKE fav_file.fav01,
               fav02     LIKE fav_file.fav02,
               fav03     LIKE fav_file.fav03,
               fav031    LIKE fav_file.fav031,
               fax06     LIKE fax_file.fax06,
               fav07     LIKE fav_file.fav07,
              #fav08     LIKE fav_file.fav08,     #NO:A099 #No.FUN-B80081 mark
               faj06     LIKE faj_file.faj06,
               faj18     LIKE faj_file.faj18
               END RECORD,
         i           LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
   IF s_shut(0) THEN RETURN END IF
      LET l_sql ="SELECT fav01,fav02,fav03,fav031,fav04-fav07,",
                #" fav07,fav08,faj06,faj18",         #NO:A099 #No.FUN-B80081 mark
                 " fav07,faj06,faj18",         #NO:A099 #No.FUN-B80081 add,移除fav08   
                 "  FROM fav_file,faj_file,fau_file",
                 " WHERE fav03  = faj02",
                 "   AND fav031 = faj022",
                 "   AND (fav04-fav07) > 0 ",
                 "   AND fav01=fau01 ",     #no:5825
                 "   AND faupost='Y' ",     #no:5825
                 "   AND fav01 = '",g_faw.faw03,"'",
                 " ORDER BY 1"
     PREPARE t104_prepare_g FROM l_sql
     IF SQLCA.SQLCODE != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,0)
        RETURN
     END IF
     LET l_wc = ' 1=1'
     DECLARE t104_curs2 CURSOR FOR t104_prepare_g
 
     SELECT MAX(fax02)+1 INTO i FROM fax_file
      WHERE fax01 = g_faw.faw01
     IF STATUS THEN
#       CALL cl_err(' ',STATUS,0)   #No.FUN-660136
        CALL cl_err3("sel","fax_file",g_faw.faw01,"",STATUS,"","",1)  #No.FUN-660136
     END IF
     IF cl_null(i) THEN
        LET i = 1
     END IF
     FOREACH t104_curs2 INTO l_fav.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,0)
          EXIT FOREACH
       END IF
       #no:4532檢查資產盤點期間應不可做異動
       SELECT COUNT(*) INTO g_cnt FROM fca_file
        WHERE fca03  = l_fav.fav03
          AND fca031 = l_fav.fav031
          AND fca15  = 'N'
           IF g_cnt > 0 THEN
              CONTINUE FOREACH
           END IF
       #no:4532
 
       #NO:A099
       #-----TQC-620120---------
       IF cl_null(l_fav.fav031) THEN
          LET l_fav.fav031 = ' '
       END IF
       #-----END TQC-620120-----
       INSERT INTO fax_file (fax01,fax02,fax03,fax04,fax05,fax051,fax06,fax07,
                            #fax08,faxlegal) #FUN-980003 add #No.FUN-B80081 mark
                             faxlegal) #No.FUN-B80081 add,移除fax08 
                    VALUES  (g_faw.faw01,i,l_fav.fav01,l_fav.fav02,l_fav.fav03,
                             l_fav.fav031,l_fav.fax06,l_fav.fav07,
                            #l_fav.fav08,g_legal) #FUN-980003 add #No.FUN-B80081 mark  
                             g_legal) #FUN-980003 add #No.FUN-B80081 add,移除l_fav.fav08
       #end NO:A099
       IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#         CALL cl_err('ins fax',STATUS,1)   #No.FUN-660136
          CALL cl_err3("ins","fax_file",g_faw.faw01,i,STATUS,"","ins fax",1)  #No.FUN-660136
          EXIT FOREACH
       END IF
       LET i = i + 1
     END FOREACH
     CALL t104_b_fill(l_wc)
END FUNCTION
 
FUNCTION t104_y() 			# when g_faw.fawconf='N' (Turn to 'Y')
DEFINE l_cnt LIKE type_file.num5         #No.FUN-680070 SMALLINT
   SELECT * INTO g_faw.* FROM faw_file WHERE faw01 = g_faw.faw01
   IF g_faw.fawconf='Y' THEN RETURN END IF
   IF g_faw.fawconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   #bugno:7341 add......................................................
   SELECT COUNT(*) INTO l_cnt FROM fax_file
    WHERE fax01= g_faw.faw01
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   #bugno:7341 end......................................................
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   BEGIN WORK
 
    OPEN t104_cl USING g_faw.faw01
    IF STATUS THEN
       CALL cl_err("OPEN t104_cl:", STATUS, 1)
       CLOSE t104_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t104_cl INTO g_faw.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_faw.faw01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t104_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   UPDATE faw_file SET fawconf = 'Y' WHERE faw01 = g_faw.faw01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd fawconf',STATUS,1)   #No.FUN-660136
      CALL cl_err3("upd","faw_file",g_faw.faw01,"",STATUS,"","upd fawconf",1)  #No.FUN-660136
      LET g_success = 'N'
   END IF
   CLOSE t104_cl
   IF g_success = 'Y' THEN
      LET g_faw.fawconf='Y'
      COMMIT WORK
      DISPLAY BY NAME g_faw.fawconf
      CALL cl_flow_notify(g_faw.faw01,'Y')
  ELSE
      LET g_faw.fawconf='N'
      ROLLBACK WORK
  END IF
  CALL cl_set_field_pic("","","","","","")
  IF g_faw.fawconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  #start FUN-580109
   IF g_faw.faw04 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
  #CALL cl_set_field_pic(g_faw.fawconf,"",g_faw.fawpost,"",g_chr,"")
   CALL cl_set_field_pic(g_faw.fawconf,g_chr2,g_faw.fawpost,"",g_chr,"")
  #end FUN-580109
END FUNCTION
 
#start FUN-580109
FUNCTION t104_y_chk()
  DEFINE l_cnt  LIKE type_file.num5      #No.FUN-680070 SMALLINT
  DEFINE l_fax  RECORD LIKE fax_file.*   #MOD-BB0240 add
  DEFINE l_msg  LIKE type_file.chr1000   #MOD-BB0240 add
 
  LET g_success = 'Y'              #FUN-580109
#CHI-C30107 ----------- add ------------ begin
  IF g_faw.fawconf = 'Y' THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err('','9023',0)      #FUN-580109
     RETURN
  END IF
  IF g_faw.fawconf = 'X' THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err(' ','9024',0)
     RETURN
  END IF
  IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
     g_action_choice CLIPPED = "insert"     
  THEN
     IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF
  END IF
#CHI-C30107 ----------- add ------------ end  
  SELECT * INTO g_faw.* FROM faw_file WHERE faw01 = g_faw.faw01
  IF g_faw.fawconf = 'Y' THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err('','9023',0)      #FUN-580109
     RETURN
  END IF
  IF g_faw.fawconf = 'X' THEN
     LET g_success = 'N'           #FUN-580109
     CALL cl_err(' ','9024',0)
     RETURN
  END IF
  #MODNO:7341 add......................................................
  SELECT COUNT(*) INTO l_cnt FROM fax_file
   WHERE fax01= g_faw.faw01
  IF l_cnt = 0 THEN
     LET g_success = 'N'           #FUN-580109
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
  IF g_faw.faw02 < g_faa.faa09 THEN
     LET g_success = 'N'  
     CALL cl_err(g_faw.faw01,'aap-176',1) RETURN
  END IF
 #-MOD-A80137-end-
 
 #str MOD-BB0240 add
  CALL s_showmsg_init()   #No.FUN-710028

  #-->判斷輸入日期之前是否有未過帳
  DECLARE t104_fax_cur CURSOR FOR
     SELECT * FROM fax_file WHERE fax01=g_faw.faw01
  FOREACH t104_fax_cur INTO l_fax.*
     SELECT COUNT(*) INTO l_cnt FROM faw_file,fax_file
      WHERE faw01 = fax01
        AND fax05 = l_fax.fax05
        AND fax051= l_fax.fax051
        AND faw02 <= g_faw.faw02
        AND fawpost = 'N'
        AND faw01 != g_faw.faw01
        AND fawconf <> 'X'
     IF l_cnt  > 0 THEN
        LET l_msg = l_fax.fax01,' ',l_fax.fax02,' ',
                    l_fax.fax05,' ',l_fax.fax051
        CALL s_errmsg('','',l_msg,'afa-309',1)
        LET g_success = 'N'
     END IF
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM fav_file,fau_file,faj_file
      WHERE fav01 = l_fax.fax03
        AND fav02 = l_fax.fax04
        AND (fav04-fav07 > 0 )
        AND fav01 = fau01
        AND fauconf = 'Y'
        AND faupost = 'Y'
        AND fav03 = faj02
        AND fav031= faj022
     IF l_cnt = 0 THEN
        LET l_msg = l_fax.fax01,' ',l_fax.fax02,' ',
                    l_fax.fax05,' ',l_fax.fax051
        CALL s_errmsg('','',l_msg,'afa-220',1)
        LET g_success = 'N'
     END IF
  END FOREACH
  IF g_success = 'N' THEN
     CALL s_showmsg()
  END IF
 #end MOD-BB0240 add

  IF g_success = 'N' THEN RETURN END IF   #FUN-580109
 
END FUNCTION
 
FUNCTION t104_y_upd()
 
  LET g_success = 'Y'
  IF g_action_choice CLIPPED = "confirm" OR   #按「確認」時
     g_action_choice CLIPPED = "insert"     #FUN-640243
  THEN
 
     IF g_faw.fawmksg='Y'   THEN
         IF g_faw.faw04 != '1' THEN
            CALL cl_err('','aws-078',1)
            LET g_success = 'N'
            RETURN
         END IF
     END IF
#    IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
  END IF
 
  BEGIN WORK
 
  OPEN t104_cl USING g_faw.faw01
  IF STATUS THEN
     CALL cl_err("OPEN t104_cl:", STATUS, 1)
     CLOSE t104_cl
     ROLLBACK WORK
     RETURN
  END IF
  FETCH t104_cl INTO g_faw.*          # 鎖住將被更改或取消的資料
  IF SQLCA.sqlcode THEN
     CALL cl_err(g_faw.faw01,SQLCA.sqlcode,0)     # 資料被他人LOCK
     CLOSE t104_cl ROLLBACK WORK RETURN
  END IF
 
  LET g_success = 'Y'
  UPDATE faw_file SET fawconf = 'Y' WHERE faw01 = g_faw.faw01
  IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#    CALL cl_err('upd fawconf',STATUS,1)   #No.FUN-660136
     CALL cl_err3("upd","faw_file",g_faw.faw01,"",STATUS,"","upd fawconf",1)  #No.FUN-660136
     LET g_success = 'N'
  END IF
 
 #start FUN-580109
  IF g_success = 'Y' THEN
     IF g_faw.fawmksg = 'Y' THEN #簽核模式
        CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
            WHEN 0  #呼叫 EasyFlow 簽核失敗
                 LET g_faw.fawconf="N"
                 LET g_success = "N"
                 ROLLBACK WORK
                 RETURN
            WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                 LET g_faw.fawconf="N"
                 ROLLBACK WORK
                 RETURN
        END CASE
     END IF
 #end FUN-580109
     CLOSE t104_cl
     IF g_success = 'Y' THEN
       #start FUN-580109
        LET g_faw.faw04='1'      #執行成功, 狀態值顯示為 '1' 已核准
        UPDATE faw_file SET faw04 = g_faw.faw04 WHERE faw01=g_faw.faw01
        IF SQLCA.sqlerrd[3]=0 THEN
           LET g_success='N'
        END IF
       #end FUN-580109
        LET g_faw.fawconf='Y'    #執行成功, 確認碼顯示為 'Y' 已確認
        COMMIT WORK
        DISPLAY BY NAME g_faw.fawconf
        DISPLAY BY NAME g_faw.faw04   #FUN-580109
        CALL cl_flow_notify(g_faw.faw01,'Y')
     ELSE
        LET g_faw.fawconf='N'
        LET g_success = 'N'   #FUN-580109
        ROLLBACK WORK
     END IF
 #start FUN-580109
  ELSE
     LET g_faw.fawconf='N'
     LET g_success = 'N'
     ROLLBACK WORK
  END IF
 #end FUN-580109
 
  CALL cl_set_field_pic("","","","","","")
  IF g_faw.fawconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
 #start FUN-580109
  IF g_faw.faw04 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
 #CALL cl_set_field_pic(g_faw.fawconf,"",g_faw.fawpost,"",g_chr,"")
  CALL cl_set_field_pic(g_faw.fawconf,g_chr2,g_faw.fawpost,"",g_chr,"")
 #end FUN-580109
 
END FUNCTION
 
FUNCTION t104_ef()
 
  CALL t104_y_chk()      #CALL 原確認的 check 段
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
 
  IF aws_efcli2(base.TypeInfo.create(g_faw),base.TypeInfo.create(g_fax),'','','','')
  THEN
     LET g_success='Y'
     LET g_faw.faw04='S'
     DISPLAY BY NAME g_faw.faw04
  ELSE
     LET g_success='N'
  END IF
END FUNCTION
#end FUN-580109
 
FUNCTION t104_z() 			# when g_faw.fawconf='Y' (Turn to 'N')
   SELECT * INTO g_faw.* FROM faw_file WHERE faw01 = g_faw.faw01
   IF g_faw.faw04  ='S' THEN CALL cl_err("","mfg3557",0) RETURN END IF   #FUN-580109
   IF g_faw.fawconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF g_faw.fawconf='N' THEN RETURN END IF
   IF g_faw.fawpost='Y' THEN
      CALL cl_err(g_faw.fawpost,'afa-106',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_faw.faw02 < g_faa.faa09 THEN
      CALL cl_err(g_faw.faw01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end-
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
 
    OPEN t104_cl USING g_faw.faw01
    IF STATUS THEN
       CALL cl_err("OPEN t104_cl:", STATUS, 1)
       CLOSE t104_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t104_cl INTO g_faw.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_faw.faw01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t104_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
  #UPDATE faw_file SET fawconf = 'N'               #FUN-580109 mark
   UPDATE faw_file SET fawconf = 'N',faw04 = '0'   #FUN-580109
    WHERE faw01 = g_faw.faw01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd_z fawconf',STATUS,1)   #No.FUN-660136
      CALL cl_err3("upd","faw_file",g_faw.faw01,"",STATUS,"","upd_z fawconf",1)  #No.FUN-660136
      LET g_success = 'N'
   END IF
   CLOSE t104_cl
   IF g_success = 'Y' THEN
      LET g_faw.fawconf='N'
      LET g_faw.faw04='0'   #FUN-580109
      COMMIT WORK
      DISPLAY BY NAME g_faw.fawconf
      DISPLAY BY NAME g_faw.faw04    #FUN-580109
   ELSE
      LET g_faw.fawconf='Y'
      ROLLBACK WORK
   END IF
   CALL cl_set_field_pic("","","","","","")
   IF g_faw.fawconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  #start FUN-580109
   IF g_faw.faw04 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
  #CALL cl_set_field_pic(g_faw.fawconf,"",g_faw.fawpost,"",g_chr,"")
   CALL cl_set_field_pic(g_faw.fawconf,g_chr2,g_faw.fawpost,"",g_chr,"")
  #end FUN-580109
END FUNCTION
 
#----過帳--------
FUNCTION t104_s()
 DEFINE
       #l_sql           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(200)
        l_sql           STRING,        #TQC-630166
        l_msg           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(30)
        l_cnt           LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_faj           RECORD LIKE faj_file.*,
        l_fap05         LIKE fap_file.fap05,
        l_fap052        LIKE fap_file.fap052,        #FUN-AB0088
        l_fax           RECORD
          fax01         LIKE fax_file.fax01,
          fax02         LIKE fax_file.fax02,
          faj171        LIKE faj_file.faj171,
          fax03         LIKE fax_file.fax03,
          fax05         LIKE fax_file.fax05,
          fax051        LIKE fax_file.fax051,
          fax07         LIKE fax_file.fax07,
          #fax08         LIKE fax_file.fax08         #No:A099 #No.FUN-B80081 mark
          fax04         LIKE fax_file.fax04          #MOD-BB0240 add
          END RECORD,
        l_fav07         LIKE fav_file.fav07
 
    SELECT * INTO g_faw.* FROM faw_file WHERE faw01 = g_faw.faw01
   IF g_faw.fawconf <> 'Y' THEN CALL cl_err(' ','afa-100',0) RETURN END IF
   IF g_faw.fawpost = 'Y' THEN CALL cl_err(' ','afa-101',0) RETURN END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_faw.faw02 < g_faa.faa09 THEN
      CALL cl_err(g_faw.faw01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end-
   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK
 
    OPEN t104_cl USING g_faw.faw01
    IF STATUS THEN
       CALL cl_err("OPEN t104_cl:", STATUS, 1)
       CLOSE t104_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t104_cl INTO g_faw.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_faw.faw01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t104_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
   UPDATE faw_file SET fawpost='Y' WHERE faw01=g_faw.faw01 #更改過帳碼
                                     AND fawpost = 'N'
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('Update:',SQLCA.sqlcode,1)   #No.FUN-660136
      CALL cl_err3("upd","faw_file",g_faw.faw01,"",SQLCA.sqlcode,"","Update:",1)  #No.FUN-660136
      LET g_success = 'N'
   END IF
   LET l_sql = "SELECT fax01,fax02,faj171,fax03,fax05,fax051,fax07,fax04",  #MOD-BB0240 add fax04
               #"       fax08",                    #No:A099 #No.FUN-B80081 mark
               "  FROM faj_file,fax_file",
               " WHERE faj02  = fax05",
               "   AND faj022 = fax051",
               "   AND fax01  = '",g_faw.faw01,"'"
   PREPARE t104_prepare3 FROM l_sql
   IF STATUS THEN
      CALL cl_err('Sel :',STATUS,1)
      LET g_success = 'N'
   END IF
   DECLARE t104_curs3 CURSOR FOR t104_prepare3
   CALL s_showmsg_init()   #No.FUN-710028
   FOREACH t104_curs3 INTO l_fax.*
#No.FUN-710028 --begin                                                                                                              
       IF g_success='N' THEN                                                                                                         
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                                                                                                                        
#No.FUN-710028 --end
 
      IF SQLCA.sqlcode THEN
#        CALL cl_err('foreach:',SQLCA.sqlcode,1)                       #No.FUN-710028
         CALL s_errmsg('fax01',g_faw.faw01,'foreach:',SQLCA.sqlcode,0) #No.FUN-710028
         EXIT FOREACH
      END IF
     #------- 先找出對應之 faj_file 資料 99-04-28 modi by kitty
     SELECT * INTO l_faj.* FROM faj_file WHERE faj02=l_fax.fax05
     AND faj022=l_fax.fax051
     IF STATUS THEN
        CALL cl_err('sel faj',STATUS,0)
#       CALL cl_err3("sel","faj_file",l_fax.fax05,l_fax.fax051,SQLCA.sqlcode,"","sel faj",1)  #No.FUN-660136 #No.FUN-710028
        LET g_showmsg = l_fax.fax05,"/",l_fax.fax051    #No.FUN-710028
        CALL s_errmsg('faj02,faj022',g_showmsg,'sel faj',STATUS,1)   #No.FUN-710028
        LET g_success = 'N'
     END IF
     #-->判斷輸入日期之前是否有未過帳  99-04-28 add by kitty
     SELECT count(*) INTO l_cnt FROM faw_file,fax_file
                     WHERE faw01 = fax01
                       AND fax05 = l_fax.fax05
                       AND fax051= l_fax.fax051
                       AND faw02 <= g_faw.faw02
                       AND fawpost = 'N'
                       AND faw01 != g_faw.faw01
                       AND fawconf <> 'X'   #MOD-590470
     IF l_cnt  > 0 THEN
        LET l_msg = l_fax.fax01,' ',l_fax.fax02,' ',
                    l_fax.fax05,' ',l_fax.fax051
#       CALL cl_err(l_msg,'afa-309',1)            #No.FUN-710028
        CALL s_errmsg('','',l_msg,'afa-309',1)    #No.FUN-710028
        LET g_success = 'N'
#       EXIT FOREACH      #No.FUN-710028
        CONTINUE FOREACH  #No.FUN-710028
     END IF
     #----insert fap  99-04-29 add by kitty
    #str MOD-BB0240 add
     #-->判斷還有沒有可收回的數量
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM fav_file,fau_file,faj_file
      WHERE fav01 = l_fax.fax03
        AND fav02 = l_fax.fax04
        AND (fav04-fav07 > 0 )
        AND fav01 = fau01
        AND fauconf = 'Y'
        AND faupost = 'Y'
        AND fav03 = faj02
        AND fav031= faj022
     IF l_cnt = 0 THEN
        LET l_msg = l_fax.fax01,' ',l_fax.fax02,' ',
                    l_fax.fax05,' ',l_fax.fax051
        CALL s_errmsg('','',l_msg,'afa-220',1)
        LET g_success = 'N'
        CONTINUE FOREACH
     END IF
    #end MOD-BB0240 add
     #-----TQC-620120---------
     IF cl_null(l_fax.fax051) THEN
        LET l_fax.fax051 = ' '
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
                          #fap63,fap66,fap44,fap77,fap56,  #CHI-9B0032 add fap77  #TQC-B30156 add fap56 #No.FUN-B80081 mark
                           fap63,fap66,fap77,fap56,  #CHI-9B0032 add fap77  #TQC-B30156 add fap56 #No.FUN-B80081 add,移除fap44
                           #FUN-AB0088---add---str---
                           fap052,fap062,fap072,fap082,
                           fap092,fap103,fap1012,fap112,
                           fap152,fap162,fap212,fap222,
                           fap232,fap242,fap252,fap262,fap772,
                           #FUN-AB0088---add---end---
                           faplegal)            #No:A099 #FUN-980003 add
                   VALUES (l_faj.faj01,l_fax.fax05,l_fax.fax051,'B',
                           g_faw.faw02,l_faj.faj43,l_faj.faj28,l_faj.faj30,
                           l_faj.faj31,l_faj.faj14,l_faj.faj141,l_faj.faj33,
                           l_faj.faj32,l_faj.faj53,l_faj.faj54,l_faj.faj55,
                           l_faj.faj23,l_faj.faj24,l_faj.faj20,l_faj.faj19,
                           l_faj.faj21,l_faj.faj17,l_faj.faj171,l_faj.faj58,
                           l_faj.faj59,l_faj.faj60,l_faj.faj34,l_faj.faj35,
                           l_faj.faj36,l_faj.faj61,l_faj.faj65,l_faj.faj66,
                           l_faj.faj62,l_faj.faj63,l_faj.faj68,l_faj.faj67,
                           l_faj.faj69,l_faj.faj70,l_faj.faj71,l_faj.faj72,
                           l_faj.faj73,l_faj.faj100,l_fax.fax01,l_fax.fax02,
                           #l_fax.fax03,l_fax.fax07,l_faj.faj105,l_faj.faj43,0, #CHI-9B0032 add faj43  #TQC-B30156 add 0 #No.FUN-B80081 mark 
                           l_fax.fax03,l_fax.fax07,l_faj.faj43,0, #CHI-9B0032 add faj43  #TQC-B30156 add 0 #No.FUN-B80081 add,移除faj105
                           #FUN-AB0088---add---str---
                           l_faj.faj432,l_faj.faj282,l_faj.faj302,l_faj.faj312,
                           l_faj.faj142,l_faj.faj1412,l_faj.faj332,l_faj.faj322,
                           l_faj.faj232,l_faj.faj242,l_faj.faj582,l_faj.faj592,
                           l_faj.faj602,l_faj.faj342,l_faj.faj352,l_faj.faj362,l_faj.faj432,
                           #FUN-AB0088---add---end---   
                           g_legal)  #No:A099 #FUN-980003 add
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#       CALL cl_err('ins fap',STATUS,0)   #No.FUN-660136
#       CALL cl_err3("ins","fap_file",l_faj.faj01,l_fax.fax05,STATUS,"","ins fap",1)  #No.FUN-660136 #No.FUN-710028
        LET g_showmsg = l_fax.fax05,"/",l_fax.fax051,"/",'B',"/",g_faw.faw02          #No.FUN-710028
        CALL s_errmsg('fap02,fap021,fap03,fap04',g_showmsg,'ins fap',STATUS,1)        #No.FUN-710028
        LET g_success = 'N'
      END IF
     #----
      SELECT SUM(fav07) INTO l_fav07 FROM fav_file,fau_file
       WHERE fav03  = l_fax.fax05
         AND fav031 = l_fax.fax051
         AND fav01  = l_fax.fax03
         AND fav01  = fau01
         AND fauconf = 'Y'
         AND faupost = 'Y'
      IF STATUS THEN
#        CALL cl_err('',STATUS,1)   #No.FUN-660136
#        CALL cl_err3("sel","fav_file,fau_file",l_fax.fax05,l_fax.fax03,STATUS,"","",1)  #No.FUN-660136 #No.FUN-710028
         LET g_showmsg = l_fax.fax05,"/",l_fax.fax051,"/",l_fax.fax03,"/",'Y',"/",'Y'    #No.FUN-710028
         CALL s_errmsg('fav03,fav031,fav01,fauconf,faupost',g_showmsg,'',STATUS,1)       #No.FUN-710028
         LET g_success = 'N'
      END IF
      IF cl_null(l_fav07) THEN LET l_fav07 = 0 END IF
      LET l_fax.faj171 = l_fax.faj171 - l_fax.fax07    #在外量
      LET l_fav07 = l_fav07 + l_fax.fax07              #收回數量
      IF l_faj.faj43 = '3' THEN #MOD-690117 add if 判斷 #外送
         #SELECT fap05 INTO l_fap05 FROM fap_file                          #update回faj43   #FUN-AB0088 mark
          SELECT fap05,fap052 INTO l_fap05,l_fap052 FROM fap_file          #update回faj43   #FUN-AB0088 add 
           WHERE fap03='A'
             AND fap50=l_fax.fax03       #No:8466 原用faw03可能為空白
             AND fap02=l_fax.fax05
             AND fap021=l_fax.fax051
      #MOD-690117-------add-------str---
      ELSE
          LET l_fap05=l_faj.faj43
          LET l_fap052 = l_faj.faj432     #FUN-AB0088  
      END IF
      #MOD-690117-------add-------end---
      UPDATE faj_file SET faj171 = l_fax.faj171,
                          faj43  = l_fap05
                         #faj432 = l_fap052    #FUN-AB0088 #FUN-B90096 mark 
                          #faj105 = l_fax.fax08      #No:A099 #No.FUN-B80081 mark
       WHERE faj02  = l_fax.fax05    #更新資產基本檔
         AND faj022 = l_fax.fax051
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#        CALL cl_err('Update3:',SQLCA.sqlcode,1)         #No.FUN-660136
#        CALL cl_err3("upd","faj_file",l_fax.fax05,l_fax.fax051,SQLCA.sqlcode,"","Update3:",1)  #No.FUN-660136 #No.FUN-710028
         LET g_showmsg = l_fax.fax05,"/",l_fax.fax051    #No.FUN-710028
         CALL s_errmsg('faj02,faj022',g_showmsg,'Update3:',SQLCA.sqlcode,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
    #FUN-B90096----------add-------str
      IF g_faa.faa31 = 'Y' THEN
         UPDATE faj_file SET faj432 = l_fap052
            WHERE faj02  = l_fax.fax05    #更新資產基本檔
              AND faj022 = l_fax.fax051
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            LET g_showmsg = l_fax.fax05,"/",l_fax.fax051
            CALL s_errmsg('faj02,faj022',g_showmsg,'Update3:',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
      END IF 
    #FUN-B90096----------add-------end       
      UPDATE fav_file SET fav07 = l_fav07    #更新資產外送檔
       WHERE fav03  = l_fax.fax05
         AND fav031 = l_fax.fax051
         AND fav01  = l_fax.fax03
      IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
#        CALL cl_err('Update4 :',SQLCA.sqlcode,1)   #No.FUN-660136
#        CALL cl_err3("upd","fav_file",l_fax.fax05,l_fax.fax051,SQLCA.sqlcode,"","Update4 :",1)  #No.FUN-660136 #No.FUN-710028
         LET g_showmsg = l_fax.fax05,"/",l_fax.fax051,"/",l_fax.fax03                #No.FUN-710028
         CALL s_errmsg('fav03,fav031,fav01',g_showmsg,'Update4 :',SQLCA.sqlcode,1)   #No.FUN-710028
         LET g_success = 'N'
      END IF
   END FOREACH
#No.FUN-710028 --begin                                                                                                              
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
#No.FUN-710028 --end
 
   CLOSE t104_cl
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'Y' THEN
      LET g_faw.fawpost='Y'
      COMMIT WORK
      DISPLAY BY NAME g_faw.fawpost
      CALL cl_flow_notify(g_faw.faw01,'S')
   ELSE
      LET g_faw.fawpost='N'
      ROLLBACK WORK
   END IF
   CALL cl_set_field_pic("","","","","","")
   IF g_faw.fawconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  #start FUN-580109
   IF g_faw.faw04 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
  #CALL cl_set_field_pic(g_faw.fawconf,"",g_faw.fawpost,"",g_chr,"")
   CALL cl_set_field_pic(g_faw.fawconf,g_chr2,g_faw.fawpost,"",g_chr,"")
  #end FUN-580109
END FUNCTION
#------過帳還原--------
FUNCTION t104_w()
 DEFINE l_fap05         LIKE fap_file.fap05 #MOD-690117 add
 DEFINE l_fap052        LIKE fap_file.fap052    #FUN-AB0088 add 
 DEFINE
       #l_sql           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(200)
        l_sql           STRING,        #TQC-630166
        l_fap44         LIKE fap_file.fap44,        #No:A099
        l_fax           RECORD
          fax01         LIKE fax_file.fax01,
          fax02         LIKE fax_file.fax02,
          faj171        LIKE faj_file.faj171,
          fax03         LIKE fax_file.fax03,
          fax05         LIKE fax_file.fax05,
          fax051        LIKE fax_file.fax051,
          fax07         LIKE fax_file.fax07
          END RECORD,
        l_fav07         LIKE fav_file.fav07
 
    SELECT * INTO g_faw.* FROM faw_file WHERE faw01 = g_faw.faw01
   IF g_faw.fawconf = 'X' THEN RETURN END IF
   IF g_faw.fawpost = 'N' THEN
      RETURN END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
   #FUN-B50090 add -end--------------------------
  #-MOD-A80137-add-
   #-->立帳日期小於關帳日期
   IF g_faw.faw02 < g_faa.faa09 THEN
      CALL cl_err(g_faw.faw01,'aap-176',1) RETURN
   END IF
  #-MOD-A80137-end-
 
   IF NOT cl_sure(18,20) THEN RETURN END IF
   BEGIN WORK
 
    OPEN t104_cl USING g_faw.faw01
    IF STATUS THEN
       CALL cl_err("OPEN t104_cl:", STATUS, 1)
       CLOSE t104_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t104_cl INTO g_faw.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_faw.faw01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t104_cl ROLLBACK WORK RETURN
    END IF
   LET g_success = 'Y'
   UPDATE faw_file SET fawpost='N' WHERE faw01=g_faw.faw01 #更改過帳碼
                                     AND fawpost = 'Y'
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('Update:',SQLCA.sqlcode,1)   #No.FUN-660136
      CALL cl_err3("upd","faw_file",g_faw.faw01,"",SQLCA.sqlcode,"","Update:",1)  #No.FUN-660136
      LET g_success = 'N'
   END IF
   LET l_sql = "SELECT fax01,fax02,faj171,fax03,fax05,fax051,fax07",
               "  FROM faj_file,fax_file",
               " WHERE faj02  = fax05",
               "   AND faj022 = fax051",
               "   AND fax01  = '",g_faw.faw01,"'"
   PREPARE t104_prepare4 FROM l_sql
   IF STATUS THEN
      CALL cl_err('Prepare4: :',STATUS,1)
      LET g_success = 'N'
   END IF
   DECLARE t104_curs4 CURSOR FOR t104_prepare4
   CALL s_showmsg_init()   #No.FUN-710028
   FOREACH t104_curs4 INTO l_fax.*
#No.FUN-710028 --begin                                                                                                              
     IF g_success='N' THEN                                                                                                         
        LET g_totsuccess='N'                                                                                                       
        LET g_success="Y"                                                                                                          
     END IF                                                                                                                        
#No.FUN-710028 --end
 
     IF SQLCA.sqlcode THEN
#       CALL cl_err('foreach:',SQLCA.sqlcode,1)                        #No.FUN-710028
        CALL s_errmsg('fax01',g_faw.faw01,'foreach:',SQLCA.sqlcode,1)  #No.FUN-710028
        EXIT FOREACH
     END IF
     #No:A099
     SELECT fap44 INTO l_fap44 FROM fap_file          #update回faj43
      WHERE fap03='B'
        AND fap50=g_faw.faw01
        AND fap02=l_fax.fax05
        AND fap021=l_fax.fax051
     IF SQLCA.sqlcode THEN
#       CALL cl_err('sel fap:',SQLCA.sqlcode,1)   #No.FUN-660136
#       CALL cl_err3("sel","fap_file",g_faw.faw01,l_fax.fax05,SQLCA.sqlcode,"","sel fap:",1)  #No.FUN-660136 #No.FUN-710028
        LET g_showmsg = 'B',"/",g_faw.faw01,"/",l_fax.fax05,"/",l_fax.fax051             #No.FUN-710028
        CALL s_errmsg('fap03,fap50,fap02,fap021',g_showmsg,'sel fap:',SQLCA.sqlcode,1)   #No.FUN-710028
        LET g_success = 'N'
     END IF
     #end No:A099
     SELECT SUM(fav07) INTO l_fav07 FROM fav_file,fau_file
      WHERE fav03  = l_fax.fax05
        AND fav031 = l_fax.fax051
        AND fav01  = l_fax.fax03
        AND fav01  = fau01
        AND fauconf= 'Y'
        AND faupost= 'Y'
     IF STATUS THEN
#       CALL cl_err('',STATUS,1)   #No.FUN-660136
#       CALL cl_err3("sel","fav_file,fau_file",l_fax.fax05,l_fax.fax03,STATUS,"","",1)  #No.FUN-660136 #No.FUN-710028
        LET g_showmsg = l_fax.fax05,"/",l_fax.fax051,"/",l_fax.fax03,"/",'Y',"/",'Y'    #No.FUN-710028
        CALL s_errmsg('fav03,fav031,fav01,fauconf,faupost',g_showmsg,'',STATUS,1)       #No.FUN-710028
        LET g_success = 'N'
     END IF
     IF cl_null(l_fav07) THEN LET l_fav07 = 0 END IF
     LET l_fax.faj171 = l_fax.faj171 + l_fax.fax07
     LET l_fav07 = l_fav07 - l_fax.fax07
     #MOD-690117 ----------------add--------str--
    #SELECT fap05 INTO l_fap05 FROM fap_file                     #FUN-AB0088 mark 
     SELECT fap05,fap052 INTO l_fap05,l_fap052 FROM fap_file     #FUN-AB0088 add
      WHERE fap02=l_fax.fax05
        AND fap021=l_fax.fax051
        AND fap03 = 'B' #收回
        AND fap04 = g_faw.faw02
     #MOD-690117 ----------------add--------end--
     UPDATE faj_file SET faj171 = l_fax.faj171,
                        #faj43  = '3',    #MOD-690117 mark
                         faj43  = l_fap05 #MOD-690117 mod
                        #faj432 = l_fap052  #FUN-AB0088 add #FUN-B90096 mark
                         #faj105 = l_fap44                #No:A099 #No.FUN-B80081 mark
      WHERE faj02  = l_fax.fax05    #更新資產基本檔
        AND faj022 = l_fax.fax051
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#       CALL cl_err('Update3:',SQLCA.sqlcode,1)   #No.FUN-660136
#       CALL cl_err3("upd","faj_file",l_fax.fax05,l_fax.fax051,SQLCA.sqlcode,"","Update3:",1)  #No.FUN-660136 #No.FUN-710028
        LET g_showmsg = l_fax.fax05,"/",l_fax.fax051                        #No.FUN-710028
        CALL s_errmsg('faj02,faj022',g_showmsg,'Update3:',SQLCA.sqlcode,1)  #No.FUN-710028
        LET g_success = 'N'
     END IF
    #FUN-B90096----------add-------str
     IF g_faa.faa31 = 'Y' THEN
        UPDATE faj_file SET faj432 = l_fap052
           WHERE faj02  = l_fax.fax05    #更新資產基本檔
             AND faj022 = l_fax.fax051
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           LET g_showmsg = l_fax.fax05,"/",l_fax.fax051
           CALL s_errmsg('faj02,faj022',g_showmsg,'Update3:',SQLCA.sqlcode,1)
           LET g_success = 'N'
        END IF
     END IF 
    #FUN-B90096----------add-------end      
     UPDATE fav_file SET fav07 = l_fav07   #更新資產外送檔
      WHERE fav03  = l_fax.fax05
        AND fav031 = l_fax.fax051
        AND fav01  = l_fax.fax03
     IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
#       CALL cl_err('Update4 :',SQLCA.sqlcode,1)   #No.FUN-660136
#       CALL cl_err3("upd","fav_file",l_fax.fax05,l_fax.fax03,SQLCA.sqlcode,"","Update4 :",1)  #No.FUN-660136 #No.FUN-710028
        LET g_showmsg = l_fax.fax05,"/",l_fax.fax051,"/",l_fax.fax03                #No.FUN-710028
        CALL s_errmsg('fav03,fav031,fav01',g_showmsg,'Update4 :',SQLCA.sqlcode,1)   #No.FUN-710028
        LET g_success = 'N'
     END IF
      #--------- 還原過帳 delete fap_file   99-04-29 add by kitty
      DELETE FROM fap_file WHERE fap50=l_fax.fax01 AND fap501= l_fax.fax02
                             AND fap03 = 'B'
      IF STATUS OR SQLCA.sqlerrd[3]= 0 THEN
#        CALL cl_err('del fap',STATUS,0)   #No.FUN-660136
#        CALL cl_err3("del","fap_file",l_fax.fax01,l_fax.fax02,STATUS,"","del fap",1)  #No.FUN-660136 #No.FUN-710028
         LET g_showmsg = l_fax.fax01,"/",l_fax.fax02,"/",'B'               #No.FUN-710028
         CALL s_errmsg('fap50,fap501,fap03',g_showmsg,'del fap',STATUS,1)  #No.FUN-660136
         LET g_success = 'N'
      END IF
  END FOREACH
#No.FUN-710028 --begin                                                                                                              
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
#No.FUN-710028 --end
 
   CLOSE t104_cl
   CALL s_showmsg()   #No.FUN-710028
   IF g_success = 'Y' THEN
      LET g_faw.fawpost='N'
      COMMIT WORK
      DISPLAY BY NAME g_faw.fawpost
   ELSE
      LET g_faw.fawpost='Y'
      ROLLBACK WORK
   END IF
   CALL cl_set_field_pic("","","","","","")
   IF g_faw.fawconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  #start FUN-580109
   IF g_faw.faw04 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
  #CALL cl_set_field_pic(g_faw.fawconf,"",g_faw.fawpost,"",g_chr,"")
   CALL cl_set_field_pic(g_faw.fawconf,g_chr2,g_faw.fawpost,"",g_chr,"")
  #end FUN-580109
END FUNCTION
 
#FUNCTION t104_x()                       #FUN-D20035
FUNCTION t104_x(p_type)                  #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_faw.* FROM faw_file WHERE faw01=g_faw.faw01
  #start FUN-580109
   IF g_faw.faw04 MATCHES '[Ss1]' THEN
      CALL cl_err("","mfg3557",0) RETURN
   END IF
  #end FUN-580109
   IF g_faw.faw01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_faw.fawconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF

    #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_faw.fawconf='X' THEN RETURN END IF
   ELSE
      IF g_faw.fawconf<>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end
   BEGIN WORK
   LET g_success='Y'
 
   OPEN t104_cl USING g_faw.faw01
   IF STATUS THEN
      CALL cl_err("OPEN t104_cl:", STATUS, 1)
      CLOSE t104_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t104_cl INTO g_faw.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_faw.faw01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t104_cl ROLLBACK WORK RETURN
   END IF
   #-->作廢轉換01/08/01
  #IF cl_void(0,0,g_faw.fawconf)   THEN                                #FUN-D20035
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #FUN-D20035
   IF cl_void(0,0,l_flag) THEN                                         #FUN-D20035
      LET g_chr=g_faw.fawconf
     #IF g_faw.fawconf ='N' THEN                                      #FUN-D20035
      IF p_type = 1 THEN                                              #FUN-D20035
         LET g_faw.fawconf='X'
         LET g_faw.faw04 = '9'   #FUN-580109
      ELSE
         LET g_faw.fawconf='N'
         LET g_faw.faw04 = '0'   #FUN-580109
      END IF
 
      UPDATE faw_file SET fawconf = g_faw.fawconf,
                          faw04   = g_faw.faw04,   #FUN-580109
                          fawmodu = g_user,
                          fawdate = TODAY
       WHERE faw01 = g_faw.faw01
      IF STATUS THEN CALL cl_err('upd fawconf:',STATUS,1) LET g_success='N' END IF
      IF g_success='Y' THEN
         COMMIT WORK
        #start FUN-580109
         IF g_faw.fawconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_faw.faw04 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_faw.fawconf,g_chr2,g_faw.fawpost,"",g_chr,"")
        #end FUN-580109
          CALL cl_flow_notify(g_faw.faw01,'V')
      ELSE
          ROLLBACK WORK
      END IF
     #SELECT fawconf INTO g_faw.fawconf                     #FUN-580109 mark
      SELECT fawconf,faw04 INTO g_faw.fawconf,g_faw.faw04   #FUN-580109
        FROM faw_file
       WHERE faw01 = g_faw.faw01
      DISPLAY BY NAME g_faw.fawconf
      DISPLAY BY NAME g_faw.faw04    #FUN-580109
   END IF
  #CALL cl_set_field_pic("","","","","","")                            #FUN-580109 mark
  #IF g_faw.fawconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF   #FUN-580109 mark
  #CALL cl_set_field_pic(g_faw.fawconf,"",g_faw.fawpost,"",g_chr,"")   #FUN-580109 mark
END FUNCTION
#FUN-630045
FUNCTION t104_faw05(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_gen02    LIKE gen_file.gen02,
       l_gen03    LIKE gen_file.gen03,             #No:7381
       l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti    #No:7381
      FROM gen_file
     WHERE gen01 = g_faw.faw05
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1312'
                                LET l_gen02 = NULL
                                LET l_genacti = NULL
       WHEN l_genacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
END FUNCTION
#END FUN-630045
 
#No.TQC-760182--begin-- 增加打印功能
FUNCTION t104_o()
DEFINE   l_cmd    LIKE type_file.chr1000
DEFINE  
        #l_wc1    LIKE type_file.chr1000
         l_wc1    STRING        #NO.FUN-910082
DEFINE   l_wc2    LIKE type_file.chr1000
DEFINE   l_prtway LIKE zz_file.zz22
 
    IF cl_null(g_faw.faw01) THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
    CALL cl_wait()
    LET g_wc = " faw01 = '",g_faw.faw01,"'"      #MOD-B30624
    LET l_wc1 = g_wc CLIPPED," AND ",g_wc2
    SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file
     WHERE zz01='afar215'
    IF SQLCA.sqlcode OR cl_null(l_wc2) THEN
       LET l_wc2 = " '' 'NNN' 'NNN' '3' '3' 'default' 'default' 'template1'" 
    END IF
    LET l_cmd = "afar215 ",
                " '",g_today CLIPPED,"' ''",
                " '",g_lang CLIPPED,"' 'Y' '",l_prtway CLIPPED,"' '1' ",
                " \"",l_wc1 CLIPPED,"\"",l_wc2
    CALL cl_cmdrun(l_cmd)
    ERROR ''
 
END FUNCTION 
#No.TQC-760182--end-- 

