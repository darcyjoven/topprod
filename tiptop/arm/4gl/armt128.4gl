# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: armt128.4gl
# Descriptions...: RMA修復資料維護作業
# Date & Author..: 98/05/05 By Danny
# Modify.........: No:8517 03/10/29 By Wiky img03='' ,img04=''
#                : 改為 img03=' ' , img04=' '
# Modify.........: No:9698 04/06/08 By Wiky 改t128_cl 為select * form rmc_file
# Modify.........: No.MOD-490059 04/09/08 By Wiky 1.t128_m只能寫一筆,程式改寫
#                                                 2. 整批修復,應需update修復日.
# Modify.........: No.MOD-490371 04/09/22 By Kitty Controlp 未加display
# Modify.........: No.MOD-490414 04/09/23 By Wiky 修改若原本為未修復改為1 or 2 ,程式不會再讓他改回來
# Modify.........: No.FUN-4B0035 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-510044 05/02/14 By Mandy 報表轉XML
# Modify.........: No.FUN-550064 05/05/28 By Trisy 單據編號加大
# Modify.........: No.FUN-570109 05/07/15 By vivien KEY值更改控制
# Modify.........: No.MOD-570327 05/07/28 By Yiting  單身已維護 ,離開再進單身 責任歸屬被清掉
# Modify.........: No.MOD-570349 05/07/25 By Yiting rmc08不會自動帶出系統日期
# Modify.........: No.MOD-570357 05/07/26 By Yiting
#                  1.下查詢時不設任何條件，查詢出的筆數錯誤
#                  2.實際查詢出來的只有rmc14為0,1,2之資料
# Modify.........: No.MOD-570392 05/08/05 BY yiting 修復狀態的碼全加上
# Modify.........: No.MOD-570323 05/08/11 By Rosayu 訊息加強,改用POP出來方式
# Modify.........: No.TQC-5B0109 05/11/11 By Echo &051112修改報表料件、品名、規格、單號格式
# Modify.........: No.FUN-590118 06/01/04 By Rosayu 將項次改成'###&'
# Modify.........: No.MOD-640343 06/04/12 BY yiting 己轉雜收發單時不可更改
# Modify.........: No.MOD-640452 06/04/18 By Sarah 整批修復畫面增加維修日期欄位以帶出工資率,工資率改為NOENTRY
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0085 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0018 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-7A0184 07/11/07 By claire 工資率要以修復日小於等於生效日取得
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-830100 08/03/12 By claire 新增資料單頭後按放棄再按新增, 程式會LOOP
# Modify.........: No.MOD-830102 08/03/12 By claire 新增資料單頭後按確定資料會回到單頭
# Modify.........: No.FUN-840041 08/04/10 By shiwuying  ccc_file增加2個Key,抓取單價時,增加條件 ccc07='1',抓實際成本算出的單價為基准
# Modify.........: No.MOD-840223 08/04/20 By jamie 更改料號時，會出現-391的錯誤
# Modify.........: No.FUN-840068 08/04/23 By TSD.Wind 自定欄位功能修改
# Modify.........: No.MOD-840188 08/04/28 By Zhangyajun 單身單位與庫存單位必須有轉換率
# Modify.........: No.MOD-840679 08/04/29 By claire 第一次新增至單身後仍會跳回單頭LOOP直到按放棄
# Modify.........: NO.FUN-860018 08/06/20 BY TSD.jarlin 舊報表轉成CR報表
# Modify.........: No.FUN-890102 08/09/23 By baofei  CR追單到31區
# Modify.........: No.MOD-950062 09/05/08 By Smapmin 若有客訴單號,客訴問題清單應要先default
# Modify.........: No.MOD-950153 09/05/27 By Smapmin 抓取材料成本時,先抓取最接近單據日的ccc23,若無再抓取最接近單據日的cca23
# Modify.........: No.MOD-980065 09/08/12 By mike rmd03=g_rmd[l_ac].rmd031要改為rmd031=g_rmd[l_ac].rmd031 另外再增加rmd21=g_rmd[l_ac].rmd21.
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990105 09/10/10 By lilingyu 單頭"人工工時"沒有控管負數
# Modify.........: No.TQC-990104 09/10/12 By lilingyu "RMA單號"增加開窗功能
# Modify.........: No.TQC-9C0198 10/01/04 By lilingyu 單身"數量"欄位未控管負數
# Modify.........: No.TQC-A10002 10/01/04 By lilingyu 1.單身sql語法錯誤 2.單身字段全部NOENTRY時,自動帶到下一行可edit的行
# Modify.........: No.TQC-A10021 10/01/06 By lilingyu "整批修復"時,對一筆已修復成功的資料,再次修復時,給出提示訊息 
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No:MOD-A20029 10/02/04 By Smapmin 修改單頭修復狀態時,要判斷單身是否已有資料/是否已存在銷退單或報廢單
# Modify.........: No:MOD-A20040 10/02/06 By Smapmin 還原TQC-9C0198
# Modify.........: No:MOD-A30050 10/03/10 By Sarah 修復狀態為5.修畢已包裝,應可維護單身資料
# Modify.........: No:CHI-A90040 10/10/13 By Summer 1.將armt128.4gl裡針對rmk02的欄位開關都mark
#                                                   2.(1)增加AFTER FIELD rmd21,若有輸入值則檢查輸入的單號是否存在ina_file,不存在則需顯示錯誤訊息!
#                                                     (2)當rmd21有輸入值時,檢查輸入的rmd04需存在inb_file裡
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管 
# Modify.........: No.TQC-AB0025 10/12/21 By chenying Sybase調整
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:CHI-B60093 11/06/29 By Pengu 當成本參數設定為"分倉成本"時，成本應取該料的平均
# Modify.........: No:FUN-BB0084 11/12/26 By lixh1 增加數量欄位小數取位
# Modify.........: No:CHI-C80041 12/12/20 By bart 排除作廢
 
DATABASE ds
 
GLOBALS "../../config/top.global"
#模組變數(Module Variables)
DEFINE
    g_rmg           RECORD LIKE rmg_file.*,
    g_rmc           RECORD LIKE rmc_file.*,
    g_rmc_t         RECORD LIKE rmc_file.*,
    g_rma03         LIKE rma_file.rma03,
    g_rma04         LIKE rma_file.rma04,
    g_rmd21         LIKE rmd_file.rmd21,
    l_rmc02         LIKE rmc_file.rmc02,
    g_rmd           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                    rmd02   LIKE rmd_file.rmd02,
                    rmd031  LIKE rmd_file.rmd031,
                    rmd23   LIKE rmd_file.rmd23,
                    rmk02   LIKE rmk_file.rmk02,
                    rmd21   LIKE rmd_file.rmd21,
                    rmd24   LIKE rmd_file.rmd24,
                    rmd04   LIKE rmd_file.rmd04,
                    rmd07   LIKE rmd_file.rmd07,
                    rmd12   LIKE rmd_file.rmd12,
                    rmd05   LIKE rmd_file.rmd05,
                    rmd27   LIKE rmd_file.rmd27,
                    rmdud01 LIKE rmd_file.rmdud01,
                    rmdud02 LIKE rmd_file.rmdud02,
                    rmdud03 LIKE rmd_file.rmdud03,
                    rmdud04 LIKE rmd_file.rmdud04,
                    rmdud05 LIKE rmd_file.rmdud05,
                    rmdud06 LIKE rmd_file.rmdud06,
                    rmdud07 LIKE rmd_file.rmdud07,
                    rmdud08 LIKE rmd_file.rmdud08,
                    rmdud09 LIKE rmd_file.rmdud09,
                    rmdud10 LIKE rmd_file.rmdud10,
                    rmdud11 LIKE rmd_file.rmdud11,
                    rmdud12 LIKE rmd_file.rmdud12,
                    rmdud13 LIKE rmd_file.rmdud13,
                    rmdud14 LIKE rmd_file.rmdud14,
                    rmdud15 LIKE rmd_file.rmdud15
                    END RECORD,
    g_rmd_t         RECORD                 #程式變數 (舊值)
                    rmd02   LIKE rmd_file.rmd02,
                    rmd031  LIKE rmd_file.rmd031,
                    rmd23   LIKE rmd_file.rmd23,
                    rmk02   LIKE rmk_file.rmk02,
                    rmd21   LIKE rmd_file.rmd21,
                    rmd24   LIKE rmd_file.rmd24,
                    rmd04   LIKE rmd_file.rmd04,
                    rmd07   LIKE rmd_file.rmd07,
                    rmd12   LIKE rmd_file.rmd12,
                    rmd05   LIKE rmd_file.rmd05,
                    rmd27   LIKE rmd_file.rmd27,
                    rmdud01 LIKE rmd_file.rmdud01,
                    rmdud02 LIKE rmd_file.rmdud02,
                    rmdud03 LIKE rmd_file.rmdud03,
                    rmdud04 LIKE rmd_file.rmdud04,
                    rmdud05 LIKE rmd_file.rmdud05,
                    rmdud06 LIKE rmd_file.rmdud06,
                    rmdud07 LIKE rmd_file.rmdud07,
                    rmdud08 LIKE rmd_file.rmdud08,
                    rmdud09 LIKE rmd_file.rmdud09,
                    rmdud10 LIKE rmd_file.rmdud10,
                    rmdud11 LIKE rmd_file.rmdud11,
                    rmdud12 LIKE rmd_file.rmdud12,
                    rmdud13 LIKE rmd_file.rmdud13,
                    rmdud14 LIKE rmd_file.rmdud14,
                    rmdud15 LIKE rmd_file.rmdud15
                    END RECORD,
    g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_flag          LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
    g_buf           LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(30)
    int_f           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(01),
    g_rmc08         LIKE rmc_file.rmc08,
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    p_row,p_col     LIKE type_file.num5,    #No.FUN-690010 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   LIKE type_file.num5        #FUN-570109  #No.FUN-690010 SMALLINT
DEFINE   g_cnt          LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_i            LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE   l_table        STRING       #-----NO.FUN-860018 BY TSD.jarlin-----                                                         
DEFINE   g_str          STRING       #-----NO.FUN-860018 BY TSD.jarlin-----
DEFINE   g_edit          LIKE type_file.chr1   #TQC-9B0194 
DEFINE   g_chr           LIKE type_file.chr1   #TQC-A10021
DEFINE   g_rmd05_t       LIKE rmd_file.rmd05   #FUN-BB0084
 
MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
  
    WHENEVER ERROR CALL cl_err_msg_log
  
    IF (NOT cl_setup("ARM")) THEN
       EXIT PROGRAM
    END IF
    LET g_sql = "rmc01.rmc_file.rmc01,",                                                                                            
                "rmc02.rmc_file.rmc02,",                                                                                            
                "rmc04.rmc_file.rmc04,",                                                                                            
                "rmc06.rmc_file.rmc06,",                                                                                            
                "rmc061.rmc_file.rmc061,",                                                                                          
                "rmc08.rmc_file.rmc08,",                                                                                            
                "rmc09.rmc_file.rmc09,",                                                                                            
                "rmc10.rmc_file.rmc10,",                                                                                            
                "rmc14.rmc_file.rmc14,",                                                                                            
                "rmc16.rmc_file.rmc16,",                                                                                            
                "rmc25.rmc_file.rmc25,",                                                                                            
                "rmd01.rmd_file.rmd01,",                                                                                            
                "rmd02.rmd_file.rmd02,",                                                                                            
                "rmd031.rmd_file.rmd031,",                                                                                          
                "rmd04.rmd_file.rmd04,",                                                                                            
                "rmd05.rmd_file.rmd05,",                                                                                            
                "rmd06.rmd_file.rmd06,",       
                "rmd061.rmd_file.rmd061,",                                                                                          
                "rmd07.rmd_file.rmd07,",                                                                                            
                "rmd12.rmd_file.rmd12,",                                                                                            
                "rmd21.rmd_file.rmd21,",                                                                                            
                "rmd23.rmd_file.rmd23,",                                                                                            
                "rmd24.rmd_file.rmd24,",                                                                                            
                "rmd27.rmd_file.rmd27,",                                                                                            
                "rma03.rma_file.rma03,",                                                                                            
                "rma04.rma_file.rma04,",                                                                                            
                "rmk01.rmk_file.rmk01,",                                                                                            
                "rmk02.rmk_file.rmk02,",                                                                                            
                "rmk03.rmk_file.rmk03,",                                                                                            
                "rmc14d.type_file.chr20"                                                                                            
    LET l_table = cl_prt_temptable('armt128',g_sql) CLIPPED                                                                         
    IF l_table = -1 THEN EXIT PROGRAM END IF        
    LET g_sql = "INSERT INTO ", g_cr_db_str CLIPPED,                                                                                
                 l_table CLIPPED,                                                                                                   
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,                                                                
                         ?,?,?,?,?, ?,?,?,?,?)"                                                                                     
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1)                                                                                         
       EXIT PROGRAM                                                                                                                 
    END IF                                                                                                                          
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time      #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
    LET p_row = 2 LET p_col = 4
    OPEN WINDOW t128_w AT p_row,p_col      #顯示畫面
         WITH FORM "arm/42f/armt128"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_forupd_sql = "SELECT * FROM rmc_file ",   #No.9698
                       " WHERE rmc01 = ? AND rmc02 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t128_cl CURSOR FROM g_forupd_sql
 
    WHILE TRUE
       LET g_action_choice = ''
       CALL t128_menu()
       IF g_action_choice = 'exit' THEN EXIT WHILE END IF
    END WHILE
    CLOSE WINDOW t128_w                    #結束畫面
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time      #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
END MAIN
 
#QBE 查詢資料
FUNCTION t128_cs(p_cmd)
  DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
  DEFINE p_cmd  LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
         g_rma09    LIKE rma_file.rma09,
         g_rmaconf  LIKE rma_file.rmaconf,
         g_rmavoid  LIKE rma_file.rmavoid
 
  LET g_flag='N'
  CLEAR FORM                               #清除畫面
  CALL g_rmd.clear()
  IF p_cmd = 'a' THEN
     INPUT BY NAME g_rmc.rmc01,g_rmc.rmc02 WITHOUT DEFAULTS
 
        BEFORE FIELD rmc01
           LET g_rmc.rmc02=l_rmc02+1
           DISPLAY BY NAME g_rmc.rmc02
 
        AFTER FIELD rmc01
           IF NOT cl_null(g_rmc.rmc01) THEN
               SELECT rma09,rmaconf,rmavoid INTO g_rma09,g_rmaconf,g_rmavoid
                 FROM rma_file WHERE rma01=g_rmc.rmc01
               IF STATUS THEN
                  CALL cl_err3("sel","rma_file",g_rmc.rmc01,"",SQLCA.sqlcode,"","",1) #FUN-660111
                  NEXT FIELD rmc01
               END IF
               IF g_rmavoid='N' THEN
                  CALL cl_err(g_rmc.rmc01,9028,0)
                  NEXT FIELD rmc01
               END IF
               IF g_rma09='6' THEN
                  CALL cl_err(g_rmc.rmc01,'arm-018',0)
                  NEXT FIELD rmc01
               END IF
               IF g_rmaconf='N' THEN
                  CALL cl_err(g_rmc.rmc01,'arm-005',0)
                  NEXT FIELD rmc01
               END IF
           END IF
 
        AFTER FIELD rmc02
           IF NOT cl_null(g_rmc.rmc02) THEN
               IF g_rmc.rmc02 < 1 THEN NEXT FIELD rmc02 END IF
               SELECT rmc14 INTO g_rmc.rmc14 FROM rmc_file
                  WHERE rmc01=g_rmc.rmc01 AND rmc02=g_rmc.rmc02
               IF STATUS THEN
                  CALL cl_err3("sel","rmc_file",g_rmc.rmc01,g_rmc.rmc02,"arm-016","","",1) #FUN-660111
                  NEXT FIELD rmc01
               END IF
               LET l_rmc02=g_rmc.rmc02
           END IF
 
         ON ACTION CONTROLP
            CASE
                WHEN INFIELD(rmc01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_rma3"
                     LET g_qryparam.default1 = g_rmc.rmc01
                     CALL cl_create_qry() RETURNING g_rmc.rmc01
                     DISPLAY BY NAME g_rmc.rmc01
                     NEXT FIELD rmc01
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
     IF INT_FLAG THEN RETURN END IF
     LET g_wc = 'rmc01="',g_rmc.rmc01,'" AND rmc02=',g_rmc.rmc02 USING '###'
     LET g_flag='Y'
     LET g_wc2 = " 1=1"
  ELSE 
     CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_rmc.* TO NULL    #No.FUN-750051
     CONSTRUCT BY NAME g_wc ON
               rmc01,rmc02,rmc07,rmc08,rmc14,
               rmc25,rmc04,rmc06,rmc061,
               rmc16,rmc09,rmc10,rmc11,
               rmcud01,rmcud02,rmcud03,rmcud04,rmcud05,
               rmcud06,rmcud07,rmcud08,rmcud09,rmcud10,
               rmcud11,rmcud12,rmcud13,rmcud14,rmcud15
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
         ON ACTION CONTROLP
           CASE
            WHEN INFIELD(rmc01) 
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_rmc1"  
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO rmc01
              NEXT FIELD rmc01
            END CASE
 
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
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
     IF INT_FLAG THEN RETURN END IF
     CONSTRUCT g_wc2 ON rmd02,rmd031,rmd23,rmd24,   #螢幕上取單身條件
                        rmd04,rmd07,rmd05,rmd12,rmd27,rmd21
                        ,rmdud01,rmdud02,rmdud03,rmdud04,rmdud05
                        ,rmdud06,rmdud07,rmdud08,rmdud09,rmdud10
                        ,rmdud11,rmdud12,rmdud13,rmdud14,rmdud15
                   FROM s_rmd[1].rmd02, s_rmd[1].rmd031,s_rmd[1].rmd23,
                        s_rmd[1].rmd24, s_rmd[1].rmd04, s_rmd[1].rmd07,
                        s_rmd[1].rmd05, s_rmd[1].rmd12, s_rmd[1].rmd27,
                        s_rmd[1].rmd21
                        ,s_rmd[1].rmdud01,s_rmd[1].rmdud02,s_rmd[1].rmdud03
                        ,s_rmd[1].rmdud04,s_rmd[1].rmdud05,s_rmd[1].rmdud06
                        ,s_rmd[1].rmdud07,s_rmd[1].rmdud08,s_rmd[1].rmdud09
                        ,s_rmd[1].rmdud10,s_rmd[1].rmdud11,s_rmd[1].rmdud12
                        ,s_rmd[1].rmdud13,s_rmd[1].rmdud14,s_rmd[1].rmdud15
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
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
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
     END CONSTRUCT
     IF INT_FLAG THEN RETURN END IF
  END IF
  IF g_wc2 = " 1=1" THEN                        #若單身未輸入條件
     LET g_sql = "SELECT rmc01,rmc02 ",
                 " FROM rmc_file,rma_file,oay_file ",
                 " WHERE rma01 like ltrim(rtrim(oayslip)) || '-%'",      #No.FUN-550064
                 " AND oaytype='70' ",
                 " AND rma09 !='6' AND rmavoid='Y' ",
                 " AND rmc01=rma01 AND ",g_wc CLIPPED,
                 " ORDER BY rmc01,rmc02 "
  ELSE                                         #若單身有輸入條件
     LET g_sql = "SELECT UNIQUE rmc01,rmc02 ",
                 "  FROM rmc_file, rmd_file,rma_file,oay_file ",
                 " WHERE rmc01=rmd01",
                 " AND rma01 like ltrim(rtrim(oayslip)) || '-%'",      #No.FUN-550064
                 " AND oaytype='70' ",
                 " AND rma09 !='6' AND rmavoid='Y' ",
                 " AND rmc01=rma01",
                 " AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                 " ORDER BY rmc01,rmc02"
  END IF
  PREPARE t128_prepare FROM g_sql
  IF STATUS THEN CALL cl_err('t128_prepare',STATUS,1) RETURN END IF
  DECLARE t128_cs                               #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR t128_prepare
 
  IF g_wc2 = " 1=1" THEN                        #取合乎條件筆數
     LET g_sql="SELECT COUNT(*) FROM rmc_file WHERE ",g_wc CLIPPED
  ELSE
      LET g_sql="SELECT COUNT((DISTINCT rmc01)) FROM rmc_file,rmd_file ", #MOD-570357
               " WHERE rmc01 = rmd01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
  END IF
  PREPARE t128_precount FROM g_sql
  DECLARE t128_count CURSOR FOR t128_precount
END FUNCTION
 
FUNCTION t128_menu()
 
   WHILE TRUE
      CALL t128_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t128_q('a')
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t128_q('q')
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t128_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t128_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t128_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "客訴問題"
         WHEN "customer_problem"
            IF cl_chk_act_auth() THEN
               CALL t128_m()
            END IF
       #@WHEN "整批修復"
         WHEN "batch_fix"
            IF cl_chk_act_auth() THEN
               CALL t128_j()
            END IF
         WHEN "exporttoexcel"     #FUN-4B0035
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rmd),'','')
            END IF
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_rmc.rmc01 IS NOT NULL THEN
                LET g_doc.column1 = "rmc01"
                LET g_doc.column2 = "rmc02"
                LET g_doc.value1 = g_rmc.rmc01
                LET g_doc.value2 = g_rmc.rmc02
                CALL cl_doc()
             END IF 
          END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Query 查詢
FUNCTION t128_q(p_cmd)
 
    DEFINE p_cmd  LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rmc.* TO NULL               #No.FUN-6A0018
    INITIALIZE g_rmc08 TO NULL
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
    CALL g_rmd.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    IF p_cmd = 'a' THEN
       LET g_rmc.rmc01=' ' LET g_rmc.rmc02 = 0 LET l_rmc02=0
       LET g_before_input_done = FALSE   #MOD-830100 
       CALL t128_set_entry(p_cmd)        #MOD-830100
    END IF
  WHILE true
    LET INT_F='N'
    CALL t128_cs(p_cmd)
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_rmc.* TO NULL
        EXIT WHILE
    END IF
    OPEN t128_cs                               #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rmc.rmc01,SQLCA.sqlcode,0)
       INITIALIZE g_rmc.* TO NULL
    ELSE
        OPEN t128_count
        FETCH t128_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t128_fetch('F')                   #讀出TEMP第一筆並顯示
    END IF
    IF p_cmd = 'a' THEN
       CALL t128_u()
       IF INT_F='Y' THEN
          LET INT_F='N'
          EXIT WHILE
       END IF
       IF g_rmc.rmc14 != '1' THEN EXIT WHILE END IF   #MOD-950062  
       CALL t128_b()
       IF INT_F='Y' THEN
          LET INT_F='N'
          EXIT WHILE
       END IF
    ELSE
       EXIT WHILE
    END IF
  END WHILE
END FUNCTION
 
#處理資料的讀取
FUNCTION t128_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                    #處理方式  #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10                    #絕對的筆數  #No.FUN-690010 INTEGER
 
    MESSAGE ''
    CASE p_flag
      WHEN 'N' FETCH NEXT     t128_cs INTO g_rmc.rmc01,g_rmc.rmc02
      WHEN 'P' FETCH PREVIOUS t128_cs INTO g_rmc.rmc01,g_rmc.rmc02
      WHEN 'F' FETCH FIRST    t128_cs INTO g_rmc.rmc01,g_rmc.rmc02
      WHEN 'L' FETCH LAST     t128_cs INTO g_rmc.rmc01,g_rmc.rmc02
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
            FETCH ABSOLUTE g_jump t128_cs INTO g_rmc.rmc01,g_rmc.rmc02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rmc.rmc01,SQLCA.sqlcode,0)
       INITIALIZE g_rmc.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_rmc.* FROM rmc_file WHERE rmc01 = g_rmc.rmc01 AND rmc02 = g_rmc.rmc02
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","rmc_file",g_rmc.rmc01,g_rmc.rmc02,SQLCA.sqlcode,"","",1) #FUN-660111
       INITIALIZE g_rmc.* TO NULL
       RETURN
    END IF
 
    CALL t128_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t128_show()
    LET g_rmc_t.* = g_rmc.*                #保存單頭舊值
    DISPLAY BY NAME                        # 顯示單頭值
       g_rmc.rmc01,g_rmc.rmc02, g_rmc.rmc07, g_rmc.rmc04, g_rmc.rmc06, g_rmc.rmc061,
       g_rmc.rmc08, g_rmc.rmc09, g_rmc.rmc10, g_rmc.rmc14, g_rmc.rmc16,
       g_rmc.rmc25, g_rmc.rmc11,    #NO:7211
       g_rmc.rmcud01,g_rmc.rmcud02,g_rmc.rmcud03,g_rmc.rmcud04,
       g_rmc.rmcud05,g_rmc.rmcud06,g_rmc.rmcud07,g_rmc.rmcud08,
       g_rmc.rmcud09,g_rmc.rmcud10,g_rmc.rmcud11,g_rmc.rmcud12,
       g_rmc.rmcud13,g_rmc.rmcud14,g_rmc.rmcud15 
    LET g_buf = ''
    CASE g_lang
      WHEN '0'
        CASE g_rmc.rmc14
          WHEN '0' LET g_buf = '未修復'
          WHEN '1' LET g_buf = '修復'
          WHEN '2' LET g_buf = '不修'
        END CASE
      WHEN '2'
        CASE g_rmc.rmc14
          WHEN '0' LET g_buf = '未修復'
          WHEN '1' LET g_buf = '修復'
          WHEN '2' LET g_buf = '不修'
        END CASE
      OTHERWISE
        CASE g_rmc.rmc14
          WHEN '0' LET g_buf = 'NoModi'
          WHEN '1' LET g_buf = 'Updt'
          WHEN '2' LET g_buf = 'NRep'
        END CASE
    END CASE
    DISPLAY g_buf TO rmc14d
    LET g_rma03 = ' ' LET g_rma04 = ' '
    SELECT rma03,rma04 INTO g_rma03,g_rma04 FROM rma_file
     WHERE rma01 = g_rmc.rmc01
    DISPLAY g_rma03,g_rma04 TO rma03,rma04
    CALL t128_b_fill(g_wc2 CLIPPED)                #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t128_u()
  DEFINE g_rma09    LIKE rma_file.rma09,
         g_rmaconf  LIKE rma_file.rmaconf,
         g_rmavoid  LIKE rma_file.rmavoid,
         g_rmp01    LIKE rmp_file.rmp01,
         g_cn       LIKE type_file.num5,   #No.FUN-690010 smallint,
         l_cnt      LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
     IF s_shut(0) THEN CALL cl_err('',9037,1) RETURN END IF       #MOD-570323 秀訊息改用POP出來方式
    MESSAGE ""
    SELECT * INTO g_rmc.* FROM rmc_file WHERE rmc01 = g_rmc.rmc01 AND rmc02 = g_rmc.rmc02
    IF cl_null(g_rmc.rmc01) OR cl_null(g_rmc.rmc02) THEN
        CALL cl_err('',-400,1) RETURN                             #MOD-570323 秀訊息改用POP出來方式
    END IF
    SELECT rma09,rmaconf,rmavoid INTO g_rma09,g_rmaconf,g_rmavoid
      FROM rma_file WHERE rma01=g_rmc.rmc01
     IF STATUS THEN  
     CALL cl_err3("sel","rma_file",g_rmc.rmc01,"",SQLCA.sqlcode,"","",1) #FUN-660111 
     RETURN END IF    #MOD-570323 秀訊息改用POP出來方式
     IF g_rmavoid='N' THEN CALL cl_err(g_rmc.rmc01,9028,1) RETURN END IF   #MOD-570323 秀訊息改用POP出來方式
     IF g_rma09='6' THEN CALL cl_err(g_rmc.rmc01,'arm-018',1) RETURN END IF   #MOD-570323 秀訊息改用POP出來方式
     IF g_rmaconf='N' THEN CALL cl_err(g_rmc.rmc01,'arm-005',1) RETURN END IF  #MOD-570323 秀訊息改用POP出來方式
   #若修護此RMA單號的項次資料可在覆出單資料中找到則不允許修改,因已有覆出資料
    SELECT COUNT(*),rmp01 INTO g_cn,g_rmp01 FROM rmp_file
      WHERE rmp05=g_rmc.rmc01 AND rmp06=g_rmc.rmc02
     IF g_cn >=1 THEN CALL cl_err(g_rmp01,'arm-020',1) RETURN END IF  #MOD-570323 秀訊息改用POP出來方式
    LET g_rmc_t.* = g_rmc.*
    CALL cl_opmsg('u')
    LET INT_F='N'
    WHILE TRUE
        BEGIN WORK
 
    OPEN t128_cl USING g_rmc.rmc01,g_rmc.rmc02
    IF STATUS THEN
       CALL cl_err("OPEN t128_cl:", STATUS, 1)
       CLOSE t128_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t128_cl INTO g_rmc.*          #No.9698 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_rmg.rmg01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t128_cl ROLLBACK WORK RETURN
    END IF
         INITIALIZE g_rmc08 TO NULL    #MOD-570349
        CALL t128_i("u")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 LET INT_F='Y'
           LET g_rmc.* = g_rmc_t.*
           CALL t128_show()
           CALL cl_err('',9001,0)
           EXIT WHILE
        END IF
        UPDATE rmc_file SET * = g_rmc.* WHERE rmc01 = g_rmc.rmc01 AND rmc02 = g_rmc.rmc02
        IF STATUS THEN      
        CALL cl_err3("upd","rmc_file",g_rmc_t.rmc01,g_rmc_t.rmc02,STATUS,"","",1) #FUN-660111
        CONTINUE WHILE END IF
        LET g_rmc_t.* = g_rmc.*
        EXIT WHILE
    END WHILE
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION t128_i(p_cmd)
  DEFINE p_cmd      LIKE type_file.chr1,                 #a:輸入 u:更改  #No.FUN-690010 VARCHAR(1)
         l_cnt      LIKE type_file.num5   #MOD-A20029 

    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME g_rmc.rmc01,g_rmc.rmc02,g_rmc.rmc07,g_rmc.rmc08,g_rmc.rmc14,
                  g_rmc.rmc25,g_rmc.rmc04,g_rmc.rmc06,g_rmc.rmc061,
                  g_rmc.rmc16,g_rmc.rmc09,g_rmc.rmc10,g_rmc.rmc11,
                  g_rmc.rmcud01,g_rmc.rmcud02,g_rmc.rmcud03,g_rmc.rmcud04,
                  g_rmc.rmcud05,g_rmc.rmcud06,g_rmc.rmcud07,g_rmc.rmcud08,
                  g_rmc.rmcud09,g_rmc.rmcud10,g_rmc.rmcud11,g_rmc.rmcud12,
                  g_rmc.rmcud13,g_rmc.rmcud14,g_rmc.rmcud15 
                  WITHOUT DEFAULTS
     BEFORE INPUT
        LET g_before_input_done = FALSE
        CALL t128_set_entry(p_cmd)
        CALL t128_set_no_entry(p_cmd)
        LET g_before_input_done = TRUE
 
    BEFORE FIELD rmc08  #預設系統日期
       IF cl_null(g_rmc.rmc08) and cl_null(g_rmc08) THEN
          LET g_rmc.rmc08 = g_today
       ELSE
          IF g_flag='Y' AND cl_null(g_rmc.rmc08) THEN
             LET g_rmc.rmc08=g_rmc08 END IF
       END IF
       DISPLAY BY NAME g_rmc.rmc08
       LET g_rmc08= g_rmc.rmc08
 
    AFTER FIELD rmc08
       IF NOT cl_null(g_rmc.rmc08) THEN
           IF g_rmc.rmc08 != g_rmc_t.rmc08 OR g_rmc_t.rmc08 is null THEN
              CALL t128_rmc11()
           END IF
           LET g_rmc08= g_rmc.rmc08
       END IF
 
    AFTER FIELD rmc14
       IF NOT cl_null(g_rmc.rmc14) THEN
            IF g_rmc.rmc14 NOT MATCHES '[0123456]' THEN   #No.MOD-570392
               NEXT FIELD rmc14
           END IF
           #-----MOD-A20029---------
           IF g_rmc.rmc14 <> g_rmc_t.rmc14 THEN 
              CASE g_rmc_t.rmc14
                 WHEN '1'
                    LET l_cnt=0
                    SELECT COUNT(*) INTO l_cnt FROM rmd_file  
                      WHERE rmd01=g_rmc.rmc01
                        AND rmd03=g_rmc.rmc02
                    IF l_cnt > 0 THEN
                       CALL cl_err('','arm-101',0)
                       LET g_rmc.rmc14 = g_rmc_t.rmc14
                       DISPLAY BY NAME g_rmc.rmc14
                       NEXT FIELD rmc14
                    END IF
                 WHEN '3'
                    LET l_cnt=0
                    SELECT COUNT(*) INTO l_cnt  
                      FROM rml_file,rmp_file 
                     WHERE rmp01=rml01 AND rmp011=rml03 AND rmp00='2' 
                       AND rmp05=g_rmc.rmc01 
                       AND rmp06=g_rmc.rmc02
                       AND rmlvoid='Y'
                    IF l_cnt > 0 THEN 
                       CALL cl_err('','arm-102',0)  
                       LET g_rmc.rmc14 = g_rmc_t.rmc14
                       DISPLAY BY NAME g_rmc.rmc14
                       NEXT FIELD rmc14
                    END IF
                 WHEN '4'
                    LET l_cnt=0
                    SELECT COUNT(*) INTO l_cnt  
                      FROM rmj_file,rmp_file 
                     WHERE rmp01=rmj01 AND rmp00='3' 
                       AND rmp05=g_rmc.rmc01
                       AND rmp06=g_rmc.rmc02
                       AND rmjvoid='Y'
                       AND rmjconf <> 'X'  #CHI-C80041
                    IF l_cnt > 0 THEN 
                       CALL cl_err('','arm-103',0)  
                       LET g_rmc.rmc14 = g_rmc_t.rmc14
                       DISPLAY BY NAME g_rmc.rmc14
                       NEXT FIELD rmc14
                    END IF
              END CASE
           END IF 
           #-----END MOD-A20029-----
           IF g_rmc.rmc14 = '2' THEN EXIT INPUT END IF
           END IF
       IF NOT cl_null(g_rmc.rmc08) THEN LET g_rmc08= g_rmc.rmc08 END IF
 
    AFTER FIELD rmc10
       IF NOT cl_null(g_rmc.rmc10) THEN
          IF g_rmc.rmc10 < 0 THEN
             CALL cl_err('','aec-020',0)
             NEXT FIELD rmc10
          END IF 
           LET g_rmc.rmc12 = g_rmc.rmc10 * g_rmc.rmc11
       END IF
 
    AFTER FIELD rmc09
       IF NOT cl_null(g_rmc.rmc09) THEN
           IF g_rmc.rmc09 NOT MATCHES '[YN]' THEN
              NEXT FIELD rmc09
           END IF
       END IF
 
    AFTER FIELD rmc16
       IF NOT cl_null(g_rmc.rmc16) THEN
           IF g_rmc.rmc16 NOT MATCHES '[YN]' THEN
               NEXT FIELD rmc16
           END IF
       END IF
 
    AFTER FIELD rmcud01
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD rmcud02
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD rmcud03
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD rmcud04
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD rmcud05
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD rmcud06
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD rmcud07
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD rmcud08
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD rmcud09
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD rmcud10
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD rmcud11
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD rmcud12
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD rmcud13
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD rmcud14
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
    AFTER FIELD rmcud15
       IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        ON ACTION customer_problem
           CALL t128_m()
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(rmc01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_rma"
                     LET g_qryparam.arg1 = '70'
                     CALL cl_create_qry() RETURNING g_rmc.rmc01
                     DISPLAY BY NAME g_rmc.rmc01
                     NEXT FIELD rmc01
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
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
END FUNCTION
 
FUNCTION t128_rmc11()      #工資率
 
      SELECT * INTO g_rmg.* FROM rmg_file  
       WHERE rmg01 = (SELECT MAX(rmg01) FROM rmg_file 
                       WHERE rmg01 <=  g_rmc.rmc08)     
      LET g_rmc.rmc11=g_rmg.rmg02
 
    IF g_rmc.rmc11 IS NULL THEN LET g_rmc.rmc11=0 END IF
    DISPLAY BY NAME g_rmc.rmc11
END FUNCTION
 
FUNCTION t128_rmc11_j()      #工資率
      SELECT * INTO g_rmg.* FROM rmg_file  
       WHERE rmg01 = (SELECT MAX(rmg01) FROM rmg_file 
                       WHERE rmg01 <=  g_rmc.rmc08)     
      LET g_rmc.rmc11=g_rmg.rmg02
 
    IF g_rmc.rmc11 IS NULL THEN LET g_rmc.rmc11=0 END IF
    RETURN g_rmc.rmc11
END FUNCTION
 
FUNCTION t128_j()    #NO:7221 add
DEFINE tm    RECORD                          # Print condition RECORD
              wc      STRING,                # Where condition
              rmc08   LIKE rmc_file.rmc08,   #MOD-640452 add
              b       LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),               # Input more condition
              c       LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),               # Input more condition
              d       LIKE eca_file.eca09,    #No.FUN-690010 DEC(8,2),              # Input more condition
              e       LIKE eca_file.eca09     #No.FUN-690010 DEC(8,2)               # Input more condition
             END RECORD
DEFINE l_sql STRING
DEFINE sr1   RECORD
              rmc01  LIKE rmc_file.rmc01,
              rmc02  LIKE rmc_file.rmc02,
              rmc09  LIKE rmc_file.rmc09,
              rmc10  LIKE rmc_file.rmc10,
              rmc16  LIKE rmc_file.rmc16,
              rmc11  LIKE rmc_file.rmc11
             END RECORD
 
    OPEN WINDOW t128_j AT 10,15      #顯示畫面
         WITH FORM "arm/42f/armt128j"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("armt128j")
 
    LET tm.rmc08 = g_today   #MOD-640452 add
    LET tm.b='Y'
    LET tm.c='N'
    LET tm.d=0
    LET tm.e=0
    CONSTRUCT BY NAME tm.wc ON rmc01,rmc02
 
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
       LET INT_FLAG = 0  CLOSE WINDOW t128_j RETURN
    END IF
 
    DISPLAY tm.rmc08 TO FORMONLY.rmc08   #MOD-640452 add
    DISPLAY tm.b TO FORMONLY.b
    DISPLAY tm.c TO FORMONLY.c
    DISPLAY tm.d TO FORMONLY.d
    DISPLAY tm.e TO FORMONLY.e
 
    INPUT BY NAME tm.rmc08,tm.b,tm.c,tm.d WITHOUT DEFAULTS   #MOD-640452
       AFTER FIELD rmc08
          IF NOT cl_null(tm.rmc08) THEN
             LET g_rmc.rmc08= tm.rmc08
             CALL t128_rmc11_j() RETURNING tm.e
             DISPLAY tm.e TO FORMONLY.e
          END IF
 
       AFTER FIELD b
          IF NOT cl_null(tm.b) THEN
              IF tm.b NOT MATCHES '[YN]' THEN
                  NEXT FIELD b
              END IF
          END IF
 
       AFTER FIELD c
          IF NOT cl_null(tm.c) THEN
              IF tm.c NOT MATCHES '[YN]' THEN
                  NEXT FIELD c
              END IF
          END IF
 
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
    IF cl_confirm('aap-017') THEN
       LET l_sql=" SELECT rmc01,rmc02,rmc09,rmc10,rmc16,rmc11 ",
                 " FROM rmc_file ",
                 " WHERE rmc14='0' ",
                 " AND ", tm.wc CLIPPED
       PREPARE t128_prepare1 FROM l_sql
       IF SQLCA.sqlcode  THEN
          CALL cl_err('prepare:',SQLCA.sqlcode,1) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
       DECLARE t128_j CURSOR FOR t128_prepare1
 
       BEGIN WORK
       LET g_success='Y'
       LET g_chr = 'N'   #TQC-A10021
       FOREACH t128_j INTO sr1.*
          UPDATE rmc_file SET rmc16=tm.b,
                              rmc09=tm.c,
                              rmc10=tm.d,
                              rmc14='1',
                              rmc11=tm.e,
                              rmc08=tm.rmc08   #g_today #No.MOD-490059   #MOD-640452 modify
          WHERE rmc01=sr1.rmc01
            AND rmc02=sr1.rmc02
          IF SQLCA.sqlcode  THEN
             CALL cl_err3("upd","rmc_file",sr1.rmc01,sr1.rmc02,SQLCA.sqlcode,"","foreach:",1) #FUN-660111
             LET g_success='N'
             EXIT FOREACH
          END IF
          LET g_chr = 'Y'  #TQC-A10021
       END FOREACH
       IF SQLCA.SQLCODE THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          LET g_success='N'
       END IF
        IF g_chr = 'N' THEN
           CALL cl_err('','arm-002',1)
           LET g_success = 'N'
        END IF  
       IF g_success = 'Y' THEN
          COMMIT WORK
          CALL cl_err('','agl-112',1)
       ELSE
          ROLLBACK WORK
          CALL cl_err('',9050,1)
       END IF
    END IF
    CLOSE WINDOW t128_j
    RETURN
END FUNCTION
#單身
FUNCTION t128_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    l_status        LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),               #rmd04的庫存明細檔
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690010 VARCHAR(1)
    g_cn            LIKE type_file.num5,    #No.FUN-690010 SMALLINT,
    l_ima02         LIKE ima_file.ima02,
    l_ima021        LIKE ima_file.ima021,
    l_ima25         LIKE ima_file.ima25,
    l_rmd08         LIKE rmd_file.rmd08,
    l_rmd13         LIKE rmd_file.rmd13,
    l_rmd14         LIKE rmd_file.rmd14,
    l_rmd04         LIKE rmd_file.rmd04,
    l_rmk03         LIKE rmk_file.rmk03,
    g_rma09         LIKE rma_file.rma09,
    g_rmp01         LIKE rmp_file.rmp01,
    g_rmaconf       LIKE rma_file.rmaconf,
    g_rmavoid       LIKE rma_file.rmavoid,
    l_yy,l_mm       LIKE type_file.num5,    #No.FUN-690010 SMALLINT,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690010 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否  #No.FUN-690010 SMALLINT
    l_flag          LIKE type_file.num5,                #MOD-840188
    l_fac           LIKE ima_file.ima31_fac,             #MOD-840188 #CHI-A90040 add ,
    l_str           STRING                              #CHI-A90040 add
    
    LET g_action_choice = ""
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    IF cl_null(g_rmc.rmc01) OR cl_null(g_rmc.rmc02) THEN RETURN END IF
    SELECT * INTO g_rmc.* FROM rmc_file WHERE rmc01 = g_rmc.rmc01 AND rmc02 = g_rmc.rmc02
   #IF g_rmc.rmc14 !='1' THEN                         #MOD-A30050 mark
    IF g_rmc.rmc14 !='1' AND g_rmc.rmc14 !='5' THEN   #MOD-A30050
       CALL cl_err(g_rmc.rmc14,'arm-017',0) RETURN
    END IF
    SELECT rma09,rmaconf,rmavoid INTO g_rma09,g_rmaconf,g_rmavoid
      FROM rma_file WHERE rma01=g_rmc.rmc01
    IF g_rmavoid='N' THEN CALL cl_err(g_rmc.rmc01,9028,0) RETURN END IF
    IF g_rma09='6' THEN CALL cl_err(g_rmc.rmc01,'arm-018',0) RETURN END IF
    IF g_rmaconf='N' THEN CALL cl_err(g_rmc.rmc01,'arm-005',0) RETURN END IF
   #若修護此RMA單號的項次資料可在覆出單資料中找到則不允許修改,因已有覆出資料
    SELECT COUNT(*),rmp01 INTO g_cn,g_rmp01 FROM rmp_file
      WHERE rmp05=g_rmc.rmc01 AND rmp06=g_rmc.rmc02
       GROUP BY rmp01    #TQC-A10002
    IF g_cn >=1 THEN CALL cl_err(g_rmp01,'arm-020',0) RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
   " SELECT rmd02,rmd031,rmd23,'',rmd21,rmd24,rmd04,rmd07,rmd12,rmd05,rmd27,",
   "        rmdud01,rmdud02,rmdud03,rmdud04,rmdud05,",
   "        rmdud06,rmdud07,rmdud08,rmdud09,rmdud10,",
   "        rmdud11,rmdud12,rmdud13,rmdud14,rmdud15 ", 
   "   FROM rmd_file ",
   "    WHERE rmd01 = ? ",
   "    AND rmd03 = ? ",
   "    AND rmd02 = ? ",
   "FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t128_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_status  = "y"                #rmd04的庫存明細檔,default='Y'
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_rmd WITHOUT DEFAULTS FROM s_rmd.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
         CALL cl_set_docno_format("rmd21")
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t128_cl USING g_rmc.rmc01,g_rmc.rmc02
            IF STATUS THEN
               CALL cl_err("OPEN t128_cl:", STATUS, 1)
               CLOSE t128_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t128_cl INTO g_rmc.*          #No.9698 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_rmg.rmg01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t128_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               #CKP
               LET g_rmd_t.* = g_rmd[l_ac].*  #BACKUP
               LET g_rmd05_t = g_rmd[l_ac].rmd05     #FUN-BB0084
               LET p_cmd='u'
               OPEN t128_bcl USING g_rmc.rmc01,g_rmc.rmc02,g_rmd_t.rmd02
               IF STATUS THEN
                   CALL cl_err("OPEN t128_bcl:", STATUS, 1)
               ELSE
                   FETCH t128_bcl INTO g_rmd[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_rmd_t.rmd031,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                   SELECT rmk02,rmk03 INTO g_rmd[l_ac].rmk02,l_rmk03 FROM rmk_file
                    WHERE rmk01 = g_rmd[l_ac].rmd23
               END IF
               LET g_before_input_done = FALSE
               CALL t128_set_entry_b(p_cmd)
               CALL t128_set_no_entry_b(p_cmd)
               LET g_before_input_done = TRUE
               CALL cl_show_fld_cont()     #FUN-550037(smin)
               DISPLAY BY NAME g_rmd[l_ac].rmk02
               IF g_edit = 'N' THEN
                  LET l_ac= l_ac + 1
                  CALL fgl_set_arr_curr(l_ac) 
               END IF
            END IF
 
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET INT_F='Y'       #MOD-830102 add
               #CKP
               CANCEL INSERT
            END IF
            LET INT_F='Y'          #MOD-840679 add
            INSERT INTO rmd_file(rmd01,rmd02,rmd03,rmd031,rmd04,rmd05,
                                 rmd06,rmd061,rmd07,rmd08,rmd12,rmd13,
                                 rmd14,rmd15 ,rmd16,rmd17,
                                 rmd23,rmd24 ,rmd25,rmd26,rmd27,rmd31,
                                 rmd32,rmd33,
                                 rmdud01,rmdud02,rmdud03,
                                 rmdud04,rmdud05,rmdud06,
                                 rmdud07,rmdud08,rmdud09,
                                 rmdud10,rmdud11,rmdud12,
                                 rmdud13,rmdud14,rmdud15,
                                 rmdplant,rmdlegal)  #FUN-980007
                         VALUES(g_rmc.rmc01,g_rmd[l_ac].rmd02,
                                g_rmc.rmc02,g_rmd[l_ac].rmd031,
                                g_rmd[l_ac].rmd04,g_rmd[l_ac].rmd05,
                                l_ima02,l_ima021, g_rmd[l_ac].rmd07,
                                l_rmd08,g_rmd[l_ac].rmd12,l_rmd13,
                                l_rmd14,'','','',
                                g_rmd[l_ac].rmd23,g_rmd[l_ac].rmd24,
                              # '','',g_rmd[l_ac].rmd27,'','','',     #TQC-AB0025 mark
                                '','',g_rmd[l_ac].rmd27,'',0 ,'',     #TQC-AB0025 add
                                g_rmd[l_ac].rmdud01,g_rmd[l_ac].rmdud02,
                                g_rmd[l_ac].rmdud03,g_rmd[l_ac].rmdud04,
                                g_rmd[l_ac].rmdud05,g_rmd[l_ac].rmdud06,
                                g_rmd[l_ac].rmdud07,g_rmd[l_ac].rmdud08,
                                g_rmd[l_ac].rmdud09,g_rmd[l_ac].rmdud10,
                                g_rmd[l_ac].rmdud11,g_rmd[l_ac].rmdud12,
                                g_rmd[l_ac].rmdud13,g_rmd[l_ac].rmdud14,
                                g_rmd[l_ac].rmdud15,
                                g_plant,g_legal)     #FUN-980007
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rmd_file",g_rmc.rmc01,g_rmd[l_ac].rmd02,SQLCA.sqlcode,"","",1) #FUN-660111
               #CKP
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
               LET g_rec_b = g_rec_b + 1
               MESSAGE 'INSERT O.K'
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_rmd[l_ac].* TO NULL      #900423
            LET g_rmd_t.* = g_rmd[l_ac].*         #新輸入資料
            LET g_rmd05_t = NULL                  #FUN-BB0084
            LET g_before_input_done = FALSE
            CALL t128_set_entry_b(p_cmd)
            CALL t128_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD rmd02
 
        BEFORE FIELD rmd02
            IF cl_null(g_rmd[l_ac].rmd02) OR g_rmd[l_ac].rmd02 = 0 THEN
               SELECT MAX(rmd02)+1 INTO g_rmd[l_ac].rmd02
                 FROM rmd_file
                WHERE rmd01 = g_rmc.rmc01 AND rmd03 = g_rmc.rmc02
                IF g_rmd[l_ac].rmd02 IS NULL THEN
                   LET g_rmd[l_ac].rmd02 = 1
                END IF
            END IF
 
        AFTER FIELD rmd02
            IF NOT cl_null(g_rmd[l_ac].rmd02) THEN
                IF p_cmd = 'a' OR
                   (p_cmd = 'u' AND g_rmd[l_ac].rmd02 != g_rmd_t.rmd02) THEN
                   SELECT COUNT(*) INTO l_cnt FROM rmd_file
                    WHERE rmd01 = g_rmc.rmc01 AND rmd03 = g_rmc.rmc02
                      AND rmd02 = g_rmd[l_ac].rmd02
                   IF l_cnt > 0 THEN
                      LET g_rmd[l_ac].rmd02 = g_rmd_t.rmd02
                      CALL cl_err(g_rmd[l_ac].rmd02,-239,1) NEXT FIELD rmd02
                   END IF
                END IF
            END IF
 
        AFTER FIELD rmd04
            IF NOT cl_null(g_rmd[l_ac].rmd04) THEN
                CALL cl_set_comp_entry("rmd05",TRUE)     #MOD-840188
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_rmd[l_ac].rmd04,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_rmd[l_ac].rmd04= g_rmd_t.rmd04
                  NEXT FIELD rmd04
               END IF
#FUN-AA0059 ---------------------end-------------------------------
                IF l_status='N' THEN
                   LET l_status='Y'
                END IF
                IF g_rmd[l_ac].rmd04='MISC' THEN     #980602 新增
                   LET g_rmd[l_ac].rmd12=0 LET l_rmd13=0 LET l_rmd14=0
                   DISPLAY BY NAME g_rmd[l_ac].rmd12
                   NEXT FIELD rmd12
                END IF
                #CHI-A90040 add --start--
                LET l_str = g_rmd[l_ac].rmd21
                IF NOT cl_null(g_rmd[l_ac].rmd21) AND l_str.trim() != '-' THEN
                   SELECT inb04 INTO g_rmd[l_ac].rmd04 FROM inb_file
                    WHERE inb01 = g_rmd[l_ac].rmd21
                      AND inb04 = g_rmd[l_ac].rmd04
                   IF STATUS THEN
                      CALL cl_err3("sel","inb_file",g_rmd[l_ac].rmd04,"",STATUS,"","sel inb",1)
                      NEXT FIELD rmd04
                   END IF
                END IF
                #CHI-A90040 add --end--
                IF p_cmd = 'a' OR
                  (p_cmd='u'                                       ) THEN
                   SELECT ima02,ima021,ima25 INTO l_ima02,l_ima021,l_ima25
                     FROM ima_file
                    WHERE ima01 = g_rmd[l_ac].rmd04 AND imaacti = 'Y'
                   IF STATUS THEN
                      LET l_ima02 = ''
                      LET l_ima021= ''
                      CALL cl_err3("sel","ima_file",g_rmd[l_ac].rmd04,"",STATUS,"","sel ima",1) #FUN-660111
                      NEXT FIELD rmd04
                   END IF
                   #根據修復日期取得上月成本單價
                   CALL s_yp(g_rmc.rmc08) RETURNING l_yy,l_mm
                  #-----------------No:CHI-B60093 modify
                  #SELECT ccc23 INTO l_rmd13 FROM ccc_file
                  #  WHERE ccc01 = g_rmd[l_ac].rmd04 AND ccc07 = '1'
                  #    AND ccc02*12+ccc03 =
                  #        (SELECT MAX(ccc02*12+ccc03) FROM ccc_file
                  #           WHERE ccc01 = g_rmd[l_ac].rmd04 AND ccc07 = '1'
                  #             AND ccc02*12+ccc03 <= l_yy*12+l_mm)
                   SELECT ccz28 INTO g_ccz.ccz28 FROM ccz_file WHERE ccz00='0'  
                   CALL t128_get_ccc23('1',g_rmd[l_ac].rmd04,l_yy,l_mm) RETURNING l_rmd13
                  #-----------------No:CHI-B60093 end
                   IF cl_null(l_rmd13) THEN
                     #-------------------No:CHI-B60093 modify
                     #SELECT cca23 INTO l_rmd13 FROM cca_file
                     #  WHERE cca01 = g_rmd[l_ac].rmd04 AND cca06 = '1'
                     #    AND cca02*12+cca03 =
                     #        (SELECT MAX(cca02*12+cca03) FROM cca_file
                     #           WHERE cca01 = g_rmd[l_ac].rmd04 AND cca06 = '1'
                     #             AND cca02*12+cca03 <= l_yy*12+l_mm)
                      CALL t128_get_ccc23('2',g_rmd[l_ac].rmd04,l_yy,l_mm) RETURNING l_rmd13
                     #-------------------No:CHI-B60093 end
                   END IF
                   IF cl_null(l_rmd13) THEN LET l_rmd13 = 0 END IF
                   LET l_rmd14 = g_rmd[l_ac].rmd12 * l_rmd13
                   IF cl_null(l_rmd14) THEN LET l_rmd14 = 0 END IF
                   IF cl_null(g_rmc.rmc05) OR
                      (g_rmc.rmc04<>g_rmd[l_ac].rmd04) THEN    #NO:7221
                      LET g_rmd[l_ac].rmd05 = l_ima25
                   ELSE
                      LET g_rmd[l_ac].rmd05 = g_rmc.rmc05
                   END IF
             #FUN-BB0084 ---------------Begin-------------
                   IF NOT cl_null(g_rmd[l_ac].rmd12) THEN
                      LET g_rmd[l_ac].rmd12 = s_digqty(g_rmd[l_ac].rmd12,g_rmd[l_ac].rmd05) 
                      DISPLAY BY NAME g_rmd[l_ac].rmd12
                   END IF
             #FUN-BB0084 ---------------End---------------
                END IF
                LET l_rmd04=g_rmd[l_ac].rmd04
            END IF
            DISPLAY BY NAME g_rmd[l_ac].rmd05
       BEFORE FIELD rmd05
            IF NOT cl_null(g_rmd[l_ac].rmd04) THEN
               CALL cl_set_comp_entry("rmd05",TRUE)
            ELSE
               CALL cl_set_comp_entry("rmd05",FALSE)
            END IF   
 
        AFTER FIELD rmd05
             IF NOT cl_null(g_rmd[l_ac].rmd05) AND NOT cl_null(g_rmd[l_ac].rmd04) THEN #MOD-840188
                SELECT gfe01 FROM gfe_file
                 WHERE gfe01 = g_rmd[l_ac].rmd05 AND gfeacti = 'Y'
                IF STATUS THEN
                   CALL cl_err3("sel","gfe_file",g_rmd[l_ac].rmd05,"",STATUS,"","sel gfe",1) #FUN-660111
                    NEXT FIELD rmd05
                ELSE
                    CALL s_umfchk(g_rmd[l_ac].rmd04,g_rmd[l_ac].rmd05,l_ima25) RETURNING l_flag,l_fac 
                    IF l_flag THEN
                       CALL cl_err(g_rmd[l_ac].rmd05,'aoo-027',0)
                       NEXT FIELD rmd05
                    END IF
                END IF
            END IF
        #FUN-BB0084 ----------------------Begin----------------------
            IF NOT cl_null(g_rmd[l_ac].rmd05) AND NOT cl_null(g_rmd[l_ac].rmd12) THEN
               IF cl_null(g_rmd05_t) OR cl_null(g_rmd_t.rmd12) OR g_rmd05_t ! = g_rmd[l_ac].rmd05
                  OR g_rmd_t.rmd12 ! = g_rmd[l_ac].rmd12 THEN
                  LET g_rmd[l_ac].rmd12 = s_digqty(g_rmd[l_ac].rmd12,g_rmd[l_ac].rmd05)
                  DISPLAY BY NAME g_rmd[l_ac].rmd12
               END IF
            END IF
            LET g_rmd05_t = g_rmd[l_ac].rmd05
        #FUN-BB0084 ----------------------End------------------------
 
        #-----MOD-A20029--------- 
        #AFTER FIELD rmd21
        #   IF NOT cl_null(g_rmd[l_ac].rmd21) THEN
        #       IF g_rmd[l_ac].rmd21 < 0 THEN
        #          CALL cl_err('','aec-020',0)
        #          NEXT FIELD CURRENT 
        #       END IF 
        #   END IF
        #-----END MOD-A20029-----

        #CHI-A90040 add --start--
        AFTER FIELD rmd21
            LET l_str = g_rmd[l_ac].rmd21
            IF NOT cl_null(g_rmd[l_ac].rmd21) AND l_str.trim() != '-' THEN
               SELECT ina01 INTO g_rmd[l_ac].rmd21 FROM ina_file
                WHERE ina01 = g_rmd[l_ac].rmd21
               IF STATUS THEN
                  CALL cl_err3("sel","inb_file",g_rmd[l_ac].rmd21,"",STATUS,"","sel ina",1)
                  NEXT FIELD rmd21
               END IF
            END IF
        #CHI-A90040 add --end--

        AFTER FIELD rmd23
            IF NOT cl_null(g_rmd[l_ac].rmd23) THEN
                SELECT rmk02,rmk03 INTO g_rmd[l_ac].rmk02,l_rmk03 FROM rmk_file
                 WHERE rmk01 = g_rmd[l_ac].rmd23
                IF STATUS THEN
                   CALL cl_err3("sel","rmk_file",g_rmd[l_ac].rmd23,"",STATUS,"","sel rmk",1) #FUN-660111
                    NEXT FIELD rmd23
                END IF
            END IF
            DISPLAY BY NAME g_rmd[l_ac].rmk02
 
        AFTER FIELD rmd27
            IF NOT cl_null(g_rmd[l_ac].rmd27) THEN
               IF g_rmd[l_ac].rmd27 NOT MATCHES '[AU]' THEN
                   NEXT FIELD rmd27
               END IF
            END IF
 
        AFTER FIELD rmd12
            #-----MOD-A20040---------
            ##-----MOD-A20029---------
            #IF NOT cl_null(g_rmd[l_ac].rmd12) THEN
            #   IF g_rmd[l_ac].rmd12 < 0 THEN   
            #      CALL cl_err('','aec-020',0)
            #      NEXT FIELD CURRENT
            #   END IF   
            #END IF 
            ##-----END MOD-A20029-----
            #-----END MOD-A20040-----
            IF cl_null(g_rmd[l_ac].rmd12) THEN LET g_rmd[l_ac].rmd12 = 0 END IF
        #FUN-BB0084 ----------------------Begin----------------------
            IF NOT cl_null(g_rmd[l_ac].rmd05) AND NOT cl_null(g_rmd[l_ac].rmd12) THEN 
               IF cl_null(g_rmd05_t) OR cl_null(g_rmd_t.rmd12) OR g_rmd05_t ! = g_rmd[l_ac].rmd05
                  OR g_rmd_t.rmd12 ! = g_rmd[l_ac].rmd12 THEN 
                  LET g_rmd[l_ac].rmd12 = s_digqty(g_rmd[l_ac].rmd12,g_rmd[l_ac].rmd05)
                  DISPLAY BY NAME g_rmd[l_ac].rmd12
               END IF
            END IF
        #FUN-BB0084 ----------------------End------------------------
            CASE
              WHEN g_rmd[l_ac].rmd12 > 0 LET l_rmd08 = '1'
              OTHERWISE                  LET l_rmd08 = '2'
            END CASE
               IF g_rmd[l_ac].rmd12 <0 AND g_rmd[l_ac].rmd04 != 'MISC' THEN
                  CALL t128_chk_img()
                  IF g_errno='N' THEN
                     LET l_status='N'
                     NEXT FIELD rmd04
                  END IF
               END IF
            LET l_rmd14 = g_rmd[l_ac].rmd12 * l_rmd13
 
        AFTER FIELD rmdud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmdud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmdud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmdud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmdud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmdud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmdud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmdud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmdud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmdud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmdud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmdud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmdud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmdud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmdud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_rmd_t.rmd02 > 0 AND
               g_rmd_t.rmd02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF g_rmd[l_ac].rmd21 IS NOT NULL THEN
                    CALL cl_err('','arm-021',0)
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM rmd_file
                 WHERE rmd01 = g_rmc.rmc01 AND rmd02 = g_rmd_t.rmd02
                   AND rmd03 = g_rmc.rmc02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","rmd_file",g_rmc.rmc01,g_rmd_t.rmd02,SQLCA.sqlcode,"","",1) #FUN-660111
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b = g_rec_b - 1
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET INT_F='Y'       #MOD-830102 add
               LET g_rmd[l_ac].* = g_rmd_t.*
               CLOSE t128_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET INT_F='Y'          #MOD-840679 add
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_rmd[l_ac].rmd02,-263,1)
               LET g_rmd[l_ac].* = g_rmd_t.*
            ELSE
               IF g_rmd[l_ac].rmd02 IS NULL THEN LET g_rmd[l_ac].rmd02=0 END IF                    
               IF g_rmd[l_ac].rmd031 IS NULL THEN LET g_rmd[l_ac].rmd031= 0 END IF                    
               UPDATE rmd_file SET
                      rmd02=g_rmd[l_ac].rmd02,
                      rmd21=g_rmd[l_ac].rmd21, #MOD-980065    
                      rmd031=g_rmd[l_ac].rmd031,
                      rmd04=g_rmd[l_ac].rmd04,
                      rmd05=g_rmd[l_ac].rmd05,
                      rmd07=g_rmd[l_ac].rmd07,
                      rmd12=g_rmd[l_ac].rmd12,
                      rmd23=g_rmd[l_ac].rmd23,
                      rmd24=g_rmd[l_ac].rmd24,
                      rmd27=g_rmd[l_ac].rmd27,
                      rmd08=l_rmd08,
                      rmd13=l_rmd13,
                      rmd14=l_rmd14,
                      rmdud01 = g_rmd[l_ac].rmdud01,
                      rmdud02 = g_rmd[l_ac].rmdud02,
                      rmdud03 = g_rmd[l_ac].rmdud03,
                      rmdud04 = g_rmd[l_ac].rmdud04,
                      rmdud05 = g_rmd[l_ac].rmdud05,
                      rmdud06 = g_rmd[l_ac].rmdud06,
                      rmdud07 = g_rmd[l_ac].rmdud07,
                      rmdud08 = g_rmd[l_ac].rmdud08,
                      rmdud09 = g_rmd[l_ac].rmdud09,
                      rmdud10 = g_rmd[l_ac].rmdud10,
                      rmdud11 = g_rmd[l_ac].rmdud11,
                      rmdud12 = g_rmd[l_ac].rmdud12,
                      rmdud13 = g_rmd[l_ac].rmdud13,
                      rmdud14 = g_rmd[l_ac].rmdud14,
                      rmdud15 = g_rmd[l_ac].rmdud15
                WHERE rmd01=g_rmc.rmc01
                  AND rmd02=g_rmd_t.rmd02
                  AND rmd03=g_rmc.rmc02
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","rmd_file",g_rmc.rmc01,g_rmd_t.rmd02,SQLCA.sqlcode,"","",1) #FUN-660111
                  LET g_rmd[l_ac].* = g_rmd_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            LET l_ac_t = l_ac
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET INT_F='Y'       #MOD-830102 add
               #CKP
               IF p_cmd='u' THEN
                  LET g_rmd[l_ac].* = g_rmd_t.*
               END IF
               CLOSE t128_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
          #CKP
            LET INT_F='Y'          #MOD-840679 add
            CLOSE t128_bcl
            COMMIT WORK
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION CONTROLO                        #copy 上一筆料件編號
            IF INFIELD(rmd04) AND l_ac > 1 THEN
                LET g_rmd[l_ac].rmd04 = g_rmd[l_ac-1].rmd04
                NEXT FIELD rmd04
            END IF
 
        ON ACTION CONTROLP
            CASE
              WHEN INFIELD(rmd04)
#FUN-AA0059---------mod------------str-----------------              
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_ima"
#                 LET g_qryparam.default1 = g_rmd[l_ac].rmd04
#                 CALL cl_create_qry() RETURNING g_rmd[l_ac].rmd04
                  CALL q_sel_ima(FALSE, "q_ima","",g_rmd[l_ac].rmd04,"","","","","",'' ) 
                      RETURNING  g_rmd[l_ac].rmd04
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY BY NAME g_rmd[l_ac].rmd04          #No.MOD-490371
                 NEXT FIELD rmd04
              WHEN INFIELD(rmd05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = g_rmd[l_ac].rmd05
                 CALL cl_create_qry() RETURNING g_rmd[l_ac].rmd05
                  DISPLAY BY NAME g_rmd[l_ac].rmd05          #No.MOD-490371
                 NEXT FIELD rmd05
              WHEN INFIELD(rmd23)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rmk"
                 LET g_qryparam.default1 = g_rmd[l_ac].rmd23
                 CALL cl_create_qry() RETURNING g_rmd[l_ac].rmd23
                  DISPLAY BY NAME g_rmd[l_ac].rmd23          #No.MOD-490371
                 NEXT FIELD rmd23
              OTHERWISE EXIT CASE
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
 
    CALL t128_up_rmc()    #update rmc13=sum(rmd14)
    CLOSE t128_bcl
    COMMIT WORK
END FUNCTION

#-----------------------No:CHI-B60093 add----------------------
FUNCTION t128_get_ccc23(p_flag,p_ccc01,p_yy,p_mm)
   DEFINE p_ccc01      LIKE ccc_file.ccc01
   DEFINE p_flag       LIKE type_file.chr1
   DEFINE p_yy         LIKE ccc_file.ccc02
   DEFINE p_mm         LIKE ccc_file.ccc03
   DEFINE l_chr        LIKE type_file.chr1
   DEFINE l_ccc23      LIKE ccc_file.ccc23
   DEFINE l_ccc23_sum  LIKE ccc_file.ccc23
   DEFINE l_ccc02      LIKE ccc_file.ccc02
   DEFINE l_ccc03      LIKE ccc_file.ccc03
   DEFINE l_ccc02_t    LIKE ccc_file.ccc02
   DEFINE l_ccc03_t    LIKE ccc_file.ccc03
   DEFINE l_cnt        LIKE type_file.num5

   LET l_ccc23 = 0 
   LET l_ccc23_sum = 0 
   LET l_cnt = 0     
   LET l_ccc02_t = NULL 
   LET l_ccc03_t = NULL 
   LET l_chr = 'N'
   IF p_flag = '1' THEN 
      DECLARE ccc_ym CURSOR FOR
        SELECT ccc02,ccc03,ccc23 FROM ccc_file
         WHERE ccc01 = p_ccc01
           AND ccc07 = g_ccz.ccz28
           AND ccc02*12+ccc03<=p_yy*12+p_mm
         ORDER BY ccc02 DESC, ccc03 DESC
      IF g_ccz.ccz28 MATCHES "[12]" THEN
      #成本參數設定月加權平均
         FOREACH ccc_ym INTO l_ccc02,l_ccc03,l_ccc23
            LET l_ccc23_sum = l_ccc23
            LET l_cnt = l_cnt + 1
            LET l_chr = 'Y'
            EXIT FOREACH
         END FOREACH
      ELSE
         FOREACH ccc_ym INTO l_ccc02,l_ccc03,l_ccc23
            IF NOT cl_null(l_ccc02_t) AND NOT cl_null(l_ccc03_t) 
               AND (l_ccc02 *12+ l_ccc03) <> (l_ccc02_t*12+l_ccc03_t) THEN
               EXIT FOREACH
            ELSE
               LET l_ccc23_sum = l_ccc23_sum + l_ccc23
               LET l_cnt = l_cnt + 1
               LET l_ccc02_t = l_ccc02 
               LET l_ccc03_t = l_ccc03 
               LET l_chr = 'Y'
            END IF
         END FOREACH
      END IF 
   ELSE
      DECLARE cca_ym CURSOR FOR
         SELECT cca02,cca03,cca12 FROM cca_file
          WHERE cca01 = p_ccc01
           AND cca06 = g_ccz.ccz28
           AND cca02*12+cca03<=p_yy*12+p_mm
          ORDER BY cca02 DESC, cca03 DESC
      IF g_ccz.ccz28 MATCHES "[12]" THEN
      #成本參數設定月加權平均
         FOREACH cca_ym INTO l_ccc02,l_ccc03,l_ccc23
            LET l_ccc23_sum = l_ccc23
            LET l_cnt = l_cnt + 1
            LET l_chr = 'Y'
            EXIT FOREACH
         END FOREACH
      ELSE
         FOREACH cca_ym INTO l_ccc02,l_ccc03,l_ccc23
            IF NOT cl_null(l_ccc02_t) AND NOT cl_null(l_ccc03_t) 
               AND (l_ccc02 *12+ l_ccc03) <> (l_ccc02_t*12+l_ccc03_t) THEN
               EXIT FOREACH
            ELSE
               LET l_ccc23_sum = l_ccc23_sum + l_ccc23
               LET l_cnt = l_cnt + 1
               LET l_ccc02_t = l_ccc02 
               LET l_ccc03_t = l_ccc03 
               LET l_chr = 'Y'
            END IF
         END FOREACH
      END IF
   END IF
   IF l_cnt = 0 THEN LET l_cnt = 1 END IF
   LET l_ccc23_sum = l_ccc23_sum / l_cnt
   IF l_chr = 'N' THEN
      RETURN NULL
   ELSE
      RETURN l_ccc23_sum
   END IF

END FUNCTION
#-----------------------No:CHI-B60093 add----------------------
 
FUNCTION t128_up_rmc()  # rmc13=sum(rmd14)
   DEFINE t_rmd14  LIKE rmd_file.rmd14
 
    SELECT sum(rmd14) INTO t_rmd14 FROM rmd_file
     WHERE rmd01=g_rmc.rmc01 AND rmd03=g_rmc.rmc02
       AND rmd12 >0
 
    IF t_rmd14 IS NULL THEN LET t_rmd14=0 END IF
    UPDATE rmc_file set rmc13=t_rmd14
           WHERE rmc01=g_rmc.rmc01 AND rmc02=g_rmc.rmc02
END FUNCTION
 
FUNCTION t128_chk_img()
   DEFINE l_img RECORD LIKE img_file.*,
          l_img09  LIKE img_file.img09,
          l_ima71  LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
   SELECT * FROM img_file
        WHERE img01=g_rmd[l_ac].rmd04 AND img02=g_rmz.rmz02
          AND (img03=' ' OR img03 IS NULL)  #No:8517
          AND (img04=' ' OR img04 IS NULL)  #No:8517
   IF STATUS=100 THEN  #No.7926
      INITIALIZE l_img.* TO NULL
      LET l_img.img01=g_rmd[l_ac].rmd04           #料號
      LET l_img.img02=g_rmz.rmz02                 #倉庫(中途倉)
      LET l_img.img03=' '                         #儲位No:8517 ''改 ' '
      LET l_img.img04=' '                         #批號No:8517 ''改 ' '
      LET l_img.img05=g_rmc.rmc01                 #參號單號
      LET l_img.img06=g_rmd[l_ac].rmd02           #項次
      SELECT ima25,ima71 INTO l_img09,l_ima71 FROM ima_file
             WHERE ima01=l_img.img01 #庫存單位,儲存有效天數
      IF SQLCA.sqlcode OR l_ima71 IS NULL THEN LET l_ima71=0 END IF
      LET l_img.img09 = l_img09                   #庫存單位
      LET l_img.img10=0                           #庫存數量
      LET l_img.img13=0                           #
      LET l_img.img17=g_today
      IF l_ima71 =0 THEN
         LET l_img.img18=g_lastdat           #有效日期
      ELSE
         IF cl_null(g_rmc.rmc08) THEN
            LET l_img.img18=g_today+l_ima71
         ELSE
            LET l_img.img18=g_rmc.rmc08+l_ima71
         END IF
      END IF
      LET l_img.img21=1                           #factor
      LET l_img.img22=1                           #factor
     #中途倉: 倉儲類別,是否為可用倉儲,是否為MRP可用倉儲,保稅否
      SELECT imd10,imd11,imd12,imd13 INTO
             l_img.img22, l_img.img23, l_img.img24, l_img.img25
        FROM imd_file WHERE imd01=g_rmz.rmz02
      LET l_img.img30=0
      LET l_img.img31=0
      LET l_img.img32=0
      LET l_img.img33=0
      LET l_img.img34=1
      LET g_errno=' '
      IF g_sma.sma892[2,2]='Y' THEN
         OPEN WINDOW t3241_w AT 11,29 WITH FORM "aim/42f/aimt3241"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimt3241")
 
 
           DISPLAY l_img09 TO ima25
           INPUT BY NAME l_img.img09, l_img.img21,
                         l_img.img26, l_img.img19, l_img.img36,
                         l_img.img27, l_img.img28, l_img.img35
                         WITHOUT DEFAULTS
           AFTER FIELD img09
             IF NOT cl_null(l_img.img09) THEN
                 SELECT gfe02 INTO g_buf FROM gfe_file WHERE gfe01=l_img.img09
                 IF STATUS THEN 
                 CALL cl_err3("sel","gfe_file",l_img.img09,"",STATUS,"","gfe:",1) #FUN-660111
                 NEXT FIELD img09 END IF
                 CALL s_umfchk(l_img.img01,l_img.img09,l_img09)
                              RETURNING g_cnt,l_img.img21
                 IF g_cnt = 1 THEN
                    CALL cl_err('','mfg3075',0)
                    NEXT FIELD img09
                 END IF
                 DISPLAY BY NAME l_img.img21
             END IF
 
           AFTER FIELD img21
             IF NOT cl_null(l_img.img21) THEN
                 IF l_img.img21=0 THEN NEXT FIELD img21 END IF
             END IF
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
          CLOSE WINDOW t3241_w
          IF INT_FLAG THEN LET INT_FLAG=0 LET g_errno='N' RETURN END IF
      END IF
      IF l_img.img02 IS NULL THEN LET l_img.img02 = ' ' END IF
      IF l_img.img03 IS NULL THEN LET l_img.img03 = ' ' END IF
      IF l_img.img04 IS NULL THEN LET l_img.img04 = ' ' END IF
      
      LET l_img.imgplant = g_plant #FUN-980007
      LET l_img.imglegal = g_legal #FUN-980007
      INSERT INTO img_file VALUES (l_img.*)
      IF STATUS THEN 
      CALL cl_err3("ins","img_file",l_img.img01,l_img.img02,STATUS,"","ins img",1) #FUN-660111
      LET g_errno='N' END IF
      LET g_rmd[l_ac].rmd05 = l_img.img09
      LET g_rmd[l_ac].rmd12 = s_digqty(g_rmd[l_ac].rmd12,g_rmd[l_ac].rmd05)   #FUN-BB0084
      DISPLAY BY NAME g_rmd[l_ac].rmd12             #FUN-BB0084
   END IF
END FUNCTION
 
FUNCTION t128_b_askkey()
DEFINE    l_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON rmd02,rmd031,rmd23,rmd24,   #螢幕上取單身條件
                       rmd04,rmd07,rmd05,rmd12,rmd27,rmd21
                       ,rmdud01,rmdud02,rmdud03,rmdud04,rmdud05
                       ,rmdud06,rmdud07,rmdud08,rmdud09,rmdud10
                       ,rmdud11,rmdud12,rmdud13,rmdud14,rmdud15
                  FROM s_rmd[1].rmd02, s_rmd[1].rmd031,s_rmd[1].rmd23,
                       s_rmd[1].rmd24, s_rmd[1].rmd04, s_rmd[1].rmd07,
                       s_rmd[1].rmd05, s_rmd[1].rmd12, s_rmd[1].rmd27,
                       s_rmd[1].rmd21
                       ,s_rmd[1].rmdud01,s_rmd[1].rmdud02,s_rmd[1].rmdud03
                       ,s_rmd[1].rmdud04,s_rmd[1].rmdud05,s_rmd[1].rmdud06
                       ,s_rmd[1].rmdud07,s_rmd[1].rmdud08,s_rmd[1].rmdud09
                       ,s_rmd[1].rmdud10,s_rmd[1].rmdud11,s_rmd[1].rmdud12
                       ,s_rmd[1].rmdud13,s_rmd[1].rmdud14,s_rmd[1].rmdud15
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t128_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t128_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    LET g_sql = "SELECT rmd02,rmd031,rmd23,rmk02,rmd21,rmd24,rmd04,",
                "       rmd07,rmd12,rmd05,rmd27, ",
                "       rmdud01,rmdud02,rmdud03,rmdud04,rmdud05,",
                "       rmdud06,rmdud07,rmdud08,rmdud09,rmdud10,",
                "       rmdud11,rmdud12,rmdud13,rmdud14,rmdud15 ", 
                " FROM rmd_file LEFT JOIN rmk_file ON rmk_file.rmk01 = rmd23",
                " WHERE rmd01 ='",g_rmc.rmc01,"'",  #單頭
                "   AND rmd03 =",g_rmc.rmc02,
                "   AND ",p_wc2 CLIPPED,            #單身
                " ORDER BY rmd02 "
    PREPARE t128_pb FROM g_sql
    IF STATUS THEN CALL cl_err('t128_pb',STATUS,1) RETURN END IF
    DECLARE rmd_cs CURSOR FOR t128_pb
 
    CALL g_rmd.clear()
    LET g_cnt = 1
    LET g_rec_b = 0
    LET g_rmd21=''
    FOREACH rmd_cs INTO g_rmd[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF g_cnt=1 THEN
           SELECT rmd21 INTO g_rmd21 FROM rmd_file
                  WHERE rmd01 = g_rmc.rmc01
                    AND rmd03 = g_rmc.rmc02
                    AND rmd02 = g_rmd[g_cnt].rmd02
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    #CKP
    CALL g_rmd.deleteElement(g_cnt)
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    IF g_rmd21 IS NULL THEN
       DISPLAY "N" TO FORMONLY.md21
    ELSE
       DISPLAY "Y" TO FORMONLY.md21
    END IF
END FUNCTION
 
FUNCTION t128_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rmd TO s_rmd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t128_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t128_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t128_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t128_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t128_fetch('L')
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
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 客訴問題
      ON ACTION customer_problem
         LET g_action_choice="customer_problem"
         EXIT DISPLAY
    #@ON ACTION 整批修復
      ON ACTION batch_fix
         LET g_action_choice="batch_fix"
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
 
 
      ON ACTION exporttoexcel       #FUN-4B0035
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0018  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t128_out()
DEFINE sr       RECORD
                rmc    RECORD LIKE rmc_file.*,
                rmd    RECORD LIKE rmd_file.*,
                rma03  LIKE rma_file.rma03,
                rma04  LIKE rma_file.rma04,
                rmc14d LIKE type_file.chr20,   #No.FUN-690010 VARCHAR(20),
                rmk    RECORD LIKE rmk_file.*
                END RECORD,
       l_name   LIKE type_file.chr20   #No.FUN-690010 VARCHAR(20)
    DEFINE l_sql STRING                                                                                                             
    CALL cl_del_data(l_table)                                                                                                       
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog                                                                          
 
    IF cl_null(g_rmc.rmc01) OR cl_null(g_rmc.rmc02) THEN
          CALL cl_err('','arm-019',0) RETURN END IF
     IF g_wc IS NULL THEN
           LET g_wc="     rmc01='",g_rmc.rmc01,"'",
                    " AND rmc02=",g_rmc.rmc02
     END IF
 
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql=" SELECT rmc_file.*,rmd_file.*,rma03,rma04,'',rmk_file.* ",
              "   FROM rmc_file,rma_file,rmd_file LEFT JOIN rmk_file ON rmd23 = rmk_file.rmk01  ",
              "  WHERE ",g_wc CLIPPED,
              "    AND ",g_wc2 CLIPPED,
              "    AND rmc01 = rmd01 ",
              "    AND rmc02 = rmd03 ",
              "    AND rma01 = rmc01 ",
              "  ORDER BY rmc01,rmc02,rmd031,rmk03,rmk01,rmd04 "
    PREPARE t128_p1 FROM g_sql              # RUNTIME 編譯
    IF STATUS THEN CALL cl_err('t128_p1',STATUS,1) RETURN END IF
    DECLARE t128_co                         # SCROLL CURSOR
        CURSOR FOR t128_p1
 
 
    FOREACH t128_co INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        CASE g_lang
          WHEN '0'
            CASE g_rmc.rmc14
              WHEN '0' LET sr.rmc14d = '未修復'
              WHEN '1' LET sr.rmc14d = '修復'
              WHEN '2' LET sr.rmc14d = '不修'
              WHEN '3' LET g_buf = '轉銷退'
              WHEN '4' LET g_buf = '報廢'
              WHEN '5' LET g_buf = '修畢己包裝'
              WHEN '6' LET g_buf = '未修己包裝'
            END CASE
          WHEN '2'
            CASE g_rmc.rmc14
              WHEN '0' LET sr.rmc14d = '未修復'
              WHEN '1' LET sr.rmc14d = '修復'
              WHEN '2' LET sr.rmc14d = '不修'
              WHEN '3' LET g_buf = '轉銷退'
              WHEN '4' LET g_buf = '報廢'
              WHEN '5' LET g_buf = '修畢己包裝'
              WHEN '6' LET g_buf = '未修己包裝'
            END CASE
          OTHERWISE
            CASE g_rmc.rmc14
              WHEN '0' LET sr.rmc14d = 'Waiting Repair'
              WHEN '1' LET sr.rmc14d = 'Repaired'
              WHEN '2' LET sr.rmc14d = 'Non Repair'
              WHEN '3' LET g_buf = 'Tr to S/R'
              WHEN '4' LET g_buf = 'Scrp'
              WHEN '5' LET g_buf = 'Fixd&Packd'
              WHEN '6' LET g_buf = 'Unfix&Packd'
            END CASE
        END CASE
        EXECUTE insert_prep USING sr.rmc.rmc01,sr.rmc.rmc02,sr.rmc.rmc04,                                                           
                                  sr.rmc.rmc06,sr.rmc.rmc061,sr.rmc.rmc08,                                                          
                                  sr.rmc.rmc09,sr.rmc.rmc10,sr.rmc.rmc14,                                                           
                                  sr.rmc.rmc16,sr.rmc.rmc25,sr.rmd.rmd01,                                                           
                                  sr.rmd.rmd02,sr.rmd.rmd031,sr.rmd.rmd04,                                                          
                                  sr.rmd.rmd05,sr.rmd.rmd06,sr.rmd.rmd061,                                                          
                                  sr.rmd.rmd07,sr.rmd.rmd12,sr.rmd.rmd21,                                                           
                                  sr.rmd.rmd23,sr.rmd.rmd24,sr.rmd.rmd27,                                                           
                                  sr.rma03,sr.rma04,sr.rmk.rmk01,                                                                   
                                  sr.rmk.rmk02,sr.rmk.rmk03,sr.rmc14d                                                               
        IF SQLCA.sqlcode THEN                                                                                                       
           CALL cl_err('execute:',status,1)                                                                                         
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
           EXIT PROGRAM                                                                                                             
        END IF                                                                                                                      
    END FOREACH
        LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,                                                                           
                     l_table CLIPPED,                                                                                               
                    " ORDER BY rmc01,rmc02,rmd02"                                                                                   
                                                                                                                                    
        IF g_zz05='Y' THEN                                                                                                          
           CALL cl_wcchp(g_wc,'')                                                                                                   
           RETURNING g_str                                                                                                          
        ELSE                                                                                                                        
           LET g_str = ''                                                                                                           
        END IF                                                                                                                      
        LET g_str=g_str                                                                                                             
        CALL cl_prt_cs3('armt128','armt128',l_sql,g_str)                                                                            
    CLOSE t128_co
    MESSAGE ""
END FUNCTION
 
FUNCTION t128_m()
   DEFINE i,j,k      LIKE type_file.num5    #No.FUN-690010 SMALLINT
    DEFINE l_ac_t     LIKE type_file.num5   #No.MOD-490059  #No.FUN-690010 SMALLINT
    DEFINE l_ac,l_n   LIKE type_file.num5   #No.MOD-490059  #No.FUN-690010 SMALLINT
    DEFINE p_cmd      LIKE type_file.chr1    #No.MOD-490059  #No.FUN-690010 VARCHAR(1)
    DEFINE l_lock_sw  LIKE type_file.chr1    #No.MOD-490059  #No.FUN-690010 VARCHAR(1)
   DEFINE l_rmr      DYNAMIC ARRAY OF RECORD
                     rmr03   LIKE rmr_file.rmr03,
                     rmr04   LIKE rmr_file.rmr04
                     END RECORD,
           l_rmr_t    RECORD   #No.MOD-490059
                     rmr03   LIKE rmr_file.rmr03,
                     rmr04   LIKE rmr_file.rmr04
                     END RECORD,
          l_allow_insert   LIKE type_file.num5,                #可新增否  #No.FUN-690010 SMALLINT
          l_allow_delete   LIKE type_file.num5,                #可刪除否  #No.FUN-690010 SMALLINT
          l_cnt     LIKE type_file.num5,   #MOD-950062
          l_rma22   LIKE rma_file.rma22,   #MOD-950062
          l_sql     STRING   #MOD-950062
 
    LET l_allow_insert = cl_detail_input_auth('insert') #No.MOD-490059
    LET l_allow_delete = cl_detail_input_auth('delete') #No.MOD-490059
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
   IF cl_null(g_rmc.rmc01) OR cl_null(g_rmc.rmc02) THEN RETURN END IF
   OPEN WINDOW t128_m_w AT 07,23 WITH FORM "arm/42f/armt128_m"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("armt128_m")
 
   CALL cl_opmsg('b')
 
   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM rmr_file
     WHERE rmr01 = g_rmc.rmc01 AND rmr02 = g_rmc.rmc02
   IF l_cnt = 0 THEN 
      LET l_rma22 = ''
      SELECT rma22 INTO l_rma22 FROM rma_file WHERE rma01 = g_rmc.rmc01
      LET l_sql = " SELECT ohd02,ohd03 FROM ohd_file ",
                  "   WHERE ohd01 ='",l_rma22,"' ",
                  "   ORDER BY ohd02 "
   ELSE
     LET l_sql = " SELECT rmr03,rmr04 FROM rmr_file ",
                 "   WHERE rmr01 ='",g_rmc.rmc01,"' ",
                 "     AND rmr02 ='",g_rmc.rmc02,"' ",
                 "   ORDER BY rmr03 "
   END IF
   PREPARE t128_m_p FROM l_sql
   DECLARE t128_m_c CURSOR FOR t128_m_p
 
   CALL l_rmr.clear()
   LET i = 1
   FOREACH t128_m_c INTO l_rmr[i].rmr03,l_rmr[i].rmr04
      IF STATUS THEN CALL cl_err('foreach rmr',STATUS,0) EXIT FOREACH END IF
      IF l_cnt = 0 THEN 
         INSERT INTO rmr_file(rmr01,rmr02,rmr03,rmr04,
                              rmrplant,rmrlegal)   #FUN-980007
                  VALUES(g_rmc.rmc01,g_rmc.rmc02,
                         l_rmr[i].rmr03,l_rmr[i].rmr04,
                         g_plant,g_legal)          #FUN-980007
      END IF
      LET i = i + 1
   END FOREACH
    CALL l_rmr.deleteElement(i) #No.MOD-490059
    LET g_rec_b=i-1             #No.MOD-490059
 
   LET g_forupd_sql = "SELECT rmr03,rmr04 FROM rmr_file ",
                      "  WHERE rmr01 = ? AND rmr02 = ? AND rmr03=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t128_m_bcl CURSOR FROM g_forupd_sql       # LOCK CURSOR
 
   INPUT ARRAY l_rmr WITHOUT DEFAULTS FROM s_rmr.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
    BEFORE INPUT
       IF g_rec_b != 0 THEN
          CALL fgl_set_arr_curr(l_ac)
       END IF
 
    BEFORE ROW
        DISPLAY "BEFORE ROW"
        LET p_cmd=''
        LET l_ac = ARR_CURR()
        LET l_lock_sw = 'N'            #DEFAULT
        LET l_n  = ARR_COUNT()
 
        IF g_rec_b>=l_ac THEN
           BEGIN WORK
           LET p_cmd='u'
           LET l_rmr_t.* = l_rmr[l_ac].*  #BACKUP
           OPEN t128_m_bcl USING g_rmc.rmc01, g_rmc.rmc02,l_rmr_t.rmr03
           IF STATUS THEN
              CALL cl_err("OPEN t128_m_bcl:", STATUS, 1)
              LET l_lock_sw = "Y"
           ELSE
              FETCH t128_m_bcl INTO l_rmr[l_ac].*
              IF SQLCA.sqlcode THEN
                  CALL cl_err(l_rmr_t.rmr03,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
              END IF
           END IF
           CALL cl_show_fld_cont()     #FUN-550037(smin)
        END IF
 
        BEFORE INSERT
        DISPLAY "BEFORE INSERT"
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE l_rmr[l_ac].* TO NULL      #900423
            LET l_rmr_t.* = l_rmr[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD rmr03
 
        AFTER INSERT
        DISPLAY "AFTER INSERT"
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CLOSE t128_m_bcl
               CANCEL INSERT
            END IF
            INSERT INTO rmr_file(rmr01,rmr02,rmr03,rmr04,
                                 rmrplant,rmrlegal) #FUN-980007
                     VALUES(g_rmc.rmc01,g_rmc.rmc02,
                            l_rmr[l_ac].rmr03,l_rmr[l_ac].rmr04,
                            g_plant,g_legal)      #FUN-980007
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rmr_file",g_rmc.rmc01,g_rmc.rmc02,SQLCA.sqlcode,"","",1) #FUN-660111
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
            END IF
        BEFORE DELETE                            #是否取消單身
        DISPLAY "BEFORE DELETE"
           IF l_rmr_t.rmr03 IS NOT NULL THEN
              IF NOT cl_delete() THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rmr_file
               WHERE rmr01 = g_rmc.rmc01
                 AND rmr02 = g_rmc.rmc02
                 AND rmr03 = l_rmr_t.rmr03
              IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","rmr_file",g_rmc.rmc01,g_rmc.rmc02,SQLCA.sqlcode,"","",1) #FUN-660111
                  CANCEL DELETE
                  EXIT INPUT
              END IF
              LET g_rec_b=g_rec_b-1
              COMMIT WORK
           END IF
        BEFORE FIELD rmr03
           DISPLAY "BEFORE FIELD rmr03"
           IF l_rmr[l_ac].rmr03 IS NULL OR
              l_rmr[l_ac].rmr03 = 0 THEN
                SELECT max(rmr03)+1
                   INTO l_rmr[l_ac].rmr03
                   FROM rmr_file
                     WHERE rmr01 = g_rmc.rmc01
                       AND rmr02 = g_rmc.rmc02
                IF l_rmr[l_ac].rmr03 IS NULL THEN
                    LET l_rmr[l_ac].rmr03 = 1
                END IF
            END IF
        ON ROW CHANGE
           DISPLAY "ON ROW CHANGE"
           IF INT_FLAG THEN                 #新增程式段
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET l_rmr[l_ac].* = l_rmr_t.*
              CLOSE t128_m_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw="Y" THEN
               CALL cl_err(l_rmr[l_ac].rmr03,-263,0)
               LET l_rmr[l_ac].* = l_rmr_t.*
           ELSE
               UPDATE rmr_file SET rmr03=l_rmr[l_ac].rmr03,
                                   rmr04=l_rmr[l_ac].rmr04
                 WHERE rmr01 = g_rmc.rmc01
                   AND rmr02 = g_rmc.rmc02
                   AND rmr03 = l_rmr_t.rmr03
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","rmr_file",g_rmc.rmc01,g_rmc.rmc02,SQLCA.sqlcode,"","",1) #FUN-660111
                   LET l_rmr[l_ac].* = l_rmr_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
           END IF
        AFTER ROW
          DISPLAY "AFTER ROW"
          LET l_ac = ARR_CURR()            # 新增
          LET l_ac_t = l_ac                # 新增
 
          IF INT_FLAG THEN                 #900423
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd='u' THEN
                LET l_rmr[l_ac].* = l_rmr_t.*
             END IF
             CLOSE t128_m_bcl               # 新增
             ROLLBACK WORK                 # 新增
             EXIT INPUT
          END IF
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
     END INPUT
     CLOSE WINDOW t128_m_w
     CLOSE t128_m_bcl                  # 新增
     COMMIT WORK
END FUNCTION
 
FUNCTION t128_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("rmc01,rmc02",TRUE)
   END IF
END FUNCTION
 
FUNCTION t128_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("rmc01,rmc02",FALSE)
   END IF
END FUNCTION
 
FUNCTION t128_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   IF p_cmd = 'a' OR (p_cmd = 'u' AND g_rmd[l_ac].rmd21 IS NULL)
     AND ( NOT g_before_input_done ) THEN
    #CALL cl_set_comp_entry("rmd02,rmd031,rmd23,rmk02,rmd21,rmd24,rmd04,rmd07,rmd12,rmd05,rmd27",TRUE) #CHI-A90040 mark
     CALL cl_set_comp_entry("rmd02,rmd031,rmd23,rmd21,rmd24,rmd04,rmd07,rmd12,rmd05,rmd27",TRUE) #CHI-A90040
   END IF
END FUNCTION
 
FUNCTION t128_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
   LET g_edit = 'Y'    #TQC-A1002
   IF p_cmd = 'u' AND g_rmd[l_ac].rmd21 IS NOT NULL  AND ( NOT g_before_input_done ) THEN
    #CALL cl_set_comp_entry("rmd02,rmd031,rmd23,rmk02,rmd21,rmd24,rmd04,rmd07,rmd12,rmd05,rmd27",FALSE) #CHI-A90040 mark
     CALL cl_set_comp_entry("rmd02,rmd031,rmd23,rmd21,rmd24,rmd04,rmd07,rmd12,rmd05,rmd27",FALSE) #CHI-A90040
     LET g_edit = 'N'  #TQC-A10002
   END IF
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
