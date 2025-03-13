# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: armt160.4gl
# Descriptions...: RMA覆出單產生作業
# Date & Author..: 98/04/21 plum
# Modify.........: BUGNO:7487 03/07/16 Nicola Where 增加使用者、部門、修改者、日期
# Modify.........: No:7947 03/08/28 By Wiky 若為輸入的方式 ,而不是以查詢的方式 ,會無法 O 列印
# Modify.........: No:8714 03/12/02 ching 過帳後取消過帳,再次做過帳就不行
# Modify.........: 04/07/16 By Wiky Bugno.MOD-470041 修改INSERT INTO ...
# Modify.........: 04/09/30 By Mandy Bugno.MOD-490416 單身RMA項次,有重複要擋掉,若作廢也不可以新增
# Modify.........: No.MOD-4A0268 04/10/20 By ching 提示訊息錯誤修改
# Modify.........: No.MOD-4A0248 04/10/28 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0035 04/11/09 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0055 04/12/09 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510044 05/02/03 By Mandy 報表轉XML
# Modify.........: No.MOD-530716 05/03/28 By Mandy 無法直接串包裝單維護(若包裝單尚未產生，應有錯誤訊息)
# Modify.........: No.FUN-550064 05/05/28 By Trisy 單據編號加大
# Modify.........: NO.FUN-560014 05/06/08 By jackie 單據編號修改
# Modify.........: NO.MOD-570357 05/07/25 By Yiting rmp09給了值但無回寫
# Modify.........: NO.MOD-590034 05/10/24 By Nicola 加一行Disaply
# Modify.........: NO.MOD-570393 05/10/28 BY Yiting
#                  若此客戶要做包裝單,在確認的時候,若單身有任何一筆箱號是NULL或空白則提示"此客戶要做包裝單,但單身箱號未齊
# Modify.........: NO.TQC-5A0110 05/10/28 BY yiting AFTER FIELD rmd011 在此SQL之前應先用LET g_t = s_get_doc_no(g_rme.rme011)  將g_t的值取出
# Modify.........: No.FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.FUN-630016 06/03/07 By ching  ADD p_flow功能
# Modify.........: No.TQC-630150 06/03/14 By 扣帳執行有誤
# Modify.........: No.TQC-630145 06/03/28 By  RMA單號^P查無單號
# Modify.........: No.TQC-610087 06/04/03 By Claire Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.MOD-650084 06/05/19 By Pengu 客戶是保稅廠時無法確認
# Modify.........: No.FUN-660111 06/06/12 By pxlpxl substitute cl_err() for cl_err3()
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-690010 06/09/05 By huchenghao 類型轉換
# Modify.........: No.FUN-680064 06/10/18 By huchenghao 初始化g_rec_b
# Modify.........: No.FUN-6A0085 06/10/26 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0018 06/11/08 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.CHI-6B0071 06/12/19 By jamie 新增刪除功能
# Modify.........: No.TQC-6C0213 04/12/31 By chenl 點擊更改和備注時，報錯信息循環報錯。
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-770022 07/07/06 By Smapmin 修改開窗所帶的變數
# Modify.........: NO.TQC-790003 07/09/03 BY yiting insert into前給予預設值
# Modify.........: NO.TQC-790051 07/09/10 BY lumxa 點查詢時，狀態中“資料所有者、資料所有部門、資料更改者、最近更改日”都是灰色
# Modify.........: NO.MOD-7A0145 07/09/25 BY Carol 單身自動產生時rmp011應給值不可為null 
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-840369 08/04/21 By jamie 當新增完後進入單身後,"資料重複,請檢查主鍵欄位資料 !"
# Modify.........: No.FUN-840068 08/04/23 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-860018 08/06/18 BY TSD.lucasyeh 轉Crystal Report
# Modify.........: No.FUN-890102 08/09/23 By baofei CR追單到31區
# Modify.........: No.MOD-920045 09/02/04 By Smapmin 單身按產生ACTION後,單身資料顯示有誤
# Modify.........: No.MOD-950063 09/05/14 By Smapmin 單身收費否欄位未default為armt128單頭的收費否欄位
# Modify.........: No.MOD-950152 09/05/15 By Smapmin 利潤率要抓取參數設定檔的設定
# Modify.........: No.FUN-980007 09/08/17 By TSD.zeak GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9C0200 10/01/04 By lilingyu 單身"軟盤數量"欄位未控管負數
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A30035 10/03/08 By Sarah SQL裡有rmc14條件的,請加上56
# Modify.........: No:MOD-A30047 10/03/10 By Sarah 若單身已有資料,則提示訊息且不允許修改rem011
# Modify.........: No:MOD-A90172 10/09/27 By sabrina 按下備註action後，再按新增時只能輸入rme01，其餘都無法輸入
# Modify.........: No:MOD-AA0009 10/10/04 By sabrina 若RMA覆出單號已存在armt200，則不可以取消確認
# Modify.........: No:MOD-B40218 11/04/22 By zhangll 取消異常單別判斷
# Modify.........: No:MOD-B50116 11/05/20 By vampire 新增時g_wc2值不應清空
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No.CHI-BC0016 11/12/08 By 1.將arm-530的控卡移到過帳段
#                                            2.過帳時開放覆出日期(rme021)可維護，預設帶當天日期，過帳還原時rme021不update回null
# Modify.........: No.FUN-910088 11/12/22 By chenjing 增加數量欄位小數取位
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C30085 12/07/06 By lixiang 改CR報表串GR報表
# Modify.........: No:CHI-C80041 12/12/19 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:CHI-D20010 13/02/20 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/08 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_rme   RECORD LIKE rme_file.*,
    l_rmp   RECORD LIKE rmp_file.*,
    t_rmp   RECORD
            rmp01      LIKE rmp_file.rmp01,
            rmp05      LIKE rmp_file.rmp05,
            rmp03      LIKE rmp_file.rmp03,
            rmp11      LIKE rmp_file.rmp11,
            rmp13      LIKE rmp_file.rmp13,
            rmp10      LIKE rmp_file.rmp10,
            rmp09      LIKE rmp_file.rmp09,
           #rmc03      LIKE rmc_file.rmc03,   #MOD-950063 mark
            rmc09      LIKE rmc_file.rmc09,   #MOD-950063 add 
            rmp07      LIKE rmp_file.rmp07,
            rmp08      LIKE rmp_file.rmp08
            END RECORD,
    g_rme_t RECORD LIKE rme_file.*,
    g_rme_o RECORD LIKE rme_file.*,
    g_rmf   RECORD LIKE rmf_file.*,
    g_rmp02    LIKE rmp_file.rmp02,
    g_rme01_t  LIKE rme_file.rme01,
    g_rmp           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                    rmp02     LIKE rmp_file.rmp02,
                    rmp06     LIKE rmp_file.rmp06,
                    rmp03     LIKE rmp_file.rmp03,
                    rmp07     LIKE rmp_file.rmp07,
                    rmp08     LIKE rmp_file.rmp08,
                    rmp11     LIKE rmp_file.rmp11,
                    rmp10     LIKE rmp_file.rmp10,
                    rmp13     LIKE rmp_file.rmp13,
                    rmp14     LIKE rmp_file.rmp14,
                    rmp12     LIKE rmp_file.rmp12,
                    rmp15     LIKE rmp_file.rmp15,
                    #FUN-840068 --start---
                    rmpud01   LIKE rmp_file.rmpud01,
                    rmpud02   LIKE rmp_file.rmpud02,
                    rmpud03   LIKE rmp_file.rmpud03,
                    rmpud04   LIKE rmp_file.rmpud04,
                    rmpud05   LIKE rmp_file.rmpud05,
                    rmpud06   LIKE rmp_file.rmpud06,
                    rmpud07   LIKE rmp_file.rmpud07,
                    rmpud08   LIKE rmp_file.rmpud08,
                    rmpud09   LIKE rmp_file.rmpud09,
                    rmpud10   LIKE rmp_file.rmpud10,
                    rmpud11   LIKE rmp_file.rmpud11,
                    rmpud12   LIKE rmp_file.rmpud12,
                    rmpud13   LIKE rmp_file.rmpud13,
                    rmpud14   LIKE rmp_file.rmpud14,
                    rmpud15   LIKE rmp_file.rmpud15
                    #FUN-840068 --end--
                    END RECORD,
    g_rmp_t         RECORD
                    rmp02     LIKE rmp_file.rmp02,
                    rmp06     LIKE rmp_file.rmp06,
                    rmp03     LIKE rmp_file.rmp03,
                    rmp07     LIKE rmp_file.rmp07,
                    rmp08     LIKE rmp_file.rmp08,
                    rmp11     LIKE rmp_file.rmp11,
                    rmp10     LIKE rmp_file.rmp10,
                    rmp13     LIKE rmp_file.rmp13,
                    rmp14     LIKE rmp_file.rmp14,
                    rmp12     LIKE rmp_file.rmp12,
                    rmp15     LIKE rmp_file.rmp15,
                    #FUN-840068 --start---
                    rmpud01   LIKE rmp_file.rmpud01,
                    rmpud02   LIKE rmp_file.rmpud02,
                    rmpud03   LIKE rmp_file.rmpud03,
                    rmpud04   LIKE rmp_file.rmpud04,
                    rmpud05   LIKE rmp_file.rmpud05,
                    rmpud06   LIKE rmp_file.rmpud06,
                    rmpud07   LIKE rmp_file.rmpud07,
                    rmpud08   LIKE rmp_file.rmpud08,
                    rmpud09   LIKE rmp_file.rmpud09,
                    rmpud10   LIKE rmp_file.rmpud10,
                    rmpud11   LIKE rmp_file.rmpud11,
                    rmpud12   LIKE rmp_file.rmpud12,
                    rmpud13   LIKE rmp_file.rmpud13,
                    rmpud14   LIKE rmp_file.rmpud14,
                    rmpud15   LIKE rmp_file.rmpud15
                    #FUN-840068 --end--
                    END RECORD,
    g_rmp_o         RECORD
                    rmp02     LIKE rmp_file.rmp02,
                    rmp06     LIKE rmp_file.rmp06,
                    rmp03     LIKE rmp_file.rmp03,
                    rmp07     LIKE rmp_file.rmp07,
                    rmp08     LIKE rmp_file.rmp08,
                    rmp11     LIKE rmp_file.rmp11,
                    rmp10     LIKE rmp_file.rmp10,
                    rmp13     LIKE rmp_file.rmp13,
                    rmp14     LIKE rmp_file.rmp14,
                    rmp12     LIKE rmp_file.rmp12,
                    rmp15     LIKE rmp_file.rmp15,
                    #FUN-840068 --start---
                    rmpud01   LIKE rmp_file.rmpud01,
                    rmpud02   LIKE rmp_file.rmpud02,
                    rmpud03   LIKE rmp_file.rmpud03,
                    rmpud04   LIKE rmp_file.rmpud04,
                    rmpud05   LIKE rmp_file.rmpud05,
                    rmpud06   LIKE rmp_file.rmpud06,
                    rmpud07   LIKE rmp_file.rmpud07,
                    rmpud08   LIKE rmp_file.rmpud08,
                    rmpud09   LIKE rmp_file.rmpud09,
                    rmpud10   LIKE rmp_file.rmpud10,
                    rmpud11   LIKE rmp_file.rmpud11,
                    rmpud12   LIKE rmp_file.rmpud12,
                    rmpud13   LIKE rmp_file.rmpud13,
                    rmpud14   LIKE rmp_file.rmpud14,
                    rmpud15   LIKE rmp_file.rmpud15
                    #FUN-840068 --end--
                    END RECORD,
     g_wc,g_wc2,g_sql,g_wc3,w_sql   string,  #No.FUN-580092 HCN
    g_t             LIKE type_file.chr5,    #No.FUN-690010 VARCHAR(5),
    p_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
    g_auto          LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
    g_err           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
    g_cnt1          LIKE type_file.num5,    #No.FUN-690010 SMALLINT,
    g_t1            LIKE oay_file.oayslip,                     #No.FUN-550064  #No.FUN-690010 VARCHAR(05)
   #g_cmd           LIKE type_file.chr1000, #No.FUN-690010 VARCHAR(50)
    g_cmd           LIKE type_file.chr1000,            #No.TQC-610087 modify  #No.FUN-690010 VARCHAR(200)
    g_rec_b         LIKE type_file.num5,                #單身筆數  #No.FUN-690010 SMALLINT
    g_tmp           LIKE type_file.num5,    #No.FUN-690010 SMALLINT,              #目前處理的SCREEN LINE
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-690010 SMALLINT
    g_count         LIKE type_file.num5,    #No.FUN-690010 SMALLINT,
    l_rmp09         LIKE rmp_file.rmp09,    #No.FUN-690010 VARCHAR(1),               #預設新修復狀態
    l_exit_sw       LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),               #Esc結束INPUT ARRAY 否
    l_cn            LIKE type_file.num5,    #No.FUN-690010 SMALLINT,              #符合單身條件筆數
    g_no            LIKE type_file.num5     #No.FUN-690010 SMALLINT
 
DEFINE g_forupd_sql      STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690010 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   g_jump          LIKE type_file.num10   #No.FUN-690010 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690010 SMALLINT
DEFINE g_argv1	LIKE rme_file.rme01 #No.FUN-690010 VARCHAR(16)            #No.FUN-4A0081
DEFINE g_argv2  STRING              #No.FUN-4A0081
DEFINE g_str,l_table     STRING,     #No.FUN-860018 add FOR CR                                                                       
       tm RECORD                    #No.FUN-860018 add FOR CR                                                                       
         wc              STRING                                                                                                      
          END RECORD   
DEFINE   g_void          LIKE type_file.chr1  #CHI-C80041

MAIN
    DEFINE p_row,p_col   LIKE type_file.num5    #No.FUN-690010 SMALLINT
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ARM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
    #No.FUN-860018 add---start                                                                                                      
    ## *** 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##                                                         
    LET g_sql = "rme01.rme_file.rme01,",                                                                                            
                "rme011.rme_file.rme011,",                                                                                          
                "rme02.rme_file.rme02,",                                                                                            
                "rme03.rme_file.rme03,",                                                                                            
                "rme04.rme_file.rme04,",                                                                                            
                "rme21.rme_file.rme21,",                                                                                            
                "rmp06.rmp_file.rmp06,",                                                                                            
                "rmp03.rmp_file.rmp03,",                                                                                            
                "rmp07.rmp_file.rmp07,",                                                                                            
                "rmp08.rmp_file.rmp08,",                                                                                            
                "rmp10.rmp_file.rmp10,",                                                                                            
                "rmp11.rmp_file.rmp11,",                                                                                            
                "rmp12.rmp_file.rmp12,",                                                                                            
                "rmp13.rmp_file.rmp13,",                                                                                            
                "rmp14.rmp_file.rmp14,",                                                                                            
                "rmp15.rmp_file.rmp15,",                                                                                            
                "rmp02.rmp_file.rmp02"                                                                                              
                                         #17 items  
    LET l_table = cl_prt_temptable('armt160',g_sql) CLIPPED   # 產生Temp Table                                                      
    IF l_table = -1 THEN EXIT PROGRAM END IF                  # Temp Table產生                                                      
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                           
                " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,? )"                                                                    
    PREPARE insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep:',status,1)                                                                                         
       EXIT PROGRAM                                                                                                                 
    END IF                                                                                                                          
    #------------------------------ CR (1) ------------------------------#                                                          
    #No.FUN-860018 add---end  
 
    LET p_row = 4 LET p_col = 4
    OPEN WINDOW t160_w AT p_row,p_col WITH FORM "arm/42f/armt160"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
 
   LET g_argv1=ARG_VAL(1)           #No.FUN-4A0081
   LET g_argv2=ARG_VAL(2)           #No.FUN-4A0081
   LET g_wc='1=1'                   #MOD-B50116 add
   LET g_wc2='1=1'                  #MOD-B50116 add

    DECLARE t160_rmp_cs CURSOR FOR
      SELECT * FROM rmp_file
      WHERE rmp00='1' AND rmp01=g_rme.rme01 AND rmp06 > 0
 
    LET g_forupd_sql =
        "SELECT * FROM rme_file WHERE rme01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t160_cl CURSOR FROM g_forupd_sql
    #No.FUN-4A0081 --start--
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t160_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t160_a()
             END IF
          OTHERWISE 
                CALL t160_q()
       END CASE
    END IF
    #No.FUN-4A0081 ---end---
    CALL t160_menu()
    CLOSE WINDOW t160_w                 #結束畫面
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0085
END MAIN
 
FUNCTION t160_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    IF cl_null(g_argv1) THEN   #FUN-4A0081
    CALL g_rmp.clear()
      CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_rme.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        rme01,rme011,rme03,rme04,rme02,rme021,rme21,rmegen,rmepack,
#       rmeprin,rmepost,rmevoid   #TQC-790051
        rmeprin,rmepost,rmeuser,rmemodu,rmevoid,rmegrup,rmedate,   #TQC-790051
        #FUN-840068   ---start---
        rmeud01,rmeud02,rmeud03,rmeud04,rmeud05,
        rmeud06,rmeud07,rmeud08,rmeud09,rmeud10,
        rmeud11,rmeud12,rmeud13,rmeud14,rmeud15
        #FUN-840068    ----end----
          #--No.MOD-4A0248--------
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
         ON ACTION CONTROLP
           CASE WHEN INFIELD(rme011)      #RMA單號
                     CALL cl_init_qry_var()
                     LET g_qryparam.state= "c"
                     LET g_qryparam.form = "q_rma"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rme011
                     NEXT FIELD rme011
                 WHEN INFIELD(rme03)      #客戶編號
                     CALL cl_init_qry_var()
                     LET g_qryparam.state= "c"
                     LET g_qryparam.form = "q_occ"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rme03
                     NEXT FIELD rme03
                 WHEN INFIELD(rme01)      #RMA覆出單號
                     CALL cl_init_qry_var()
                     LET g_qryparam.state= "c"
                     LET g_qryparam.form = "q_rme"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO rme01
                     NEXT FIELD rme01
           OTHERWISE EXIT CASE
           END CASE
         #--END---------------
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
 
    CONSTRUCT g_wc2 ON rmp02,rmp06,rmp03,rmp07,rmp08,rmp11,rmp10,
                       rmp13,rmp14,rmp12,rmp15
                       #No.FUN-840068 --start--
                       ,rmpud01,rmpud02,rmpud03,rmpud04,rmpud05
                       ,rmpud06,rmpud07,rmpud08,rmpud09,rmpud10
                       ,rmpud11,rmpud12,rmpud13,rmpud14,rmpud15
                       #No.FUN-840068 ---end---
         FROM s_rmp[1].rmp02,s_rmp[1].rmp06, s_rmp[1].rmp03, s_rmp[1].rmp07,
              s_rmp[1].rmp08, s_rmp[1].rmp11, s_rmp[1].rmp10,
              s_rmp[1].rmp13, s_rmp[1].rmp14,s_rmp[1].rmp12,
              s_rmp[1].rmp15
              #No.FUN-840068 --start--
              ,s_rmp[1].rmpud01,s_rmp[1].rmpud02,s_rmp[1].rmpud03
              ,s_rmp[1].rmpud04,s_rmp[1].rmpud05,s_rmp[1].rmpud06
              ,s_rmp[1].rmpud07,s_rmp[1].rmpud08,s_rmp[1].rmpud09
              ,s_rmp[1].rmpud10,s_rmp[1].rmpud11,s_rmp[1].rmpud12
              ,s_rmp[1].rmpud13,s_rmp[1].rmpud14,s_rmp[1].rmpud15
              #No.FUN-840068 ---end---
		#No.FUN-580031 --start--     HCN
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
 
 
		#No.FUN-580031 --start--     HCN
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
  #FUN-4A0081
  ELSE
      LET g_wc =" rme01 = '",g_argv1,"'"    #No.FUN-4A0081
      LET g_wc2=" 1=1"
  END IF
  #--
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc CLIPPED," AND rmeuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc CLIPPED," AND rmegrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc CLIPPED," AND rmegrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rmeuser', 'rmegrup')
    #End:FUN-980030
 
    IF g_wc2 = " 1=1" THEN                        # 若單身未輸入條件
       LET g_sql = "SELECT rme01 FROM rme_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY rme01"
     ELSE                                         # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE rme01 ",
                   "  FROM rme_file, rmp_file",
                   " WHERE rme01 = rmp01 AND rmp00='1' ",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY rme01"
    END IF
    PREPARE t160_prepare FROM g_sql
    DECLARE t160_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t160_prepare
 
    IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM rme_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT rme01) FROM rme_file,rmp_file WHERE ",
                  "rmp01=rme01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t160_precount FROM g_sql
    DECLARE t160_count CURSOR FOR t160_precount
END FUNCTION
 
FUNCTION t160_menu()
   DEFINE   l_occ57   LIKE occ_file.occ57
   DEFINE  l_rmeprin  LIKE rme_file.rmeprin
   DEFINE  l_wc       LIKE type_file.chr1000           #No.TQC-610087 add  #No.FUN-690010 VARCHAR(200)
 
   WHILE TRUE
 
      CALL t160_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t160_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t160_q()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t160_u('u')
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t160_x()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t160_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t160_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "confirm" #"確認"
            CALL t160_y()
 
         WHEN "undo_confirm"   #"取消確認"
            CALL t160_z('')
         WHEN "memo"
            CALL t160_u('m')
 
         WHEN "deduct"   #"扣帳"
            IF cl_chk_act_auth() THEN
               CALL t160_s('Y')
            END IF
 
         WHEN "undo_deduct"   # "扣帳還原"
            IF cl_chk_act_auth() THEN
               CALL t160_s('N')
            END IF
 
         WHEN "maintain_packing" #"維護PACKING 資料"
            IF cl_chk_act_auth() AND NOT cl_null(g_rme.rme01) THEN
               SELECT occ57 INTO l_occ57 FROM occ_file
               WHERE occ01=g_rme.rme03
               IF l_occ57='Y' THEN        #NO:7260
                  LET g_cmd = "armt240 '",g_rme.rme01,"'"
                  CALL  cl_cmdrun_wait(g_cmd CLIPPED)
               ELSE
                   #此客戶,不須製作包裝單!                 #MOD-530716
                   CALL cl_err(g_rme.rme03,'arm-160',1)    #MOD-530716
               END IF
            END IF
            SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
            DISPLAY BY NAME g_rme.rmepack
 
         WHEN "prt_release_order"   #"放行單列印"
            LET l_wc = NULL         #No.TQC-610087 add
            IF g_sma.sma79 THEN
               IF cl_chk_act_auth() AND NOT cl_null(g_rme.rme01) THEN
            #---------------No.TQC-610087 modify--------------
               LET l_wc = "rme01='",g_rme.rme01 CLIPPED,"'"
              #LET g_cmd = "armr160 '",g_rme.rme01,"' 1 "
              #LET g_cmd = "armr160 '",g_today,"' '",g_user,"' '",g_lang,"' ",  #FUN-C30085
               LET g_cmd = "armg160 '",g_today,"' '",g_user,"' '",g_lang,"' ",  #FUN-C30085
                           " 'Y' ' ' '1' ",'\" ',l_wc CLIPPED,' \" '
            #---------------No.TQC-610087 end------------------
                  CALL  cl_cmdrun_wait(g_cmd CLIPPED)
               END IF
            END IF
            SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
            DISPLAY BY NAME g_rme.rmeprin
 
 
         WHEN "print_sticker" #"黏貼單列印"
            IF cl_chk_act_auth() AND NOT cl_null(g_rme.rme01) THEN
            #---------------No.TQC-610087 modify--------------
               LET l_wc = "rme01='",g_rme.rme01 CLIPPED,"'"
              #LET g_cmd = "armr170 '",g_rme.rme01,"' 1 "
              #LET g_cmd = "armr170 '",g_today,"' '",g_user,"' '",g_lang,"' ",  #FUN-C30085
               LET g_cmd = "armg170 '",g_today,"' '",g_user,"' '",g_lang,"' ",  #FUN-C30085
                           " 'Y' ' ' '1' ",'\" ',l_wc CLIPPED,' \" '
            #---------------No.TQC-610087 end------------------
               CALL  cl_cmdrun(g_cmd CLIPPED)
            END IF
 
         WHEN "print_rd_summary"   #"覆出單彙總列印"
            IF cl_chk_act_auth() AND NOT cl_null(g_rme.rme01) THEN
            #---------------No.TQC-610087 modify--------------
               LET l_wc = "rme01='",g_rme.rme01 CLIPPED,"'"
              #LET g_cmd = "armr141 '",g_rme.rme01,"'"
              #LET g_cmd = "armr141 '",g_today,"' '",g_user,"' '",g_lang,"' ",  #FUN-C30085
               LET g_cmd = "armg141 '",g_today,"' '",g_user,"' '",g_lang,"' ",  #FUN-C30085
                           " 'Y' ' ' '1' ",'\" ',l_wc CLIPPED,' \" '
            #---------------No.TQC-610087 end------------------
               CALL  cl_cmdrun(g_cmd CLIPPED)
            END IF
         WHEN "exporttoexcel"     #FUN-4B0035
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rmp),'','')
            END IF
 
         #No.FUN-6A0018-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_rme.rme01 IS NOT NULL THEN
                    LET g_doc.column1 = "rme01"
                    LET g_doc.value1 = g_rme.rme01
                    CALL cl_doc()
                 END IF
              END IF
         #No.FUN-6A0018-------add--------end----
 
         #CHI-6B0071---add---str---
         #@WHEN "刪除"
         WHEN "delete"
              IF cl_chk_act_auth() THEN
                 CALL t160_r()
              END IF
         #CHI-6B0071---add---end---
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t160_v()     #CHI-D20010
               CALL t160_v(1)    #CHI-D20010
               IF g_rme.rmegen='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_rme.rmegen ,"",g_rme.rmepost,"",g_void,g_rme.rmevoid)   
            END IF
         #CHI-C80041---end 
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t160_v(2)
               IF g_rme.rmegen='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_rme.rmegen ,"",g_rme.rmepost,"",g_void,g_rme.rmevoid)
            END IF
         #CHI-D20010---end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t160_a()
    DEFINE li_result   LIKE type_file.num5          #No.FUN-550064  #No.FUN-690010 SMALLINT
    DEFINE    g_i      LIKE type_file.num10         #No.FUN-690010 INTEGER
 
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_rmp.clear()
    INITIALIZE g_rme.* TO NULL
   #LET g_wc = NULL     #MOD-B50116 mark
   #LET g_wc2= NULL     #MOD-B50116 mark
    LET g_rme_o.* = g_rme.*
    LET g_rme01_t = NULL
    CALL cl_opmsg('a')
    SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=g_rmz.rmz06
    WHILE TRUE
        INITIALIZE g_rme.* TO NULL
        LET g_auto="N"
        LET g_success = 'Y'
        LET g_rme.rme01 = g_rmz.rmz06
        LET g_rme.rme02  =g_today
        LET g_rme.rme021 =g_today
        LET g_rme.rme18=0 LET g_rme.rme181=0 LET g_rme.rme182=0
        LET g_rme.rme19=0 LET g_rme.rme191=0 LET g_rme.rme192=0
       #LET g_rme.rme30=1.20     #MOD-950152 mark
        LET g_rme.rme30=g_rmz.rmz21   #MOD-950152
        LET g_rme.rme28='N'
        LET g_rme.rme31='N'
        LET g_rme.rme32='N'
        LET g_rme.rmeconf='N'
        LET g_rme.rmegen ='N'
        LET g_rme.rmepost='N'
        LET g_rme.rmeprin='N'
        LET g_rme.rmepack='N'
        LET g_rme.rmevoid="Y"
        LET g_rme.rmeuser=g_user
        LET g_rme.rmeoriu = g_user #FUN-980030
        LET g_rme.rmeorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_rme.rmegrup=g_grup
        LET g_rme.rmedate=g_today
        LET p_cmd="a"
        BEGIN WORK
        CALL t160_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9044,0)
           EXIT WHILE
        END IF
        IF cl_null(g_rme.rme01) THEN CONTINUE WHILE END IF
        BEGIN WORK  #No:7876
      #No.FUN-550064 --start--
        CALL s_auto_assign_no("arm",g_rme.rme01,g_today,"71","rme_file","rme01","","","")    #No.FUN-560014
        RETURNING li_result,g_rme.rme01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_rme.rme01
#       IF g_oay.oayauno='Y' THEN
#           CALL s_armauno(g_rme.rme01,g_today) RETURNING g_i,g_rme.rme01
#           IF g_i THEN CONTINUE WHILE END IF       #有問題
#           DISPLAY BY NAME g_rme.rme01
#       END IF
       #No.FUN-550064 ---end---
        LET g_rme.rmeplant = g_plant #FUN-980007
        LET g_rme.rmelegal = g_legal #FUN-980007
        INSERT INTO rme_file VALUES (g_rme.*)
        IF STATUS THEN
           LET  g_success = 'N'
    #       CALL cl_err(g_rme.rme01,STATUS,1)# FUN-660111 
           CALL cl_err3("ins","rme_file",g_rme.rme01,"",STATUS,"","",1) #FUN-660111
           ROLLBACK WORK  #No:7876
           EXIT  WHILE
        ELSE
           COMMIT WORK    #No:7876
           CALL cl_flow_notify(g_rme.rme01,'I')
        END IF
 
        CALL g_rmp.clear()
        LET g_rec_b=0                   #MOD-840369 mod 
       #由 RMA單(rmp)依單頭所輸入: rme011(rmp01) 產生單身:rmp
        IF  cl_confirm('aap-701') THEN
            CALL t160_g_b()
            IF g_rec_b=0 OR g_success="N" THEN ROLLBACK WORK EXIT WHILE END IF
            LET g_auto='Y'
        END IF
        LET g_rme_t.* = g_rme.*
        SELECT rme01 INTO g_rme.rme01 FROM rme_file
               WHERE rme01=g_rme_t.rme01
        #LET g_rec_b=0                  #MOD-840369 mark  #No.FUN-680064
        CALL t160_b()                   #單身的conf
        IF INT_FLAG THEN
           LET INT_FLAG=0
          #CALL t160_show()
           ROLLBACK WORK
           EXIT WHILE
        END IF
        IF g_success="N" OR g_rec_b = 0 THEN
           ROLLBACK WORK
          #CALL cl_err('',9052,0)
        ELSE
            COMMIT WORK
           #CALL cl_msgany(0,0,'新增OK!')
        END IF
       #CALL t160_show()
        EXIT WHILE
    END WHILE
END FUNCTION
 
#由RMA單(rmp)依單頭所輸入的:rme011產生符合的單身(rmc01=rme011 and
#     rmc23 is null and rmc14 matches "12" )
FUNCTION t160_g_b()
       DEFINE  g_n  LIKE type_file.num5    #No.FUN-690010 smallint
 
       LET g_sql =" SELECT '1','','','','','',rmc01,rmc02, ",
                  " rmc31-rmc311-rmc312-rmc313,0,'',rmc14,rmc04, ",
                  " rmc05,rmc06,rmc061,rmc07 ",
                  " FROM rmc_file ",
                  " WHERE rmc01='",g_rme.rme011,"' AND rmc23 IS NULL",
                  "   AND rmc14 IN ('1','2','5','6') ",   #MOD-A30035 rmc14 add 56
                  " ORDER BY rmc02 "
 
    PREPARE t160_rmppb FROM g_sql
    IF SQLCA.SQLCODE != 0 THEN
       CALL cl_err('pre1:',SQLCA.sqlcode,0)
       LET g_success="N"
       RETURN
    END IF
    DECLARE rmc_curs                       #SCROLL CURSOR
        CURSOR FOR t160_rmppb
 
    LET g_cnt = 1
    LET g_rec_b = 0
    FOREACH rmc_curs INTO l_rmp.*          #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH
        ELSE
           LET g_n=0
           SELECT COUNT(*) INTO g_n FROM rme_file,rmp_file
               WHERE rmp01 <> g_rme.rme01
                 AND rmp00='1' AND rmp05=l_rmp.rmp05
                 AND rmp06=l_rmp.rmp06 AND rmp01=rme01 AND rmevoid='Y'
                 AND rmegen <> 'X'  #CHI-C80041
           IF g_n >= 1 THEN CONTINUE FOREACH END IF   
           IF l_rmp.rmp07 IS NULL THEN LET l_rmp.rmp07=0 END IF
           #NO.TQC-790003 start--
           IF cl_null(l_rmp.rmp01) THEN LET l_rmp.rmp01 = ' ' END IF
           IF cl_null(l_rmp.rmp011) THEN LET l_rmp.rmp011 = 0 END IF
           IF cl_null(l_rmp.rmp02) THEN LET l_rmp.rmp02 = 0 END IF
           #no.TQC-790003 end----
 
           INSERT INTO rmp_file(rmp00,rmp01,rmp011,rmp02,rmp03,rmp04,rmp05,
                                rmp06,rmp07,rmp08,rmp09,rmp10,rmp11,rmp12,
                                 rmp13,rmp14,rmp15,rmp909,  #No.MOD-470041
                                rmpplant,rmplegal)     #FUN-980007
          #MOD-7A0145-modify
          #VALUES ('1',g_rme.rme01,'',g_cnt,'','',l_rmp.rmp05,l_rmp.rmp06,
           VALUES ('1',g_rme.rme01,l_rmp.rmp011,g_cnt,'','',l_rmp.rmp05,l_rmp.rmp06,
          #MOD-7A0145-modify-end
                   l_rmp.rmp07,0,'',l_rmp.rmp10,l_rmp.rmp11,l_rmp.rmp12,
                   l_rmp.rmp13,l_rmp.rmp14,l_rmp.rmp15,'',
                   g_plant,g_legal)                    #FUN-980007
           IF STATUS THEN
             #CALL cl_err('ins rmp',STATUS,0)# FUN-660111 
              CALL cl_err3("ins","rmp_file",g_rme.rme01,g_cnt,STATUS,"","ins rmp",1) #FUN-660111
              LET g_success="N"
              EXIT FOREACH
           END IF
           LET g_rec_b = g_rec_b + 1
           LET g_cnt = g_cnt + 1
        END IF
    END FOREACH
    IF g_rec_b =0 OR g_success="N" THEN
       CALL cl_err('',9052,0)
       LET g_success="N"
       RETURN
    ELSE
       COMMIT WORK
    END IF
    CALL t160_b_fill(" 1=1")
END FUNCTION
 
#處理INPUT
FUNCTION t160_i(r_cmd)
  DEFINE li_result   LIKE type_file.num5         #No.FUN-550064  #No.FUN-690010 SMALLINT
  DEFINE r_cmd           LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),              #a:輸入 u:更改
         l_n             LIKE type_file.num5,    #No.FUN-690010 SMALLINT
         g_t             LIKE type_file.chr5     #No.FUN-690010 VARCHAR(5)
 
    DISPLAY BY NAME g_rme.rme01,g_rme.rme011,g_rme.rme03, g_rme.rme04,
                    g_rme.rme02,g_rme.rme021,g_rme.rme21,g_rme.rmegen,
                    g_rme.rmepack,g_rme.rmeprin, g_rme.rmepost,g_rme.rmevoid,
                    g_rme.rmeuser,g_rme.rmegrup,g_rme.rmemodu,g_rme.rmedate  #bugno:7487
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME   g_rme.rme01,g_rme.rme011,g_rme.rme03, g_rme.rmeoriu,g_rme.rmeorig,
                    g_rme.rme02,g_rme.rme021,g_rme.rme21,
                    #FUN-840068     ---start---
                    g_rme.rmeud01,g_rme.rmeud02,g_rme.rmeud03,g_rme.rmeud04,
                    g_rme.rmeud05,g_rme.rmeud06,g_rme.rmeud07,g_rme.rmeud08,
                    g_rme.rmeud09,g_rme.rmeud10,g_rme.rmeud11,g_rme.rmeud12,
                    g_rme.rmeud13,g_rme.rmeud14,g_rme.rmeud15 
                    #FUN-840068     ----end----
                   WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t160_set_entry(r_cmd)
           CALL t160_set_no_entry(r_cmd)
           LET g_before_input_done = TRUE
 
         #No.FUN-550064 --start--
         CALL cl_set_docno_format("rme01")
         CALL cl_set_docno_format("rme011")
         #No.FUN-550064 ---end---
 
        AFTER FIELD rme01
           IF NOT cl_null(g_rme.rme01) THEN
      #No.FUN-550064 --start--
#No.FUN-560014 --start-
            #IF p_cmd='a' THEN          #No.TQC-6C0213  #FUN-B50026 mark
               #CALL s_check_no("axm",g_rme.rme01,"","71","rme_file","rme01","")  #MOD-A30035 mark
               #CALL s_check_no("arm",g_rme.rme01,"","71","rme_file","rme01","")  #MOD-A30035
                CALL s_check_no("arm",g_rme.rme01,g_rme01_t,"71","rme_file","rme01","")  #MOD-A30035  #FUN-B50026 mod
                   RETURNING li_result,g_rme.rme01
#                  LET g_rme.rme01 = s_get_doc_no(g_rme.rme01)
                DISPLAY BY NAME g_rme.rme01
                IF (NOT li_result) THEN
                  LET g_rme.rme01=g_rme_o.rme01
                  NEXT FIELD rme01
                END IF
#                  LET g_t=g_rme.rme01[1,3]
#                  CALL s_axmslip(g_t,'71',g_sys)           #檢查覆出單單別:71
#                  IF NOT cl_null(g_errno) THEN               #抱歉, 有問題
#                        CALL cl_err(g_t,g_errno,0)
#                        NEXT FIELD rme01
#                  END IF
#                 IF cl_null(g_rme.rme01[5,10]) AND NOT cl_null(g_rme.rme01[1,3]) THEN
#                 IF cl_null(g_rme.rme01[g_no_sp,g_no_ep]) AND NOT cl_null(g_rme.rme01[1,g_doc_len]) THEN
#                     IF g_oay.oayauno = 'N' THEN
#                        CALL cl_err('','aap-011',0)  #此單別無自動編號,需人工
#                        NEXT FIELD rme01
#                     ELSE
#                        NEXT FIELD rme011
#                     END IF
#                 END IF
#                   IF g_rme.rme01 != g_rme01_t OR g_rme_t.rme01 IS NULL THEN
#                      IF g_oay.oayauno = 'Y' AND NOT cl_chk_data_continue(g_rme.rme01[5,10]) THEN
#                      IF g_oay.oayauno = 'Y' AND NOT cl_chk_data_continue(g_rme.rme01[5,10]) THEN
#                         CALL cl_err('','9056',0) NEXT FIELD rme01
#                      END IF
#                     {SELECT count(*) INTO g_cnt FROM rme_file
#                          WHERE rme01 = g_rme.rme01
#                      IF g_cnt > 0 THEN   #資料重複
#                          CALL cl_err(g_rme.rme01,-239,0)
#                          LET g_rme.rme01 = g_rme_t.rme01
#                          DISPLAY BY NAME g_rme.rme01
#                          NEXT FIELD rme01
#                      END IF}
#                  END IF
                  LET g_rme_o.rme01 = g_rme.rme01
#                 END IF
#No.FUN-560014 ---end--
        #No.FUN-550064 ---end---
             #END IF          #No.TQC-6C0213   #FUN-B50026 mark
            END IF
 
        AFTER FIELD rme011
           IF NOT cl_null(g_rme.rme011) THEN
              #No.FUN-550064 --start--
              IF g_rme.rme011 != g_rme_o.rme011 OR g_rme_o.rme011 IS NULL THEN
#                LET g_t = g_rme.rme011[1,g_doc_len]                 #No.FUN-560014
                #CALL s_check_no("axm",g_rme.rme011,"","70","","","")   #MOD-A30047 mark
                #Mark MOD-B40218
                #CALL s_check_no("arm",g_rme.rme011,"","70","","","")   #MOD-A30047
                #   RETURNING li_result,g_rme.rme011
                #DISPLAY BY NAME g_rme.rme011
                #IF (NOT li_result) THEN
                #   LET g_rme.rme011=g_rme_o.rme011   #MOD-A30047 mod
                #   NEXT FIELD rme011
                #END IF
                #End Mark MOD-B40218
                #str MOD-A30047 add
                #若單身已有資料,則提示訊息且不允許修改rem011
                 LET l_n = 0
                 SELECT COUNT(*) INTO l_n FROM rmp_file
                  WHERE rmp01=g_rme.rme01
                 IF cl_null(l_n) THEN LET l_n = 0 END IF
                 IF l_n > 0 THEN
                    CALL cl_err(g_rme_o.rme011,'arm-161',0)
                    LET g_rme.rme011=g_rme_o.rme011
                    NEXT FIELD rme011
                 END IF
                #end MOD-A30047 add
 
#                LET g_t=g_rme.rme011[1,3]
#                CALL s_axmslip(g_t,'70',g_sys)           #檢查RMA單別:70
#                IF NOT cl_null(g_errno) THEN               #抱歉, 有問題
#                   CALL cl_err(g_t,g_errno,0)
#                   NEXT FIELD rme011
#                   END IF
#                END IF
                 #No.FUN-550064 ---end---
                 #檢查rmc_file(rma_file:非取消,非無效且單據性質為'70'的RMA單號)中,
                 #找覆出單上的RMA單號,且rmc23(參考單號)為空白,
                 #且rmc14='1' or '2' (修復碼為1:修復 2:不修) 者
                 #NO.TQC-5A0110 START------
                 LET g_t = s_get_doc_no(g_rme.rme011)
                 #NO.TQC-5A0110 END---------
                 SELECT COUNT(*) INTO l_n FROM rma_file,rmc_file,oay_file
                  WHERE rmc01=g_rme.rme011 AND rmc23 IS NULL
                    AND rmc14 IN ('1','2','5','6') AND rma01=rmc01   #MOD-A30035 rmc14 add 56
                    AND rma09!='6' AND rmavoid='Y'
                    AND g_t=oayslip AND oaytype='70'
                 IF l_n=0 THEN  #表無符合以上條件的RMA單號
                    #CALL cl_err(g_rme.rme011,9064,0)
                    CALL cl_err(g_rme.rme011,'mfg3122',0)
                    NEXT FIELD rme011
                 END IF
                 SELECT rma03,rma04 INTO g_rme.rme03,g_rme.rme04
                   FROM rma_file
                  WHERE rma01=g_rme.rme011
                 DISPLAY BY NAME g_rme.rme03,g_rme.rme04
                 CALL t160_get_rme03()
                 DISPLAY BY NAME g_rme.rme04
              END IF
              LET g_rme_o.rme011=g_rme.rme011
              LET g_rme_o.rme03 = g_rme.rme03
           END IF
 
        AFTER FIELD rme03
            IF NOT cl_null(g_rme.rme03) THEN
                IF g_rme.rme03 != g_rme_o.rme03 OR g_rme_o.rme03 IS NULL THEN
                 SELECT occ02 INTO g_rme.rme04 FROM occ_file
                     WHERE occ01=g_rme.rme03 AND occacti='Y'
                 IF SQLCA.sqlcode THEN
#                    CALL cl_err(g_rme.rme03,SQLCA.sqlcode,0)# FUN-660111 
                    CALL cl_err3("sel","occ_file",g_rme.rme03,"",SQLCA.sqlcode,"","",1) #FUN-660111
                    LET g_rme.rme03 = g_rme_t.rme03
                    LET g_rme.rme04 = g_rme_t.rme04
                    DISPLAY BY NAME g_rme.rme03,g_rme.rme04
                    NEXT FIELD rme03
                 END IF
                 CALL t160_get_rme03()
                 DISPLAY BY NAME g_rme.rme04
                END IF
                LET g_rme_o.rme03 = g_rme.rme03
            END IF
 
        #FUN-840068     ---start---
        AFTER FIELD rmeud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD rmeud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840068     ----end----
 
        ON ACTION CONTROLP
          CASE WHEN INFIELD(rme01)             #查詢覆出單單別
#                LET g_t=g_rme.rme01[1,3]
                 LET g_t = s_get_doc_no(g_rme.rme01)     #No.FUN-550064
 
#                CALL q_oay(0,0,g_t,'71',g_sys) RETURNING g_t
                #CALL q_oay(FALSE,FALSE,g_t,'71',g_sys) RETURNING g_t  #TQC-670008
                 CALL q_oay(FALSE,FALSE,g_t,'71','ARM') RETURNING g_t  #TQC-670008
#                 CALL FGL_DIALOG_SETBUFFER( g_t )
#                     LET g_rme.rme01[1,3]=g_t
                      LET g_rme.rme01 = g_t                 #No.FUN-550064
                      DISPLAY BY NAME g_rme.rme01
                      NEXT FIELD rme01
               WHEN INFIELD(rme011)             #查詢RMA單据
#                CALL q_rma(0,0,'70') RETURNING g_rme.rme011
#                CALL FGL_DIALOG_SETBUFFER( g_rme.rme011 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_rma"
                 LET g_qryparam.arg1 = '70'
                 LET g_qryparam.arg2 = g_doc_len   #No:No.TQC-630145 add
                 CALL cl_create_qry() RETURNING g_rme.rme011
                 DISPLAY BY NAME g_rme.rme011
                 NEXT FIELD rme011
               WHEN INFIELD(rme03)             #查詢客戶資料
#                CALL q_occ(9,2,g_rme.rme03) RETURNING g_rme.rme03
#                CALL FGL_DIALOG_SETBUFFER( g_rme.rme03 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_occ"
                 LET g_qryparam.default1 = g_rme.rme03
                 CALL cl_create_qry() RETURNING g_rme.rme03
#                 CALL FGL_DIALOG_SETBUFFER( g_rme.rme03 )
                      DISPLAY BY NAME g_rme.rme03
                      NEXT FIELD rme03
            END CASE
 
        ON ACTION CONTROLF                     #欄位說明
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
 
FUNCTION t160_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      #CALL cl_set_comp_entry("rme01",TRUE)                                    #MOD-A90172 mark
       CALL cl_set_comp_entry("rme01,rme011,rme03,rme02,rme021",TRUE)          #MOD-A90172 add
    END IF
    IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
      #CALL cl_set_comp_entry("rme011,rme03,rme04,rme02,rme021",TRUE)   #MOD-A90172 mark
       CALL cl_set_comp_entry("rme011,rme03,,rme02,rme021",TRUE)        #MOD-A90172 add   畫面檔已經將rme04設為noentry了，所以程式不用設定
    END IF

    IF p_cmd = 'Y' AND ( NOT g_before_input_done ) THEN     #CHI-BC0016 add
       CALL cl_set_comp_entry("rme021",TRUE)                #CHI-BC0016 add
    END IF                                                  #CHI-BC0016 add
 
END FUNCTION
 
FUNCTION t160_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("rme01",FALSE)
    END IF
    IF p_cmd = 'm' THEN
      #CALL cl_set_comp_entry("rme01,rme011,rme03,rme04,rme02,rme021",FALSE)   #MOD-A90172 mark
       CALL cl_set_comp_entry("rme01,rme011,rme03,rme02,rme021",FALSE)         #MOD-A90172 add 畫面檔已經將rme04設為noentry了，所以程式不用設定
    END IF

    IF p_cmd = 'Y' AND ( NOT g_before_input_done )  THEN     #CHI-BC0016 add
       CALL cl_set_comp_entry("rme021",FALSE)                #CHI-BC0016 add
    END IF                                                   #CHI-BC0016 add
 
END FUNCTION
 
FUNCTION t160_u(r_cmd)
    DEFINE r_cmd  LIKE type_file.chr1    #No.FUN-690010 VARCHAR(01)
 
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
    IF g_rme.rme01 IS NULL THEN
       CALL cl_err('','arm-019',0) RETURN   
    END IF
    LET g_rme01_t = g_rme.rme01  #FUN-B50026 add
    IF r_cmd != 'm' THEN
    IF g_rme.rmevoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
     #MOD-4A0268
    IF g_rme.rmepost ='Y' THEN
       CALL cl_err('rmepost=Y:','axm-208',0)  RETURN
    END IF
    #--
    IF g_rme.rmegen  = 'Y' THEN  CALL cl_err('gen=Y',9023,0) RETURN END IF
    END IF
    MESSAGE ""
    IF r_cmd != 'm' THEN CALL cl_opmsg(r_cmd) END IF
    LET p_cmd="u"
    LET g_rme_o.* = g_rme.*
    BEGIN WORK
 
    OPEN t160_cl USING g_rme.rme01
    IF STATUS THEN
       CALL cl_err("OPEN t160_cl:", STATUS, 1)
       CLOSE t160_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t160_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t160_cl ROLLBACK WORK RETURN
    END IF
    CALL t160_show()
    WHILE TRUE
        IF r_cmd != 'm' THEN
           LET g_rme.rmemodu=g_user
           LET g_rme.rmedate=g_today
        END IF
        CALL t160_i(r_cmd)                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_rme.*=g_rme_t.*
            CALL t160_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE rme_file SET * = g_rme.* WHERE rme01 = g_rme.rme01
        IF STATUS THEN 
#        CALL cl_err(g_rme.rme01,STATUS,0)# FUN-660111 
        CALL cl_err3("upd","rme_file",g_rme_t.rme01,"",STATUS,"","",1) #FUN-660111
         CONTINUE WHILE END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t160_cl
    COMMIT WORK
    CALL cl_flow_notify(g_rme.rme01,'U')
    CALL t160_show()     #MOD-B50116 add
 
END FUNCTION
 
FUNCTION t160_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_rme.* TO NULL               #No.FUN-6A0018
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    LET p_cmd="u"
    CALL t160_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_rme.* TO NULL RETURN END IF
    MESSAGE " SEARCHING ! "
    OPEN t160_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_rme.* TO NULL
    ELSE
        OPEN t160_count
        FETCH t160_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t160_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
    LET g_auto="N"
END FUNCTION
 
FUNCTION t160_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-690010 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-690010 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t160_cs INTO g_rme.rme01
        WHEN 'P' FETCH PREVIOUS t160_cs INTO g_rme.rme01
        WHEN 'F' FETCH FIRST    t160_cs INTO g_rme.rme01
        WHEN 'L' FETCH LAST     t160_cs INTO g_rme.rme01
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
            FETCH ABSOLUTE g_jump t160_cs INTO g_rme.rme01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_rme.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
    IF SQLCA.sqlcode THEN
#        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)# FUN-660111 
        CALL cl_err3("sel","rme_file",g_rme.rme01,"",SQLCA.sqlcode,"","",1) #FUN-660111
        INITIALIZE g_rme.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_rme.rmeuser #FUN-4C0055
        LET g_data_group = g_rme.rmegrup #FUN-4C0055
        LET g_data_plant = g_rme.rmeplant #FUN-980030
    END IF
 
    CALL t160_show()
END FUNCTION
 
FUNCTION t160_show()
 
    LET g_rme_t.* = g_rme.*                #保存單頭舊值
    DISPLAY BY NAME g_rme.rmeoriu,g_rme.rmeorig,
 
        g_rme.rme01,g_rme.rme011,g_rme.rme03,g_rme.rme04,g_rme.rme021,
        g_rme.rme02,g_rme.rme21,g_rme.rmegen,g_rme.rmepack,g_rme.rmeprin,
        g_rme.rmepost,g_rme.rmevoid,
        g_rme.rmeuser,g_rme.rmegrup,g_rme.rmemodu,g_rme.rmedate,   #bugno:7487
        #FUN-840068     ---start---
        g_rme.rmeud01,g_rme.rmeud02,g_rme.rmeud03,g_rme.rmeud04,
        g_rme.rmeud05,g_rme.rmeud06,g_rme.rmeud07,g_rme.rmeud08,
        g_rme.rmeud09,g_rme.rmeud10,g_rme.rmeud11,g_rme.rmeud12,
        g_rme.rmeud13,g_rme.rmeud14,g_rme.rmeud15 
        #FUN-840068     ----end----
 
    #CKP
    #CALL cl_set_field_pic(g_rme.rmegen ,"",g_rme.rmepost,"","",g_rme.rmevoid) #CHI-C80041
    IF g_rme.rmegen='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
    CALL cl_set_field_pic(g_rme.rmegen ,"",g_rme.rmepost,"",g_void,g_rme.rmevoid) #CHI-C80041 
 
 
    CALL t160_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#CHI-6B0071---add---str---
FUNCTION t160_r()
 
IF s_shut(0) THEN
RETURN
END IF
 
IF g_rme.rme01 IS NULL THEN
CALL cl_err("",-400,0)
RETURN
END IF
 
SELECT * INTO g_rme.* FROM rme_file
WHERE rme01=g_rme.rme01
IF g_rme.rmegen ='Y' OR g_rme.rmepost ='Y' THEN           #檢查資料是否確認
CALL cl_err(g_rme.rme01,'9023',0)
RETURN
END IF
BEGIN WORK
 
OPEN t160_cl USING g_rme.rme01
IF STATUS THEN
CALL cl_err("OPEN t160_cl:", STATUS, 1)
CLOSE t160_cl
ROLLBACK WORK
RETURN
END IF
 
FETCH t160_cl INTO g_rme.*    # 鎖住將被更改或取消的資料
IF SQLCA.sqlcode THEN
CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)    #資料被他人LOCK
ROLLBACK WORK
RETURN
END IF
 
CALL t160_show()
 
IF cl_delh(0,0) THEN                   #確認一下
    INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
    LET g_doc.column1 = "rme01"         #No.FUN-9B0098 10/02/24
    LET g_doc.value1 = g_rme.rme01      #No.FUN-9B0098 10/02/24
    CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
   DELETE FROM rme_file WHERE rme01 = g_rme.rme01
   DELETE FROM rmp_file WHERE rmp01 = g_rme.rme01
   CLEAR FORM
   CALL g_rmp.clear()
   OPEN t160_count
   #FUN-B50064-add-start--
   IF STATUS THEN
      CLOSE t160_cs
      CLOSE t160_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50064-add-end-- 
   FETCH t160_count INTO g_row_count
   #FUN-B50064-add-start--
   IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
      CLOSE t160_cs
      CLOSE t160_count
      COMMIT WORK
      RETURN
   END IF
   #FUN-B50064-add-end--
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t160_cs
   IF g_curs_index = g_row_count + 1 THEN
      LET g_jump = g_row_count
      CALL t160_fetch('L')
   ELSE
      LET g_jump = g_curs_index
      LET mi_no_ask = TRUE
      CALL t160_fetch('/')
   END IF
END IF
 
CLOSE t160_cl
COMMIT WORK
CALL cl_flow_notify(g_rme.rme01,'D')
END FUNCTION
#CHI-6B0071---add---end---
 
 
FUNCTION t160_b()                          #單身
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690010 SMALLINT
    g_n             LIKE type_file.num5,    #No.FUN-690010 SMALLINT,
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_cnt           LIKE type_file.num5,                #檢查重複用  #No.FUN-690010 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690010 VARCHAR(1)
    l_ima01         LIKE ima_file.ima01,   #料件編號
    g_tmp           LIKE rmc_file.rmc01,   #料件編號
    l_ima25         LIKE ima_file.ima25,   #料件編號: 單位
    l_gfe01         LIKE gfe_file.gfe01,   #料件編號: 單位
    g_rmp07,g_rmp311,l_total,l_i  LIKE type_file.num5,    #No.FUN-690010 SMALLINT
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690010 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否  #No.FUN-690010 SMALLINT
    li_flag    LIKE type_file.num5         #MOD-920045
 
    LET g_action_choice = ""
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
    IF g_rme.rme01 IS NULL THEN
       CALL cl_err('','aap-105',0) RETURN END IF
    IF g_rme.rmevoid = 'N' THEN CALL cl_err('void=N',9027,0) RETURN END IF
     #MOD-4A0268
    IF g_rme.rmepost ='Y' THEN
       CALL cl_err('rmepost=Y:','axm-208',0)  RETURN
    END IF
    #--
    IF g_rme.rmegen  = 'Y' THEN CALL cl_err('gen=Y',9003,0) RETURN END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      " SELECT rmp02,rmp06,rmp03,rmp07,rmp08,rmp11,rmp10,rmp13,rmp14, ",
      "        rmp12,rmp15, ",
      #No.FUN-840068 --start--
      "        rmpud01,rmpud02,rmpud03,rmpud04,rmpud05,",
      "        rmpud06,rmpud07,rmpud08,rmpud09,rmpud10,",
      "        rmpud11,rmpud12,rmpud13,rmpud14,rmpud15 ", 
      #No.FUN-840068 ---end---
      " FROM rmp_file ",
      "  WHERE rmp01= ? ",
      "   AND rmp02= ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t160_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
    WHILE TRUE   #MOD-920045
        INPUT ARRAY g_rmp
              WITHOUT DEFAULTS
              FROM s_rmp.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete)
 
 
        BEFORE INPUT
            #CKP
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            #CKP
            LET p_cmd = ''
            LET l_total=ARR_COUNT()
            LET l_ac = ARR_CURR()
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t160_cl USING g_rme.rme01
            IF STATUS THEN
               CALL cl_err("OPEN t160_cl:", STATUS, 1)
               CLOSE t160_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t160_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                CLOSE t160_cl ROLLBACK WORK RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_rmp_t.* = g_rmp[l_ac].*  #BACKUP
               LET g_rmp_o.* = g_rmp[l_ac].*  #BACKUP
                OPEN t160_bcl USING g_rme.rme01,g_rmp_t.rmp02
                IF STATUS THEN
                    CALL cl_err("OPEN t160_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH t160_bcl INTO g_rmp[l_ac].*
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_rmp_t.rmp02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    END IF
                    LET p_cmd='u'
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            if g_no is not null then
               IF l_ac < g_no THEN NEXT FIELD rmp15 END IF
               IF l_ac = g_no then let g_no=null end if
            end if
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               CANCEL INSERT
            END IF
            #NO.TQC-790003 start--
            IF cl_null(l_rmp.rmp01) THEN LET l_rmp.rmp01 = ' ' END IF
            IF cl_null(l_rmp.rmp011) THEN LET l_rmp.rmp011 = 0 END IF
            IF cl_null(l_rmp.rmp02) THEN LET l_rmp.rmp02 = 0 END IF
            #no.TQC-790003 end----
            INSERT INTO rmp_file(rmp00,rmp01,rmp011,rmp02,rmp03,rmp04,
                                 rmp05,rmp06,rmp07,rmp08,rmp09,
                                 rmp10,rmp11,rmp12,rmp13,rmp14,rmp15,
                                 #FUN-840068 --start--
                                 rmpud01,rmpud02,rmpud03,
                                 rmpud04,rmpud05,rmpud06,
                                 rmpud07,rmpud08,rmpud09,
                                 rmpud10,rmpud11,rmpud12,
                                 rmpud13,rmpud14,rmpud15,
                                 rmpplant,rmplegal)         #FUN-980007
                                 #FUN-840068 --end--
              VALUES('1',g_rme.rme01,0,g_rmp[l_ac].rmp02,
                     g_rmp[l_ac].rmp03,'',g_rme.rme011,
                     g_rmp[l_ac].rmp06,g_rmp[l_ac].rmp07,
                     g_rmp[l_ac].rmp08,l_rmp09,g_rmp[l_ac].rmp10,
                    #g_rmp[l_ac].rmp08,'',g_rmp[l_ac].rmp10,
                     g_rmp[l_ac].rmp11,g_rmp[l_ac].rmp12,
                     g_rmp[l_ac].rmp13,g_rmp[l_ac].rmp14,
                     g_rmp[l_ac].rmp15,
                     #FUN-840068 --start--
                     g_rmp[l_ac].rmpud01,g_rmp[l_ac].rmpud02,
                     g_rmp[l_ac].rmpud03,g_rmp[l_ac].rmpud04,
                     g_rmp[l_ac].rmpud05,g_rmp[l_ac].rmpud06,
                     g_rmp[l_ac].rmpud07,g_rmp[l_ac].rmpud08,
                     g_rmp[l_ac].rmpud09,g_rmp[l_ac].rmpud10,
                     g_rmp[l_ac].rmpud11,g_rmp[l_ac].rmpud12,
                     g_rmp[l_ac].rmpud13,g_rmp[l_ac].rmpud14,
                     g_rmp[l_ac].rmpud15,
                     g_plant,g_legal)                        #FUN-980007
                     #FUN-840068 --end--
              IF SQLCA.sqlcode THEN
 #                 CALL cl_err(g_rmp[l_ac].rmp02,SQLCA.sqlcode,0)# FUN-660111 
                  CALL cl_err3("ins","rmp_file",g_rme.rme01,g_rmp[l_ac].rmp02,SQLCA.sqlcode,"","",1) #FUN-660111
                  #CKP
                  ROLLBACK WORK
                  CANCEL INSERT
              ELSE
                  COMMIT WORK
                  LET g_rec_b=g_rec_b+1
                  DISPLAY g_rec_b TO FORMONLY.cn2
              END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_rmp[l_ac].* TO NULL      #900423
            LET g_rmp[l_ac].rmp07 = 0        #Body default
            LET g_rmp[l_ac].rmp08 = 0        #Body default
            LET g_rmp[l_ac].rmp10 = " "      #Body default
            LET g_rmp_t.* = g_rmp[l_ac].*         #新輸入資料
            LET g_rmp_o.* = g_rmp[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD rmp02
 
        BEFORE FIELD rmp02                        #default 序號
            IF g_rmp[l_ac].rmp02 IS NULL OR
               g_rmp[l_ac].rmp02 = 0 THEN
                SELECT max(rmp02)+1
                   INTO g_rmp[l_ac].rmp02
                   FROM rmp_file
                   WHERE rmp01 = g_rme.rme01
                IF g_rmp[l_ac].rmp02 IS NULL THEN
                    LET g_rmp[l_ac].rmp02 = 1
                END IF
           END IF
 
        AFTER FIELD rmp02                        #check 序號是否重複
          IF NOT cl_null(g_rmp[l_ac].rmp02) THEN 
            IF g_rmp[l_ac].rmp02 != g_rmp_o.rmp02 OR
              g_rmp_o.rmp02 IS NULL THEN
              SELECT count(*) INTO l_n FROM rmp_file
                  WHERE rmp00="1" AND rmp01 = g_rme.rme01 AND
                        rmp02 = g_rmp[l_ac].rmp02
              IF l_n > 0 THEN
               #   LET g_rmp[l_ac].rmp02 = g_rmp_t.rmp02
                  CALL cl_err('',-239,0) 
                  LET g_rmp[l_ac].rmp02 = g_rmp_t.rmp02
                  NEXT FIELD rmp02
              END IF
            END IF
            LET g_rmp_o.rmp02=g_rmp[l_ac].rmp02
          END IF   

#TQC-9C0200 --begin--
       AFTER FIELD rmp08
          IF NOT cl_null(g_rmp[l_ac].rmp08) THEN
               IF g_rmp[l_ac].rmp08 <0 THEN
                  CALL cl_err('','aec-020',0)
                  NEXT FIELD CURRENT 
               END IF 
             LET g_rmp[l_ac].rmp08 = s_digqty(g_rmp[l_ac].rmp08,g_rmp[l_ac].rmp12)   #FUN-910088--add--start--
             DISPLAY BY NAME g_rmp[l_ac].rmp08                                       #FUN-910088--add--end--
          END IF 
#TQC-9C0200 --end-- 

       AFTER FIELD rmp06
          IF NOT cl_null(g_rmp[l_ac].rmp06) THEN
                LET g_n=0
               #檢查在同一張覆出單中,不可有重覆的RMA單號之項次
                IF g_rmp[l_ac].rmp06 != g_rmp_o.rmp06 OR #MOD-490416
                   g_rmp_o.rmp06 IS NULL THEN            #MOD-490416
                   SELECT count(*) INTO g_n FROM rmp_file
                        WHERE rmp00="1" AND rmp01=g_rme.rme01
                         AND rmp05=g_rme.rme011
                         #AND rmp02 <> g_rmp_t.rmp02 #MOD-490416
                         AND rmp06 = g_rmp[l_ac].rmp06
                   IF  g_n >= 1  THEN
                        LET g_rmp[l_ac].rmp06 = g_rmp_t.rmp06
                        CALL cl_err('',-239,0)
                        NEXT FIELD rmp06
                   END IF
                END IF
               #檢查在rmp_file中,不可有重覆的RMA單號之項次
                LET g_n=0
                SELECT count(*) INTO g_n FROM rme_file,rmp_file
                     WHERE rmp01 <> g_rme.rme01
                      AND  rmp00="1" AND  rmp05=g_rme.rme011
                      AND  rmp06 = g_rmp[l_ac].rmp06 AND rmevoid='Y'
                      AND  rmp05 = rme011 AND rmp01=rme01
                      AND  rmegen <> 'X'  #CHI-C80041
                IF g_n >= 1 THEN
                   LET g_rmp[l_ac].rmp06 = g_rmp_t.rmp06
                   CALL cl_err('','arm-020',0) NEXT FIELD rmp06
                END IF
                LET g_err="N"
                CALL t160_get_rmc()
                IF g_err="Y" THEN
                   CALL cl_err('','aap-129',0)
                   IF cl_null(g_rmp[l_ac].rmp08) THEN
                      LET g_rmp[l_ac].rmp08=0 END IF
                   NEXT FIELD rmp06
                END IF
                #------MOD-5A0095 START----------
                DISPLAY BY NAME g_rmp[l_ac].rmp06
                #------MOD-5A0095 END------------
          END IF
          LET g_rmp_o.rmp06 = g_rmp[l_ac].rmp06
 
       #No.FUN-840068 --start--
       AFTER FIELD rmpud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmpud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmpud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmpud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmpud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmpud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmpud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmpud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmpud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmpud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmpud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmpud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmpud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmpud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD rmpud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       #No.FUN-840068 ---end---
 
        BEFORE DELETE                            #是否取消單身
            IF g_rmp_t.rmp02 > 0 AND
               g_rmp_t.rmp02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM rmp_file
                    WHERE rmp00='1' AND rmp01 = g_rme.rme01
                      AND rmp02 = g_rmp_t.rmp02
                IF SQLCA.sqlcode THEN
#                    CALL cl_err(g_rmp_t.rmp02,SQLCA.sqlcode,0)# FUN-660111 
                    CALL cl_err3("del","rmp_file",g_rme.rme01,g_rmp_t.rmp02,SQLCA.sqlcode,"","",1) #FUN-660111
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_rmp[l_ac].* = g_rmp_t.*
               CLOSE t160_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_rmp[l_ac].rmp02,-263,1)
               LET g_rmp[l_ac].* = g_rmp_t.*
            ELSE
                          UPDATE rmp_file SET
                                 rmp02=g_rmp[l_ac].rmp02,
                                 rmp03=g_rmp[l_ac].rmp03,
                                 rmp05=g_rme.rme011,
                                 rmp06=g_rmp[l_ac].rmp06,
                                 rmp07=g_rmp[l_ac].rmp07,
                                 rmp08=g_rmp[l_ac].rmp08,
                                 rmp10=g_rmp[l_ac].rmp10,
                                 rmp11=g_rmp[l_ac].rmp11,
                                 rmp12=g_rmp[l_ac].rmp12,
                                 rmp13=g_rmp[l_ac].rmp13,
                                 rmp14=g_rmp[l_ac].rmp14,
                                 rmp15=g_rmp[l_ac].rmp15,
                                 rmp09=l_rmp09,
                                 #FUN-840068 --start--
                                 rmpud01 = g_rmp[l_ac].rmpud01,
                                 rmpud02 = g_rmp[l_ac].rmpud02,
                                 rmpud03 = g_rmp[l_ac].rmpud03,
                                 rmpud04 = g_rmp[l_ac].rmpud04,
                                 rmpud05 = g_rmp[l_ac].rmpud05,
                                 rmpud06 = g_rmp[l_ac].rmpud06,
                                 rmpud07 = g_rmp[l_ac].rmpud07,
                                 rmpud08 = g_rmp[l_ac].rmpud08,
                                 rmpud09 = g_rmp[l_ac].rmpud09,
                                 rmpud10 = g_rmp[l_ac].rmpud10,
                                 rmpud11 = g_rmp[l_ac].rmpud11,
                                 rmpud12 = g_rmp[l_ac].rmpud12,
                                 rmpud13 = g_rmp[l_ac].rmpud13,
                                 rmpud14 = g_rmp[l_ac].rmpud14,
                                 rmpud15 = g_rmp[l_ac].rmpud15
                                 #FUN-840068 --end-- 
                         WHERE rmp00="1"
                           AND rmp01=g_rme.rme01
                           AND rmp02=g_rmp_t.rmp02
                        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN
  #                          CALL cl_err(g_rmp[l_ac].rmp02,SQLCA.sqlcode,0)# FUN-660111 
                            CALL cl_err3("upd","rmp_file",g_rme.rme01,g_rmp_t.rmp02,SQLCA.sqlcode,"","",1) #FUN-660111  
                            LET g_rmp[l_ac].* = g_rmp_t.*
                        ELSE
                            COMMIT WORK
                        END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
       #    LET l_ac_t = l_ac      #FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               #CKP
               IF p_cmd='u' THEN
                  LET g_rmp[l_ac].* = g_rmp_t.*
            #FUN-D40030--add--str--
               ELSE
                  CALL g_rmp.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D40030--add--end--
               END IF
               CLOSE t160_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac      #FUN-D40030 add
           #CKP
           #LET g_rmp_t.* = g_rmp[l_ac].*          # 900423
            CLOSE t160_bcl
            COMMIT WORK
 
      # ON ACTION CONTROLN
      #     CALL t160_b_askkey()
      #     EXIT INPUT
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(rmp02) AND l_ac > 1 THEN
                LET g_rmp[l_ac].* = g_rmp[l_ac-1].*
                LET g_rmp[l_ac].rmp02 = NULL
                NEXT FIELD rmp02
            END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION gen_detail #銷帳單號項次NO:7221
           IF cl_confirm('arm-521') THEN
               #BEGIN WORK   #MOD-920045
               #LET g_success = 'Y'   #MOD-920045
               DELETE FROM rmp_file WHERE rmp01=g_rme.rme01   #RMA覆出單號
               IF SQLCA.SQLCODE THEN
                   #LET g_success = 'N'   #MOD-920045
                   #ROLLBACK WORK   #MOD-920045
                   NEXT FIELD rmp02
               END IF
               CALL g_rmp.clear()
               CALL t160_g_b()
               LET l_ac = ARR_CURR()   #MOD-920045
               LET g_rmp_t.* = g_rmp[l_ac].*    #MOD-920045
               LET g_rmp_o.* = g_rmp[l_ac].*    #MOD-920045
               LET li_flag = TRUE  #MOD-920045
               EXIT INPUT #MOD-920045
               #IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF   #MOD-920045
               #CALL t160_b()   #MOD-920045
           ELSE
               NEXT FIELD rmp02
           END IF
 
        ON ACTION CONTROLG
 
        ON ACTION CONTROLP #genero
            CASE
               WHEN INFIELD(rmp06) #項次
#    #            CALL q_rma1(0,0,g_rme.rme011,'70') RETURNING g_tmp,g_rmp[l_ac].rmp06
#    #            CALL FGL_DIALOG_SETBUFFER( g_tmp )
#    #            CALL FGL_DIALOG_SETBUFFER( g_rmp[l_ac].rmp06 )
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_rma1"
                  IF NOT cl_null(g_rme.rme011) THEN
                      LET g_qryparam.construct = "N"
                      LET g_qryparam.where = " rmc01 = '",g_rme.rme011,"'"
                  END IF
                  LET g_qryparam.default1 = g_rme.rme011
                  LET g_qryparam.arg1 = '70'
                  LET g_qryparam.arg2 = g_doc_len   #MOD-770022
                  CALL cl_create_qry() RETURNING g_tmp,g_rmp[l_ac].rmp06
#                  CALL FGL_DIALOG_SETBUFFER( g_tmp )
#                  CALL FGL_DIALOG_SETBUFFER( g_rmp[l_ac].rmp06 )
                  DISPLAY g_rmp[l_ac].rmp06 TO rmp06
                  CALL t160_get_rmc()  #NO:7221
                  NEXT FIELD rmp06
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
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END  
 
        END INPUT
   #-----MOD-920045---------
        IF li_flag = TRUE THEN
           LET li_flag = FALSE
           CONTINUE WHILE
        END IF
        EXIT WHILE
   END WHILE
   #-----END MOD-920045-----
        IF NOT INT_FLAG THEN
            LET  g_rec_b= ARR_COUNT()
        END IF
 
   #FUN-5B0113-begin
    LET g_rme.rmemodu = g_user
    LET g_rme.rmedate = g_today
    UPDATE rme_file SET rmemodu = g_rme.rmemodu,rmedate = g_rme.rmedate
     WHERE rme01 = g_rme.rme01
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
   #    CALL cl_err('upd rme',SQLCA.SQLCODE,1)# FUN-660111 
       CALL cl_err3("upd","rme_file",g_rme.rme01,"",SQLCA.sqlcode,"","upd rme",1) #FUN-660111
    END IF
    DISPLAY BY NAME g_rme.rmemodu,g_rme.rmedate
   #FUN-5B0113-end
 
    CLOSE t160_bcl
   #COMMIT WORK
    LET g_success="Y"
    IF INT_FLAG THEN
       LET g_success = "N"
       IF p_cmd="a" THEN RETURN
       ELSE LET INT_FLAG=0 CALL cl_err('',9001,1)
            ROLLBACK WORK
            CALL t160_show()
            RETURN END IF
    END IF
 
    CALL t160_delHeader()     #CHI-C30002 add
    IF NOT cl_null(g_rme.rme01) THEN #CHI-C30002 add
#   LET g_t1 = g_rme.rme01[1,3]
       LET g_t1 = s_get_doc_no(g_rme.rme01)     #No.FUN-550064
       SELECT * INTO g_oay.* FROM oay_file WHERE oayslip=g_t1
       IF g_oay.oayconf = 'Y' THEN CALL t160_y() END IF
    END IF     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t160_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_rme.rme01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM rme_file ",
                  "  WHERE rme01 LIKE '",l_slip,"%' ",
                  "    AND rme01 > '",g_rme.rme01,"'"
      PREPARE t160_pb1 FROM l_sql 
      EXECUTE t160_pb1 INTO l_cnt       
      
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
        #CALL t160_v()
         CALL t160_v(1)  #CHI-D20010
         IF g_rme.rmegen='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_rme.rmegen ,"",g_rme.rmepost,"",g_void,g_rme.rmevoid) 
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN #CHI-C80041
         DELETE FROM rme_file WHERE rme01 = g_rme.rme01
         INITIALIZE g_rme.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t160_chk_rmp03()
   DEFINE l_i   LIKE type_file.num5,    #No.FUN-690010 SMALLINT
          g_rmp10 LIKE rmp_file.rmp10
 
   IF g_rec_b > 0 THEN
      FOR l_i = 1 TO g_rec_b
        let g_no=null
        IF g_rmp[l_i].rmp02 IS NULL OR g_rmp[l_i].rmp06 IS NULL THEN
           EXIT FOR END IF
           IF cl_null(g_rmp[l_i].rmp03) THEN
              LET l_exit_sw="n"
              LET g_no=l_i
              CALL cl_err('C/NO: ','aar-011',0)
              EXIT FOR
           END IF
      END FOR
   END IF
END FUNCTION
 
FUNCTION t160_get_rmc()
   SELECT rmc04,rmc05,rmc06,rmc061,rmc07,rmc31-rmc311-rmc312-rmc313,rmc14
     INTO g_rmp[l_ac].rmp11,g_rmp[l_ac].rmp12,g_rmp[l_ac].rmp13,
          g_rmp[l_ac].rmp14,g_rmp[l_ac].rmp15,g_rmp[l_ac].rmp07,
          g_rmp[l_ac].rmp10
     FROM rmc_file
    WHERE rmc01=g_rme.rme011 AND rmc02=g_rmp[l_ac].rmp06
      AND rmc23 IS NULL AND rmc14 IN ('1','2','5','6')  #MOD-A30035 rmc14 add 56
 
   #-----No.MOD-590034-----
   DISPLAY BY NAME g_rmp[l_ac].rmp11,g_rmp[l_ac].rmp12,g_rmp[l_ac].rmp13,
                   g_rmp[l_ac].rmp14,g_rmp[l_ac].rmp15,g_rmp[l_ac].rmp07,
                   g_rmp[l_ac].rmp10
   #-----No.MOD-590034 END-----
 
   IF SQLCA.sqlcode THEN
      LET g_err="Y"
      LET g_rmp[l_ac].* = g_rmp_t.*
      LET g_rmp[l_ac].rmp02 = g_rmp_o.rmp02
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION t160_get_ima()
        SELECT ima02,ima021,ima25,'2'
              INTO g_rmp[l_ac].rmp13,g_rmp[l_ac].rmp14,g_rmp[l_ac].rmp12,
                   g_rmp[l_ac].rmp10
              FROM ima_file  WHERE ima01="MISC"
        IF SQLCA.sqlcode THEN
           LET g_err="Y"
           LET g_rmp[l_ac].* = g_rmp_t.*
           RETURN
        END IF
END FUNCTION
 
FUNCTION t160_b_askkey()
DEFINE           l_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON rmp02,rmp06,rmp03,rmp07,rmp10,rmp08,rmp11,  #No:7198
                       rmp13,rmp14,rmp12,rmp15
                       #No.FUN-840068 --start--
                       ,rmpud01,rmpud02,rmpud03,rmpud04,rmpud05
                       ,rmpud06,rmpud07,rmpud08,rmpud09,rmpud10
                       ,rmpud11,rmpud12,rmpud13,rmpud14,rmpud15
                       #No.FUN-840068 ---end---
         FROM s_rmp[1].rmp02,s_rmp[1].rmp06, s_rmp[1].rmp03, s_rmp[1].rmp07,
              s_rmp[1].rmp10, s_rmp[1].rmp08, s_rmp[1].rmp11,
              s_rmp[1].rmp13, s_rmp[1].rmp14,s_rmp[1].rmp12,
              s_rmp[1].rmp15
              #No.FUN-840068 --start--
              ,s_rmp[1].rmpud01,s_rmp[1].rmpud02,s_rmp[1].rmpud03
              ,s_rmp[1].rmpud04,s_rmp[1].rmpud05,s_rmp[1].rmpud06
              ,s_rmp[1].rmpud07,s_rmp[1].rmpud08,s_rmp[1].rmpud09
              ,s_rmp[1].rmpud10,s_rmp[1].rmpud11,s_rmp[1].rmpud12
              ,s_rmp[1].rmpud13,s_rmp[1].rmpud14,s_rmp[1].rmpud15
              #No.FUN-840068 ---end---
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t160_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t160_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-690010 VARCHAR(400)
 
       LET g_sql =" SELECT rmp02,rmp06,rmp03,rmp07,rmp08,rmp11,rmp10, ",
                  "        rmp13,rmp14,rmp12,rmp15, ",
                  #No.FUN-840068 --start--
                  "        rmpud01,rmpud02,rmpud03,rmpud04,rmpud05,",
                  "        rmpud06,rmpud07,rmpud08,rmpud09,rmpud10,",
                  "        rmpud11,rmpud12,rmpud13,rmpud14,rmpud15 ", 
                  #No.FUN-840068 ---end---
                  " FROM rme_file,rmp_file ",
                  " WHERE rme01=rmp01 AND rmp00='1' ",
                  " AND rmp05= '",g_rme.rme011,"'",
                  " AND rmp01= '",g_rme.rme01,"'"," AND ",p_wc2 CLIPPED,
                  " ORDER BY rmp06,rmp02 "
    PREPARE t160_pb FROM g_sql
    DECLARE rmp_curs                       #SCROLL CURSOR
        CURSOR FOR t160_pb
 
    CALL g_rmp.clear()
    LET g_cnt = 1
    FOREACH rmp_curs INTO g_rmp[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    #CKP
    CALL g_rmp.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION t160_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rmp TO s_rmp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t160_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t160_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t160_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t160_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t160_fetch('L')
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
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #CKP
         #CALL cl_set_field_pic(g_rme.rmegen ,"",g_rme.rmepost,"","",g_rme.rmevoid) #CHI-C80041
         IF g_rme.rmegen='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
         CALL cl_set_field_pic(g_rme.rmegen ,"",g_rme.rmepost,"",g_void,g_rme.rmevoid) #CHI-C80041 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
    #@ON ACTION Memo
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
    #@ON ACTION 扣帳
      ON ACTION deduct
         LET g_action_choice="deduct"
         EXIT DISPLAY
    #@ON ACTION 扣帳還原
      ON ACTION undo_deduct
         LET g_action_choice="undo_deduct"
         EXIT DISPLAY
    #@ON ACTION 維護PACKING
      ON ACTION maintain_packing
         LET g_action_choice="maintain_packing"
         EXIT DISPLAY
    #@ON ACTION 放行單列印
      ON ACTION prt_release_order
         LET g_action_choice="prt_release_order"
         EXIT DISPLAY
    #@ON ACTION 黏貼單列印
      ON ACTION print_sticker
         LET g_action_choice="print_sticker"
         EXIT DISPLAY
    #@ON ACTION 覆出單彙總列印
      ON ACTION print_rd_summary
         LET g_action_choice="print_rd_summary"
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      #NO.FUN-6B0031--BEGIN                                                                                                               
       ON ACTION CONTROLS                                                                                                          
          CALL cl_set_head_visible("","AUTO")                                                                                      
      #NO.FUN-6B0031--END
 
     #CHI-6B0071---add---str---
     #@ON ACTION 刪除
       ON ACTION delete
          LET g_action_choice="delete"
          EXIT DISPLAY
     #CHI-6B0071---add---end---
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
 
FUNCTION t160_x()
    IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
    SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
    IF g_rme.rme01 IS NULL THEN
       CALL cl_err('','arm-019',0) RETURN END IF
    IF g_rme.rmevoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
    IF g_rme.rmegen  = 'Y' THEN CALL cl_err('gen=Y',9023,0)  RETURN END IF
     #MOD-4A0268
    IF g_rme.rmepost ='Y' THEN
       CALL cl_err('rmepost=Y:','axm-208',0)  RETURN
    END IF
    #--
 
    IF cl_exp(0,0,g_rme.rmevoid) THEN
 
       BEGIN WORK
 
       OPEN t160_cl USING g_rme.rme01
       IF STATUS THEN
          CALL cl_err("OPEN t160_cl:", STATUS, 1)
          CLOSE t160_cl
          ROLLBACK WORK
          RETURN
       END IF
 
       FETCH t160_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
          CLOSE t160_cl ROLLBACK WORK RETURN
       END IF
 
       CALL t160_show()
 
       LET g_rme.rmevoid='N'
       UPDATE rme_file                    #更改有效碼
          SET rmevoid=g_rme.rmevoid,rmemodu=g_user,rmedate=g_today
        WHERE rme01=g_rme.rme01
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
 #         CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)# FUN-660111 
          CALL cl_err3("upd","rem_file",g_rme.rme01,"",SQLCA.sqlcode,"","",1) #FUN-660111
          LET g_rme.rmevoid='Y'
       END IF
 
       DISPLAY BY NAME g_rme.rmevoid
 
       COMMIT WORK
 
       CALL cl_flow_notify(g_rme.rme01,'V')
 
    END IF
    #CKP
    #CALL cl_set_field_pic(g_rme.rmegen ,"",g_rme.rmepost,"","",g_rme.rmevoid) #CHI-C80041
    IF g_rme.rmegen='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
    CALL cl_set_field_pic(g_rme.rmegen ,"",g_rme.rmepost,"",g_void,g_rme.rmevoid) #CHI-C80041
 
 
END FUNCTION
 
FUNCTION t160_y()         # when g_rme.rmegen ='N' (Turn to 'Y')
DEFINE l_occ57 LIKE occ_file.occ57
DEFINE l_cnt   LIKE type_file.num5    #No.FUN-690010 SMALLINT
 
  #NO.MOD-570393
  LET l_cnt = 0
  SELECT occ57 INTO l_occ57 FROM occ_file
   WHERE occ01=g_rme.rme03
   #------CHI-BC0016 mark----------- 
   #IF l_occ57='Y' THEN   #是否製作包裝單
   #   SELECT count(*) INTO l_cnt
   #     FROM rmp_file
   #    WHERE rmp01 = g_rme.rme01
   #      AND rmp03 IS NULL
   #  IF l_cnt > 0 THEN
   #       CALL cl_err('','arm-530',1)
   #       RETURN
   #   END IF
   #END IF
   #------CHI-BC0016 mark----------- 
  #--END
 
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
#CHI-C30107 ------------ add ------------ begin
   IF g_rme.rme01 IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN
   END IF 
   IF g_rme.rmevoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rme.rmegen  = 'Y' THEN CALL cl_err('gen=Y',9023,0)  RETURN END IF
   IF g_rme.rmepost ='Y' THEN
      CALL cl_err('rmepost=Y:','axm-208',0)  RETURN
   END IF
   IF NOT cl_upsw(0,0,'N') THEN RETURN END IF 
#CHI-C30107 ------------ add ------------ end
   SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
   IF g_rme.rme01 IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN
   END IF
#-----------------No.MOD-650084 mark
  #IF g_sma.sma79='Y' THEN    #NO:7260
  #    IF g_rme.rmeprin = 'N' THEN CALL cl_err('prin=N','arm-039',0) RETURN END IF
  #END IF
#-----------------No.MOD-650084 end
   SELECT occ57 INTO l_occ57 FROM occ_file
    WHERE occ01=g_rme.rme03
    #MOD-4A0268
   {
   IF l_occ57='Y' THEN        #NO:7260
      IF g_rme.rmepack  = 'N' THEN CALL cl_err('pack=N','arm-040',0) RETURN END IF
   END IF
   }
   #--
   IF g_rme.rmevoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rme.rmegen  = 'Y' THEN CALL cl_err('gen=Y',9023,0)  RETURN END IF
    #MOD-A0268
   IF g_rme.rmepost ='Y' THEN
      CALL cl_err('rmepost=Y:','axm-208',0)  RETURN
   END IF
   #--
   IF g_rmp[1].rmp02 IS NULL THEN
      CALL cl_err(g_rme.rme01,'arm-034',1) RETURN END IF
 
#  IF NOT cl_upsw(0,0,'N') THEN RETURN END IF #CHI-C30107 mark
 
   BEGIN WORK
 
    OPEN t160_cl USING g_rme.rme01
    IF STATUS THEN
       CALL cl_err("OPEN t160_cl:", STATUS, 1)
       CLOSE t160_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t160_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t160_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   DELETE FROM rmf_file WHERE rmf01=g_rme.rme01
   CALL t160_t()               #INSERT,UPDATE rmf(RET# >0),up rmp l:1614
   IF g_success = 'N' THEN
      ROLLBACK WORK
      CALL cl_rbmsg(3) sleep 1
      RETURN
   END IF
 
   CALL t160_up_rmbc('Y')      #UPDATE rmp,rmc l:1599
   IF g_success = 'N' THEN
      ROLLBACK WORK
      RETURN
   END IF
   UPDATE rme_file SET rmegen = 'Y',rmemodu=g_user,rmedate=g_today
          WHERE rme01 = g_rme.rme01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
  #    CALL cl_err('upd rmegen ',STATUS,1)# FUN-660111 
      CALL cl_err3("upd","rme_file",g_rme.rme01,"",STATUS,"","upd rmegen",1) #FUN-660111
      LET g_success = 'N'
   END IF
   IF g_success = 'Y' THEN
      LET g_rme.rmegen ="Y"
      LET g_rme.rmemodu=g_user LET g_rme.rmedate=g_today
      COMMIT WORK
      CALL cl_flow_notify(g_rme.rme01,'Y')
      DISPLAY BY NAME g_rme.rmegen
      CALL cl_cmmsg(3) sleep 1
   ELSE
      LET g_rme.rmegen ='N'
      ROLLBACK WORK
      CALL cl_rbmsg(3) sleep 1
   END IF
   DISPLAY BY NAME g_rme.rmegen
   MESSAGE ''
   #CKP
   #CALL cl_set_field_pic(g_rme.rmegen ,"",g_rme.rmepost,"","",g_rme.rmevoid) #CHI-C80041
   IF g_rme.rmegen='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
   CALL cl_set_field_pic(g_rme.rmegen ,"",g_rme.rmepost,"",g_void,g_rme.rmevoid) #CHI-C80041
 
END FUNCTION
 
FUNCTION t160_z(p_cmd)    # when g_rme.rmegen='Y' (Turn to 'N')
DEFINE p_cmd LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
DEFINE l_cnt LIKE type_file.num5    #MOD-AA0009 add
 
  #MOD-AA0009---add--start---
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM rme_file
    WHERE rme01 = g_rme.rme01
      AND rmeconf = 'Y'
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt > 0 THEN
      CALL cl_err(g_rme.rme01,'arm-047',1)
      RETURN
   END IF
  #MOD-AA0009---add---end---
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
   SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
   IF g_rme.rme01 IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN
   END IF
   IF g_rme.rmevoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
   IF g_rme.rmegen  = 'N' THEN CALL cl_err('gen=N',9025,0) RETURN END IF
    #MOD-A0268
   IF g_rme.rmepost ='Y' THEN
      CALL cl_err('rmepost=Y:','axm-208',0)  RETURN
   END IF
   #--
   IF g_rme.rme31   ='Y' THEN CALL cl_err('t220(forward):rme31=Y:',9023,0)
      RETURN END IF
   IF g_rme.rme32   ='Y' THEN CALL cl_err('t225(cargo):rme32=Y:',9023,0)
      RETURN END IF
   IF cl_null(p_cmd) THEN
      IF NOT cl_upsw(0,0,'Y') THEN RETURN END IF
   END IF
   BEGIN WORK
 
 
    OPEN t160_cl USING g_rme.rme01
    IF STATUS THEN
       CALL cl_err("OPEN t160_cl:", STATUS, 1)
       CLOSE t160_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t160_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t160_cl ROLLBACK WORK RETURN
    END IF
 
   LET g_success = 'Y'
   CALL t160_up_rmbc('N')    #l:1599
   IF g_success="N" THEN
      ROLLBACK WORK
      RETURN
   END IF
  #UPDATE rme_file SET rmegen  = 'N',rmemodu=g_user,
  #-------980717 modi 若執行取消確認時,同時prin=N,pack=N
   UPDATE rme_file SET rmegen  = 'N',rmeprin='N',rmepack='N',rmemodu=g_user,
                       rmedate=g_today
          WHERE rme01 = g_rme.rme01
  #--------
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
  #    CALL cl_err('upd rmegen',STATUS,1)# FUN-660111 
      CALL cl_err3("upd","rem_file",g_rme.rme01,"",STATUS,"","upd rmegen",1) #FUN-660111
      LET g_success = 'N'
   END IF
   IF g_success = 'Y'
      THEN LET g_rme.rmegen ='N'
           LET g_rme.rmeprin='N'    LET g_rme.rmepack='N'
           LET g_rme.rmemodu=g_user LET g_rme.rmedate=g_today
           COMMIT WORK
           CALL cl_cmmsg(3) sleep 1
      ELSE LET g_rme.rmegen ='Y'
           LET g_rme.rmeprin='Y'    LET g_rme.rmepack='Y'
           ROLLBACK WORK
           CALL cl_rbmsg(3) sleep 1
   END IF
   DISPLAY BY NAME g_rme.rmegen,g_rme.rmepack,g_rme.rmeprin
   MESSAGE ''
   #CKP
   #CALL cl_set_field_pic(g_rme.rmegen ,"",g_rme.rmepost,"","",g_rme.rmevoid) #CHI-C80041
   IF g_rme.rmegen='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
   CALL cl_set_field_pic(g_rme.rmegen ,"",g_rme.rmepost,"",g_void,g_rme.rmevoid) #CHI-C80041
END FUNCTION
 
FUNCTION t160_s(p_cmd)           # when g_rme.rmepost='N' (Turn to 'Y')
   DEFINE p_cmd LIKE type_file.chr1           #Y:扣帳 N:還原  #No.FUN-690010 VARCHAR(1)
   DEFINE l_occ57 LIKE occ_file.occ57
   DEFINE l_cnt LIKE type_file.num5    #CHI-BC0016 add
 
   IF s_shut(0) THEN CALL cl_err('',9037,0) RETURN END IF
   SELECT * INTO g_rme.* FROM rme_file WHERE rme01 = g_rme.rme01
   IF g_rme.rme01 IS NULL THEN
      CALL cl_err('','arm-019',0) RETURN END IF
   IF g_rme.rmevoid = 'N' THEN CALL cl_err('void=N',9028,0) RETURN END IF
 
   SELECT occ57 INTO l_occ57 FROM occ_file WHERE occ01=g_rme.rme03
 
  #Y:扣帳  gen=N,prin=N,pack=N,psst=N
   IF p_cmd="Y" THEN
     #gen=N(表未確認)時不可扣帳
      IF g_rme.rmegen  != p_cmd THEN
         CALL cl_err(' gen=N','afa-100',0) RETURN END IF
       #MOD-4A0268
      IF l_occ57='Y' AND  g_rme.rmepack  = 'N' THEN
         CALL cl_err('pack=N','arm-040',0) RETURN
      END IF
      #--
     #post=Y(表已扣帳)時,不可再扣帳
      IF g_rme.rmepost=p_cmd THEN
         CALL cl_err('post=Y','aar-519',0) RETURN END IF
   ELSE                         #N:還原  gen=N,prin=N,pack=N,psst=N
     #gen=N(表未確認)時,不可還原
      IF g_rme.rmegen   = p_cmd THEN
         CALL cl_err(' gen=N','aap-717',0) RETURN END IF
     #post=N(表未扣帳)時,不可還原
      IF g_rme.rmepost  = p_cmd THEN
         CALL cl_err('post=N','mfg0178',0) RETURN END IF
   END IF
   #請使用者選擇Y/N!
   IF p_cmd="Y" THEN     #扣帳
      IF NOT cl_confirm('mfg0176') THEN RETURN END IF     #若輸入:N 時則離開
   ELSE                  #還原
      IF NOT cl_confirm('asf-663') THEN RETURN END IF     #若輸入:N 時則離開
   END IF
 
   BEGIN WORK
 
    OPEN t160_cl USING g_rme.rme01
    IF STATUS THEN
       CALL cl_err("OPEN t160_cl:", STATUS, 1)
       CLOSE t160_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t160_cl INTO g_rme.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t160_cl ROLLBACK WORK RETURN
    END IF
 #-------CHI-BC0016 add start-----
   IF p_cmd = 'Y' THEN
    IF l_occ57='Y' THEN   #是否製作包裝單
       SELECT count(*) INTO l_cnt
       FROM rmp_file
       WHERE rmp01 = g_rme.rme01
         AND rmp03 IS NULL
       IF l_cnt > 0 THEN
          CALL cl_err('','arm-530',1)
          RETURN
       END IF
     END IF
   END IF
#-------CHI-BC0016 add END  -----
   LET g_success = 'Y'
   CALL t160_s1(p_cmd)      #update rmc   l:1491
   IF g_success = 'Y' THEN
      IF p_cmd = 'Y' THEN
         UPDATE rme_file SET rmepost=p_cmd,rmemodu=g_user,rmedate=g_today
          WHERE rme01=g_rme.rme01
         COMMIT WORK
         CALL cl_flow_notify(g_rme.rme01,'S')
         LET g_rme.rmepost='Y'
         LET g_rme.rmemodu=g_user LET g_rme.rmedate=g_today
         DISPLAY BY NAME g_rme.rmepost
 
      ELSE
        #NO:7260:rmegen,rmeprin,rmepack拿掉(不UPDATE)
 
         UPDATE rme_file SET rmepost=p_cmd,rmemodu=g_user,
                             rmedate=g_today   #,rme021=NULL     #CHI-BC0016 mark rme021不回復成NULL
          WHERE rme01=g_rme.rme01
         LET g_rme.rmepost='N'
         LET g_rme.rmemodu=g_user LET g_rme.rmedate=g_today
         DISPLAY BY NAME g_rme.rmepost, g_rme.rmeprin,g_rme.rmepack
 
         COMMIT WORK
         CALL cl_flow_notify(g_rme.rme01,'S')
 
      END IF
 
      CALL cl_cmmsg(3)
   ELSE
      ROLLBACK WORK
      DISPLAY BY NAME g_rme.rmepost
      CALL cl_cmmsg(3)
   END IF
   MESSAGE ''
   #CKP
   #CALL cl_set_field_pic(g_rme.rmegen ,"",g_rme.rmepost,"","",g_rme.rmevoid) #CHI-C80041
   IF g_rme.rmegen='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF #CHI-C80041
   CALL cl_set_field_pic(g_rme.rmegen ,"",g_rme.rmepost,"",g_void,g_rme.rmevoid) #CHI-C80041
END FUNCTION
 
FUNCTION t160_s1(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1,    #Y:扣帳 N:扣帳還原  #No.FUN-690010 VARCHAR(1)
         g_rmb111 like rmb_file.rmb111,
         l_rmc  record like rmc_file.*
 
   IF p_cmd="Y" THEN
     #-------CHI-BC0016 add start-----
     LET g_before_input_done = FALSE
     CALL t160_set_entry(p_cmd)
     INPUT BY NAME  g_rme.rme021 WITHOUT DEFAULTS

        BEFORE INPUT
          LET g_rme.rme021 = g_today
          DISPLAY BY NAME g_rme.rme021 

        AFTER INPUT
          CALL t160_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE

        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT

        ON ACTION about
          CALL cl_about()

        ON ACTION help
          CALL cl_show_help()

        ON ACTION controlg
          CALL cl_cmdask()
            
      END INPUT
      #-------CHI-BC0016 add end------
 
     #rmc_file: rmc22=覆出日期(rme021),rmc21="1' 表覆出除帳
      UPDATE rmc_file SET rmc22=g_rme.rme021,rmc21="1"
          WHERE rmc23=g_rme.rme01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
   #      CALL cl_err('up rmc: ',STATUS,0)# FUN-660111 
         CALL cl_err3("upd","rmc_file",g_rme.rme01,"",SQLCA.sqlcode,"","upd rmc:",1) #FUN-660111
         LET g_success = 'N'
         RETURN
      END IF
 
     #update rmb_file:  INVO已出數量=rmb111+覆出數量(by RMA單號+料件)
      FOREACH t160_rmp_cs INTO l_rmp.*
         IF STATUS THEN
            CALL cl_err('FOREACH rmp: ',STATUS,0) EXIT FOREACH END IF
         UPDATE rmb_file SET rmb111=rmb111+l_rmp.rmp07
          WHERE rmb01=l_rmp.rmp05 AND rmb03=l_rmp.rmp11
            AND rmb05=l_rmp.rmp13
         IF STATUS THEN
#            CALL cl_err('upd rmb: ',STATUS,0)# FUN-660111 
            CALL cl_err3("upd","rmb_file",l_rmp.rmp05,l_rmp.rmp11,STATUS,"","upd rmb:",1) #FUN-660111
            LET g_success='N'
            EXIT FOREACH
         END IF
 
      END FOREACH
   ELSE     #扣帳還原
      FOREACH t160_rmp_cs INTO l_rmp.*
         IF STATUS THEN
            CALL cl_err('FOREACH rmp: ',STATUS,0) EXIT FOREACH END IF
         UPDATE rmc_file SET rmc21='0', #No.8714
                             rmc22=NULL
          WHERE rmc01=g_rme.rme011 and rmc02=l_rmp.rmp06
         IF STATUS THEN
#            CALL cl_err('upd rmc: ',STATUS,0)# FUN-660111 
            CALL cl_err3("upd","rmc_file",g_rme.rme011,l_rmp.rmp06,STATUS,"","upd rmc:",1) #FUN-660111
            LET g_success='N'
            RETURN
         END IF
 
         #執行取消確認: up rmb_file
         #INVO已出數量=rmb111-覆出數量(by RMA單號+料件)
         UPDATE rmb_file SET rmb111=rmb111-l_rmp.rmp07
             WHERE rmb01=l_rmp.rmp05 AND rmb03=l_rmp.rmp11
               AND rmb05=l_rmp.rmp13
         IF STATUS THEN
  #          CALL cl_err('upd rmb: ',STATUS,0)# FUN-660111 
            CALL cl_err3("upd","rmb_file",l_rmp.rmp05,l_rmp.rmp11,STATUS,"","upd rmb:",1) #FUN-660111
            LET g_success='N'
            EXIT FOREACH
         END IF
 
       END FOREACH
   END IF
   CLOSE t160_rmp_cs
END FUNCTION
 
FUNCTION t160_up_rmbc(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
 
 
   FOREACH t160_rmp_cs INTO l_rmp.*
      IF STATUS THEN
         CALL cl_err('FOREACH rmp: ',STATUS,0) EXIT FOREACH END IF
 
      IF p_cmd="Y" THEN             #當執行 Y.確認時
         #update rmc_file: rmc23,rmc24,rmc14=新修復狀態 (by RMA單號+項次)
         UPDATE rmc_file
            SET rmc14 = l_rmp.rmp09, rmc23 = l_rmp.rmp01,
                rmc24 = l_rmp.rmp02
            WHERE rmc01=l_rmp.rmp05 AND rmc02=l_rmp.rmp06
         IF STATUS THEN
#            CALL cl_err('upd rmc: ',STATUS,0)# FUN-660111 
            CALL cl_err3("upd","rmc_file",l_rmp.rmp05,l_rmp.rmp06,STATUS,"","upd rmc:",1) #FUN-660111
            LET g_success='N'
            EXIT FOREACH
         END IF
 
      END IF
 
      IF p_cmd="N" THEN           #當執行 Z.取消確認時,
         #update rmc_file: rmc23,rmc24=0,rmc14=原修復狀態
         #       (by RMA單號+項次)
         UPDATE rmc_file SET rmc23=NULL,rmc24=0,rmc14=l_rmp.rmp10
            WHERE rmc01=l_rmp.rmp05 AND rmc02=l_rmp.rmp06
         IF STATUS THEN
  #          CALL cl_err('upd rmc: ',STATUS,0)# FUN-660111 
            CALL cl_err3("upd","rmc_file",l_rmp.rmp05,l_rmp.rmp06,STATUS,"","upd rmc:",1) #FUN-660111
            LET g_success='N'
            EXIT FOREACH
         END IF
      END IF
 
   END FOREACH
   CLOSE t160_rmp_cs
 
END FUNCTION
 
FUNCTION t160_t()             # 當執行 Y.確認時
             # group by 覆出單號,RMA單號,C/NO,料號,品名,原修護碼
  #LET w_sql = " SELECT rmp01,rmp05,rmp03,rmp11,rmp13,rmp10,rmp09,rmc03,",      #MOD-950063 mark  
   LET w_sql = " SELECT rmp01,rmp05,rmp03,rmp11,rmp13,rmp10,rmp09,rmc09,",      #MOD-950063 add
               " sum(rmp07),sum(rmp08) ",
               " FROM rmp_file LEFT JOIN rmc_file ON rmp05=rmc_file.rmc01 AND rmp06=rmc_file.rmc02 ",
               " WHERE rmp01='",g_rme.rme01,"'",
              #" GROUP BY rmp01,rmp05,rmp03,rmp11,rmp10,rmp13,rmp09,rmc03 ",    #MOD-950063 mark
               " GROUP BY rmp01,rmp05,rmp03,rmp11,rmp10,rmp13,rmp09,rmc09 ",    #MOD-950063 add
               " ORDER BY 1,2,3,4,5,6,7 "     
 
   PREPARE t160_t_prepare FROM w_sql
   DECLARE t160_t_cs CURSOR FOR t160_t_prepare
 
     LET g_success = 'Y'
     LET g_count=0
     INITIALIZE t_rmp.*   TO NULL
     FOREACH t160_t_cs INTO t_rmp.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('資料被他人鎖住',SQLCA.sqlcode,0)     # 資料被他人LOCK
          LET g_success = 'N'
          EXIT FOREACH
       END IF
 
       LET g_cnt=0
       CALL t160_ins_rmf()
 
       IF g_success = 'N' THEN
          EXIT FOREACH
       END IF
 
       LET g_count   = g_count+1
 
    END FOREACH
 
    CLOSE t160_t_cs
 
END FUNCTION
 
#get rmp,occ (rma01=g_rme.rme011,rma03=occ01)
FUNCTION t160_get_rme03()      # update  覆出單單頭 rme_file
 
    SELECT rma13,rma14,rma16,rma17,rma08
      INTO g_rme.rme12,g_rme.rme13,g_rme.rme16,g_rme.rme17,g_rme.rme29
      FROM rma_file
      WHERE rma01=g_rme.rme011
    SELECT occ11,occ241,occ242,occ243,occ41,occ18,occ19,occ02
      INTO g_rme.rme041,g_rme.rme073,g_rme.rme074,g_rme.rme075,g_rme.rme15,
           g_rme.rme071,g_rme.rme072,g_rme.rme04
      FROM occ_file
      WHERE occ01=g_rme.rme03
    SELECT gec04,gec05,gec07 INTO g_rme.rme151,g_rme.rme152,g_rme.rme153
           FROM gec_file WHERE gec01=g_rme.rme15 AND gec011='2'
END FUNCTION
 
FUNCTION t160_ins_rmf()  # add 覆出單單身: rmf_file ( 當執行 Y.確認時)
    DEFINE l_rmp09 like rmp_file.rmp09
 
    INITIALIZE g_rmf.* TO NULL
   #IF t_rmp.rmp10 = '1' THEN #修復狀態                       #MOD-A30035 mark
    IF t_rmp.rmp10 = '1' OR t_rmp.rmp10 = '5' THEN #修復狀態  #MOD-A30035
       LET l_rmp09 = '5'            #修復已包裝
    ELSE
       LET l_rmp09 = '6'            #未修已包裝
    END IF
   #by RMA單號,C/NO,料號,原修護碼(rmf07,rmf33,rmf03,rmf25)
    SELECT rmb02,rmb13,rmb04,rmb05,rmb06
      INTO g_rmf.rmf08,g_rmf.rmf13,g_rmf.rmf04,
           g_rmf.rmf06,g_rmf.rmf061
      FROM rmb_file WHERE rmb01=t_rmp.rmp05 AND rmb03=t_rmp.rmp11
                   #--------------No.TQC-630150 modify
                      AND (rmb05=t_rmp.rmp13 OR rmb05 IS NULL)
                   #--------------No.TQC-630150 end
    IF SQLCA.sqlcode THEN
 #      CALL cl_err('t160_ins_rmf: sel rmb',SQLCA.sqlcode,1)# FUN-660111 
       CALL cl_err3("sel","rmb_file",t_rmp.rmp05,t_rmp.rmp11,SQLCA.sqlcode,"","t160_ins_rmf:",1) #FUN-660111
       LET g_success = 'N'  RETURN
    END IF
    IF g_rmf.rmf12  IS NULL THEN LET g_rmf.rmf12=0  END IF
    IF g_rmf.rmf121 IS NULL THEN LET g_rmf.rmf121=0 END IF
    IF g_rmf.rmf13  IS NULL THEN LET g_rmf.rmf13=0  END IF
    IF g_rmf.rmf14  IS NULL THEN LET g_rmf.rmf14=0  END IF
    IF g_rmf.rmf16  IS NULL THEN LET g_rmf.rmf16=0  END IF
    IF g_rmf.rmf17  IS NULL THEN LET g_rmf.rmf17=0  END IF
    IF g_rmf.rmf22  IS NULL THEN LET g_rmf.rmf22=0  END IF
    IF g_rmf.rmf23  IS NULL THEN LET g_rmf.rmf23=0  END IF
    IF g_rmf.rmf24  IS NULL THEN LET g_rmf.rmf24=0  END IF
    LET g_rmf.rmf01     = g_rme.rme01
    SELECT MAX(rmf02)+1 INTO g_rmf.rmf02  FROM rmf_file
           WHERE rmf01=g_rme.rme01
    IF g_rmf.rmf02 IS NULL THEN LET g_rmf.rmf02=1 END IF
    LET g_rmf.rmf03     = t_rmp.rmp11
    LET g_rmf.rmf07     = t_rmp.rmp05
    LET g_rmf.rmf12     = t_rmp.rmp07
    LET g_rmf.rmf12     = s_digqty(g_rmf.rmf12,g_rmf.rmf04)   #FUN-910088--add--
   #-----MOD-950063---------
   #LET g_rmf.rmf21     = 'N'   #no:6935
    LET g_rmf.rmf21     = t_rmp.rmc09
   #-----END MOD-950063-----
    LET g_rmf.rmf22     = t_rmp.rmp07
    LET g_rmf.rmf22     = s_digqty(g_rmf.rmf22,g_rmf.rmf04)   #FUN-910088--add--
    LET g_rmf.rmf121    = t_rmp.rmp08
    LET g_rmf.rmf121    = s_digqty(g_rmf.rmf121,g_rmf.rmf04)  #FUN-910088--add--
    LET g_rmf.rmf14     = g_rmf.rmf12*g_rmf.rmf13
    LET g_rmf.rmf16     = 0
    LET g_rmf.rmf17     = 0
    LET g_rmf.rmf25     = l_rmp09
   #LET g_rmf.rmf25     = t_rmp.rmp09
    LET g_rmf.rmf33     = t_rmp.rmp03
    LET g_rmf.rmfplant = g_plant #FUN-980007
    LET g_rmf.rmflegal = g_legal #FUN-980007
    INSERT INTO rmf_file VALUES(g_rmf.*)
    IF SQLCA.sqlcode THEN
   #    CALL cl_err('t160_ins_rmf: ins rmf',SQLCA.sqlcode,1)# FUN-660111 
       CALL cl_err3("ins","rmf_file",g_rmf.rmf01,g_rmf.rmf02,SQLCA.sqlcode,"","t160_ins_rmf:",1) #FUN-660111
       LET g_success = 'N'  RETURN
    END IF
   # update rmp(by 覆出單,RMA單號,C/NO,料號,品名,原修護碼 )
    UPDATE rmp_file SET rmp04 = g_rmf.rmf02,
                     rmp09 = l_rmp09  #MOD-570357
     WHERE rmp00="1" AND rmp01=t_rmp.rmp01
       AND rmp05=t_rmp.rmp05 # AND rmp03=t_rmp.rmp03 NO:7260
     #------------------No.TQC-630150 modify
       AND rmp11=t_rmp.rmp11 
       AND (rmp13=t_rmp.rmp13 OR rmp13 IS NULL)
       AND rmp10=t_rmp.rmp10
     #------------------No.TQC-630150 end
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
    #   CALL cl_err('upd rmp:',SQLCA.sqlcode,1)# FUN-660111 
       CALL cl_err3("upd","rmp_file",t_rmp.rmp01,t_rmp.rmp11,SQLCA.sqlcode,"","upd rmp:",1) #FUN-660111
       LET g_success = 'N' RETURN
    END IF
END FUNCTION
 
FUNCTION t160_t1() #For RET# = 0(PART-NO='MISC'+品名)
 
  #LET w_sql = " SELECT rmp01,rmp05,rmp03,rmp11,rmp13,rmp10,rmp09,rmc03,",    #MOD-950063 mark   
   LET w_sql = " SELECT rmp01,rmp05,rmp03,rmp11,rmp13,rmp10,rmp09,rmc09,",    #MOD-950063 add
               " sum(rmp07),sum(rmp08) FROM rmp_file,rmc_file ",
  #LET w_sql = " SELECT *  FROM rmp_file ",
               " WHERE rmp01='",g_rme.rme01,"' AND rmp05='",g_rme.rme011,"'",
               "   AND rmp11 = 'MISC' AND rmp00='1' ",
               "   AND rmp05=rmc01 AND rmp06=rmc02 ",
               "   AND rmp01='",g_rme.rme01,"'",
              #" GROUP BY rmp01,rmp05,rmp06,rmp03,rmp11,rmp10,rmp13,rmp09,rmc03 ",  #MOD-950063 mark
               " GROUP BY rmp01,rmp05,rmp06,rmp03,rmp11,rmp10,rmp13,rmp09,rmc09 ",  #MOD-950063 add
               " ORDER BY 1,2,3,4,5,6,7 "           
              #" ORDER BY rmp02 "
 
   PREPARE t160_t0_prepare FROM w_sql
   DECLARE t160_t0_cs CURSOR FOR t160_t0_prepare
 
     LET g_success = 'Y'
     LET g_count=0
    #INITIALIZE l_rmp.*   TO NULL
     INITIALIZE t_rmp.*   TO NULL
     LET g_cnt=0
     FOREACH t160_t0_cs INTO t_rmp.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('RecLock:',SQLCA.sqlcode,0)     # 資料被他人LOCK
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF g_count=0 THEN
         DELETE FROM rmf_file WHERE rmf01=g_rme.rme01 AND rmf03='MISC'
      END IF
      CALL t160_ins_rmf0()
      IF g_success = 'N' THEN
         EXIT FOREACH
      END IF
      LET g_count   = g_count+1
     END FOREACH
     CLOSE t160_t0_cs
END FUNCTION
 
FUNCTION t160_ins_rmf0()  # add 覆出單單身: rmf_file (當執行 Z.取消確認時)
    DEFINE l_rmp09 like rmp_file.rmp09
 
   #IF t_rmp.rmp10 = '1' THEN #修復狀態                       #MOD-A30035 mark
    IF t_rmp.rmp10 = '1' OR t_rmp.rmp10 = '5' THEN #修復狀態  #MOD-A30035
       LET l_rmp09 = '5'            #修復已包裝
    ELSE
       LET l_rmp09 = '6'            #未修已包裝
    END IF
    INITIALIZE g_rmf.* TO NULL
    SELECT rmb02,rmb13,rmb04,rmb05,rmb06
      INTO g_rmf.rmf08,g_rmf.rmf13,g_rmf.rmf04,
           g_rmf.rmf06,g_rmf.rmf061
      FROM rmb_file WHERE rmb01=t_rmp.rmp05 AND rmb03=t_rmp.rmp11
                   #--------------No.TQC-630150 modify
                      AND (rmb05=t_rmp.rmp13 OR rmb05 IS NULL)
                   #--------------No.TQC-630150 end
    IF SQLCA.sqlcode THEN  #No.7926
   #    CALL cl_err('t160_ins_rmf0: sel rmb',SQLCA.sqlcode,1)# FUN-660111 
       CALL cl_err3("sel","rmb_file",t_rmp.rmp05,t_rmp.rmp11,SQLCA.sqlcode,"","t160_ins_rmf0:sel rmb",1) #FUN-660111
       LET g_success = 'N'  RETURN
    END IF
      IF g_rmf.rmf12  IS NULL THEN LET g_rmf.rmf12=0  END IF
      IF g_rmf.rmf121 IS NULL THEN LET g_rmf.rmf121=0 END IF
      IF g_rmf.rmf13  IS NULL THEN LET g_rmf.rmf13=0  END IF
      IF g_rmf.rmf14  IS NULL THEN LET g_rmf.rmf14=0  END IF
      IF g_rmf.rmf16  IS NULL THEN LET g_rmf.rmf16=0  END IF
      IF g_rmf.rmf17  IS NULL THEN LET g_rmf.rmf17=0  END IF
      IF g_rmf.rmf22  IS NULL THEN LET g_rmf.rmf22=0  END IF
      IF g_rmf.rmf23  IS NULL THEN LET g_rmf.rmf23=0  END IF
      IF g_rmf.rmf24  IS NULL THEN LET g_rmf.rmf24=0  END IF
      LET g_rmf.rmf01     = g_rme.rme01
      SELECT MAX(rmf02)+1 INTO g_rmf.rmf02 FROM rmf_file
             WHERE rmf01=g_rme.rme01
      IF g_rmf.rmf02=0 THEN LET g_rmf.rmf02=1 END IF
      LET g_rmf.rmf03     = t_rmp.rmp11
     #LET g_rmf.rmf04     = t_rmp.rmp12
     #LET g_rmf.rmf06     = t_rmp.rmp13
     #LET g_rmf.rmf061    = t_rmp.rmp14
      LET g_rmf.rmf07     = t_rmp.rmp05
      LET g_rmf.rmf12     = t_rmp.rmp07
      LET g_rmf.rmf12     = s_digqty(g_rmf.rmf12,g_rmf.rmf04)   #FUN-910088
      LET g_rmf.rmf22     = t_rmp.rmp07
      LET g_rmf.rmf22     = s_digqty(g_rmf.rmf22,g_rmf.rmf04)   #FUN-910088
      LET g_rmf.rmf121    = t_rmp.rmp08
      LET g_rmf.rmf121    = s_digqty(g_rmf.rmf121,g_rmf.rmf04)  #FUN-910088
     #LET g_rmf.rmf13     = 0
      LET g_rmf.rmf14     = g_rmf.rmf12*g_rmf.rmf13
     #LET g_rmf.rmf14     = 0
     #LET g_rmf.rmf08     = 0
      LET g_rmf.rmf25     = t_rmp.rmp09
      LET g_rmf.rmf33     = t_rmp.rmp03
      LET g_rmf.rmfplant = g_plant #FUN-980007
      LET g_rmf.rmflegal = g_legal #FUN-980007
      INSERT INTO rmf_file VALUES(g_rmf.*)
      IF SQLCA.sqlcode THEN
    #     CALL cl_err('t160_ins_rmf0: ins rmf0',SQLCA.sqlcode,1)# FUN-660111 
         CALL cl_err3("ins","rmf_file",g_rmf.rmf01,g_rmf.rmf02,SQLCA.sqlcode,"","t160_ins_rmf0: ins rmf0",1) #FUN-660111
         LET g_success = 'N'
         RETURN
      END IF
      UPDATE rmp_file            # update rmp(by 覆出單,項次)
       #SET rmp04 = g_rmf.rmf02,rmp09=l_rmp05
         SET rmp04 = g_rmf.rmf02,rmp09 =l_rmp09   #MOD-570357
        WHERE rmp00="1" AND rmp01=t_rmp.rmp01 AND rmp05=t_rmp.rmp05
        #--------------------------No.TQC-630150 modify
          AND rmp03=t_rmp.rmp03  AND rmp11=t_rmp.rmp11 
          AND (rmp13=t_rmp.rmp13 OR rmp13 IS NULL)
        #--------------------------No.TQC-630150 end
          AND rmp10=t_rmp.rmp10
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
 #        CALL cl_err('t160_ins_rmf0: up rmp',SQLCA.sqlcode,1)# FUN-660111 
         CALL cl_err3("upd","rmp_file",t_rmp.rmp01,t_rmp.rmp11,SQLCA.sqlcode,"","t160_ins_rmf0: up rmp",1) #FUN-660111
         LET g_success = 'N'
      END IF
END FUNCTION
 
FUNCTION t160_out()
DEFINE
    sr              RECORD
        rme01       LIKE rme_file.rme01,   # 覆出單單號
        rme011      LIKE rme_file.rme011,  # RMA 單單號
        rme02       LIKE rme_file.rme02,   # 單據日期
        rme03       LIKE rme_file.rme03,   # 客戶編號
        rme04       LIKE rme_file.rme04,   # 客戶簡稱
        rme21       LIKE rme_file.rme21,   # rmeark
        rmp06       LIKE rmp_file.rmp06,   # RMA單號之項次
        rmp03       LIKE rmp_file.rmp03,   # C/N
        rmp07       LIKE rmp_file.rmp07,   # 覆出數量
        rmp08       LIKE rmp_file.rmp08,   # 磁片數量
        rmp10       LIKE rmp_file.rmp10,   # 修復
        rmp11       LIKE rmp_file.rmp11,   # 料件編號
        rmp12       LIKE rmp_file.rmp12,   # 單位
        rmp13       LIKE rmp_file.rmp13,   # 品名
        rmp14       LIKE rmp_file.rmp14,   # 規格
        rmp15       LIKE rmp_file.rmp15,   # S/N
        rmp02       LIKE rmp_file.rmp02    # 項次
                    END RECORD,
    l_name          LIKE type_file.chr20                #External(Disk) file name  #No.FUN-690010 VARCHAR(20)
DEFINE l_sql        STRING                                                                                                          
                                                                                                                                    
                                                                                                                                    
    #No.FUN-860018 add---start                                                                                                      
    ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##                                                           
    CALL cl_del_data(l_table)                                                                                                       
    #------------------------------ CR (2) ------------------------------#                                                          
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog                                                                        
    #No.FUN-860018 add---end                                                                                                        
                                                         
 
    IF cl_null(g_rme.rme01) THEN
       CALL cl_err('','arm-019',0)
       RETURN
    END IF
    IF g_wc IS NULL THEN LET g_wc=" rme01='",g_rme.rme01,"'" END IF
    IF cl_null(g_wc2) THEN LET g_wc2=" 1=1 "  END IF    #No:7947
    CALL cl_wait()
#    LET l_name = 'armt160.out'
#    CALL cl_outnam('armt160') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql=" SELECT rme01,rme011,rme02,rme03,rme04,rme21,rmp06,rmp03, ",
              "  rmp07,rmp08,rmp10,rmp11,rmp12,rmp13,rmp14,rmp15,rmp02 ",
              " FROM rme_file,rmp_file",
              " WHERE rme01=rmp01 AND ",g_wc CLIPPED,
              " AND ",g_wc2 CLIPPED,
              " AND rmegen <> 'X' ",   #CHI-C80041
              " AND rmevoid = 'Y' "   #CHI-C80041
              
    PREPARE t160_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t160_co                         # SCROLL CURSOR
        CURSOR FOR t160_p1
 
#    START REPORT t160_rep TO l_name
 
    FOREACH t160_co INTO sr.*
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
        #No.FUN-860018 add---start                                                                                                  
        EXECUTE insert_prep USING sr.*                                                                                              
        IF SQLCA.sqlcode  THEN                                                                                                      
             CALL cl_err('insert_prep:',STATUS,1)                                                                                   
             EXIT FOREACH                                                                                                           
        END IF                                                                                                                      
        #----------------------CR (3)----------------------#                                                                        
        #No.FUN-860018 add---end  
#       OUTPUT TO REPORT t160_rep(sr.*)
    END FOREACH
    #No.FUN-860018 add---start                                                                                                      
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                                
    #是否列印選擇條件                                                                                                               
    IF g_zz05 = 'Y' THEN                                                                                                            
       CALL cl_wcchp(g_wc,'')                                                                                                       
            RETURNING tm.wc                                                                                                         
       LET g_str = tm.wc                                                                                                            
    ELSE                                                                                                                            
       LET g_str = ''                                                                                                               
    END IF                                                                                                                          
    LET g_str = g_str                                                                                                               
    CALL cl_prt_cs3('armt160','armt160',l_sql,g_str)                                                                                
    #------------------------------ CR (4) ------------------------------#                                                          
    #No.FUN-860018 add---end         
#    FINISH REPORT t160_rep
    CLOSE t160_co
    MESSAGE ""
#    CALL cl_prt(l_name,' ','1',g_len)
END FUNCTION
#No.FUN-860018---begin
#REPORT t160_rep(sr)
#DEFINE
#   l_last_sw       LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1),
#   sr              RECORD
#       rme01       LIKE rme_file.rme01,   # 覆出單單號
#       rme011      LIKE rme_file.rme011,  # RMA 單單號
#       rme02       LIKE rme_file.rme02,   # 單據日期
#       rme03       LIKE rme_file.rme03,   # 客戶編號
#       rme04       LIKE rme_file.rme04,   # 客戶簡稱
#       rme21       LIKE rme_file.rme21,   # rmeark
#       rmp06       LIKE rmp_file.rmp06,   # RMA單號之項次
#       rmp03       LIKE rmp_file.rmp03,   # C/N
#       rmp07       LIKE rmp_file.rmp07,   # 覆出數量
#       rmp08       LIKE rmp_file.rmp08,   # 磁片數量
#       rmp10       LIKE rmp_file.rmp10,   # 修復
#       rmp11       LIKE rmp_file.rmp11,   # 料件編號
#       rmp12       LIKE rmp_file.rmp12,   # 單位
#       rmp13       LIKE rmp_file.rmp13,   # 品名
#       rmp14       LIKE rmp_file.rmp14,   # 規格
#       rmp15       LIKE rmp_file.rmp15,   # S/N
#       rmp02       LIKE rmp_file.rmp02    # 項次
#                   END RECORD
 
#  OUTPUT
#  TOP MARGIN g_top_margin
#  LEFT MARGIN g_left_margin
#  BOTTOM MARGIN g_bottom_margin
#  PAGE LENGTH g_page_line
 
#  ORDER BY sr.rme01,sr.rmp06
 
#   FORMAT
#       PAGE HEADER
#          PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1 , g_company
#          PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#          LET g_pageno = g_pageno + 1
#          LET pageno_total = PAGENO USING '<<<',"/pageno"
#          PRINT COLUMN 01,g_x[9] CLIPPED,sr.rme01,
#                COLUMN 47,g_x[11] CLIPPED,sr.rme02
#          PRINT COLUMN 01,g_x[10] CLIPPED,sr.rme011,
#                COLUMN 47,g_x[12] CLIPPED,sr.rme03,"(",sr.rme04,")"
#          IF NOT cl_null(sr.rme21) THEN
#             PRINT COLUMN 01,g_x[17] CLIPPED,sr.rme21
#          ELSE
#             SKIP 1 LINE
#          END IF
#          PRINT g_head CLIPPED,pageno_total
#          PRINT g_dash
#          PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36],g_x[37],g_x[38]
#          PRINTX name=H2 g_x[39],g_x[40],g_x[41],g_x[42]
#          PRINTX name=H3 g_x[43],g_x[44]
#          PRINT g_dash1
#          LET l_last_sw = 'n'
 
#       BEFORE GROUP OF sr.rme01
#          SKIP TO TOP OF PAGE
 
#       ON EVERY ROW
#          PRINTX name=D1 COLUMN g_c[31],sr.rmp02 USING '###&',
#                         COLUMN g_c[32],sr.rmp06 USING '---&',
#                         COLUMN g_c[33],sr.rmp03 USING '---&',
#                         COLUMN g_c[34],cl_numfor(sr.rmp07,34,0),
#                         COLUMN g_c[35],cl_numfor(sr.rmp08,35,0),
#                         COLUMN g_c[36],sr.rmp11,
#                         COLUMN g_c[37],sr.rmp12,
#                         COLUMN g_c[38],sr.rmp15
 
#          PRINTX name=D2 COLUMN g_c[39],' ',
#                         COLUMN g_c[40],sr.rmp10,
#                         COLUMN g_c[41],' ',
#                         COLUMN g_c[42],sr.rmp13 CLIPPED
#          PRINTX name=D3 COLUMN g_c[43],' ',
#                         COLUMN g_c[44],sr.rmp14
 
#       ON LAST ROW
#           PRINT g_dash
#           PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#           LET l_last_sw = 'y'
 
#       PAGE TRAILER
#           IF l_last_sw = 'n'
#               THEN PRINT g_dash
#                    PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#               ELSE SKIP 2 LINES
#           END IF
#END REPORT
#No.FUN-860018---end
#No.FUN-890102
#Patch....NO.MOD-5A0095 <001> #
#CHI-C80041---begin
#FUNCTION t160_v()   #CHI-D20010
FUNCTION t160_v(p_type) #CHI-D20010
DEFINE   l_chr              LIKE type_file.chr1
DEFINE   l_flag             LIKE type_file.chr1  #CHI-D20010
DEFINE   p_type             LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_rme.rme01) THEN CALL cl_err('',-400,0) RETURN END IF  
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_rme.rmegen ='X' THEN RETURN END IF
   ELSE
      IF g_rme.rmegen <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t160_cl USING g_rme.rme01
   IF STATUS THEN
      CALL cl_err("OPEN t160_cl:", STATUS, 1)
      CLOSE t160_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t160_cl INTO g_rme.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rme.rme01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t160_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_rme.rmegen = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF g_rme.rmegen = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_rme.rmegen)   THEN  #CHI-D20010
   IF cl_void(0,0,l_flag)   THEN   #CHI-D20010
        LET l_chr=g_rme.rmegen
       #IF g_rme.rmegen='N' THEN #CHI-D20010
        IF p_type=1 THEN         #CHI-D20010
            LET g_rme.rmegen='X' 
        ELSE
            LET g_rme.rmegen='N'
        END IF
        UPDATE rme_file
            SET rmegen=g_rme.rmegen,  
                rmemodu=g_user,
                rmedate=g_today
            WHERE rme01=g_rme.rme01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","rme_file",g_rme.rme01,"",SQLCA.sqlcode,"","",1)  
            LET g_rme.rmegen=l_chr 
        END IF
        DISPLAY BY NAME g_rme.rmegen
   END IF
 
   CLOSE t160_cl
   COMMIT WORK
   CALL cl_flow_notify(g_rme.rme01,'V')
 
END FUNCTION
#CHI-C80041---end
