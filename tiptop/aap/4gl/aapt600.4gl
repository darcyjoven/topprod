# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aapt600.4gl
# Descriptions...: 集團代收付維護作業
# Date & Author..: 2006/09/26 By wujie
# Modify.........: No.FUN-6A0090 06/11/07 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0052 06/1114  By cl    處理內容同FUN-690090
# Modify.........: No.FUN-6B0033 06/11/27 By hellen 新增單頭折疊功能
# Modify.........: No.FUN-6B0079 06/11/24 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件" 
# Modify.........: No.TQC-6C0067 06/12/13 By wujie 1:帳款單身單據號不能重復?應為同一庫中帳款編號+子帳期項次不能重復,并且開窗查詢不到其他庫資料,開窗標題部分為英文?
#                                                  2:ringmenu action在中文下都顯示英文
#                                                  3:審核不過去,提示aap-982 衝帳金額加已衝金額不能大于帳款總金額加調匯金額
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730032 07/03/20 By wujie   網銀功能相關修改，nme新增欄位
# Modify.........: No.FUN-730064 07/04/03 By Lynn    會計科目加帳套
# Modify ........: No.TQC-740042 07/04/09 By johnray s_get_bookno和s_get_bookno1參數應先取出年份
# Modify.........: No.MOD-740193 07/04/22 By chenl   付款單身離開時出現訊息問"1.修改付款 2.. 3....',按1還是離開
# Modify.........: No.MOD-740346 07/04/23 By Rayven 若未使用網銀，不判斷是否未轉
# Modify.........: No.MOD-740255 07/04/24 By wujie   參數順序錯
# Modify.........: No.TQC-750040 07/05/10 By Carrier 確認時報-254錯誤
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760075 07/06/08 By Rayven 確認段所組SQL有問題
# Modify.........: No.MOD-7B0007 07/11/01 By Smapmin apc03為NOT NULL欄位
# Modify.........: No.FUN-7B0055 07/11/14 By Carrier CALL _oox()時考慮多帳期
# Modify.........: No.TQC-7C0050 07/12/06 By Smapmin 程式一開始就先預設主帳別/次帳別
# Modify.........: No.CHI-7C0033 07/12/31 By Smapmin 帳款資料帶出的匯率,應以當下工廠所對應的匯率為主
# Modify.........: No.MOD-7C0233 07/12/31 By Smapmin 修改帳款拋轉傳票後傳票是否確認的抓取來源
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-840409 08/04/25 By Carrier 修改q_m_apa的傳入參數,帳款開窗時,過濾簡稱的條件
# Modify.........: No.FUN-850038 08/05/12 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.TQC-860021 08/06/10 By Sarah PROMPT段漏了ON IDLE控制
# Modify.........: No.MOD-860257 08/07/01 By Sarah 1.t600_ins_apac()段,SELECT * INTO l_aqd.* FROM aqd_file WHERE aqd01 = p_plant應為g_plant
#                                                  2.aqe_file之確認碼為aqe14
# Modify.........: No.CHI-880003 08/08/06 By Sarah 將azr03改成azp01,抓azr_file的地方改抓azp_file
# Modify.........: No.MOD-8C0013 08/12/02 By sherry t600_sel_aqf_p沒有DECLARE
# Modify.........: No.FUN-8C0106 09/01/05 By jamie 依參數控管,檢查會科/部門/成本中心 AFTER FIELD 
# Modify.........: No.FUN-930106 09/03/16 By destiny 增加對aqe10付款理由的管控
# Modify.........: No.TQC-940085 09/04/16 By chenl 1.調用s_def_npq時，應傳入aapt330
# Modify.........:                                 2.增加分錄底稿關系人。
# Modify.........: No.TQC-940178 09/05/12 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.TQC-940038 09/06/05 By dxfwo   MSV bug 處理
# Modify.........: No.MOD-970273 09/07/30 By mike 目前會先判斷aph03 = "1"時,才為再判斷apz44來決定如何帶出摘要,請改為aph03="1" OR aph
# Modify.........: No.FUN-980001 09/08/04 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-960141 09/08/12 By lutingtingGP5.2 去除apaplant,apbplant
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/02 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980094 09/09/10 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-990069 09/09/25 By baofei GP集團架構修改,sub相關參數
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.FUN-9C0012 09/12/02 By ddestiny nem_file补PK，在insert表时给PK字段预设值
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡
# Modify.........: No.TQC-A10060 10/01/12 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A20062 10/03/02 By lutingting 拿掉參數apz26得判斷
# Modify.........: No:FUN-970077 10/03/08 By chenmoyan add aqg22,aqg23
# Modify.........: No.TQC-A30078 10/03/16 By Carrier q_apw传帐套
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->AAP
# Modify.........: No.FUN-A40055 10/04/28 By fumk 将多单身作业的construct和display array 改为DIALOG写法 
# Modify.........: No.TQC-A50030 10/05/12 By destiny 无法录入,有字段不在画面上
# Modify.........: No.FUN-A50102 10/06/01 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A60024 10/06/12 By wujie   新增apa79，预设值为 0 
# Modify.........: No:MOD-A70102 10/07/14 By Dido 帳款開窗需過濾付款日後的資料 
# Modify.........: No.FUN-950053 10/08/17 By vealxu 廠商基本資料的關係人設定搭配異動碼彈性設定
# Modify.........: No.CHI-A80036 10/08/31 By wuxj  整批确认时应对所有资料做检查
# Modify.........: No.FUN-A50110 10/09/01 By vealxu aapt600中的aqe11欄位管控的調整
# Modify.........: No.TQC-B10069 11/01/12 By lixh1 整批確認時,使用彙總訊息方式呈現批次確認範圍內的所有錯誤訊息
# Modify.........: No.FUN-AA0087 11/01/26 By chenmoyan 異動碼設定類型改善
# Modify.........: No:CHI-B10042 11/02/09 By Summer 將upd()段判斷狀況碼要為1.已核准才可以確認的段落往上搬到chk()段 
# Modify.........: No:TQC-B20128 11/02/21 By Sarah 整批確認檢查有錯誤要離開確認段時,要先將aapt600_6視窗關閉
# Modify.........: No:FUN-B20059 11/02/22 By wujie  科目自动开窗hard code修改
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 離開前未加cl_used(2)
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No:FUN-B40056 11/05/20 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No.FUN-B80105 11/08/10 By minpp程序撰寫規範修改
# Modify.........: No.FUN-B90062 11/09/14 By wujie 产生nme_file时同时产生tic_file   
# Modify.........: No.MOD-BB0212 11/11/21 By Dido 帳別預設值調整 

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:CHI-C30107 12/06/05 By yuhuabao 整批修改確認時先彈出窗口詢問再進行chk
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No:FUN-C80018 12/08/06 By minpp 大陸版時如果anmi030沒有維護單身時，anmt100單頭的簿號和支票號碼可以手動輸入
# Modify.........: No:MOD-CA0136 12/10/19 By 抓取付款單據性質增加項次條件
# Modify.........: No:FUN-D20035 13/02/20 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/01 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D60052 13/06/13 By wangrr 更改"現金異動碼"開窗

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_aqe           RECORD LIKE aqe_file.*,       #付款單   (假單頭)
    g_aqe_t         RECORD LIKE aqe_file.*,       #付款單   (舊值)
    g_aqe_o         RECORD LIKE aqe_file.*,       #付款單   (舊值)
    g_aqe01_t       LIKE aqe_file.aqe01,   # Pay No.     (舊值)
    g_aqf           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        aqf02            LIKE aqf_file.aqf02,
        aqf03            LIKE aqf_file.aqf03,
        aqf04            LIKE aqf_file.aqf04,
        aqf06            LIKE aqf_file.aqf06,
        apc04            LIKE apc_file.apc04,
        apa13            LIKE apa_file.apa13,
        apc06            LIKE apc_file.apc06,
        aqf05f           LIKE aqf_file.aqf05f,
        aqf05            LIKE aqf_file.aqf05,
        aqf11            LIKE aqf_file.aqf11,
        aqf12            LIKE aqf_file.aqf12,
        aqf13            LIKE aqf_file.aqf13,
        aqf14            LIKE aqf_file.aqf14,
        aqf15            LIKE aqf_file.aqf15,
        aqfud01		 LIKE aqf_file.aqfud01,
        aqfud02		 LIKE aqf_file.aqfud02,
        aqfud03		 LIKE aqf_file.aqfud03,
        aqfud04		 LIKE aqf_file.aqfud04,
        aqfud05		 LIKE aqf_file.aqfud05,
        aqfud06		 LIKE aqf_file.aqfud06,
        aqfud07		 LIKE aqf_file.aqfud07,
        aqfud08		 LIKE aqf_file.aqfud08,
        aqfud09		 LIKE aqf_file.aqfud09,
        aqfud10		 LIKE aqf_file.aqfud10,
        aqfud11		 LIKE aqf_file.aqfud11,
        aqfud12		 LIKE aqf_file.aqfud12,
        aqfud13		 LIKE aqf_file.aqfud13,
        aqfud14		 LIKE aqf_file.aqfud14,
        aqfud15		 LIKE aqf_file.aqfud15
                    END RECORD,
    g_aqf_t         RECORD                 #程式變數 (舊值)
        aqf02            LIKE aqf_file.aqf02,
        aqf03            LIKE aqf_file.aqf03,
        aqf04            LIKE aqf_file.aqf04,
        aqf06            LIKE aqf_file.aqf06,
        apc04            LIKE apc_file.apc04,
        apa13            LIKE apa_file.apa13,
        apc06            LIKE apc_file.apc06,
        aqf05f           LIKE aqf_file.aqf05f,
        aqf05            LIKE aqf_file.aqf05,
        aqf11            LIKE aqf_file.aqf11,
        aqf12            LIKE aqf_file.aqf12,
        aqf13            LIKE aqf_file.aqf13,
        aqf14            LIKE aqf_file.aqf14,
        aqf15            LIKE aqf_file.aqf15,
        aqfud01		 LIKE aqf_file.aqfud01,
        aqfud02		 LIKE aqf_file.aqfud02,
        aqfud03		 LIKE aqf_file.aqfud03,
        aqfud04		 LIKE aqf_file.aqfud04,
        aqfud05		 LIKE aqf_file.aqfud05,
        aqfud06		 LIKE aqf_file.aqfud06,
        aqfud07		 LIKE aqf_file.aqfud07,
        aqfud08		 LIKE aqf_file.aqfud08,
        aqfud09		 LIKE aqf_file.aqfud09,
        aqfud10		 LIKE aqf_file.aqfud10,
        aqfud11		 LIKE aqf_file.aqfud11,
        aqfud12		 LIKE aqf_file.aqfud12,
        aqfud13		 LIKE aqf_file.aqfud13,
        aqfud14		 LIKE aqf_file.aqfud14,
        aqfud15		 LIKE aqf_file.aqfud15
                    END RECORD,
    g_aqg           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        aqg02            LIKE aqg_file.aqg02,
        aqg03            LIKE aqg_file.aqg03,
        aqg04            LIKE aqg_file.aqg04,
        aqg08            LIKE aqg_file.aqg08,
        aqg22            LIKE aqg_file.aqg22,  #FUN-970077 add
        aqg23            LIKE aqg_file.aqg23,  #FUN-970077 add
        aqg05            LIKE aqg_file.aqg05,
        aqg051           LIKE aqg_file.aqg051,
        aqg11            LIKE aqg_file.aqg11,
        nmc02            LIKE nmc_file.nmc02,
        aqg07            LIKE aqg_file.aqg07,
        aqg09            LIKE aqg_file.aqg09,
        aqg10            LIKE aqg_file.aqg10,
        aqg06f           LIKE aqg_file.aqg06f,
        aqg06            LIKE aqg_file.aqg06,
        aqgud01		 LIKE aqg_file.aqgud01,
        aqgud02		 LIKE aqg_file.aqgud02,
        aqgud03		 LIKE aqg_file.aqgud03,
        aqgud04		 LIKE aqg_file.aqgud04,
        aqgud05		 LIKE aqg_file.aqgud05,
        aqgud06		 LIKE aqg_file.aqgud06,
        aqgud07		 LIKE aqg_file.aqgud07,
        aqgud08		 LIKE aqg_file.aqgud08,
        aqgud09		 LIKE aqg_file.aqgud09,
        aqgud10		 LIKE aqg_file.aqgud10,
        aqgud11		 LIKE aqg_file.aqgud11,
        aqgud12		 LIKE aqg_file.aqgud12,
        aqgud13		 LIKE aqg_file.aqgud13,
        aqgud14		 LIKE aqg_file.aqgud14,
        aqgud15		 LIKE aqg_file.aqgud15
                    END RECORD,
    g_aqg_t         RECORD
        aqg02            LIKE aqg_file.aqg02,
        aqg03            LIKE aqg_file.aqg03,
        aqg04            LIKE aqg_file.aqg04,
        aqg08            LIKE aqg_file.aqg08,
        aqg22            LIKE aqg_file.aqg22,  #FUN-970077 add
        aqg23            LIKE aqg_file.aqg23,  #FUN-970077 add
        aqg05            LIKE aqg_file.aqg05,
        aqg051           LIKE aqg_file.aqg051,
        aqg11            LIKE aqg_file.aqg11,
        nmc02            LIKE nmc_file.nmc02,
        aqg07            LIKE aqg_file.aqg07,
        aqg09            LIKE aqg_file.aqg09,
        aqg10            LIKE aqg_file.aqg10,
        aqg06f           LIKE aqg_file.aqg06f,
        aqg06            LIKE aqg_file.aqg06,
        aqgud01		 LIKE aqg_file.aqgud01,
        aqgud02		 LIKE aqg_file.aqgud02,
        aqgud03		 LIKE aqg_file.aqgud03,
        aqgud04		 LIKE aqg_file.aqgud04,
        aqgud05		 LIKE aqg_file.aqgud05,
        aqgud06		 LIKE aqg_file.aqgud06,
        aqgud07		 LIKE aqg_file.aqgud07,
        aqgud08		 LIKE aqg_file.aqgud08,
        aqgud09		 LIKE aqg_file.aqgud09,
        aqgud10		 LIKE aqg_file.aqgud10,
        aqgud11		 LIKE aqg_file.aqgud11,
        aqgud12		 LIKE aqg_file.aqgud12,
        aqgud13		 LIKE aqg_file.aqgud13,
        aqgud14		 LIKE aqg_file.aqgud14,
        aqgud15		 LIKE aqg_file.aqgud15
                    END RECORD,
    g_aqg_o         RECORD LIKE aqg_file.*,
    g_aps           RECORD LIKE aps_file.*,
    g_wc,g_wc2,g_wc3,g_sql    string,
    g_rec_b,g_rec_b2    LIKE type_file.num5,            #單身筆數
    m_aqe           RECORD LIKE aqe_file.*,
    m_aqf           RECORD LIKE aqf_file.*,
    m_aqg           RECORD LIKE aqg_file.*,
    g_buf           LIKE type_file.chr1000,             # #CHAR(78)
    g_aptype        LIKE aqe_file.aqe00, #帳款種類
    g_dbs_nm        LIKE type_file.chr21,       # #CHAR(21),
    g_qty1,g_qty2,g_qty3,g_qty4,g_qty5  LIKE type_file.num20_6,     #  DEC(20,6)
    g_statu         LIKE type_file.chr1,        # #CHAR(01),              #是否從新賦予等級
    g_note_days     LIKE type_file.num5,        # SMALLINT,              #最大票期
    g_add           LIKE type_file.chr1,        # #CHAR(1),               #是否為 Add Mode
    g_t1            LIKE oay_file.oayslip,      #單別  #CHAR(5)
    g_dbs_gl        LIKE type_file.chr21,       # #CHAR(21),              #工廠編號
    g_argv1         STRING,
    g_argv2         STRING,
    l_ac            LIKE type_file.num5        #目前處理的ARRAY CNT SMALLINT
DEFINE g_net            LIKE apv_file.apv04
DEFINE  g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE  g_before_input_done  LIKE type_file.num5    #SMALLINT
DEFINE  g_azi01         LIKE azi_file.azi01   #幣別
DEFINE  g_chr           LIKE type_file.chr1     #CHAR(1)
DEFINE  g_cnt           LIKE type_file.num10    #INTEGER
DEFINE  g_str           STRING    
DEFINE  g_wc_gl         STRING     
DEFINE  g_i             LIKE type_file.num5    #count/index for any purpose   SMALLINT
DEFINE  g_msg           LIKE type_file.chr1000 #CHAR(72)
DEFINE  g_row_count    LIKE type_file.num10    #INTEGER
DEFINE  g_curs_index   LIKE type_file.num10    #INTEGER
DEFINE  g_jump         LIKE type_file.num10    #INTEGER
DEFINE  g_no_ask       LIKE type_file.num5    #SMALLINT
DEFINE  g_void         LIKE type_file.chr1     #CHAR(1)
DEFINE  g_chr2          LIKE type_file.chr1    #CHAR(1)
DEFINE  g_chr3          LIKE type_file.chr1    #CHAR(1)
DEFINE  g_laststage    LIKE type_file.chr1     #CHAR(1)
DEFINE  g_aqf03       LIKE aqf_file.aqf03
DEFINE  g_aqf04       LIKE aqf_file.aqf04
DEFINE  g_aqf11       LIKE aqf_file.aqf11
DEFINE  g_aqf12       LIKE aqf_file.aqf12
DEFINE  g_aqf13       LIKE aqf_file.aqf13
DEFINE  g_amtf        LIKE aqf_file.aqf05f
DEFINE  g_amt         LIKE aqf_file.aqf05
DEFINE  g_apf01       LIKE apf_file.apf01
DEFINE g_azp03             LIKE azp_file.azp03    #No.FUN-730064
DEFINE g_bookno1           LIKE aza_file.aza81    #No.FUN-730064                                                                    
DEFINE g_bookno2           LIKE aza_file.aza82    #No.FUN-730064                                                                    
DEFINE g_bookno            LIKE aag_file.aag00    #No.FUN-730064                                                                    
DEFINE g_dbsm              LIKE type_file.chr21   #No.FUN-730064                                                                    
DEFINE g_plantm            LIKE type_file.chr10   #No.FUN-980020
DEFINE g_db_type           LIKE type_file.chr3    #No.FUN-730064
DEFINE       g_flag        LIKE type_file.chr1    #No.FUN-730064
DEFINE g_db1               LIKE type_file.chr21  #No.FUN-730064
DEFINE  g_b_flag        STRING                    #No.FUN-A40055
 
MAIN
  DEFINE g_argv1       LIKE aqe_file.aqe01
  DEFINE g_argv2       STRING                #執行功能
 
   OPTIONS
          INPUT NO WRAP
   DEFER INTERRUPT

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   CALL s_get_bookno('') RETURNING g_flag,g_bookno1,g_bookno2    #TQC-7C0050
 
   IF g_aza.aza70 <> 'Y' THEN                                                                                                       
      CALL cl_err('','aap-978',1)                                                                                                   
      EXIT PROGRAM                                                                                                                  
   END IF   
 
   LET g_argv1=ARG_VAL(1)
   LET g_argv2=ARG_VAL(2)
 
     CALL cl_used(g_prog,g_time,1) RETURNING g_time                 #No.FUN-6A0090                  

     IF fgl_getenv('EASYFLOW') = "1" THEN
        LET g_argv1 = aws_efapp_wsk(1)   #參數:key-1
     END IF
 
     LET g_forupd_sql = "SELECT * FROM aqe_file WHERE aqe01 = ? FOR UPDATE"
     LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
     DECLARE t600_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
     OPEN WINDOW t600_w WITH FORM "aap/42f/aapt600"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
     CALL cl_ui_init()

     CALL t600_set_comb()
     #如果由表單追蹤區觸發程式, 此參數指定為何種資料匣
     #當為 EasyFlow 簽核時, 加入 EasyFlow 簽核 toolbar icon
     CALL aws_efapp_toolbar()    
      
     IF g_aza.aza63 ='N' THEN   
       CALL cl_set_comp_visible("aqg051",FALSE)                                                                                    
     END IF       
     #FUN-970077---Begin
     IF g_aza.aza73  = 'Y' AND g_aza.aza26  = '0' THEN
        CALL cl_set_comp_visible("aqg22,aqg23",TRUE)
     ELSE
      CALL cl_set_comp_visible("aqg22,aqg23",FALSE)
     END IF
     #FUN-970077---End
 
     IF NOT cl_null(g_argv1) THEN
        CASE g_argv2
           WHEN "query"
              LET g_action_choice = "query"
              IF cl_chk_act_auth() THEN
                 CALL t600_q()
              END IF
           WHEN "insert"
              LET g_action_choice = "insert"
              IF cl_chk_act_auth() THEN
                 CALL t600_a()
              END IF
           WHEN "efconfirm"
              CALL t600_q()
              CALL s_showmsg_init()          #TQC-B10069
              LET g_success = 'Y'            #TQC-B10069
              CALL t600_firm1_chk()          #CALL 原確認的 check 段
              IF g_success = "Y" THEN               
                 CALL t600_firm1_upd()       #CALL 原確認的 update 段
              END IF
              CALL s_showmsg()               #TQC-B10069
              EXIT PROGRAM
           OTHERWISE
              CALL t600_q()
        END CASE
     END IF
 
     #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
     CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, undo_void,   FUN-D20035--add--undo_void
                                confirm, undo_confirm, easyflow_approval,account_detail,payment_detail,gen_entry,entry_sheet,entry_sheet2")    
          RETURNING g_laststage
 
     CALL t600_menu()
 
     CLOSE WINDOW t600_w

     CALL cl_used(g_prog,g_time,2) RETURNING g_time                 #No.FUN-6A0090
END MAIN
 
 
#QBE 查詢資料
FUNCTION t600_cs()
DEFINE   lc_qbe_sn   LIKE gbm_file.gbm01
DEFINE   l_dbs       LIKE type_file.chr21
 
   CLEAR FORM                             #清除畫面
   CALL g_aqf.clear()
   CALL g_aqg.clear()
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
   INITIALIZE g_aqe.* TO NULL    #No.FUN-750051
   #No.FUN-A40055--begin
   DIALOG ATTRIBUTES(UNBUFFERED)
      CONSTRUCT BY NAME g_wc ON aqe01,aqe02,aqeinpd,aqe03,aqe11,aqe12,aqe14,
                                aqemksg,aqe15,aqe06,aqe10,aqe13,
                                aqe04,aqe05,aqe08f,aqe09f,aqe08,
                                aqe09,aqeuser,aqegrup,aqemodu,
                                aqedate,aqeacti,
                                aqeud01,aqeud02,aqeud03,aqeud04,aqeud05,
                                aqeud06,aqeud07,aqeud08,aqeud09,aqeud10,
                                aqeud11,aqeud12,aqeud13,aqeud14,aqeud15
      BEFORE CONSTRUCT
          CALL cl_qbe_init()
      END CONSTRUCT 
      
      CONSTRUCT g_wc2 ON aqf02,aqf03,aqf04,aqf06,aqf05f,aqf05,aqf11,aqf12,aqf13,aqf14,aqf15
                        ,aqfud01,aqfud02,aqfud03,aqfud04,aqfud05
                        ,aqfud06,aqfud07,aqfud08,aqfud09,aqfud10
                        ,aqfud11,aqfud12,aqfud13,aqfud14,aqfud15
           FROM s_aqf[1].aqf02,s_aqf[1].aqf03,s_aqf[1].aqf04,
                s_aqf[1].aqf06,s_aqf[1].aqf05f,s_aqf[1].aqf05,
                s_aqf[1].aqf11,s_aqf[1].aqf12,s_aqf[1].aqf13,
                s_aqf[1].aqf14,s_aqf[1].aqf15
               ,s_aqf[1].aqfud01,s_aqf[1].aqfud02,s_aqf[1].aqfud03
               ,s_aqf[1].aqfud04,s_aqf[1].aqfud05,s_aqf[1].aqfud06
               ,s_aqf[1].aqfud07,s_aqf[1].aqfud08,s_aqf[1].aqfud09
               ,s_aqf[1].aqfud10,s_aqf[1].aqfud11,s_aqf[1].aqfud12
               ,s_aqf[1].aqfud13,s_aqf[1].aqfud14,s_aqf[1].aqfud15
 
 
      BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT  
      
      CONSTRUCT g_wc3 ON aqg02,aqg03,aqg04,aqg08,aqg22,aqg23,   #FUN-970077 add aqg22,aqg23
                         aqg05,aqg051,aqg11,aqg07,aqg09,aqg10,   
                         aqg06f,aqg06
                        ,aqgud01,aqgud02,aqgud03,aqgud04,aqgud05
                        ,aqgud06,aqgud07,aqgud08,aqgud09,aqgud10
                        ,aqgud11,aqgud12,aqgud13,aqgud14,aqgud15
            FROM s_aqg[1].aqg02,s_aqg[1].aqg03,s_aqg[1].aqg04,s_aqg[1].aqg08,
                 s_aqg[1].aqg22,s_aqg[1].aqg23,      #FUN-970077 add
                 s_aqg[1].aqg05,s_aqg[1].aqg051,s_aqg[1].aqg11,
                 s_aqg[1].aqg07,s_aqg[1].aqg09,s_aqg[1].aqg10,
                 s_aqg[1].aqg06f,s_aqg[1].aqg06
                ,s_aqg[1].aqgud01,s_aqg[1].aqgud02,s_aqg[1].aqgud03
                ,s_aqg[1].aqgud04,s_aqg[1].aqgud05,s_aqg[1].aqgud06
                ,s_aqg[1].aqgud07,s_aqg[1].aqgud08,s_aqg[1].aqgud09
                ,s_aqg[1].aqgud10,s_aqg[1].aqgud11,s_aqg[1].aqgud12
                ,s_aqg[1].aqgud13,s_aqg[1].aqgud14,s_aqg[1].aqgud15
 
      BEFORE CONSTRUCT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT
      
             
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(aqe01) #集團代付單號
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_aqe"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aqe01
               NEXT FIELD aqe01
            WHEN INFIELD(aqe03) #付款廠商
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pmc"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aqe03
               NEXT FIELD aqe03
            WHEN INFIELD(aqe04) # Employee CODE
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gen"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aqe04
               NEXT FIELD aqe04
            WHEN INFIELD(aqe05) # Dept CODE
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gem"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aqe05
               NEXT FIELD aqe05
            WHEN INFIELD(aqe06) # CURRENCY
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azi"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aqe06
               NEXT FIELD aqe06
            WHEN INFIELD(aqe10) # reason code
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azf01a"                #No.FUN-930106
               LET g_qryparam.arg1 = '8'                      #No.FUN-930106  
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aqe10
               NEXT FIELD aqe10
           #WHEN INFIELD(aqe12) # 現金變動碼 #TQC-D60052 mark
            WHEN INFIELD(aqe13) # 現金變動碼 #TQC-D60052
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_nml"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aqe13  #TQC-D60052 aqe12->aqe13
               NEXT FIELD aqe13  #TQC-D60052 aqe12->aqe13
            WHEN INFIELD(aqf03)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_azp"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aqf03
               NEXT FIELD aqf03
            WHEN INFIELD(aqf04)
               SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = g_plant 
               CALL q_m_apa(TRUE,TRUE,g_plant,g_aqe.aqe03,'*',       #FUN-990069
                           #g_aqe.aqe06,'1*',g_aqf[1].aqf04,g_aqe.aqe11)  #No.MOD-840409                 #MOD-A70102 mark
                            g_aqe.aqe06,'1*',g_aqf[1].aqf04,g_aqe.aqe11,g_aqe.aqe02)  #No.MOD-840409     #MOD-A70102
               RETURNING g_aqf[1].aqf04 # ,g_aqf[1].aqf06
               DISPLAY g_aqf[1].aqf04 TO aqf04
               NEXT FIELD aqf04
            WHEN INFIELD(aqf11)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_apr"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aqf11
               NEXT FIELD aqf11
            WHEN INFIELD(aqf12)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_pma"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aqf12
               NEXT FIELD aqf12
            WHEN INFIELD(aqf13)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_gec3"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aqf13
               NEXT FIELD aqf13
            WHEN INFIELD(aqf14)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_nma4"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aqf14
               NEXT FIELD aqf14
            WHEN INFIELD(aqf15)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_nmc02"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aqf15  
               NEXT FIELD aqf15 
             WHEN INFIELD(aqg03)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_azp"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aqg03
              NEXT FIELD arg03
           WHEN INFIELD(aqg08)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_nma"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aqg08
              NEXT FIELD aqg08
           #FUN-970077---Begin
           WHEN INFIELD(aqg22)
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_nnc1" 
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aqg22
              NEXT FIELD aqg22
           #FUN-970077--End
            WHEN INFIELD(aqg11)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_nmc"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO aqg11
               NEXT FIELD aqg11
           WHEN INFIELD(aqg05)
                 CALL q_aapact(TRUE,TRUE,'2',g_aqg[1].aqg05,g_bookno1)
                      RETURNING g_aqg[1].aqg05
              DISPLAY g_aqg[1].aqg05 TO aqg05
              NEXT FIELD aqg05
           WHEN INFIELD(aqg051)
                 CALL q_aapact(TRUE,TRUE,'2',g_aqg[1].aqg051,g_bookno2)
                      RETURNING g_aqg[1].aqg051
                 DISPLAY g_aqg[1].aqg051 TO aqg051
                 NEXT FIELD aqg051
           WHEN INFIELD(aqgvoid) # CURRENCY
              CALL cl_init_qry_var()
              LET g_qryparam.state = "c"
              LET g_qryparam.form ="q_azi"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO aqgvoid
              NEXT FIELD aqgvoid   
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION qbe_select
         CALL cl_qbe_list() RETURNING lc_qbe_sn
         CALL cl_qbe_display_condition(lc_qbe_sn)
   
     ON ACTION qbe_save
        CALL cl_qbe_save()
        
     ON ACTION accept
           EXIT DIALOG
   
     ON ACTION EXIT
        LET INT_FLAG = TRUE
        EXIT DIALOG 
      
     ON ACTION cancel
        LET INT_FLAG = TRUE
        EXIT DIALOG           
     END DIALOG
     #No.FUN-A40055--end
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aqeuser', 'aqegrup')
     IF cl_null(g_wc2) THEN
          # 客戶資料查詢
     LET g_wc2 = " 1=1"
     END IF
     IF cl_null(g_wc3) THEN
        # 料件資料查詢
     LET g_wc3 = " 1=1"
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG=0
        RETURN
     END IF

   IF g_wc3=" 1=1" THEN
      IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
         LET g_sql = "SELECT aqe01 FROM aqe_file ",
                     " WHERE ", g_wc CLIPPED,
                     "   AND aqe00 = '0'",
                     " ORDER BY aqe01"
      ELSE                              # 若單身有輸入條件
         LET g_sql = "SELECT UNIQUE aqe_file.aqe01 ",
                     "  FROM aqe_file, aqf_file ",
                     " WHERE aqe01 = aqf01",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     "   AND aqe00 = '0'",
                     " ORDER BY aqe01"
      END IF
   ELSE
      IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
         LET g_sql = "SELECT UNIQUE aqe_file.aqe01 ",
                     "  FROM aqe_file,aqg_file ",
                     " WHERE aqe01=aqg01 AND ", g_wc CLIPPED,
                     "   AND ",g_wc3 CLIPPED,
                     "   AND aqe00 = '0'",
                     " ORDER BY aqe01"
      ELSE                              # 若單身有輸入條件
         LET g_sql = "SELECT UNIQUE aqe_file.aqe01 ",
                     "  FROM aqe_file, aqf_file,aqg_file ",
                     " WHERE aqe01 = aqf01 AND aqe01=aqg01 ",
                     "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                     "   AND ",g_wc3 CLIPPED,
                     "   AND aqe00 = '0'",
                     " ORDER BY aqe01"
      END IF
   END IF
 
   PREPARE t600_prepare FROM g_sql
   DECLARE t600_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t600_prepare
 
   IF g_wc3=" 1=1" THEN
      IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
         LET g_sql="SELECT COUNT(*) FROM aqe_file WHERE ",g_wc CLIPPED,
                   "   AND aqe00 = '0'"
      ELSE
         LET g_sql="SELECT COUNT(DISTINCT aqe01) FROM aqe_file,aqf_file WHERE ",
                   "aqf01=aqe01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   "   AND aqe00 = '0'"
      END IF
   ELSE
      IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
         LET g_sql="SELECT COUNT(DISTINCT aqe01) ",
                   "   FROM aqe_file,aqg_file  WHERE ",g_wc CLIPPED,
                   "   AND aqe01=aqg01 AND ",g_wc3 CLIPPED,
                   "   AND aqe00 = '0'"
      ELSE
         LET g_sql="SELECT COUNT(DISTINCT aqe01) ",
                   "  FROM aqe_file,aqf_file,aqg_file  ",
                   "  WHERE aqf01=aqe01 AND aqe01=aqg01 ",
                   "    AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   "    AND ",g_wc3 CLIPPED,
                   "   AND aqe00 = '0'"
      END IF
   END IF
   PREPARE t600_precount FROM g_sql
   DECLARE t600_count CURSOR FOR t600_precount
END FUNCTION
 
FUNCTION t600_menu()
   DEFINe l_flowuser  LIKE type_file.chr1
   DEFINE l_creator   LIKE type_file.chr1
 
 
   WHILE TRUE
      CALL t600_bp("G")
      CASE g_action_choice
         WHEN "insert"
            LET g_add = 'Y'
            IF cl_chk_act_auth() THEN
               CALL t600_a()
            END IF
        #No.FUN-A40055--begin
         WHEN "detail" 
            IF cl_chk_act_auth() THEN  
               CASE g_b_flag
                   WHEN '1' CALL t600_b()
                   WHEN '2' CALL t600_b2()
               END CASE 
            ELSE    
               LET g_action_choice = NULL 
            END IF
            #No.FUN-A40055--end
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t600_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t600_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t600_u()
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t600_out('')
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "account_detail"
            IF cl_chk_act_auth() THEN
               CALL t600_b()
            END IF
         #No.FUN-A40055--begin 
#         WHEN "qry_account_detail"
#           IF cl_chk_act_auth() THEN
#              CALL t600_bp2('G')
#           ELSE
#              LET g_action_choice = NULL
#           END IF
         #No.FUN-A40055--end

         WHEN "payment_detail"
            IF cl_chk_act_auth() THEN
               CALL t600_b2()
            END IF
 
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL s_showmsg_init()          #TQC-B10069
               LET g_success = 'Y'            #TQC-B10069
               CALL t600_firm1_chk()          #CALL 原確認的 check 段 
               CALL t600_firm1_chk1()         #No.CHI-A80036  ---add---
               IF g_success = "Y" THEN   
                  CALL t600_firm1_upd()       #CALL 原確認的 update 段
               ELSE                           #TQC-B20128 add
                  CLOSE WINDOW t600_w6        #TQC-B20128 add
               END IF
               CALL s_showmsg()               #TQC-B10069 
               IF g_aqe.aqe14 = 'X' THEN      #MOD-860257 mod aqe13->aqe14
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
            END IF
 
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t600_firm2()
               IF g_aqe.aqe14 = 'X' THEN      #MOD-860257 mod aqe13->aqe14
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               IF g_aqe.aqe15 = '1' THEN
                  LET g_chr2='Y' ELSE LET g_chr2='N'
               END IF
               CALL cl_set_field_pic(g_aqe.aqe14,g_chr2,"","",g_void,g_aqe.aqeacti)   #MOD-860257 mod aqe13->aqe14
            END IF
 
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t600_x()                      #FUN-D20035
               CALL t600_x(1)                      #FUN-D20035
               IF g_aqe.aqe14 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               IF g_aqe.aqe15 = '1' THEN
                      LET g_chr2='Y'
               ELSE
                      LET g_chr2='N'
               END IF
               CALL cl_set_field_pic(g_aqe.aqe14,g_chr2,"","",g_void,g_aqe.aqeacti)
            END IF
   
          #FUN-D20035----add--str
          #取消作废
          WHEN "undo_void"
             IF cl_chk_act_auth() THEN
               CALL t600_x(2)               
               IF g_aqe.aqe14 = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               IF g_aqe.aqe15 = '1' THEN
                  LET g_chr2='Y'
               ELSE
                  LET g_chr2='N'
               END IF
               CALL cl_set_field_pic(g_aqe.aqe14,g_chr2,"","",g_void,g_aqe.aqeacti)
            END IF
          #FUN-D20035---add--end 
         #@WHEN "准"
         WHEN "agree"
            IF g_laststage = "Y" AND l_flowuser = "N" THEN  #最後一關並且沒有加>
               CALL s_showmsg_init()      #TQC-B10069 
               CALL t600_firm1_upd()      #CALL 原確認的 update 段
               CALL s_showmsg()           #TQC-B10069
            ELSE
               LET g_success = "Y"
               IF NOT aws_efapp_formapproval() THEN
                  LET g_success = "N"
               END IF
            END IF
            IF g_success = 'Y' THEN
               IF cl_confirm('aws-081') THEN  #詢問是否繼續下一筆資料的簽核
                  IF aws_efapp_getnextforminfo() THEN #取得下一筆簽核單號
                     LET l_flowuser = "N"
                     LET g_argv1 = aws_efapp_wsk(1)   #取得單號
                     IF NOT cl_null(g_argv1) THEN     #自動 query 帶出資料
                       CALL t600_q()
                      #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                       CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, undo_void,confirm, undo_confirm,    #FUN-D20035 ADD--undo_void
                                                  easyflow_approval,account_detail,payment_detail,gen_entry,entry_sheet,entry_sheet2")     
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
            LET l_creator = aws_efapp_backflow()
            IF l_creator IS NOT NULL THEN #退回關卡
               IF aws_efapp_formapproval() THEN
                  IF l_creator = "Y" THEN
                     LET g_aqe.aqe15= 'R'
                     DISPLAY BY NAME g_aqe.aqe15
                  END IF
                  IF cl_confirm('aws-081') THEN     #詢問是否繼續下一筆資料的簽>
                     IF aws_efapp_getnextforminfo() THEN #取得下一筆簽核單號
                       LET l_flowuser = "N"
                       LET g_argv1 = aws_efapp_wsk(1)    #取得單號
                       IF NOT cl_null(g_argv1) THEN      #自動 query 帶出資料
                          CALL t600_q()
                        #設定簽核功能及哪些 action 在簽核狀態時是不可被執行的
                          CALL aws_efapp_flowaction("insert, modify, delete, reproduce, detail, query,locale, void, undo_void,  #FUN-D20035 add--undo_void
                                                     confirm, undo_confirm, easyflow_approval,account_detail,payment_detail,gen_entry,entry_sheet,entry_sheet2")     
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
 
         WHEN "easyflow_approval"
           IF cl_chk_act_auth() THEN
                CALL t600_ef()
           END IF
 
         WHEN "approval_status"
           IF cl_chk_act_auth() THEN  #DISPLAY ONLY
              IF aws_condition2() THEN
                  CALL aws_efstat2()
              END IF
           END IF
 
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_aqe.aqe01 IS NOT NULL THEN
                 LET g_doc.column1 = "aqe01"
                 LET g_doc.value1 = g_aqe.aqe01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t600_a()
   DEFINE   li_result   LIKE type_file.num5     #SMALLINT
 
   IF s_aapshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_aqf.clear()
   CALL g_aqg.clear()
   INITIALIZE g_aqe.* LIKE aqe_file.*             #DEFAULT 設定
   LET g_aqe01_t = NULL
   #預設值及將數值類變數清成零
   LET g_aqe.aqe00='0'
   LET g_aqe.aqe02=g_today
   LET g_aqe.aqeinpd=g_today
   LET g_aqe.aqe06=g_aza.aza17
   LET g_aqe.aqe08=0
   LET g_aqe.aqe08f=0
   LET g_aqe.aqe09=0
   LET g_aqe.aqe09f=0
   LET g_aqe.aqe14='N'
   LET g_aqe_o.* = g_aqe.*
   LET g_aqe.aqemksg='N'
   LET g_aqe.aqe15='0'
   LET g_aqe.aqeprno=0
   LET g_aqe.aqeuser=g_user
   LET g_aqe.aqeoriu = g_user #FUN-980030
   LET g_aqe.aqeorig = g_grup #FUN-980030
   LET g_aqe.aqegrup=g_grup
   LET g_aqe.aqedate=g_today
   LET g_aqe.aqeacti='Y'              #資料有效
   LET g_aqe.aqelegal=g_legal
   LET g_note_days = 0
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL t600_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_aqe.* TO NULL
         EXIT WHILE
      END IF
      IF g_aqe.aqe01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK
         CALL s_auto_assign_no("aap",g_aqe.aqe01,g_aqe.aqe02,"35","aqe_file","aqe01","","","")
           RETURNING li_result,g_aqe.aqe01
         IF (NOT li_result) THEN
            CONTINUE WHILE
         END IF
      DISPLAY BY NAME g_aqe.aqe01
      INSERT INTO aqe_file VALUES (g_aqe.*)
 
 
      IF SQLCA.sqlcode THEN                     #置入資料庫不成功
         CALL cl_err3("ins","aqe_file",g_aqe.aqe01,"",SQLCA.sqlcode,"","",1)   #FUN-B80105
         ROLLBACK WORK  #
        #CALL cl_err3("ins","aqe_file",g_aqe.aqe01,"",SQLCA.sqlcode,"","",1)   #FUN-B80105
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_aqe.aqe01,'I')
      END IF
      SELECT aqe01 INTO g_aqe.aqe01 FROM aqe_file
       WHERE aqe01 = g_aqe.aqe01
      LET g_aqe01_t = g_aqe.aqe01        #保留舊值
      LET g_aqe_t.* = g_aqe.*
      CALL g_aqf.clear()
      CALL t600_b()                   #輸入單身-1
      SELECT COUNT(*) INTO g_cnt FROM aqf_file WHERE aqf01 = g_aqe.aqe01
      IF g_cnt = 0 THEN RETURN END IF
      CALL g_aqg.clear()
      CALL t600_b2()                   #輸入單身-2
 
      LET g_t1=s_get_doc_no(m_aqe.aqe01)  #wujie
      SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
      IF NOT cl_null(g_aqe.aqe01) AND g_apy.apyprint='Y' THEN  #是否馬上列印
          IF cl_confirm('mfg3242') THEN CALL t600_out('a') END IF
      END IF
      IF NOT cl_null(g_aqe.aqe01) AND g_apy.apydmy1='Y'       #確認
      AND g_apy.apyapr <> 'Y'
      THEN
         LET g_action_choice = "insert"
         CALL s_showmsg_init()          #TQC-B10069
         LET g_success = 'Y'            #TQC-B10069
         CALL t600_firm1_chk()          #CALL 原確認的 check 段
         IF g_success = "Y" THEN
            CALL t600_firm1_upd()       #CALL 原確認的 update 段
         END IF
         CALL s_showmsg()               #TQC-B10069 
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t600_u()
 
   IF s_aapshut(0) THEN RETURN END IF
   IF g_aqe.aqe01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_aqe.* FROM aqe_file
    WHERE aqe01=g_aqe.aqe01
 
   IF g_aqe.aqe14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF      #MOD-860257 mod aqe13->aqe14
 
   IF g_aqe.aqe14 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF   #MOD-860257 mod aqe13->aqe14
    IF g_aqe.aqe15 matches '[Ss]'
   THEN
         CALL cl_err('','apm-030',0)
         RETURN
   END IF
 
   IF g_aqe.aqeacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_aqe.aqe01,9027,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_aqe01_t = g_aqe.aqe01
   LET g_aqe_o.* = g_aqe.*
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t600_cl USING g_aqe.aqe01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t600_cl INTO g_aqe.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqe.aqe01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL t600_show()
   WHILE TRUE
      LET g_aqe01_t = g_aqe.aqe01
      LET g_aqe.aqemodu=g_user
      LET g_aqe.aqedate=g_today
      CALL t600_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         LET g_aqe.*=g_aqe_t.*
         CALL t600_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_aqe.aqe01 != g_aqe01_t THEN            # 更改單號
         UPDATE aqf_file SET aqf01 = g_aqe.aqe01
          WHERE aqf01 = g_aqe01_t
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","aqf_file",g_aqe01_t,"",SQLCA.sqlcode,"","upd aqf",1)  
            CONTINUE WHILE
         END IF
      END IF
       LET g_aqe.aqe15 = '0'     
      UPDATE aqe_file SET aqe_file.* = g_aqe.* WHERE aqe01 = g_aqe01_t
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","aqe_file",g_aqe01_t,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      END IF
         DISPLAY BY NAME g_aqe.aqe15             
        IF g_aqe.aqe14 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF   #MOD-860257 mod aqe13->aqe14
        IF g_aqe.aqe15 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        CALL cl_set_field_pic(g_aqe.aqe14,g_chr2,"","",g_void,g_aqe.aqeacti)   #MOD-860257 mod aqe13->aqe14
      EXIT WHILE
   END WHILE
   CLOSE t600_cl
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_aqe.aqe01,'U')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
#處理INPUT
FUNCTION t600_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入   #CHAR(1)
    p_cmd           LIKE type_file.chr1,                 #a:輸入 u:更改   #CHAR(1)
    l_paydate       LIKE type_file.dat,                     #   DATE
    l_yy,l_mm       LIKE type_file.num5     #SMALLINT
DEFINE  li_result   LIKE type_file.num5     #SMALLINT
DEFINE  l_aag05     LIKE aag_file.aag05    #FUN-8C0106   add
DEFINE  l_aag05_1   LIKE aag_file.aag05    #FUN-8C0106   add
 
    CALL cl_set_head_visible("","YES")      #No.FUN-6B0033	
 
    INPUT BY NAME 
          #g_aqe.aqeoriu,g_aqe.aqeorig,                                       #No.TQC-A50030
          g_aqe.aqe01 ,g_aqe.aqe02,g_aqe.aqeinpd,g_aqe.aqe03,g_aqe.aqe11,
          g_aqe.aqe12, g_aqe.aqe14,g_aqe.aqemksg,g_aqe.aqe15,g_aqe.aqe06,
          g_aqe.aqe10,g_aqe.aqe13,g_aqe.aqe04,g_aqe.aqe05,g_aqe.aqe08f,
          g_aqe.aqe09f,g_aqe.aqe08,g_aqe.aqe09,
          g_aqe.aqeuser,g_aqe.aqegrup,g_aqe.aqemodu,g_aqe.aqedate,g_aqe.aqeacti,
          g_aqe.aqeud01,g_aqe.aqeud02,g_aqe.aqeud03,g_aqe.aqeud04,
          g_aqe.aqeud05,g_aqe.aqeud06,g_aqe.aqeud07,g_aqe.aqeud08,
          g_aqe.aqeud09,g_aqe.aqeud10,g_aqe.aqeud11,g_aqe.aqeud12,
          g_aqe.aqeud13,g_aqe.aqeud14,g_aqe.aqeud15
        WITHOUT DEFAULTS
   
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t600_set_entry(p_cmd)
         CALL t600_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("aqe01")
 
        AFTER FIELD aqe01                  #帳款編號
          IF g_aqe.aqe01 IS NOT NULL  THEN
#              CALL s_check_no(g_sys,g_aqe.aqe01,g_aqe01_t,'35',"aqe_file","aqe01","") RETURNING li_result,g_aqe.aqe01
               CALL s_check_no("aap",g_aqe.aqe01,g_aqe01_t,'35',"aqe_file","aqe01","") RETURNING li_result,g_aqe.aqe01     #No.FUN-A40041
               DISPLAY BY NAME g_aqe.aqe01
               IF (NOT li_result) THEN
                  NEXT FIELD aqe01
               END IF
 
               LET g_t1=g_aqe.aqe01[1,g_doc_len]
           END IF
           SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
            IF p_cmd = 'a' THEN
              LET g_aqe.aqemksg = g_apy.apyapr
              LET g_aqe.aqe15 = "0"
           END IF
           IF g_apy.apykind !='35' THEN
              CALL cl_err(g_aqe.aqe01,'aap-008',1)
              LET g_aqe.aqe01 =NULL
              NEXT FIELD aqe01
           END IF
           IF g_apy.apydmy3 !='N' THEN
              CALL cl_err(g_aqe.aqe01,'anm-036',1)
              LET g_aqe.aqe01 =NULL
              NEXT FIELD aqe01
           END IF
           DISPLAY BY NAME g_aqe.aqemksg,g_aqe.aqe15
 
        AFTER FIELD aqe02                  #付款日期不可小於關帳日期
           IF NOT cl_null(g_aqe.aqe02) THEN
               CALL t600_bookno()           #No.FUN-730064                                                                
              IF g_aqe.aqe02 <= g_apz.apz57 THEN
                 CALL cl_err(g_aqe.aqe02,'aap-176',0)
                 NEXT FIELD aqe02
              END IF
              IF g_apz.apz27 = 'Y' THEN
                 LET l_yy = YEAR(g_aqe.aqe02)
                 LET l_mm = MONTH(g_aqe.aqe02)
                 IF (l_yy*12+l_mm) - (g_apz.apz21*12+g_apz.apz22) > 1 THEN
                    CALL cl_err(g_aqe.aqe02,'axr-405',0)
                 END IF
                 IF (l_yy*12+l_mm) - (g_apz.apz21*12+g_apz.apz22) = 0 THEN
                    CALL cl_err(g_aqe.aqe02,'axr-406',0) 
                 END IF
              END IF
           END IF
 
        BEFORE FIELD aqe03
         CALL t600_set_entry(p_cmd)
 
        AFTER FIELD aqe03
          IF NOT cl_null(g_aqe.aqe03) THEN
           IF p_cmd = 'a' OR g_aqe.aqe03 != g_aqe_o.aqe03
              OR g_aqe.aqe03 != g_aqe_o.aqe03 THEN
              CALL t600_aqe03('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_aqe.aqe03,g_errno,0)
                 LET g_aqe.aqe03 = g_aqe_o.aqe03
                 DISPLAY BY NAME g_aqe.aqe03
                 NEXT FIELD aqe03
              END IF
           END IF
           LET g_aqe_o.aqe03 = g_aqe.aqe03
           CALL t600_set_no_entry(p_cmd)
          END IF
 
        AFTER FIELD aqe11
            IF cl_null(g_aqe.aqe11) THEN NEXT FIELD aqe11 END IF
            IF g_aqe.aqe11[1,1]='.' THEN
               LET g_msg = g_aqe.aqe11[2,9]
               SELECT gen02 INTO g_aqe.aqe11 FROM gen_file WHERE gen01=g_msg
               DISPLAY BY NAME g_aqe.aqe11
               IF STATUS THEN NEXT FIELD aqe11 END IF
            END IF
 
        AFTER FIELD aqe12
         IF NOT cl_null(g_aqe.aqe12) AND g_aqe.aqe12 != g_aqe_t.aqe12 THEN
           CALL t600_input_apl()
         END IF
 
        AFTER FIELD aqe04
           IF NOT cl_null(g_aqe.aqe04) THEN
              IF p_cmd = 'a' OR g_aqe.aqe04 != g_aqe_t.aqe04 THEN
                 CALL t600_aqe04('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_aqe.aqe04,g_errno,0)
                    NEXT FIELD aqe04
                 END IF
              END IF
           END IF
 
        AFTER FIELD aqe05
           IF NOT cl_null(g_aqe.aqe05) THEN
              IF p_cmd = 'a' OR g_aqe.aqe05 != g_aqe_t.aqe05 THEN
                 CALL t600_aqe05('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_aqe.aqe05,g_errno,0)
                    NEXT FIELD aqe05
                 END IF
              END IF
 
             #防止User只修改部門欄位時,未再次檢查會科與允許/拒絕部門關係
              IF p_cmd = 'u' OR g_aqe.aqe05 != g_aqe_t.aqe05 THEN
                 LET l_aag05=''
                 SELECT aag05 INTO l_aag05 FROM aag_file
                  WHERE aag01 = g_aqg[l_ac].aqg05
                    AND aag00 = g_bookno1    
                 
                 LET g_errno = ' '   
                 IF l_aag05 = 'Y' AND NOT cl_null(g_aqg[l_ac].aqg05) THEN 
                   #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                    IF g_aaz.aaz90 !='Y' THEN
                       CALL s_chkdept(g_aaz.aaz72,g_aqg[l_ac].aqg05,g_aqe.aqe05,g_bookno1)  
                                     RETURNING g_errno
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err('',g_errno,0)
                       NEXT FIELD aqe05
                    END IF
                 END IF
                 
                #會計科目二
                 IF g_aza.aza63='Y' THEN
                    LET l_aag05_1=''
                    SELECT aag05 INTO l_aag05_1 FROM aag_file
                     WHERE aag01 = g_aqg[l_ac].aqg051
                       AND aag00 = g_bookno2    
                   
                    LET g_errno = ' '   
                    IF l_aag05_1 = 'Y' AND NOT cl_null(g_aqg[l_ac].aqg051) THEN
                      #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          CALL s_chkdept(g_aaz.aaz72,g_aqg[l_ac].aqg051,g_aqe.aqe05,g_bookno2) 
                                        RETURNING g_errno
                       END IF
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err('',g_errno,0)
                          NEXT FIELD aqe05
                       END IF
                    END IF
                 END IF
               END IF
 
           END IF
 
        AFTER FIELD aqe06
           IF NOT cl_null(g_aqe.aqe06) THEN
              IF p_cmd = 'a' OR g_aqe.aqe06 != g_aqe_t.aqe06 THEN
                 CALL t600_aqe06('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_aqe.aqe06,g_errno,0)
                    NEXT FIELD aqe06
                 END IF
              END IF
           END IF
 
        AFTER FIELD aqe10
           IF NOT cl_null(g_aqe.aqe10) THEN
              CALL t600_aqe10('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD aqe10
              END IF
           END IF
 
        AFTER FIELD aqe13
           IF NOT cl_null(g_aqe.aqe13) THEN
              SELECT COUNT(*) INTO g_cnt FROM nml_file
               WHERE nml01=g_aqe.aqe13
              IF g_cnt=0 THEN NEXT FIELD aqe13 END IF
           END IF
 
        AFTER FIELD aqemksg
           IF NOT cl_null(g_aqe.aqemksg) THEN
              IF g_aqe.aqemksg NOT MATCHES "[YN]" THEN NEXT FIELD aqe23 END IF
           END IF
 
        AFTER FIELD aqeud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqeud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_aqe.aqeuser = s_get_data_owner("aqe_file") #FUN-C10039
           LET g_aqe.aqegrup = s_get_data_group("aqe_file") #FUN-C10039
           LET l_flag='N'
           IF INT_FLAG THEN
              EXIT INPUT
           END IF
           IF g_aqe.aqe03 IS NULL THEN
              LET l_flag='Y'
              DISPLAY BY NAME g_aqe.aqe03
           END IF
           IF l_flag='Y' THEN
              CALL cl_err('','9033',0)
              NEXT FIELD aqe01
           END IF
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(aqe01) #集團代收付單號
                 LET g_t1=s_get_doc_no(g_aqe.aqe01)
                 CALL q_apy(FALSE,FALSE,g_t1,'35','AAP') RETURNING g_t1
                 LET g_aqe.aqe01=g_t1
                 DISPLAY BY NAME g_aqe.aqe01
                 NEXT FIELD aqe01
              WHEN INFIELD(aqe03) #PAY TO VENDOR
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_pmc"
                 LET g_qryparam.default1 = g_aqe.aqe03
                 CALL cl_create_qry() RETURNING g_aqe.aqe03
                 DISPLAY BY NAME g_aqe.aqe03
              WHEN INFIELD(aqe04) # Employee CODE
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gen"
                 LET g_qryparam.default1 = g_aqe.aqe04
                 CALL cl_create_qry() RETURNING g_aqe.aqe04
                 DISPLAY BY NAME g_aqe.aqe04
              WHEN INFIELD(aqe05) # Dept CODE
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 = g_aqe.aqe05
                 CALL cl_create_qry() RETURNING g_aqe.aqe05
                 DISPLAY BY NAME g_aqe.aqe05
              WHEN INFIELD(aqe06) # CURRENCY
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_aqe.aqe06
                 CALL cl_create_qry() RETURNING g_aqe.aqe06
                 DISPLAY BY NAME g_aqe.aqe06
              WHEN INFIELD(aqe10) # reason code
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azf01a"                 #No.FUN-930106
                 LET g_qryparam.arg1 = '8'                       #No.FUN-930106   
                 LET g_qryparam.default1 = g_aqe.aqe10
                 CALL cl_create_qry() RETURNING g_aqe.aqe10
                 DISPLAY BY NAME g_aqe.aqe10
              WHEN INFIELD(aqe13) # 現金變動碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_nml"
                 LET g_qryparam.default1 = g_aqe.aqe13
                 CALL cl_create_qry() RETURNING g_aqe.aqe13
                 DISPLAY BY NAME g_aqe.aqe13
              OTHERWISE EXIT CASE
        END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about
           CALL cl_about()
 
        ON ACTION help
           CALL cl_show_help()
 
    END INPUT
END FUNCTION
 
FUNCTION t600_aqe03(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1     #CHAR(1)
   DEFINE l_pmc22   LIKE pmc_file.pmc22
   DEFINE l_pmc24   LIKE pmc_file.pmc24
   DEFINE l_pmc03 LIKE pmc_file.pmc03
   DEFINE l_pmc05 LIKE pmc_file.pmc05
   DEFINE l_pmcacti LIKE pmc_file.pmcacti
 
   SELECT pmc22,pmc24,pmc03,pmc05,pmcacti
     INTO l_pmc22,l_pmc24,l_pmc03,l_pmc05,l_pmcacti
     FROM pmc_file
    WHERE pmc01 = g_aqe.aqe03
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-031'
        WHEN l_pmcacti = 'N'     LET g_errno = '9028'
        WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
 
        WHEN l_pmc05   = '0'     LET g_errno = 'aap-032'
        WHEN l_pmc05   = '3'     LET g_errno = 'aap-033'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF p_cmd = 'a' THEN
      LET g_aqe.aqe11 = l_pmc03
      LET g_aqe.aqe12 = l_pmc24
      LET g_aqe.aqe06 = l_pmc22
      DISPLAY BY NAME g_aqe.aqe11,g_aqe.aqe12,g_aqe.aqe06
   END IF
END FUNCTION
 
FUNCTION t600_aqe04(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1     #CHAR(1)
   DEFINE l_gen03   LIKE gen_file.gen03
   DEFINE l_genacti LIKE gen_file.genacti
 
   SELECT gen03,genacti INTO l_gen03,l_genacti
     FROM gen_file WHERE gen01 = g_aqe.aqe04
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-038'
        WHEN l_genacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF
   LET g_aqe.aqe05 = l_gen03
   DISPLAY BY NAME g_aqe.aqe05
END FUNCTION
 
FUNCTION t600_aqe05(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1     #CHAR(1)
   DEFINE l_gemacti LIKE gem_file.gemacti
 
   SELECT gemacti INTO l_gemacti
     FROM gem_file WHERE gem01 = g_aqe.aqe05
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-039'
        WHEN l_gemacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF
END FUNCTION
 
FUNCTION t600_aqe06(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1     #CHAR(1)
   DEFINE l_aziacti LIKE azi_file.aziacti
 
   SELECT aziacti INTO l_aziacti FROM azi_file WHERE azi01 = g_aqe.aqe06
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-002'
        WHEN l_aziacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
END FUNCTION
 
FUNCTION t600_aqg09(p_aqg09)
   DEFINE p_cmd   LIKE type_file.chr1     #CHAR(1)
   DEFINE l_aziacti LIKE azi_file.aziacti
   DEFINE p_aqg09   LIKE aqg_file.aqg09
 
   SELECT aziacti INTO l_aziacti FROM azi_file WHERE azi01 = p_aqg09
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-002'
        WHEN l_aziacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
END FUNCTION
 
FUNCTION t600_aqe10(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1     #CHAR(1)
   DEFINE l_azfacti LIKE azf_file.azfacti
   DEFINE l_azf03   LIKE azf_file.azf03
   DEFINE l_azf09   LIKE azf_file.azf09   #No.FUN-930106 
 

    SELECT azfacti,azf03,azf09 INTO l_azfacti,l_azf03,l_azf09 FROM azf_file
     WHERE azf01 = g_aqe.aqe10 AND azf02 = '2'
 
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
        WHEN l_azfacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
        WHEN l_azf09 !='8'       LET g_errno ='aoo-407'
   END CASE
   DISPLAY l_azf03 TO azf03
END FUNCTION
 
FUNCTION t600_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_aqe.* TO NULL               #No.FUN-6B0079  add
 
   CALL cl_msg("")                             
 
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_aqf.clear()
   CALL g_aqg.clear()
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t600_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL cl_msg(" SEARCHING ! ")                              
 
   OPEN t600_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_aqe.* TO NULL
   ELSE
      OPEN t600_count
      FETCH t600_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL t600_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   CALL cl_msg("")                             
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t600_fetch(p_flag)
DEFINE
   p_flag          LIKE type_file.chr1                  #處理方式   #CHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t600_cs INTO g_aqe.aqe01
      WHEN 'P' FETCH PREVIOUS t600_cs INTO g_aqe.aqe01
      WHEN 'F' FETCH FIRST    t600_cs INTO g_aqe.aqe01
      WHEN 'L' FETCH LAST     t600_cs INTO g_aqe.aqe01
      WHEN '/'
         IF NOT g_no_ask THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about
                  CALL cl_about()
 
               ON ACTION help
                  CALL cl_show_help()
 
               ON ACTION controlg
                  CALL cl_cmdask()
 
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump t600_cs INTO g_aqe.aqe01
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqe.aqe01,SQLCA.sqlcode,0)
      INITIALIZE g_aqe.* TO NULL  #TQC-6B0105
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
   SELECT * INTO g_aqe.* FROM aqe_file WHERE aqe01 = g_aqe.aqe01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aqe_file",g_aqe.aqe01,"",SQLCA.sqlcode,"","",1)
      INITIALIZE g_aqe.* TO NULL
      RETURN
   ELSE
      LET g_data_owner = g_aqe.aqeuser
      LET g_data_group = g_aqe.aqegrup
      CALL t600_bookno()
      CALL t600_show()
   END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t600_show()
   LET g_aqe_t.* = g_aqe.*                #保存單頭舊值
   DISPLAY BY NAME 
          g_aqe.aqeoriu,g_aqe.aqeorig,
          g_aqe.aqe01,g_aqe.aqe02,g_aqe.aqeinpd,g_aqe.aqe03,g_aqe.aqe11,
          g_aqe.aqe12,g_aqe.aqe14,g_aqe.aqemksg,g_aqe.aqe15,
          g_aqe.aqe06,g_aqe.aqe10,g_aqe.aqe13,g_aqe.aqe04,g_aqe.aqe05,
          g_aqe.aqe08f,g_aqe.aqe09f,
          g_aqe.aqe08,g_aqe.aqe09,
          g_aqe.aqeuser,g_aqe.aqegrup,g_aqe.aqemodu,g_aqe.aqedate,g_aqe.aqeacti,
          g_aqe.aqeud01,g_aqe.aqeud02,g_aqe.aqeud03,g_aqe.aqeud04,
          g_aqe.aqeud05,g_aqe.aqeud06,g_aqe.aqeud07,g_aqe.aqeud08,
          g_aqe.aqeud09,g_aqe.aqeud10,g_aqe.aqeud11,g_aqe.aqeud12,
          g_aqe.aqeud13,g_aqe.aqeud14,g_aqe.aqeud15
 
   CALL t600_aqe03('d')
   CALL t600_aqe10('d')
   CALL t600_b_fill(g_wc2)                 #單身
   CALL t600_b2_fill(g_wc3)                #單身
   IF g_aqe.aqe14 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF
   IF g_aqe.aqe15 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_aqe.aqe14,g_chr2,"","",g_void,g_aqe.aqeacti)
   CALL cl_show_fld_cont()
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t600_r()
DEFINE l_apa            DYNAMIC ARRAY OF RECORD
             apa01      LIKE apa_file.apa01
                        END RECORD
DEFINE i                LIKE type_file.num5           #SMALLINT
 
   IF s_aapshut(0) THEN RETURN END IF
   IF g_aqe.aqe01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_aqe.* FROM aqe_file
    WHERE aqe01=g_aqe.aqe01
   IF g_aqe.aqe14 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
   IF g_aqe.aqe14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_aqe.aqe15 matches '[Ss1]' THEN
      CALL cl_err("","mfg3557",0)
      RETURN
   END IF
 
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t600_cl USING g_aqe.aqe01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t600_cl INTO g_aqe.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqe.aqe01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL t600_show()
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "aqe01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_aqe.aqe01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM aqf_file WHERE aqf01 = g_aqe.aqe01
      IF STATUS THEN
         CALL cl_err3("del","aqf_file",g_aqe.aqe01,"",STATUS,"","del aqf:",1)  
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM aqg_file WHERE aqg01 = g_aqe.aqe01
      IF STATUS THEN
         CALL cl_err3("del","aqg_file",g_aqe.aqe01,"",STATUS,"","del aqg:",1) 
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM aqe_file WHERE aqe01 = g_aqe.aqe01
      IF STATUS THEN
         CALL cl_err3("del","aqe_file",g_aqe.aqe01,"",STATUS,"","del aqe:",1)  
         ROLLBACK WORK
         RETURN
      END IF
      INITIALIZE g_aqe.* TO NULL
      CLEAR FORM
      CALL g_aqf.clear()
      CALL g_aqg.clear()
      OPEN t600_count
      #FUN-B50062-add-start--
      IF STATUS THEN
         CLOSE t600_cl
         CLOSE t600_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      FETCH t600_count INTO g_row_count
      #FUN-B50062-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t600_cl
         CLOSE t600_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50062-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t600_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t600_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE
         CALL t600_fetch('/')
      END IF
   END IF
   CLOSE t600_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_aqe.aqe01,'D')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t600_g_b()
   CALL t600_g_b1()
END FUNCTION
 
FUNCTION t600_g_b1()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01
DEFINE body_sw          LIKE type_file.chr1     #CHAR(1)
DEFINE p05f,p05         LIKE type_file.num20_6  #DEC(20,6)
DEFINE l_aba19          LIKE aba_file.aba19
DEFINE l_apa44          LIKE apa_file.apa44
DEFINE g_t1             LIKE oay_file.oayslip   #CHAR(5)
DEFINE l_apydmy3        LIKE apy_file.apydmy3
DEFINE l_apz02b         LIKE apz_file.apz02b   #MOD-7C0233
 
 
 
   IF g_aqe.aqe01 IS NULL THEN RETURN END IF
 
 
   OPEN WINDOW t600_g_b_w AT 4,24 WITH FORM "aap/42f/aapt310_1"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("aapt310_1")
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
    
   INPUT BY NAME body_sw WITHOUT DEFAULTS
      AFTER FIELD body_sw
         IF NOT cl_null(body_sw) THEN
            IF body_sw NOT MATCHES "[12]" THEN
               NEXT FIELD body_sw
            END IF
         END IF
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
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t600_g_b_w
      RETURN
   END IF
 
   LET g_dbs_new = NULL
   CASE WHEN body_sw = '2'
             CLOSE WINDOW t600_g_b_w
             RETURN
        WHEN body_sw = '1'
 
 
           OPEN WINDOW t600_g_b_w2 AT 10,20 WITH FORM "aap/42f/aapt310_2"
                 ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
           CALL cl_ui_locale("aapt310_2")
           CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
           CONSTRUCT BY NAME g_wc2 ON azp01   #CHI-880003 mod azr03->azp01
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE CONSTRUCT
 
              ON ACTION about
                 CALL cl_about()
 
              ON ACTION help
                 CALL cl_show_help()
 
              ON ACTION controlg
                 CALL cl_cmdask()
 
              ON ACTION qbe_select
                 CALL cl_qbe_list() RETURNING lc_qbe_sn
                 CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
      CONSTRUCT BY NAME g_wc ON apa01,apa02,apa11,apa12,apa21,apa22
 
           BEFORE CONSTRUCT
              CALL cl_qbe_display_condition(lc_qbe_sn)
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
 
           ON ACTION about
              CALL cl_about()
 
           ON ACTION help
              CALL cl_show_help()
 
           ON ACTION controlg
              CALL cl_cmdask()
 
           ON ACTION qbe_save
              CALL cl_qbe_save()
      END CONSTRUCT
           CLOSE WINDOW t600_g_b_w2
 
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              CLOSE WINDOW t600_g_b_w
              RETURN
           END IF
   END CASE
   CLOSE WINDOW t600_g_b_w
 
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t600_cl USING g_aqe.aqe01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t600_cl INTO g_aqe.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqe.aqe01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t600_cl
      ROLLBACK WORK RETURN
   END IF
   LET l_ac = 1

#FUN-A50102--mod--str--
#  LET g_sql = "SELECT azp01 FROM azp_file",
#              " WHERE azp053 = 'Y'",    #ERP資料庫否
#              "   AND ",g_wc2 CLIPPED
   LET g_sql = "SELECT azw01 FROM azw_file",
               " WHERE azwacti = 'Y' ",
               "   AND azw01 IN(SELECT zxy03 FROM zxy_file ",
               "                 WHERE zxy01 = '",g_user,"')",
               "   AND ",g_wc2 CLIPPED
#FUN-A50102--mod--end
   PREPARE z6_pre FROM g_sql
   DECLARE z6_curs CURSOR WITH HOLD FOR z6_pre
   FOREACH z6_curs INTO g_plant_new
      IF STATUS THEN
         CALL cl_err('z6_curs',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
     #CALL s_getdbs()   #FUN-A50102
 
      IF g_apz.apz27 = 'N' THEN

         LET g_sql = "SELECT 0,'",g_plant_new,"',apa01,apc02,apc04,apa13,'',",  
                     "       apc08-apc10-apc16,0,'','','','','', ",   
                     "       azi01,apa44",   
                    #FUN-A50102--mod--str--
                    #"  FROM ",g_dbs_new CLIPPED,"apa_file LEFT OUTER JOIN ",g_dbs_new CLIPPED,"azi_file ON apa_file.apa13 = azi_file.azi01, ",
                    #          g_dbs_new CLIPPED,"apc_file ",
                     "  FROM ",cl_get_target_table(g_plant_new,'apa_file')," LEFT OUTER JOIN ",
                     "       ",cl_get_target_table(g_plant_new,'azi_file'),
                     "         ON apa_file.apa13 = azi_file.azi01, ",
                     "       ",cl_get_target_table(g_plant_new,'apc_file'), 
                    #FUN-A50102--mod--end
                     " WHERE ",g_wc CLIPPED,
                     "   AND apa06 = '",g_aqe.aqe03 CLIPPED,"'",
                     "   AND apa13 = '",g_aqe.aqe06 CLIPPED,"'",
                     "   AND apa01=apc01 ",
                     "   AND (apc08>(apc10 +apc16) OR apc09>(apc11+apc16*apa14)) ",    
                     "   AND apa00 LIKE '1%'",
                     "   AND apa41 = 'Y' AND apa42 = 'N'",
                     " ORDER BY apa01,apc02"
      ELSE

         LET g_sql = "SELECT 0,'",g_plant_new,"',apa01,apc02,apc04,apa13,'',", 
                     "       apc08-apc10-apc16,0,'','','','','',",   
                     "       azi01,apa44",   
                    #FUN-A50102--mod--str--
                    #"  FROM ",g_dbs_new CLIPPED,"apa_file LEFT OUTER JOIN ",g_dbs_new CLIPPED,"azi_file ON apa_file.apa13 = azi_file.azi01, ",
                    #          g_dbs_new CLIPPED,"apc_file ",
                     "  FROM ",cl_get_target_table(g_plant_new,'apa_file')," LEFT OUTER JOIN ",
                     "       ",cl_get_target_table(g_plant_new,'azi_file'),
                     "         ON apa_file.apa13 = azi_file.azi01, ",
                     "       ",cl_get_target_table(g_plant_new,'apc_file'),
                    #FUN-A50102--mod--end
                     " WHERE ",g_wc CLIPPED,
                     "   AND apa06 = '",g_aqe.aqe03 CLIPPED,"'",
                     "   AND apa13 = '",g_aqe.aqe06 CLIPPED,"'",
                     "   AND apa01 = apc01 ",
                     "   AND (apc08 >(apc10 +apc16) OR apc13>(apc16*apc07))",
                     "   AND apa00 LIKE '1%'",
                     "   AND apa41 = 'Y' AND apa42 = 'N'",
                     " ORDER BY apa01,apc02"
      END IF
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
   PREPARE t600_g_b_p1 FROM g_sql
   DECLARE t600_g_b_c1 CURSOR WITH HOLD FOR t600_g_b_p1
   FOREACH t600_g_b_c1 INTO g_aqf[l_ac].*, g_azi01,l_apa44   
      IF STATUS THEN CALL cl_err('for apa',STATUS,1) EXIT FOREACH END IF
 
      CALL s_curr3(g_aqf[l_ac].apa13,g_aqe.aqe02,g_apz.apz33)    
         RETURNING g_aqf[l_ac].apc06   
      LET g_aqf[l_ac].aqf05 = g_aqf[l_ac].aqf05f * g_aqf[l_ac].apc06   
 
      LET p05f=0 LET p05 =0
 
      SELECT SUM(aqf05f),SUM(aqf05) INTO p05f,p05
        FROM aqf_file,aqe_file   #CHI-7C0033
       WHERE aqf04 = g_aqf[l_ac].aqf04    #CHI-7C0033
         AND aqf06 = g_aqf[l_ac].aqf06 AND aqf01=aqe01 AND aqe14='N'
 
      IF p05f IS NULL THEN LET p05f=0 END IF
      IF p05  IS NULL THEN LET p05 =0 END IF
      LET g_aqf[l_ac].aqf05f=g_aqf[l_ac].aqf05f-p05f
      LET g_aqf[l_ac].aqf05 =g_aqf[l_ac].aqf05 -p05
      IF g_aqf[l_ac].aqf05f<=0 AND g_aqf[l_ac].aqf05 <=0 THEN
         CONTINUE FOREACH
      END IF
      #no.4642 若不可沖銷未拋轉傳票之應付帳款，則不自動產生
      IF g_apz.apz06 = 'N' THEN
         LET g_t1 = s_get_doc_no(g_aqf[l_ac].aqf04)
         SELECT apydmy3 INTO l_apydmy3 FROM apy_file WHERE apyslip=g_t1
         IF l_apydmy3 = 'Y' AND cl_null(l_apa44) THEN
            CONTINUE FOREACH
         END IF
      END IF
 
 
      #no.4642 若不可沖銷傳票未確認之應付帳款，則不自動產生
      IF NOT cl_null(l_apa44) AND g_apz.apz05 = 'N' THEN
         LET g_plant_new = g_aqf[l_ac].aqf03
        #CALL s_getdbs()   #FUN-A50102
        #LET g_sql = "SELECT apz02p,apz02b FROM ", g_dbs_new, "apz_file "   #FUN-A50102
         LET g_sql = "SELECT apz02p,apz02b FROM ",     #FUN-A50102
                      cl_get_target_table(g_plant_new,'apz_file')  #FUN-A50102 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
         PREPARE t600_apz02p_1 FROM g_sql
         DECLARE t600_apz02c_1 CURSOR FOR t600_apz02p_1
         OPEN t600_apz02c_1
         FETCH t600_apz02c_1 INTO g_plant_new,l_apz02b
         CLOSE t600_apz02c_1
        #CALL s_getdbs()   #FUN-A50102
         LET g_sql = "SELECT aba19 ",
                    #"  FROM ",g_dbs_new,"aba_file",   #FUN-A50102
                     "  FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                     "  WHERE aba01 = ? AND aba00 = ? "
 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
         PREPARE t600_p4x FROM g_sql 
         DECLARE t600_c4x CURSOR FOR t600_p4x
         OPEN t600_c4x USING l_apa44,l_apz02b   #MOD-7C0233
         FETCH t600_c4x INTO l_aba19
         IF cl_null(l_aba19) THEN LET l_aba19 = 'N' END IF
         LET g_plant_new = g_aqf[l_ac].aqf03   #MOD-7C0233
         CALL s_getdbs()   #MOD-7C0233
         IF l_aba19 = 'N' THEN CONTINUE FOREACH END IF
      END IF
      SELECT max(aqf02)+1 INTO g_aqf[l_ac].aqf02
        FROM aqf_file
       WHERE aqf01 = g_aqe.aqe01
 
      IF g_aqf[l_ac].aqf03 =g_plant THEN
         SELECT aqd03,aqd05,aqd08,aqd06,aqd15 INTO
                g_aqf[l_ac].aqf11,g_aqf[l_ac].aqf12,g_aqf[l_ac].aqf13,g_aqf[l_ac].aqf14,g_aqf[l_ac].aqf15
           FROM aqd_file
          WHERE aqd01 = g_aqf[l_ac].aqf03
      ELSE
         SELECT aqd03,aqd05,aqd08,aqd06,aqd16 INTO
                g_aqf[l_ac].aqf11,g_aqf[l_ac].aqf12,g_aqf[l_ac].aqf13,g_aqf[l_ac].aqf14,g_aqf[l_ac].aqf15
           FROM aqd_file
          WHERE aqd01 = g_aqf[l_ac].aqf03
      END IF
 
      IF g_aqf[l_ac].aqf02 IS NULL THEN LET g_aqf[l_ac].aqf02 = 1 END IF
      LET g_aqf[l_ac].aqf05 = cl_digcut(g_aqf[l_ac].aqf05,t_azi04)
      MESSAGE '>:',g_aqf[l_ac].aqf02,' ',
                   g_aqf[l_ac].aqf04,' ',g_aqf[l_ac].aqf05f
      LET g_t1 =g_aqe.aqe01[1,g_doc_len]
 
      IF cl_null(g_aqf[l_ac].aqf11) OR cl_null(g_aqf[l_ac].aqf12) OR cl_null(g_aqf[l_ac].aqf13) OR
         cl_null(g_aqf[l_ac].aqf14) OR cl_null(g_aqf[l_ac].aqf15) THEN
         CONTINUE FOREACH
      END IF
     
      INSERT INTO aqf_file(aqf00,aqf01,aqf02,aqf03,aqf04,aqf06,aqf05f,aqf05,
                           aqf11,aqf12,aqf13,aqf14,aqf15,aqflegal)   #FUN-960141 add 
       VALUES('0',g_aqe.aqe01,
              g_aqf[l_ac].aqf02,g_aqf[l_ac].aqf03,
              g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf06,g_aqf[l_ac].aqf05f,
              g_aqf[l_ac].aqf05,g_aqf[l_ac].aqf11,g_aqf[l_ac].aqf12,
              g_aqf[l_ac].aqf13,g_aqf[l_ac].aqf14,g_aqf[l_ac].aqf15,g_legal)  #FUN-960141 add
 
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","aqf_file",g_aqe.aqe01,g_aqf[l_ac].aqf02,SQLCA.sqlcode,"","",1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      LET l_ac = l_ac + 1
   END FOREACH
   END FOREACH
   IF g_success='Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
   CALL t600_b_fill(' 1=1')
   CALL t600_b2_fill(' 1=1')
END FUNCTION
 
FUNCTION t600_b()
DEFINE
   l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT   SMALLINT
   l_n             LIKE type_file.num5,                #檢查重複用   SMALLINT
   l_lock_sw       LIKE type_file.chr1,                #單身鎖住否   #CHAR(1)
   p_cmd           LIKE type_file.chr1,                #處理狀態   #CHAR(1)
   l_exit_sw       LIKE type_file.chr1,                #CHAR(1)
   l_allow_insert  LIKE type_file.num5,                #可新增否   SMALLINT
   l_allow_delete  LIKE type_file.num5,                #可刪除否   SMALLINT
   l_aqe15         LIKE aqe_file.aqe15,
   l_cnt           LIKE type_file.num5,                #SMALLINT
   l_dbs1          LIKE type_file.chr21,               #new db
   l_dbs           LIKE type_file.chr21,               #new db
   l_sql           STRING
DEFINE  l_gec04    LIKE gec_file.gec04
DEFINE  l_apa13    LIKE apa_file.apa13   #CHI-7C0033
DEFINE  l_apa14    LIKE apa_file.apa14   #CHI-7C0033
 
   LET g_action_choice = ""
   IF s_aapshut(0) THEN RETURN END IF
   IF g_aqe.aqe01 IS NULL THEN RETURN END IF
   SELECT * INTO g_aqe.* FROM aqe_file
    WHERE aqe01=g_aqe.aqe01
    LET l_aqe15 = g_aqe.aqe15
   IF g_aqe.aqe14 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
   IF g_aqe.aqe14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_aqe.aqeacti ='N' THEN CALL cl_err(g_aqe.aqe01,'9027',0) RETURN END IF
    IF g_aqe.aqe15 matches '[Ss]' THEN
         CALL cl_err('','apm-030',0)
         RETURN
    END IF
 
   SELECT COUNT(*) INTO g_rec_b FROM aqf_file WHERE aqf01=g_aqe.aqe01
   IF g_rec_b = 0 THEN
      CALL t600_g_b()            # Auto Generate Body
      CALL t600_b_fill(' 1=1')
   END IF
   IF g_apz.apz13 = 'Y' THEN
      SELECT * INTO g_aps.* FROM aps_file WHERE aps01=g_aqe.aqe05
   ELSE
      SELECT * INTO g_aps.* FROM aps_file WHERE (aps01 = ' ' OR aps01 IS NULL)
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT aqf02,aqf03,aqf04,aqf06,'','','',",
                      "       aqf05f,aqf05,aqf11,aqf12,aqf13,aqf14,aqf15,",
                      "       aqfud01,aqfud02,aqfud03,aqfud04,aqfud05,",
                      "       aqfud06,aqfud07,aqfud08,aqfud09,aqfud10,",
                      "       aqfud11,aqfud12,aqfud13,aqfud14,aqfud15 ",
                      " FROM aqf_file",
                      " WHERE aqf01=? AND aqf02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t600_b2cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET g_aqe.aqemodu=g_user
   LET g_aqe.aqedate=g_today
   DISPLAY BY NAME g_aqe.aqemodu,g_aqe.aqedate
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   WHILE TRUE
   LET l_exit_sw = 'y'
   INPUT ARRAY g_aqf WITHOUT DEFAULTS FROM s_aqf.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          BEGIN WORK
          LET g_success = 'Y'
          OPEN t600_cl USING g_aqe.aqe01
          IF STATUS THEN
             CALL cl_err("OPEN t600_cl:", STATUS, 1)
             CLOSE t600_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH t600_cl INTO g_aqe.*            # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_aqe.aqe01,SQLCA.sqlcode,0)      # 資料被他人LOCK
             CLOSE t600_cl
             ROLLBACK WORK
             RETURN
          END IF
          IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_aqf_t.* = g_aqf[l_ac].*  #BACKUP
             OPEN t600_b2cl USING g_aqe.aqe01,g_aqf_t.aqf02
             IF STATUS THEN
                CALL cl_err("OPEN t600_b2cl:", STATUS, 1)
                LET l_lock_sw = "Y"
             END IF
             FETCH t600_b2cl INTO g_aqf[l_ac].*
             IF SQLCA.sqlcode THEN
                CALL cl_err(g_aqf_t.aqf02,SQLCA.sqlcode,1)
                LET l_lock_sw = "Y"
             END IF
             LET g_aqf[l_ac].apc04 = g_aqf_t.apc04
             LET g_aqf[l_ac].apa13 = g_aqf_t.apa13
             LET g_aqf[l_ac].apc06 = g_aqf_t.apc06
             CALL cl_show_fld_cont()
          END IF
          CALL t600_set_entry(p_cmd)
          CALL t600_set_no_entry(p_cmd)
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_aqf[l_ac].* TO NULL  
          LET g_aqf[l_ac].aqf05f= 0
          LET g_aqf[l_ac].aqf05 = 0
          LET g_aqf_t.* = g_aqf[l_ac].*         #新輸入資料
          CALL cl_show_fld_cont()     
          NEXT FIELD aqf02
 
       AFTER INSERT
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             CANCEL INSERT
          END IF
          INSERT INTO aqf_file(aqf00,aqf01,aqf02,aqf03,aqf04,aqf06,aqf05f,
                               aqf05,aqf11,aqf12,aqf13,aqf14,aqf15,
                               aqfud01,aqfud02,aqfud03, aqfud04,aqfud05,aqfud06,
                               aqfud07,aqfud08,aqfud09, aqfud10,aqfud11,aqfud12,
                               aqfud13,aqfud14,aqfud15,aqflegal)  #FUN-960141 add
           VALUES(g_aqe.aqe00,g_aqe.aqe01,
                  g_aqf[l_ac].aqf02,g_aqf[l_ac].aqf03,
                  g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf06,
                  g_aqf[l_ac].aqf05f,g_aqf[l_ac].aqf05,
                  g_aqf[l_ac].aqf11,g_aqf[l_ac].aqf12,
                  g_aqf[l_ac].aqf13,g_aqf[l_ac].aqf14,
                  g_aqf[l_ac].aqf15,
                  g_aqf[l_ac].aqfud01, g_aqf[l_ac].aqfud02,
                  g_aqf[l_ac].aqfud03, g_aqf[l_ac].aqfud04,
                  g_aqf[l_ac].aqfud05, g_aqf[l_ac].aqfud06,
                  g_aqf[l_ac].aqfud07, g_aqf[l_ac].aqfud08,
                  g_aqf[l_ac].aqfud09, g_aqf[l_ac].aqfud10,
                  g_aqf[l_ac].aqfud11, g_aqf[l_ac].aqfud12,
                  g_aqf[l_ac].aqfud13, g_aqf[l_ac].aqfud14,
                  g_aqf[l_ac].aqfud15,g_legal)  #FUN-960141 add
 
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","aqf_file",g_aqe.aqe01,g_aqf[l_ac].aqf02,SQLCA.sqlcode,"","",1)
             CANCEL INSERT
             ROLLBACK WORK
          ELSE
             MESSAGE 'INSERT O.K'
             LET g_rec_b=g_rec_b+1
             DISPLAY g_rec_b TO FORMONLY.cn2
             IF g_success='Y' THEN
                COMMIT WORK
                 LET l_aqe15 = '0'
             ELSE
                ROLLBACK WORK
             END IF
          END IF
 
       BEFORE FIELD aqf02                        #default 序號
          IF g_aqf[l_ac].aqf02 IS NULL OR g_aqf[l_ac].aqf02 = 0 THEN
             SELECT max(aqf02)+1
               INTO g_aqf[l_ac].aqf02
               FROM aqf_file
              WHERE aqf01 = g_aqe.aqe01
             IF g_aqf[l_ac].aqf02 IS NULL THEN
                LET g_aqf[l_ac].aqf02 = 1
             END IF
          END IF
           CALL t600_set_entry_b(p_cmd)
 
       AFTER FIELD aqf02                        #check 序號是否重複
          IF g_aqf[l_ac].aqf02 IS NULL THEN
             LET g_aqf[l_ac].aqf02 = g_aqf_t.aqf02
             NEXT FIELD aqf02
          END IF
          IF g_aqf[l_ac].aqf02 != g_aqf_t.aqf02 OR
             g_aqf_t.aqf02 IS NULL THEN
              SELECT count(*)
                  INTO l_n
                  FROM aqf_file
                  WHERE aqf01 = g_aqe.aqe01
                    AND aqf02 = g_aqf[l_ac].aqf02
              IF l_n > 0 THEN
                  CALL cl_err('',-239,0)
                  LET g_aqf[l_ac].aqf02 = g_aqf_t.aqf02
                  NEXT FIELD aqf02
              END IF
          END IF
           CALL t600_set_no_entry_b(p_cmd)
 
       BEFORE FIELD aqf04
           IF g_aqf[l_ac].aqf03 MATCHES "[23]" THEN
              CALL cl_err('','aap-082',0)
              NEXT FIELD aqf02
           END IF
 
       AFTER FIELD aqf03
          IF NOT cl_null(g_aqf[l_ac].aqf03) THEN
             LET g_plant_new = g_aqf[l_ac].aqf03
             IF (g_plant_new!=g_plant) THEN
             IF NOT s_chknplt(g_plant_new,'AAP','AAP') THEN
                CALL cl_err(g_plant_new,g_errno,0)
                  NEXT FIELD aqf03
             END IF
             ELSE
                LET g_dbs_new = NULL
             END IF
             IF g_aqf_t.aqf03 IS NULL OR g_aqf[l_ac].aqf03 != g_aqf_t.aqf03 THEN
                CALL t600_aqf03()
                IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      LET g_aqf[l_ac].aqf03=g_aqf_t.aqf03
                      NEXT FIELD aqf03
                END IF
                CALL s_getdbs()
             END IF
          ELSE
          	 NEXT FIELD aqf03
          END IF
 
 
       AFTER FIELD aqf06
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM aqe_file,aqf_file
             WHERE aqe01 = aqf01 AND aqf04 = g_aqf[l_ac].aqf04 AND
                   aqe01 = g_aqe.aqe01 AND aqf06 = g_aqf[l_ac].aqf06
                   AND aqf03 =g_aqf[l_ac].aqf03         #No.TQC-6C0067
           IF g_aqf_t.aqf04 IS NULL OR
               g_aqf[l_ac].aqf04 != g_aqf_t.aqf04 THEN
	             IF l_cnt > 0 THEN
                  CALL cl_err('','aap-112',1)
                  NEXT FIELD aqf04
               END IF
           END IF
           IF NOT cl_null(g_aqf[l_ac].aqf06) THEN
              IF g_aqf_t.aqf06 IS NULL OR
                  g_aqf[l_ac].aqf04 != g_aqf_t.aqf04 OR
                  g_aqf[l_ac].aqf06 != g_aqf_t.aqf06 OR
                  g_aqf[l_ac].aqf03 != g_aqf_t.aqf03 THEN
                  CALL t600_aqf04('a')
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err('',g_errno,0)
                      LET g_aqf[l_ac].aqf04=g_aqf_t.aqf04
                      LET g_aqf[l_ac].aqf06=g_aqf_t.aqf06
                      DISPLAY BY NAME g_aqf[l_ac].aqf04
                      DISPLAY BY NAME g_aqf[l_ac].aqf06
                      NEXT FIELD aqf04
                  END IF
              END IF
           END IF
 
       BEFORE FIELD aqf05f
           LET g_sql = "SELECT apc08 ,apc10 ,apc16,apc08 -apc10 ",
                      #"  FROM ",g_dbs_new,"apc_file  ",  #FUN-A50102
                       "  FROM ",cl_get_target_table(g_plant_new,'apc_file'),   #FUN-A50102
                       " WHERE apc01 = ?  AND apc02=? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
           PREPARE t600_p4 FROM g_sql
           DECLARE t600_c4 CURSOR FOR t600_p4
           OPEN t600_c4 USING g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf06
           FETCH t600_c4 INTO g_qty1,g_qty2,g_qty3,g_qty4
           #考慮付款未確認部分
           LET g_sql = "SELECT SUM(aqf05f)",
                       "  FROM aqf_file,aqe_file",   #CHI-7C0033
                       " WHERE aqf04 = ? AND aqf06 = ? ",
                       "   AND aqf01 <> '",g_aqe.aqe01,"'",
                       "   AND aqf01 = aqe01 AND aqe14='N'"   #CHI-7C0033
           PREPARE t600_p5 FROM g_sql
           DECLARE t600_c5 CURSOR FOR t600_p5
           OPEN t600_c5 USING g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf06
           FETCH t600_c5 INTO g_qty5
           IF cl_null(g_qty5) THEN LET g_qty5=0 END IF
           IF g_qty4 < 0 THEN LET g_qty4 = 0 END IF
           LET g_qty4=g_qty4 - g_qty5
           CALL cl_getmsg('aap-061',g_lang) RETURNING g_msg
           LET g_msg[6,13] = g_qty1 USING '--------'
           LET g_msg[20,27] = g_qty2 USING '--------'
           LET g_msg[34,41] = g_qty3 USING '--------'
           LET g_msg[50,57] = g_qty5 USING '--------'
           ERROR g_msg CLIPPED,g_qty4 USING '--------'
           LET g_aqf_t.aqf05f = g_aqf[l_ac].aqf05f
 
       AFTER FIELD aqf05f
          IF NOT cl_null(g_aqf[l_ac].aqf05f) THEN
             IF g_aqf[l_ac].aqf05f > g_qty4 THEN
                CALL cl_err('','aap-069',1)
                NEXT FIELD aqf05f
             END IF
             IF g_aqf[l_ac].aqf05f = g_aqf_t.aqf05f THEN ELSE
                LET g_aqf[l_ac].aqf05=g_aqf[l_ac].aqf05f*g_aqf[l_ac].apc06
                CALL cl_digcut(g_aqf[l_ac].aqf05,t_azi04)
                     RETURNING g_aqf[l_ac].aqf05
                     DISPLAY BY NAME g_aqf[l_ac].aqf05
             END IF
          END IF
 
       BEFORE FIELD aqf05
 
           LET g_sql = "SELECT apc08 ,apc10 ,apc16,apc08 -apc10 ",
                      #"  FROM ",g_dbs_new,"apc_file  ",  #FUN-A50102
                       "  FROM ",cl_get_target_table(g_plant_new,'apc_file'),   #FUN-A50102 
                       " WHERE apc01 = ?  AND apc02=? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
           PREPARE t600_p6 FROM g_sql
           DECLARE t600_c6 CURSOR FOR t600_p6
           OPEN t600_c6 USING g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf06
           FETCH t600_c6 INTO g_qty1,g_qty2,g_qty3,g_qty4
          #LET g_sql = "SELECT apa13 FROM ",g_dbs_new,"apa_file ",  #FUN-A50102
           LET g_sql = "SELECT apa13 FROM ",cl_get_target_table(g_plant_new,'apa_file'), #FUN-A50102
                       " WHERE apa01 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
           CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
           PREPARE t600_p8 FROM g_sql
           DECLARE t600_c8 CURSOR FOR t600_p8
           OPEN t600_c8 USING g_aqf[l_ac].aqf04
           FETCH t600_c8 INTO l_apa13
           CALL s_curr3(l_apa13,g_aqe.aqe02,g_apz.apz33) 
                RETURNING l_apa14  
           LET g_qty1 = g_qty1 * l_apa14
           LET g_qty2 = g_qty2 * l_apa14
           LET g_qty3 = g_qty3 * l_apa14
           LET g_qty4 = g_qty4 * l_apa14
           LET g_sql = "SELECT SUM(aqf05)",
                       "  FROM aqf_file,aqe_file",   #CHI-7C0033
                       " WHERE aqf04 = ? AND aqf06 = ? ",
                       "   AND aqf01 <> '",g_aqe.aqe01,"'",
                       "   AND aqf01 = aqe01 AND aqe14='N'"   #CHI-7C0033
           PREPARE t600_p7 FROM g_sql
           DECLARE t600_c7 CURSOR FOR t600_p7
           OPEN t600_c7 USING g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf06
           FETCH t600_c7 INTO g_qty5
           IF cl_null(g_qty5) THEN LET g_qty5=0 END IF
           IF g_qty4 < 0 THEN LET g_qty4 = 0 END IF
           LET g_qty4=g_qty4 - g_qty5
           CALL cl_getmsg('aap-061',g_lang) RETURNING g_msg
           LET g_msg[6,13] = g_qty1 USING '--------'
           LET g_msg[20,27] = g_qty2 USING '--------'
           LET g_msg[34,41] = g_qty3 USING '--------'
           LET g_msg[50,57] = g_qty5 USING '--------'
           ERROR g_msg CLIPPED,g_qty4 USING '--------'
           LET g_aqf_t.aqf05 = g_aqf[l_ac].aqf05
 
 
       AFTER FIELD aqf05
          IF NOT cl_null(g_aqf[l_ac].aqf05) THEN
             IF g_aqf[l_ac].aqf05 > g_qty4 THEN
                CALL cl_err('','aap-069',1)
                NEXT FIELD aqf05
             END IF
             IF g_aqf[l_ac].aqf05 != g_aqf_t.aqf05 THEN
                CALL cl_digcut(g_aqf[l_ac].aqf05,t_azi04)
                     RETURNING g_aqf[l_ac].aqf05
                     DISPLAY BY NAME g_aqf[l_ac].aqf05
             END IF
          END IF
 
       AFTER FIELD aqf13
           IF NOT cl_null(g_aqf[l_ac].aqf13) THEN
              LET g_sql = "SELECT gec04",
                         #"  FROM ",g_dbs_new,"gec_file,",   #FUN-A50102
                          "  FROM ",cl_get_target_table(g_plant_new,'gec_file'),  #FUN-A50102 
                          " WHERE gec01 ='",g_aqf[l_ac].aqf13,
                          "   AND gec011='2'"
 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
              CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
              PREPARE t600_gec_p FROM g_sql
              DECLARE t600_gec_c CURSOR FOR t600_p7
              OPEN t600_gec_c
              FETCH t600_gec_c INTO l_gec04
              IF l_gec04 !='0' THEN
                 CALL cl_err(g_aqf[l_ac].aqf13,'aap-985',1)
                 LET g_aqf[l_ac].aqf13 =NULL
                 NEXT FIELD aqf13
              END IF
           END IF
           
 
 
      AFTER FIELD aqf11     #帳款類型
         IF NOT cl_null(g_aqf[l_ac].aqf11) THEN
            IF g_aqf[l_ac].aqf11 != g_aqf_t.aqf11 OR
               (NOT cl_null(g_aqf[l_ac].aqf11) AND cl_null(g_aqf_t.aqf11))  THEN
              #FUN-A50102--mod--str--
              #LET l_sql=" SELECT COUNT(apr01) FROM ",g_dbs_new CLIPPED,"apr_file ",  
               LET l_sql=" SELECT COUNT(apr01) FROM ",
                           cl_get_target_table(g_plant_new,'apr_file'),
              #FUN-A50102--mod--end
                         " WHERE apr01='",g_aqf[l_ac].aqf11,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
               PREPARE t600_sel_apr_p FROM l_sql
               DECLARE t600_sel_apr_c CURSOR FOR t600_sel_apr_p
               OPEN t600_sel_apr_c
               FETCH t600_sel_apr_c INTO g_cnt
               IF g_cnt =0 THEN
                  CALL cl_err3("sel","apr_file",g_aqf[l_ac].aqf11,"",SQLCA.sqlcode,"","sel apr_file",1)
                  LET g_aqf[l_ac].aqf11 = g_aqf_t.aqf11
                  NEXT FIELD aqf11
               END IF 
            END IF
         END IF
            
 
           
      AFTER FIELD aqf12         #付款條件
         IF NOT cl_null(g_aqf[l_ac].aqf12) THEN
            IF g_aqf[l_ac].aqf12 != g_aqf_t.aqf12 OR
               (NOT cl_null(g_aqf[l_ac].aqf12) AND cl_null(g_aqf_t.aqf12))  THEN
              #FUN-A50102--mod--str--
              #LET l_sql=" SELECT COUNT(pma01) FROM ",g_dbs_new CLIPPED,"pma_file ",
               LET l_sql=" SELECT COUNT(pma01) ",
                         "   FROM ",cl_get_target_table(g_plant_new,'pma_file'),
              #FUN-A50102--mod--end
                         "  WHERE pma01='",g_aqf[l_ac].aqf12,"' AND pmaacti='Y' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
               PREPARE t600_sel_pma_p FROM l_sql
               DECLARE t600_sel_pma_c CURSOR FOR t600_sel_pma_p
               OPEN t600_sel_pma_c
               FETCH t600_sel_pma_c INTO g_cnt
               IF g_cnt =0 THEN
                  CALL cl_err3("sel","pma_file",g_aqf[l_ac].aqf12,"",SQLCA.sqlcode,"","sel pma_file",1)
                  LET g_aqf[l_ac].aqf12 = g_aqf_t.aqf12
                  NEXT FIELD aqf12
               END IF 
            END IF
         END IF
           
 
      AFTER FIELD aqf14       #內部帳戶 
         IF NOT cl_null(g_aqf[l_ac].aqf14) THEN
            IF g_aqf[l_ac].aqf14 != g_aqf_t.aqf14 OR
               (NOT cl_null(g_aqf[l_ac].aqf14) AND cl_null(g_aqf_t.aqf14))  THEN
              #FUN-A50102--mod--str--
              #LET l_sql=" SELECT COUNT(nma01) FROM ",g_dbs_new CLIPPED,"nma_file ",
               LET l_sql=" SELECT COUNT(nma01) ",
                         "   FROM ",cl_get_target_table(g_plant_new,'nma_file'),
              #FUN-A50102--mod--end
                         "  WHERE nma01='",g_aqf[l_ac].aqf14,"' AND nma37='0' AND nmaacti='Y'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
               PREPARE t600_sel_nma_p FROM l_sql
               DECLARE t600_sel_nma_c CURSOR FOR t600_sel_nma_p
               OPEN t600_sel_nma_c
               FETCH t600_sel_nma_c INTO g_cnt
               IF g_cnt =0 THEN
                  CALL cl_err3("sel","nma_file",g_aqf[l_ac].aqf14,"",SQLCA.sqlcode,"","sel nma_file",1)
                  LET g_aqf[l_ac].aqf14 = g_aqf_t.aqf14
                  NEXT FIELD aqf14
               END IF 
            END IF
         END IF
 
 
      AFTER FIELD aqf15         #銀行存提異動碼-存碼
         IF NOT cl_null(g_aqf[l_ac].aqf15) THEN
            IF g_aqf[l_ac].aqf15 != g_aqf_t.aqf15 OR
               (NOT cl_null(g_aqf[l_ac].aqf15) AND cl_null(g_aqf_t.aqf15))  THEN
              #FUN-A50102--mod--str--
              #LET l_sql=" SELECT COUNT(nmc01) FROM ",g_dbs_new CLIPPED,"nmc_file ",
               LET l_sql=" SELECT COUNT(nmc01) ",
                         "   FROM ",cl_get_target_table(g_plant_new,'nmc_file'),
              #FUN-A50102--mod--end
                         " WHERE nmc01='",g_aqf[l_ac].aqf15,"' AND nmcacti='Y'"
               IF g_aqf[l_ac].aqf03 =g_plant THEN
                  LET l_sql =l_sql CLIPPED," AND nmc03 =1"
               ELSE
                  LET l_sql =l_sql CLIPPED," AND nmc03 =2"
               END IF
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
               PREPARE t600_sel_nmc_p FROM l_sql
               DECLARE t600_sel_nmc_c CURSOR FOR t600_sel_nmc_p
               OPEN t600_sel_nmc_c
               FETCH t600_sel_nmc_c INTO g_cnt
               IF g_cnt =0 THEN
                  CALL cl_err3("sel","nmc_file",g_aqf[l_ac].aqf15,"",SQLCA.sqlcode,"","sel nmc_file",1)
                  LET g_aqf[l_ac].aqf15 = g_aqf_t.aqf15
                  NEXT FIELD aqf15
               END IF 
            END IF
         END IF
 
        AFTER FIELD aqfud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqfud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
 
       BEFORE DELETE                            #是否取消單身
          IF g_aqf_t.aqf02 > 0 AND
             g_aqf_t.aqf02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM aqf_file
              WHERE aqf01 = g_aqe.aqe01
                AND aqf02 = g_aqf_t.aqf02
             IF SQLCA.sqlcode THEN
                CALL cl_err3("del","aqf_file",g_aqe.aqe01,g_aqf_t.aqf02,SQLCA.sqlcode,"","",1)  
                ROLLBACK WORK
                CANCEL DELETE
             END IF
             LET g_rec_b=g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
             LET g_plant_new = g_aqf_t.aqf03 CALL s_getdbs()
             IF g_success='Y' THEN
                CALL t600_b1_tot()
                COMMIT WORK
                 LET l_aqe15 = '0'
             ELSE
                ROLLBACK WORK
             END IF
          END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_aqf[l_ac].* = g_aqf_t.*
             CLOSE t600_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_aqf[l_ac].aqf02,-263,1)
             LET g_aqf[l_ac].* = g_aqf_t.*
          ELSE
             UPDATE aqf_file SET aqf02 = g_aqf[l_ac].aqf02,
                                 aqf03 = g_aqf[l_ac].aqf03,
                                 aqf04 = g_aqf[l_ac].aqf04,
                                 aqf05f = g_aqf[l_ac].aqf05f,
                                 aqf05 = g_aqf[l_ac].aqf05,
                                 aqf06 = g_aqf[l_ac].aqf06,
                                 aqf11 = g_aqf[l_ac].aqf11,
                                 aqf12 = g_aqf[l_ac].aqf12,
                                 aqf13 = g_aqf[l_ac].aqf13,
                                 aqf14 = g_aqf[l_ac].aqf14,
                                 aqf15 = g_aqf[l_ac].aqf15,
                                 aqfud01 = g_aqf[l_ac].aqfud01,
                                 aqfud02 = g_aqf[l_ac].aqfud02,
                                 aqfud03 = g_aqf[l_ac].aqfud03,
                                 aqfud04 = g_aqf[l_ac].aqfud04,
                                 aqfud05 = g_aqf[l_ac].aqfud05,
                                 aqfud06 = g_aqf[l_ac].aqfud06,
                                 aqfud07 = g_aqf[l_ac].aqfud07,
                                 aqfud08 = g_aqf[l_ac].aqfud08,
                                 aqfud09 = g_aqf[l_ac].aqfud09, 
                                 aqfud10 = g_aqf[l_ac].aqfud10,
                                 aqfud11 = g_aqf[l_ac].aqfud11,
                                 aqfud12 = g_aqf[l_ac].aqfud12,
                                 aqfud13 = g_aqf[l_ac].aqfud13,
                                 aqfud14 = g_aqf[l_ac].aqfud14,
                                 aqfud15 = g_aqf[l_ac].aqfud15
              WHERE aqf01=g_aqe.aqe01 AND aqf02=g_aqf_t.aqf02
 
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","aqf_file",g_aqe.aqe01,g_aqf_t.aqf02,SQLCA.sqlcode,"","",1)
                LET g_aqf[l_ac].* = g_aqf_t.*
                ROLLBACK WORK
             ELSE
                MESSAGE 'UPDATE O.K'
                IF g_success='Y' THEN
                   COMMIT WORK
                    LET l_aqe15 = '0'
                ELSE
                   ROLLBACK WORK
                END IF
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac  #FUN-D30032 mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                LET g_aqf[l_ac].* = g_aqf_t.*
             #FUN-D30032--add--str--
             ELSE 
                CALL g_aqf.deleteElement(l_ac)
                IF g_rec_b != 0 THEN 
                   LET INT_FLAG = 0
                   LET g_action_choice = "detail" 
                   LET g_b_flag = '1'
                   LET l_ac = l_ac_t
                END IF 
             #FUN-D30032--add--end--
             END IF
             CLOSE t600_b2cl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          LET l_ac_t = l_ac  #FUN-D30032
          CLOSE t600_b2cl
          COMMIT WORK
          CALL t600_b1_tot()
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(aqf03)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_azp"
                LET g_qryparam.default1 = g_aqf[l_ac].aqf03
                CALL cl_create_qry() RETURNING g_aqf[l_ac].aqf03
                DISPLAY g_aqf[l_ac].aqf03 TO aqf03
             WHEN INFIELD(aqf04)
                SELECT azp03 INTO l_dbs1 FROM azp_file WHERE azp01=g_aqf[l_ac].aqf03
                CALL q_m_apa(FALSE,TRUE,g_aqf[l_ac].aqf03,g_aqe.aqe03,'*',    #FUN-990069
                            #g_aqe.aqe06,'1*',g_aqf[l_ac].aqf04,g_aqe.aqe11)  #No.MOD-840409                 #MOD-A70102 mark
                             g_aqe.aqe06,'1*',g_aqf[l_ac].aqf04,g_aqe.aqe11,g_aqe.aqe02)  #No.MOD-840409     #MOD-A70102
                RETURNING g_aqf[l_ac].aqf04 ,g_aqf[l_ac].aqf06
                DISPLAY g_aqf[l_ac].aqf04 TO aqf04
            WHEN INFIELD(aqf11)
               SELECT azp03 INTO l_dbs1 FROM azp_file WHERE azp01=g_aqf[l_ac].aqf03
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_apr01"
               LET g_qryparam.plant = g_aqf[l_ac].aqf03  #No.FUN-980025 add
               LET g_qryparam.default1 = g_aqf[l_ac].aqf11
               CALL cl_create_qry() RETURNING g_aqf[l_ac].aqf11
               DISPLAY BY NAME g_aqf[l_ac].aqf11
               NEXT FIELD aqf11
            WHEN INFIELD(aqf12)
               SELECT azp03 INTO l_dbs1 FROM azp_file WHERE azp01=g_aqf[l_ac].aqf03
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pma2"
               LET g_qryparam.plant = g_aqf[l_ac].aqf03  #No.FUN-980025 add
               LET g_qryparam.default1 = g_aqf[l_ac].aqf12
               CALL cl_create_qry() RETURNING g_aqf[l_ac].aqf12
               DISPLAY BY NAME g_aqf[l_ac].aqf12
               NEXT FIELD aqf12
            WHEN INFIELD(aqf13)
               SELECT azp03 INTO l_dbs1 FROM azp_file WHERE azp01=g_aqf[l_ac].aqf03
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gec3"
               LET g_qryparam.plant = g_aqf[l_ac].aqf03  #No.FUN-980025 add
               LET g_qryparam.default1 = g_aqf[l_ac].aqf13
               CALL cl_create_qry() RETURNING g_aqf[l_ac].aqf13
               DISPLAY BY NAME g_aqf[l_ac].aqf13
               NEXT FIELD aqf13
            WHEN INFIELD(aqf14)
               SELECT azp03 INTO l_dbs1 FROM azp_file WHERE azp01=g_aqf[l_ac].aqf03
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_nma3"
               LET g_qryparam.plant = g_aqf[l_ac].aqf03  #No.FUN-980025 add
               LET g_qryparam.default1 = g_aqf[l_ac].aqf14
               CALL cl_create_qry() RETURNING g_aqf[l_ac].aqf14
               DISPLAY BY NAME g_aqf[l_ac].aqf14
               NEXT FIELD aqf14
            WHEN INFIELD(aqf15)
               SELECT azp03 INTO l_dbs1 FROM azp_file WHERE azp01=g_aqf[l_ac].aqf03
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_nmc03"
               LET g_qryparam.plant = g_aqf[l_ac].aqf03  #No.FUN-980025 add
               IF g_aqf[l_ac].aqf03 =g_plant THEN
                  LET g_qryparam.arg1 ='1'
               ELSE
                  LET g_qryparam.arg1 ='2'
               END IF
               LET g_qryparam.default1 = g_aqf[l_ac].aqf15
               CALL cl_create_qry() RETURNING g_aqf[l_ac].aqf15
               DISPLAY BY NAME g_aqf[l_ac].aqf15
               NEXT FIELD aqf15
             OTHERWISE
                EXIT CASE
       END CASE
 
       ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(aqf02) AND l_ac > 1 THEN
               LET g_aqf[l_ac].* = g_aqf[l_ac-1].*
               LET g_aqf[l_ac].aqf02 = NULL   
               NEXT FIELD aqf02
           END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       	
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END INPUT
   UPDATE aqe_file SET aqemodu=g_aqe.aqemodu,aqe15=l_aqe15,
                       aqedate=g_aqe.aqedate
    WHERE aqe01=g_aqe.aqe01
   LET g_aqe.aqe15 = l_aqe15
   DISPLAY BY NAME g_aqe.aqe15
   IF g_aqe.aqe14 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF
   IF g_aqe.aqe15 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_aqe.aqe14,g_chr2,"","",g_void,g_aqe.aqeacti)
 
   IF g_aqe.aqe09f != 0 AND g_aqe.aqe09f != g_aqe.aqe08f THEN
      WHILE TRUE
         IF g_aqe.aqe09f < g_aqe.aqe08f THEN                 # 付不足
            CALL cl_getmsg('aap-070',g_lang) RETURNING g_msg
         END IF
         IF g_aqe.aqe09f > g_aqe.aqe08f THEN   # 付超過
            CALL cl_getmsg('aap-983',g_lang) RETURNING g_msg
         END IF
         WHILE TRUE
            LET g_chr=' '
            LET INT_FLAG = 0
            PROMPT g_msg CLIPPED FOR CHAR g_chr
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about         #TQC-860021
                  CALL cl_about()      #TQC-860021
 
               ON ACTION help          #TQC-860021
                  CALL cl_show_help()  #TQC-860021
 
               ON ACTION controlg      #TQC-860021
                  CALL cl_cmdask()     #TQC-860021
            END PROMPT
            IF INT_FLAG THEN LET INT_FLAG = 0 END IF
            IF g_chr MATCHES "[12Ee]" THEN EXIT WHILE END IF
         END WHILE
         IF g_chr MATCHES '[Ee]' THEN LET l_exit_sw = 'y' EXIT WHILE END IF
         IF g_chr = '2' THEN LET l_exit_sw = 'n' EXIT WHILE END IF
         IF g_chr = '1' THEN
            LET l_n = ARR_COUNT()
            CALL t600_b2()
         END IF
         EXIT WHILE
      END WHILE
   END IF
 
   IF l_exit_sw = 'y' THEN
      EXIT WHILE
   ELSE
      CONTINUE WHILE
   END IF
   END WHILE
   CALL t600_b1_tot()
   CLOSE t600_b2cl
   IF g_success='Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
END FUNCTION
 
FUNCTION t600_b1_tot()
   SELECT SUM(aqf05f),SUM(aqf05) INTO g_aqe.aqe08f,g_aqe.aqe08 FROM aqf_file
    WHERE aqf01=g_aqe.aqe01
   IF g_aqe.aqe08f IS NULL THEN LET g_aqe.aqe08f=0 END IF
   IF g_aqe.aqe08  IS NULL THEN LET g_aqe.aqe08 =0 END IF
   DISPLAY BY NAME g_aqe.aqe08f,g_aqe.aqe08
   UPDATE aqe_file SET aqe08f=g_aqe.aqe08f,
                       aqe08 =g_aqe.aqe08
    WHERE aqe01=g_aqe.aqe01
END FUNCTION
 
FUNCTION t600_b2_tot()
   SELECT SUM(aqg06f),SUM(aqg06) INTO g_aqe.aqe09f,g_aqe.aqe09 FROM aqg_file
    WHERE aqg01=g_aqe.aqe01
   IF g_aqe.aqe09f IS NULL THEN LET g_aqe.aqe09f=0 END IF
   IF g_aqe.aqe09  IS NULL THEN LET g_aqe.aqe09 =0 END IF
   DISPLAY BY NAME g_aqe.aqe09f,g_aqe.aqe09
   UPDATE aqe_file SET aqe09f=g_aqe.aqe09f,
                       aqe09 =g_aqe.aqe09
    WHERE aqe01=g_aqe.aqe01
END FUNCTION
 
FUNCTION t600_aqf03()
   DEFINE p_cmd   LIKE type_file.chr1     #CHAR(1)
   DEFINE l_aqdacti LIKE aqd_file.aqdacti
   DEFINE l_aqd   RECORD LIKE aqd_file.*
 
   SELECT * INTO l_aqd.* FROM aqd_file WHERE aqd01 = g_aqf[l_ac].aqf03
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-981'
        WHEN l_aqd.aqdacti = 'N'     LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF cl_null(g_errno) THEN
      LET g_aqf[l_ac].aqf11 =l_aqd.aqd03
      LET g_aqf[l_ac].aqf12 =l_aqd.aqd05
      LET g_aqf[l_ac].aqf13 =l_aqd.aqd08
      LET g_aqf[l_ac].aqf14 =l_aqd.aqd06
      IF (g_aqf[l_ac].aqf03 !=g_plant) THEN
         LET g_aqf[l_ac].aqf15 =l_aqd.aqd16
      ELSE
      	 LET g_aqf[l_ac].aqf15 =l_aqd.aqd15
      END IF
   END IF
END FUNCTION
 
FUNCTION t600_aqf04(p_cmd)
   DEFINE p_cmd           LIKE type_file.chr1     #CHAR(1)
   DEFINE l_amtf,l_amt    LIKE type_file.num20_6  #DEC(20,6)
   DEFINE l_apa00         LIKE apa_file.apa00
   DEFINE l_apa06         LIKE apa_file.apa06
   DEFINE l_apa07         LIKE apa_file.apa07
   DEFINE l_apa08         LIKE apa_file.apa08
   DEFINE l_apa13         LIKE apa_file.apa13
   DEFINE l_apc06         LIKE apc_file.apc06
   DEFINE l_apa20         LIKE apa_file.apa20
   DEFINE l_apc16         LIKE apc_file.apc16
   DEFINE l_apa21         LIKE apa_file.apa21
   DEFINE l_apa22         LIKE apa_file.apa22
   DEFINE l_apa41         LIKE apa_file.apa41
   DEFINE l_apa42         LIKE apa_file.apa42
   DEFINE l_apa34         LIKE apa_file.apa34
   DEFINE l_apa34f        LIKE apa_file.apa34f
   DEFINE l_apc08         LIKE apc_file.apc08
   DEFINE l_apc09         LIKE apc_file.apc09
   DEFINE l_apa35         LIKE apa_file.apa35
   DEFINE l_apa35f        LIKE apa_file.apa35f
   DEFINE l_apc10         LIKE apc_file.apc10
   DEFINE l_apc11         LIKE apc_file.apc11
   DEFINE l_apc13         LIKE apc_file.apc13
   DEFINE l_aqf05f        LIKE aqf_file.aqf05f
   DEFINE l_aqf05         LIKE aqf_file.aqf05
   DEFINE l_apc07         LIKE apc_file.apc07
   DEFINE l_aba19         LIKE aba_file.aba19
   DEFINE l_apa44         LIKE apa_file.apa44
   DEFINE l_amt3          LIKE apa_file.apa73   
   DEFINE g_t1            LIKE oay_file.oayslip      #CHAR(5)
   DEFINE l_apydmy3       LIKE apy_file.apydmy3  
   DEFINE l_apz02b         LIKE apz_file.apz02b   #MOD-7C0233
 
 
 
   LET g_errno = ' '
   LET g_plant_new = g_aqf[l_ac].aqf03
   CALL s_getdbs()
 
   IF g_apz.apz27 = 'N' THEN
      LET g_sql = "SELECT apc04,apa13,'',apc08-apc10-apc16,0,",   
                  " apa06,apa07,apa21,apa22,apa13,apa00,apa41,apa42,apa08,apa44 ",   
                 #FUN-A50102--mod--str--
                 #"  FROM ",g_dbs_new,"apa_file, ",
                 #          g_dbs_new,"apc_file  ",
                  "  FROM ",cl_get_target_table(g_plant_new,'apa_file'),
                  "      ,",cl_get_target_table(g_plant_new,'apc_file'),
                 #FUN-A50102--mod--end 
                  "  WHERE apa01 = ? AND apc02=? ",
                  "    AND apa01=apc01 ",
                  #"    AND apa00[1,1] = '1'"   #No.FUN-A40055
                  "    AND apa00 LIKE '1%'"     #No.FUN-A40055
   ELSE
      LET g_sql = "SELECT apc04,apa13,'',apc08-apc10-apc16,0,",  
                  " apa06,apa07,apa21,apa22,apa13,apa00,apa41,apa42,apa08,apa44 ",   
                 #FUN-A50102--mod--str--
                 #"  FROM ",g_dbs_new,"apa_file, ",
                 #          g_dbs_new,"apc_file  ",
                  "  FROM ",cl_get_target_table(g_plant_new,'apa_file'),
                  "      ,",cl_get_target_table(g_plant_new,'apc_file'),
                 #FUN-A50102--mod--end
                  "  WHERE apa01 = ? AND apc02=? ",
                  "    AND apa01=apc01 ",
                  #"    AND apa00[1,1] = '1'"   #No.FUN-A40055
                  "    AND apa00 LIKE '1%'"     #No.FUN-A40055
   END IF

 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE t600_p3 FROM g_sql DECLARE t600_c3 CURSOR FOR t600_p3
   OPEN t600_c3 USING g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf06
   FETCH t600_c3 INTO g_aqf[l_ac].apc04,g_aqf[l_ac].apa13,g_aqf[l_ac].apc06,
                      l_amtf,l_amt,l_apa06,l_apa07,l_apa21,l_apa22,l_apa13,
                      l_apa00,l_apa41,l_apa42,l_apa08,l_apa44   
   CALL s_curr3(l_apa13,g_aqe.aqe02,g_apz.apz33) RETURNING g_aqf[l_ac].apc06 
   LET l_amt = l_amtf* g_aqf[l_ac].apc06 
   DISPLAY BY NAME g_aqf[l_ac].apc04
   DISPLAY BY NAME g_aqf[l_ac].apc06
   IF p_cmd = 'd' THEN RETURN END IF
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-075'
      WHEN l_apa41  = 'N'         LET g_errno = 'aap-141'
      WHEN l_apa42  = 'Y'         LET g_errno = 'aap-165'
      WHEN l_apa08  = 'UNAP'      LET g_errno = 'aap-015'
      WHEN l_apa06 != g_aqe.aqe03 LET g_errno = 'aap-040'
      WHEN l_apa07 != g_aqe.aqe11 LET g_errno = 'aap-155'
      WHEN l_apa13 != g_aqe.aqe06 LET g_errno = 'aap-041'
      WHEN l_amtf<=0 AND l_amt<=0 LET g_errno = 'aap-076'
      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
    IF g_apz.apz06 = 'N' THEN
       LET g_t1 = s_get_doc_no(g_aqf[l_ac].aqf04)
       SELECT apydmy3 INTO l_apydmy3 FROM apy_file WHERE apyslip=g_t1
       IF l_apydmy3 = 'Y' AND cl_null(l_apa44) THEN
          LET g_errno='aap-109'
       END IF
    END IF
   IF NOT cl_null(l_apa44) AND g_apz.apz05 = 'N' THEN
      LET g_plant_new = g_aqf[l_ac].aqf03
      CALL s_getdbs()
      #LET g_sql = "SELECT apz02p,apz02b FROM ", g_dbs_new, "apz_file "   #FUN-A50102
      LET g_sql = "SELECT apz02p,apz02b FROM ",cl_get_target_table(g_plant_new,'apz_file') #FUN-A50102
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
      PREPARE t600_apz02p_2 FROM g_sql
      DECLARE t600_apz02c_2 CURSOR FOR t600_apz02p_2
      OPEN t600_apz02c_2
      FETCH t600_apz02c_2 INTO g_plant_new,l_apz02b
      CLOSE t600_apz02c_2
      CALL s_getdbs()
      LET g_sql = "SELECT aba19 ",
                 #"  FROM ",g_dbs_new,"aba_file",  #FUN-A50102
                  "  FROM ",cl_get_target_table(g_plant_new,'aba_file'),  #FUN-A50102 
                  "  WHERE aba01 = ? AND aba00 = ? "
 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
      PREPARE t600_p3x FROM g_sql 
      DECLARE t600_c3x CURSOR FOR t600_p3x
      OPEN t600_c3x USING l_apa44,l_apz02b   #MOD-7C0233
      FETCH t600_c3x INTO l_aba19
      IF cl_null(l_aba19) THEN LET l_aba19 = 'N' END IF
      LET g_plant_new = g_aqf[l_ac].aqf03   #MOD-7C0233
      CALL s_getdbs()   #MOD-7C0233
      IF l_aba19 = 'N' THEN LET g_errno = 'aap-110' END IF
   END IF
   LET g_sql = " SELECT apa20,apc08 ,apc10 ,apc09,apc11,'',apc07,apc13 ",   #CHI-7C0033
              #FUN-A50102--mod--str-- 
              #"   FROM ",g_dbs_new CLIPPED,"apa_file ,",
              #           g_dbs_new CLIPPED,"apc_file  ",
               "   FROM ",cl_get_target_table(g_plant_new,'apa_file'),
               "       ,",cl_get_target_table(g_plant_new,'apc_file'),
              #FUN-A50102--mod--end
               "  WHERE apa01= ? ",
               "    AND apc02= ? AND apa01= apc01 ",
               #"    AND apa00[1,1] = '1'"  #No.FUN-A40055
               "    AND apa00 LIKE '1%'"     #No.FUN-A40055
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE t600_str1 FROM g_sql
   DECLARE t600_z1 CURSOR FOR t600_str1
   OPEN t600_z1 USING g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf06
   FETCH t600_z1 INTO l_apc16,l_apc08 ,l_apc10 ,l_apc09,l_apc11,l_apc06,l_apc07,l_apc13
   CALL s_curr3(l_apa13,g_aqe.aqe02,g_apz.apz33) RETURNING l_apc06   #CHI-7C0033
   CLOSE t600_z1
 
   SELECT SUM(aqf05f),SUM(aqf05) INTO l_aqf05f,l_aqf05
     FROM aqf_file,aqe_file
    WHERE aqf04=g_aqf[l_ac].aqf04
      AND aqf06=g_aqf[l_ac].aqf06
      AND aqf01<>g_aqe.aqe01
      AND aqf01=aqe01 AND aqe14='N'
   IF cl_null(l_aqf05f) THEN LET l_aqf05f = 0 END IF
   IF cl_null(l_aqf05) THEN LET l_aqf05 = 0 END IF
   IF g_apz.apz27 = 'N' THEN
      IF (l_apc08 -l_apc10 -l_apc16-l_aqf05f) > l_amtf OR
         (((l_apc08 -l_apc10 -l_apc16)*l_apc06)-l_aqf05) > l_amt THEN   #CHI-7C0033  
         LET g_errno='aap-250'
      END IF
   ELSE
      IF (l_apc08 -l_apc10 -l_apc16-l_aqf05f) > l_amtf OR
         (((l_apc08 -l_apc10 -l_apc16)*l_apc06)-l_aqf05) > l_amt THEN   #CHI-7C0033
         LET g_errno='aap-250'
      END IF
   END IF
   IF NOT cl_null(g_errno) THEN RETURN END IF
   LET g_aqf[l_ac].aqf05f= l_amtf
   LET g_aqf[l_ac].aqf05 = l_amt
   IF g_aqf[l_ac].apa13 != g_aza.aza17 THEN
      #未付金額-已KEY未確認-留置金額
      LET g_aqf[l_ac].aqf05f = g_aqf[l_ac].aqf05f - l_aqf05f - l_apc16  
      LET g_aqf[l_ac].aqf05  = g_aqf[l_ac].aqf05f * l_apc06   
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=l_apa13
      CALL cl_digcut(g_aqf[l_ac].aqf05f,t_azi04) RETURNING g_aqf[l_ac].aqf05f  
      CALL cl_digcut(g_aqf[l_ac].aqf05,g_azi04) RETURNING g_aqf[l_ac].aqf05  
      DISPLAY BY NAME g_aqf[l_ac].aqf05
      DISPLAY BY NAME g_aqf[l_ac].aqf05f
   END IF
END FUNCTION
 
FUNCTION t600_b2()
DEFINE
    p_cmd           LIKE type_file.chr1,                #處理狀態   #CHAR(1)
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT   SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用   SMALLINT
    l_apa41         LIKE apa_file.apa41,
    l_apa42         LIKE apa_file.apa42,
    l_apa13         LIKE apa_file.apa13,
    l_apa14         LIKE apa_file.apa14,
    l_apa08         LIKE apa_file.apa08,
    l_cnt           LIKE type_file.num5,     #SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否   #CHAR(1)
    l_exit_sw       LIKE type_file.chr1,     #CHAR(1)
    l_aptype        LIKE apa_file.apa00,     #CHAR(2),
    l_type          LIKE apa_file.apa00,
    l_t1            LIKE type_file.chr3,        #CHAR(03),
    l_apydmy3       LIKE apy_file.apydmy3,
    l_aqe15         LIKE aqe_file.aqe15
DEFINE
    l_amt3          LIKE apa_file.apa72,
    l_apa20         LIKE apa_file.apa20,
    l_apc16         LIKE apc_file.apc16,
    l_apa72         LIKE apa_file.apa72,
    l_aqg05         LIKE aqg_file.aqg05,
    l_allow_insert  LIKE type_file.num5,                #可新增否   SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否   SMALLINT
    l_aqg07         LIKE aqg_file.aqg07,
    l_w             LIKE type_file.num5,                #SMALLINT,
    l_nma28         LIKE nma_file.nma28
 
DEFINE l_aag05      LIKE aag_file.aag05,                #FUN-8C0106 add
       l_aag05_1    LIKE aag_file.aag05                 #FUN-8C0106 add
 
    IF s_aapshut(0) THEN RETURN END IF
    IF g_aqe.aqe01 IS NULL THEN RETURN END IF
    SELECT * INTO g_aqe.* FROM aqe_file
     WHERE aqe01=g_aqe.aqe01
      LET l_aqe15 = g_aqe.aqe15
    IF g_aqe.aqe14 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
    IF g_aqe.aqe14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_aqe.aqeacti ='N' THEN CALL cl_err(g_aqe.aqe01,'9027',0) RETURN END IF
     IF g_aqe.aqe15 matches '[Ss]' THEN
         CALL cl_err('','apm-030',0)
         RETURN
    END IF
 
    IF g_apz.apz13 = 'Y' THEN
       SELECT * INTO g_aps.* FROM aps_file WHERE aps01=g_aqe.aqe05
    ELSE
       SELECT * INTO g_aps.* FROM aps_file WHERE (aps01 = ' ' OR aps01 IS NULL)
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT aqg02,aqg03,aqg04,aqg08,aqg22,aqg23,", #FUN-970077 add aqg22,aqg23
                       "       aqg05,aqg051,aqg11,'',aqg07,aqg09,",
                       "       aqg10,aqg06f,aqg06,",
                       "       aqgud01,aqgud02,aqgud03,aqgud04,aqgud05,",
                       "       aqgud06,aqgud07,aqgud08,aqgud09,aqgud10,",
                       "       aqgud11,aqgud12,aqgud13,aqgud14,aqgud15 ",
                       " FROM aqg_file",
                       " WHERE aqg01=? AND aqg02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t600_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET g_aqe.aqemodu=g_user
    LET g_aqe.aqedate=g_today
    DISPLAY BY NAME g_aqe.aqemodu,g_aqe.aqedate
    CALL t600_b2_fill(g_wc3)                 #單身
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    WHILE TRUE
    LET l_exit_sw = 'y'
    INPUT ARRAY g_aqg WITHOUT DEFAULTS FROM s_aqg.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b2 != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           CALL cl_set_comp_entry("aqg11",TRUE)
           BEGIN WORK
           LET g_success = 'Y'
           OPEN t600_cl USING g_aqe.aqe01
           IF STATUS THEN
              CALL cl_err("OPEN t600_cl:", STATUS, 1)
              CLOSE t600_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t600_cl INTO g_aqe.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_aqe.aqe01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE t600_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b2 >= l_ac THEN
              LET p_cmd='u'
              LET g_aqg_t.* = g_aqg[l_ac].*  #BACKUP
              OPEN t600_bcl USING g_aqe.aqe01,g_aqg_t.aqg02
              IF STATUS THEN
                 CALL cl_err("OPEN t600_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              END IF
              FETCH t600_bcl INTO g_aqg[l_ac].*
              LET g_aqg[l_ac].nmc02 =g_aqg_t.nmc02
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_aqg_t.aqg02,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              CALL cl_show_fld_cont()
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_aqg[l_ac].* TO NULL
           LET g_aqg[l_ac].aqg03  = g_plant
           LET g_aqg[l_ac].aqg10  = 1
           LET g_aqg[l_ac].aqg06f = 0
           LET g_aqg[l_ac].aqg06 = 0
           LET g_aqg[l_ac].aqg23 = '3'           #FUN-970077 add
           LET g_aqg_t.* = g_aqg[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()
            NEXT FIELD aqg02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF g_aqg[l_ac].aqg05 IS NULL AND g_aqg[l_ac].aqg06 = 0 THEN
              CALL g_aqg.deleteElement(l_ac)
              NEXT FIELD aqg02
              CANCEL INSERT
           END IF
           INSERT INTO aqg_file(aqg00,aqg01,aqg02,aqg03,aqg04,aqg08,
                                aqg22,aqg23,aqg05,aqg051,aqg11,aqg07, #FUN-970077 add aqg22,aqg23
                                aqg09,aqg10,aqg06f,aqg06,
                                aqgud01,aqgud02,aqgud03,aqgud04,aqgud05,
                                aqgud06,aqgud07,aqgud08,aqgud09,aqgud10,
                                aqgud11,aqgud12,aqgud13,aqgud14,aqgud15,aqglegal)  #FUN-960141 add
            VALUES(g_aqe.aqe00,g_aqe.aqe01,g_aqg[l_ac].aqg02,g_aqg[l_ac].aqg03,
                   g_aqg[l_ac].aqg04,g_aqg[l_ac].aqg08,g_aqg[l_ac].aqg22,g_aqg[l_ac].aqg23,  #FUN-970077 add aqg22,aqg23
                   g_aqg[l_ac].aqg05,
                   g_aqg[l_ac].aqg051,g_aqg[l_ac].aqg11,
                   g_aqg[l_ac].aqg07,g_aqg[l_ac].aqg09,g_aqg[l_ac].aqg10,
                   g_aqg[l_ac].aqg06f,g_aqg[l_ac].aqg06,
                   g_aqg[l_ac].aqgud01, g_aqg[l_ac].aqgud02,
                   g_aqg[l_ac].aqgud03, g_aqg[l_ac].aqgud04,
                   g_aqg[l_ac].aqgud05, g_aqg[l_ac].aqgud06,
                   g_aqg[l_ac].aqgud07, g_aqg[l_ac].aqgud08,
                   g_aqg[l_ac].aqgud09, g_aqg[l_ac].aqgud10,
                   g_aqg[l_ac].aqgud11, g_aqg[l_ac].aqgud12,
                   g_aqg[l_ac].aqgud13, g_aqg[l_ac].aqgud14,
                   g_aqg[l_ac].aqgud15,g_legal)  #FUN-960141 add
 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","aqg_file",g_aqe.aqe01,g_aqg[l_ac].aqg02,SQLCA.sqlcode,"","",1)
              CANCEL INSERT
              ROLLBACK WORK
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b2=g_rec_b2+1
              DISPLAY g_rec_b2 TO FORMONLY.cn4
              IF g_success='Y' THEN
                  LET l_aqe15 = '0'
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
           END IF
 
        BEFORE FIELD aqg02                        #default 序號
           IF g_aqg[l_ac].aqg02 IS NULL OR g_aqg[l_ac].aqg02 = 0 THEN
              SELECT max(aqg02)+1
                INTO g_aqg[l_ac].aqg02
                FROM aqg_file
               WHERE aqg01 = g_aqe.aqe01
              IF g_aqg[l_ac].aqg02 IS NULL THEN
                 LET g_aqg[l_ac].aqg02 = 1
              END IF
           END IF
 
        AFTER FIELD aqg02                        #check 序號是否重複
           IF NOT cl_null(g_aqg[l_ac].aqg02) THEN
              IF g_aqg[l_ac].aqg02 != g_aqg_t.aqg02 OR g_aqg_t.aqg02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM aqg_file
                  WHERE aqg01 = g_aqe.aqe01
                    AND aqg02 = g_aqg[l_ac].aqg02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_aqg[l_ac].aqg02 = g_aqg_t.aqg02
                    NEXT FIELD aqg02
                 END IF
              END IF
           END IF
 
        AFTER FIELD aqg03
           IF NOT cl_null(g_aqg[l_ac].aqg03) THEN
              LET g_plant_new = g_aqg[l_ac].aqg03
              IF (g_plant_new!=g_plant) THEN
              IF NOT s_chknplt(g_plant_new,'AAP','AAP') THEN
                 CALL cl_err(g_plant_new,g_errno,0)
                   NEXT FIELD aqg03
              END IF
              ELSE
                 LET g_dbs_new = NULL
              END IF
           END IF
 
        BEFORE FIELD aqg04
            CALL t600_set_entry_b(p_cmd)
 
        AFTER FIELD aqg04
            IF NOT cl_null(g_aqg[l_ac].aqg04) THEN
               IF g_aqg[l_ac].aqg04 MATCHES "[6789]" THEN
                  CALL cl_set_comp_entry("aqg17",TRUE)
               ELSE
                  CALL cl_set_comp_entry("aqg17",FALSE)
               END IF
               IF g_aqg_o.aqg04 IS NULL OR g_aqg_o.aqg04 != g_aqg[l_ac].aqg04 THEN
               CASE WHEN g_aqg[l_ac].aqg04 = '1'
                         LET g_aqg[l_ac].aqg05 = g_aps.aps24
                         LET g_aqg[l_ac].aqg051= g_aps.aps241
                    WHEN g_aqg[l_ac].aqg04 = '3'
                         LET g_aqg[l_ac].aqg05 = g_aps.aps47
                         LET g_aqg[l_ac].aqg051= g_aps.aps471
                    WHEN g_aqg[l_ac].aqg04 = '4'
                         LET g_aqg[l_ac].aqg05 = g_aps.aps43
                         LET g_aqg[l_ac].aqg051= g_aps.aps431
                    WHEN g_aqg[l_ac].aqg04 = '5'
                         LET g_aqg[l_ac].aqg05 = g_aps.aps42
                         LET g_aqg[l_ac].aqg051= g_aps.aps421
                    WHEN g_aqg[l_ac].aqg04 = 'A'
                         LET g_aqg[l_ac].aqg05 = g_aps.aps46
                         LET g_aqg[l_ac].aqg051= g_aps.aps461
                    WHEN g_aqg[l_ac].aqg04 = 'B'
                         LET g_aqg[l_ac].aqg05 = g_aps.aps57
                         LET g_aqg[l_ac].aqg051= g_aps.aps571
                    WHEN g_aqg[l_ac].aqg04 = 'C'
                         LET g_aqg[l_ac].aqg05 = g_aps.aps58
                         LET g_aqg[l_ac].aqg051= g_aps.aps581
                    WHEN g_aqg[l_ac].aqg04 = 'Z'
                         LET g_aqg[l_ac].aqg05 = g_aps.aps56
                         LET g_aqg[l_ac].aqg051= g_aps.aps561
               END CASE
               LET g_aqg_o.aqg04 = g_aqg[l_ac].aqg04
               END IF
               IF g_aqg[l_ac].aqg04 NOT MATCHES "[6789ABZ]" THEN
                  SELECT apw03 INTO g_aqg[l_ac].aqg05 FROM apw_file
                   WHERE apw01=g_aqg[l_ac].aqg04
                  IF g_aza.aza63 = 'Y' THEN
                     SELECT apw03 INTO g_aqg[l_ac].aqg051 FROM apw_file
                      WHERE apw01=g_aqg[l_ac].aqg04
                  END IF
               END IF
               CALL t600_set_no_entry_b(p_cmd)
            END IF
            IF g_aqg[l_ac].aqg04 <> '2' THEN
               CALL cl_set_comp_entry("aqg11",FALSE)
               LET g_aqg[l_ac].aqg11 = ''
               LET g_aqg[l_ac].nmc02 = ''
               DISPLAY BY NAME g_aqg[l_ac].aqg11,g_aqg[l_ac].nmc02
            END IF
            IF g_aza.aza63 = 'Y' AND g_aqg[l_ac].aqg04 NOT MATCHES "[6789]" THEN
               CALL cl_set_comp_visible("aqg051",TRUE)
            ELSE
            END IF
 
        BEFORE FIELD aqg05
            IF g_aqg[l_ac].aqg04 MATCHES "[6789]"
               THEN CALL cl_getmsg('aap-074',g_lang) RETURNING g_msg
               ELSE CALL cl_getmsg('aap-073',g_lang) RETURNING g_msg
            END IF
            ERROR g_msg CLIPPED
 
        AFTER FIELD aqg05
            IF NOT cl_null(g_aqg[l_ac].aqg05) THEN
               IF g_aqg_t.aqg05 IS NULL OR g_aqg[l_ac].aqg05!=g_aqg_t.aqg05
                   OR g_aqg[l_ac].aqg04!=g_aqg_t.aqg04 THEN
                   IF g_aqg[l_ac].aqg04 NOT MATCHES "[6789]" THEN
                      IF g_apz.apz02 = 'Y' THEN
                       CALL s_aapact('2',g_bookno1,g_aqg[l_ac].aqg05) RETURNING g_msg      #No.MOD-740255
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err(g_aqg[l_ac].aqg05,g_errno,0)
#No.FUN-B20059 --begin
                          CALL q_aapact(FALSE,FALSE,'2',g_aqg[l_ac].aqg05,g_bookno1)
                               RETURNING g_aqg[l_ac].aqg05
#No.FUN-B20059 --end
                          NEXT FIELD aqg05
                       END IF
                      END IF
                   END IF
               END IF
 
 
              LET l_aag05=''
              SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_aqg[l_ac].aqg05
                  AND aag00 = g_bookno1           
              IF l_aag05 = 'Y' AND NOT cl_null(g_aqe.aqe05) THEN
                #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                 IF g_aaz.aaz90 !='Y' THEN
                    CALL s_chkdept(g_aaz.aaz72,g_aqg[l_ac].aqg05,g_aqe.aqe05,g_bookno1) RETURNING g_errno
                 END IF
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    NEXT FIELD aqg05
                 END IF
              END IF  
 
            END IF
 
        BEFORE FIELD aqg051
            IF g_aqg[l_ac].aqg04 MATCHES "[6789]"
               THEN CALL cl_getmsg('aap-074',g_lang) RETURNING g_msg
               ELSE CALL cl_getmsg('aap-073',g_lang) RETURNING g_msg
            END IF
            ERROR g_msg CLIPPED
 
        AFTER FIELD aqg051
            IF NOT cl_null(g_aqg[l_ac].aqg051) THEN
               IF g_aqg_t.aqg051 IS NULL OR g_aqg[l_ac].aqg051!=g_aqg_t.aqg051
                   OR g_aqg[l_ac].aqg04!=g_aqg_t.aqg04 THEN
                  IF g_apz.apz02 = 'Y' THEN
                     CALL s_aapact('2',g_bookno2,g_aqg[l_ac].aqg051) RETURNING g_msg      #No.MOD-740255
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aqg[l_ac].aqg051,g_errno,0)
#No.FUN-B20059 --begin
                        CALL q_aapact(FALSE,FALSE,'2',g_aqg[l_ac].aqg051,g_bookno2)
                             RETURNING g_aqg[l_ac].aqg051
#No.FUN-B20059 --end
                        NEXT FIELD aqg051
                     END IF
                  END IF
               END IF
 
               LET l_aag05_1=''
               SELECT aag05 INTO l_aag05_1 FROM aag_file
                 WHERE aag01 = g_aqg[l_ac].aqg051
                   AND aag00 = g_bookno2           
               IF l_aag05_1 = 'Y' AND NOT cl_null(g_aqe.aqe05) THEN
                 #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     CALL s_chkdept(g_aaz.aaz72,g_aqg[l_ac].aqg051,g_aqe.aqe05,g_bookno2) RETURNING g_errno
                  END IF 
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD aqg051
                  END IF
               END IF  
 
            END IF
 
        AFTER FIELD aqg08
            IF g_aqg[l_ac].aqg04 = '2' THEN
               IF cl_null(g_aqg[l_ac].aqg08) THEN NEXT FIELD aqg08 END IF
            END IF
            IF g_aqg[l_ac].aqg08 IS NOT NULL THEN
               SELECT nma10 INTO g_aqg[l_ac].aqg09 FROM nma_file
                    WHERE nma01 = g_aqg[l_ac].aqg08
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","nma_file",g_aqg[l_ac].aqg08,"",STATUS,"","sel nma:",1)  
                  NEXT FIELD aqg08
               END IF
            END IF
            IF g_aqg[l_ac].aqg04 = '2' AND
               g_aqg[l_ac].aqg09 != g_aza.aza17 THEN
               CALL s_bankex(g_aqg[l_ac].aqg08,g_aqe.aqe02)
                    RETURNING g_aqg[l_ac].aqg10
               SELECT azi07 INTO t_azi07 FROM azi_file
                WHERE azi01= g_aqg[l_ac].aqg09
               LET g_aqg[l_ac].aqg10 = cl_digcut(g_aqg[l_ac].aqg10,t_azi07)
               LET g_aqg[l_ac].aqg06 = g_aqg[l_ac].aqg06f * g_aqg[l_ac].aqg10
               LET g_aqg[l_ac].aqg06 = cl_digcut(g_aqg[l_ac].aqg06,t_azi04)
               DISPLAY BY NAME g_aqg[l_ac].aqg10
               DISPLAY BY NAME g_aqg[l_ac].aqg06
            END IF
 
              IF g_aqg[l_ac].aqg04 = '1' THEN
                    IF NOT cl_null(g_aqg[l_ac].aqg08) THEN
                       SELECT nma28 INTO l_nma28 FROM nma_file
                         WHERE nma01=g_aqg[l_ac].aqg08
                    #  IF l_nma28 <> g_aqg[l_ac].aqg04 THEN                          #FUN-C80018
                       IF l_nma28 <> g_aqg[l_ac].aqg04 AND g_aza.aza26!='2' THEN     #FUN-C80018
                          CALL cl_err('','aap-804',0)
                          NEXT FIELD aqg08
                       END IF
                    END IF
              END IF
 
           IF g_aqg[l_ac].aqg04 = '2' THEN
              SELECT nma28 INTO l_nma28 FROM nma_file
                WHERE nma01=g_aqg[l_ac].aqg08
             #IF l_nma28 <> g_aqg[l_ac].aqg04 THEN    #FUN-C80018
              IF l_nma28 <> g_aqg[l_ac].aqg04 AND g_aza.aza26!='2' THEN     #FUN-C80018
                 CALL cl_err('','aap-804',0)
                 NEXT FIELD aqg08
              END IF
              SELECT nma05,nma051 INTO g_aqg[l_ac].aqg05,g_aqg[l_ac].aqg051 FROM nma_file    
                 WHERE nma01 = g_aqg[l_ac].aqg08
              DISPLAY BY NAME g_aqg[l_ac].aqg05
              DISPLAY BY NAME g_aqg[l_ac].aqg051
           END IF
 
        #FUN-970077---Begin
        AFTER FIELD aqg22
           IF NOT cl_null(g_aqg[l_ac].aqg22) THEN
              SELECT COUNT(*) INTO l_n FROM nnc_file
               WHERE nnc02 = g_aqg[l_ac].aqg22
              IF l_n = 0 THEN
                 CALL cl_err("","asfi115",0)
                 NEXT FIELD aqg22
              END IF
           END IF
        #FUN-970077--End
        BEFORE FIELD aqg11
           IF g_aqg[l_ac].aqg04 = '2' THEN
               IF cl_null(g_aqg[l_ac].aqg11) THEN
                  LET g_aqg[l_ac].aqg11 = g_apz.apz58
               END IF
               SELECT nmc02 INTO g_aqg[l_ac].nmc02 FROM nmc_file
                  WHERE nmc01 = g_aqg[l_ac].aqg11
               DISPLAY BY NAME g_aqg[l_ac].nmc02
           ELSE
               CALL cl_set_comp_entry("aqg11",FALSE)
           END IF
 
        AFTER FIELD aqg11
           IF cl_null(g_aqg[l_ac].aqg11) AND g_aqg[l_ac].aqg04 = '2' THEN
              NEXT FIELD aqg11
           END IF
           IF NOT cl_null(g_aqg[l_ac].aqg11) THEN
              SELECT COUNT(*) INTO l_cnt FROM nmc_file
                 WHERE nmc01 = g_aqg[l_ac].aqg11 AND nmc03 = '2'
              IF l_cnt = 0 THEN
                 CALL cl_err('','anm-024',1)
                 LET g_aqg[l_ac].aqg11 = g_aqg_o.aqg11
                 NEXT FIELD aqg11
              ELSE
                 SELECT nmc02 INTO g_aqg[l_ac].nmc02 FROM nmc_file
                    WHERE nmc01 = g_aqg[l_ac].aqg11  AND nmc03 = '2' #僅能為提出
                    DISPLAY BY NAME g_aqg[l_ac].nmc02
                 LET g_aqg_o.aqg11 = g_aqg[l_ac].aqg11
              END IF
           END IF
 
        BEFORE FIELD aqg09
            IF g_aqg[l_ac].aqg09 IS NULL THEN
               LET g_aqg[l_ac].aqg09 = g_aqe.aqe06
            END IF
            DISPLAY BY NAME g_aqg[l_ac].aqg09
 
        AFTER FIELD aqg09,aqg10
            IF g_aqg[l_ac].aqg09 IS NULL THEN NEXT FIELD aqg09 END IF
            IF g_aqg[l_ac].aqg04 NOT MATCHES "[6789]" AND
               g_aqg[l_ac].aqg09 != g_aza.aza17 AND
               g_aqg[l_ac].aqg10 = 1 THEN
               CALL s_curr3(g_aqg[l_ac].aqg09,g_aqe.aqe02,g_apz.apz33)
                    RETURNING g_aqg[l_ac].aqg10
               DISPLAY BY NAME g_aqg[l_ac].aqg10
            END IF
            IF p_cmd = 'a' OR g_aqg[l_ac].aqg09 != g_aqg_t.aqg09 THEN
               CALL t600_aqg09(g_aqg[l_ac].aqg09)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aqg[l_ac].aqg09,g_errno,0)
                  NEXT FIELD aqg09
               END IF
            END IF
 
            IF g_aqg[l_ac].aqg10 IS NOT NULL THEN
               IF g_aqg[l_ac].aqg09 =g_aza.aza17 THEN
                  LET g_aqg[l_ac].aqg10 =1
                  DISPLAY BY NAME g_aqg[l_ac].aqg10
               END IF
            END IF
 
        BEFORE FIELD aqg06f
            IF g_aqg[l_ac].aqg06f = 0 OR g_aqg[l_ac].aqg06f IS NULL THEN
               LET g_aqg[l_ac].aqg06f = g_aqe.aqe08f-g_aqe.aqe09f
               DISPLAY BY NAME g_aqg[l_ac].aqg06f
            END IF
 
        AFTER FIELD aqg06f
            SELECT azi04 INTO g_azi04 FROM azi_file
                WHERE azi01 = g_aqg[l_ac].aqg09
            LET g_aqg[l_ac].aqg06f = cl_digcut(g_aqg[l_ac].aqg06f,g_azi04)
            DISPLAY BY NAME g_aqg[l_ac].aqg06f
 
            IF g_aqg[l_ac].aqg04 MATCHES "[45]" THEN
               LET g_aqg[l_ac].aqg05 = g_aqe.aqe08+g_aqg_t.aqg05-g_aqe.aqe10
            END IF
            IF g_aqg[l_ac].aqg04 NOT MATCHES "[45]" THEN
               LET g_aqg[l_ac].aqg06 = g_aqg[l_ac].aqg06f * g_aqg[l_ac].aqg10
               LET g_aqg[l_ac].aqg06 = cl_digcut(g_aqg[l_ac].aqg06,t_azi04)
            END IF
            DISPLAY BY NAME g_aqg[l_ac].aqg06
 
      AFTER FIELD aqg07
        LET l_w = WEEKDAY(g_aqg[l_ac].aqg07)
        # 若為週日
        IF l_w = 0 THEN
           LET g_aqg[l_ac].aqg07 = g_aqg[l_ac].aqg07 + 1
           CALL cl_err(g_aqg[l_ac].aqg07,'aap-803',0)
        END IF
        # 若為週六
        IF l_w = 6 THEN
           LET g_aqg[l_ac].aqg07 = g_aqg[l_ac].aqg07 + 2
           CALL cl_err(g_aqg[l_ac].aqg07,'aap-803',0)
        END IF
        # 若為假日,找尋下一個工作日
        SELECT nph02 INTO g_buf FROM nph_file WHERE nph01=g_aqg[l_ac].aqg07
        IF STATUS = 0 THEN
           SELECT MIN(sme01) INTO l_aqg07 FROM sme_file
            WHERE sme01 > g_aqg[l_ac].aqg07 AND sme02 = 'Y'
           IF STATUS = 100 THEN
              CALL cl_err3("sel","sme_file","","","amr-533","","",1)
           ELSE
              CALL cl_err3("sel","sme_file","","","aap-803","","",1)
              LET g_aqg[l_ac].aqg07 = l_aqg07
           END IF
        END IF
        IF g_aqe.aqe02 = g_aqg[l_ac].aqg07 AND g_apz.apz52 <> '1' THEN
           SELECT nma05 INTO g_aqg[l_ac].aqg04 FROM nma_file
              WHERE nma01 = g_aqg[l_ac].aqg08
        END IF
        DISPLAY BY NAME g_aqg[l_ac].aqg04
 
        AFTER FIELD aqgud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD aqgud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_aqg_t.aqg02 > 0 AND g_aqg_t.aqg02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
              DELETE FROM aqg_file
               WHERE aqg01 = g_aqe.aqe01
                 AND aqg02 = g_aqg_t.aqg02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","aqg_file",g_aqe.aqe01,g_aqg_t.aqg02,SQLCA.sqlcode,"","",1)
                 CANCEL DELETE
              END IF
              LET g_rec_b2=g_rec_b2-1
              DISPLAY g_rec_b2 TO FORMONLY.cn4
              IF g_success='Y' THEN
                  LET l_aqe15 = '0'
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
           END IF
           CALL t600_b2_tot()
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_aqg[l_ac].* = g_aqg_t.*
               CLOSE t600_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_aqg[l_ac].aqg02,-263,1)
               LET g_aqg[l_ac].* = g_aqg_t.*
            ELSE
               UPDATE aqg_file SET aqg02 = g_aqg[l_ac].aqg02,
                                   aqg03 = g_aqg[l_ac].aqg03,
                                   aqg04 = g_aqg[l_ac].aqg04,
                                   aqg05 = g_aqg[l_ac].aqg05,
                                   aqg051= g_aqg[l_ac].aqg051,
                                   aqg11 = g_aqg[l_ac].aqg11,
                                   aqg07 = g_aqg[l_ac].aqg07,
                                   aqg08 = g_aqg[l_ac].aqg08,
                                   aqg22 = g_aqg[l_ac].aqg22,  #FUN-970077 add
                                   aqg23 = g_aqg[l_ac].aqg23,  #FUN-970077 add
                                   aqg09 = g_aqg[l_ac].aqg09,
                                   aqg10 = g_aqg[l_ac].aqg10,
                                   aqg06f = g_aqg[l_ac].aqg06f,
                                   aqg06 = g_aqg[l_ac].aqg06,
                                   aqgud01 = g_aqg[l_ac].aqgud01,
                                   aqgud02 = g_aqg[l_ac].aqgud02,
                                   aqgud03 = g_aqg[l_ac].aqgud03,
                                   aqgud04 = g_aqg[l_ac].aqgud04,
                                   aqgud05 = g_aqg[l_ac].aqgud05,
                                   aqgud06 = g_aqg[l_ac].aqgud06,
                                   aqgud07 = g_aqg[l_ac].aqgud07,
                                   aqgud08 = g_aqg[l_ac].aqgud08,
                                   aqgud09 = g_aqg[l_ac].aqgud09,
                                   aqgud10 = g_aqg[l_ac].aqgud10,
                                   aqgud11 = g_aqg[l_ac].aqgud11,
                                   aqgud12 = g_aqg[l_ac].aqgud12,
                                   aqgud13 = g_aqg[l_ac].aqgud13,
                                   aqgud14 = g_aqg[l_ac].aqgud14,
                                   aqgud15 = g_aqg[l_ac].aqgud15
                WHERE aqg01=g_aqe.aqe01
                 AND aqg02 = g_aqg_t.aqg02
 
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","aqg_file",g_aqe.aqe01,g_aqg_t.aqg02,SQLCA.sqlcode,"","",1)  
                  LET g_aqg[l_ac].* = g_aqg_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  UPDATE aqe_file SET aqemodu=g_user,aqedate=g_today
                   WHERE aqe01=g_aqe.aqe01
                  IF g_success='Y' THEN
                      LET l_aqe15 = '0'
                     COMMIT WORK
                  ELSE
                     ROLLBACK WORK
                  END IF
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_aqg[l_ac].* = g_aqg_t.*
               #FUN-D30032--add--str--
               ELSE
                  CALL g_aqg.deleteElement(l_ac)
                  IF g_rec_b2 != 0 THEN
                     LET g_action_choice = "detail"
                     LET g_b_flag = '2'
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end--
               END IF
               CLOSE t600_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30032 add
            CLOSE t600_bcl
            COMMIT WORK
            CALL t600_b2_tot()
 
        ON ACTION mntn_freq_ac
           IF g_aqg[l_ac].aqg04 NOT MATCHES '[ABT]' THEN
              CALL cl_cmdrun('aapi204')
           END IF
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(aqg04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_apw"
                 LET g_qryparam.arg1 = g_bookno1     #No.TQC-A30078
                 LET g_qryparam.default1 = g_aqg[l_ac].aqg04
                 CALL cl_create_qry() RETURNING g_aqg[l_ac].aqg04
                 DISPLAY g_aqg[l_ac].aqg04 TO aqg04
              WHEN INFIELD(aqg08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_nma2"   
                 IF g_aqg[l_ac].aqg04 = 'C' THEN
                    LET g_qryparam.arg1 = '23'
                 ELSE
                    IF g_aqg[l_ac].aqg04 = '2' THEN
                       LET g_qryparam.arg1 = '23'
                    ELSE
                       LET g_qryparam.arg1 = g_aqg[l_ac].aqg04
                    END IF
                 END IF
                 LET g_qryparam.default1 = g_aqg[l_ac].aqg08
                 CALL cl_create_qry() RETURNING g_aqg[l_ac].aqg08
                 DISPLAY g_aqg[l_ac].aqg08 TO aqg08
              #FUN-970077---Begin                                                                                                   
              WHEN INFIELD(aqg22)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_nnc1"
                 LET g_qryparam.arg1 =g_aqg[l_ac].aqg08
                 LET g_qryparam.default1 = g_aqg[l_ac].aqg22
                 CALL cl_create_qry() RETURNING g_aqg[l_ac].aqg22
                 DISPLAY g_aqg[l_ac].aqg22 TO aqg22
              #FUN-970077---End
              WHEN INFIELD(aqg11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_nmc"
                 LET g_qryparam.default1 = g_aqg[l_ac].aqg11
                 CALL cl_create_qry() RETURNING g_aqg[l_ac].aqg11
                 DISPLAY g_aqg[l_ac].aqg11 TO aqg11
              WHEN INFIELD(aqg05)
                    CALL q_aapact(FALSE,TRUE,'2',g_aqg[l_ac].aqg05,g_bookno1)
                         RETURNING g_aqg[l_ac].aqg05
                    DISPLAY g_aqg[l_ac].aqg05 TO aqg05
              WHEN INFIELD(aqg051)
                    CALL q_aapact(FALSE,TRUE,'2',g_aqg[l_ac].aqg051,g_bookno2)
                         RETURNING g_aqg[l_ac].aqg051
                    DISPLAY g_aqg[l_ac].aqg051 TO aqg051
              WHEN INFIELD(aqg09) # CURRENCY
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azi"
                 LET g_qryparam.default1 = g_aqg[l_ac].aqg09
                 CALL cl_create_qry() RETURNING g_aqg[l_ac].aqg09
                 DISPLAY g_aqg[l_ac].aqg09 TO aqg09
              WHEN INFIELD(aqg10)
                   CALL s_rate(g_aqg[l_ac].aqg09,g_aqg[l_ac].aqg10)
                   RETURNING g_aqg[l_ac].aqg10
                   DISPLAY BY NAME g_aqg[l_ac].aqg10
                   NEXT FIELD aqg10
              WHEN INFIELD(aqg03)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_azp"
                 LET g_qryparam.default1 = g_aqg[l_ac].aqg03
                 CALL cl_create_qry() RETURNING g_aqg[l_ac].aqg03
                 DISPLAY g_aqg[l_ac].aqg03 TO aqg03
              OTHERWISE
                 EXIT CASE
        END CASE
 
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(aqg02) AND l_ac > 1 THEN
               LET g_aqg[l_ac].* = g_aqg[l_ac-1].*
               LET g_aqg[l_ac].aqg02 = NULL   
               NEXT FIELD aqg02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       	
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
    END INPUT
 
     UPDATE aqe_file SET aqemodu=g_aqe.aqemodu,aqe15=l_aqe15,
                        aqedate=g_aqe.aqedate
     WHERE aqe01=g_aqe.aqe01
   LET g_aqe.aqe15 = l_aqe15
   DISPLAY BY NAME g_aqe.aqe15
   IF g_aqe.aqe14 = 'X' THEN LET g_void = 'Y' ELSE LET g_void = 'N' END IF
   IF g_aqe.aqe15 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
   CALL cl_set_field_pic(g_aqe.aqe14,g_chr2,"","",g_void,g_aqe.aqeacti)
 
    CALL t600_b2_tot()
 
       IF g_aqe.aqe09f != g_aqe.aqe08f THEN
          IF g_aqe.aqe09f < g_aqe.aqe08f THEN
             CALL cl_getmsg('aap-070',g_lang) RETURNING g_msg
          END IF
          IF g_aqe.aqe09f > g_aqe.aqe08f THEN
             CALL cl_getmsg('aap-983',g_lang) RETURNING g_msg
          END IF
          WHILE TRUE
             LET g_chr=' '
             LET INT_FLAG = 0
             PROMPT g_msg CLIPPED FOR CHAR g_chr
                ON IDLE g_idle_seconds  #TQC-860021
                   CALL cl_on_idle()    #TQC-860021
 
                ON ACTION about         #TQC-860021
                   CALL cl_about()      #TQC-860021
 
                ON ACTION help          #TQC-860021
                   CALL cl_show_help()  #TQC-860021
 
                ON ACTION controlg      #TQC-860021
                   CALL cl_cmdask()     #TQC-860021
             END PROMPT                 #TQC-860021
             IF INT_FLAG THEN LET INT_FLAG = 0 END IF
             IF g_chr MATCHES "[12Ee]" THEN EXIT WHILE END IF
          END WHILE
          IF g_chr MATCHES '[Ee]' THEN LET l_exit_sw = 'y' EXIT WHILE END IF
          IF g_chr = '1' THEN LET l_exit_sw = 'n' END IF                     #No.MOD-740193       
          IF g_chr = '2' THEN
             LET l_n = ARR_COUNT()
             CALL t600_b()
          END IF
       END IF
 
 
    IF l_exit_sw = 'y' THEN
       EXIT WHILE
    ELSE
       CONTINUE WHILE
    END IF
    END WHILE
 
    CLOSE t600_bcl
    IF g_success='Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
  #  IF g_chr = 'E' THEN RETURN END IF MARK #FUN-A40055
 # ------FUN-A40055---BEGIN
  IF g_chr MATCHES '[Ee]' THEN
     LET  g_action_choice = NULL
  RETURN END IF
  #-----FUN-A40055------END
    LET g_success='Y'
END FUNCTION
 
 
FUNCTION t600_b_askkey()
    DEFINE l_wc2           LIKE type_file.chr1000  #CHAR(200)
 
    CONSTRUCT l_wc2 ON aqf02,aqf03,aqf04,aqf06,aqf05f,aqf05,aqf11,aqf12,aqf13,aqf14,aqf15
                      ,aqfud01,aqfud02,aqfud03,aqfud04,aqfud05
                      ,aqfud06,aqfud07,aqfud08,aqfud09,aqfud10
                      ,aqfud11,aqfud12,aqfud13,aqfud14,aqfud15
            FROM s_aqf[1].aqf02,s_aqf[1].aqf03,s_aqf[1].aqf04,
                 s_aqf[1].aqf06,s_aqf[1].aqf05f,s_aqf[1].aqf05,
                 s_aqf[1].aqf11,s_aqf[1].aqf12,s_aqf[1].aqf13,
                 s_aqf[1].aqf14,s_aqf[1].aqf15
                ,s_aqf[1].aqfud01,s_aqf[1].aqfud02,s_aqf[1].aqfud03
                ,s_aqf[1].aqfud04,s_aqf[1].aqfud05,s_aqf[1].aqfud06
                ,s_aqf[1].aqfud07,s_aqf[1].aqfud08,s_aqf[1].aqfud09
                ,s_aqf[1].aqfud10,s_aqf[1].aqfud11,s_aqf[1].aqfud12
                ,s_aqf[1].aqfud13,s_aqf[1].aqfud14,s_aqf[1].aqfud15
 
      BEFORE CONSTRUCT
         CALL cl_qbe_init()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t600_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t600_b_fill(p_wc2)
DEFINE
    p_wc2           LIKE type_file.chr1000  #CHAR(200)

   DEFINE l_amtf,l_amt    LIKE type_file.num20_6  #DEC(20,6)
   DEFINE l_apa00         LIKE apa_file.apa00
   DEFINE l_apa06         LIKE apa_file.apa06
   DEFINE l_apa07         LIKE apa_file.apa07
   DEFINE l_apa08         LIKE apa_file.apa08
   DEFINE l_apa13         LIKE apa_file.apa13
   DEFINE l_apc06         LIKE apc_file.apc06
   DEFINE l_apa20         LIKE apa_file.apa20
   DEFINE l_apc16         LIKE apc_file.apc16
   DEFINE l_apa21         LIKE apa_file.apa21
   DEFINE l_apa22         LIKE apa_file.apa22
   DEFINE l_apa41         LIKE apa_file.apa41
   DEFINE l_apa42         LIKE apa_file.apa42
   DEFINE l_apa34         LIKE apa_file.apa34
   DEFINE l_apa34f        LIKE apa_file.apa34f
   DEFINE l_apa44         LIKE apa_file.apa44  
                                         
    LET g_sql = "SELECT aqf02,aqf03,aqf04,aqf06,'','','',",
                "       aqf05f,aqf05,aqf11,aqf12,aqf13,aqf14,aqf15,",
                "       aqfud01,aqfud02,aqfud03,aqfud04,aqfud05,",
                "       aqfud06,aqfud07,aqfud08,aqfud09,aqfud10,",
                "       aqfud11,aqfud12,aqfud13,aqfud14,aqfud15 ",
                "  FROM aqf_file",
                " WHERE aqf01 ='",g_aqe.aqe01,"'",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY aqf02"
    PREPARE t600_pb FROM g_sql
    DECLARE aqf_curs CURSOR FOR t600_pb
       #NO.FUN-A40055--begin
       LET g_sql = "SELECT apc04,apa13,apc06 ",
                   " FROM ",cl_get_target_table(g_plant_new,'apa_file'),
                   "     ,",cl_get_target_table(g_plant_new,'apc_file'),
                   " WHERE apa01 = ? ",
                   "  AND apc02 = ? ",
                   "  AND apc01 = apa01 "
    	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102 
       PREPARE t600_str6 FROM g_sql
       IF STATUS THEN
          CALL cl_err('change dbs_6 error',status,1)
          LET g_success='N'
       END IF
       DECLARE z9_curs CURSOR FOR t600_str6
       
   IF g_apz.apz27 = 'N' THEN
      LET g_sql = "SELECT apc04,apa13,'',apc08-apc10-apc16,0,",   
                  " apa06,apa07,apa21,apa22,apa13,apa00,apa41,apa42,apa08,apa44 ",   
                  "  FROM ",cl_get_target_table(g_plant_new,'apa_file'),
                  "      ,",cl_get_target_table(g_plant_new,'apc_file'),
                  "  WHERE apa01 = ? AND apc02=? ",
                  "    AND apa01=apc01 ",
                  #"    AND apa00[1,1] = '1'"
                  "    AND apa00 LIKE '1%' "
   ELSE
      LET g_sql = "SELECT apc04,apa13,'',apc08-apc10-apc16,0,",  
                  " apa06,apa07,apa21,apa22,apa13,apa00,apa41,apa42,apa08,apa44 ",   
                  "  FROM ",cl_get_target_table(g_plant_new,'apa_file'),
                  "      ,",cl_get_target_table(g_plant_new,'apc_file'),
                  "  WHERE apa01 = ? AND apc02=? ",
                  "    AND apa01=apc01 ",
                  #"    AND apa00[1,1] = '1'"
                  "    AND apa00 LIKE '1%' "
   END IF                 
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql      
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  
   PREPARE t600_p31 FROM g_sql 
   DECLARE t600_c31 CURSOR FOR t600_p31      
   #NO.FUN-A40055--end 
    CALL g_aqf.clear()
    LET l_ac = 1
    LET g_note_days = 0
    FOREACH aqf_curs INTO g_aqf[l_ac].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       #NO.FUN-A40055--begin
       LET g_plant_new = g_aqf[l_ac].aqf03
       CALL s_getdbs()
       
#       LET g_sql = "SELECT apc04,apa13,apc06 ",
#                  #FUN-A50102--mod--str--
#                  #" FROM ",g_dbs_new CLIPPED,"apa_file,",
#                  #       g_dbs_new CLIPPED,"apc_file ",
#                   " FROM ",cl_get_target_table(g_plant_new,'apa_file'),
#                   "     ,",cl_get_target_table(g_plant_new,'apc_file'),
#                  #FUN-A50102--mod--end
#                   "WHERE apa01 = ? ",
#                   "  AND apc02 = ? ",
#                   "  AND apc01 = apa01 "
#    	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
#       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102 
#       PREPARE t600_str6 FROM g_sql
#       IF STATUS THEN
#          CALL cl_err('change dbs_6 error',status,1)
#          LET g_success='N'
#          EXIT FOREACH
#       END IF
#       DECLARE z9_curs CURSOR FOR t600_str6
       #NO.FUN-A40055--end 
       OPEN z9_curs USING g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf06
       FETCH z9_curs INTO g_aqf[l_ac].apc04,g_aqf[l_ac].apa13,g_aqf[l_ac].apc06
       CLOSE z9_curs

       OPEN t600_c31 USING g_aqf[l_ac].aqf04,g_aqf[l_ac].aqf06
       FETCH t600_c31 INTO g_aqf[l_ac].apc04,g_aqf[l_ac].apa13,g_aqf[l_ac].apc06,
                          l_amtf,l_amt,l_apa06,l_apa07,l_apa21,l_apa22,l_apa13,
                          l_apa00,l_apa41,l_apa42,l_apa08,l_apa44    
       CALL s_curr3(l_apa13,g_aqe.aqe02,g_apz.apz33) RETURNING g_aqf[l_ac].apc06 
       LET l_amt = l_amtf* g_aqf[l_ac].apc06 
       DISPLAY BY NAME g_aqf[l_ac].apc04
       DISPLAY BY NAME g_aqf[l_ac].apc06                                      
#       CALL t600_aqf04('d')
       LET l_ac = l_ac + 1
      IF l_ac > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_aqf.deleteElement(l_ac)
    LET g_rec_b = l_ac-1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION t600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #CHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #No.FUN-A40055--begin
   DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_aqf TO s_aqf.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
        CALL cl_navigator_setting( g_curs_index, g_row_count )
     #    EXIT DISPLAY
        LET g_b_flag='1' 

     BEFORE ROW
       LET l_ac = DIALOG.getCurrentRow("s_aqf")
       CALL cl_show_fld_cont()     
      AFTER DISPLAY
     #     CONTINUE DISPLAY
        CONTINUE DIALOG         
   END DISPLAY  
   
   DISPLAY ARRAY g_aqg TO s_aqg.* ATTRIBUTE(COUNT=g_rec_b2)
      BEFORE DISPLAY
        CALL cl_navigator_setting( g_curs_index, g_row_count )
        LET g_b_flag='2' 
     BEFORE ROW
     LET l_ac = DIALOG.getCurrentRow("s_aqg")
     CALL cl_show_fld_cont()
   END DISPLAY  
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT  DIALOG
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT  DIALOG
 
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT  DIALOG
 
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT  DIALOG
 
      ON ACTION first
         CALL t600_fetch('F')
         EXIT DIALOG
 
      ON ACTION previous
         CALL t600_fetch('P')
         EXIT DIALOG
 
      ON ACTION jump
         CALL t600_fetch('/')
         EXIT DIALOG
 
      ON ACTION next
         CALL t600_fetch('N')
         EXIT  DIALOG
 
      ON ACTION last
         CALL t600_fetch('L')
         EXIT DIALOG
 
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
         IF g_aqe.aqe14 = 'X' THEN
            LET g_void = 'Y' ELSE LET g_void = 'N'
         END IF
         IF g_aqe.aqe15 = '1' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         CALL cl_set_field_pic(g_aqe.aqe14,g_chr2,"","",g_void,g_aqe.aqeacti)
 
         CALL t600_set_comb()
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
 
      ON ACTION account_detail #帳款單身
         LET g_action_choice="account_detail"
         EXIT DIALOG
     #No.FUN-A40055--begin 
     #ON ACTION qry_account_detail #帳款單身
     #   LET g_action_choice="qry_account_detail"
     #   EXIT DIALOG
     #No.FUN-A40055--begin 
 
      ON ACTION payment_detail #付款單身
         LET g_action_choice="payment_detail"
         EXIT DIALOG
      #No.FUN-A40055--begin
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
      #No.FUN-A40055--end    
      ON ACTION easyflow_approval
        LET g_action_choice = "easyflow_approval"
        EXIT DIALOG
 
      ON ACTION confirm     #確認
         LET g_action_choice="confirm"
         EXIT DIALOG
 
      ON ACTION undo_confirm     #取消確認
         LET g_action_choice="undo_confirm"
         EXIT DIALOG
 
      ON ACTION agree
         LET g_action_choice = 'agree'
         EXIT DIALOG
 
      ON ACTION deny
         LET g_action_choice = 'deny'
         EXIT DIALOG
 
      ON ACTION modify_flow
         LET g_action_choice = 'modify_flow'
         EXIT DIALOG
 
      ON ACTION withdraw
         LET g_action_choice = 'withdraw'
         EXIT DIALOG
 
      ON ACTION org_withdraw
         LET g_action_choice = 'org_withdraw'
         EXIT DIALOG
 
      ON ACTION phrase
         LET g_action_choice = 'phrase'
         EXIT DIALOG
 
      ON ACTION void   #作廢
         LET g_action_choice="void"
         EXIT DIALOG

      #FUN-D20035---add--str
      #取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG
      #FUN-D20035---add---end

      ON ACTION accept
         LET g_action_choice="detail"   #FUN-A40055 
         #LET l_ac = ARR_CURR()
      EXIT DIALOG
 
      ON ACTION cancel
         LET INT_FLAG=FALSE
         LET g_action_choice="exit"
         EXIT DIALOG
   
      ON ACTION ExportToExcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_aqf),base.TypeInfo.create(g_aqg),'')
         EXIT DIALOG
 
    #@ON ACTION 簽核狀況
      ON ACTION approval_status
         LET g_action_choice="approval_status"
         EXIT DIALOG
    
      ON ACTION controls                       #No.FUN-6B0033                                                                       	
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG
 
      &include "qry_string.4gl"
   END DIALOG
   #No.FUN-A40055--end
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t600_b2_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000  #CHAR(200)
 
    IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF
    LET g_sql = "SELECT aqg02,aqg03,aqg04,aqg08,aqg22,aqg23,", #FUN-970077 add aqg22,aqg23
                "       aqg05,aqg051,aqg11,'',aqg07,aqg09,aqg10,",
                "       aqg06f,aqg06,",
                "       aqgud01,aqgud02,aqgud03,aqgud04,aqgud05,",
                "       aqgud06,aqgud07,aqgud08,aqgud09,aqgud10,",
                "       aqgud11,aqgud12,aqgud13,aqgud14,aqgud15 ",
                " FROM aqg_file",
                " WHERE aqg01 ='",g_aqe.aqe01,"'",
                "   AND ",p_wc2 CLIPPED,
                " ORDER BY aqg02"
    PREPARE t600_pb2 FROM g_sql
    DECLARE aqg_curs CURSOR FOR t600_pb2
 
    CALL g_aqg.clear()
    LET g_cnt = 1
    FOREACH aqg_curs INTO g_aqg[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
       END IF
          SELECT nmc02 INTO g_aqg[g_cnt].nmc02 FROM nmc_file
             WHERE nmc01 = g_aqg[g_cnt].aqg11
       LET g_cnt = g_cnt + 1
    END FOREACH
    CALL g_aqg.deleteElement(g_cnt)
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn4
END FUNCTION
 
FUNCTION t600_out(p_cmd)
   DEFINE l_cmd                LIKE type_file.chr1000,  #CHAR(400)
          z1,z2                LIKE type_file.chr1000,  #CHAR(70),
          l_wc          LIKE type_file.chr1000,  #CHAR(200)
          p_cmd         LIKE type_file.chr1     #CHAR(1)
 
   CALL cl_wait()
   LET p_cmd= 'a'
   IF p_cmd= 'a' THEN
      LET l_wc = 'aqe01="',g_aqe.aqe01,'"'             # "新增"則印單張
   ELSE
      LET l_wc = g_wc CLIPPED,                              # 其他則印多張
                 "   AND aqe00 = '0'"
   END IF
   IF l_wc IS NULL THEN CALL cl_err('','9057',0) END IF
   #LET l_cmd = "aapr311",  #FUN-C30085 mark
   LET l_cmd = "aapg311",  #FUN-C30085 add
               " '",g_today CLIPPED,"' ''",
               " '",g_lang CLIPPED,"' 'Y' '' '1' '",
               l_wc CLIPPED,"' '",'0',"' 'Y' 'N' 'N' 'N' "
   CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION
 
FUNCTION t600_firm1_chk()
   DEFINE l_aqg04 LIKE aqg_file.aqg04,
          l_sql   STRING
 
 
   #LET g_success = 'Y'           #TQC-B10069
 
   IF g_aqe.aqe14 = 'X' THEN
     #CALL cl_err('','9024',0)                        #TQC-B10069
      CALL s_errmsg("aqe14",g_aqe.aqe01,"",'9024',1)  #TQC-B10069  
      LET g_success = 'N'
     #RETURN    #TQC-B10069
   END IF
 
   IF g_aqe.aqe14 = 'Y' THEN
     #CALL cl_err('','9023',0)                        #TQC-B10069
      CALL s_errmsg("aqe14",g_aqe.aqe01,"",'9023',1)  #TQC-B10069  
      LET g_success = 'N'
     #RETURN    #TQC-B10069
   END IF
 
   LET l_sql = "SELECT aqg04 FROM aqg_file WHERE aqg01 = '",g_aqe.aqe01,"'"
   PREPARE aqg04_p FROM l_sql
   DECLARE aqg04_c CURSOR FOR aqg04_p
   FOREACH aqg04_c INTO l_aqg04
     IF l_aqg04 = '2' AND cl_null(g_aqe.aqe13) THEN
       #CALL cl_err('','aap-101',1)                        #TQC-B10069
        CALL s_errmsg("aqg04",g_aqe.aqe01,"",'aap-101',1)  #TQC-B10069        
        LET g_success = 'N'
        #RETURN           #TQC-B10069 mark
        CONTINUE FOREACH  #TQC-B10069 add
     END IF
   END FOREACH

   #CHI-B10042 add --start--
   IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"
   THEN
      IF g_aqe.aqemksg='Y' THEN
         IF g_aqe.aqe15 != '1' THEN
            CALL s_errmsg("aqe15",g_aqe.aqe01,g_aqe.aqe15,'aws-078',1) 
            LET g_success = 'N'
         END IF
      END IF
   END IF
   #CHI-B10042 add --end--
END FUNCTION
 
#No.CHI-A80036   ---begin---
FUNCTION t600_firm1_chk1()
 DEFINE  only_one  LIKE type_file.chr1  
   #LET g_success = 'Y'     #TQC-B10069
   LET only_one = '1'
 
   IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"
   THEN
      IF g_action_choice CLIPPED = "insert" THEN #CHI-B10042 add
         IF g_aqe.aqemksg='Y' THEN
            IF g_aqe.aqe15 != '1' THEN
            #  CALL cl_err('','aws-078',1)            #TQC-B10069
               CALL s_errmsg("aqe15",g_aqe.aqe01,g_aqe.aqe15,'aws-078',1)  #TQC-B10069         
               LET g_success = 'N'
            #  RETURN      #TQC-B10069
            END IF
         END IF
      END IF #CHI-B10042 add
 
      OPEN WINDOW t600_w6 AT 8,6 WITH FORM "aap/42f/aapt600_6"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
      CALL cl_ui_locale("aapt600_6")
 
      LET only_one = '1'
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
      INPUT BY NAME only_one WITHOUT DEFAULTS
         AFTER FIELD only_one
            IF NOT cl_null(only_one) THEN
               IF only_one NOT MATCHES "[12]" THEN
                  NEXT FIELD only_one
               END IF
               IF only_one = '1' AND g_aqe.aqe01 IS NULL OR g_aqe.aqe01= ' ' THEN
                  NEXT FIELD only_one
               END IF
            END IF
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
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW t600_w6
         RETURN
      END IF
   END IF
 
   IF only_one = '1' THEN
      LET g_wc = " aqe01 = '",g_aqe.aqe01,"' "
   ELSE
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
      CONSTRUCT BY NAME g_wc ON aqe01,aqe02,aqe04,aqe05
 
            BEFORE CONSTRUCT
               CALL cl_qbe_init()
 
            ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(aqe01) #查詢單据
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_aqe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO aqe01
                    NEXT FIELD aqe01
                 WHEN INFIELD(aqe04) # Employee CODE
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gen"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO aqe04
                 WHEN INFIELD(aqe05) # Dept CODE
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gem"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO aqe05
                 OTHERWISE EXIT CASE
           END CASE
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
        ON ACTION about
           CALL cl_about()
   
        ON ACTION help
           CALL cl_show_help()
   
        ON ACTION controlg
           CALL cl_cmdask()
 
        ON ACTION qbe_select
           CALL cl_qbe_select()
 
        ON ACTION qbe_save
           CALL cl_qbe_save()
       END CONSTRUCT
       IF INT_FLAG THEN
          LET INT_FLAG=0
          CLOSE WINDOW t600_w6
          RETURN
       END IF
   END IF
 
   IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
      g_action_choice CLIPPED = "insert"
   THEN
       IF NOT cl_confirm('aap-222') THEN
          LET g_success = 'N'
          CLOSE WINDOW t600_w6
          RETURN
       END IF
#CHI-C30107 --------- add -------- begin
      IF only_one =  1 THEN
         CLOSE WINDOW t600_w6   #MOD-CA0136 add
         SELECT * INTO g_aqe.*  FROM aqe_file WHERE aqe01 = g_aqe.aqe01
         CALL t600_firm1_chk()
      END IF
#CHI-C30107 -------- add -------- end
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW t600_w6
      RETURN
   END IF

   IF only_one != '1' THEN
      LET g_sql = "SELECT * FROM aqe_file WHERE ",g_wc CLIPPED
      PREPARE aqe_pre1 FROM g_sql
      DECLARE aqe_cur1 CURSOR FOR aqe_pre1
      LET g_aqe_t.* = g_aqe.*
      FOREACH aqe_cur1 INTO g_aqe.*
         IF STATUS THEN
            CALL cl_err('foreach:',STATUS,1)
            LET g_success = 'N' 
            EXIT FOREACH
         END IF
         CALL t600_firm1_chk()
         IF g_success = 'N' THEN
           #EXIT FOREACH         #TQC-B10069
            CONTINUE FOREACH     #TQC-B10069
         END IF
      END FOREACH
      LET g_aqe.* = g_aqe_t.*
      CLOSE WINDOW t600_w6   #TQC-B20128 add
   END IF
END FUNCTION 
#No.CHI-A80036    ---end---

FUNCTION t600_firm1_upd()
 DEFINE  only_one  LIKE type_file.chr1        #  VARCHAR(1)
 DEFINE  l_amt     LIKE type_file.num20_6     #  DEC(20,6)
 DEFINE l_aqe09    LIKE aqe_file.aqe09
 DEFINE l_aqe08    LIKE aqe_file.aqe08
 DEFINE l_aqe09f   LIKE aqe_file.aqe09f
 DEFINE l_aqe08f   LIKE aqe_file.aqe08f
 DEFINE l_aqe02    LIKE aqe_file.aqe02
 DEFINE l_aqe01    LIKE aqe_file.aqe01
 DEFINE l_aqf04    LIKE aqf_file.aqf04
 DEFINE l_aqf05    LIKE aqf_file.aqf05
 DEFINE l_aqf05f   LIKE aqf_file.aqf05f   #CHI-7C0033
 DEFINE l_aqf06    LIKE aqf_file.aqf06
 DEFINE l_apc09    LIKE apc_file.apc09
 DEFINE l_apc11    LIKE apc_file.apc11
 DEFINE l_aqf03    LIKE aqf_file.aqf03       #No.TQC-6C0067
 DEFINE l_apa14    LIKE apa_file.apa14    #CHI-7C0033
 DEFINE l_azi04    LIKE azi_file.azi04    #CHI-7C0033
   LET g_success = 'Y'

#No.CHI-A80036  ----mark----begin
#  LET only_one = '1'
#
#  IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
#     g_action_choice CLIPPED = "insert"
#  THEN
#     IF g_aqe.aqemksg='Y' THEN
#        IF g_aqe.aqe15 != '1' THEN
#           CALL cl_err('','aws-078',1)
#           LET g_success = 'N'
#           RETURN
#        END IF
#     END IF
#
#     OPEN WINDOW t600_w6 AT 8,6 WITH FORM "aap/42f/aapt600_6"
#           ATTRIBUTE (STYLE = g_win_style CLIPPED)
#
#     CALL cl_ui_locale("aapt600_6")
#
#     LET only_one = '1'
#     CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
#
#     INPUT BY NAME only_one WITHOUT DEFAULTS
#        AFTER FIELD only_one
#           IF NOT cl_null(only_one) THEN
#              IF only_one NOT MATCHES "[12]" THEN
#                 NEXT FIELD only_one
#              END IF
#              IF only_one = '1' AND g_aqe.aqe01 IS NULL OR g_aqe.aqe01= ' ' THEN
#                 NEXT FIELD only_one
#              END IF
#           END IF
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
#
#        ON ACTION about
#           CALL cl_about()
#
#        ON ACTION help
#           CALL cl_show_help()
#
#        ON ACTION controlg
#           CALL cl_cmdask()
#
#     END INPUT
#
#     IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        CLOSE WINDOW t600_w6
#        RETURN
#     END IF
#  END IF
#
#  IF only_one = '1' THEN
#     LET g_wc = " aqe01 = '",g_aqe.aqe01,"' "
#  ELSE
#     CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
#
#     CONSTRUCT BY NAME g_wc ON aqe01,aqe02,aqe04,aqe05
#
#           BEFORE CONSTRUCT
#              CALL cl_qbe_init()
#
#           ON ACTION CONTROLP
#             CASE
#                WHEN INFIELD(aqe01) #查詢單据
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_aqe"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO aqe01
#                   NEXT FIELD aqe01
#                WHEN INFIELD(aqe04) # Employee CODE
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_gen"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO aqe04
#                WHEN INFIELD(aqe05) # Dept CODE
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.state = "c"
#                   LET g_qryparam.form ="q_gem"
#                   CALL cl_create_qry() RETURNING g_qryparam.multiret
#                   DISPLAY g_qryparam.multiret TO aqe05
#                OTHERWISE EXIT CASE
#          END CASE
#
#       ON IDLE g_idle_seconds
#          CALL cl_on_idle()
#          CONTINUE CONSTRUCT
#
#       ON ACTION about
#          CALL cl_about()
#  
#       ON ACTION help
#          CALL cl_show_help()
#  
#       ON ACTION controlg
#          CALL cl_cmdask()
#
#       ON ACTION qbe_select
#          CALL cl_qbe_select()
#
#       ON ACTION qbe_save
#          CALL cl_qbe_save()
#      END CONSTRUCT
#      IF INT_FLAG THEN
#         LET INT_FLAG=0
#         CLOSE WINDOW t600_w6
#         RETURN
#      END IF
#  END IF
#
#  IF g_action_choice CLIPPED = "confirm" OR #執行 "確認" 功能(非簽核模式呼叫)
#     g_action_choice CLIPPED = "insert"
#  THEN
#      IF NOT cl_confirm('aap-222') THEN
#         LET g_success = 'N'
#         CLOSE WINDOW t600_w6
#         RETURN
#      END IF
#  END IF
#
#  IF INT_FLAG THEN
#     LET INT_FLAG = 0
#     CLOSE WINDOW t600_w6
#     RETURN
#  END IF
#No.CHI-A80036   ---mark---end
 
   CALL cl_msg("WORKING !")
 
   BEGIN WORK
 
   LET g_sql = "SELECT SUM(aqe09) FROM aqe_file",
               " WHERE aqe14 = 'N' AND ",g_wc clipped
   PREPARE t600_firm1_p2 FROM g_sql
   DECLARE t600_firm1_c2 CURSOR FOR t600_firm1_p2
   OPEN t600_firm1_c2
   FETCH t600_firm1_c2 INTO l_amt
   IF l_amt IS NULL OR l_amt = ' ' THEN LET l_amt = 0 END IF
   DISPLAY BY NAME l_amt

#FUN-B50090 add begin-------------------------
   LET g_sql ="SELECT apz57 FROM apz_file ",
              " WHERE apz00 = '0'"
   PREPARE t600_apz57_p FROM g_sql
   EXECUTE t600_apz57_p INTO g_apz.apz57
#FUN-B50090 add -end--------------------------
 
   LET g_sql = "SELECT aqe01,aqe02,aqe08f,aqe09f FROM aqe_file",
               " WHERE aqe14 = 'N' AND ",g_wc clipped
   PREPARE t600_firm1_p3 FROM g_sql
   DECLARE t600_firm1_c3 CURSOR FOR t600_firm1_p3
   FOREACH t600_firm1_c3 INTO l_aqe01,l_aqe02,l_aqe08f,l_aqe09f
      IF l_aqe02<=g_apz.apz57 THEN
       # CALL cl_err(l_aqe02,'aap-176',1)   #TQC-B10069  
       # CLOSE WINDOW t600_w6               #TQC-B10069
         CALL s_errmsg("aqe02",g_aqe.aqe01,l_aqe02,'aap-176',1)  #TQC-B10069
         LET g_success='N'
       # RETURN              #TQC-B10069       
         CONTINUE FOREACH    #TQC-B10069 
      END IF
      IF l_aqe09f < l_aqe08f THEN
       # CALL cl_err('','aap-318',1)        #TQC-B10069
         CALL s_errmsg("aqe09f",g_aqe.aqe01,l_aqe09f,'aap-318',1)  #TQC-B10069 
       # CLOSE WINDOW t600_w6               #TQC-B10069
         LET g_success='N'
       # RETURN              #TQC-B10069
         CONTINUE FOREACH    #TQC-B10069
      END IF
      IF l_aqe09f > l_aqe08f THEN
       # CALL cl_err('','aap-319',1)     #TQC-B10069
         CALL s_errmsg("aqe09f",g_aqe.aqe01,l_aqe09f,'aap-319',1)  #TQC-B10069
       # CLOSE WINDOW t600_w6            #TQC-B10069 
         LET g_success='N'
       # RETURN              #TQC-B10069
         CONTINUE FOREACH    #TQC-B10069 
      END IF
 
      DECLARE t600_firm1_c4 CURSOR FOR SELECT aqf03,aqf04,aqf05f,aqf06  FROM aqf_file    #CHI-7C0033
                                        WHERE aqf01 =l_aqe01
      FOREACH t600_firm1_c4 INTO l_aqf03,l_aqf04,l_aqf05f,l_aqf06   #CHI-7C0033                     
         LET g_plant_new=l_aqf03 CALL s_getdbs()
        #LET g_sql ="SELECT apc09,apc11 FROM ",g_dbs_new,"apc_file",  #FUN-A50102
         LET g_sql ="SELECT apc09,apc11 FROM ",cl_get_target_table(g_plant_new,'apc_file'),   #FUN-A50102 
                    " WHERE apc01 = '",l_aqf04,"'",
                    "   AND apc02 = '",l_aqf06,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
         PREPARE t600_firm1_p4 FROM g_sql
         EXECUTE t600_firm1_p4 INTO l_apc09,l_apc11
        #LET g_sql = " SELECT apa14 FROM ",g_dbs_new CLIPPED,"apa_file",  #FUN-A50102
         LET g_sql = " SELECT apa14 FROM ",cl_get_target_table(g_plant_new,'apa_file'),  #FUN-A50102
                     " WHERE apa01 ='",l_aqf04,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
         PREPARE t600_firm1_p5 FROM g_sql
        #IF STATUS THEN CALL cl_err('',STATUS,0) END IF    #TQC-B10069
         IF STATUS THEN                        #TQC-B10069
            CALL s_errmsg('','','',STATUS,1)   #TQC-B10069 
         END IF                                #TQC-B10069
         EXECUTE t600_firm1_p5 INTO l_apa14
        #FUN-A50102--mod--str--
        #LET g_sql = " SELECT azi04 FROM ",g_dbs_new CLIPPED,"azi_file,",  
        #            g_dbs_new CLIPPED,"aza_file",
         LET g_sql = " SELECT azi04 ", 
                     "   FROM ",cl_get_target_table(g_plant_new,'azi_file'),
                     "       ,",cl_get_target_table(g_plant_new,'aza_file'),
        #FUN-A50102--mod--end
                     " WHERE aza17 = azi01"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
         PREPARE t600_firm1_p6 FROM g_sql
        #IF STATUS THEN CALL cl_err('',STATUS,0) END IF    #TQC-B10069
         IF STATUS THEN                        #TQC-B10069
            CALL s_errmsg('','','',STATUS,1)   #TQC-B10069
         END IF                                #TQC-B10069       
         EXECUTE t600_firm1_p6 INTO l_azi04
         LET l_aqf05 = cl_digcut(l_aqf05f * l_apa14,l_azi04)
         CALL t600_comp_oox1(l_aqf04,l_aqf06) RETURNING g_net  #No.FUN-7B0055
         IF  l_aqf05 + l_apc11 > l_apc09 + g_net  THEN
           # CALL cl_err(l_aqf05,'aap-982',1)   #TQC-B10069
             CALL s_errmsg("aqe05",g_aqe.aqe05,l_aqf05,'aap-982',1)  #TQC-B10069   
             LET g_success='N'
           # CLOSE WINDOW t600_w6    #TQC-B10069
           # RETURN              #TQC-B10069
             CONTINUE FOREACH    #TQC-B10069          
         END IF
      END FOREACH
   END FOREACH       
 
   CALL  t600_bu()
      IF g_success = 'Y' THEN
         IF g_aqe.aqemksg = 'Y' THEN #簽核模式
            CASE aws_efapp_formapproval()            #呼叫 EF 簽核功能
                 WHEN 0  #呼叫 EasyFlow 簽核失敗
                      LET g_aqe.aqe14="N"
                      LET g_success = "N"
                      ROLLBACK WORK
                      RETURN
                 WHEN 2  #當最後一關有兩個以上簽核者且此次簽核完成後尚未結案
                      LET g_aqe.aqe14="N"
                      ROLLBACK WORK
                      RETURN
            END CASE
         END IF
          IF g_success='Y' THEN
            LET g_aqe.aqe15='1'              #執行成功, 狀態值顯示為 '1' 已核准
            LET g_aqe.aqe14='Y'              #執行成功, 確認碼顯示為 'Y' 已確認
            UPDATE aqe_file SET aqe14 = g_aqe.aqe14,
                                aqe15 = g_aqe.aqe15   
            WHERE aqe01 = g_aqe.aqe01
            DISPLAY BY NAME g_aqe.aqe14
            DISPLAY BY NAME g_aqe.aqe15
            COMMIT WORK
            CALL cl_flow_notify(g_aqe.aqe01,'Y')
         ELSE
            LET g_aqe.aqe14='N'
            LET g_success = 'N'
            ROLLBACK WORK
         END IF
      ELSE
         LET g_aqe.aqe14='N'
         LET g_success = 'N'
         ROLLBACK WORK
      END IF
    
      SELECT * INTO g_aqe.* FROM aqe_file WHERE aqe01 = g_aqe.aqe01
      IF g_aqe.aqe14='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
      IF g_aqe.aqe15='1' OR
         g_aqe.aqe15='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
      IF g_aqe.aqe15='6' THEN LET g_chr3='Y' ELSE LET g_chr3='N' END IF
      CALL cl_set_field_pic(g_aqe.aqe14,g_chr2,"",g_chr3,g_chr,g_aqe.aqeacti)
END FUNCTION
 
 
 
FUNCTION t600_ef()
   CALL s_showmsg_init()     #TQC-B10069
   LET g_success = 'Y'       #TQC-B10069
   CALL t600_firm1_chk()     #CALL 原確認的 check 段
   CALL s_showmsg()          #TQC-B10069
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
 
  IF aws_efcli2(base.TypeInfo.create(g_aqe),base.TypeInfo.create(g_aqf),base.TypeInfo.create(g_aqg),'','','') THEN
     LET g_success = 'Y'
     LET g_aqe.aqe15 = 'S'
     DISPLAY BY NAME g_aqe.aqe15
  ELSE
     LET g_success = 'N'
  END IF
 
END FUNCTION
 
 
 
FUNCTION t600_ins_nme(p_code,p_plant)
   DEFINE p_plant          LIKE apg_file.apg03
   DEFINE p_code           LIKE type_file.chr1
   DEFINE l_dbs            STRING
   DEFINE l_nme            RECORD LIKE nme_file.*
   DEFINE l_aqf            RECORD LIKE aqf_file.*
   DEFINE l_aqg            RECORD LIKE aqg_file.*
   DEFINE l_aqd            RECORD LIKE aqd_file.*
   DEFINE l_aqf04          LIKE aqf_file.aqf04
   DEFINE l_apa13          LIKE apa_file.apa13
   DEFINE l_apa13_1        LIKE apa_file.apa13
   DEFINE l_flag           LIKE type_file.chr1 
   DEFINE l_legal          LIKE azw_file.azw02  #FUN-980001 add

#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
   
   IF g_apz.apz04 = 'N' THEN RETURN END IF
   LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new
   LET g_sql=" SELECT SUM(aqf05f),SUM(aqf05) FROM aqf_file ",
             "  WHERE aqf01 ='",g_aqe.aqe01,"'",
             "    AND aqf03!='",g_plant,"'",
             "    AND aqf03 ='",p_plant,"'"
   PREPARE t600_sel_aqf_c0 FROM g_sql
   IF STATUS THEN CALL cl_err('',STATUS,0) END IF
   EXECUTE t600_sel_aqf_c0 INTO l_nme.nme04,l_nme.nme08
   IF STATUS THEN
      CALL cl_err('sel apf05:',STATUS,1)
      LET g_success='N'
      RETURN
   END IF
   DECLARE t600_sel_aqg_c1 CURSOR FOR                                                                                                         
     SELECT * FROM aqg_file                                                                                     
      WHERE aqg01 =g_aqe.aqe01
   IF p_code ='1' THEN
      FOREACH t600_sel_aqg_c1 INTO l_aqg.*
         LET l_nme.nme00=0
         LET l_nme.nme01=l_aqg.aqg08
         LET l_nme.nme02=g_aqe.aqe02
         LET l_nme.nme03=l_aqg.aqg11
         LET l_nme.nme04=l_aqg.aqg06f
         LET l_nme.nme07=l_aqg.aqg10
         LET l_nme.nme08=l_aqg.aqg06
         LET l_nme.nme11=g_aqe.aqe10
         LET l_nme.nme21=l_aqg.aqg02                          #MOD-CA0136 add
         SELECT apf01,aph03 INTO l_nme.nme12,l_nme.nme23 FROM apf_file,aph_file     #No.FUN-730032  #No.TQC-750040
          WHERE apf992=g_aqe.aqe01 
            AND apf01 =aph01                                                   #No.FUN-730032
            AND aph02 = l_nme.nme21                           #MOD-CA0136 add
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","apf01",g_aqe.aqe01,"",SQLCA.sqlcode,"","",1)
            LET g_success='N'
         END IF
         LET l_nme.nme22='01'         #No.FUN-730032
         LET l_nme.nme24='9'          #No.FUN-730032
         LET l_nme.nme25=g_aqe.aqe03  #No.FUN-730032
         LET l_nme.nme13=g_aqe.aqe11
         LET l_nme.nme14=g_aqe.aqe13
         LET l_nme.nme15=g_aqe.aqe05
         LET l_nme.nme16=g_aqe.aqe02
         LET l_nme.nme17 = ""
         LET l_nme.nmeacti='Y'
         LET l_nme.nmeuser=g_user
         LET l_nme.nmegrup=g_grup
         LET l_nme.nmedate=g_today
         LET l_nme.nmeoriu=g_user    #TQC-A10060  add
         LET l_nme.nmeorig=g_grup    #TQC-A10060  add
        #LET l_nme.nme21=l_aqg.aqg02         #No.FUN-9C0012  #MOD-CA0136 mark

#FUN-B30166--add--str
   LET l_date1 = g_today
   LET l_year = YEAR(l_date1)USING '&&&&'
   LET l_month = MONTH(l_date1) USING '&&'
   LET l_day = DAY(l_date1) USING  '&&'
   LET l_time = TIME(CURRENT)
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                l_time[1,2],l_time[4,5],l_time[7,8]
   SELECT MAX(nme27) + 1 INTO l_nme.nme27 FROM nme_file
   WHERE nme27[1,14] = l_dt
  IF cl_null(l_nme.nme27) THEN
     LET l_nme.nme27 = l_dt,'000001'
  END if
#FUN-B30166--add--end

         LET g_sql="INSERT INTO nme_file",
                   "(nme00,nme01,nme02,nme021,nme03,nme04,nme05,nme06,nme07,nme08,",
                   "nme09,nme10,nme11,nme12,nme13,nme14,nme15,nme16,nme17,nme18,",
#                  "nme19,nme20,nmeacti,nmeuser,nmegrup,nmemodu,nmedate,nme061,nme21,nme22,nme23,nme24,nme25,nmelegal,nmeoriu,nmeorig)",   #TQC-A10060 add nmeoriu,nmeorig     #No.FUN-730032 #FUN-980001 add nmelegal #FUN-B30166 Mark
                   "nme19,nme20,nmeacti,nmeuser,nmegrup,nmemodu,nmedate,nme061,nme21,nme22,nme23,nme24,nme25,nme27,nmelegal,nmeoriu,nmeorig)",   #TQC-A10060 add nmeoriu,nmeorig     #No.FUN-730032 #FUN-980001 add nmelegal #FUN-B30166 add nme27
#                  " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"     #TQC-A10060 add ?,?    #No.FUN-730032 #FUN-980001 add ? #FUN-B30166 Mark
                   " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"     #TQC-A10060 add ?,?    #No.FUN-730032 #FUN-980001 add ? #FUN-B30166 add  ?
         PREPARE t600_y_nme_p FROM g_sql
         IF STATUS THEN CALL cl_err('',STATUS,0) END IF

         EXECUTE t600_y_nme_p USING l_nme.nme00,l_nme.nme01,l_nme.nme02,l_nme.nme021,l_nme.nme03,l_nme.nme04,l_nme.nme05,l_nme.nme06,l_nme.nme07,l_nme.nme08,
                                    l_nme.nme09,l_nme.nme10,l_nme.nme11,l_nme.nme12,l_nme.nme13,l_nme.nme14,l_nme.nme15,l_nme.nme16,l_nme.nme17,l_nme.nme18,
                                    #l_nme.nme19,l_nme.nme20,l_nme.nmeacti,l_nme.nmeuser,l_nme.nmegrup,l_nme.nmemodu,l_nme.nmedate,l_nme.nme061,l_nme.nme21,l_nme.nme22,l_nme.nme23,l_nme.nme24,l_nme.nme25    #No.FUN-730032 #FUN-980001 mark
#                                   l_nme.nme19,l_nme.nme20,l_nme.nmeacti,l_nme.nmeuser,l_nme.nmegrup,l_nme.nmemodu,l_nme.nmedate,l_nme.nme061,l_nme.nme21,l_nme.nme22,l_nme.nme23,l_nme.nme24,l_nme.nme25,g_legal    #No.FUN-730032 #FUN-980001 add #FUN-B30166 Mark
                                    l_nme.nme19,l_nme.nme20,l_nme.nmeacti,l_nme.nmeuser,l_nme.nmegrup,l_nme.nmemodu,l_nme.nmedate,l_nme.nme061,l_nme.nme21,l_nme.nme22,l_nme.nme23,l_nme.nme24,l_nme.nme25,l_nme.nme27,g_legal    #No.FUN-730032 #FUN-980001 add #FUN-B30166 add l_nme.nme27
                                   ,l_nme.nmeoriu,l_nme.nmeorig    #TQC-A10060  add
         IF STATUS THEN
            CALL cl_err('ins nme:',STATUS,1)
            LET g_success='N'
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err('ins nme:',SQLCA.SQLCODE,1)
            LET g_success='N'
            RETURN
         END IF
         CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062         
      END FOREACH
   ELSE
      LET l_nme.nme00=0
      SELECT aqd06,aqd16 INTO  l_nme.nme01,l_nme.nme03
        FROM aqd_file
       WHERE aqd01 = p_plant
      LET l_nme.nme02=g_aqe.aqe02
      IF cl_null(l_nme.nme08) THEN
         LET l_nme.nme08 =0
      END IF
      LET l_nme.nme07=l_nme.nme08/l_nme.nme04
      LET l_nme.nme11=g_aqe.aqe10
     #FUN-A50102--mod--str--
     #LET g_sql=" SELECT apf01,aph02,aph03 FROM ",l_dbs,"apf_file,",l_dbs,"aph_file",       #No.FUN-730032
      LET g_sql=" SELECT apf01,aph02,aph03 ",
                "   FROM ",cl_get_target_table(g_plant_new,'apf_file'),
                "       ,",cl_get_target_table(g_plant_new,'aph_file'),
     #FUN-A50102--mod--end
                "  WHERE apf992='",g_aqe.aqe01,"'",
                "    AND apf01 = aph01"                                                     #No.FUN-730032
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE t600_sel_aqf_p FROM g_sql
      DECLARE t600_sel_aqf_curo CURSOR FOR t600_sel_aqf_p   #MOD-8C0013 add
      IF STATUS THEN CALL cl_err('',STATUS,0) END IF

      LET l_nme.nme13=g_aqe.aqe11
     #LET g_sql ="SELECT nmc05 FROM ",l_dbs,"nmc_file",   #FUN-A50102
      LET g_sql ="SELECT nmc05 FROM ",cl_get_target_table(g_plant_new,'nmc_file'),   #FUN-A50102 
                 " WHERE nmc01 ='",l_nme.nme03,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE t600_ins_nme_p FROM g_sql
      IF STATUS THEN CALL cl_err('',STATUS,0) END IF
      EXECUTE t600_ins_nme_p INTO l_nme.nme14
      IF STATUS THEN
         CALL cl_err('sel nmc05:',STATUS,1)
         LET g_success='N'
         RETURN
      END IF
      LET l_nme.nme15=g_aqe.aqe05
      LET l_nme.nme16=g_aqe.aqe02
      LET l_nme.nme17 = ""
      LET l_nme.nmeacti='Y'
      LET l_nme.nmeuser=g_user
      LET l_nme.nmegrup=g_grup
      LET l_nme.nmedate=g_today
      LET l_nme.nmeoriu=g_user    #TQC-A10060  add
      LET l_nme.nmeorig=g_grup    #TQC-A10060  add

#FUN-B30166--add--str
   LET l_date1 = g_today
   LET l_year = YEAR(l_date1)USING '&&&&'
   LET l_month = MONTH(l_date1) USING '&&'
   LET l_day = DAY(l_date1) USING  '&&'
   LET l_time = TIME(CURRENT)
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                l_time[1,2],l_time[4,5],l_time[7,8]
   SELECT MAX(nme27) + 1 INTO l_nme.nme27 FROM nme_file
    WHERE nme27[1,14] = l_dt
   IF cl_null(l_nme.nme27) THEN
      LET l_nme.nme27 = l_dt,'000001'
   END if
#FUN-B30166--add--end

     #LET g_sql="INSERT INTO ",l_dbs CLIPPED,"nme_file",  #FUN-A50102
      LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'nme_file'),   #FUN-A50102
                "(nme00,nme01,nme02,nme021,nme03,nme04,nme05,nme06,nme07,nme08,",
                "nme09,nme10,nme11,nme12,nme13,nme14,nme15,nme16,nme17,nme18,",
#               "nme19,nme20,nmeacti,nmeuser,nmegrup,nmemodu,nmedate,nme061,nme21,nme22,nme23,nme24,nme25,nmelegal,nmeoriu,nmeorig)",#TQC-A10060 add nmeoriu,nmeorig #FUN-980001 add nmelegal #FUN-B30166 Mark
                "nme19,nme20,nmeacti,nmeuser,nmegrup,nmemodu,nmedate,nme061,nme21,nme22,nme23,nme24,nme25,nme27,nmelegal,nmeoriu,nmeorig)",#TQC-A10060 add nmeoriu,nmeorig #FUN-980001 add nmelegal #FUN-B30166 add nme27
#               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,? ,?,?)"   #TQC-A10060 add ?,?     #No.FUN-730032 #FUN-980001 add ?  #FUN-B30166 Mark
                " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,? ,?,?,?)"   #TQC-A10060 add ?,?     #No.FUN-730032 #FUN-980001 add ?  #FUN-B30166 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
      PREPARE t600_y_nme_p1 FROM g_sql
      IF STATUS THEN CALL cl_err('',STATUS,0) END IF
      CALL s_getlegal(g_plant_new) RETURNING l_legal  #FUN-980001 add
      FOREACH t600_sel_aqf_curo INTO l_nme.nme12,l_nme.nme21,l_nme.nme23   #MOD-8C0013
         LET l_nme.nme22 ='X'
         LET l_nme.nme24 ='9'

         EXECUTE t600_y_nme_p1 USING l_nme.nme00,l_nme.nme01,l_nme.nme02,l_nme.nme021,l_nme.nme03,l_nme.nme04,l_nme.nme05,l_nme.nme06,l_nme.nme07,l_nme.nme08,
                                     l_nme.nme09,l_nme.nme10,l_nme.nme11,l_nme.nme12,l_nme.nme13,l_nme.nme14,l_nme.nme15,l_nme.nme16,l_nme.nme17,l_nme.nme18,
                                     #l_nme.nme19,l_nme.nme20,l_nme.nmeacti,l_nme.nmeuser,l_nme.nmegrup,l_nme.nmemodu,l_nme.nmedate,l_nme.nme061,l_nme.nme21,l_nme.nme22,l_nme.nme23,l_nme.nme24,l_nme.nme25  #FUN-980001 mark
#                                    l_nme.nme19,l_nme.nme20,l_nme.nmeacti,l_nme.nmeuser,l_nme.nmegrup,l_nme.nmemodu,l_nme.nmedate,l_nme.nme061,l_nme.nme21,l_nme.nme22,l_nme.nme23,l_nme.nme24,l_nme.nme25,l_legal #FUN-980001 add #FUN-B30166 Mark
                                     l_nme.nme19,l_nme.nme20,l_nme.nmeacti,l_nme.nmeuser,l_nme.nmegrup,l_nme.nmemodu,l_nme.nmedate,l_nme.nme061,l_nme.nme21,l_nme.nme22,l_nme.nme23,l_nme.nme24,l_nme.nme25,l_nme.nme27,l_legal #FUN-980001 add #FUN-B30166 add l_nme.nme27
                                    ,l_nme.nmeoriu,l_nme.nmeorig    #TQC-A10060  add
         IF STATUS THEN
            CALL cl_err('ins nme:',STATUS,1)
            LET g_success='N'
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err('ins nme:',SQLCA.SQLCODE,1)
             LET g_success='N'
             RETURN
         END IF 
         CALL s_flows_nme(l_nme.*,'1',g_plant_new)   #No.FUN-B90062   
      END FOREACH      
#在總部插入與分公司的nme對應的nme資料
      SELECT aqd06,aqd15 INTO  l_nme.nme01,l_nme.nme03
        FROM aqd_file
       WHERE aqd01 = g_plant
      SELECT nmc05 INTO l_nme.nme14 FROM nmc_file WHERE nmc01 =l_nme.nme03
      IF STATUS THEN
         CALL cl_err('sel nmc05:',STATUS,1)
         LET g_success='N'
         RETURN
      END IF
      DECLARE t600_sel_apf_c9 CURSOR FOR 
      SELECT apf01,aph02,aph03 FROM apf_file,aph_file
       WHERE apf992=g_aqe.aqe01
         AND aph01 =apf01
      IF STATUS THEN
         CALL cl_err('sel apf01:',STATUS,1)
         LET g_success='N'
         RETURN
      END IF
      LET l_nme.nme22 ='01'
      LET l_nme.nme24 ='X'
      FOREACH t600_sel_apf_c9 INTO l_nme.nme12,l_nme.nme21,l_nme.nme23
#FUN-B30166--add--str
   LET l_date1 = g_today
   LET l_year = YEAR(l_date1)USING '&&&&'
   LET l_month = MONTH(l_date1) USING '&&'
   LET l_day = DAY(l_date1) USING  '&&'
   LET l_time = TIME(CURRENT)
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                l_time[1,2],l_time[4,5],l_time[7,8]
   SELECT MAX(nme27) + 1 INTO l_nme.nme27 FROM nme_file
    WHERE nme27[1,14] = l_dt
   IF cl_null(l_nme.nme27) THEN
      LET l_nme.nme27 = l_dt,'000001'
   END if
#FUN-B30166--add--end
         INSERT INTO nme_file
         (nme00,nme01,nme02,nme021,nme03,nme04,nme05,nme06,nme07,nme08,
         nme09,nme10,nme11,nme12,nme13,nme14,nme15,nme16,nme17,nme18,
#        nme19,nme20,nmeacti,nmeuser,nmegrup,nmemodu,nmedate,nme061,nme21,nme22,nme23,nme24,nme25,nmelegal,nmeoriu,nmeorig) #FUN-980001 add FUN-B30166 Mark
         nme19,nme20,nmeacti,nmeuser,nmegrup,nmemodu,nmedate,nme061,nme21,nme22,nme23,nme24,nme25,nme27,nmelegal,nmeoriu,nmeorig) #FUN-980001 add FUN-B30166 add nme27
          VALUES(l_nme.nme00,l_nme.nme01,l_nme.nme02,l_nme.nme021,l_nme.nme03,l_nme.nme04,l_nme.nme05,l_nme.nme06,l_nme.nme07,l_nme.nme08,
                 l_nme.nme09,l_nme.nme10,l_nme.nme11,l_nme.nme12,l_nme.nme13,l_nme.nme14,l_nme.nme15,l_nme.nme16,l_nme.nme17,l_nme.nme18,
#                l_nme.nme19,l_nme.nme20,l_nme.nmeacti,l_nme.nmeuser,l_nme.nmegrup,l_nme.nmemodu,l_nme.nmedate,l_nme.nme061,l_nme.nme21,l_nme.nme22,l_nme.nme23,l_nme.nme24,l_nme.nme25,g_legal, g_user, g_grup) #FUN-980001 add      #No.FUN-980030 10/01/04  insert columns oriu, orig    #FUN-B30166 Mark
                 l_nme.nme19,l_nme.nme20,l_nme.nmeacti,l_nme.nmeuser,l_nme.nmegrup,l_nme.nmemodu,l_nme.nmedate,l_nme.nme061,l_nme.nme21,l_nme.nme22,l_nme.nme23,l_nme.nme24,l_nme.nme25,l_nme.nme27,g_legal, g_user, g_grup) #FUN-980001 add      #No.FUN-980030 10/01/04  insert columns oriu, orig    #FUN-B30166 add l_nme.nme27
         IF STATUS THEN
            CALL cl_err('ins nme:',STATUS,1)
            LET g_success='N'
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err('ins nme:',SQLCA.SQLCODE,1)
             LET g_success='N'
             RETURN
         END IF  
         CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062   
      END FOREACH
   END IF
END FUNCTION
 
 
 
FUNCTION t600_firm2()
   DEFINE  l_amt   LIKE type_file.num20_6     #DEC(20,6) 
   DEFINE  l_cnt   LIKE type_file.num5        #SMALLINT 
   DEFINE  l_sql   LIKE type_file.chr1000     #CHAR(1000)
   DEFINE  l_aqf03 LIKE aqf_file.aqf03
   DEFINE  l_dbs   STRING                
 
   IF g_aqe.aqe01 IS NULL THEN RETURN END IF
   SELECT * INTO g_aqe.* FROM aqe_file
    WHERE aqe01=g_aqe.aqe01
   IF g_aqe.aqe14 = 'N' THEN RETURN END IF
   IF g_aqe.aqe14 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_aqe.aqe15 = "S" THEN
      CALL cl_err("","mfg3557",0)
      RETURN
   END IF
 
   LET g_wc = " aqe01 = '",g_aqe.aqe01,"' "
   IF g_priv2='4' THEN                           #只能使用自己的資料
      LET g_wc = g_wc clipped," AND aqeuser = '",g_user,"'"
   END IF
   IF g_priv3='4' THEN                           #只能使用自己的資料
      LET g_wc = g_wc clipped," AND aqegrup = '",g_grup,"'"
   END IF
   LET g_sql = "SELECT SUM(aqe09) FROM aqe_file",
               " WHERE aqe14 != 'N' AND ",g_wc clipped
   PREPARE t600_firm2_p2 FROM g_sql
   DECLARE t600_firm2_c2 CURSOR FOR t600_firm2_p2
   OPEN t600_firm2_c2
   FETCH t600_firm2_c2 INTO l_amt
   IF l_amt IS NULL OR l_amt = ' ' THEN LET l_amt = 0 END IF
   DISPLAY BY NAME l_amt
   IF cl_confirm('aap-224') THEN
      MESSAGE "WORKING !"
   END IF
   IF g_aqe.aqe01 IS NOT NULL THEN
      SELECT aqe14 INTO g_aqe.aqe14 FROM aqe_file WHERE aqe01 = g_aqe.aqe01
      DISPLAY BY NAME g_aqe.aqe14   #MOD-860257 mod aqe13->aqe14
      SELECT aqe15 INTO g_aqe.aqe15 FROM aqe_file WHERE aqe01 = g_aqe.aqe01
      DISPLAY BY NAME g_aqe.aqe15
   END IF
   LET g_sql ="SELECT UNIQUE(aqf03) FROM aqf_file",
              " WHERE aqf00 ='",g_aqe.aqe00,"'",
              "   AND aqf01 ='",g_aqe.aqe01,"'",
              "   AND aqf03 != '",g_plant CLIPPED,"'"
   PREPARE t600_sel_aqf_p3 FROM g_sql
   IF STATUS THEN CALL cl_err('',STATUS,0) END IF
   DECLARE t600_sel_aqf_c3 CURSOR FOR t600_sel_aqf_p3
 
   BEGIN WORK
   LET g_success ='Y'
          #在付款法人體數據庫中刪除付款單aapt330的資料
          #先查aapt330是否已拋轉過總帳（apf44和對應的分錄底稿nppglno），如果已拋轉過則全部回轉
          CALL t600_chk_voucher(g_plant)
          IF g_success ='Y' THEN
             CALL t600_upd_apac('1')                    #根據帳款單身更新各數據庫中該廠商的應付款已付款金額
             CALL t600_del_nme(g_plant)                 #如果沒有拋轉過則刪除對應的銀行異動資料(外部銀行和內部銀行)
             CALL t600_del_npp(g_plant)                 #如果沒有拋轉過則刪除對應的分錄底稿單頭資料
             CALL t600_del_npq(g_plant)                 #如果沒有拋轉過則刪除對應的分錄底稿單身資料
             CALL t600_del_aph(g_plant)                 #如果沒有拋轉過則刪除對應的付款單付款單身資料
             CALL t600_del_apg(g_plant)                 #如果沒有拋轉過則刪除對應的付款單帳款單身資料
             CALL t600_del_apf(g_plant)                 #如果沒有拋轉過則刪除對應的付款單單頭資
          END IF
          #在付款法人體數據庫刪除對被付法人體的待扺應付款aapt220的資料
          #先檢查對被付款法人的待扺帳款aapt220有沒有被衝過帳，如有衝過則全部回轉
          CALL t600_chk_contra(g_plant)
          IF g_success ='Y' THEN
             CALL t600_del_apac(g_plant)                #如果沒被衝過則刪除對應的待扺帳款單資料
          END IF
          #在被付款法人體數據庫刪除付款單aapt330的資料
          #先檢查有沒有拋轉過總帳(apf44和對應的分錄底稿nppglno),如果已拋轉過則全部回轉   
          FOREACH t600_sel_aqf_c3 INTO l_aqf03
             CALL t600_chk_voucher(l_aqf03)
             IF g_success ='Y' THEN
                CALL t600_del_npp(l_aqf03)
                CALL t600_del_npq(l_aqf03)
                CALL t600_del_nme(l_aqf03)
                CALL t600_del_aph(l_aqf03)
                CALL t600_del_apg(l_aqf03)
                CALL t600_del_apf(l_aqf03)
             ELSE
             	 ROLLBACK WORK
             	 RETURN
             END IF             
             #在被付款法人體數據庫刪除對付款法人體的應付帳款aapt120的資料
             #先檢查對付款法人的應付帳款aapt120有沒有被衝過帳，如有衝過則全部回轉
             CALL t600_chk_contra(l_aqf03)
             IF g_success ='Y' THEN
                CALL t600_del_apac(l_aqf03)                #如果沒被衝過則刪除對應的應付帳款單資料
             ELSE
             	 ROLLBACK WORK
             	 RETURN
             END IF
          END FOREACH
          IF g_success ='Y' THEN
             LET g_aqe.aqe15='0'              #執行成功, 狀態值顯示為 '0' 已核准
             LET g_aqe.aqe14='N'              #執行成功, 確認碼顯示為 'N' 已確認
             UPDATE aqe_file SET aqe14 = g_aqe.aqe14,
                                 aqe15 = g_aqe.aqe15   
             WHERE aqe01 = g_aqe.aqe01
             DISPLAY BY NAME g_aqe.aqe14
             DISPLAY BY NAME g_aqe.aqe15
             COMMIT WORK
          ELSE
            	ROLLBACK WORK
          END IF
END FUNCTION
 
FUNCTION t600_chk_voucher(p_plant)
   DEFINE   p_plant        LIKE type_file.chr21
   DEFINE   l_dbs          STRING
   DEFINE   l_apf01        LIKE apf_file.apf01
   DEFINE   l_apf44        LIKE apf_file.apf44
   DEFINE   l_nppglno      LIKE npp_file.nppglno
   DEFINE   l_nppglno1     LIKE npp_file.nppglno
   DEFINE   l_aza63        LIKE aza_file.aza63       #No.TQC-6C0067
   
    LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new
    LET g_sql = " SELECT aza63 ",  
               #"   FROM ",l_dbs CLIPPED,"aza_file ",   #FUN-A50102
                "   FROM ",cl_get_target_table(g_plant_new,'aza_file'),   #FUN-A50102 
                "  WHERE aza01 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
    PREPARE t600_aza63_p FROM g_sql
    DECLARE t600_aza63 CURSOR FOR t600_aza63_p
    OPEN t600_aza63  
    FETCH t600_aza63 INTO l_aza63
   #LET g_sql="SELECT apf01,apf44 FROM ",l_dbs CLIPPED,"apf_file",  #FUN-A50102
    LET g_sql="SELECT apf01,apf44 FROM ",cl_get_target_table(g_plant_new,'apf_file'), #FUN-A50102
             " WHERE apf992 ='",g_aqe.aqe01,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
    PREPARE t600_sel_apf44_p FROM g_sql
    IF STATUS THEN CALL cl_err('',STATUS,0) END IF
    DECLARE t600_sel_apf44_c CURSOR FOR t600_sel_apf44_p
    FOREACH t600_sel_apf44_c INTO l_apf01,l_apf44
      #LET g_sql="SELECT nppglno FROM ",l_dbs CLIPPED,"npp_file",   #FUN-A50102
       LET g_sql="SELECT nppglno FROM ",cl_get_target_table(g_plant_new,'npp_file'),   #FUN-A50102
                " WHERE npp01 ='",l_apf01,"'",
                "   AND nppsys='AP'",
                "   AND npp00 ='3'",
                "   AND npp011='1'",
                "   AND npptype ='0'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
       PREPARE t600_sel_nppglno_p FROM g_sql
       IF STATUS THEN CALL cl_err('',STATUS,0) END IF
       EXECUTE t600_sel_nppglno_p INTO l_nppglno
       IF l_aza63 ='Y' THEN         #No.TQC-6C0067
         #LET g_sql="SELECT nppglno FROM ",l_dbs CLIPPED,"npp_file",  #FUN-A50102
          LET g_sql="SELECT nppglno FROM ",cl_get_target_table(g_plant_new,'npp_file'),   #FUN-A50102
                    " WHERE npp01 ='",l_apf01,"'",
                    "   AND nppsys='AP'",
                    "   AND npp00 ='3'",
                    "   AND npp011='1'",
                    "   AND npptype ='1'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
         PREPARE t600_sel_nppglno_p1 FROM g_sql
         IF STATUS THEN CALL cl_err('',STATUS,0) END IF
         EXECUTE t600_sel_nppglno_p1 INTO l_nppglno1
         IF NOT cl_null(l_apf44) OR NOT cl_null(l_nppglno) OR NOT cl_null(l_nppglno1) THEN
            CALL cl_err('','axm-316','1')
            LET g_success ='N'
            RETURN
         END IF
       ELSE
         IF NOT cl_null(l_apf44) OR NOT cl_null(l_nppglno)  THEN
            CALL cl_err('','axm-316','1')
            LET g_success ='N'
            RETURN
         END IF     	
       END IF
    END FOREACH
END FUNCTION
 
FUNCTION t600_chk_contra(p_plant)
   DEFINE   p_plant        LIKE type_file.chr21
   DEFINE   l_dbs          STRING
   DEFINE l_apa35     LIKE apa_file.apa35
   DEFINE l_apa35f    LIKE apa_file.apa35f
 
    LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET g_sql="SELECT apa35,apa35f FROM ",l_dbs CLIPPED,"apa_file",
    LET g_sql="SELECT apa35,apa35f FROM ",cl_get_target_table(g_plant_new,'apa_file'),   #FUN-A50102   
             " WHERE apa992 ='",g_aqe.aqe01,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
    PREPARE t600_sel_apa35_p FROM g_sql
    IF STATUS THEN CALL cl_err('',STATUS,0) END IF
    DECLARE t600_sel_apa35_c CURSOR FOR t600_sel_apa35_p
    FOREACH t600_sel_apa35_c INTO l_apa35,l_apa35f
        IF l_apa35 >0 OR l_apa35f>0 THEN
           CALL cl_err('','axm-316','1')
           LET g_success ='N'
           ROLLBACK WORK
           RETURN
        END IF
    END FOREACH        
END FUNCTION
 
FUNCTION t600_del_apac(p_plant)
   DEFINE   p_plant        LIKE type_file.chr21
   DEFINE   l_dbs          STRING
   DEFINE   l_apa01    LIKE apa_file.apa01
   
    LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET g_sql="DELETE FROM ",l_dbs CLIPPED,"apa_file",  #FUN-A50102
    LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'apa_file'), #FUN-A50102  
             " WHERE apa01 = ?"  
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
    PREPARE t600_del_apa_p FROM g_sql
    IF STATUS THEN CALL cl_err('',STATUS,0) END IF  
   #LET g_sql="DELETE FROM ",l_dbs CLIPPED,"apc_file",  #FUN-A50102
    LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'apc_file'),   #FUN-A50102
             " WHERE apc01 = ?"  
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
    PREPARE t600_del_apc_p FROM g_sql
    IF STATUS THEN CALL cl_err('',STATUS,0) END IF  
   #LET g_sql="SELECT apa01 FROM ",l_dbs CLIPPED,"apa_file",  #FUN-A50102
    LET g_sql="SELECT apa01 FROM ",cl_get_target_table(g_plant_new,'apa_file'),  #FUN-A50102 
             " WHERE apa992 ='",g_aqe.aqe01,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
    PREPARE t600_sel_apa_p FROM g_sql
    IF STATUS THEN CALL cl_err('',STATUS,0) END IF
    DECLARE t600_sel_apa_c CURSOR FOR t600_sel_apa_p
    FOREACH t600_sel_apa_c INTO l_apa01
       EXECUTE t600_del_apa_p USING l_apa01
       EXECUTE t600_del_apc_p USING l_apa01
       IF SQLCA.sqlcode THEN
          LET g_success ='N'
          ROLLBACK WORK
          RETURN
       END IF
    END FOREACH   
END FUNCTION
 
FUNCTION t600_del_npp(p_plant)
   DEFINE   p_plant        LIKE type_file.chr21
   DEFINE   l_dbs          STRING
   DEFINE  l_apf01     LIKE apf_file.apf01
 
    LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET g_sql="SELECT apf01 FROM ",l_dbs CLIPPED,"apf_file",  #FUN-A50102
    LET g_sql="SELECT apf01 FROM ",cl_get_target_table(g_plant_new,'apf_file'),  #FUN-A50102 
             " WHERE apf992 ='",g_aqe.aqe01,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
    PREPARE t600_sel_apf_p4 FROM g_sql
    IF STATUS THEN CALL cl_err('',STATUS,0) END IF
    DECLARE t600_sel_apf_c4 CURSOR FOR t600_sel_apf_p4
    FOREACH t600_sel_apf_c4 INTO l_apf01
      #LET g_sql="DELETE FROM ",l_dbs CLIPPED,"npp_file",  #FUN-A50102
       LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'npp_file'),  #FUN-A50102 
                " WHERE npp01 = '",l_apf01,"'" ,
                "   AND nppsys='AP'",
                "   AND npp00 ='3'",
                "   AND npp011='1'" 
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
       PREPARE t600_del_npp_p FROM g_sql
       EXECUTE t600_del_npp_p
       IF SQLCA.sqlcode THEN
          LET g_success ='N'
          ROLLBACK WORK 
          RETURN
       END IF   
       #FUN-B40056--add--str--
       LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'tic_file'), 
                 " WHERE tic04 = '",l_apf01,"'" 
 	   CALL cl_replace_sqldb(g_sql) RETURNING g_sql     
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  
       PREPARE t600_del_tic_p FROM g_sql
       EXECUTE t600_del_tic_p
       IF SQLCA.sqlcode THEN
          LET g_success ='N'
          ROLLBACK WORK 
          RETURN
       END IF    
       #FUN-B40056--add--end--
    END FOREACH
 
END FUNCTION
 
FUNCTION t600_del_npq(p_plant)
   DEFINE   p_plant        LIKE type_file.chr21
   DEFINE   l_dbs          STRING
   DEFINE  l_apf01     LIKE apf_file.apf01
 
    LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET g_sql="SELECT apf01 FROM ",l_dbs CLIPPED,"apf_file",   #FUN-A50102
    LET g_sql="SELECT apf01 FROM ",cl_get_target_table(g_plant_new,'apf_file'),   #FUN-A50102
             " WHERE apf992 ='",g_aqe.aqe01,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
    PREPARE t600_sel_apf_p5 FROM g_sql
    IF STATUS THEN CALL cl_err('',STATUS,0) END IF
    DECLARE t600_sel_apf_c5 CURSOR FOR t600_sel_apf_p5
    FOREACH t600_sel_apf_c5 INTO l_apf01
      #LET g_sql="DELETE FROM ",l_dbs CLIPPED,"npq_file",   #FUN-A50102
       LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'npq_file'),   #FUN-A50102
                " WHERE npq01 = '",l_apf01,"'" ,
                "   AND npqsys='AP'",
                "   AND npq00 ='3'",
                "   AND npq011='1'" 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
       PREPARE t600_del_npq_p FROM g_sql
       EXECUTE t600_del_npq_p
       IF SQLCA.sqlcode THEN
          LET g_success ='N'
          ROLLBACK WORK 
          RETURN
       END IF
    END FOREACH
END FUNCTION
 
FUNCTION t600_del_aph(p_plant)
   DEFINE   p_plant        LIKE type_file.chr21
   DEFINE   l_dbs          STRING
   DEFINE  l_apf01     LIKE apf_file.apf01
 
    LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET g_sql="SELECT apf01 FROM ",l_dbs CLIPPED,"apf_file",   #FUN-A50102
    LET g_sql="SELECT apf01 FROM ",cl_get_target_table(g_plant_new,'apf_file'),   #FUN-A50102
             " WHERE apf992 ='",g_aqe.aqe01,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
    PREPARE t600_sel_apf_p6 FROM g_sql
    IF STATUS THEN CALL cl_err('',STATUS,0) END IF
    DECLARE t600_sel_apf_c6 CURSOR FOR t600_sel_apf_p6
    FOREACH t600_sel_apf_c6 INTO l_apf01
      #LET g_sql="DELETE FROM ",l_dbs CLIPPED,"aph_file",   #FUN-A50102
       LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'aph_file'),   #FUN-A50102
                " WHERE aph01 = '",l_apf01,"'" 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
       PREPARE t600_del_aph_p FROM g_sql
       EXECUTE t600_del_aph_p
       IF SQLCA.sqlcode THEN
          LET g_success ='N'
          ROLLBACK WORK 
          RETURN
       END IF
    END FOREACH
END FUNCTION
 
FUNCTION t600_del_apf(p_plant)
    DEFINE   p_plant        LIKE type_file.chr21
    DEFINE   l_dbs          STRING
 
    LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET g_sql="DELETE FROM ",l_dbs CLIPPED,"apf_file",   #FUN-A50102
    LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'apf_file'),   #FUN-A50102
             " WHERE apf992 = '",g_aqe.aqe01,"'" 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
    PREPARE t600_del_apf_p FROM g_sql
    EXECUTE t600_del_apf_p
    IF SQLCA.sqlcode THEN
       LET g_success ='N'
       ROLLBACK WORK 
       RETURN
    END IF
END FUNCTION
 
FUNCTION t600_del_apg(p_plant)
   DEFINE   p_plant        LIKE type_file.chr21
   DEFINE   l_dbs          STRING
   DEFINE  l_apf01     LIKE apf_file.apf01
 
    LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET g_sql="SELECT apf01 FROM ",l_dbs CLIPPED,"apf_file",
    LET g_sql="SELECT apf01 FROM ",cl_get_target_table(g_plant_new,'apf_file'),  #FUN-A50102
             " WHERE apf992 ='",g_aqe.aqe01,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
    PREPARE t600_sel_apf_p7 FROM g_sql
    IF STATUS THEN CALL cl_err('',STATUS,0) END IF
    DECLARE t600_sel_apf_c7 CURSOR FOR t600_sel_apf_p7
    FOREACH t600_sel_apf_c7 INTO l_apf01
       #LET g_sql="DELETE FROM ",l_dbs CLIPPED,"apg_file",
       LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'apg_file'),  #FUN-A50102
                " WHERE apg01 = '",l_apf01,"'" 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
       PREPARE t600_del_apg_p FROM g_sql
       EXECUTE t600_del_apg_p
       IF SQLCA.sqlcode THEN
          LET g_success ='N'
          ROLLBACK WORK 
          RETURN
       END IF
    END FOREACH
 
END FUNCTION
 
 
FUNCTION t600_del_nme(p_plant)
   DEFINE   l_n            LIKE type_file.num5     #SMALLINT
   DEFINE   p_plant        LIKE type_file.chr21
   DEFINE   l_aqf01        LIKE aqf_file.aqf01
   DEFINE   l_dbs          STRING
   DEFINE   l_nme24        LIKE nme_file.nme24    #No.FUN-730032
   DEFINE   l_aza73        LIKE aza_file.aza73    #No.MOD-740346
    
   LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new
  #LET g_sql="SELECT apf01 FROM ",l_dbs CLIPPED,"apf_file ",  #FUN-A50102
   LET g_sql="SELECT apf01 FROM ",cl_get_target_table(g_plant_new,'apf_file'),   #FUN-A50102 
             " WHERE apf992='",g_aqe.aqe01,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
   PREPARE t600_sel_apf_p8 FROM g_sql
   DECLARE t600_sel_apf_c8 CURSOR FOR t600_sel_apf_p8
   IF STATUS THEN
      CALL cl_err('del nme:',STATUS,1)
      LET g_success='N'
      RETURN
   END IF
 
  #LET g_sql="SELECT aza73 FROM ",l_dbs CLIPPED,"aza_file"   #FUN-A50102
   LET g_sql="SELECT aza73 FROM ",cl_get_target_table(g_plant_new,'aza_file')   #FUN-A50102
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
   PREPARE t600_aza_p FROM g_sql
   DECLARE t600_aza_c CURSOR FOR t600_aza_p
   OPEN t600_aza_c
   FETCH t600_aza_c INTO l_aza73
 
   FOREACH t600_sel_apf_c8 INTO l_aqf01
      IF l_aza73 = 'Y' THEN   #No.MOD-740346
        #LET g_sql="SELECT nme24 FROM ",l_dbs CLIPPED,"nme_file", #FUN-A50102
         LET g_sql="SELECT nme24 FROM ",cl_get_target_table(g_plant_new,'nme_file'),   #FUN-A50102
                   " WHERE nme12='",l_aqf01,"'",  
                   "   AND nme22 != 'X'"  
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
         PREPARE t600_z_nme_p FROM g_sql
         FOREACH t600_z_nme_p INTO l_nme24
            IF l_nme24 <> '9' THEN
               CALL cl_err('','anm-043',1)
               LET g_success='N'
               RETURN
            END IF
         END FOREACH
      END IF #No.MOD-740346
     #LET g_sql="DELETE FROM ",l_dbs CLIPPED,"nme_file",   #FUN-A50102
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'nme_file'),   #FUN-A50102 
                " WHERE nme12='",l_aqf01,"'"  
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      PREPARE t600_z_nme_p1 FROM g_sql
      EXECUTE t600_z_nme_p1
      IF STATUS THEN
         CALL cl_err('del nme:',STATUS,1)
         LET g_success='N'
         RETURN
      END IF 
      IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021 
    #FUN-B40056 --begin
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'tic_file'),  
                " WHERE tic04='",l_aqf01,"'"  
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE t600_z_tic_p FROM g_sql
      EXECUTE t600_z_tic_p
      IF STATUS THEN
         CALL cl_err('del tic:',STATUS,1)
         LET g_success='N'
         RETURN
      END IF
    #FUN-B40056 --end 
    END IF                 #No.TQC-B70021 
   END FOREACH
END FUNCTION
 
FUNCTION t600_input_apl()
   DEFINE l_apl RECORD LIKE apl_file.*
 
   LET l_apl.apl01 = g_aqe.aqe12
   SELECT * INTO l_apl.* FROM apl_file WHERE apl01 = l_apl.apl01
 
 
   OPEN WINDOW t600_apl AT 7,24 WITH FORM "aap/42f/aapt310_b"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
    CALL cl_ui_locale("aapt310_b")
 
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033	
 
   INPUT BY NAME l_apl.apl01,l_apl.apl02,l_apl.apl03 WITHOUT DEFAULTS
      AFTER FIELD apl01
         SELECT * INTO l_apl.* FROM apl_file WHERE apl01 = l_apl.apl01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","apl_file",l_apl.apl01,"","aap-205","","",1)  
         ELSE
            DISPLAY BY NAME l_apl.apl02,l_apl.apl03
         END IF
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
   CLOSE WINDOW t600_apl
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   LET g_aqe.aqe12 = l_apl.apl01
   LET g_aqe.aqe11 = l_apl.apl02[1,8]
   DISPLAY BY NAME g_aqe.aqe11,g_aqe.aqe12
   UPDATE apl_file SET * = l_apl.* WHERE apl01 = l_apl.apl01
   IF STATUS THEN
   CALL cl_err3("upd","apl_file",l_apl.apl01,"",STATUS,"","upd apl",1)  
   RETURN END IF
   IF SQLCA.SQLERRD[3] = 0 THEN
      INSERT INTO apl_file VALUES (l_apl.*)
      IF STATUS THEN
         CALL cl_err3("ins","apl_file",l_apl.apl01,"",STATUS,"","ins apl",1)  
         RETURN
      END IF
   END IF
END FUNCTION
 
#FUNCTION t600_x()                                    #FUN-D20035
FUNCTION t600_x(p_type)                               #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1               #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1               #FUN-D20035

   IF s_aapshut(0) THEN RETURN END IF
   IF g_aqe.aqe01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
   SELECT * INTO g_aqe.* FROM aqe_file
    WHERE aqe01=g_aqe.aqe01
 
 
    IF g_aqe.aqe15 matches '[Ss1]' THEN    
      CALL cl_err("","mfg3557",0)
      RETURN
   END IF
 
 
   IF g_aqe.aqe14 = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF

   #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_aqe.aqe14='X' THEN RETURN END IF
   ELSE
      IF g_aqe.aqe14<>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   LET g_success = 'Y'    #FUN-D20035 
   BEGIN WORK
 
   OPEN t600_cl USING g_aqe.aqe01
   IF STATUS THEN
      CALL cl_err("OPEN t600_cl:", STATUS, 1)
      CLOSE t600_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t600_cl INTO g_aqe.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_aqe.aqe01,SQLCA.sqlcode,0)          #資料被他人LOCK
       ROLLBACK WORK
       RETURN
   END IF
     #FUN-D20035---MOD--STR
     #IF cl_void(0,0,g_aqe.aqe14) THEN       
      IF p_type = 1 THEN 
         LET l_flag = 'N' 
      ELSE 
         LET l_flag = 'X' 
      END IF    
      IF cl_void(0,0,l_flag) THEN            
         IF p_type =1 THEN          
      #FUN-D20035---MOD--END
            LET g_aqe.aqe14='X'
            LET g_aqe.aqe15='9'   
         ELSE                        #取消作廢
            LET g_aqe.aqe14='N'
            LET g_aqe.aqe15='0'  
         END IF
      END IF                        #FUN-D20035
      UPDATE aqe_file SET aqe14 = g_aqe.aqe14,
                          aqe15 = g_aqe.aqe15   
       WHERE aqe01 = g_aqe.aqe01
      IF STATUS THEN
         CALL cl_err3("upd","aqe_file",g_aqe.aqe01,"",STATUS,"","",1)  
         LET g_success = 'N'
      END IF
      IF SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('','aap-161',0) LET g_success='N'
      END IF
   SELECT aqe14 INTO g_aqe.aqe14 FROM aqe_file WHERE aqe01 = g_aqe.aqe01
   SELECT aqe15 INTO g_aqe.aqe15 FROM aqe_file WHERE aqe01 = g_aqe.aqe01
   DISPLAY BY NAME g_aqe.aqe14
   DISPLAY BY NAME g_aqe.aqe15
   CLOSE t600_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_aqe.aqe01,'V')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
 
 
FUNCTION t600_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #CHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("aqe01",TRUE)
    END IF
 
    IF INFIELD(aqe03) THEN
      CALL cl_set_comp_entry("aqe11,aqe12",TRUE)
    END IF
    CALL cl_set_comp_entry("aqf03",TRUE)
 
END FUNCTION
 
FUNCTION t600_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #CHAR(1)
  DEFINE l_pmc14   LIKE pmc_file.pmc14  #FUN-A50110 add                         
  DEFINE l_flag    LIKE type_file.chr1  #FUN-A50110 add 
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("aqe01",FALSE)
    END IF
 
#FUN-A50110 ------------------add start---------------------------
    LET l_flag = 'N'                                                             
   SELECT pmc14 INTO l_pmc14                                                    
     FROM pmc_file                                                              
    WHERE pmc01 = g_aqe.aqe03                                                   
   IF l_pmc14 = '3' THEN                                                        
      LET l_flag = 'Y'                                                          
   END IF
#FUN-A50110 ----------------add end----------------------------------
    IF INFIELD(aqe03) THEN
     # IF g_aqe.aqe03 != 'MISC' AND g_aqe.aqe03 != 'EMPL' THEN                            #FUN-A50110 mark
       IF g_aqe.aqe03 != 'MISC' AND g_aqe.aqe03 != 'EMPL' AND l_flag = 'N' THEN           #FUN-A50110 add
          CALL cl_set_comp_entry("aqe11",FALSE)
       END IF
       IF g_aqe.aqe03 != 'MISC' THEN
          CALL cl_set_comp_entry("aqe12",FALSE)
       END IF
    END IF
   #TQC-A20062--mark--str--
   #IF g_apz.apz26 ='N' THEN
   #   CALL cl_set_comp_entry("aqf03",FALSE)
   #END IF
   #TQC-A20062--mark--end
    
END FUNCTION
 
FUNCTION t600_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #CHAR(1)
 
   CALL cl_set_comp_entry("aqf03",TRUE)
 
   IF INFIELD(aqg04) THEN 
      CALL cl_set_comp_entry("aqg07,aqg08,aqg09,aqg10,aqg11",TRUE) 
      CALL cl_set_comp_required("aqg08",FALSE) 
   END IF
 
END FUNCTION
 
FUNCTION t600_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1     #CHAR(1)
 
 
   IF INFIELD(aqg04) THEN                     
      IF g_aqg[l_ac].aqg04 MATCHES '[6789]' THEN
         CALL cl_set_comp_entry("aqg07,aqg08,aqg09,aqg10",FALSE) 
      END IF
      IF g_aqg[l_ac].aqg04 MATCHES '[12]' THEN    
         CALL cl_set_comp_entry("aqg09",FALSE)
      END IF
      IF g_aqg[l_ac].aqg04 ="1" THEN
         CALL cl_set_comp_entry("aqg11",FALSE)
      END IF
      IF g_aqg[l_ac].aqg04 ="2" THEN
         CALL cl_set_comp_required("aqg08",TRUE)
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t600_set_comb()
  DEFINE l_apw      RECORD LIKE apw_file.*
  DEFINE comb_value STRING
  DEFINE comb_item  LIKE type_file.chr1000     #CHAR(1000)
 
    LET comb_value = '1,2,3,4,5,A,B,C,Z'  
 
    SELECT ze03 INTO comb_item FROM ze_file
     WHERE ze01='aap-979' AND ze02=g_lang
    DECLARE apw_cs CURSOR FOR
     SELECT * FROM apw_file WHERE apw01 ='1' OR apw01 ='2'   #No.TQC-940038 
    FOREACH apw_cs INTO l_apw.*
        LET comb_value = comb_value CLIPPED,',',l_apw.apw01
        LET comb_item  = comb_item  CLIPPED,',',l_apw.apw01 CLIPPED,':',
                                                l_apw.apw02
    END FOREACH
    CALL cl_set_combo_items('aqg04',comb_value,comb_item)
END FUNCTION
 
FUNCTION t600_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #CHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL cl_set_act_visible("cancel", FALSE)
   DISPLAY ARRAY g_aqf TO s_aqf.* ATTRIBUTE(COUNT=g_rec_b)
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
 
      ON ACTION controlg      
         CALL cl_cmdask()    
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       	
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
   CALL cl_set_act_visible("cancel", FALSE)
 
END FUNCTION
 
FUNCTION t600_comp_oox1(p_apv03,p_apv05)  #No.FUN-7B0055
DEFINE l_net     LIKE apv_file.apv04
DEFINE p_apv03   LIKE apv_file.apv03
DEFINE p_apv05   LIKE apv_file.apv05      #No.FUN-7B0055
DEFINE l_apa00   LIKE apa_file.apa00
 
    LET l_net = 0
    IF g_apz.apz27 = 'Y' THEN
       SELECT SUM(oox10) INTO l_net FROM oox_file
        WHERE oox00 = 'AP' AND oox03 = p_apv03
          AND oox041 = p_apv05       #No.FUN-7B0055
       IF cl_null(l_net) THEN
          LET l_net = 0
       END IF
    END IF
    SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=p_apv03
    IF l_apa00 MATCHES '1*' THEN LET l_net = l_net * ( -1) END IF
 
    RETURN l_net
END FUNCTION
 
FUNCTION t600_bu()
   DEFINE l_aqf03        LIKE aqf_file.aqf03
   DEFINE l_aqf11        LIKE aqf_file.aqf11
                                                                                                                                       
    #在當前數據庫產生正式付款單據aapt330
    CALL t600_ins_apf(g_plant)                            #產生付款單頭apf_file數據
    IF g_success ='N' THEN
       RETURN
    END IF
    CALL t600_ins_apg(g_plant)                            #產生付款單帳款單身apg_file數據
    IF g_success ='N' THEN
       RETURN
    END IF
    CALL t600_ins_aph(g_plant,'')                            #產生付款單付款單身aph_file數據
    IF g_success ='N' THEN
       RETURN
    END IF
    LET g_apf01 =NULL
    CALL t600_ins_nme('1',g_plant)                                #產生外部銀行異動資料nme_file數據
    IF g_success ='N' THEN
       RETURN
    END IF

    #根據帳款單身更新各數據庫中該廠商的應付款已付款金額
    CALL t600_upd_apac('0')
    IF g_success ='N' THEN
       RETURN
    END IF    
    
    #在被付法人體的數據庫中產生對供應商的付款衝賬單aapt330
   
   DECLARE t600_sel_aqf_c5 CURSOR FOR                                                                                                         
     SELECT UNIQUE(aqf03),aqf11 FROM aqf_file                                                                                     
      WHERE aqf01 =g_aqe.aqe01
        AND aqf03!=g_plant
   FOREACH t600_sel_aqf_c5 INTO l_aqf03,l_aqf11
       CALL t600_ins_apf(l_aqf03)                          #產生付款單頭apf_file數據
       IF g_success ='N' THEN
          RETURN
       END IF
       CALL t600_ins_apg(l_aqf03)                          #產生付款單帳款單身apg_file數據
       IF g_success ='N' THEN
          RETURN
       END IF
       CALL t600_ins_aph(l_aqf03,l_aqf11)                          #產生付款單付款單身aph_file數據
       IF g_success ='N' THEN
          RETURN
       END IF
       CALL t600_ins_nme('0',l_aqf03)                                #產生內部銀行異動資料nme_file數據
       IF g_success ='N' THEN
          RETURN
       END IF
       #在被代付法人體的數據庫中產生對代付法人體的應付帳款aapt120
       #產生雜項應付款單頭apa_file和多帳期檔案apc_file數據
 
       CALL t600_ins_apac(l_aqf03)   #表示非本庫
       IF g_success ='N' THEN
          RETURN
       END IF
       LET g_apf01 =NULL
   END FOREACH
                                           
    
 
END FUNCTION
 
FUNCTION t600_ins_apf(p_plant)
    DEFINE li_result   LIKE type_file.num5     #SMALLINT
    DEFINE p_plant     LIKE type_file.chr21
    DEFINE l_apf       RECORD LIKE apf_file.*
    DEFINE l_dbs       STRING
    DEFINE l_aqd14     LIKE aqd_file.aqd14
    DEFINE l_legal     LIKE azw_file.azw02  #FUN-980001 add
 
    LET l_apf.apf00 ='33'
    SELECT aqd14 INTO l_aqd14 FROM aqd_file
     WHERE aqd01 =p_plant
    LET l_apf.apf01 =l_aqd14
    LET l_apf.apf02 =g_aqe.aqe02
    LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new   
    CALL s_auto_assign_no("aap",l_apf.apf01,l_apf.apf02,"33","apf_file","apf01",p_plant,"","")
         RETURNING li_result,l_apf.apf01
    IF (NOT li_result) THEN
         LET g_success = 'N'
         RETURN
    END IF
 
    LET l_apf.apf03 = g_aqe.aqe03
    LET l_apf.apf04 = g_aqe.aqe04
    LET l_apf.apf05 = g_aqe.aqe05
    LET l_apf.apf06 = g_aqe.aqe06
    LET l_apf.apf07 = s_curr(g_aqe.aqe06,g_today)                                                                             
    LET l_apf.apf08 = 0
    LET l_apf.apf09 = 0
    LET l_apf.apf10 = 0
    LET l_apf.apf08f= 0
    LET l_apf.apf09f= 0
    LET l_apf.apf10f= 0
    LET l_apf.apf11 = g_aqe.aqe10
    LET l_apf.apf12 = g_aqe.aqe11
    LET l_apf.apf13 = g_aqe.aqe12
    LET l_apf.apf14 = g_aqe.aqe13
    LET l_apf.apf41 = 'Y'
    LET l_apf.apf42 = '1'
    LET l_apf.apf992= g_aqe.aqe01
    LET l_apf.apfmksg = g_aqe.aqemksg
    LET l_apf.apfuser = g_aqe.aqeuser
    LET l_apf.apfgrup = g_aqe.aqegrup
    LET l_apf.apfinpd = g_aqe.aqeinpd
    LET l_apf.apfacti = g_aqe.aqeacti
    LET l_apf.apfsign = g_aqe.aqesign
    LET l_apf.apfdays = g_aqe.aqedays
    LET l_apf.apfprit = g_aqe.aqeprit
    LET l_apf.apfsmax = g_aqe.aqesmax
    LET l_apf.apfsseq = g_aqe.aqesseq
    LET l_apf.apfprno = g_aqe.aqeprno
    LET l_apf.apfmodu = g_aqe.aqemodu
    LET l_apf.apfdate = g_today
    CALL s_getlegal(g_plant_new) RETURNING l_legal  #FUN-980001 add
    LET l_apf.apflegal = l_legal #FUN-980001 add
    LET l_apf.apforiu = g_user     #TQC-A10060  add
    LET l_apf.apforig = g_grup    #TQC-A10060  add 
 
   #LET g_sql="INSERT INTO ",l_dbs CLIPPED,"apf_file",   #FUN-A50102
    LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'apf_file'),  #FUN-A50102
              "(apf00,apf01,apf02,apf03,apf04,apf05,apf06,apf07,",
              "apf08,apf08f,apf09,apf09f,apf10,apf10f,apf11,apf12,",
              "apf13,apf14,apf15,apf41,apf42,apf43,apf44,apf992,apfinpd,apfmksg,",
              "apfsign,apfdays,apfprit,apfsmax,apfsseq,apfprno,",
              "apfacti,apfuser,apfgrup,apfmodu,apfdate,apflegal,apforiu,apforig)", #TQC-A10060 add apforiu,apforig  #FUN-960141 add
              " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  #FUN-960141 del 1 ?   #TQC-A10060 add ?,?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
    PREPARE t600_ins_apf_p FROM g_sql
    IF STATUS THEN CALL cl_err('',STATUS,0) END IF

    EXECUTE t600_ins_apf_p USING l_apf.apf00,l_apf.apf01,l_apf.apf02,l_apf.apf03,l_apf.apf04,l_apf.apf05,l_apf.apf06,l_apf.apf07,
                                 l_apf.apf08,l_apf.apf08f,l_apf.apf09,l_apf.apf09f,l_apf.apf10,l_apf.apf10f,l_apf.apf11,l_apf.apf12,
                                 l_apf.apf13,l_apf.apf14,l_apf.apf15,l_apf.apf41,l_apf.apf42,l_apf.apf43,l_apf.apf44,l_apf.apf992,l_apf.apfinpd,l_apf.apfmksg,
                                 l_apf.apfsign,l_apf.apfdays,l_apf.apfprit,l_apf.apfsmax,l_apf.apfsseq,l_apf.apfprno,
                                 #l_apf.apfacti,l_apf.apfuser,l_apf.apfgrup,l_apf.apfmodu,l_apf.apfdate #FUN-980001 mark
                                 #l_apf.apfacti,l_apf.apfuser,l_apf.apfgrup,l_apf.apfmodu,l_apf.apfdate,l_apf.apfplant,l_apf.apflegal #FUN-980001 add plant,legal  #FUN-960141 mark         
                                 l_apf.apfacti,l_apf.apfuser,l_apf.apfgrup,l_apf.apfmodu,l_apf.apfdate,l_apf.apflegal,l_apf.apforiu,l_apf.apforig  #FUN-960141 add   #TQC-A10060 add oriu,orig
    IF STATUS THEN
       CALL cl_err('ins apf:',STATUS,1)
       LET g_success='N'
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err('ins apf:',SQLCA.SQLCODE,1)
       LET g_success='N'
       RETURN
    END IF
    LET g_apf01 =l_apf.apf01
END FUNCTION
 
FUNCTION t600_ins_apg(p_plant)
    DEFINE p_plant          LIKE apg_file.apg03
    DEFINE l_dbs            LIKE type_file.chr21
    DEFINE l_amt            LIKE aqf_file.aqf05
    DEFINE l_amtf           LIKE aqf_file.aqf05f
    DEFINE l_sumf           LIKE aqf_file.aqf05f
    DEFINE l_sum            LIKE aqf_file.aqf05
    DEFINE l_apf07          LIKE apf_file.apf07
    DEFINE l_aqf            RECORD LIKE aqf_file.*
    DEFINE l_apg            RECORD LIKE apg_file.*
    DEFINE l_legal          LIKE azw_file.azw02  #FUN-980001 add
 
    LET g_sql ="SELECT * FROM aqf_file",
               " WHERE aqf00 ='",g_aqe.aqe00,"'",
               "   AND aqf01 ='",g_aqe.aqe01,"'"
 
    PREPARE t600_sel_aqf_p2 FROM g_sql
    IF STATUS THEN CALL cl_err('',STATUS,0) END IF
    DECLARE t600_sel_aqf_c2 CURSOR FOR t600_sel_aqf_p2
    LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new
    LET l_amt =0
    LET l_amtf=0
    LET l_sum =0
    LET l_sumf=0
    CALL s_getlegal(g_plant_new) RETURNING l_legal  #FUN-980001 add
    FOREACH t600_sel_aqf_c2 INTO l_aqf.*
       IF l_aqf.aqf03 <> p_plant AND p_plant <> g_plant THEN
          CONTINUE FOREACH
       END IF
       LET  l_apg.apg01 =  g_apf01
       LET  l_apg.apg02 =  l_aqf.aqf02
       LET  l_apg.apg03 =  l_aqf.aqf03
       LET  l_apg.apg04 =  l_aqf.aqf04
       LET  l_apg.apg05 =  l_aqf.aqf05
       LET  l_apg.apg05f=  l_aqf.aqf05f
       IF cl_null(l_apg.apg05) THEN
          LET l_apg.apg05 =0
       END IF
       IF cl_null(l_apg.apg05f) THEN
          LET l_apg.apg05f =0
       END IF
       LET l_sum =l_sum+l_apg.apg05
       LET l_sumf=l_sumf+l_apg.apg05f
       LET  l_apg.apg06 =  l_aqf.aqf06
       IF l_aqf.aqf03 = g_plant THEN
          LET l_amtf = l_amtf + l_aqf.aqf05f
          LET l_amt = l_amt + l_aqf.aqf05
       END IF
       LET l_apg.apglegal = l_legal #FUN-980001 add
      #LET g_sql="INSERT INTO ",l_dbs CLIPPED,"apg_file",  #FUN-A50102
       LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'apg_file'),   #FUN-A50102
                 "(apg01,apg02,apg03,apg04,apg05,apg05f,apg06,apglegal)",  #FUN-960141 add
                 " VALUES(?,?,?,?,?,?,?,?)"  #FUN-960141 add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
       PREPARE t600_ins_apg_p FROM g_sql
       IF STATUS THEN CALL cl_err('',STATUS,0) END IF
      
       EXECUTE t600_ins_apg_p USING l_apg.apg01,l_apg.apg02,l_apg.apg03,l_apg.apg04,
                                    #l_apg.apg05,l_apg.apg05f,l_apg.apg06 #FUN-980001 mark
                                    #l_apg.apg05,l_apg.apg05f,l_apg.apg06,l_apg.apgplant,l_apg.apglegal #FUN-980001 add  #FUN-960141 mark
                                    l_apg.apg05,l_apg.apg05f,l_apg.apg06,l_apg.apglegal  #FUN-960141 add
       IF STATUS THEN
          CALL cl_err('ins apg:',STATUS,1)
          LET g_success='N'
       END IF
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err('ins apg:',SQLCA.SQLCODE,1)
          LET g_success='N'
          RETURN
       END IF
    END FOREACH
    IF p_plant !=g_plant THEN

      #LET g_sql="UPDATE ",l_dbs CLIPPED,"apf_file",   #FUN-A50102
       LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'apf_file'),   #FUN-A50102 
                 " SET apf08 ='",l_sum,"',apf08f ='",l_sumf,"'",          #No.TQC-6C0067
                 " WHERE apf01 ='",l_apg.apg01,"'"
    ELSE
      #LET g_sql="UPDATE ",l_dbs CLIPPED,"apf_file",   #FUN-A50102
       LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'apf_file'),   #FUN-A50102
                 " SET apf08 ='",l_sum,"',apf08f ='",l_sumf,"'",
                 " WHERE apf01 ='",l_apg.apg01,"'"
 
    END IF                                                                                                                       
 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
    PREPARE t600_upd_apf_p FROM g_sql
    IF STATUS THEN CALL cl_err('',STATUS,0) END IF
    EXECUTE t600_upd_apf_p
    IF STATUS THEN
       CALL cl_err('upd apf:',STATUS,1)
       LET g_success='N'
    END IF
 
 
 
 
 
END FUNCTION
 
FUNCTION t600_ins_aph(p_plant,p_aqf11)
    DEFINE p_plant    LIKE apg_file.apg03
    DEFINE p_aqf11    LIKE aqf_file.aqf11
    DEFINE l_dbs      LIKE type_file.chr21       #CHAR(21)
    DEFINE l_aqg      RECORD LIKE aqg_file.*
    DEFINE l_aph      RECORD LIKE aph_file.*
    DEFINE l_sumf     LIKE apf_file.apf10f
    DEFINE l_sum      LIKE apf_file.apf10
    DEFINE l_aqf11    LIKE aqf_file.aqf11
    DEFINE l_apt04    LIKE apt_file.apt04
    DEFINE l_apt041   LIKE apt_file.apt041
    DEFINE l_aza63    LIKE aza_file.aza63       #No.TQC-6C0067   
    DEFINE l_legal    LIKE azw_file.azw02   #FUN-980001 add
 
    LET l_aqf11 = p_aqf11
 
    LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new
    LET g_sql = " SELECT aza63 ",  
               #"   FROM ",l_dbs CLIPPED,"aza_file ",   #FUN-A50102
                "   FROM ",cl_get_target_table(g_plant_new,'aza_file'),   #FUN-A50102
                "  WHERE aza01 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
    PREPARE t600_aza631_p FROM g_sql
    DECLARE t600_aza631 CURSOR FOR t600_aza631_p
    OPEN t600_aza631  
    FETCH t600_aza631 INTO l_aza63
    LET g_sql ="SELECT * FROM aqg_file",
               " WHERE aqg00 ='",g_aqe.aqe00,"'",
               "   AND aqg01 ='",g_aqe.aqe01,"'"
    PREPARE t600_sel_aqg_p FROM g_sql
    IF STATUS THEN CALL cl_err('',STATUS,0) END IF
    DECLARE t600_sel_aqg_c CURSOR FOR t600_sel_aqg_p
    IF p_plant =g_plant THEN
       LET l_sum  =0
       LET l_sumf =0
       FOREACH t600_sel_aqg_c INTO l_aqg.*
                LET  l_aph.aph01 =  g_apf01
                LET  l_aph.aph02 =  l_aqg.aqg02
                LET  l_aph.aph03 =  l_aqg.aqg04
                LET  l_aph.aph04 =  l_aqg.aqg05
                LET  l_aph.aph041=  l_aqg.aqg051
                LET  l_aph.aph05f=  l_aqg.aqg06f
                LET  l_aph.aph05 =  l_aqg.aqg06
                IF cl_null(l_aph.aph05) THEN
                   LET l_aph.aph05 =0
                END IF
                IF cl_null(l_aph.aph05f) THEN
                   LET l_aph.aph05f =0
                END IF
                LET l_sum =l_sum + l_aph.aph05
                LET l_sumf=l_sumf+ l_aph.aph05f
                LET  l_aph.aph07 =  l_aqg.aqg07
                LET  l_aph.aph08 =  l_aqg.aqg08
                LET  l_aph.aph09 = 'N'
                LET  l_aph.aph13 =  l_aqg.aqg09
                LET  l_aph.aph14 =  l_aqg.aqg10
                LET  l_aph.aph16 =  l_aqg.aqg11
                LET  l_aph.aphlegal=g_legal #FUN-980001 add
                LET g_sql="INSERT INTO aph_file",
                          "(aph01,aph02,aph03,aph04,aph041,aph05,aph05f,aph06,aph07,aph08,aph09,",
                          "aph13,aph14,aph15,aph16,aph17,aphlegal)",  #FUN-960141 add
                          " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"   #FUN-960141 add 
                PREPARE t600_ins_aph_p FROM g_sql
                IF STATUS THEN CALL cl_err('',STATUS,0) END IF

                EXECUTE t600_ins_aph_p USING l_aph.aph01,l_aph.aph02,l_aph.aph03,l_aph.aph04,l_aph.aph041,l_aph.aph05,l_aph.aph05f,l_aph.aph06,
                                             #l_aph.aph07,l_aph.aph08,l_aph.aph09,l_aph.aph13,l_aph.aph14,l_aph.aph15,l_aph.aph16,l_aph.aph17 #FUN-980001 mark
                                             #l_aph.aph07,l_aph.aph08,l_aph.aph09,l_aph.aph13,l_aph.aph14,l_aph.aph15,l_aph.aph16,l_aph.aph17,l_aph.aphplant,l_aph.aphlegal #FUN-980001 add  #FUN-960141 mark
                                             l_aph.aph07,l_aph.aph08,l_aph.aph09,l_aph.aph13,l_aph.aph14,l_aph.aph15,l_aph.aph16,l_aph.aph17,l_aph.aphlegal   #FUN-960141 add
                IF STATUS THEN
                   CALL cl_err('ins aph:',STATUS,1)
                   LET g_success='N'
                END IF
                IF SQLCA.SQLERRD[3]=0 THEN
                   CALL cl_err('ins aph:',SQLCA.SQLCODE,1)
                   LET g_success='N'
                   RETURN
                END IF
       END FOREACH
      #LET g_sql="UPDATE ",l_dbs CLIPPED,"apf_file",   #FUN-A50102
       LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'apf_file'),   #FUN-A50102
                 " SET apf10 ='",l_sum,"',apf10f ='",l_sumf,"'",
                 " WHERE apf01 ='",l_aph.aph01,"'"
 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
       PREPARE t600_upd_apf_p1 FROM g_sql
       IF STATUS THEN CALL cl_err('',STATUS,0) END IF
       EXECUTE t600_upd_apf_p1
       IF STATUS THEN
          CALL cl_err('upd apf:',STATUS,1)
          LET g_success='N'
       END IF
    ELSE
         LET l_aph.aph01 = g_apf01
         LET l_aph.aph02 = '1'
         LET l_aph.aph03 = 'X'
        #LET g_sql=" SELECT apt04,apt041 FROM  ",l_dbs,"apt_file",   #FUN-A50102
         LET g_sql=" SELECT apt04,apt041 FROM  ",cl_get_target_table(g_plant_new,'apt_file'),   #FUN-A50102 
                   "  WHERE apt01 ='",l_aqf11,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
         PREPARE t600_sel_apt_p2 FROM g_sql
         IF STATUS THEN CALL cl_err('',STATUS,0) END IF
         EXECUTE t600_sel_apt_p2 INTO l_apt04,l_apt041
         IF STATUS THEN
            CALL cl_err('sel apt:',STATUS,1)
         END IF
         LET l_aph.aph04 =  l_apt04
         LET l_aph.aph041=  l_apt041
        #LET g_sql ="SELECT SUM(apg05f),SUM(apg05) FROM ",l_dbs CLIPPED,"apg_file ",  #FUN-A50102
         LET g_sql ="SELECT SUM(apg05f),SUM(apg05) ",   #FUN-A50102
                    "  FROM ",cl_get_target_table(g_plant_new,'apg_file'),   #FUN-A50102
                    " WHERE apg01 ='",g_apf01,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
         PREPARE t600_sel_apg_p FROM g_sql
         IF STATUS THEN CALL cl_err('',STATUS,0) END IF
         EXECUTE t600_sel_apg_p  INTO l_aph.aph05f,l_aph.aph05
         IF STATUS THEN
            CALL cl_err('ins aph:',STATUS,1)
            LET g_success='N'
         END IF
         IF cl_null(l_aph.aph05) THEN
            LET l_aph.aph05 =0
         END IF
         IF cl_null(l_aph.aph05f) THEN
            LET l_aph.aph05f =0
         END IF
         LET l_aph.aph07 = NULL
         LET l_aph.aph09 = 'N'
         LET l_aph.aph13 = g_aqe.aqe06
         LET l_aph.aph14 = l_aph.aph05/l_aph.aph05f
         CALL s_getlegal(g_plant_new) RETURNING l_legal  #FUN-980001 add
         LET l_aph.aphlegal=l_legal #FUN-980001 add
        #LET g_sql="INSERT INTO ",l_dbs CLIPPED,"aph_file",   #FUN-A50102
         LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'aph_file'),   #FUN-A50102
                   "(aph01,aph02,aph03,aph04,aph041,aph05,aph05f,aph06,aph07,aph08,aph09,",
                   "aph13,aph14,aph15,aph16,aph17,aphlegal)",  #FUN-960141 add
                   " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  #FUN-960141 add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
         PREPARE t600_ins_aph_p1 FROM g_sql
         IF STATUS THEN CALL cl_err('',STATUS,0) END IF

         EXECUTE t600_ins_aph_p1 USING l_aph.aph01,l_aph.aph02,l_aph.aph03,l_aph.aph04,l_aph.aph041,l_aph.aph05,l_aph.aph05f,l_aph.aph06,
                                       #l_aph.aph07,l_aph.aph08,l_aph.aph09,l_aph.aph13,l_aph.aph14,l_aph.aph15,l_aph.aph16,l_aph.aph17 #FUN-980001 mark
                                       #l_aph.aph07,l_aph.aph08,l_aph.aph09,l_aph.aph13,l_aph.aph14,l_aph.aph15,l_aph.aph16,l_aph.aph17,l_aph.aphplant,l_aph.aphlegal #FUN-980001 add  #FUN-960141 mark
                                       l_aph.aph07,l_aph.aph08,l_aph.aph09,l_aph.aph13,l_aph.aph14,l_aph.aph15,l_aph.aph16,l_aph.aph17,l_aph.aphlegal  #FUN-960141 add  
         IF STATUS THEN
            CALL cl_err('ins aph:',STATUS,1)
            LET g_success='N'
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err('ins aph:',SQLCA.SQLCODE,1)
            LET g_success='N'
            RETURN
         END IF
        #LET g_sql="UPDATE ",l_dbs CLIPPED,"apf_file",   #FUN-A50102
         LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'apf_file'),  #FUN-A50102
                   " SET apf10 ='",l_aph.aph05,"',apf10f ='",l_aph.aph05f,"'",
                   " WHERE apf01 ='",l_aph.aph01,"'"
 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
         PREPARE t600_upd_apf_p2 FROM g_sql
         IF STATUS THEN CALL cl_err('',STATUS,0) END IF
         EXECUTE t600_upd_apf_p2
         IF STATUS THEN
            CALL cl_err('upd apf:',STATUS,1)
            LET g_success='N'
         END IF
    END IF
    CALL t600_ins_npp(p_plant,'0',g_apf01)                #產生分錄底稿單頭資料npp_file數據
    IF l_aza63 ='Y' THEN                    #No.TQC-6C0067
       CALL t600_ins_npp(p_plant,'1',g_apf01)
    END IF
    CALL t600_ins_npq(p_plant,'0',g_apf01)                #產生分錄底稿單身資料npq_file數據
    IF l_aza63 ='Y' THEN                #No.TQC-6C0067
       CALL t600_ins_npq(p_plant,'1',g_apf01)
    END IF
END FUNCTION
 
FUNCTION t600_ins_npp(p_plant,p_npptype,p_apno)
   DEFINE p_plant          LIKE type_file.chr21
   DEFINE p_npptype        LIKE npp_file.npptype
   DEFINE p_apno           LIKE apf_file.apf01
   DEFINE l_dbs            STRING
   DEFINE l_plant          LIKE type_file.chr10       #FUN-980020
   DEFINE l_npp            RECORD LIKE npp_file.*
   DEFINE l_apf            RECORD LIKE apf_file.*
   DEFINE l_legal          LIKE azw_file.azw02   #FUN-980001 add
 
    IF cl_null(g_apf01) THEN
      LET g_success ='N'
      RETURN
    END IF
    LET l_plant = p_plant
    LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new
    #LET g_sql="SELECT * FROM ",l_dbs CLIPPED,"apf_file",   #FUN-A50102
    LET g_sql="SELECT * FROM ",cl_get_target_table(g_plant_new,'apf_file'),   #FUN-A50102
             " WHERE apf01 ='",p_apno,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
    PREPARE t600_sel_apf_p2 FROM g_sql
    IF STATUS THEN CALL cl_err('',STATUS,0) END IF
    EXECUTE t600_sel_apf_p2 INTO l_apf.*
 
    LET l_npp.nppsys = 'AP'
    LET l_npp.npp00  = 3
    LET l_npp.npp01  = g_apf01
    LET l_npp.npp011 = 1
    LET l_npp.npp02  = l_apf.apf02
    LET l_npp.npp03  = NULL
    LET l_npp.npp05  = NULL
    LET l_npp.nppglno= NULL
    LET l_npp.npptype= p_npptype
    CALL s_getlegal(g_plant_new) RETURNING l_legal #FUN-980001 add
    LET l_npp.npplegal= l_legal #FUN-980001 add
 
   #LET g_sql="INSERT INTO ",l_dbs CLIPPED,"npp_file",   #FUN-A50102
    LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'npp_file'),   #FUN-A50102
              "(nppsys,npp00,npp01,npp011,npp02,npp03",
              ",npp04,npp05,npp06,npp07,nppglno,npptype,npplegal)", #FUN-980001 add
              " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)" #FUN-980001 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
    PREPARE t600_ins_npp_p FROM g_sql
    IF STATUS THEN CALL cl_err('',STATUS,0) END IF

    EXECUTE t600_ins_npp_p USING l_npp.nppsys,l_npp.npp00,l_npp.npp01,l_npp.npp011,l_npp.npp02,l_npp.npp03,
                                 #l_npp.npp04,l_npp.npp05,l_npp.npp06,l_npp.npp07,l_npp.nppglno,l_npp.npptype #FUN-980001 mark
                                 l_npp.npp04,l_npp.npp05,l_npp.npp06,l_npp.npp07,l_npp.nppglno,l_npp.npptype,l_npp.npplegal #FUN-980001 add npplegal
    IF STATUS THEN
       CALL cl_err('ins npp:',STATUS,1)
       LET g_success='N'
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err('ins npp:',SQLCA.SQLCODE,1)
       LET g_success='N'
       RETURN
    END IF
    CALL s_get_bookno1(YEAR(l_npp.npp02),l_plant)  #FUN-980020
        RETURNING g_flag,g_bookno1,g_bookno2                           
    IF g_flag =  '1' THEN  #抓不到帳別                                  
       CALL cl_err(l_npp.npp02,'aoo-081',1)                             
    END IF
 
END FUNCTION
 
 
FUNCTION t600_ins_npq(p_plant,p_npqtype,p_apno)
   DEFINE p_plant          LIKE type_file.chr21
   DEFINE p_npqtype        LIKE npq_file.npqtype
   DEFINE p_apno           LIKE apf_file.apf01
   DEFINE l_dbs            STRING
   DEFINE l_npq            RECORD LIKE npq_file.*
   DEFINE l_apf            RECORD LIKE apf_file.*
   DEFINE l_apg03          LIKE apg_file.apg03
   DEFINE l_apg04          LIKE apg_file.apg04
   DEFINE l_apg05          LIKE apg_file.apg05
   DEFINE l_apg05f         LIKE apg_file.apg05f
   DEFINE l_apg06          LIKE apg_file.apg06
   DEFINE l_dept           LIKE apa_file.apa22
   DEFINE l_actno,l_actno2 LIKE apa_file.apa54 
   DEFINE l_curr           LIKE npq_file.npq24
   DEFINE l_rate           LIKE npq_file.npq25
   DEFINE l_amt            LIKE apg_file.apg05
   DEFINE l_amtf           LIKE apg_file.apg05f
   DEFINE l_aag05          LIKE aag_file.aag05
   DEFINE l_aag181         LIKE aag_file.aag181
   DEFINE l_pmc03          LIKE pmc_file.pmc03
   DEFINE l_pmc903         LIKE pmc_file.pmc903
   DEFINE l_aph02          LIKE aph_file.aph02
   DEFINE l_aph03          LIKE aph_file.aph03
   DEFINE l_aph08          LIKE aph_file.aph08
   DEFINE l_aqf11          LIKE aqf_file.aqf11
   DEFINE l_apt03          LIKE apt_file.apt03
   DEFINE l_opendate,l_duedate	LIKE type_file.dat 
   DEFINE l_aza63          LIKE aza_file.aza63       #No.TQC-6C0067
   DEFINE l_aag371         LIKE aag_file.aag371      #No.TQC-940085
   DEFINE l_legal          LIKE azw_file.azw02       #FUN-980001 add
 
 
   IF cl_null(g_apf01) THEN                                                                                                    
     LET g_success ='N'                                                                                                            
     RETURN                                                                                                                        
   END IF
   LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new
    LET g_sql = " SELECT aza63 ",  
               #"   FROM ",l_dbs CLIPPED,"aza_file ",   #FUN-A50102
                "   FROM ",cl_get_target_table(g_plant_new,'aza_file'),   #FUN-A50102
                "  WHERE aza01 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102  
    PREPARE t600_aza632_p FROM g_sql
    DECLARE t600_aza632 CURSOR FOR t600_aza632_p
    OPEN t600_aza632  
    FETCH t600_aza632 INTO l_aza63
  #LET g_sql="SELECT * FROM ",l_dbs CLIPPED,"apf_file",   #FUN-A50102
   LET g_sql="SELECT * FROM ",cl_get_target_table(g_plant_new,'apf_file'),  #FUN-A50102
            " WHERE apf01 ='",p_apno,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE t600_sel_apf_p3 FROM g_sql
   IF STATUS THEN CALL cl_err('',STATUS,0) END IF
   EXECUTE t600_sel_apf_p3 INTO l_apf.*
    LET l_npq.npqsys = 'AP'
    LET l_npq.npq00  = 3
    LET l_npq.npq01  = g_apf01
    LET l_npq.npq011 = 1
    LET l_npq.npq02  = 1
    LET l_npq.npq21  = l_apf.apf03               #No.TQC-6C0067
    LET l_npq.npq22  = l_apf.apf12
    LET l_npq.npqtype= p_npqtype
 
  #FUN-A50102--mod--str--
  #LET g_sql="SELECT apg03,apg04,apg05,apg05f,apg06 FROM ",l_dbs CLIPPED,"apg_file",
   LET g_sql="SELECT apg03,apg04,apg05,apg05f,apg06 ",
             "  FROM ",cl_get_target_table(g_plant_new,'apg_file'),
  #FUN-A50102--mod--end
            " WHERE apg01 ='",p_apno,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
   PREPARE t600_sel_apg_p1 FROM g_sql
   IF STATUS THEN CALL cl_err('',STATUS,0) END IF
   DECLARE t600_sel_apg_c1 CURSOR FOR t600_sel_apg_p1
   FOREACH t600_sel_apg_c1 INTO l_apg03,l_apg04,l_apg05,l_apg05f,l_apg06
      IF SQLCA.sqlcode THEN
         CALL cl_err('t600_g_gl(ckp#1)',SQLCA.sqlcode,1)
      END IF
  	  LET g_plant_new = l_apg03
  	  CALL s_getdbs()
 
  	  IF l_apg03 <> g_plant AND p_plant = g_plant THEN         #No.TQC-6C0067
  	     SELECT azp01,azp02 INTO l_npq.npq21,l_npq.npq22 FROM azp_file
  	      WHERE azp01 =l_apg03
  	  END IF
 
      IF p_npqtype = '0' THEN
         LET g_sql= "SELECT apa22,apa13,apa14 ",
                   #" FROM  ",g_dbs_new CLIPPED," apa_file ",   #FUN-A50102
                    " FROM  ",cl_get_target_table(g_plant_new,'apa_file'),   #FUN-A50102 
                    " WHERE apa01 ='",l_apg04,"'"
      ELSE
         LET g_sql= "SELECT apa22,apa13,apa14 ",
                   #" FROM  ",g_dbs_new CLIPPED," apa_file ",   #FUN-A50102
                    " FROM  ",cl_get_target_table(g_plant_new,'apa_file'),   #FUN-A50102
                    " WHERE apa01 ='",l_apg04,"'"
      END IF
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
      PREPARE t600_gl_d FROM g_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('t600_gl_d',SQLCA.sqlcode,0)
      END IF
      DECLARE t600_cs_gl CURSOR FOR t600_gl_d
      OPEN t600_cs_gl
      FETCH t600_cs_gl INTO l_dept,l_curr,l_rate
      CLOSE t600_cs_gl
      IF l_apg03 = p_plant THEN
         LET g_sql=" SELECT apa54,apa541 ",
                  #"  FROM ",g_dbs_new CLIPPED,"apa_file ",  #FUN-A50102
                   "  FROM ",cl_get_target_table(g_plant_new,'apa_file'),  #FUN-A50102
                   "  WHERE apa01 = '",l_apg04,"'"
      ELSE
         LET g_sql=" SELECT apt03,apt031 ",
                  #FUN-A50102--mod--str--
                  #" FROM ",l_dbs CLIPPED,"apt_file, aqf_file,",l_dbs CLIPPED,"apg_file ",
                   " FROM ",cl_get_target_table(g_plant_new,'apt_file'),", aqf_file,",
                   "      ",cl_get_target_table(g_plant_new,'apg_file'),
                  #FUN-A50102--mod--end
                   " WHERE apt01=aqf11 AND aqf04=apg04 AND aqf06=apg06 ",
                   " AND apg04='",l_apg04 CLIPPED,"'",
                   " AND apg06=",l_apg06
      END IF
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
      PREPARE t600_apt_p FROM g_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('t600_apt_p',SQLCA.sqlcode,0)
      END IF
      DECLARE t600_apt_cs CURSOR FOR t600_apt_p
      OPEN t600_apt_cs
      FETCH t600_apt_cs INTO l_actno,l_actno2
      CLOSE t600_apt_cs
      IF p_npqtype='0' THEN
         LET l_npq.npq03 = l_actno
         LET g_bookno = g_bookno1    #No.FUN-730064
      ELSE
         LET l_npq.npq03 = l_actno2
         LET g_bookno = g_bookno2     #No.FUN-730064
      END IF
     #FUN-A50102--mod-str--
     #LET g_sql ="SELECT aag05,aag181,aag371 FROM ",g_dbs_new CLIPPED,"aag_file",  #No.TQC-940085 add aag371
      LET g_sql ="SELECT aag05,aag181,aag371 ",
                 "  FROM ",cl_get_target_table(g_plant_new,'aag_file'),
     #FUN-A50102--mod--end
                 " WHERE aag01 ='",l_npq.npq03,"'",
                 " AND   aag00 ='",g_bookno,"'"        #No.FUN-730064
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
      PREPARE t600_sel_aag_p FROM g_sql
      IF STATUS THEN CALL cl_err('',STATUS,0) END IF
      LET l_aag371 = ''  #No.TQC-940085
      EXECUTE t600_sel_aag_p INTO l_aag05,l_aag181,l_aag371   #No.TQC-940085 add l_aag371
      IF l_aag05='Y' THEN
         LET l_npq.npq05 = l_dept
      ELSE
         LET l_npq.npq05 = ' '
      END IF
     #IF l_aag181 MATCHES '[23]' THEN      #FUN-950053 mark 
         #-->for 合併報表-關係人
       #FUN-A50102--mod--str--
       # LET g_sql ="SELECT pmc03,pmc903 FROM ",l_dbs CLIPPED,"pmc_file",
         LET g_sql ="SELECT pmc03,pmc903 ",
                    "  FROM ",cl_get_target_table(g_plant_new,'pmc_file'),
       #FUN-A50102--mod--end
                    " WHERE pmc01 ='",l_npq.npq21,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
         PREPARE t600_sel_pmc_p FROM g_sql
         IF STATUS THEN CALL cl_err('',STATUS,0) END IF
         EXECUTE t600_sel_pmc_p INTO l_pmc03,l_pmc903
      IF l_aag181 MATCHES '[23]' THEN    #FUN-950053 add                 
         IF l_pmc903 = 'Y' THEN LET l_npq.npq14 = l_pmc03 CLIPPED END IF
      END IF
      LET l_npq.npq06 = '1'
      LET l_npq.npq07f= l_apg05f
      LET l_npq.npq07 = l_apg05
      IF g_plant =p_plant THEN
         IF l_apg03 = g_plant THEN
            LET l_npq.npq23 = l_apg04
         ELSE
            LET l_npq.npq23 = g_aqe.aqe01     
         END IF
      ELSE
      	 LET l_npq.npq23 = l_apg04
      END IF
      LET l_npq.npq24 = l_curr
      LET l_npq.npq25 = l_rate
      LET l_npq.npq04 = ''
      LET l_npq.npq11 = ''
      LET l_npq.npq12 = ''
      LET l_npq.npq13 = ''
      LET l_npq.npq14 = ''
      LET l_npq.npq31 = ''
      LET l_npq.npq32 = ''
      LET l_npq.npq33 = ''
      LET l_npq.npq34 = ''
      LET l_npq.npq35 = ''
      LET l_npq.npq36 = ''
     #IF l_aag371 MATCHES '[23]' THEN    #FUN-950053 mark
      IF (l_aag371 MATCHES '[23]') OR (l_aag371 MATCHES '[4]' AND l_pmc903 = 'Y' ) THEN   #FUN-950053 add  
         IF g_plant <> p_plant THEN
            LET l_npq.npq37 = g_plant
         ELSE
            LET l_npq.npq37 = l_apg03
         END IF  
      ELSE
         LET l_npq.npq37 = ''
      END IF
      
      CALL s_getlegal(g_plant_new) RETURNING l_legal #FUN-980001 add
      LET l_npq.npqlegal=l_legal #FUN-980001 add
     #LET g_sql="INSERT INTO ",l_dbs CLIPPED,"npq_file",    #FUN-A50102
      LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'npq_file'),  #FUN-A50102
                "(npqsys,npq00,npq01,npq011,npq02,npq03,npq04,npq05,npq06",
                ",npq07f,npq07,npq08,npq11,npq12,npq13,npq14,npq15,npq21",
                ",npq22,npq23,npq24,npq25,npq26,npq27,npq28,npq29,npq30",
                ",npq31,npq32,npq33,npq34,npq35,npq36,npq37,npq930,npqtype,npqlegal)", #FUN-980001 add
                " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" #FUN-980001 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      PREPARE t600_ins_npq_p FROM g_sql
      IF STATUS THEN CALL cl_err('',STATUS,0) END IF

      EXECUTE t600_ins_npq_p USING l_npq.npqsys,l_npq.npq00,l_npq.npq01,l_npq.npq011,l_npq.npq02,l_npq.npq03,l_npq.npq04,l_npq.npq05,l_npq.npq06,
                                   l_npq.npq07f,l_npq.npq07,l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,l_npq.npq14,l_npq.npq15,l_npq.npq21,
                                   l_npq.npq22,l_npq.npq23,l_npq.npq24,l_npq.npq25,l_npq.npq26,l_npq.npq27,l_npq.npq28,l_npq.npq29,l_npq.npq30,
                                   l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34,l_npq.npq35,l_npq.npq36,l_npq.npq37,l_npq.npq930,l_npq.npqtype,l_npq.npqlegal #FUN-980001 add
      IF STATUS THEN
         CALL cl_err('ins npq:',STATUS,1)
         LET g_success='N'
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('ins npq:',SQLCA.SQLCODE,1)
         LET g_success='N'
         RETURN
      END IF
      LET l_npq.npq02 = l_npq.npq02 + 1
   END FOREACH
 
   IF p_npqtype = '0' THEN
      LET g_sql = " SELECT aph02,aph03,aph08,aph04,aph05,",
                  "         aph05f,aph06,aph07,aph13,aph14 ",
                 #"   FROM ",l_dbs CLIPPED,"aph_file ",  # l_dbs CLIPPED,"apa_file ",   #FUN-A50102
                  "   FROM ",cl_get_target_table(g_plant_new,'aph_file'),   #FUN-A50102
                  "  WHERE aph01 = '",g_apf01,"'",
                  "  ORDER BY aph02 "
   ELSE
      LET g_sql = " SELECT aph02,aph03,aph08,aph041,aph05,",
                  "         aph05f,aph06,aph07,aph13,aph14 ",
                 #"   FROM ",l_dbs CLIPPED,"aph_file ",  # l_dbs CLIPPED,"apa_file ",   #FUN-A50102
                  "   FROM ",cl_get_target_table(g_plant_new,'aph_file'),   #FUN-A50102
                  "  WHERE aph01 = '",g_apf01,"'",
                  "  ORDER BY aph02 "
   END IF
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
   PREPARE t600_gl_p2 FROM g_sql
   DECLARE t600_gl_c2 CURSOR FOR t600_gl_p2
 
   FOREACH t600_gl_c2 INTO l_aph02,l_aph03,l_aph08,l_actno,
                           l_amt,l_amtf,l_opendate,l_duedate,l_curr,l_rate
 
      IF g_plant = p_plant  THEN     #No.TQC-6C0067
         LET l_npq.npq03 = l_actno 		# Cash, N/P
         LET l_npq.npq23 = g_apf01
      ELSE
         LET l_npq.npq03 = l_actno		# 折讓/預付
         LET l_npq.npq23 = g_aqe.aqe01 
      END IF
 
      IF l_aph03 = "1" OR l_aph03 = "2" THEN #MOD-970273     
         CASE WHEN g_apz.apz44 = '1'
                   LET l_npq.npq04=l_apf.apf03 CLIPPED,' ',l_apf.apf12
              WHEN g_apz.apz44 = '2'
                   LET l_npq.npq04=l_apf.apf03 CLIPPED,' ',l_apf.apf12,' ',
                                   l_duedate
         END CASE
      END IF
      LET l_npq.npq06 = '2'
      LET l_npq.npq07 = l_amt
      LET l_npq.npq07f= l_amtf
      LET l_npq.npq24 = l_curr
      LET l_npq.npq25 = l_rate
      IF l_aph03 = 'X' AND p_plant <> g_plant THEN    #貸方科目
         LET l_npq.npq21 = g_plant
         SELECT azp02 INTO l_npq.npq22 FROM azp_file WHERE azp01 = p_plant
      END IF
      IF p_plant = g_plant THEN    #貸方科目
         LET l_npq.npq21 = g_aqe.aqe03
         LET l_npq.npq22 = g_aqe.aqe11
      END IF
      LET l_aag371 = ''    #No.TQC-940085
     #LET g_sql="SELECT aag05,aag371 FROM ",l_dbs CLIPPED,"aag_file",  #No.TQC-940085 add aag371  #FUN-A50102
      LET g_sql="SELECT aag05,aag371 FROM ",cl_get_target_table(g_plant_new,'aag_file'),  #FUN-A50102
                " WHERE aag01 ='",l_npq.npq03,"'",
                "   AND aag00 ='",g_bookno,"'"  #No.TQC-750040
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      PREPARE t600_sel_aag_p1 FROM g_sql
      IF STATUS THEN CALL cl_err('',STATUS,0) END IF
      EXECUTE t600_sel_aag_p1 INTO l_aag05,l_aag371    #No.TQC-940085 add aag371
      IF STATUS THEN
         CALL cl_err('sel aag:',STATUS,1)
         LET g_success='N'
      END IF
      IF l_aag05='Y' THEN
         LET l_npq.npq05 = l_apf.apf05
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      LET l_npq.npq04 = ''
      LET l_npq.npq11 = ''
      LET l_npq.npq12 = ''
      LET l_npq.npq13 = ''
      LET l_npq.npq14 = ''
      LET l_npq.npq31 = ''
      LET l_npq.npq32 = ''
      LET l_npq.npq33 = ''
      LET l_npq.npq34 = ''
      LET l_npq.npq35 = ''
      LET l_npq.npq36 = ''
   IF l_npq.npqtype = '0' THEN                                                                                                      
      CALL s_def_npq(l_npq.npq03,'aapt330',l_npq.*,l_npq.npq01,'','',g_bookno1) #No.TQC-940085
      RETURNING l_npq.*                                                                                                             
      CALL s_def_npq31_npq34(l_npq.*,g_bookno1)                    #FUN-AA0087
         RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
   ELSE                                                                                                                             
      CALL s_def_npq(l_npq.npq03,'aapt330',l_npq.*,l_npq.npq01,'','',g_bookno2) #No.TQC-940085
      RETURNING l_npq.*                                                                                                             
      CALL s_def_npq31_npq34(l_npq.*,g_bookno1)                    #FUN-AA0087
         RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
   END IF                                                                                                                           
  #IF l_aag371 MATCHES '[23]' THEN                                                      #FUN-950053 mark
   IF (l_aag371 MATCHES '[23]') OR (l_aag371 MATCHES '[4]' AND l_pmc903 = 'Y' ) THEN    #FUN-950053 add 
      IF g_plant <> p_plant THEN
         LET l_npq.npq37 = g_plant
      ELSE
         LET l_npq.npq37 = l_apg03
      END IF  
   ELSE
      LET l_npq.npq37 = ''
   END IF
      CALL s_getlegal(g_plant_new) RETURNING l_legal #FUN-980001 add
      LET l_npq.npqlegal = l_legal #FUN-980001 add
     #LET g_sql="INSERT INTO ",l_dbs CLIPPED,"npq_file",   #FUN-A50102
      LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'npq_file'),   #FUN-A50102 
                "(npqsys,npq00,npq01,npq011,npq02,npq03,npq04,npq05,npq06",
                ",npq07f,npq07,npq08,npq11,npq12,npq13,npq14,npq15,npq21",
                ",npq22,npq23,npq24,npq25,npq26,npq27,npq28,npq29,npq30",
                ",npq31,npq32,npq33,npq34,npq35,npq36,npq37,npq930,npqtype,npqlegal)", #FUN-980001 add
                " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)" #FUN-980001 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      PREPARE t600_ins_npq_p1 FROM g_sql
      IF STATUS THEN CALL cl_err('',STATUS,0) END IF

      EXECUTE t600_ins_npq_p1 USING l_npq.npqsys,l_npq.npq00,l_npq.npq01,l_npq.npq011,l_npq.npq02,l_npq.npq03,l_npq.npq04,l_npq.npq05,l_npq.npq06,
                                    l_npq.npq07f,l_npq.npq07,l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,l_npq.npq14,l_npq.npq15,l_npq.npq21,
                                    l_npq.npq22,l_npq.npq23,l_npq.npq24,l_npq.npq25,l_npq.npq26,l_npq.npq27,l_npq.npq28,l_npq.npq29,l_npq.npq30,
                                    l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34,l_npq.npq35,l_npq.npq36,l_npq.npq37,l_npq.npq930,l_npq.npqtype,l_npq.npqlegal #FUN-980001 add
      IF STATUS THEN
         CALL cl_err('ins npq:',STATUS,1)
         LET g_success='N'
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('ins npq:',SQLCA.SQLCODE,1)
         LET g_success='N'
         RETURN
      END IF
      LET l_npq.npq02 = l_npq.npq02 + 1
   END FOREACH
   CALL s_chknpq3(g_apf01,'AP',1,'0',p_plant,g_bookno1) # 檢查分錄底稿平衡正確否
   IF l_aza63 = 'Y' AND g_success = 'Y' AND p_npqtype ='1' THEN                 #No.TQC-6C0067 
      CALL s_chknpq3(g_apf01,'AP',1,'1',p_plant,g_bookno2)                                                                                
   END IF                                                                                                                  
   CALL s_flows('3','',l_npq.npq01,g_aqe.aqe02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021  
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION t600_ins_apac(p_plant)
   DEFINE p_plant       LIKE type_file.chr21
   DEFINE l_aqd         RECORD LIKE aqd_file.*
   DEFINE l_aqf03       LIKE aqf_file.aqf03
 
   DECLARE t600_sel_aqf_c CURSOR FOR
      SELECT aqf03,aqf04,aqf11,aqf12,aqf13,SUM(aqf05f),SUM(aqf05) FROM aqf_file
       WHERE aqf01 = g_aqe.aqe01
         AND aqf03 = p_plant
      GROUP BY aqf03,aqf04,aqf11,aqf12,aqf13
      ORDER BY aqf03
      FOREACH t600_sel_aqf_c INTO g_aqf03,g_aqf04,g_aqf11,g_aqf12,g_aqf13,g_amtf,g_amt
         IF g_aqf03 != p_plant AND p_plant != g_plant THEN
            CONTINUE FOREACH
         END IF
         IF g_aqf03 != g_plant THEN
             SELECT *  INTO l_aqd.* FROM aqd_file WHERE aqd01 = g_aqf03
             CALL t600_ins_apa(g_aqf03,'12',l_aqd.aqd12)
             SELECT *  INTO l_aqd.* FROM aqd_file WHERE aqd01 = g_plant   #MOD-860257 mod p_plant->g_plant
             CALL t600_ins_apa(g_plant,'22',l_aqd.aqd13)
         END IF
      END FOREACH
END FUNCTION
 
FUNCTION t600_ins_apa(p_plant,p_aptype,p_apno)
   DEFINE p_plant          LIKE type_file.chr21
   DEFINE p_aptype         LIKE type_file.chr2
   DEFINE p_apno           LIKE apa_file.apa01
   DEFINE l_dbs            STRING
   DEFINE l_apa            RECORD LIKE apa_file.*
   DEFINE l_apc            RECORD LIKE apc_file.*
   DEFINE li_result        LIKE type_file.num5     #SMALLINT
   DEFINE l_apa51          LIKE apa_file.apa51
   DEFINE l_apa511         LIKE apa_file.apa511
   DEFINE l_apa54          LIKE apa_file.apa54 
   DEFINE l_apa541         LIKE apa_file.apa541
   DEFINE l_legal          LIKE azw_file.azw02       #FUN-980001 add
   DEFINE l_plant          LIKE type_file.chr10      #FUN-980020
      
       LET l_plant = p_plant                         #FUN-980020
       LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new
       LET l_apa.apa00 =p_aptype
       LET l_apa.apa02 =g_aqe.aqe02
       LET l_apa.apa01 =p_apno
      #CALL s_auto_assign_no("aap",l_apa.apa01,l_apa.apa02,l_apa.apa00,"apa_file","apa01",l_dbs,"","")    #No.FUN-A40055
       CALL s_auto_assign_no("aap",l_apa.apa01,l_apa.apa02,l_apa.apa00,"apa_file","apa01",p_plant,"","")  #No.FUN-A40055
         RETURNING li_result,l_apa.apa01
       IF (NOT li_result) THEN
          RETURN
       END IF
       IF p_aptype ='22' THEN

          LET l_apa.apa05 =g_aqf03   
          LET l_apa.apa06 =g_aqf03 
       ELSE
          LET l_apa.apa05 =g_plant   
          LET l_apa.apa06 =g_plant   
       END IF
       SELECT azp02 INTO l_apa.apa07 FROM azp_file WHERE azp01 =l_apa.apa06
       IF p_aptype ='22' THEN
          LET l_apa.apa14 = s_curr(g_aqe.aqe06,g_today) 
       ELSE
         #LET g_sql ="SELECT apa14 FROM ",l_dbs,"apa_file",   #FUN-A50102
          LET g_sql ="SELECT apa14 FROM ",cl_get_target_table(g_plant_new,'apa_file'),   #FUN-A50102
                     " WHERE apa01 = '",g_aqf04,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
          CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
          PREPARE t600_sel_apa14 FROM g_sql                                                                                           
          IF STATUS THEN CALL cl_err('',STATUS,0) END IF                                                                               
          EXECUTE t600_sel_apa14 INTO l_apa.apa14
          IF STATUS THEN                                                                                                               
             CALL cl_err('sel apa14:',STATUS,1)                                                                                          
             LET g_success='N'                                                                                                         
             RETURN                                                                                                                    
          END IF 
       END IF     
       LET l_apa.apa09 =l_apa.apa02
       LET l_apa.apa11 =g_aqf12
       CALL s_paydate_m(l_plant,'a','',l_apa.apa09,l_apa.apa02,l_apa.apa11,l_apa.apa06) #FUN-980020
           RETURNING l_apa.apa12,l_apa.apa64,l_apa.apa24
       LET l_apa.apa13 =g_aqe.aqe06
       LET l_apa.apa15 =g_aqf13
       LET l_apa.apa16 = 0
       LET l_apa.apa20 = 0
       LET l_apa.apa21 = g_aqe.aqe04
       LET l_apa.apa22 = g_aqe.aqe05
       LET l_apa.apa31f = g_amtf
       LET l_apa.apa32f = 0
       LET l_apa.apa33f = 0
       LET l_apa.apa34f = g_amtf
       LET l_apa.apa35f = 0
       LET l_apa.apa31 = g_amt
       LET l_apa.apa32 = 0
       LET l_apa.apa33 = 0
       LET l_apa.apa34 = g_amt
       LET l_apa.apa35 = 0
       LET l_apa.apa36 = g_aqf11
       LET l_apa.apa41 = 'Y'
       LET l_apa.apa42 = 'N'
      #FUN-A50102--MOD--STR--
      #LET g_sql="SELECT apt03,apt031,apt04,apt041 FROM ",l_dbs CLIPPED,"apt_file",
       LET g_sql="SELECT apt03,apt031,apt04,apt041 ",
                 "  FROM ",cl_get_target_table(g_plant_new,'apt_file'),
      #FUN-A50102--MOD--END
                 " WHERE apt01 ='",l_apa.apa36,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
       PREPARE t600_sel_apt_p1 FROM g_sql
       IF STATUS THEN CALL cl_err('',STATUS,0) END IF
       EXECUTE t600_sel_apt_p1 INTO l_apa.apa51,l_apa.apa511,l_apa.apa54,l_apa.apa541
       IF STATUS THEN
          CALL cl_err('sel apt:',STATUS,1)
          LET g_success='N'
          RETURN
       END IF
       IF p_plant =g_plant THEN
          LET l_apa51 =l_apa.apa54
          LET l_apa511=l_apa.apa541
          LET l_apa54 =l_apa.apa51
          LET l_apa541=l_apa.apa511
          LET l_apa.apa51 = l_apa51
          LET l_apa.apa511= l_apa511
          LET l_apa.apa54 = l_apa54
          LET l_apa.apa541= l_apa541
       END IF
       LET l_apa.apa57f=0
       LET l_apa.apa57 = 0
       LET l_apa.apa60f = 0
       LET l_apa.apa61f = 0
       LET l_apa.apa60 = 0
       LET l_apa.apa61 = 0
       LET l_apa.apa65f = 0
       LET l_apa.apa65 = 0
       LET l_apa.apa73 = g_amt
       LET l_apa.apa992 = g_aqe.aqe01
       LET l_apa.apainpd = g_today
       LET l_apa.apamksg = g_aqe.aqemksg
       LET l_apa.apasign = g_aqe.aqesign
       LET l_apa.apadays = g_aqe.aqedays
       LET l_apa.apaprit = g_aqe.aqeprit
       LET l_apa.apasmax = g_aqe.aqesmax
       LET l_apa.apasseq = g_aqe.aqesseq
       LET l_apa.apaprno = g_aqe.aqeprno
       LET l_apa.apaacti = g_aqe.aqeacti
       LET l_apa.apauser = g_aqe.aqeuser
       LET l_apa.apagrup = g_aqe.aqegrup
       LET l_apa.apamodu = g_aqe.aqemodu
       LET l_apa.apadate  = g_today
       LET l_apa.apa100 = g_plant     #FUN-960141 
       CALL s_getlegal(g_plant_new) RETURNING l_legal #FUN-980001 add
       LET l_apa.apalegal  = l_legal #FUN-980001 add
       LET l_apa.apa79  = 0           #No.FUN-A60024
      #LET g_sql="INSERT INTO ",l_dbs,"apa_file",    #FUN-A50102
       LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'apa_file'),   #FUN-A50102                                                                               
                 "(apa00, apa01, apa02, apa05, apa06, apa07, apa08, apa09,",
                 " apa11, apa12, apa13, apa14, apa15, apa16, apa17, apa171,",
                 " apa172,apa173,apa174,apa175,apa18, apa19, apa20, apa21,",
                 " apa22, apa23, apa24, apa25, apa31f,apa32f,apa33f,apa34f,",
                 " apa35f,apa31, apa32, apa33, apa34, apa35, apa36, apa41,",
                 " apa42, apa43, apa44, apa45, apa46, apa51, apa52, apa53,",
                 " apa54, apa55, apa56, apa57f,apa57, apa58, apa59, apa60f,",
                 " apa61f,apa60, apa61, apa62, apa63, apa64, apa65f,apa65,",
                 " apa66, apa67, apa68, apa69, apa70, apa71, apa72, apa73,",
                 " apa74, apa75, apa79,apa99, apainpd,apamksg,apasign,apadays,apaprit,",   #No.FUN-A60024 add apa79
                 " apasmax,apasseq,apaprno,apaacti,apauser,apagrup,apamodu,apadate,",
                 " apa100,apa930,apa511,apa521,apa531,apa541,apa37,apa37f,",
                 " apa101,apa102,apa992,apalegal,apaoriu,apaorig)",   #FUN-960141  #TQC-A10060 add apaoriu,apaorig
            " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
                     "?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
                     "?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,",
                     "?,?,?,?,?,?,?,?,?,?,?,?,?)"  #FUN-960141 del ?   #TQC-A10060  add ?,?   #No.FUN-A60024 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql   #FUN-A50102
       PREPARE t600_ins_apa_p FROM g_sql
       IF STATUS THEN CALL cl_err('',STATUS,0) END IF

       EXECUTE t600_ins_apa_p USING l_apa.apa00,l_apa.apa01,l_apa.apa02,l_apa.apa05,l_apa.apa06,l_apa.apa07,l_apa.apa08,l_apa.apa09,
                                    l_apa.apa11,l_apa.apa12,l_apa.apa13,l_apa.apa14,l_apa.apa15,l_apa.apa16,l_apa.apa17,l_apa.apa171,
                                    l_apa.apa172,l_apa.apa173,l_apa.apa174,l_apa.apa175,l_apa.apa18,l_apa.apa19,l_apa.apa20,l_apa.apa21,
                                    l_apa.apa22,l_apa.apa23,l_apa.apa24,l_apa.apa25,l_apa.apa31f,l_apa.apa32f,l_apa.apa33f,l_apa.apa34f,
                                    l_apa.apa35f,l_apa.apa31,l_apa.apa32,l_apa.apa33,l_apa.apa34,l_apa.apa35,l_apa.apa36,l_apa.apa41,
                                    l_apa.apa42,l_apa.apa43,l_apa.apa44,l_apa.apa45,l_apa.apa46,l_apa.apa51,l_apa.apa52,l_apa.apa53,
                                    l_apa.apa54,l_apa.apa55,l_apa.apa56,l_apa.apa57f,l_apa.apa57,l_apa.apa58,l_apa.apa59,l_apa.apa60f,
                                    l_apa.apa61f,l_apa.apa60,l_apa.apa61,l_apa.apa62,l_apa.apa63,l_apa.apa64,l_apa.apa65f,l_apa.apa65,
                                    l_apa.apa66,l_apa.apa67,l_apa.apa68,l_apa.apa69,l_apa.apa70,l_apa.apa71,l_apa.apa72,l_apa.apa73,
                                    l_apa.apa74,l_apa.apa75,l_apa.apa79,l_apa.apa99,l_apa.apainpd,l_apa.apamksg,l_apa.apasign,l_apa.apadays,l_apa.apaprit,         #No.FUN-A60024
                                    l_apa.apasmax,l_apa.apasseq,l_apa.apaprno,l_apa.apaacti,l_apa.apauser,l_apa.apagrup,l_apa.apamodu,l_apa.apadate,
                                    l_apa.apa100,l_apa.apa930,l_apa.apa511,l_apa.apa521,l_apa.apa531,l_apa.apa541,l_apa.apa37,l_apa.apa37f,
                                    l_apa.apa101,l_apa.apa102,l_apa.apa992,l_apa.apalegal,g_user,g_grup     #FUN-960141 #TQC-A10060  add g_user,g_grup
       IF STATUS THEN
          CALL cl_err('ins apa:',STATUS,1)
          LET g_success='N'
          RETURN
       END IF
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err('ins apa:',SQLCA.SQLCODE,1)
          LET g_success='N'
          RETURN
       END IF
#insert apc
       LET l_apc.apc01 =l_apa.apa01
       LET l_apc.apc02 ='1'
       LET l_apc.apc03 =l_apa.apa11   #MOD-7B0007
       LET l_apc.apc04 =l_apa.apa12
       LET l_apc.apc05 =l_apa.apa64
       LET l_apc.apc06 =l_apa.apa14
       LET l_apc.apc07 =l_apa.apa72
       LET l_apc.apc08 =l_apa.apa34f
       LET l_apc.apc09 =l_apa.apa34
       LET l_apc.apc10 =l_apa.apa35f
       LET l_apc.apc11 =l_apa.apa35
       LET l_apc.apc12 =l_apa.apa08
       LET l_apc.apc13 =l_apa.apa73
       LET l_apc.apc14 =l_apa.apa65f
       LET l_apc.apc15 =l_apa.apa65
       LET l_apc.apc16 =l_apa.apa20
      CALL s_getlegal(g_plant_new) RETURNING l_legal #FUN-980001 add
       LET l_apc.apclegal =l_legal  #FUN-980001 add
      #LET g_sql="INSERT INTO ",l_dbs CLIPPED,"apc_file",
       LET g_sql="INSERT INTO ",cl_get_target_table(g_plant_new,'apc_file'),   #FUN-A50102 
                 "(apc01,apc02,apc03,apc04,apc05,apc06,apc07,apc08",
                 ",apc09,apc10,apc11,apc12,apc13,apc14,apc15,apc16,apclegal) ",  #FUN-960141 add
                 " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"  #FUN-960141 add
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
       CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
       PREPARE t600_ins_apc_p FROM g_sql
       IF STATUS THEN CALL cl_err('',STATUS,0) END IF

       EXECUTE t600_ins_apc_p USING l_apc.apc01,l_apc.apc02,l_apc.apc03,l_apc.apc04,l_apc.apc05,l_apc.apc06,l_apc.apc07,l_apc.apc08,
                                    l_apc.apc09,l_apc.apc10,l_apc.apc11,l_apc.apc12,l_apc.apc13,l_apc.apc14,l_apc.apc15,l_apc.apc16,l_apc.apclegal  #FUN-960141 add
       IF STATUS THEN
          CALL cl_err('ins apc:',STATUS,1)
          LET g_success='N'
          RETURN
       END IF
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err('ins apc:',SQLCA.SQLCODE,1)
          LET g_success='N'
          RETURN
       END IF
END FUNCTION
 
 
FUNCTION t600_upd_apac(p_code)
   DEFINE p_code      LIKE type_file.chr1
   DEFINE l_aqf03     LIKE aqf_file.aqf03
   DEFINE l_aqf04     LIKE aqf_file.aqf04
   DEFINE l_aqf06     LIKE aqf_file.aqf06
   DEFINE l_aqf05f    LIKE aqf_file.aqf05f
   DEFINE l_aqf05     LIKE aqf_file.aqf05
               
   DECLARE t600_sel_aqf_c1 CURSOR FOR
      SELECT aqf03,aqf04,aqf06,aqf05f,aqf05 FROM aqf_file
       WHERE aqf01 = g_aqe.aqe01 AND aqf00 =g_aqe.aqe00
 
   FOREACH t600_sel_aqf_c1 INTO l_aqf03,l_aqf04,l_aqf06,l_aqf05f,l_aqf05
      IF STATUS THEN
         CALL cl_err('sel_aqc_c1',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      CALL t600_upd_apa(l_aqf03,l_aqf04,l_aqf06,l_aqf05f,l_aqf05,p_code)   #CHI-7C0033 
   END FOREACH
END FUNCTION
 
FUNCTION t600_upd_apa(p_plant,p_apno,p_line,p_amtf,p_amt,p_code)
   DEFINE p_plant          LIKE type_file.chr21
   DEFINE p_line           LIKE aqf_file.aqf06
   DEFINE p_amt            LIKE aqf_file.aqf05
   DEFINE p_amtf           LIKE aqf_file.aqf05f
   DEFINE p_apno           LIKE aqf_file.aqf04
   DEFINE p_code           LIKE type_file.chr1
   DEFINE l_dbs            STRING
   DEFINE l_apa            RECORD LIKE apa_file.*
   DEFINE l_apc            RECORD LIKE apc_file.* 
   DEFINE l_apa14          LIKE apa_file.apa14   #CHI-7C0033
   DEFINE l_azi04          LIKE azi_file.azi04   #CHI-7C0033
   
   
      LET g_plant_new=p_plant CALL s_getdbs() LET l_dbs=g_dbs_new
     #LET g_sql = " SELECT apa14 FROM ",l_dbs CLIPPED,"apa_file",   #FUN-A50102
      LET g_sql = " SELECT apa14 FROM ",cl_get_target_table(g_plant_new,'apa_file'),  #FUN-A50102
                  " WHERE apa01 ='",p_apno,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      PREPARE t600_upd_apa_p2 FROM g_sql
      IF STATUS THEN CALL cl_err('',STATUS,0) END IF
      EXECUTE t600_upd_apa_p2 INTO l_apa14
     #FUN-A50102--mod--str--
     #LET g_sql = " SELECT azi04 FROM ",l_dbs CLIPPED,"azi_file,",
     #            l_dbs CLIPPED,"aza_file",
      LET g_sql = " SELECT azi04 ",
                  "   FROM ",cl_get_target_table(g_plant_new,'azi_file'),
                  "       ,",cl_get_target_table(g_plant_new,'aza_file'),
     #FUN-A50102--mod--end
                  " WHERE aza17 = azi01"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      PREPARE t600_upd_apa_p3 FROM g_sql
      IF STATUS THEN CALL cl_err('',STATUS,0) END IF
      EXECUTE t600_upd_apa_p3 INTO l_azi04
      LET p_amt = cl_digcut(p_amtf * l_apa14,l_azi04)
      IF p_code ='0' THEN     #審核更新
       #LET g_sql="UPDATE ",l_dbs CLIPPED,"apa_file",   #FUN-A50102
        LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'apa_file'),   #FUN-A50102 
                   " SET apa35f =apa35f + '",p_amtf,"',apa35 = apa35 + '",p_amt,"',",
                   " apa73 =apa73 - '",p_amt,"'",
                   " WHERE apa01 ='",p_apno,"'"
      ELSE                    #撤銷審核更新
       #LET g_sql="UPDATE ",l_dbs CLIPPED,"apa_file",   #FUN-A50102
        LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'apa_file'),   #FUN-A50102
                   " SET apa35f =apa35f - '",p_amtf,"',apa35 = apa35 - '",p_amt,"',",
                   " apa73 =apa73 + '",p_amt,"'",
                   " WHERE apa01 ='",p_apno,"'"
      END IF
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      PREPARE t600_upd_apa_p FROM g_sql
      IF STATUS THEN CALL cl_err('',STATUS,0) END IF
      EXECUTE t600_upd_apa_p
      IF STATUS THEN
         CALL cl_err('upd apa:',STATUS,1)
         LET g_success='N'
         RETURN
      END IF
#update apc
      IF p_code ='0' THEN     #審核更新
       #LET g_sql="UPDATE ",l_dbs CLIPPED,"apc_file",   #FUN-A50102
        LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'apc_file'),   #FUN-A50102
                   " SET apc11 =apc11 + '",p_amt,"',apc10 = apc10 + '",p_amtf,"',",
                   " apc13 =apc13 - '",p_amt,"'",
                   " WHERE apc01 ='",p_apno,"'",
                   "   AND apc02 ='",p_line,"'"
      ELSE                    #撤銷審核更新
       #LET g_sql="UPDATE ",l_dbs CLIPPED,"apc_file",    #FUN-A50102
        LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'apc_file'),   #FUN-A50102
                   " SET apc11 =apc11 - '",p_amt,"',apc10 = apc10 - '",p_amtf,"',",
                   " apc13 =apc13 + '",p_amt,"'",
                   " WHERE apc01 ='",p_apno,"'",
                   "   AND apc02 ='",p_line,"'"
      END IF
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql  #FUN-A50102
      PREPARE t600_upd_apc_p FROM g_sql
      IF STATUS THEN CALL cl_err('',STATUS,0) END IF
      EXECUTE t600_upd_apc_p
      IF STATUS THEN
         CALL cl_err('upd apc:',STATUS,1)
         LET g_success='N'
      END IF
END FUNCTION
 
FUNCTION t600_bookno()                                                                                                              
   IF g_apz.apz02='Y' THEN          #MOD-BB0212 mod sma03 -> apz02
      LET g_db1 = g_apz.apz02p      #MOD-BB0212 mod sma87 -> apz02p
   ELSE                                                                                                                             
      LET g_db1 = g_plant                                                                                                           
   END IF

   LET g_plantm = g_db1       #FUN-980020
   SELECT azp03 INTO g_azp03 FROM azp_file                                                                                          
    WHERE azp01=g_db1                                                                                                               
   LET g_db_type=cl_db_get_database_type()                                                                                             
   LET g_dbsm = s_dbstring(g_azp03 CLIPPED) 

   CALL s_get_bookno1(YEAR(g_aqe.aqe02),g_plantm)   #FUN-980020 
        RETURNING g_flag,g_bookno1,g_bookno2                                                                                        
   IF g_flag =  '1' THEN  #抓不到帳別                                                                                               
      CALL cl_err(g_dbsm,'aoo-081',1)                                                                                               
      CALL cl_used(g_prog,g_time,2) RETURNING g_time       #FUN-B30211
      EXIT PROGRAM                                                                                                                  
   END IF                                                                                                                           
END FUNCTION                                                                                                                        
#No.FUN-9C0077 程式精簡

