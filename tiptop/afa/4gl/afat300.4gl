# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afat300.4gl
# Descriptions...: 模具領用單維護作業
# Date & Author..: 00/03/03 By Alex Lin
# Modify.........: No.B608 010612 by linda add fec05 類別 1.部門 2.廠商
# Modify.........: No:7837 03/08/19 By Wiky 呼叫自動取單號時應在 Transction中
# Modify.........: No.MOD-490344 04/09/20 By Kitty controlp 少display補入
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-4A0248 04/10/26 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.FUN-510035 05/01/31 By Smapmin 報表轉XML格式
# Modify.........: NO.FUN-550034 05/05/17 By jackie 單據編號加大
# Modify.........: NO.FUN-550060 05/06/16 By day   單據編號修改
# Modify.........: No.MOD-580153 05/08/19 By Smapmin 維護到作業編號時,會跳出來.
#                                                    輸入完該張單據的當時,不能列印
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.TQC-630052 06/03/07 By Claire 流程訊息通知傳參數
# Modify.........: No.TQC-660068 06/06/14 By Claire 流程訊息通知傳參數
# Modify.........: No.FUN-660136 06/06/26 By ice cl_err-->cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0001 06/10/11 By jamie FUNCTION t300_q() 一開始應清空g_fec.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time 
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770108 07/07/24 By Rayven 更改一筆資料，將“類型”更改，后面的“部門/廠商”不更改，確定可以通過
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.MOD-840007 08/04/02 By Pengu 是否可刪除應判斷是否有其它異動單號
# Modify.........: No.FUN-850068 08/05/12 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-840241 08/06/19 By sherry 加上確認/取消確認功能，在確認時才回afai300數量feb12
# Modify.........: No.FUN-850024 08/05/08 By Cockroach 報表轉CR 
#                                08/07/30 By Cockroach 追單至31區
# Modify.........: No.FUN-910038 09/02/26 By sabrina 與EasyFlow整合，並將確認段拆出至afat300_sub.4gl
# Modify.........: No.MOD-970110 09/07/20 By baofei 手動輸入工單編號沒有控管sfb04為1  
# Modify.........: No.TQC-970405 09/07/31 By Carrier 已有歸還資料的單據不得取消審核
# Modify.........: No.FUN-980003 09/08/11 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0112 09/10/16 By mike 应增加AFTER FIELD fec02 日期与现行期别之起迄日期之检查.                           
# Modify.........: No:FUN-9C0077 10/01/07 By baofei 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-A60117 10/06/18 by Dido 檢核模具壽命若與已使用次相同則不可再領用 
# Modify.........: No.FUN-A60056 10/07/08 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.TQC-B20148 11/02/22 By yinhy 工單狀態不為結案的都可以領用模具
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-B80054 11/08/04 By fengrui  程式撰寫規範修正
# Modify.........: No:FUN-B60140 11/09/08 By zhangweib "財簽二二次改善"追單
# Modify.........: No:FUN-C20012 12/02/04 By Abby EF功能調整-客戶不以整張單身資料送簽問題
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:CHI-C80041 12/12/18 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No.FUN-C30163 12/12/26 By pauline CALL q_ecm(時增加參數
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fec           RECORD LIKE fec_file.*,
    g_fec_t         RECORD LIKE fec_file.*,
    g_fec_o         RECORD LIKE fec_file.*,
    g_fec01_t       LIKE fec_file.fec01,   #簽核等級 (舊值)
    g_t1            LIKE type_file.chr5,     #No.FUN-550034       #No.FUN-680070 VARCHAR(05)
    l_cnt           LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    g_fed           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fed02       LIKE fed_file.fed02,   #序號
        fed03       LIKE fed_file.fed03,   #模具編號
        fea02       LIKE fea_file.fea02,   #名稱
        fed04       LIKE fed_file.fed04,   #數量
        fed05       LIKE fed_file.fed05,   #工單號碼
        fed06       LIKE fed_file.fed06,   #作業編號
        ecd02       LIKE ecd_file.ecd02,   #作業名稱
        fedud01     LIKE fed_file.fedud01,
        fedud02     LIKE fed_file.fedud02,
        fedud03     LIKE fed_file.fedud03,
        fedud04     LIKE fed_file.fedud04,
        fedud05     LIKE fed_file.fedud05,
        fedud06     LIKE fed_file.fedud06,
        fedud07     LIKE fed_file.fedud07,
        fedud08     LIKE fed_file.fedud08,
        fedud09     LIKE fed_file.fedud09,
        fedud10     LIKE fed_file.fedud10,
        fedud11     LIKE fed_file.fedud11,
        fedud12     LIKE fed_file.fedud12,
        fedud13     LIKE fed_file.fedud13,
        fedud14     LIKE fed_file.fedud14,
        fedud15     LIKE fed_file.fedud15
                    END RECORD,
    g_fed_t         RECORD                 #程式變數 (舊值)
        fed02       LIKE fed_file.fed02,   #序號
        fed03       LIKE fed_file.fed03,   #模具編號
        fea02       LIKE fea_file.fea02,   #名稱
        fed04       LIKE fed_file.fed04,   #數量
        fed05       LIKE fed_file.fed05,   #工單號碼
        fed06       LIKE fed_file.fed06,   #作業編號
        ecd02       LIKE ecd_file.ecd02,   #作業名稱
        fedud01     LIKE fed_file.fedud01,
        fedud02     LIKE fed_file.fedud02,
        fedud03     LIKE fed_file.fedud03,
        fedud04     LIKE fed_file.fedud04,
        fedud05     LIKE fed_file.fedud05,
        fedud06     LIKE fed_file.fedud06,
        fedud07     LIKE fed_file.fedud07,
        fedud08     LIKE fed_file.fedud08,
        fedud09     LIKE fed_file.fedud09,
        fedud10     LIKE fed_file.fedud10,
        fedud11     LIKE fed_file.fedud11,
        fedud12     LIKE fed_file.fedud12,
        fedud13     LIKE fed_file.fedud13,
        fedud14     LIKE fed_file.fedud14,
        fedud15     LIKE fed_file.fedud15
                    END RECORD,
    g_fed_o         RECORD                 #程式變數 (舊值)
        fed02       LIKE fed_file.fed02,   #序號
        fed03       LIKE fed_file.fed03,   #模具編號
        fea02       LIKE fea_file.fea02,   #名稱
        fed04       LIKE fed_file.fed04,   #數量
        fed05       LIKE fed_file.fed05,   #工單號碼
        fed06       LIKE fed_file.fed06,   #作業編號
        ecd02       LIKE ecd_file.ecd02,   #作業名稱
        fedud01     LIKE fed_file.fedud01,
        fedud02     LIKE fed_file.fedud02,
        fedud03     LIKE fed_file.fedud03,
        fedud04     LIKE fed_file.fedud04,
        fedud05     LIKE fed_file.fedud05,
        fedud06     LIKE fed_file.fedud06,
        fedud07     LIKE fed_file.fedud07,
        fedud08     LIKE fed_file.fedud08,
        fedud09     LIKE fed_file.fedud09,
        fedud10     LIKE fed_file.fedud10,
        fedud11     LIKE fed_file.fedud11,
        fedud12     LIKE fed_file.fedud12,
        fedud13     LIKE fed_file.fedud13,
        fedud14     LIKE fed_file.fedud14,
        fedud15     LIKE fed_file.fedud15
                    END RECORD,
    g_fah           RECORD LIKE fah_file.*,
    g_wc,g_wc2,g_sql    STRING,            #TQC-630166
    g_rec_b         LIKE type_file.num5,                #單身筆數       #No.FUN-680070 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
    g_cmd           LIKE type_file.chr1     #MOD-580153       #No.FUN-680070 VARCHAR(1)
                                                                                                                                    
DEFINE   g_str           STRING                                                                                                     
DEFINE   l_table         STRING                                                                                                     
                                
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_chr           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
DEFINE g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_argv1         LIKE fec_file.fec01            # 單號             #TQC-630052       #No.FUN-680070 VARCHAR(16)
DEFINE g_argv2         STRING              # 指定執行的功能   #TQC-630052
DEFINE g_laststage    LIKE type_file.chr1          #FUN-910038 add
DEFINE g_chr2         LIKE type_file.chr1          #FUN-910038 add
DEFINE g_approve      LIKE type_file.chr1          #FUN-910038 add
 
MAIN
DEFINE p_row,p_col   LIKE type_file.num5         #No.FUN-680070 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
                                                                                                                                    
 LET g_sql =         "fed01.fed_file.fed01,",                                                                                       
                     "fec02.fec_file.fec02,",                                                                                       
                     "gem01.gem_file.gem01,",                                                                                       
                     "gem02.gem_file.gem02,",                                                                                       
                     "fed02.fed_file.fed02,",                                                                                       
                     "fed03.fed_file.fed03,",                                                                                       
                     "fed04.fed_file.fed04,",                                                                                       
                     "fed05.fed_file.fed05,",                                                                                       
                     "fed06.fed_file.fed06,",                                                                                       
                     "fec04.fec_file.fec04,",                                                                                       
                     "fea02.fea_file.fea02,",                                                                                       
                     "ecd02.ecd_file.ecd02 "                                                                                        
                                                                                                                                    
   LET l_table = cl_prt_temptable('afat300',g_sql) CLIPPED                                                                          
   IF  l_table = -1 THEN EXIT PROGRAM END IF                                                                                        
 
    LET g_argv1=ARG_VAL(1)           #TQC-630052
    LET g_argv2=ARG_VAL(2)           #TQC-630052
 
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                                         #NO.FUN-6A0069    
 
    LET g_forupd_sql = " SELECT * FROM fec_file WHERE fec01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t300_cl CURSOR FROM g_forupd_sql
 
    IF fgl_getenv('EASYFLOW')  = "1" THEN  #判斷是否為簽核模式
       LET g_argv1 = aws_efapp_wsk(1)       #取得單號
    END IF
 
   IF g_bgjob = 'N' OR cl_null(g_bgjob) THEN   #FUN-910038 add  若為背景作業則不開窗
      LET p_row = 4 LET p_col = 13
      OPEN WINDOW t300_w AT p_row,p_col              #顯示畫面
          WITH FORM "afa/42f/afat300"
           ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
      CALL cl_ui_init()
   END IF                                       #FUN-910038 add
 
  #如果由表單追蹤區觸發程式, 此參數指定為何種資料匣
  #當為 EasyFlow 簽核時, 加入 EasyFlow 簽核 toolbar icon
    CALL aws_efapp_toolbar()
 
   # 先以g_argv2判斷直接執行哪種功能，執行Q時，g_argv1是領用單號(fec01)
   # 執行I時，g_argv1是領用單號(fec01)
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t300_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t300_a()
            END IF
         WHEN "efconfirm"
            CALL t300_q()
            CALL t300sub_y_chk(g_fec.fec01)          #CALL 原確認的 check 段
            IF g_success = "Y" THEN
               CALL t300sub_y_upd(g_fec.fec01,g_action_choice)       #CALL 原確認的 update 段
            END IF
            EXIT PROGRAM
         OTHERWISE
               CALL t300_q()
      END CASE
   END IF
 
  #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
   CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, invalid, void, confirm, undo_confirm, easyflow_approval")    
        RETURNING g_laststage
 
    CALL t300_menu()
    CLOSE WINDOW t300_w                 #結束畫面
      CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                        #NO.FUN-6A0069
END MAIN
 
#QBE 查詢資料
FUNCTION t300_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    DEFINE l_str STRING
 
    CLEAR FORM                             #清除畫面
    CALL g_fed.clear()
 
   IF cl_null(g_argv1) THEN  #TQC-630052
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INITIALIZE g_fec.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
       fec01,fec02,fec07,fec05,fec03,fec04,fec06,fecmksg,fecconf,   #FUN-910038 add fec07,fec06,fecmksg,fecconf
       fecuser,fecgrup,fecmodu,fecdate,fecacti,
       fecud01,fecud02,fecud03,fecud04,fecud05,
       fecud06,fecud07,fecud08,fecud09,fecud10,
       fecud11,fecud12,fecud13,fecud14,fecud15
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
       ON ACTION controlp
 
           CASE
               WHEN INFIELD(fec01) #單據編號

                   CALL cl_init_qry_var()
                   LET g_qryparam.state= "c"
                   LET g_qryparam.form = "q_fec"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO fec01
                   NEXT FIELD fec01
               WHEN INFIELD(fec03) #部門代號  #genero 先mark
                   CALL GET_FLDBUF(fec05) RETURNING l_str
                   CASE l_str
                       WHEN '1'
                           CALL cl_init_qry_var()
                           LET g_qryparam.form = "q_gem"
                           LET g_qryparam.state = "c"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO fec03
                       WHEN '2'
                           CALL cl_init_qry_var()
                           LET g_qryparam.form = "q_pmc3"
                           LET g_qryparam.state = "c"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                           DISPLAY g_qryparam.multiret TO fec03
                   END CASE
                   NEXT FIELD fec03
               WHEN INFIELD(fec07) #申請人
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO fec07
                    NEXT FIELD fec07
 
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
 
 
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF

  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fecuser', 'fecgrup')
 
 
    CONSTRUCT g_wc2 ON fed02,fed03,fea02,fed04,fed05,   #螢幕上取單身條件
                       fed06,ecd02
                       ,fedud01,fedud02,fedud03,fedud04,fedud05
                       ,fedud06,fedud07,fedud08,fedud09,fedud10
                       ,fedud11,fedud12,fedud13,fedud14,fedud15
            FROM s_fed[1].fed02,s_fed[1].fed03,s_fed[1].fea02,s_fed[1].fed04,
                 s_fed[1].fed05,s_fed[1].fed06,s_fed[1].ecd02
                 ,s_fed[1].fedud01,s_fed[1].fedud02,s_fed[1].fedud03
                 ,s_fed[1].fedud04,s_fed[1].fedud05,s_fed[1].fedud06
                 ,s_fed[1].fedud07,s_fed[1].fedud08,s_fed[1].fedud09
                 ,s_fed[1].fedud10,s_fed[1].fedud11,s_fed[1].fedud12
                 ,s_fed[1].fedud13,s_fed[1].fedud14,s_fed[1].fedud15
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION controlp
           CASE
              WHEN INFIELD(fed03) #模具編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_feb"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO fed03
                   NEXT FIELD fed03
              WHEN INFIELD(fed05)     #工單編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sfb"
                   LET g_qryparam.where = "sfb04= '1'"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO fed05
                   NEXT FIELD fed05
              WHEN INFIELD(fed06) #作業編號
                  #CALL q_ecm(TRUE,TRUE,'','')   #FUN-C30163 mark
                   CALL q_ecm(TRUE,TRUE,'','','','','','')  #FUN-C30163 add
                        RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO fed06

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
 
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
 
   ELSE
      LET g_wc =" fec01 = '",g_argv1,"'"  
      LET g_wc2=" 1=1"
   END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT fec01 FROM fec_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
          display g_sql 
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE fec01 ",
                   "  FROM fec_file, fed_file ",
                   " WHERE fec01 = fed01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE t300_prepare FROM g_sql
    DECLARE t300_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t300_prepare
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM fec_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(*) FROM fec_file,fed_file WHERE ",
                  "fed01=fec01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t300_precount FROM g_sql
    DECLARE t300_count CURSOR FOR t300_precount
END FUNCTION
 
FUNCTION t300_menu()
DEFINE l_creator         VARCHAR(1)         #「不准」時是否退回填表人   #FUN-910038
DEFINE l_flowuser        VARCHAR(1)         # 是否有指定加簽人員       #FUN-910038
   LET l_flowuser = "N"                                             #FUN-910038
 
 
   WHILE TRUE
      CALL t300_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t300_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t300_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t300_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t300_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t300_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t300_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth()
               THEN CALL t300_out()
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
                 CALL t300sub_y_chk(g_fec.fec01)        #CALL 原確認的check段
                 IF g_success = "Y" THEN
                    CALL t300sub_y_upd(g_fec.fec01,g_action_choice)       #CALL 原確認的 update 段
                    CALL t300sub_refresh(g_fec.fec01) RETURNING g_fec.*           #重新讀取g_fec.*
                    CALL t300_show() 
                 END IF 
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
                 CALL t300_z()
            END IF         
 
       #@WHEN "EasyFlow送簽"
         WHEN "easyflow_approval"           
            IF cl_chk_act_auth() THEN
                #FUN-C20012 add str---
                 SELECT * INTO g_fec.* FROM fec_file
                  WHERE fec01 = g_fec.fec01
                 CALL t300_show()
                 CALL t300_b_fill(' 1=1')
                #FUN-C20012 add end---
                 CALL t300_ef()
                 CALL t300_show()  #FUN-C20012 add
            END IF
 
        #@WHEN "簽核狀況"
          WHEN "approval_status"               
              IF cl_chk_act_auth() THEN  
                 IF aws_condition2() THEN               
                     CALL aws_efstat2()
                 END IF
              END IF
 
        #@WHEN "准"
          WHEN "agree"                    #執行 EF 簽核, "准" 功能
              IF g_laststage = "Y" AND l_flowuser = "N" THEN #最後一關並且無加簽人員
                 CALL t300sub_y_upd(g_fec.fec01,g_action_choice)       #CALL 原確認的 update 段
                 CALL t300sub_refresh(g_fec.fec01) RETURNING g_fec.*
                 CALL t300_show()
              ELSE
                 LET g_success = "Y"
                 IF NOT aws_efapp_formapproval() THEN   #執行 EF 簽核
                    LET g_success = "N"
                 END IF
              END IF
              IF g_success = 'Y' THEN
                    IF cl_confirm('aws-081') THEN  #詢問是否繼續下一筆資料的簽核
                      IF aws_efapp_getnextforminfo() THEN #取得下一筆簽核單號
                         LET l_flowuser = 'N'
                         LET g_argv1 = aws_efapp_wsk(1)   #取得單號
                         IF NOT cl_null(g_argv1) THEN     #自動 query 帶出資料
                           CALL t300_q()
                          #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                           CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale,invalid,  void, confirm, undo_confirm,easyflow_approval")
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
          WHEN "deny"    #執行 EF 簽核, "不准" 功能
              IF (l_creator := aws_efapp_backflow() ) IS NOT NULL THEN #退回關卡
                IF aws_efapp_formapproval() THEN   #執行 EF 簽核
                   IF l_creator = "Y" THEN         #當退回填表人時
                      LET g_fec.fec06 = 'R'         #顯示狀態碼為 'R' 送簽退回
                      DISPLAY BY NAME g_fec.fec06
                   END IF
                   IF cl_confirm('aws-081') THEN     #詢問是否繼續下一筆資料的簽核
                      IF aws_efapp_getnextforminfo() THEN #取得下一筆簽核單號
                        LET l_flowuser = 'N'
                        LET g_argv1 = aws_efapp_wsk(1)    #取得單號
                        IF NOT cl_null(g_argv1) THEN      #自動 query 帶出資料
                           CALL t300_q()
                         #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                           CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query, locale, invalid, void, confirm, undo_confirm,easyflow_approval")
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
          WHEN "modify_flow"               #執行 EF 簽核, "加簽" 功能
              IF aws_efapp_flowuser() THEN  #選擇欲加簽人員
                 LET l_flowuser = 'Y'
              ELSE
                 LET l_flowuser = 'N'
              END IF
 
       #@WHEN "撤簽"
         WHEN "withdraw"                  #執行 EF 簽核, "撤簽" 功能
              IF cl_confirm("aws-080") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
       #@WHEN "抽單"
         WHEN "org_withdraw"               #執行 EF 簽核, "抽單" 功能
              IF cl_confirm("aws-079") THEN
                 IF aws_efapp_formapproval() THEN
                    EXIT WHILE
                 END IF
              END IF
 
       #@WHEN "簽核意見"
         WHEN "phrase"                      #執行 EF 簽核, "簽核意見" 功能
              CALL aws_efapp_phrase()
 
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fec.fec01 IS NOT NULL THEN
                  LET g_doc.column1 = "fec01"
                  LET g_doc.value1 = g_fec.fec01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fed),'','')
            END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t300_v()
               CALL t300_field_pic()
            END IF
         #CHI-C80041---end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t300_a()
    DEFINE li_result   LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    MESSAGE ""
    CLEAR FORM
    CALL g_fed.clear()
    IF s_shut(0) THEN RETURN END IF
    INITIALIZE g_fec.* LIKE fec_file.*             #DEFAULT 設定
    LET g_fec01_t = NULL
    LET g_fec.fec02 = g_today
    LET g_fec.fec05 = '1'
    LET g_fec.fec06 = '0'          #FUN-910038 add
    LET g_fec.fec07 = g_user       #FUN-910038 add
    CALL t300_fec07('d')           #FUN-910038 add
    LET g_fec.fecconf='N'       #No.FUN-840241       
    #預設值及將數值類變數清成零
    LET g_fec_t.* = g_fec.*
    LET g_fec_o.* = g_fec.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fec.fecuser=g_user
        LET g_fec.fecoriu = g_user #FUN-980030
        LET g_fec.fecorig = g_grup #FUN-980030
        LET g_fec.fecgrup=g_grup
        LET g_fec.fecmodu=' '
        LET g_fec.fecdate=g_today
        LET g_fec.fecacti='Y'              #資料有效
        LET g_fec.feclegal= g_legal    #FUN-980003 add
 
        CALL t300_i("a")                #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            INITIALIZE g_fec.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
 
 
        IF g_fec.fec01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        BEGIN WORK  #No:7837
        CALL s_auto_assign_no("afa",g_fec.fec01,g_fec.fec02,"D","fec_file","fec01","","","")
             RETURNING li_result,g_fec.fec01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_fec.fec01

        INSERT INTO fec_file VALUES (g_fec.*)
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL cl_err3("ins","fec_file",g_fec.fec01,"",SQLCA.sqlcode,"","",1) # FUN-660136  #No.FUN-B80054---調整至回滾事務前---
            ROLLBACK WORK  #No:7837			
            CONTINUE WHILE
        ELSE
            COMMIT WORK   #No:7837
            CALL cl_flow_notify(g_fec.fec01,'I')
        END IF
        SELECT fec01 INTO g_fec.fec01 FROM fec_file
            WHERE fec01 = g_fec.fec01
        LET g_fec01_t = g_fec.fec01        #保留舊值
        LET g_fec_t.* = g_fec.*
        LET g_fec_o.* = g_fec.*
 
        CALL g_fed.clear()
        LET g_rec_b=0
 
        CALL t300_b()                   #輸入單身
 
        IF NOT cl_null(g_fec.fec01) AND g_fah.fahconf = 'Y' AND g_fah.fahapr <> 'Y' THEN
           LET g_action_choice = "insert"
           CALL t300sub_y_chk(g_fec.fec01)    #CALL 原check段
           IF g_success = "Y" THEN
              CALL t300sub_y_upd(g_fec.fec01,g_action_choice)    #CALL原upd段
              CALL t300sub_refresh(g_fec.fec01) RETURNING g_fec.*        #重新讀入g_fec.*
              CALL t300_show()
           END IF
        END IF 
        EXIT WHILE
    END WHILE
     LET g_cmd = 'a'    #MOD-580153
     LET g_wc = ' '   #MOD-580153
     LET g_wc2 = ' '  #FUN-850024 ADD    
END FUNCTION
 
FUNCTION t300_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fec.fec01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_fec.* FROM fec_file
     WHERE fec01=g_fec.fec01
 
    IF g_fec.fec06 matches '[Ss]'  THEN
       CALL cl_err('','apm-030', 0)
       RETURN
    END IF
 
    IF g_fec.fecacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_fec.fec01,'mfg1000',0)
        RETURN
    END IF
    IF g_fec.fecconf = 'X' THEN RETURN END IF  #CHI-C80041
    IF g_fec.fecconf = 'Y' THEN                                                 
       CALL cl_err('','9023',0)                                              
       RETURN                                                                   
    END IF                                                                      
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fec01_t = g_fec.fec01
 
    BEGIN WORK
 
    OPEN t300_cl USING g_fec.fec01
    IF STATUS THEN
       CALL cl_err("OPEN t300_cl:", STATUS, 1)
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t300_cl INTO g_fec.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fec.fec01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t300_cl ROLLBACK WORK RETURN
    END IF
    CALL t300_show()
    WHILE TRUE
        LET g_fec01_t = g_fec.fec01
        LET g_fec_o.* = g_fec.*
        LET g_fec.fecmodu=g_user
        LET g_fec.fecdate=g_today
        CALL t300_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fec.*=g_fec_t.*
            CALL t300_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_fec.fec01 != g_fec01_t THEN            # 更改單號
            UPDATE fed_file SET fed01 = g_fec.fec01
                WHERE fed01 = g_fec01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","fed_file",g_fec01_t,"",SQLCA.sqlcode,"","fed",1) # FUN-660136               
                CONTINUE WHILE
            END IF
        END IF
        LET g_fec.fec06 = '0'      #FUN-910038 add
        UPDATE fec_file SET fec_file.* = g_fec.*
            WHERE fec01 = g_fec.fec01
        IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","fec_file",g_fec01_t,"",SQLCA.sqlcode,"","",1) # FUN-660136
             CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t300_cl
    DISPLAY BY NAME g_fec.fec06      #FUN-910038 add
    CALL t300_field_pic()            #FUN-910038 add
    COMMIT WORK
    CALL cl_flow_notify(g_fec.fec01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION t300_i(p_cmd)
DEFINE
    l_n		LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
DEFINE li_result   LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE l_bdate LIKE type_file.dat #MOD-9A0112                                                                                       
DEFINE l_edate LIKE type_file.dat #MOD-9A0112     
    DISPLAY BY NAME
    g_fec.fec01,g_fec.fec02,g_fec.fec07,g_fec.fec05,g_fec.fec03,g_fec.fec04,g_fec.fecconf, #No.FUN-840241 add fecconf  #FUN-910038 add fec07
    g_fec.fecuser,g_fec.fecgrup,g_fec.fecmodu,g_fec.fecdate,g_fec.fecacti
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
  
    INPUT BY NAME g_fec.fecoriu,g_fec.fecorig,
    g_fec.fec01,g_fec.fec02,g_fec.fec07,g_fec.fec05,g_fec.fec03,g_fec.fec04,    #FUN-910038 add fec07
    g_fec.fecconf,g_fec.fec06,g_fec.fecmksg,       #No.FUN-840241 add fecconf   #FUN-910038 add fec06,fecmksg
    g_fec.fecuser,g_fec.fecgrup,g_fec.fecmodu,g_fec.fecdate,g_fec.fecacti,
    g_fec.fecud01,g_fec.fecud02,g_fec.fecud03,g_fec.fecud04,
    g_fec.fecud05,g_fec.fecud06,g_fec.fecud07,g_fec.fecud08,
    g_fec.fecud09,g_fec.fecud10,g_fec.fecud11,g_fec.fecud12,
    g_fec.fecud13,g_fec.fecud14,g_fec.fecud15 
    WITHOUT DEFAULTS
 
    BEFORE INPUT
       LET g_before_input_done = FALSE
       CALL t300_set_entry(p_cmd)
       CALL t300_set_no_entry(p_cmd)
       LET g_before_input_done = TRUE
         CALL cl_set_docno_format("fec01")
 
    AFTER FIELD fec01
        IF NOT cl_null(g_fec.fec01) THEN                                 #FUN-910038 add
    CALL s_check_no("afa",g_fec.fec01,g_fec01_t,"D","fec_file","fec01","")
         RETURNING li_result,g_fec.fec01
    DISPLAY BY NAME g_fec.fec01
       IF (NOT li_result) THEN
          NEXT FIELD fec01
       END IF

                 LET g_t1 = s_get_doc_no(g_fec.fec01)       #No.FUN-550034
               SELECT * INTO g_fah.* FROM fah_file WHERE fahslip = g_t1

            IF (g_fec.fec01 != g_fec_t.fec01) OR g_fec_t.fec01 IS NULL THEN
               LET g_fec.fecmksg = g_fah.fahapr
               DISPLAY BY NAME g_fec.fecmksg
            END IF
 
            END IF
            LET g_fec_o.fec01 = g_fec.fec01
        
        AFTER FIELD fec02                                                                                                            
           IF NOT cl_null(g_fec.fec02) THEN                                                                                          
              CALL s_azn01(g_faa.faa07,g_faa.faa08) RETURNING l_bdate,l_edate                                                        
              IF g_fec.fec02 < l_bdate                                                                                               
                 THEN CALL cl_err(g_fec.fec02,'afa-130',0)                                                                           
                 NEXT FIELD fec02                                                                                                    
              END IF                                                                                                                 
             #FUN-B60140   ---start   Add
              IF g_faa.faa31 = "Y" THEN
                 CALL s_azn01(g_faa.faa072,g_faa.faa082) RETURNING l_bdate,l_edate
                 IF g_fec.fec02 < l_bdate
                    THEN CALL cl_err(g_fec.fec02,'afa-130',0)
                    NEXT FIELD fec02
                 END IF
              END IF
             #FUN-B60140   ---end     Add
           END IF                                                                                                                    
  
        AFTER FIELD fec05
          IF cl_null(g_fec.fec05) AND g_fec.fec05 NOT MATCHES '[12]' THEN
             NEXT FIELD fec05
          ELSE                 #No.TQC-770108
             NEXT FIELD fec03  #No.TQC-770108
          END IF
 
        AFTER FIELD fec03                       #部門代號
          IF NOT cl_null(g_fec.fec03) THEN
             CALL t300_fec03(p_cmd)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_fec.fec03,g_errno,0)
                LET g_fec.fec03 = g_fec_o.fec03
                DISPLAY BY NAME g_fec.fec03
                NEXT FIELD fec03
             END IF
          END IF
          LET g_fec_o.fec03 = g_fec.fec03
 
        AFTER FIELD fec07                #申請人
          IF NOT cl_null(g_fec.fec07) THEN
             CALL t300_fec07('a')
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_fec.fec07,g_errno,0)
                LET g_fec.fec07 = g_fec_o.fec07
                DISPLAY BY NAME g_fec.fec07
                NEXT FIELD fec07
             END IF
          END IF
        LET g_fec_o.fec07 = g_fec.fec07
 
        AFTER FIELD fecud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fecud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fecud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fecud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fecud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fecud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fecud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fecud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fecud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fecud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fecud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fecud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fecud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fecud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fecud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG                  #欄位說明
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(fec01) #單據編號
                    LET g_t1 = s_get_doc_no(g_fec.fec01)       #No.FUN-550034
                   CALL q_fah( FALSE, TRUE,g_t1,'D','AFA') RETURNING g_t1    #TQC-670008
                    LET g_fec.fec01 = g_t1      #No.FUN-550034
 
                   DISPLAY BY NAME g_fec.fec01
                   NEXT FIELD fec01
              WHEN INFIELD(fec03) #部門代號
                   IF g_fec.fec05='1' THEN
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_gem"
                      LET g_qryparam.default1 = g_fec.fec03
                      CALL cl_create_qry() RETURNING g_fec.fec03
                   ELSE
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_pmc3"
                      LET g_qryparam.default1 = g_fec.fec03
                      CALL cl_create_qry() RETURNING g_fec.fec03
                   END IF
                   DISPLAY BY NAME g_fec.fec03
                      CALL t300_fec03('d')
                      NEXT FIELD fec03
                     NEXT FIELD fec03
              WHEN INFIELD(fec07) #申請人
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   LET g_qryparam.default1 = g_fec.fec07
                   CALL cl_create_qry() RETURNING g_fec.fec07
                   DISPLAY BY NAME g_fec.fec07
                   NEXT FIELD fec07
 
              OTHERWISE
                    EXIT CASE
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION t300_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fec01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t300_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fec01",FALSE)
    END IF
 
END FUNCTION
 

FUNCTION t300_fec03(p_cmd)  #部門代號
    DEFINE l_gem02 LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti,
           p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
  LET g_errno = " "
  IF g_fec.fec05 ='1' THEN
     SELECT gem02,gemacti INTO l_gem02,l_gemacti
       FROM gem_file
      WHERE gem01 = g_fec.fec03
  ELSE
     SELECT pmc03,pmcacti INTO l_gem02,l_gemacti
       FROM pmc_file
      WHERE pmc01 = g_fec.fec03
  END IF
  CASE WHEN SQLCA.SQLCODE = 100
                       IF g_fec.fec05='1' THEN
                          LET g_errno = 'afa-083'
                       ELSE
                          LET g_errno = 'aom-061'
                       END IF
                       LET l_gem02 = NULL
       WHEN l_gemacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
 IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gem02 TO FORMONLY.gem02
 END IF
END FUNCTION
 
#Query 查詢
FUNCTION t300_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fec.* TO NULL             #No.FUN-6A0001
    MESSAGE ""
    CALL cl_opmsg('q')
    CLEAR FORM
    CALL g_fed.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t300_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_fec.* TO NULL
        RETURN
    END IF
    OPEN t300_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fec.* TO NULL
    ELSE
        OPEN t300_count
        FETCH t300_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t300_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t300_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t300_cs INTO g_fec.fec01
        WHEN 'P' FETCH PREVIOUS t300_cs INTO g_fec.fec01
        WHEN 'F' FETCH FIRST    t300_cs INTO g_fec.fec01
        WHEN 'L' FETCH LAST     t300_cs INTO g_fec.fec01
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
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t300_cs INTO g_fec.fec01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fec.fec01,SQLCA.sqlcode,0)
        INITIALIZE g_fec.* TO NULL  #TQC-6B0105
        LET g_fec.fec01 = NULL      #TQC-6B0105
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
    SELECT * INTO g_fec.* FROM fec_file WHERE fec01 =g_fec.fec01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","fec_file",g_fec.fec01,"",SQLCA.sqlcode,"","",1) # FUN-660136
        INITIALIZE g_fec.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_fec.fecuser   #FUN-4C0059
    LET g_data_group = g_fec.fecgrup   #FUN-4C0059
    CALL t300_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t300_show()
    LET g_fec_t.* = g_fec.*                #保存單頭舊值
    LET g_fec_o.* = g_fec.*                #保存單頭舊值
    DISPLAY BY NAME g_fec.fecoriu,g_fec.fecorig,                              # 顯示單頭值
 
 
        g_fec.fec01,g_fec.fec02,g_fec.fec07,g_fec.fec05,    #FUN-910038 add fec07
        g_fec.fec06,g_fec.fecmksg,                          #FUN-910038 add
        g_fec.fec03,g_fec.fec04,g_fec.fecuser,
        g_fec.fecgrup,g_fec.fecmodu,g_fec.fecdate,
        g_fec.fecacti,
        g_fec.fecud01,g_fec.fecud02,g_fec.fecud03,g_fec.fecud04,
        g_fec.fecud05,g_fec.fecud06,g_fec.fecud07,g_fec.fecud08,
        g_fec.fecud09,g_fec.fecud10,g_fec.fecud11,g_fec.fecud12,
        g_fec.fecud13,g_fec.fecud14,g_fec.fecud15,g_fec.fecconf #No.FUN-840241 add fecconf 
    CALL t300_field_pic()                                #FUN-910038 add
    CALL t300_fec03('d')
    CALL t300_fec07('d')                                 #FUN-910038 add
    CALL t300_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t300_r()
DEFINE l_fed03    LIKE  fed_file.fed03,
       l_fed04    LIKE  fed_file.fed04,
       l_feb12    LIKE  feb_file.feb12,
       l_sumfed04 LIKE  fed_file.fed04,
       l_sumfef04 LIKE  fef_file.fef04
DEFINE l_cnt      LIKE  type_file.num5    #No.MOD-840007 add
    IF s_shut(0) THEN RETURN END IF
    IF g_fec.fec01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
    IF g_fec.fecacti = 'N' THEN RETURN END IF
 
    IF g_fec.fec06 matches '[Ss]' THEN
       CALL cl_err('','apm-030',0)
       RETURN
    END IF
    IF g_fec.fecconf = 'X' THEN RETURN END IF  #CHI-C80041
    IF g_fec.fecconf = 'Y' THEN 
       CALL cl_err('','9023',0) 
       RETURN 
    END IF
    SELECT * INTO g_fec.* FROM fec_file
     WHERE fec01=g_fec.fec01
 
    BEGIN WORK
 
    OPEN t300_cl USING g_fec.fec01
    IF STATUS THEN
       CALL cl_err("OPEN t300_cl:", STATUS, 1)
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t300_cl INTO g_fec.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fec.fec01,SQLCA.sqlcode,0)          #資料被他人LOCK
        CLOSE t300_cl ROLLBACK WORK RETURN
    END IF
 
    CALL t300_show()
 
    DECLARE t300_r CURSOR FOR
        SELECT fed03,fed04 FROM fed_file WHERE fed01=g_fec.fec01
    FOREACH t300_r INTO l_fed03,l_fed04

        SELECT COUNT(*) INTO l_cnt FROM fef_file
            WHERE fef03 = l_fed03
        IF l_cnt > 0  THEN
           CALL cl_err(' ','afa-917',0)
           RETURN
        END IF
    END FOREACH
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fec01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fec.fec01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
        DELETE FROM fec_file WHERE fec01 = g_fec.fec01
           IF SQLCA.SQLERRD[3]=0 THEN
              CALL cl_err('del fec',SQLCA.SQLCODE,0)              
              ROLLBACK WORK RETURN
           END IF
        FOREACH t300_r INTO l_fed03,l_fed04

        DELETE FROM fed_file WHERE fed01 = g_fec.fec01
                               AND fed03 = l_fed03
           IF SQLCA.sqlcode THEN
              CALL cl_err3("del","fed_file",g_fec.fec01,l_fed03,SQLCA.sqlcode,"","del fed",1) # FUN-660136
              ROLLBACK WORK RETURN
           END IF
        END FOREACH
        CLEAR FORM
        CALL g_fed.clear()
        OPEN t300_count
        FETCH t300_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t300_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t300_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t300_fetch('/')
        END IF
    END IF
 
    CLOSE t300_cl
    COMMIT WORK
    CALL cl_flow_notify(g_fec.fec01,'D')
 
END FUNCTION
 
FUNCTION t300_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    l_ecm03         LIKE ecm_file.ecm03,
    l_feb06         LIKE feb_file.feb06,
    l_feb07         LIKE feb_file.feb07,         #MOD-A60117
    l_feb09         LIKE feb_file.feb09,         #MOD-A60117
    l_fed04         LIKE fed_file.fed04,
    l_fef04         LIKE fef_file.fef04,
    l_sum           LIKE type_file.chr6,         #No.FUN-680070 VARCHAR(06)
    l_sfb02         LIKE sfb_file.sfb02,
    l_feb12_t       LIKE feb_file.feb12,
    l_feb12         LIKE feb_file.feb12,
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否       #No.FUN-680070 SMALLINT
    l_fec06         LIKE fec_file.fec06                        #FUN-910038 add
DEFINE l_faj22      LIKE faj_file.faj22          #FUN-A60056 

    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_fec.fec01 IS NULL THEN
        RETURN
    END IF
    SELECT * INTO g_fec.* FROM fec_file
     WHERE fec01=g_fec.fec01
  
    LET l_fec06 = g_fec.fec06     #FUN-910038 add
    
    IF g_fec.fecacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_fec.fec01,'mfg1000',0)
        RETURN
    END IF
 
    IF g_fec.fec06 matches '[Ss]' THEN
       CALL cl_err('', 'apm-030',0)
       RETURN
    END IF
    IF g_fec.fecconf = 'X' THEN RETURN END IF  #CHI-C80041
    IF g_fec.fecconf = 'Y' THEN CALL cl_err('','apm-242',0) RETURN END IF #No.FUN-840241
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT fed02,fed03,' ',fed04,fed05,fed06,' ', ",
                       "        fedud01,fedud02,fedud03,fedud04,fedud05,",
                       "        fedud06,fedud07,fedud08,fedud09,fedud10,",
                       "        fedud11,fedud12,fedud13,fedud14,fedud15 ", 
                       " FROM fed_file ",
                       " WHERE fed01= ?  ",
                       " AND  fed02 = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t300_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_fed.clear() END IF
 
 
        INPUT ARRAY g_fed WITHOUT DEFAULTS FROM s_fed.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
           CALL cl_set_docno_format("fed05")    #No.FUN-560060
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t300_cl USING g_fec.fec01
            IF STATUS THEN
               CALL cl_err("OPEN t300_cl:", STATUS, 1)
               CLOSE t300_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t300_cl INTO g_fec.*            # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fec.fec01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t300_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_fed_t.* = g_fed[l_ac].*  #BACKUP
 
                OPEN t300_bcl USING g_fec.fec01,g_fed_t.fed02
                IF STATUS THEN
                   CALL cl_err("OPEN t300_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                   CLOSE t300_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t300_bcl INTO g_fed[l_ac].*
                   IF SQLCA.sqlcode THEN
                       CALL cl_err(g_fed_t.fed02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       SELECT fea02 INTO g_fed[l_ac].fea02
                         FROM fea_file
                        WHERE fea01=(SELECT feb01 FROM feb_file
                                         WHERE feb02=g_fed[l_ac].fed03)
                       SELECT ecd02 INTO g_fed[l_ac].ecd02
                         FROM ecd_file
                        WHERE ecd01=g_fed[l_ac].fed06
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              INITIALIZE g_fed[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_fed[l_ac].* TO s_fed.*
              CALL g_fed.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
               CANCEL INSERT
            END IF
            INSERT INTO fed_file(fed01,fed02,fed03,
                                 fed04,fed05,fed06,
                                 fedud01,fedud02,fedud03,
                                 fedud04,fedud05,fedud06,
                                 fedud07,fedud08,fedud09,
                                 fedud10,fedud11,fedud12,
                                 fedud13,fedud14,fedud15,
                                 fedlegal) #FUN-980003 add
            VALUES(g_fec.fec01,g_fed[l_ac].fed02,
                   g_fed[l_ac].fed03,g_fed[l_ac].fed04,
                   g_fed[l_ac].fed05,g_fed[l_ac].fed06,
                   g_fed[l_ac].fedud01,g_fed[l_ac].fedud02,
                   g_fed[l_ac].fedud03,g_fed[l_ac].fedud04,
                   g_fed[l_ac].fedud05,g_fed[l_ac].fedud06,
                   g_fed[l_ac].fedud07,g_fed[l_ac].fedud08,
                   g_fed[l_ac].fedud09,g_fed[l_ac].fedud10,
                   g_fed[l_ac].fedud11,g_fed[l_ac].fedud12,
                   g_fed[l_ac].fedud13,g_fed[l_ac].fedud14,
                   g_fed[l_ac].fedud15,
                   g_legal) #FUN-980003 add
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err3("ins","fed_file",g_fec.fec01,g_fed[l_ac].fed02,SQLCA.sqlcode,"","",1) # FUN-660136         
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET l_fec06 = '0'              #FUN-910038 add
                LET g_rec_b=g_rec_b+1
 
                COMMIT WORK
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_fed[l_ac].* TO NULL      #900423
            LET g_fed_t.* = g_fed[l_ac].*         #新輸入資料
            LET g_fed_o.* = g_fed[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fed02
 
        BEFORE FIELD fed02                        #default 序號
            IF g_fed[l_ac].fed02 IS NULL OR
               g_fed[l_ac].fed02 = 0 THEN
                SELECT max(fed02)+1 INTO g_fed[l_ac].fed02 FROM fed_file
                 WHERE fed01 = g_fec.fec01
                IF g_fed[l_ac].fed02 IS NULL THEN
                    LET g_fed[l_ac].fed02 = 1
                END IF
            END IF
 
        AFTER FIELD fed02                        #check 序號是否重複
            IF NOT cl_null(g_fed[l_ac].fed02) THEN
               IF g_fed[l_ac].fed02 != g_fed_t.fed02 OR
                  g_fed_t.fed02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM fed_file
                    WHERE fed01 = g_fec.fec01 AND fed02 = g_fed[l_ac].fed02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_fed[l_ac].fed02 = g_fed_t.fed02
                       NEXT FIELD fed02
                   END IF
               END IF
            END IF
 
 
        AFTER FIELD fed03                  #模具編號
            IF NOT cl_null(g_fed[l_ac].fed03) THEN
               IF g_fed_t.fed03 IS NULL OR (g_fed[l_ac].fed03 != g_fed_t.fed03)
               THEN
                  SELECT COUNT(*) INTO l_cnt FROM fed_file  #檢查重複用
                   WHERE fed01=g_fec.fec01 AND fed03=g_fed[l_ac].fed03
                  IF l_cnt>0 THEN
                     CALL cl_err(g_fed[l_ac].fed03,'afa-906',0)
                     NEXT FIELD fed03
                  END IF
                  SELECT COUNT(*) INTO l_cnt FROM feb_file   #check存在feb
                   WHERE feb02=g_fed[l_ac].fed03
                  IF l_cnt=0 THEN
                     CALL cl_err('','afa-907',0)
                     NEXT FIELD fed03
                  END IF
                 #-MOD-A60117-add-
                  SELECT feb07,feb09 INTO l_feb07,l_feb09
                    FROM feb_file
                   WHERE feb02 = g_fed[l_ac].fed03  
                  IF l_feb07 = l_feb09 THEN
                     CALL cl_err(g_fed[l_ac].fed03,'afa-913',0)
                     NEXT FIELD fed03
                  END IF
                 #-MOD-A60117-end- 
                  CALL t300_fed03('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_fed[l_ac].fed03,g_errno,0)
                     LET g_fed[l_ac].fed03 = g_fed_o.fed03
                     DISPLAY BY NAME g_fed[l_ac].fed03
                     NEXT FIELD fed03
                  END IF
                END IF
             END IF
            LET g_fed_o.fed03 = g_fed[l_ac].fed03
 
        AFTER FIELD fed04                          #數量
            IF NOT cl_null(g_fed[l_ac].fed04) THEN
               IF g_fed[l_ac].fed04 <= 0 THEN
                   CALL cl_err('','afa-037',0)
                   NEXT FIELD fed04
               END IF
               IF p_cmd='a' THEN LET g_fed_t.fed04=0  END IF
               SELECT feb06 INTO l_feb06 FROM feb_file
                WHERE feb02 = g_fed[l_ac].fed03
               SELECT sum(fed04) INTO l_fed04 FROM fed_file
                WHERE fed03 = g_fed[l_ac].fed03
               SELECT sum(fef04) INTO l_fef04 FROM fef_file
                WHERE fef03 = g_fed[l_ac].fed03
               IF l_feb06 IS NULL THEN  LET l_feb06=0 END IF
               IF l_fed04 IS NULL THEN  LET l_fed04=0 END IF
               IF l_fef04 IS NULL THEN  LET l_fef04=0 END IF
               IF g_fed[l_ac].fed03 != g_fed_t.fed03 THEN
                   LET l_sum = l_feb06 -(l_fed04 + g_fed[l_ac].fed04)
                           + l_fef04
               ELSE
                   LET l_sum = l_feb06 -(l_fed04 - g_fed_t.fed04 + g_fed[l_ac].fed04)
                           + l_fef04
               END IF
               IF l_sum < 0  THEN
                   CALL cl_err('','afa-910',0)
                   NEXT FIELD fed04
               END IF
            END IF
 
        AFTER FIELD fed05                          #工單編號
            IF cl_null(g_fed[l_ac].fed05) THEN
               LET g_fed[l_ac].fed06 = ''
               LET g_fed[l_ac].ecd02 = ''
               DISPLAY BY NAME g_fed[l_ac].fed06
               DISPLAY BY NAME g_fed[l_ac].ecd02
               NEXT FIELD ecd02
            ELSE
               IF g_fed_o.fed05 IS NULL OR
                  (g_fed[l_ac].fed05 != g_fed_o.fed05) THEN
                 #FUN-A60056--mod--str--
                 #SELECT sfb02 INTO l_sfb02 FROM sfb_file   #check存在sfb
                 # WHERE sfb01=g_fed[l_ac].fed05 AND sfb87!='X'
                 #   AND  sfb04 ='1'                 #MOD-970110 
                  SELECT faj22 INTO l_faj22 FROM faj_file,fed_file,feb_file
                   WHERE feb02 = g_fed[l_ac].fed03 AND fed03 = feb02
                     AND feb04 = faj02 AND feb05 = faj022
                  LET g_sql = "SELECT sfb02 FROM ",cl_get_target_table(l_faj22,'sfb_file'),
                              " WHERE sfb01='",g_fed[l_ac].fed05,"' AND sfb87!='X' ",
                              #"   AND  sfb04 ='1' " 
                              "   AND  sfb04 NOT IN ('6','7','8') "   #TQC-B20148 不結案的都可以領用磨具
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql
                  CALL cl_parse_qry_sql(g_sql,l_faj22) RETURNING g_sql
                  PREPARE sel_sfb02 FROM g_sql
                  EXECUTE sel_sfb02 INTO l_sfb02
                 #FUN-A60056--mod--end
                  IF SQLCA.SQLCODE <>0  THEN
                     CALL cl_err3("sel","sfb_file",g_fed[l_ac].fed05,"","afa-908","","",1)  # FUN-660136                  
                     NEXT FIELD fed05
                  END IF
                  #No.B608 類別='2'時必須為委外工單
                  IF g_fec.fec05='2' AND l_sfb02 <> '7' THEN
                     CALL cl_err('','afa-200',0)
                     NEXT FIELD fed05
                  END IF
               END IF
            END IF
 
        AFTER FIELD fed06                 #作業編號
            IF cl_null(g_fed[l_ac].fed06) THEN
               LET g_fed[l_ac].ecd02 = ''
               DISPLAY BY NAME g_fed[l_ac].ecd02
            ELSE
               SELECT COUNT(*) INTO l_cnt FROM ecd_file   #check存在ecd
                WHERE ecd01=g_fed[l_ac].fed06
               IF l_cnt=0 THEN
                  CALL cl_err('','afa-909',0)
                  NEXT FIELD fed06
               END IF
               CALL t300_fed06('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fed[l_ac].fed06,g_errno,0)
                  LET g_fed[l_ac].fed06 = g_fed_o.fed06
                  DISPLAY BY NAME g_fed[l_ac].fed06
                  NEXT FIELD fed06
               END IF
              #FUN-A60056--mod--str--
              #SELECT COUNT(*) INTO l_cnt FROM ecm_file
              # WHERE ecm01=g_fed[l_ac].fed05 AND ecm04=g_fed[l_ac].fed06
               SELECT faj22 INTO l_faj22 FROM faj_file,fed_file,feb_file
                   WHERE feb02 = g_fed[l_ac].fed03 AND fed03 = feb02
                     AND feb04 = faj02 AND feb05 = faj022
               LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_faj22,'ecm_file'),
                           " WHERE ecm01='",g_fed[l_ac].fed05,"'",
                           "   AND ecm04='",g_fed[l_ac].fed06,"'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql
               CALL cl_parse_qry_sql(g_sql,l_faj22) RETURNING g_sql
               PREPARE sel_cou_ecm FROM g_sql
               EXECUTE sel_cou_ecm INTO l_cnt
              #FUN-A60056--mod--end
               IF l_cnt = 0 THEN
                  CALL cl_err(g_fed[l_ac].fed06,'asf-905',0)
                  LET g_fed[l_ac].fed06 = g_fed_o.fed06
                  DISPLAY BY NAME g_fed[l_ac].fed06
                  NEXT FIELD fed06
               END IF
            END IF
            LET g_fed_o.fed06 = g_fed[l_ac].fed06
 
        AFTER FIELD fedud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fedud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fedud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fedud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fedud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fedud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fedud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fedud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fedud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fedud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fedud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fedud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fedud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fedud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fedud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_fed_t.fed02 > 0 AND
               NOT cl_null(g_fed_t.fed02) THEN
                SELECT sum(fed04) INTO l_fed04
                    FROM fed_file
                WHERE fed03 = g_fed_t.fed03
 
               SELECT sum(fef04) INTO l_fef04
                    FROM fef_file
                WHERE fef03 = g_fed_t.fed03
                IF l_fed04 - g_fed_t.fed04 < l_fef04 THEN
                   CALL cl_err(' ','afa-916',0)
                   EXIT INPUT
                ELSE
                    IF NOT cl_delb(0,0) THEN
                       CANCEL DELETE
                    END IF
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM fed_file
                    WHERE fed01 = g_fec.fec01 AND
                          fed02 = g_fed_t.fed02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","fed_file",g_fec.fec01,g_fed_t.fed02,SQLCA.sqlcode,"","del fed",1)  # FUN-660136
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF

                   LET l_fec06 = '0'     #FUN-910038 add
                   LET g_rec_b=g_rec_b-1
                   COMMIT WORK
                   DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fed[l_ac].* = g_fed_t.*
               CLOSE t300_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fed[l_ac].fed02,-263,1)
               LET g_fed[l_ac].* = g_fed_t.*
            ELSE
               UPDATE fed_file SET
                   fed02=g_fed[l_ac].fed02,fed03=g_fed[l_ac].fed03,
                   fed04=g_fed[l_ac].fed04,fed05=g_fed[l_ac].fed05,
                   fed06=g_fed[l_ac].fed06,
                   fedud01 = g_fed[l_ac].fedud01,fedud02 = g_fed[l_ac].fedud02,
                   fedud03 = g_fed[l_ac].fedud03,fedud04 = g_fed[l_ac].fedud04,
                   fedud05 = g_fed[l_ac].fedud05,fedud06 = g_fed[l_ac].fedud06,
                   fedud07 = g_fed[l_ac].fedud07,fedud08 = g_fed[l_ac].fedud08,
                   fedud09 = g_fed[l_ac].fedud09,fedud10 = g_fed[l_ac].fedud10,
                   fedud11 = g_fed[l_ac].fedud11,fedud12 = g_fed[l_ac].fedud12,
                   fedud13 = g_fed[l_ac].fedud13,fedud14 = g_fed[l_ac].fedud14,
                   fedud15 = g_fed[l_ac].fedud15
                WHERE fed01=g_fec.fec01 AND fed02=g_fed_t.fed02
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                   CALL cl_err3("upd","fed_file",g_fec.fec01,g_fed_t.fed02,SQLCA.sqlcode,"","",1)  # FUN-660136                  
                   LET g_fed[l_ac].* = g_fed_t.*
               ELSE
                 MESSAGE 'UPDATE O.K'
                 LET l_fec06 = '0'      #FUN-910038 add

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
                  LET g_fed[l_ac].* = g_fed_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_fed.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE t300_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 add 
            CLOSE t300_bcl
            COMMIT WORK
           #CALL g_fed.deleteElement(g_rec_b+1) #FUN-D30032 mark
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fed02) AND l_ac > 1 THEN
                LET g_fed[l_ac].* = g_fed[l_ac-1].*
                LET g_fed[l_ac].fed02 = NULL   #TQC-620018
                NEXT FIELD fed02
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(fed03) #模具編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_feb"
                   LET g_qryparam.default1 = g_fed[l_ac].fed03
                   CALL cl_create_qry() RETURNING g_fed[l_ac].fed03
                    DISPLAY g_fed[l_ac].fed03 TO fed03             #No.MOD-490344
                   CALL  t300_fed03('d')
                   NEXT FIELD fed03
              WHEN INFIELD(fed05)     #工單編號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sfb"
                   LET g_qryparam.where = "sfb04= '1'"
                   LET g_qryparam.default1 = g_fed[l_ac].fed05
                   CALL cl_create_qry() RETURNING g_fed[l_ac].fed05
                    DISPLAY g_fed[l_ac].fed05 TO fed05             #No.MOD-490344
                   NEXT FIELD fed05
              WHEN INFIELD(fed06) #作業編號
                  #CALL q_ecm(FALSE,FALSE,g_fed[l_ac].fed05,'')   #FUN-C30163 mark
                   CALL q_ecm(FALSE,FALSE,g_fed[l_ac].fed05,'','','','','')  #FUN-C30163 add
                        RETURNING g_fed[l_ac].fed06,l_ecm03
                   DISPLAY BY NAME g_fed[l_ac].fed06

              OTHERWISE
                   EXIT CASE
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
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
 
    END INPUT
 
    LET g_fec.fecmodu = g_user
    LET g_fec.fecdate = g_today
    LET g_fec.fec06 = l_fec06      #FUN-910038 add
    UPDATE fec_file SET fecmodu = g_fec.fecmodu,fecdate = g_fec.fecdate, fec06 = g_fec.fec06   #FUN-910038 add fec06
     WHERE fec01 = g_fec.fec01
    DISPLAY BY NAME g_fec.fecmodu,g_fec.fecdate,g_fec.fec06    #FUN-910038 add fec06
    CALL t300_field_pic()              #FUN-910038 add
 
    CLOSE t300_bcl
    COMMIT WORK
    CALL t300_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t300_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_fec.fec01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM fec_file ",
                  "  WHERE fec01 LIKE '",l_slip,"%' ",
                  "    AND fec01 > '",g_fec.fec01,"'"
      PREPARE t300_pb1 FROM l_sql 
      EXECUTE t300_pb1 INTO l_cnt       
      
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
         CALL t300_v()
         CALL t300_field_pic()
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM fec_file WHERE fec01 = g_fec.fec01
         INITIALIZE g_fec.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t300_b_askkey()
DEFINE
    l_wc2           STRING        #TQC-630166
 
    CONSTRUCT l_wc2 ON fed02,fed03,fed04,fed05,
                       fed06,fea02,ecd02 # 螢幕上取單身條件
                       ,fedud01,fedud02,fedud03,fedud04,fedud05
                       ,fedud06,fedud07,fedud08,fedud09,fedud10
                       ,fedud11,fedud12,fedud13,fedud14,fedud15
            FROM s_fed[1].fed02,s_fed[1].fed03,s_fed[1].fed04,
                 s_fed[1].fed05,s_fed[1].fed06,s_fed[1].fea02,
                 s_fed[1].ecd02
                 ,s_fed[1].fedud01,s_fed[1].fedud02,s_fed[1].fedud03
                 ,s_fed[1].fedud04,s_fed[1].fedud05,s_fed[1].fedud06
                 ,s_fed[1].fedud07,s_fed[1].fedud08,s_fed[1].fedud09
                 ,s_fed[1].fedud10,s_fed[1].fedud11,s_fed[1].fedud12
                 ,s_fed[1].fedud13,s_fed[1].fedud14,s_fed[1].fedud15
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
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL t300_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t300_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           STRING        #TQC-630166
 
    IF cl_null(p_wc2) THEN LET p_wc2='1=1 ' END IF
    LET g_sql =
        " SELECT fed02,fed03,fea02,fed04,fed05,fed06,ecd02, ",
        "        fedud01,fedud02,fedud03,fedud04,fedud05,",
        "        fedud06,fedud07,fedud08,fedud09,fedud10,",
        "        fedud11,fedud12,fedud13,fedud14,fedud15 ", 
        " FROM feb_file,fec_file,fea_file,fed_file LEFT OUTER JOIN ecd_file ON ecd01=fed06 ",
        " WHERE fed03 = feb02 AND",  #單頭
        " feb01=fea01 AND fed01 = fec01 AND fec01='",g_fec.fec01,"' AND ",
        p_wc2 CLIPPED," ORDER BY 1"   #單身
    PREPARE t300_pb FROM g_sql
    DECLARE fed_cs                       #SCROLL CURSOR
        CURSOR FOR t300_pb
 
    CALL g_fed.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fed_cs INTO g_fed[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_fed.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fed TO s_fed.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t300_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t300_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t300_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t300_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t300_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
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
      ON ACTION confirm                                                         
         LET g_action_choice="confirm"                                          
         EXIT DISPLAY   
      ON ACTION undo_confirm                                                         
         LET g_action_choice="undo_confirm"                                          
         EXIT DISPLAY 
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL t300_field_pic()                                  #FUN-910038 add
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
         EXIT DISPLAY
 
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
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
      &include "qry_string.4gl"
 
     #ON ACTION EasyFlow送簽
      ON ACTION easyflow_approval            
         LET g_action_choice = "easyflow_approval"
         EXIT DISPLAY
 
     #@ON ACTION 簽核狀況
      ON ACTION approval_status     
         LET g_action_choice="approval_status"
         EXIT DISPLAY
 
      ON ACTION agree   #准
         LET g_action_choice = 'agree'
         EXIT DISPLAY
 
      ON ACTION deny    #不准
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
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t300_fed03(p_cmd)  #模具編號
    DEFINE l_fea02    LIKE fea_file.fea02,
           l_feaacti  LIKE fea_file.feaacti,
           p_cmd      LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT fea02,feaacti
      INTO l_fea02,l_feaacti
      FROM fea_file WHERE fea01 =(SELECT feb01 FROM feb_file
                                      WHERE feb02=g_fed[l_ac].fed03)
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'afa-907'
                            LET l_fea02 = NULL
         WHEN l_feaacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        LET g_fed[l_ac].fea02 = l_fea02
        DISPLAY g_fed[l_ac].fea02 TO fea02
    END IF
END FUNCTION
 
FUNCTION t300_fed06(p_cmd)  #作業編號
    DEFINE l_ecd02    LIKE ecd_file.ecd02,
           l_ecdacti  LIKE ecd_file.ecdacti,
           p_cmd      LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ecd02,ecdacti
      INTO l_ecd02,l_ecdacti
      FROM ecd_file WHERE ecd01 = g_fed[l_ac].fed06
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                            LET l_ecd02 = NULL
         WHEN l_ecdacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
        LET g_fed[l_ac].ecd02 = l_ecd02
        DISPLAY g_fed[l_ac].ecd02 TO ecd02
    END IF
END FUNCTION
 
FUNCTION t300_x()
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fec.fec01 IS NULL THEN
        CALL cl_err("",-400,0)
        RETURN
    END IF
 
  #FUN-910038---add---start---    #簽核狀況若為送簽中則不可變更為無效
    IF g_fec.fec06 matches '[Ss1]'  THEN
         CALL cl_err('','mfg3557', 0)
         RETURN
    END IF
 
    IF g_fec.fecconf = 'Y' THEN
       CALL cl_err('',9023,0)
       RETURN
    END IF
 
    BEGIN WORK
 
    OPEN t300_cl USING g_fec.fec01
    IF STATUS THEN
       CALL cl_err("OPEN t300_cl:", STATUS, 1)
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t300_cl INTO g_fec.*# 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fec.fec01,SQLCA.sqlcode,0)#資料被他人LOCK
        ROLLBACK WORK
        RETURN
    END IF
 
    CALL t300_show()
 
    IF cl_exp(0,0,g_fec.fecacti) THEN    #確認一下
       LET g_chr=g_fec.fecacti
       IF g_fec.fecacti='Y' THEN
           LET g_fec.fecacti='N'
           LET g_fec.fec06 = '0'  #FUN-910038 add
       ELSE
           LET g_fec.fecacti='Y'
       END IF
       UPDATE fec_file                    #更改有效碼
           SET fecacti=g_fec.fecacti, fec06=g_fec.fec06    #FUN-910038 add fec06
           WHERE fec01=g_fec.fec01
       IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("upd","fec_file",g_fec.fec01,"",SQLCA.sqlcode,"","",1 )  # FUN-660136   
           LET g_fec.fecacti=g_chr
       END IF
       DISPLAY BY NAME g_fec.fecacti
       DISPLAY BY NAME g_fec.fec06   #FUN-910038
    END IF
 
    CLOSE t300_cl
    COMMIT WORK
 
    CALL t300_field_pic()                                 #FUN-910038 add
    CALL cl_flow_notify(g_fec.fec01,'V')
END FUNCTION
 
FUNCTION t300_z()
   DEFINE l_cnt    LIKE type_file.num5    
   DEFINE l_cmd    LIKE type_file.chr1000 
   DEFINE l_n      LIKE type_file.num5    
   DEFINE l_fed03    LIKE  fed_file.fed03,
          l_fed04    LIKE  fed_file.fed04,
          l_feb12    LIKE  feb_file.feb12
   DEFINE l_fed    RECORD LIKE fed_file.*    #FUN-910038 add
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_fec.fec01) THEN CALL cl_err('',-400,0) RETURN END IF
 
   SELECT * INTO g_fec.* FROM fec_file
    WHERE fec01=g_fec.fec01
   IF g_fec.fecconf = 'X' THEN RETURN END IF  #CHI-C80041
   IF g_fec.fecconf = 'N' THEN CALL cl_err('','9002',0) RETURN END IF
 
   SELECT COUNT(*) INTO l_cnt FROM fee_file,fef_file
    WHERE fee01 = fef01 
      AND fef05 = g_fec.fec01
      AND feeacti <> 'N'
      AND feeconf <> 'X'  #CHI-C80041
   IF l_cnt > 0 THEN
      CALL cl_err(g_fec.fec01,'afa-421',0)
      RETURN
   END IF  
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t300_cl USING g_fec.fec01
   IF STATUS THEN
      CALL cl_err("OPEN t300_cl:", STATUS, 1)
      CLOSE t300_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t300_cl INTO g_fec.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fec.fec01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t300_cl ROLLBACK WORK RETURN
   END IF
 
   IF g_success = 'Y' THEN
      LET g_fec.fecconf = 'N'
      LET g_fec.fec06 = '0'                             #FUN-910038 add 
      UPDATE fec_file SET fecconf = g_fec.fecconf, fec06 = g_fec.fec06  WHERE fec01=g_fec.fec01  #FUN-910038
      IF sqlca.sqlcode THEN
         CALL cl_err3("upd","fec_file",g_fec.fec01,"",STATUS,"","upd fec",1) 
         LET g_success='N'
      END IF
      MESSAGE ""
   ELSE
      LET g_fec.fecconf='Y' ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_fec.fecconf
   DISPLAY BY NAME g_fec.fec06         #FUN-910038 add
   DECLARE t300_r1 CURSOR FOR
    SELECT * INTO l_fed.* FROM fed_file WHERE fed01=g_fec.fec01
   FOREACH t300_r1 INTO l_fed.*            #FUN-910038 add
    SELECT feb12 INTO l_feb12 FROM feb_file WHERE feb02=l_fed.fed03
    UPDATE feb_file SET feb12=l_feb12 - l_fed.fed04
     WHERE feb02=l_fed.fed03
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","feb_file",l_fed03,"",SQLCA.sqlcode,"","upd feb",1) # FUN-660136
       ROLLBACK WORK RETURN
    END IF
   END FOREACH  
   COMMIT WORK
   CALL cl_set_field_pic("N","","","","","")
   CALL s_showmsg()   #No.FUN-6C0083
 
END FUNCTION
 
FUNCTION t300_out()
DEFINE
    l_i             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    sr              RECORD
        fed01       LIKE fed_file.fed01,
        fec02       LIKE fec_file.fec02,
        gem02       LIKE gem_file.gem02,
        fed02       LIKE fed_file.fed02,
        fed03       LIKE fed_file.fed03,
        fed04       LIKE fed_file.fed04,
        fed05       LIKE fed_file.fed05,
        fed06       LIKE fed_file.fed06,
        fec04       LIKE fec_file.fec04,
        fea02       LIKE fea_file.fea02,
        ecd02       LIKE ecd_file.ecd02
                    END RECORD,
    l_fec03         LIKE fec_file.fec03,
    l_fec05         LIKE fec_file.fec05,
    l_name          LIKE type_file.chr20,               #External(Disk) file name       #No.FUN-680070 VARCHAR(20)
    l_za05          LIKE type_file.chr1000              #       #No.FUN-680070 VARCHAR(40)
DEFINE  l_gem01         LIKE gem_file.gem01,         #No.FUN-850024   --add--                                                       
        l_wc,l_wc2,l_sql     STRING                       #No.FUN-850024   --add--                                                  
                                                                                      
    IF cl_null(g_wc) AND g_cmd = 'a' THEN
       LET g_wc = "fec01 ='",g_fec.fec01,"'"
       LET g_wc2 = "1=1"
    END IF
     CALL cl_del_data(l_table)                                                                                                      
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ",                                                                            
               "        ?, ?                         )"                                                                             
     PREPARE insert_prep FROM g_sql                                                                                                 
     IF STATUS THEN                                                                                                                 
        CALL cl_err('insert_prep:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
        EXIT PROGRAM                                                                                                                
     END IF                                                                                                                         
    IF g_wc IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT fed01,fec02,gem02,fed02,fed03,fed04,fed05,",
              " fed06,fec04,fea02,ecd02,fec03,fec05",
              " FROM fea_file,feb_file,fec_file LEFT JOIN gem_file ON fec03=gem01,fed_file LEFT JOIN ecd_file ON fed06=ecd01",
              " WHERE fec01 = fed01 ",
              "   AND feb02 = fed03 ",
              "   AND fea01 = feb01 ",
              "   AND fecconf <> 'X' ",  #CHI-C80041
              "   AND ",g_wc CLIPPED,
              "   AND ",g_wc2 CLIPPED,
              " ORDER BY 1,4 "
    PREPARE t300_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t300_co                         # SCROLL CURSOR
         CURSOR FOR t300_p1
 
 
    FOREACH t300_co INTO sr.*,l_fec03,l_fec05
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF l_fec05='2' THEN
           SELECT pmc03 INTO sr.gem02
             FROM pmc_file
           WHERE pmc01=l_fec03
        END IF
        SELECT gem01 INTO l_gem01 FROM gem_file WHERE gem02=sr.gem02    #FUN-850024 ADD    
    EXECUTE  insert_prep  USING                                                                                                     
          sr.fed01,sr.fec02,l_gem01,sr.gem02,sr.fed02,sr.fed03,                                                                     
          sr.fed04,sr.fed05,sr.fed06,sr.fec04,sr.fea02,sr.ecd02                                                                     
    END FOREACH                                                                                                                     
                                                                                                                                    
   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                 
   LET g_str = ''                                                                                                                   
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                         
   IF g_zz05 = 'Y' THEN                                                                                                             
      CALL cl_wcchp(g_wc2,'fed02,fed03,fed04,fed05,fed06,fea02,ecd02')                                                              
           RETURNING l_wc2                                                                                                          
      CALL cl_wcchp(g_wc,'fec01,fec02,fec05,fec03,fec04,                                                                            
                    fecuser,fecgrup,fecmodu,fecdate,fecacti')                                                                       
           RETURNING l_wc                                                                                                           
      LET g_str = l_wc,";",l_wc2                                                                                                    
   END IF                                                                                                                           
   LET g_str = g_str                                                                                                                
   CALL cl_prt_cs3('afat300','afat300',l_sql,g_str)                                                                                 

END FUNCTION

FUNCTION t300_ef()
 
  CALL t300sub_y_chk(g_fec.fec01)
  IF g_success = "N" THEN
     RETURN
  END IF
 
  CALL aws_condition()                            #判斷送簽資料
  IF g_success = 'N' THEN
     RETURN
  END IF
 
##########
# CALL aws_efcli2()
# 傳入參數: (1)單頭資料, (2-6)單身資料
# 回傳值  : 0 開單失敗; 1 開單成功
##########
   IF aws_efcli2(base.TypeInfo.create(g_fec),base.TypeInfo.create(g_fed) ,'','','','')
   THEN
      LET g_success = 'Y'
      LET g_fec.fec06 = 'S'   #開單成功, 更新狀態碼為 'S. 送簽中'
      DISPLAY BY NAME g_fec.fec06
   ELSE
      LET g_success = 'N'
   END IF
 
END FUNCTION
 
FUNCTION t300_fec07(p_cmd)  #人員代號
   DEFINE p_cmd     LIKE type_file.chr1,        
          l_gen02   LIKE gen_file.gen02,
          l_genacti LIKE gen_file.genacti
 
   LET g_errno = ' '
   SELECT gen02,genacti
          INTO l_gen02,l_genacti
          FROM gen_file WHERE gen01 = g_fec.fec07
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3096'
                           LET l_gen02 = NULL
        WHEN l_genacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
     DISPLAY l_gen02 TO FORMONLY.gen02  
   END IF
END FUNCTION
 
FUNCTION t300_field_pic()
DEFINE l_void  LIKE  type_file.chr1  #CHI-C80041

    LET g_approve=NULL
    IF g_fec.fec06 MATCHES '[1]' THEN
       LET g_approve='Y'
    ELSE
       LET g_approve='N'
    END IF
    #CHI-C80041---begin
    IF g_fec.fecconf = 'X' THEN
       LET l_void = 'Y'
    ELSE
       LET l_void = 'N'
    END IF 
    #CHI-C80041---end
    #CALL cl_set_field_pic("",g_approve,"","","",g_fec.fecacti)  #CHI-C80041
    CALL cl_set_field_pic(g_fec.fecconf,g_approve,"","",l_void,g_fec.fecacti)  #CHI-C80041
 
END FUNCTION
#No.FUN-9C0077 程式精簡
#CHI-C80041---begin
FUNCTION t300_v()
DEFINE   l_chr              LIKE type_file.chr1

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_fec.fec01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t300_cl USING g_fec.fec01
   IF STATUS THEN
      CALL cl_err("OPEN t300_cl:", STATUS, 1)
      CLOSE t300_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t300_cl INTO g_fec.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fec.fec01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t300_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_fec.fecconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_fec.fecconf)   THEN 
        LET l_chr=g_fec.fecconf
        IF g_fec.fecconf='N' THEN 
            LET g_fec.fecconf='X' 
        ELSE
            LET g_fec.fecconf='N'
        END IF
        UPDATE fec_file
            SET fecconf=g_fec.fecconf,  
                fecmodu=g_user,
                fecdate=g_today
            WHERE fec01=g_fec.fec01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","fec_file",g_fec.fec01,"",SQLCA.sqlcode,"","",1)  
            LET g_fec.fecconf=l_chr 
        END IF
        DISPLAY BY NAME g_fec.fecconf 
   END IF
 
   CLOSE t300_cl
   COMMIT WORK
   CALL cl_flow_notify(g_fec.fec01,'V')
 
END FUNCTION
#CHI-C80041---end
