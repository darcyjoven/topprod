# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: aglg008.4gl
# Descriptions...: 合併前沖銷勾稽表
# Date & Author..: 05/09/02 By Sarah
# Modify.........: No.FUN-5A0020 05/10/06 By Sarah 資料show出有少
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-660060 06/06/28 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-680098 06/08/30 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.TQC-690090 06/12/07 By Claire 語言鈕失效 
# Modify.........: No.FUN-6C0012 06/12/26 By Judy 新增欄位打印額外名稱
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-740020 07/04/06 By lora    會計科目加帳套
# Modify.........: NO.FUN-750076 07/05/18 BY yiting 加上版本條件
# Modify.........: No.FUN-760044 07/06/15 By Sarah 隱藏畫面的版本欄位,列印也不印
# Modify.........: No.FUN-750110 07/06/15 By dxfwo CR報表的制作
# Modify.........: No.FUN-770069 07/08/06 By Sarah 列印報表時應只抓QBE選擇的版本資料
# Modify.........: No.MOD-870208 08/07/23 By Sarah 將CR Temptable的num10欄位改成sort
# Modify.........: No.TQC-950041 09/05/08 By chenmoyan 將tm.b換成tm.axa03
# Modify.........: No.FUN-930138 09/05/20 By ve007 報表產出時，除了來源公司的上下層關係人之外，其餘對象關係人不產出 
# Modify.........: No.FUN-950048 09/05/25 By jan 拿掉‘版本’欄位
# Modify.........: No.FUN-950111 09/06/01 By lutingting選aag02時還應考慮axa09
# Modify.........: No.MOD-950214 09/06/02 By Sarah 報表應以agli003設定檢核借貸平衡方式表達
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-9A0027 09/10/15 By mike 年度期别之初值应调整为CALL s_yp(g_today) RETURNING tm.yy,tm.bm                    
# Modify.........: No:FUN-9B0073 09/11/10 By wujie  5.2SQL转标准语法
# Modify.........: No.FUN-9C0072 10/01/18 By vealxu 精簡程式碼
# Modify.........: No.FUN-A50102 10/06/07 By lutingtingGP5.3集團架構優化:跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70084 10/07/15 By lutingting GP5.2報表修改
# Modify.........: No.FUN-A30122 10/08/24 By vealxu 合併帳別/合併資料庫的抓法改為CALL s_get_aaz641,s_aaz641_dbs
# Modify.........: No:FUN-930138 10/09/06 By chenmoyan 報表產出時 除了來源公司的上下層關係人之外 其餘對像關係人不產出
# Modify.........: No.FUN-B50001 11/05/10 By lutingting agls101參數檔改為aaw_file
# Modify.........: No.FUN-B90027 11/09/21 By Wangning 明細CR報表轉GR
# Modify.........: No.FUN-B90027 12/01/13 By xuxz FUN-B50001 rollback
# Modify.........: No.FUN-C50007 12/05/14 By minpp GR程序优化
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm         RECORD
                  axa01   LIKE axa_file.axa01,   #列印族群
                  axa02   LIKE axa_file.axa02,   #來源公司編號
                  axa03   LIKE axa_file.axa03,   #帳別
                  yy      LIKE type_file.num5,   #輸入年度     #No.FUN-680098 smallint 
                  bm      LIKE type_file.num5,   #Begin 期別   #No.FUN-680098 smallint
                  em      LIKE type_file.num5,   # End  期別   #No.FUN-680098 smallint
                  d       LIKE type_file.chr1,   #金額單位     #No.FUN-680098 VARCHAR(1)  
                  e       LIKE type_file.chr1,   #打印額外名稱 #FUN-6C0012
                  more    LIKE type_file.chr1    #Input more condition(Y/N)   #No.FUN-680098 VARCHAR(1)   
                  END RECORD 
DEFINE g_unit     LIKE type_file.num10           #金額單位基數 #No.FUN-680098 integer
DEFINE g_bookno   LIKE aah_file.aah00            #帳別
DEFINE g_aaa03    LIKE aaa_file.aaa03   
DEFINE g_i        LIKE type_file.num5            #count/index for any purpose #No.FUN-680098  SMALLINT
DEFINE g_head1    STRING                         #FUN-5B0141    
DEFINE g_str      STRING                         #No.FUN-750110
DEFINE g_sql      STRING                         #No.FUN-750110 
DEFINE l_table    STRING                         #No.FUN-750110
DEFINE g_axa          DYNAMIC ARRAY OF RECORD                     
                      axb02         LIKE axb_file.axb02, 
                      axb04         LIKE axb_file.axb04,
                      num_b         LIKE type_file.num5,
                      num_e         LIKE type_file.num5
                      END RECORD
DEFINE g_j        LIKE type_file.num5       
DEFINE g_k        LIKE type_file.num5       
DEFINE g_flag     LIKE type_file.chr1
DEFINE g_axa2         DYNAMIC ARRAY OF RECORD                     
                      axb02         LIKE axb_file.axb02, 
                      axb02_axz08   LIKE axz_file.axz08,
                      axb04         LIKE axb_file.axb04,
                      axb05         LIKE axb_file.axb05,
                      axb04_axz08   LIKE axz_file.axz08,
                      count         LIKE type_file.num5
                      END RECORD
DEFINE g_dbs_axz03    LIKE type_file.chr21       
DEFINE g_plant_axz03  LIKE type_file.chr21        #FUN-A30122 add
DEFINE g_dbs_gl       LIKE type_file.chr21        #FUN-950111 add                                                                   
DEFINE g_axa_count    LIKE type_file.num5         #FUN-950111 add 
DEFINE g_aaz641       LIKE aaz_file.aaz641        #MOD-950214 add   #FUN-B50001#FUN-B90027(FUN-B50001) rollback
#DEFINE g_aaw01       LIKE aaw_file.aaw01          #FUN-B50001#FUN-B90027(FUN-B50001) rollback
 
###GENGRE###START
TYPE sr1_t RECORD
    axk02 LIKE axk_file.axk02,
    bxi01 LIKE bxi_file.bxi01,
    axk05 LIKE axk_file.axk05,
    aag02 LIKE aag_file.aag02,
    axk10 LIKE axk_file.axk10,
    axk11 LIKE axk_file.axk11,
    axk15 LIKE axk_file.axk15,
    sort LIKE type_file.num10,
    ln LIKE type_file.num10
END RECORD
###GENGRE###END

MAIN
   OPTIONS
       INPUT NO WRAP,
       FIELD ORDER FORM
   DEFER INTERRUPT                     #Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
  LET g_sql = "axk02.axk_file.axk02,",
              "bxi01.bxi_file.bxi01,",
              "axk05.axk_file.axk05,",
              "aag02.aag_file.aag02,",
              "axk10.axk_file.axk10,",
              "axk11.axk_file.axk11,",
              "axk15.axk_file.axk15,",    
              "sort.type_file.num10,",    #MOD-870208 mod num10->sort
              "ln.type_file.num10"        #MOD-950214 add
   LET l_table = cl_prt_temptable('agl008',g_sql) CLIPPED     
   IF l_table = -1 THEN
      CALL cl_gre_drop_temptable(l_table)           #FUN-B90027 
      EXIT PROGRAM
   END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?)"  #MOD-950214 add ?
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
   LET g_bookno   = ARG_VAL(1)
   LET g_pdate    = ARG_VAL(2)         #Get arguments from command line
   LET g_towhom   = ARG_VAL(3)
   LET g_rlang    = ARG_VAL(4)
   LET g_bgjob    = ARG_VAL(5)
   LET g_prtway   = ARG_VAL(6)
   LET g_copies   = ARG_VAL(7)
   LET tm.axa01   = ARG_VAL(8)
   LET tm.axa02   = ARG_VAL(9)
   LET tm.axa03   = ARG_VAL(10)
   LET tm.yy      = ARG_VAL(11)
   LET tm.bm      = ARG_VAL(12)
   LET tm.em      = ARG_VAL(13)
   LET tm.d       = ARG_VAL(14)
   LET g_rep_user = ARG_VAL(15)
   LET g_rep_clas = ARG_VAL(16)
   LET g_template = ARG_VAL(17)
   LET tm.e       = ARG_VAL(18)    #FUN-6C0012
   LET g_rpt_name = ARG_VAL(19)  #No.FUN-7C0078
 
   #axk02=>公司代號, axk07=>對象關係人, axk05=>科目
   #aag02=>科目說明, axk10=>借方金額  , axk11=>貸方金額
 CREATE TEMP TABLE g008_file(
       axk02  LIKE axk_file.axk02,
       axk04  LIKE axk_file.axk04,    #FUN-950048 add
       axk07  LIKE bxi_file.bxi01,
       axk05  LIKE axk_file.axk05,
       axk10  LIKE axk_file.axk10,
       axk11  LIKE axk_file.axk11,
       sort   LIKE type_file.num10,
       ln     LIKE type_file.num10)   #MOD-950214 add
 CREATE TEMP TABLE g008_axa_file(
   axb02 LIKE type_file.chr10, 
   axb04 LIKE type_file.chr10, 
   count LIKE type_file.num5)  
 
   IF cl_null(g_bookno) THEN LET g_bookno = g_aaz.aaz64 END IF
   IF cl_null(tm.axa03) THEN LET tm.axa03 = g_aza.aza81 END IF   #No.FUN-740020
#  寫死后導致程序無資料，無結果顯示
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN   # If background job sw is off
      CALL g008_tm()                           # Input print condition
   ELSE
      CALL g008()         
   END IF
   DROP TABLE g008_file
   DROP TABLE g008_axa_file     #FUN-930138
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
   CALL cl_gre_drop_temptable(l_table)           #FUN-B90027
END MAIN
 
FUNCTION g008_tm()
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680098   smallint
          l_sw           LIKE type_file.chr1,         #重要欄位是否空白    #No.FUN-680098   VARCHAR(1) 
          l_cmd          LIKE type_file.chr1000       #No.FUN-680098  VARCHAR(400)
   
   CALL s_dsmark(g_bookno)
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW g008_w AT p_row,p_col WITH FORM "agl/42f/aglg008" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                  #Default condition
   IF cl_null(tm.axa03) THEN LET tm.axa03 = g_aza.aza81 END IF   #No.FUN-740020
 
   #使用預設帳別之幣別
   SELECT aaa03 INTO g_aaa03 FROM aaa_file WHERE aaa01 = tm.axa03    #No.FUN-740020
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aaa_file",tm.axa03,"",SQLCA.sqlcode,"","sel aaa:",0)  # NO.FUN-660123   ##No.FUN-740020
   END IF
   CALL s_yp(g_today) RETURNING tm.yy,tm.bm #CHI-9A0027   
   LET tm.em=tm.bm #CHI-9A0027          
   LET tm.d = '1'
   LET tm.e = 'N'  #FUN-6C0012
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
      LET l_sw = 1
      INPUT BY NAME tm.axa01,tm.axa02,tm.axa03,tm.yy,tm.bm,tm.em,tm.d,tm.e,tm.more   #FUN-6C0012  #NO.FUN-750076 #FUN-950048 
            WITHOUT DEFAULTS  
         BEFORE INPUT
             CALL cl_qbe_init()
         ON ACTION locale
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_action_choice = "locale"
            EXIT INPUT  #TQC-690090 add
 
 
         AFTER FIELD axa01
            IF cl_null(tm.axa01) THEN NEXT FIELD axa01 END IF
            SELECT DISTINCT axa01 FROM axa_file WHERE axa01=tm.axa01
            IF STATUS THEN
               CALL cl_err3("sel","axa_file",tm.axa01,"",STATUS,"","sel axa:",0)  # NO.FUN-660123
               NEXT FIELD axa01 
            END IF
 
         AFTER FIELD axa02
            IF cl_null(tm.axa02) THEN NEXT FIELD axa02 END IF
            SELECT axa02 FROM axa_file WHERE axa01=tm.axa01 AND axa02=tm.axa02
            IF STATUS THEN
               CALL cl_err3("sel","axa_file",tm.axa01,tm.axa02,STATUS,"","sel axa:",0)  # NO.FUN-660123
               NEXT FIELD axa02 
            END IF
 
         AFTER FIELD axa03
            IF cl_null(tm.axa03) THEN NEXT FIELD axa03 END IF
            SELECT axa03 INTO tm.axa03 FROM axa_file 
             WHERE axa01=tm.axa01 AND axa02=tm.axa02 AND axa03=tm.axa03
            IF STATUS THEN 
               CALL cl_err3("sel","axa_file",tm.axa01,tm.axa02,STATUS,"","sel axa:",0)  # NO.FUN-660123
               NEXT FIELD axa03 
            END IF
            DISPLAY BY NAME tm.axa03
 
         AFTER FIELD yy
            IF cl_null(tm.yy) OR tm.yy = 0 THEN NEXT FIELD yy END IF
 
         AFTER FIELD bm
         IF NOT cl_null(tm.bm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.bm > 12 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            ELSE
               IF tm.bm > 13 OR tm.bm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD bm
               END IF
            END IF
         END IF
 
         AFTER FIELD em
         IF NOT cl_null(tm.em) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = tm.yy
            IF g_azm.azm02 = 1 THEN
               IF tm.em > 12 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            ELSE
               IF tm.em > 13 OR tm.em < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD em
               END IF
            END IF
         END IF
            IF tm.bm > tm.em THEN CALL cl_err('','9011',0) NEXT FIELD bm END IF
 
         AFTER FIELD d
            IF cl_null(tm.d) OR tm.d NOT MATCHES'[123]' THEN NEXT FIELD d END IF
 
         AFTER FIELD more
            IF tm.more = 'Y'
               THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies)
                         RETURNING g_pdate,g_towhom,g_rlang,
                                   g_bgjob,g_time,g_prtway,g_copies
            END IF
 
         AFTER INPUT 
            IF INT_FLAG THEN EXIT INPUT END IF
            IF cl_null(tm.yy) THEN
               LET l_sw = 0 
               DISPLAY BY NAME tm.yy 
               CALL cl_err('',9033,0)
            END IF
            IF cl_null(tm.bm) THEN
               LET l_sw = 0 
               DISPLAY BY NAME tm.bm 
            END IF
            IF cl_null(tm.em) THEN
               LET l_sw = 0 
               DISPLAY BY NAME tm.em 
            END IF
            IF tm.d = '1' THEN LET g_unit = 1       END IF
            IF tm.d = '2' THEN LET g_unit = 1000    END IF
            IF tm.d = '3' THEN LET g_unit = 1000000 END IF
            IF l_sw = 0 THEN 
               LET l_sw = 1 
               NEXT FIELD a
               CALL cl_err('',9033,0)
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(axa01) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = 'q_axa'
                  LET g_qryparam.default1 = tm.axa01
                  LET g_qryparam.default2 = tm.axa02
                  LET g_qryparam.default3 = tm.axa03
                  CALL cl_create_qry() RETURNING tm.axa01,tm.axa02,tm.axa03
                  DISPLAY BY NAME tm.axa01,tm.axa02,tm.axa03
                  NEXT FIELD axa01
               WHEN INFIELD(axa02)   #下層公司編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_axz"
                  CALL cl_create_qry() RETURNING tm.axa02
                  DISPLAY BY NAME tm.axa02
                  NEXT FIELD axa02
               WHEN INFIELD(axa03)  #帳別開窗
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aaa"
                  CALL cl_create_qry() RETURNING tm.axa03
                  DISPLAY BY NAME tm.axa03
                  NEXT FIELD axa03
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
     
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
 
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW g008_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)           #FUN-B90027
         EXIT PROGRAM
            
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
          WHERE zz01='aglg008'
         IF SQLCA.sqlcode OR l_cmd IS NULL THEN
            CALL cl_err('aglg008','9031',1)   
         ELSE
            LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                            " '",g_bookno CLIPPED,"'" ,
                            " '",g_pdate CLIPPED,"'",
                            " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                            " '",g_bgjob CLIPPED,"'",
                            " '",g_prtway CLIPPED,"'",
                            " '",g_copies CLIPPED,"'",
                            " '",tm.axa01 CLIPPED,"'",
                            " '",tm.axa02 CLIPPED,"'",
                            " '",tm.axa03 CLIPPED,"'",
                            " '",tm.yy CLIPPED,"'",
                            " '",tm.bm CLIPPED,"'",
                            " '",tm.em CLIPPED,"'",
                            " '",tm.d CLIPPED,"'",
                            " '",tm.e CLIPPED,"'",                 #FUN-6C0012
                            " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                            " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                            " '",g_template CLIPPED,"'"            #No.FUN-570264
            CALL cl_cmdat('aglg008',g_time,l_cmd)    # Execute cmd at later time
         END IF
         CLOSE WINDOW g008_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         CALL cl_gre_drop_temptable(l_table)           #FUN-B90027
         EXIT PROGRAM
      END IF
      CALL cl_wait()
      CALL g008()
      ERROR ""
   END WHILE
   CLOSE WINDOW g008_w
END FUNCTION
 
FUNCTION g008()
   DEFINE l_name         LIKE type_file.chr20        # External(Disk) file name        #No.FUN-680098  VARCHAR(20)
   DEFINE l_name1        LIKE type_file.chr20        # External(Disk) file name        #No.FUN-680098  VARCHAR(20) 
   DEFINE l_sql          STRING                      # RDSQL STATEMENT    
   DEFINE l_leng,l_leng2 LIKE type_file.num5         #No.FUN-680098    SMALLINT
   DEFINE l_axb          RECORD
                         axb01         LIKE axb_file.axb01,   #FUN-930138 add
                         axb04         LIKE axb_file.axb04,
                         axb05         LIKE axb_file.axb05,
                         axa02_axz08   LIKE axz_file.axz08    #FUN-930138 add
                         END RECORD 
   DEFINE l_axf          RECORD LIKE axf_file.*
   DEFINE sr             RECORD
                         axk02      LIKE axk_file.axk02,
                         axk04      LIKE axk_file.axk04, #FUN-950048
                         axk07      LIKE axk_file.axk07,
                         axk05      LIKE axk_file.axk05,
                         axk10      LIKE axk_file.axk10,
                         axk11      LIKE axk_file.axk11,
                         aag02      LIKE aag_file.aag02,   
                         sort       LIKE type_file.num10,   #FUN-5A0020     #No.FUN-680098  INT
                         ln         LIKE type_file.num10     #MOD-950214 add
                         END RECORD
   DEFINE l_str1,l_str2,l_str3,l_str4,l_str5   LIKE type_file.chr20     #No.FUN-680098 VARCHAR(20) 
   DEFINE l_str6,l_str7,l_str8,l_str9,l_str10  LIKE type_file.chr20     #No.FUN-680098 VARCHAR(20) 
   DEFINE l_str,l_totstr                       LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(300) 
   DEFINE l_no,l_cn,l_cnt,l_i,l_j              LIKE type_file.num5      #No.FUN-680098 smallint
   DEFINE l_cmd,l_cmd1   LIKE type_file.chr1000,    #No.FUN-680098 VARCHAR(400) 
          l_cmd2         LIKE type_file.chr1000,    #MOD-580055         #No.FUN-680098 VARCHAR(400) 
          l_amt          LIKE type_file.num20_6,    #No.FUN-680098 decimal(20,6) 
          l_count        LIKE type_file.num5,       #No.FUN-680098 smallint
          l_modi         LIKE abh_file.abh11,       #No.FUN-680098 VARCHAR(28)
          l_d_amt        LIKE type_file.num20_6,    #No.FUN-680098 decimal(20,6)
          l_c_amt        LIKE type_file.num20_6,    #No.FUN-680098 decimal(20,6)
          l_dc_amt       LIKE type_file.num20_6,    #No.FUN-680098 decimal(20,6)
          l_k            LIKE type_file.num10,      #FUN-5A0020         #No.FUN-680098 integer 
          l_aag02        LIKE aag_file.aag13,       #FUN-750110       
          l_axk10        LIKE axk_file.axk10,       #FUN-750110   
          l_axk11        LIKE axk_file.axk11        #FUN-750110 
   DEFINE l_axb04_axz08  LIKE axz_file.axz08         
   DEFINE l_n            LIKE type_file.num5
 
   SELECT aaf03 INTO g_company FROM aaf_file 
    WHERE aaf01 = tm.axa03 AND aaf02 = g_rlang      #TQC-950041
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aglg008'
   IF g_len = 0 OR g_len IS NULL THEN LET g_len = 223 END IF
   
   FOR g_i = 1 TO g_len LET g_dash2[g_i,g_i] = '=' END FOR
   LET g_j = 1
   LET g_k = 1
   LET g_flag = 'N'
   CALL cl_del_data(l_table)     
   CALL g008_p(g_j)
END FUNCTION
 
FUNCTION g008_p(p_i)
DEFINE p_axa02 LIKE axa_file.axa02
DEFINE l_sql   STRING 
DEFINE l_cnt   LIKE type_file.num5
DEFINE i       LIKE type_file.num5
DEFINE p_i     LIKE type_file.num5
DEFINE l_axb04 LIKE axb_file.axb04
DEFINE l_axb02 LIKE axb_file.axb02
DEFINE l_j     LIKE type_file.num5
DEFINE l_tmp_count LIKE type_file.num5
 
   WHILE g_flag = 'N'
     IF p_i = 1 THEN  #找第一階
         #根據tm.axa02找出子公司清單
         LET l_sql = "SELECT axb04 FROM axb_file",
                     " WHERE axb01 = '",tm.axa01,"'",
                     "   AND axb02 = '",tm.axa02,"'",
                     " ORDER BY axb04"
         PREPARE g008_p1 FROM l_sql
         IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time 
            CALL cl_gre_drop_temptable(l_table)           #FUN-B90027
            EXIT PROGRAM 
         END IF
         DECLARE g008_c1 CURSOR FOR g008_p1
         LET l_axb04 = ''
         FOREACH g008_c1 INTO l_axb04  #抓出第一層子公司
            LET l_axb02 = l_axb04
            LET l_cnt = 0
                INSERT INTO g008_axa_file VALUES(tm.axa02,l_axb04,g_j)
                LET g_axa2[g_k].axb02 = tm.axa02
                SELECT axz08 INTO g_axa2[g_k].axb02_axz08
                  FROM axz_file 
                 WHERE axz01 = g_axa2[g_k].axb02
                LET g_axa2[g_k].axb04 = l_axb04
                SELECT axz05,axz08 INTO g_axa2[g_k].axb05,
                                        g_axa2[g_k].axb04_axz08
                  FROM axz_file 
                 WHERE axz01 = g_axa2[g_k].axb04
                LET g_axa2[g_k].count = g_j
                LET g_k = g_k + 1
         END FOREACH
         CALL g_axa2.deleteElement(g_k)
     ELSE
         LET l_axb04 = ''
         LET l_j = g_j - 1
         LET l_sql = "SELECT axb04 FROM g008_axa_file ",
                     " WHERE count = '",l_j,"'"
         PREPARE g008_p2 FROM l_sql
         IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time 
            CALL cl_gre_drop_temptable(l_table)           #FUN-B90027
            EXIT PROGRAM 
         END IF
         DECLARE g008_c2 CURSOR FOR g008_p2

         #FUN-C50007--ADD--STR
         LET l_sql = "SELECT axb04 FROM axb_file",
                         " WHERE axb01 = '",tm.axa01,"'",
                         "   AND axb02 = ?",
                         " ORDER BY axb04"
             PREPARE g008_p3 FROM l_sql
             IF STATUS THEN CALL cl_err('prepare:',STATUS,1)
                CALL cl_used(g_prog,g_time,2) RETURNING g_time
                CALL cl_gre_drop_temptable(l_table)           #FUN-B90027
                EXIT PROGRAM
             END IF
             DECLARE g008_c3 CURSOR FOR g008_p3
         #FUN-C50007--ADD--END
         FOREACH g008_c2 INTO l_axb02
            #FUN-C50007--MARK---STR
            #LET l_sql = "SELECT axb04 FROM axb_file",
            #            " WHERE axb01 = '",tm.axa01,"'",
            #            "   AND axb02 = '",l_axb02,"'",
            #            " ORDER BY axb04"
            #PREPARE g008_p3 FROM l_sql
            #IF STATUS THEN CALL cl_err('prepare:',STATUS,1) 
            #   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
            #   CALL cl_gre_drop_temptable(l_table)           #FUN-B90027
            #   EXIT PROGRAM 
            #END IF
            #DECLARE g008_c3 CURSOR FOR g008_p3
            #FUN-C50007--MARK--END
             LET l_axb04 = ''
            #FOREACH g008_c3 INTO l_axb04  #抓出第一層子公司   #FUN-C50007  MARK
             FOREACH g008_c3 USING l_axb02 INTO l_axb04        #FUN-C50007  ADD
                   INSERT INTO g008_axa_file VALUES (l_axb02,l_axb04,g_j)
                   LET g_axa2[g_k].axb02 = l_axb02
                   SELECT axz08 INTO g_axa2[g_k].axb02_axz08
                     FROM axz_file 
                    WHERE axz01 = g_axa2[g_k].axb02
                   LET g_axa2[g_k].axb04 = l_axb04
                   SELECT axz05,axz08 INTO g_axa2[g_k].axb05,
                                           g_axa2[g_k].axb04_axz08
                     FROM axz_file 
                    WHERE axz01 = g_axa2[g_k].axb04
                   LET g_axa2[g_k].count = g_j
                   LET g_k = g_k + 1
             END FOREACH
             CALL g_axa2.deleteElement(g_k)
         END FOREACH
     END IF     
     IF cl_null(l_axb02) THEN 
         LET g_flag = 'Y'
         CALL g008_ins()
     ELSE
         LET g_j = g_j + 1 
         CALL g008_p(g_j)
     END IF
   END WHILE
END FUNCTION
 
FUNCTION g008_ins()
DEFINE l_name         LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680098  VARCHAR(20)
DEFINE l_name1        LIKE type_file.chr20          # External(Disk) file name        #No.FUN-680098  VARCHAR(20) 
DEFINE l_cnt       LIKE type_file.num5
DEFINE l_axa02     LIKE axa_file.axa02
DEFINE l_sql       STRING
DEFINE l_tmp_count LIKE type_file.num5
DEFINE l_axf       RECORD LIKE axf_file.*
DEFINE sr             RECORD
                      axk02      LIKE axk_file.axk02,
                      axk04      LIKE axk_file.axk04,
                      axk07      LIKE axk_file.axk07,
                      axk05      LIKE axk_file.axk05,
                      axk10      LIKE axk_file.axk10,
                      axk11      LIKE axk_file.axk11,
                      aag02      LIKE aag_file.aag02,   
                      sort       LIKE type_file.num10,   #FUN-5A0020     #No.FUN-680098  INT
                      ln         LIKE type_file.num10    #MOD-950214 add
                      END RECORD
DEFINE l_aag02        LIKE aag_file.aag13
DEFINE i              LIKE type_file.num5
DEFINE k              LIKE type_file.num5   #MOD-950214 add
DEFINE x_aaa03        LIKE axk_file.axk14
DEFINE l_axz03        LIKE axz_file.axz03
DEFINE l_axz04        LIKE axz_file.axz04   #FUN-950111
DEFINE l_axb02        LIKE axb_file.axb02   #FUN-950111
DEFINE l_axa09        LIKE axa_file.axa09   #FUN-950111
 
#FUN-A30122 ------------------------mark start-----------------------------
#  SELECT axz03 INTO l_axz03 FROM axz_file WHERE axz01 = tm.axa02
#  LET g_plant_new = l_axz03      #營運中心
#  CALL s_getdbs()
#  LET g_dbs_axz03 = g_dbs_new    #所屬DB
#
#  #上層公司所屬合併帳別
# #LET g_sql = "SELECT aaz641 FROM ",g_dbs_axz03,"aaz_file",   #FUN-A70084
#  LET g_sql = "SELECT aaz641 FROM ",cl_get_target_table(l_axz03,'aaz_file'),   #FUN-A70084
#              " WHERE aaz00 = '0'"
#  CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
#  CALL cl_parse_qry_sql(g_sql,l_axz03) RETURNING g_sql   #FUN-A70084 #FUN-A50102
#  PREPARE g008_pre_0 FROM g_sql
#  DECLARE g008_cur_0 CURSOR FOR g008_pre_0
#  OPEN g008_cur_0
#  FETCH g008_cur_0 INTO g_aaz641   #合併帳別
#  CLOSE g008_cur_0
#FUN-A30122 --------------------------mark end--------------------------------
   CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_plant_axz03         #FUN-A30122 add                   
   CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaz641                  #FUN-A30122 add   #FUN-B50001#FUN-B90027(FUN-B50001) rollback
   #CALL s_get_aaz641(g_plant_axz03) RETURNING g_aaw01#FUN-B90027(FUN-B50001) rollback
  
   LET k = 1   #MOD-950214 add
   LET l_tmp_count = g_axa2.getLength()
   FOR i = 1 TO l_tmp_count
     #以上下層公司為key抓出所有對沖科目設定---- 
     LET l_sql = "SELECT * FROM axf_file ",
                 " WHERE axf09 = '",g_axa2[i].axb02,"'",
                 "   AND axf10 = '",g_axa2[i].axb04,"'",
                 "   AND axf13 = '",tm.axa01,"'",
                 " ORDER BY axf01"
     PREPARE g008_p6 FROM l_sql
     IF STATUS THEN CALL cl_err('prepare:',STATUS,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
        CALL cl_gre_drop_temptable(l_table)           #FUN-B90027
        EXIT PROGRAM
     END IF
     DECLARE g008_axf_c1 CURSOR FOR g008_p6
     FOREACH g008_axf_c1 INTO l_axf.*
        #--抓上層對下層 axk_file---
        SELECT axz06 INTO x_aaa03 FROM axz_file where axz01 = g_axa2[i].axb02
        IF l_axf.axf01[1,4] != 'MISC' THEN   #MOD-950214 add
           LET l_sql = "INSERT INTO g008_file ",
                       "(axk02,axk04,axk07,axk05,axk10,axk11,sort,ln) ", #FUN-950048    #MOD-950241 add ln
                       "SELECT axk02,axk04,axk07,axk05,axk10,axk11,",k,",1 ", #FUN-950048  #MOD-950214
                       "  FROM axk_file ",
                       " WHERE axk01 ='",tm.axa01,"'",               #族群
                       "   AND axk04 ='",g_axa2[i].axb02,"'",        #母公司代號
                       "   AND axk041='",tm.axa03,"'",               #母公司帳別
                       "   AND axk07 ='",g_axa2[i].axb04_axz08,"'",  #子公司關係人代碼
                       "   AND axk08 ='",tm.yy,"'",
                       "   AND axk09 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                       "   AND axk05 ='",l_axf.axf01,"'",
                       "   AND axk14 ='",x_aaa03,"'"
           PREPARE g008_p8 FROM l_sql
           EXECUTE g008_p8
           LET l_sql = "INSERT INTO g008_file ",
                       "(axk02,axk04,axk07,axk05,axk10,axk11,sort,ln) ", #FUN-950048    #MOD-950241 add ln
                       "SELECT axk02,axk04,axk07,axk05,axk10,axk11,",k,",2 ", #FUN-950048  #MOD-950214
                       "  FROM axk_file ",
                       " WHERE axk01 ='",tm.axa01,"'",               #族群
                       "   AND axk04 ='",g_axa2[i].axb04,"'",        #子公司代號
                       "   AND axk041='",g_axa2[i].axb05,"'",        #子公司帳別
                       "   AND axk07 ='",g_axa2[i].axb02_axz08,"'",  #母公司關係人代碼
                       "   AND axk08 ='",tm.yy,"'",
                       "   AND axk09 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                       "   AND axk05 ='",l_axf.axf02,"'",
                       "   AND axk14 ='",x_aaa03,"'"
           PREPARE g008_p7 FROM l_sql
           EXECUTE g008_p7
        ELSE
           LET l_sql = "INSERT INTO g008_file ",
                       "(axk02,axk04,axk07,axk05,axk10,axk11,sort,ln) ", 
                       "SELECT axk02,axk04,axk07,axk05,axk10,axk11,",k,",1 ",
                       "  FROM axk_file ",
                       " WHERE axk01 ='",tm.axa01,"'",               #族群
                       "   AND axk04 ='",g_axa2[i].axb02,"'",        #母公司代號
                       "   AND axk041='",tm.axa03,"'",               #母公司帳別
                       "   AND axk07 ='",g_axa2[i].axb04_axz08,"'",  #子公司關係人代碼
                       "   AND axk08 ='",tm.yy,"'",
                       "   AND axk09 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                       "   AND axk05 IN (SELECT DISTINCT axs03 FROM axs_file",
                       "                  WHERE axs00='",g_aaz641,"'",   #FUN-B50001#FUN-B90027(FUN-B50001) rollback
                       #"                  WHERE axs00='",g_aaw01,"'",#FUN-B90027(FUN-B50001) rollback
                       "                    AND axs01='",l_axf.axf01,"'",
                       "                    AND axs09='",l_axf.axf09,"'",
                       "                    AND axs10='",l_axf.axf10,"'",
                       "                    AND axs12='",g_aaz641,"'",   #FUN-B50001#FUN-B90027(FUN-B50001) rollback
                       #"                    AND axs12='",g_aaw01,"'",#FUN-B90027(FUN-B50001) rollback
                       "                    AND axs13='",l_axf.axf13,"')",
                       "   AND axk14 ='",x_aaa03,"'"
           PREPARE g008_p8_1 FROM l_sql
           EXECUTE g008_p8_1
           LET l_sql = "INSERT INTO g008_file ",
                       "(axk02,axk04,axk07,axk05,axk10,axk11,sort,ln) ", 
                       "SELECT axk02,axk04,axk07,axk05,axk10,axk11,",k,",2 ",
                       "  FROM axk_file ",
                       " WHERE axk01 ='",tm.axa01,"'",               #族群
                       "   AND axk04 ='",g_axa2[i].axb04,"'",        #子公司代號
                       "   AND axk041='",g_axa2[i].axb05,"'",        #子公司帳別
                       "   AND axk07 ='",g_axa2[i].axb02_axz08,"'",  #母公司關係人代碼
                       "   AND axk08 ='",tm.yy,"'",
                       "   AND axk09 BETWEEN '",tm.bm,"' AND '",tm.em,"'",
                       "   AND axk05 IN (SELECT DISTINCT axt03 FROM axt_file",
                       "                  WHERE axt00 ='",g_aaz641,"'",   #FUN-B50001#FUN-B90027(FUN-B50001) rollback
                       #"                  WHERE axt00 ='",g_aaw01,"'",#FUN-B90027(FUN-B50001) rollback
                       "                    AND axt01 ='",l_axf.axf02,"'",
                       "                    AND axt09 ='",l_axf.axf09,"'",
                       "                    AND axt10 ='",l_axf.axf10,"'",
                       "                    AND axt12 ='",g_aaz641,"'",   #FUN-B50001#FUN-B90027(FUN-B50001) rollback
                       #"                    AND axt12 ='",g_aaw01,"'",#FUN-B90027(FUN-B50001) rollback
                       "                    AND axt13 ='",l_axf.axf13,"'",
                       "                    AND axt04!='Y') ",    #是否依據公式設定
                       "   AND axk14 ='",x_aaa03,"'"
           PREPARE g008_p7_1 FROM l_sql
           EXECUTE g008_p7_1
        END IF
        LET k = k + 1
      END FOREACH
   END FOR
   #抓取資料
  LET l_sql = "SELECT axk02,axk04,axk07,axk05,sort,ln,SUM(axk10),SUM(axk11) ", #NO.FUN-750076 #FUN-950048  #MOD-950214 add ln
               "  FROM g008_file ",
               " GROUP BY axk02,axk04,axk07,axk05,sort,ln " #FUN-950048  #MOD-950214 add ln
   PREPARE g008_prepare FROM l_sql
   DECLARE g008_curs CURSOR FOR g008_prepare

  #FUN-C50007--ADD--STR
   LET g_sql = g_sql CLIPPED," FROM ",cl_get_target_table(g_plant_axz03,'aag_file'),     
                  " WHERE aag01 = ? ",
                  "   AND aag00 = '",g_aaz641,"'"   
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql    
      CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql          
      PREPARE g008_pre FROM g_sql
      DECLARE g008_cur CURSOR FOR g008_pre
  #FUN-C50007--ADD--END
   LET g_pageno = 0
   FOREACH g008_curs INTO sr.axk02,sr.axk04,sr.axk07,sr.axk05,
                          sr.sort,sr.ln,sr.axk10,sr.axk11  #FUN-950048   #MOD-950214 add sr.ln 
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
     SELECT axz03,axz04 INTO l_axz03,l_axz04    #FUN-950111 add axz04    
       FROM axz_file
      WHERE axz01 = sr.axk04    #FUN-950111 
#FUN-A30122 -----------------------------------mark start------------------------------
#     IF l_axz04 = 'N' THEN
#        LET l_axz03 = g_plant
#     ELSE
#        SELECT COUNT(*) INTO g_axa_count                                                                                        
#          FROM axb_file                                                                                                         
#         WHERE axb04 = sr.axk04   #公司編碼                                                                                  
#           AND axb01 = tm.axa01   #族群   #MOD-950214
#        IF g_axa_count>0 THEN  #在公司層級中為下層公司時
#           #先抓出上一層公司的plant                                                                                     
#           SELECT axb02 INTO l_axb02                                                                                    
#             FROM axb_file                                                                                              
#            WHERE axb01 = tm.axa01  #族群   #MOD-950214
#              AND axb04 = sr.axk04  #公司編號                                                                        
#           SELECT axa09 INTO l_axa09                                                                                    
#             FROM axa_file,axb_file                                                                                     
#            WHERE axa01 = axb01 AND axa02 = axb02                                                                       
#              AND axb01 = tm.axa01   #族群   #MOD-950214
#              AND axb02 = sr.axk02   #上層公司                                                                       
#              AND axb04 = sr.axk04   #下層公司編號                                                                   
#        ELSE                                                                                                            
#           SELECT axa09 INTO l_axa09 FROM axa_file                                                                      
#            WHERE axb01 = tm.axa01  #族群   #MOD-950214
#              AND axa02 = sr.axk04  #公司編號                                                                        
#        END IF                                                                                                          
#        IF l_axa09 = 'Y' THEN                                                                                           
#           SELECT axz03 INTO l_axz03 FROM axz_file                                                                      
#            WHERE axz01 = ar.axk04                                                                                    
#           LET g_plant_new = l_axz03    #營運中心                                                                       
#           CALL s_getdbs()                                                                                              
#           LET g_dbs_gl = g_dbs_new                                                                                     
#           LET g_dbs_axz03 = g_dbs_gl                                                                                   
#        ELSE         
#           LET g_dbs_axz03 = s_dbstring(g_dbs CLIPPED)                                                                          
#           LET g_dbs_gl = g_dbs_axz03                                                                                           
#           LET l_axz03 = g_plant   #FUN-A70084
#        END IF                                                                                                                  
#     END IF                                                                                                                     
#FUN-A30122 -----------------------------mark end--------------------------
   
      DELETE FROM g008_file
      IF tm.e = 'Y' THEN                                                                                                           
         LET g_sql = "SELECT aag13 "
      ELSE
         LET g_sql = "SELECT aag02 "
      END IF
     #LET g_sql = g_sql CLIPPED," FROM ",g_dbs_axz03,"aag_file",    #FUN-A70084
     #LET g_sql = g_sql CLIPPED," FROM ",cl_get_target_table(l_axz03,'aag_file'),   #FUN-A70084   #FUN-A30122 mark
     #FUN-C50007--MARK--STR
     #LET g_sql = g_sql CLIPPED," FROM ",cl_get_target_table(g_plant_axz03,'aag_file'),           #FUN-A30122 add
     #            " WHERE aag01 = '",sr.axk05,"' ",
     #           #"   AND aag00 = '",tm.axa03,"'"   #MOD-950214 mark
     #            "   AND aag00 = '",g_aaz641,"'"   #MOD-950214   #FUN-B50001#FUN-B90027(FUN-B50001) rollback
     #            #"   AND aag00 = '",g_aaw01,"'"   #FUN-B50001#FUN-B90027(FUN-B50001) rollback
     #CALL cl_replace_sqldb(g_sql) RETURNING g_sql    #FUN-A70084
    ##CALL cl_parse_qry_sql(g_sql,l_axz03) RETURNING g_sql   #FUN-A70084        #FUN-A30122  mark
     #CALL cl_parse_qry_sql(g_sql,g_plant_axz03) RETURNING g_sql                #FUN-A30122  add
     #PREPARE g008_pre FROM g_sql
     #DECLARE g008_cur CURSOR FOR g008_pre
     #OPEN g008_cur 
     #FUN-C50007--MARK--END
      OPEN g008_cur USING sr.axk05    #FUN-C50007  add
      FETCH g008_cur INTO l_aag02 
      IF SQLCA.sqlcode THEN LET l_aag02 = ' ' END IF                                                                             
      EXECUTE insert_prep USING                                                                                                     
         sr.axk04,sr.axk07,sr.axk05,l_aag02,sr.axk10,
         sr.axk11,'',sr.sort,sr.ln   #MOD-950214 add sr.ln
   END FOREACH
 
###GENGRE###   LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #No.FUN-750110
 
###GENGRE###   LET g_str = '',";",tm.yy,";",tm.bm,";",tm.em,";",tm.d,";",  #No.FUN-750110  #FUN-950048
###GENGRE###               tm.e,";",tm.axa01,";",tm.axa02,";",tm.axa03         #No.FUN-750110
###GENGRE###   CALL cl_prt_cs3('aglg008','aglg008',l_sql,g_str)                #No.FUN-750110 
    CALL aglg008_grdata()    ###GENGRE###
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼

###GENGRE###START
FUNCTION aglg008_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("aglg008")
        IF handler IS NOT NULL THEN
            START REPORT aglg008_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
                        ," ORDER BY sort,ln,axk02,bxi01,axk05"           #FUN-B90027  
             
            DECLARE aglg008_datacur1 CURSOR FROM l_sql
            FOREACH aglg008_datacur1 INTO sr1.*
                OUTPUT TO REPORT aglg008_rep(sr1.*)
            END FOREACH
            FINISH REPORT aglg008_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT aglg008_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    #FUN-B90027----add----str----------
    DEFINE l_bm               STRING
    DEFINE l_period1          STRING
    DEFINE l_em               STRING
    DEFINE l_period2          STRING
    DEFINE l_unit             STRING
    DEFINE l_acc_desc_title   STRING
    DEFINE l_axk10       LIKE axk_file.axk10     
    DEFINE l_axk11       LIKE axk_file.axk11     
    DEFINE l_sum_axk10   LIKE axk_file.axk10
    DEFINE l_sum_axk11   LIKE axk_file.axk11
    DEFINE l_sum_axk10_sort   LIKE axk_file.axk10
    DEFINE l_sum_axk11_sort   LIKE axk_file.axk11
    DEFINE l_balance          STRING         
    #FUN-B90027----add----end----------

    
    ORDER EXTERNAL BY sr1.sort,sr1.ln
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name    #FUN-B90027 add g_ptime,g_user_name
           
            #FUN-B90027----add----str----------
            LET l_bm = tm.bm
            LET l_bm = l_bm.trim()
            IF l_bm < 10 THEN 
               LET l_period1 = '0',l_bm
            ELSE
               LET l_period1 = l_bm
            END IF
            PRINTX l_period1

            LET l_em = tm.em
            LET l_em = l_em.trim()
            IF l_em < 10 THEN
               LET l_period2 = '0',l_em
            ELSE
               LET l_period2 = l_em
            END IF
            PRINTX l_period2
 
            LET l_unit = cl_gr_getmsg("gre-208",g_lang,tm.d)
            PRINTX l_unit

            IF tm.e = 'Y' THEN
               LET l_acc_desc_title = cl_gr_getmsg("gre-234",g_lang,'1')
            ELSE
               LET l_acc_desc_title = cl_gr_getmsg("gre-235",g_lang,'2')
            END IF
            PRINTX l_acc_desc_title
            #FUN-B90027----add----end----------

            PRINTX tm.*
              
        BEFORE GROUP OF sr1.sort

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            #FUN-B90027----add----str----------
            CASE tm.d
               WHEN '1'
                  LET l_axk10 = sr1.axk10
               WHEN '2'
                  LET l_axk10 = sr1.axk10 / 1000
               WHEN '3'
                  LET l_axk10 = sr1.axk10 / 1000000
            END CASE
            PRINTX l_axk10

            CASE tm.d
               WHEN '1' 
                  LET l_axk11 = sr1.axk11
               WHEN '2'
                  LET l_axk11 = sr1.axk11 / 1000
               WHEN '3'
                  LET l_axk11 = sr1.axk11 / 1000000
            END CASE
            PRINTX l_axk11
                  
            #FUN-B90027----add----end----------

            PRINTX sr1.*

        AFTER GROUP OF sr1.sort
            #FUN-B90027----add----str----------
            LET l_sum_axk10 = GROUP SUM(sr1.axk10) 
            LET l_sum_axk11 = GROUP SUM(sr1.axk11) 
             
            PRINTX l_sum_axk10
            PRINTX l_sum_axk11

            CASE tm.d
               WHEN '1' 
                  LET l_sum_axk10_sort = l_sum_axk10
               WHEN '2' 
                  LET l_sum_axk10_sort = l_sum_axk10 / 1000
               WHEN '3'
                  LET l_sum_axk10_sort = l_sum_axk10 / 1000000
            END CASE
            PRINTX l_sum_axk10_sort

            CASE tm.d
               WHEN '1' 
                  LET l_sum_axk11_sort = l_sum_axk11
               WHEN '2' 
                  LET l_sum_axk11_sort = l_sum_axk11 / 1000
               WHEN '3'
                  LET l_sum_axk11_sort = l_sum_axk11 / 1000000
            END CASE
            PRINTX l_sum_axk11_sort

            IF l_sum_axk10_sort = l_sum_axk11_sort THEN
               LET l_balance = cl_gr_getmsg("gre-235",g_lang,'1')
            ELSE
               LET l_balance = cl_gr_getmsg("gre-235",g_lang,'2') 
            END IF
            PRINTX l_balance
            #FUN-B90027----add----end----------

        
        ON LAST ROW

END REPORT
###GENGRE###END
