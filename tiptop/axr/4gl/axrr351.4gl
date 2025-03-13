# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: axrr351.4gl
# Desc/riptions..: 應收明細帳與總帳核對表
# Date & Author..: 97/09/09 By Roger
# Date & Modify..: 03/08/13 By Wiky #No:7775 將列印資料分開
# Modify.........: No.FUN-4C0100 04/12/23 By Smapmin 報表轉XML格式
# Modify.........: No.MOD-530153 05/03/21 By Nicola r351_c4,r351_c4_1,r351_c4_2加GROUP BY
#
# Modify.........: NO.FUN-550071 05/05/19 By jackie 單據編號加大
# Modify.........: No.TQC-5A0089 05/10/27 By Smapmin 單別寫死
# Modify.........: No.TQC-620049 06/02/15 By Smapmin 加一差異欄位
# Modify.........: No.MOD-620026 06/02/15 By Smapmin 單據長度放大
# Modify.........: No.MOD-640582 06/04/28 By Smapmin 有2筆AR,合併拋至總帳,在跑此報表時, 
#                     因未對nppglno做distinct的動作,會導致在SUM(aba08)時多加.
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.TQC-610059 06/06/23 By Smapmin 修改外部參數接收
# Modify.........: No.FUN-660060 06/06/26 By Rainy 表頭期間置於中間
# Modify.........: No.FUN-670006 06/07/10 By Jackho 帳套權限修改
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690127 06/10/16 By baogui cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.TQC-6B0051 06/12/12 By xufeng 修改報表
# Modify.........: No.MOD-710186 07/01/31 By jamie  總帳資料庫和 AR 資料庫不同,在處理傳票抓立帳部份資料時,
#                                                   未多加判斷總帳資料庫,以致總帳金額無法列印。
# Modify.........: No.MOD-720051 07/02/07 By Smapmin axrt200金額也要列入
# Modify.........: No.MOD-720012 07/02/08 By Smapmin 屬於所在工廠的帳款才需要印出來
# Modify.........: No.FUN-750115 07/06/14 By sherry  報表改寫由Crystal Report產出
# Modify.........: No.MOD-830035 08/03/05 By Smapmin 應排除直接收款
# Modify.........: No.MOD-840068 08/04/09 By Smapmin 應排除作廢單據
# Modify.........: No.MOD-860117 08/06/16 By Sarah 應排除23.預收與24.暫收類的oma_file
# Modify.........: No.CHI-860010 08/07/04 By sherry 增加"3.出貨"選項
# Modify.........: No.MOD-860265 08/07/16 By Sarah 檢核資料應要再包含axrt201修改LC及押匯axrt210的資料
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9C0323 09/12/30 By Sarah 傳到CR的sql要串g_cr_db_str
# Modify.........: No:FUN-A10098 10/01/19 by dxfwo  跨DB處理
# Modify.........: No:TQC-A50082 10/05/20 By Carrier TQC-950121追单
# Modify.........: No.FUN-A60056 10/07/12 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No.CHI-B80020 11/08/11 By Polly 針加r351_c1判斷排除oma16 存在於 npn01 and npnconf = 'Y'
# Modify.........: No.CHI-C60007 12/07/02 By bart 增加帳款編
# Modify.........: No.CHI-C80041 12/12/24 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD
              wc         LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(1000)
              type       LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
              b_date     LIKE type_file.dat,           #No.FUN-680123 DATE
              e_date     LIKE type_file.dat,           #No.FUN-680123
              b_user     LIKE oma_file.omauser,        #No.FUN-680123 VARCHAR(10)
              e_user     LIKE oma_file.omauser,        #No.FUN-680123 VARCHAR(10)
              bookno     LIKE aaa_file.aaa01,
              more       LIKE type_file.chr1           #No.FUN-680123 VARCHAR(01)
              END RECORD,
          l_glno         LIKE apa_file.apa44,
          p_dbs          LIKE type_file.chr21          #MOD-710186 add
DEFINE   g_i             LIKE type_file.num5           #count/index for any purpose #No.FUN-680123 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000        #No.FUN-680123 VARCHAR(72)
#FUN-750115--start                                                              
   DEFINE  g_sql      STRING                                                    
   DEFINE  l_table    STRING                                                    
   DEFINE  g_str      STRING                                                    
#FUN-750115--end   
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                           # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690127
   #No.FUN-750115---Begin                                                       
   LET g_sql ="apa44.apa_file.apa44,",                                          
              "apa31.apa_file.apa31,",                                          
              "apa32.apa_file.apa32,",                                          
              "apa33.apa_file.apa33,",                                          
              "apa34.apa_file.apa34,",
            # "chr1.type_file.chr1,"   #No.TQC-A50082
              "chr1.type_file.chr1,",  #No.TQC-A50082
              "apa01.apa_file.apa01 "  #CHI-C60007
   LET l_table = cl_prt_temptable('axrr351',g_sql)CLIPPED                       
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
                                                                                
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " values(?,?,?,?,?,?,?) " #CHI-C60007
     PREPARE insert_prep FROM g_sql                                             
   IF SQLCA.sqlcode THEN                                                        
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM                         
   END IF                                                                       
   #No.FUN-750115---End  
 
   LET g_pdate  = ARG_VAL(1)
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   #-----TQC-610059---------
   LET tm.type = ARG_VAL(7)
   LET tm.b_date = ARG_VAL(8)
   LET tm.e_date = ARG_VAL(9)
   LET tm.b_user = ARG_VAL(10)
   LET tm.e_user = ARG_VAL(11)
   LET tm.bookno = ARG_VAL(12)
   #-----END TQC-610059----- 
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(13)
   LET g_rep_clas = ARG_VAL(14)
   LET g_template = ARG_VAL(15)
   LET g_rpt_name = ARG_VAL(16)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'    # If background job sw is off
      THEN CALL r351_tm(0,0)            # Input print condition
      ELSE CALL axrr351()               # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
END MAIN
 
FUNCTION r351_tm(p_row,p_col)
   DEFINE p_row,p_col   LIKE type_file.num5,          #No.FUN-680123 SMALLINT
          l_flag        LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
          l_cmd         LIKE type_file.chr1000        #No.FUN-680123 VARCHAR(1000)
   DEFINE 
   #li_chk_bookno       SMALLINT                      #No.FUN-670006
    li_chk_bookno       LIKE type_file.num5           #No.FUN-680123 SMALLINT 
   IF p_row = 0 THEN LET p_row = 4 LET p_col = 8 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
        LET p_row = 6 LET p_col = 22 
   ELSE LET p_row = 4 LET p_col =8
   END IF
 
   OPEN WINDOW r351_w AT p_row,p_col
        WITH FORM "axr/42f/axrr351" 
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.more = 'N'
   LET tm.type = '0'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
   SELECT aaz64 INTO tm.bookno FROM aaz_file WHERE aaz00='0' #no.7277
 
WHILE TRUE
   INPUT BY NAME tm.type,tm.b_date,tm.e_date,tm.b_user,tm.e_user,
                 tm.bookno,tm.more WITHOUT DEFAULTS 
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
 
      AFTER FIELD e_date 
         IF tm.e_date < tm.b_date THEN
            CALL cl_err('','agl-031',1)
            NEXT FIELD e_date
         END IF
      #no.7277
      AFTER FIELD bookno
         IF cl_null(tm.bookno) THEN NEXT FIELD bookno END IF
         #No.FUN-670006--begin
             CALL s_check_bookno(tm.bookno,g_user,g_plant) 
                  RETURNING li_chk_bookno
             IF (NOT li_chk_bookno) THEN
                  NEXT FIELD bookno
             END IF 
             #No.FUN-670006--end
         SELECT aaa02 FROM aaa_file WHERE aaa01=tm.bookno
                                      AND aaaacti IN ('Y','y')
         IF STATUS THEN 
#           CALL cl_err('sel aaa:',STATUS,0)   #No.FUN-660116
            CALL cl_err3("sel","aaa_file",tm.bookno,"",STATUS,"","sel aaa:",0)   #No.FUN-660116
            NEXT FIELD bokono 
         END IF
      #no.7277(end)
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR tm.more IS NULL
            THEN NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
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
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r351_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file       #get exec cmd (fglgo xxxx)
             WHERE zz01='axrr351'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('axrr351','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,             #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.type CLIPPED,"'",   #TQC-610059
                         " '",tm.b_date CLIPPED,"'",   #TQC-610059
                         " '",tm.e_date CLIPPED,"'",   #TQC-610059
                         " '",tm.b_user CLIPPED,"'",   #TQC-610059
                         " '",tm.e_user CLIPPED,"'",   #TQC-610059
                         " '",tm.bookno CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('axrr351',g_time,l_cmd)      # Execute cmd at later time
      END IF
      CLOSE WINDOW r351_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690127
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL axrr351()
   ERROR ""
END WHILE
   CLOSE WINDOW r351_w
END FUNCTION
 
FUNCTION axrr351()
   DEFINE
          l_name        LIKE type_file.chr20,       # External(Disk) file name #No.FUN-680123 VARCHAR(20)
#       l_time          LIKE type_file.chr8            #No.FUN-6A0095
          l_sql         LIKE type_file.chr1000,     # RDSQL STATEMENT #No.FUN-680123 VARCHAR(1000)
          l_chr         LIKE type_file.chr1,        #No.FUN-680123 VARCHAR(1)
          l_omauser     LIKE oma_file.omauser,      #No.FUN-680123 VARCHAR(10)
          l_ooauser     LIKE ooa_file.ooauser,      #No.FUN-680123 VARCHAR(10)
          l_ogauser     LIKE oga_file.ogauser,      #No.CHI-860010  
          l_conf        LIKE type_file.chr1,        #No.FUN-680123 VARCHAR(1)
          l_za05        LIKE type_file.chr1000      #No.FUN-680123 VARCHAR(40)
   DEFINE sr        RECORD 
                    glno      LIKE npp_file.nppglno,   #No.FUN-550071 #No.FUN-680123 VARCHAR(16)
                    ar_amt    LIKE type_file.num20_6,  # A/R AMT #No.FUN-680123 DEC(20,6)
                    ar_amt2   LIKE type_file.num20_6,  # A/R AMT (Unconfirmed) #No.FUN-680123 DEC(20,6)
                    ws_amt    LIKE type_file.num20_6,  # W/S AMT #No.FUN-680123 DEC(20,6)
                    gl_amt    LIKE type_file.num20_6,  # G/L AMT #No.FUN-680123 DEC(20,6)
                    apno      LIKE apa_file.apa01      #CHI-C60007
                    END RECORD
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
     IF tm.b_date IS NULL THEN LET tm.b_date = MDY(01,01,1901) END IF
     IF tm.e_date IS NULL THEN LET tm.e_date = MDY(12,31,9999) END IF
     IF tm.b_user IS NULL THEN LET tm.b_user = '          ' END IF
     IF tm.e_user IS NULL THEN LET tm.e_user = 'zzzzzzzzzz' END IF
    #MOD-710186 add
SELECT azp03 INTO p_dbs FROM ooz_file,azp_file WHERE ooz02p=azp01  LET p_dbs=s_dbstring(p_dbs CLIPPED)
    #MOD-710186 add
   
    #No.FUN-750115---Begin
    #CALL cl_outnam('axrr351') RETURNING l_name
    #START REPORT r351_rep TO l_name
     CALL cl_del_data(l_table)
    #No.FUN-750115---End
 
     #----------------------------------------------------------------------
#TQC-5A0089
     LET l_sql = 
         #"SELECT oma33,omaconf,SUM(oma56t) FROM oma_file, ooy_file ",   #MOD-840068
         "SELECT oma33,omaconf,SUM(oma56t+oma53),oma01 FROM oma_file, ooy_file ",   #MOD-840068 #CHI-C60007
         " WHERE oma02   BETWEEN '",tm.b_date,"' AND '",tm.e_date,"'",
         "   AND omauser BETWEEN '",tm.b_user,"' AND '",tm.e_user,"'",
         "   AND omavoid = 'N' ",
         "   AND oma00 != '23' AND oma00 != '24'",   #MOD-860117 add
         "   AND oma01[1,",g_doc_len,"]=ooyslip AND ooydmy1='Y' ",   
         "   AND oma01 NOT IN (SELECT oma01 FROM oma_file,npn_file WHERE oma16 = npn01 AND npnconf = 'Y') ",  #CHI-B80020 add
         " GROUP BY oma33,omaconf,oma01 " #CHI-C60007
     PREPARE r351_pr1 FROM l_sql
     DECLARE r351_c1 CURSOR FOR r351_pr1
#    DECLARE r351_c1 CURSOR FOR               #oma_file應收/待抵帳款
#        SELECT oma33,omaconf,SUM(oma56t) FROM oma_file, ooy_file
#         WHERE oma02   BETWEEN tm.b_date AND tm.e_date
#           AND omauser BETWEEN tm.b_user AND tm.e_user
#           AND omavoid = 'N'
#           AND oma01[1,3]=ooyslip AND ooydmy1='Y'   
#         GROUP BY oma33,omaconf
     #----------------------------------------------------------------------
     #-----MOD-720051---------
     LET l_sql = 
         "SELECT ola28,olaconf,SUM(ola09*ola07),ola01 FROM ola_file, ooy_file ", #CHI-C60007
         " WHERE ola02   BETWEEN '",tm.b_date,"' AND '",tm.e_date,"'",
         "   AND olauser BETWEEN '",tm.b_user,"' AND '",tm.e_user,"'",
        #"   AND olaconf != 'X' ",  #MOD-860265 mark
         "   AND olaconf = 'N' ",   #MOD-860265 排除已確認的資料
         "   AND ola01[1,",g_doc_len,"]=ooyslip AND ooydmy1='Y' ",   
         " GROUP BY ola28,olaconf,ola01 " #CHI-C60007
     PREPARE r351_pr5 FROM l_sql
     DECLARE r351_c5 CURSOR FOR r351_pr5
     #-----END MOD-720051-----
    #str MOD-860265 add
     #--LC 更改 axrt201
     LET l_sql =
         "SELECT ole14,oleconf,SUM(ole11*ole07),ole01 FROM ole_file, ooy_file ", #CHI-C60007
         " WHERE ole09   BETWEEN '",tm.b_date,"' AND '",tm.e_date,"'",
         "   AND oleuser BETWEEN '",tm.b_user,"' AND '",tm.e_user,"'",
         "   AND oleconf != 'X' ",
         "   AND ole01[1,",g_doc_len,"]=ooyslip AND ooydmy1='Y' ",
         " GROUP BY ole14,oleconf,ole01 " #CHI-C60007
     PREPARE r351_pr58 FROM l_sql
     DECLARE r351_c58 CURSOR FOR r351_pr58
     #--LC 押匯 axrt210
     LET l_sql =
         "SELECT olc23,olcconf,SUM(npq07),olc01 FROM olc_file, ooy_file,npq_file ", #CHI-C60007
         " WHERE olc12   BETWEEN '",tm.b_date,"' AND '",tm.e_date,"'",
         "   AND olcuser BETWEEN '",tm.b_user,"' AND '",tm.e_user,"'",
         "   AND olcconf != 'X' ",
         "   AND olc29[1,",g_doc_len,"]=ooyslip AND ooydmy1='Y' ",
         "   and npq01=olc29 and npq00='43' and npq06='1' ",
         "   and olc28=npq011 ",
         " GROUP BY olc23,olcconf,olc01 " #CHI-C60007
     PREPARE r351_pr59 FROM l_sql
     DECLARE r351_c59 CURSOR FOR r351_pr59
    #end MOD-860265 add
     #----------------------------------------------------------------------
     LET l_sql = 
        " SELECT ooa33,ooaconf,SUM(ooa32d),ooa01 FROM ooa_file, ooy_file ", #CHI-C60007
        "  WHERE ooa02   BETWEEN '",tm.b_date,"' AND '" ,tm.e_date,"'",
        "    AND ooauser BETWEEN '",tm.b_user,"' AND '" ,tm.e_user,"'",
        "    AND ooa01[1,",g_doc_len,"]=ooyslip AND ooydmy1='Y' ",  
        #"    AND ooaconf != 'X' ", #010804 增   #MOD-830035
        "    AND ooaconf != 'X' AND ooa00 !='2'", #010804 增    #MOD-830035
        "  GROUP BY ooa33,ooaconf,ooa01 " #CHI-C60007
     PREPARE r351_pr2 FROM l_sql
     DECLARE r351_c2 CURSOR FOR r351_pr2
#    DECLARE r351_c2 CURSOR FOR     #ooa沖帳單
#        SELECT ooa33,ooaconf,SUM(ooa32d) FROM ooa_file, ooy_file
#         WHERE ooa02   BETWEEN tm.b_date AND tm.e_date
#           AND ooauser BETWEEN tm.b_user AND tm.e_user
#           AND ooa01[1,3]=ooyslip AND ooydmy1='Y'   
#           AND ooaconf != 'X' #010804 增
#         GROUP BY ooa33,ooaconf
#END TQC-5A0089
#FUN-A60056--mark--str--
#    #No.CHI-860010---Begin
#    LET l_sql =
#        " SELECT oga907,ogaconf,SUM(oga53*oga24) FROM oga_file, oay_file ",
#        " WHERE oga02   BETWEEN '",tm.b_date,"' AND '",tm.e_date,"'" ,
#        "   AND ogauser BETWEEN '",tm.b_user,"' AND '",tm.e_user,"'" ,
#        "   AND ogaconf != 'X' AND oga09= '2' AND oga07 ='Y' ",
#        "   AND oga01[1,3] =oayslip ",
#        "   GROUP BY oga907,ogaconf "
#    PREPARE r351_pr6 FROM l_sql
#    DECLARE r351_c6 CURSOR FOR r351_pr6
#    #No.CHI-860010---End   
#FUN-A60056--mark--end
     #-----------------------------------------------------------------
    #str MOD-860265 mark
    #DECLARE r351_c3 CURSOR FOR  #No:7775(合併)
    #    #No.CHI-860010---Begin  
    #    #SELECT nppglno, omauser, ooauser, SUM(npq07)
    #    #  FROM npp_file, npq_file, OUTER oma_file, OUTER ooa_file
    #    SELECT nppglno, omauser, ooauser,ogauser,SUM(npq07)
    #      FROM npp_file, npq_file, OUTER oma_file, OUTER ooa_file, OUTER oga_file
    #    #No.CHI-860010---End   
    #     WHERE npp02 BETWEEN tm.b_date AND tm.e_date   #No:7755(將npp03改為npp02因為傳票未產生,分錄資料會抓不到)
    #       AND nppsys=npqsys AND npp00=npq00
    #       AND npp011=npq011 AND npp01=npq01
    #    #  AND npp07 = tm.bookno #no.7277              #No:7755(分錄產生,可是傳票未產生,分錄資料會抓不到)
    #      AND nppsys='AR' AND npq06='1'   
    #       AND npp_file.npp01=oma_file.oma01 AND npp_file.npp01=ooa_file.ooa01
    #       AND npp01=oga01  #No.CHI-860010  add
    #       AND ogaconf != 'X' #No.CHI-860010  add
    #       AND oma_file.omavoid='N'  #MOD-840068
    #       AND ooa_file.ooaconf!='X'  #MOD-840068
    #       AND oma_file.oma00!='23' AND oma_file.oma00!='24'   #MOD-860117 add
    #     GROUP BY nppglno,omauser,ooauser,ogauser #No.CHI-860010 add ogauser
    #end MOD-860265 mark
 
     #No:7755   
     DECLARE r351_c3_1 CURSOR FOR  #立帳分錄
         #SELECT nppglno, omauser, '', SUM(npq07)     #No.CHI-860010
         SELECT nppglno, omauser, '', '',SUM(npq07),npp01     #No.CHI-860010 #CHI-C60007
           FROM npp_file, npq_file, OUTER oma_file
          WHERE npp02  BETWEEN tm.b_date AND tm.e_date
            AND nppsys=npqsys AND npp00=npq00
            AND npp011=npq011 AND npp01=npq01
            AND npp00='2'                                 #No:7755
           AND nppsys='AR' AND npq06='1'   
            AND npp_file.npp01=oma_file.oma01 
            AND oma_file.omavoid='N'   #MOD-840068
            AND oma_file.oma00!='23' AND oma_file.oma00!='24'   #MOD-860117 add
          GROUP BY nppglno,omauser,npp01 #CHI-C60007
     #-----MOD-720051---------
     DECLARE r351_c3_1_1 CURSOR FOR  #立帳分錄
         #SELECT nppglno, olauser, '', SUM(npq07)     #No.CHI-860010
         SELECT nppglno, olauser, '', '',SUM(npq07),npp01     #No.CHI-860010 #CHI-C60007
           FROM npp_file, npq_file, OUTER ola_file
          WHERE npp02 BETWEEN tm.b_date AND tm.e_date
            AND nppsys=npqsys AND npp00=npq00
            AND npp011=npq011 AND npp01=npq01
           AND nppsys='AR' AND npq06='1'
            AND npp_file.npp01=ola_file.ola01
            AND ola_file.olaconf!='X'   #MOD-840068
          GROUP BY nppglno,olauser,npp01 #CHI-C60007
     #-----END MOD-720051-----
     DECLARE r351_c3_2 CURSOR FOR   #沖帳分錄
         #SELECT nppglno,'',ooauser, SUM(npq07)     #No.CHI-860010
         SELECT nppglno,'',ooauser,'', SUM(npq07),npp01     #No.CHI-860010 #CHI-C60007
           FROM npp_file, npq_file, OUTER ooa_file
          WHERE npp02 BETWEEN tm.b_date AND tm.e_date     #No:7755
            AND nppsys=npqsys AND npp00=npq00
            AND npp011=npq011 AND npp01=npq01
            AND npp00='3'                                 #No:7755   
           AND nppsys='AR' AND npq06='1'                 
           AND npp_file.npp01=ooa_file.ooa01
           AND ooa_file.ooaconf!='X'   #MOD-840068
          GROUP BY nppglno,ooauser,npp01 #CHI-C60007
#FUN-A60056--mark--str--
#    #No.CHI-860010---Begin
#    DECLARE r351_c3_3 CURSOR FOR
#      SELECT nppglno, '', '',ogauser,SUM(npq07)
#        FROM npp_file, npq_file, OUTER oga_file
#       WHERE npp02  BETWEEN tm.b_date AND tm.e_date
#         AND nppsys=npqsys AND npp00=npq00
#         AND npp011=npq011 AND npp01=npq01
#         AND npp00='1'
#         AND nppsys='AR'
#         AND npq06='1'
#         AND npp_file.npp01=oga_file.oga01
#         AND ogaconf !='X'
#       GROUP BY npp01,nppglno,ogauser 
#    
#    #No.CHI-860010---End
#FUN-A60056--mark--end
          
     ## 
     #----------------------------------------------------------------------
     #-----MOD-720012--------- 
     LET l_sql =
         " SELECT aba01, SUM(aba08)",
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin         
#        "  FROM ",p_dbs CLIPPED ,"aba_file ",
         "  FROM  aba_file",
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin         
         " WHERE aba02   BETWEEN '",tm.b_date,"' AND '" ,tm.e_date,"'",
         "   AND abauser BETWEEN '",tm.b_user,"' AND '" ,tm.e_user,"'",
         "   AND aba06   = 'AR' ",
         "   AND abaacti = 'Y'  ",
         "   AND aba19 <> 'X' ",  #CHI-C80041
         "   AND aba01 IN (SELECT nppglno FROM npp_file ",
         "                  WHERE nppsys=aba06 ",
         "                    AND nppglno=aba01", 
         #"                    AND (npp00='2' OR npp00='41' OR npp00='3')) ",    #No.CHI-860010      
         "                    AND (npp00='2' OR npp00='41' OR npp00='3' OR npp00='1')) ", #No.CHI-860010
         "   AND aba00= '",tm.bookno,"' ",
         "  GROUP BY aba01 "
     ##MOD-710186---mod---str---
     #LET l_sql = 
     #   " SELECT aba01, SUM(aba08)",
     #   "  FROM ",p_dbs CLIPPED ,"aba_file ",
     #   " WHERE aba02   BETWEEN '",tm.b_date,"' AND '" ,tm.e_date,"'",
     #   "   AND abauser BETWEEN '",tm.b_user,"' AND '" ,tm.e_user,"'",
     #   "   AND aba06='AR' ",  
     #   "   AND aba00= '",tm.bookno,"' ",
     #   "  GROUP BY aba01 "
     #-----END MOD-720012-----
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     PREPARE r351_pr4 FROM l_sql
     DECLARE r351_c4 CURSOR FOR r351_pr4   #傳票(合併)
 
    #DECLARE r351_c4 CURSOR FOR    #傳票(合併)
    #     SELECT aba01, SUM(aba08)   #No.MOD-530153
    #      FROM aba_file
    #     WHERE aba02   BETWEEN tm.b_date AND tm.e_date
    #       AND abauser BETWEEN tm.b_user AND tm.e_user
    #       AND aba06='AR'
    #       AND aba00= tm.bookno #no.7277
    #      GROUP BY aba01   #No.MOD-530153
    #MOD-710186---mod---end---
 
    #MOD-710186---mod---str---
    #傳票抓立帳部份資料
    LET l_sql =
        " SELECT aba01, SUM(aba08)",
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin 
#       "  FROM ",p_dbs CLIPPED ,"aba_file ",
        "  FROM aba_file",
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end        
        " WHERE aba02   BETWEEN '",tm.b_date,"' AND '" ,tm.e_date,"'",
        "   AND abauser BETWEEN '",tm.b_user,"' AND '" ,tm.e_user,"'",
        "   AND aba06   = 'AR' ",
        "   AND abaacti = 'Y'  ",
        "   AND aba19 <> 'X' ",  #CHI-C80041
        "   AND aba01 IN (SELECT nppglno FROM npp_file ",
        "                  WHERE nppsys=aba06 ",
        "                    AND nppglno=aba01", 
        "                    AND npp00='2' OR npp00='41') ",   #MOD-720051
        "   AND aba00= '",tm.bookno,"' ",
        "  GROUP BY aba01 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    PREPARE r351_pr4_1 FROM l_sql
    DECLARE r351_c4_1 CURSOR FOR r351_pr4_1  
 
    ##No:7755   
    #DECLARE r351_c4_1 CURSOR FOR  #傳票抓立帳部份資料
    #     SELECT aba01, SUM(aba08)   #No.MOD-530153
    #      #FROM aba_file, npp_file   #MOD-640582
    #      FROM aba_file   #MOD-640582
    #     WHERE aba02   BETWEEN tm.b_date AND tm.e_date
    #       AND abauser BETWEEN tm.b_user AND tm.e_user
    #       AND aba06='AR'
    #       #-----MOD-640582---------
    #       AND abaacti = 'Y'
    #       AND aba01 IN (SELECT nppglno FROM npp_file
    #                       WHERE nppsys=aba06 AND
    #                             nppglno=aba01 AND npp00='2')
    #       #AND aba06=nppsys
    #       #AND aba01=nppglno
    #       #AND npp00='2'
    #       #-----END MOD-640582-----
    #       AND aba00= tm.bookno #no.7277
    #      GROUP BY aba01   #No.MOD-530153
    #MOD-710186---mod---end---
 
    #MOD-710186---mod---str---
    #傳票抓沖帳部份資料
    LET l_sql =
        " SELECT aba01, SUM(aba08)",
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin    
#       "  FROM ",p_dbs CLIPPED ,"aba_file ",
        "  FROM aba_file",
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
        " WHERE aba02   BETWEEN '",tm.b_date,"' AND '" ,tm.e_date,"'",
        "   AND abauser BETWEEN '",tm.b_user,"' AND '" ,tm.e_user,"'",
        "   AND aba06   = 'AR' ",
        "   AND abaacti = 'Y'  ",
        "   AND aba19 <> 'X' ",  #CHI-C80041
        "   AND aba01 IN (SELECT nppglno FROM npp_file",
        "                  WHERE nppsys=aba06 ",
        "                    AND nppglno=aba01",
        "                    AND npp00='3') ",
        "   AND aba00= '",tm.bookno,"' ",
        "  GROUP BY aba01 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    PREPARE r351_pr4_2 FROM l_sql
    DECLARE r351_c4_2 CURSOR FOR r351_pr4_2  
 
    #DECLARE r351_c4_2 CURSOR FOR   #傳票抓沖帳部份資料
    #     SELECT aba01, SUM(aba08)   #No.MOD-530153
    #      #FROM aba_file, npp_file   #MOD-640582
    #      FROM aba_file   #MOD-640582
    #     WHERE aba02   BETWEEN tm.b_date AND tm.e_date
    #       AND abauser BETWEEN tm.b_user AND tm.e_user
    #       AND aba06='AR'
    #       #-----MOD-640582---------
    #       AND abaacti = 'Y'
    #       AND aba01 IN (SELECT nppglno FROM npp_file
    #                       WHERE nppsys=aba06 AND
    #                             nppglno=aba01 AND npp00='3')
    #       #AND aba06=nppsys
    #       #AND aba01=nppglno
    #       #AND npp00='3'
    #       #-----END MOD-640582-----
    #       AND aba00= tm.bookno #no.7277
    #      GROUP BY aba01   #No.MOD-530153
    ###
    ##----------------------------------------------------------------------
    #MOD-710186---mod---end---
     #--NO:3538 
     
    #No.CHI-860010---Begin
    #傳票抓出貨部份資料
    LET l_sql =
        " SELECT aba01, SUM(aba08)",
        ###GP5.2  #NO.FUN-A10098 dxfwo mark begin
#       "  FROM ",p_dbs CLIPPED ,"aba_file ",
        "  FROM aba_file",
        ###GP5.2  #NO.FUN-A10098 dxfwo mark end
        " WHERE aba02   BETWEEN '",tm.b_date,"' AND '" ,tm.e_date,"'",
        "   AND abauser BETWEEN '",tm.b_user,"' AND '" ,tm.e_user,"'",
        "   AND aba06   = 'AR' ",
        "   AND abaacti = 'Y'  ",
        "   AND aba19 <> 'X' ",  #CHI-C80041
        "   AND aba01 IN (SELECT nppglno FROM npp_file",
        "                  WHERE nppsys=aba06 ",
        "                    AND nppglno=aba01",
        "                    AND npp00='1') ",
        "   AND aba00= '",tm.bookno,"' ",
        "   GROUP BY aba01 "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    PREPARE r351_pr4_3 FROM l_sql
    DECLARE r351_c4_3 CURSOR FOR r351_pr4_3  
    #No.CHI-860010---End
     CASE 
         WHEN tm.type='1'
              FOREACH r351_c1 INTO sr.glno, l_conf, sr.ar_amt,sr.apno #CHI-C60007
                   IF l_conf='Y'
                       THEN LET sr.ar_amt2 =0
                   ELSE LET sr.ar_amt2 =sr.ar_amt
                   END IF
                   LET sr.ws_amt=0
                   LET sr.gl_amt=0
                #No.FUN-750115---Begin  
                  #OUTPUT TO REPORT r351_rep(sr.*)
                   EXECUTE insert_prep USING                                           
                           sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007
                #No.FUN-750115---End   
              END FOREACH
              #-----MOD-720051---------
              FOREACH r351_c5 INTO sr.glno, l_conf, sr.ar_amt,sr.apno #CHI-C60007
                   IF l_conf='Y'
                       THEN LET sr.ar_amt2 =0
                   ELSE LET sr.ar_amt2 =sr.ar_amt
                   END IF
                   LET sr.ws_amt=0
                   LET sr.gl_amt=0
                #No.FUN-750115---Begin                                          
                  #OUTPUT TO REPORT r351_rep(sr.*)                              
                   EXECUTE insert_prep USING                                    
                           sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007     
                #No.FUN-750115---End 
              END FOREACH
              #-----END MOD-720051-----
             #str MOD-860265 add
              FOREACH r351_c58 INTO sr.glno, l_conf, sr.ar_amt,sr.apno #CHI-C60007
                 IF l_conf='Y' THEN
                    LET sr.ar_amt2 =0
                 ELSE
                    LET sr.ar_amt2 =sr.ar_amt
                 END IF
                 LET sr.ws_amt=0
                 LET sr.gl_amt=0
                 EXECUTE insert_prep USING
                         sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007
              END FOREACH
             #end MOD-860265 add
              FOREACH r351_c3_1 INTO sr.glno, l_omauser, l_ooauser,l_ogauser,sr.ws_amt,sr.apno  #CHI-860010 add l_ogauser #CHI-C60007
                   IF (l_omauser >= tm.b_user AND l_omauser <= tm.e_user) OR
                      (l_ooauser >= tm.b_user AND l_ooauser <= tm.e_user) OR
                      (l_ogauser >= tm.b_user AND l_ogauser <= tm.e_user) #CHI-860010
                      THEN ELSE CONTINUE FOREACH
                   END IF
                   LET sr.ar_amt =0
                   LET sr.ar_amt2=0
                   LET sr.gl_amt =0
                #No.FUN-750115---Begin                                          
                  #OUTPUT TO REPORT r351_rep(sr.*)                              
                   EXECUTE insert_prep USING                                    
                           sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007     
                #No.FUN-750115---End 
              END FOREACH
              #-----MOD-720051---------
              FOREACH r351_c3_1_1 INTO sr.glno, l_omauser, l_ooauser,l_ogauser, sr.ws_amt,sr.apno  #CHI-860010 add l_ogauser #CHI-C60007
                   IF (l_omauser >= tm.b_user AND l_omauser <= tm.e_user) OR
                      (l_ooauser >= tm.b_user AND l_ooauser <= tm.e_user) OR
                      (l_ogauser >= tm.b_user AND l_ogauser <= tm.e_user) #CHI-860010
                      THEN ELSE CONTINUE FOREACH
                   END IF
                   LET sr.ar_amt =0
                   LET sr.ar_amt2=0
                   LET sr.gl_amt =0
                #No.FUN-750115---Begin                                          
                  #OUTPUT TO REPORT r351_rep(sr.*)                              
                   EXECUTE insert_prep USING                                    
                           sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007     
                #No.FUN-750115---End  
              END FOREACH
              #-----END MOD-720051-----
              FOREACH r351_c4_1 INTO sr.glno, sr.gl_amt
                   LET sr.ar_amt =0
                   LET sr.ar_amt2=0
                   LET sr.ws_amt =0
                   LET sr.apno = NULL #CHI-C60007
                 #No.FUN-750115---Begin                                          
                  #OUTPUT TO REPORT r351_rep(sr.*)                              
                   EXECUTE insert_prep USING                                    
                           sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007     
                #No.FUN-750115---End                 
               END FOREACH
         WHEN tm.type='2'
              FOREACH r351_c2 INTO sr.glno, l_conf, sr.ar_amt,sr.apno #CHI-C60007
                   IF l_conf='Y'
                      THEN LET sr.ar_amt2 =0
                   ELSE LET sr.ar_amt2 =sr.ar_amt
                   END IF
                   LET sr.ws_amt=0
                   LET sr.gl_amt=0
                #No.FUN-750115---Begin                                          
                  #OUTPUT TO REPORT r351_rep(sr.*)                              
                   EXECUTE insert_prep USING                                    
                           sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007     
                #No.FUN-750115---End 
              END FOREACH
             #str MOD-860265 add
              FOREACH r351_c59 INTO sr.glno, l_conf, sr.ar_amt,sr.apno #CHI-C60007
                 IF l_conf='Y' THEN
                    LET sr.ar_amt2 =0
                 ELSE
                    LET sr.ar_amt2 =sr.ar_amt
                 END IF
                 LET sr.ws_amt=0
                 LET sr.gl_amt=0
                 EXECUTE insert_prep USING
                         sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007
              END FOREACH
             #end MOD-860265 add
              FOREACH r351_c3_2 INTO sr.glno, l_omauser, l_ooauser,l_ogauser,sr.ws_amt,sr.apno #CHI-860010 add l_ogauser #CHI-C60007
                   IF (l_omauser >= tm.b_user AND l_omauser <= tm.e_user) OR
                      (l_ooauser >= tm.b_user AND l_ooauser <= tm.e_user) OR
                      (l_ogauser >= tm.b_user AND l_ogauser <= tm.e_user) #CHI-860010
                      THEN ELSE CONTINUE FOREACH
                   END IF
                   LET sr.ar_amt =0
                   LET sr.ar_amt2=0
                   LET sr.gl_amt =0
                #No.FUN-750115---Begin                                          
                  #OUTPUT TO REPORT r351_rep(sr.*)                              
                   EXECUTE insert_prep USING                                    
                           sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007     
                #No.FUN-750115---End 
              END FOREACH
              FOREACH r351_c4_2 INTO sr.glno, sr.gl_amt
                   LET sr.ar_amt =0
                   LET sr.ar_amt2=0
                   LET sr.ws_amt =0
                   LET sr.apno = NULL #CHI-C60007
                 #No.FUN-750115---Begin                                          
                  #OUTPUT TO REPORT r351_rep(sr.*)                              
                   EXECUTE insert_prep USING                                    
                           sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007     
                 #No.FUN-750115---End   
               END FOREACH
 
         WHEN tm.type='0'
              FOREACH r351_c1 INTO sr.glno, l_conf, sr.ar_amt,sr.apno #CHI-C60007
                   IF l_conf='Y'
                       THEN LET sr.ar_amt2 =0
                   ELSE LET sr.ar_amt2 =sr.ar_amt
                   END IF
                   LET sr.ws_amt=0
                   LET sr.gl_amt=0
                #No.FUN-750115---Begin                                          
                  #OUTPUT TO REPORT r351_rep(sr.*)                              
                   EXECUTE insert_prep USING                                    
                           sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007     
                #No.FUN-750115---End 
              END FOREACH
              #-----MOD-720051---------
              FOREACH r351_c5 INTO sr.glno, l_conf, sr.ar_amt,sr.apno #CHI-C60007
                   IF l_conf='Y'
                       THEN LET sr.ar_amt2 =0
                   ELSE LET sr.ar_amt2 =sr.ar_amt
                   END IF
                   LET sr.ws_amt=0
                   LET sr.gl_amt=0
                #No.FUN-750115---Begin                                          
                  #OUTPUT TO REPORT r351_rep(sr.*)                              
                   EXECUTE insert_prep USING                                    
                           sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007     
                #No.FUN-750115---End 
              END FOREACH
              #-----END MOD-720051-----
             #str MOD-860265 add
              FOREACH r351_c58 INTO sr.glno, l_conf, sr.ar_amt,sr.apno #CHI-C60007
                 IF l_conf='Y' THEN
                    LET sr.ar_amt2 =0
                 ELSE
                    LET sr.ar_amt2 =sr.ar_amt
                 END IF
                 LET sr.ws_amt=0
                 LET sr.gl_amt=0
                 EXECUTE insert_prep USING
                         sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007
              END FOREACH
              FOREACH r351_c59 INTO sr.glno, l_conf, sr.ar_amt,sr.apno #CHI-C60007
                 IF l_conf='Y' THEN
                    LET sr.ar_amt2 =0
                 ELSE
                    LET sr.ar_amt2 =sr.ar_amt
                 END IF
                 LET sr.ws_amt=0
                 LET sr.gl_amt=0
                 EXECUTE insert_prep USING
                         sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007
              END FOREACH
             #end MOD-860265 add
              FOREACH r351_c2 INTO sr.glno, l_conf, sr.ar_amt,sr.apno #CHI-C60007
                   IF l_conf='Y'
                      THEN LET sr.ar_amt2 =0
                   ELSE LET sr.ar_amt2 =sr.ar_amt
                   END IF
                   LET sr.ws_amt=0
                   LET sr.gl_amt=0
                #No.FUN-750115---Begin                                          
                  #OUTPUT TO REPORT r351_rep(sr.*)                              
                   EXECUTE insert_prep USING                                    
                           sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007     
                #No.FUN-750115---End 
              END FOREACH
            #FUN-A60056--mod--str--
            # #No.CHI-860010---Begin
            # FOREACH r351_c6 INTO sr.glno, l_conf, sr.ar_amt
            #      IF l_conf='Y'
            #         THEN LET sr.ar_amt2 =0
            #      ELSE LET sr.ar_amt2 =sr.ar_amt
            #      END IF
            #      LET sr.ws_amt=0
            #      LET sr.gl_amt=0
            #      EXECUTE insert_prep USING                                    
            #              sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,''     
            # END FOREACH
            # #No.CHI-860010---End
              CALL r351_oga()
            #FUN-A60056--mod--end
             #str MOD-860265 mark
             #FOREACH r351_c3 INTO sr.glno, l_omauser, l_ooauser,l_ogauser,sr.ws_amt   #No.CHI-860010 add l_ogauser
             #     IF (l_omauser >= tm.b_user AND l_omauser <= tm.e_user) OR
             #        (l_ooauser >= tm.b_user AND l_ooauser <= tm.e_user) OR
             #        (l_ogauser >= tm.b_user AND l_ogauser <= tm.e_user)  #No.CHI-860010
             #        THEN ELSE CONTINUE FOREACH
             #     END IF
             #     LET sr.ar_amt =0
             #     LET sr.ar_amt2=0
             #     LET sr.gl_amt =0
             #  #No.FUN-750115---Begin                                          
             #    #OUTPUT TO REPORT r351_rep(sr.*)                              
             #     EXECUTE insert_prep USING                                    
             #             sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,''     
             #  #No.FUN-750115---End   
             #END FOREACH
             ##-----MOD-720051---------
             #str MOD-860265 mark
             #str MOD-860265 add
              FOREACH r351_c3_1 INTO sr.glno, l_omauser, l_ooauser,l_ogauser, sr.ws_amt,sr.apno  # CHI-860010 add l_ogauser #CHI-C60007
                 IF (l_omauser >= tm.b_user AND l_omauser <= tm.e_user) OR
                    (l_ooauser >= tm.b_user AND l_ooauser <= tm.e_user) OR
                    (l_ogauser >= tm.b_user AND l_ogauser <= tm.e_user) #CHI-860010
                    THEN ELSE CONTINUE FOREACH
                 END IF
                 LET sr.ar_amt =0
                 LET sr.ar_amt2=0
                 LET sr.gl_amt =0
              #No.FUN-750115---Begin
                #OUTPUT TO REPORT r351_rep(sr.*)
                 EXECUTE insert_prep USING
                         sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007
              #No.FUN-750115---End
              END FOREACH
             #end MOD-860265 add
              FOREACH r351_c3_1_1 INTO sr.glno, l_omauser, l_ooauser,l_ogauser,sr.ws_amt,sr.apno  # CHI-860010 add l_ogauser #CHI-C60007
                   IF (l_omauser >= tm.b_user AND l_omauser <= tm.e_user) OR
                      (l_ooauser >= tm.b_user AND l_ooauser <= tm.e_user) OR
                      (l_ogauser >= tm.b_user AND l_ogauser <= tm.e_user) #CHI-860010
                      THEN ELSE CONTINUE FOREACH
                   END IF
                   LET sr.ar_amt =0
                   LET sr.ar_amt2=0
                   LET sr.gl_amt =0
                #No.FUN-750115---Begin                                          
                  #OUTPUT TO REPORT r351_rep(sr.*)                              
                   EXECUTE insert_prep USING                                    
                           sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007     
                #No.FUN-750115---End 
              END FOREACH
              #-----END MOD-720051-----
             #str MOD-860265 add
              FOREACH r351_c3_2 INTO sr.glno, l_omauser, l_ooauser, l_ogauser,sr.ws_amt,sr.apno  # CHI-860010 add l_ogauser #CHI-C60007
                 IF (l_omauser >= tm.b_user AND l_omauser <= tm.e_user) OR
                    (l_ooauser >= tm.b_user AND l_ooauser <= tm.e_user) OR
                    (l_ogauser >= tm.b_user AND l_ogauser <= tm.e_user) #CHI-860010
                    THEN ELSE CONTINUE FOREACH
                 END IF
                 LET sr.ar_amt =0
                 LET sr.ar_amt2=0
                 LET sr.gl_amt =0
              #No.FUN-750115---Begin
                #OUTPUT TO REPORT r351_rep(sr.*)
                 EXECUTE insert_prep USING
                         sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007
              #No.FUN-750115---End
              END FOREACH
             #FUN-A60056--mod--str--
             #FOREACH r351_c3_3 INTO sr.glno, l_omauser, l_ooauser,l_ogauser,sr.ws_amt  # CHI-860010 add l_ogauser
             #   IF (l_omauser >= tm.b_user AND l_omauser <= tm.e_user) OR
             #      (l_ooauser >= tm.b_user AND l_ooauser <= tm.e_user) OR
             #      (l_ogauser >= tm.b_user AND l_ogauser <= tm.e_user) #CHI-860010
             #      THEN ELSE CONTINUE FOREACH
             #   END IF
             #   LET sr.ar_amt =0
             #   LET sr.ar_amt2=0
             #   LET sr.gl_amt =0
             #   EXECUTE insert_prep USING
             #           sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,''
             #END FOREACH
              CALL r351_oga_1()
             #FUN-A60056--mod--end
             #end MOD-860265 add
              FOREACH r351_c4 INTO sr.glno,sr.gl_amt
                   LET sr.ar_amt =0
                   LET sr.ar_amt2=0
                   LET sr.ws_amt =0
                   LET sr.apno = NULL #CHI-C60007
                 #No.FUN-750115---Begin                                          
                  #OUTPUT TO REPORT r351_rep(sr.*)                              
                   EXECUTE insert_prep USING                                    
                           sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007     
                 #No.FUN-750115---End 
             END FOREACH
             #No.CHI-860010---Begin
             WHEN tm.type='3'
             #FUN-A60056--mod--str--
             #FOREACH r351_c6 INTO sr.glno, l_conf, sr.ar_amt
             #     IF l_conf='Y'
             #         THEN LET sr.ar_amt2 =0
             #     ELSE LET sr.ar_amt2 =sr.ar_amt
             #     END IF
             #     LET sr.ws_amt=0
             #     LET sr.gl_amt=0
             #     EXECUTE insert_prep USING                                    
             #             sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,''     
             #END FOREACH
              CALL r351_oga()
             #FUN-A60056--mod--end
             #FUN-A60056--mod--str--
             #FOREACH r351_c3_3 INTO sr.glno, l_omauser, l_ooauser,l_ogauser,sr.ws_amt  #CHI-860010 add l_ogauser
             #     IF (l_omauser >= tm.b_user AND l_omauser <= tm.e_user) OR
             #        (l_ooauser >= tm.b_user AND l_ooauser <= tm.e_user) OR
             #        (l_ogauser >= tm.b_user AND l_ogauser <= tm.e_user) #CHI-860010
             #        THEN ELSE CONTINUE FOREACH
             #     END IF
             #     LET sr.ar_amt =0
             #     LET sr.ar_amt2=0
             #     LET sr.gl_amt =0
             #     EXECUTE insert_prep USING                                    
             #             sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,''     
             #END FOREACH
              CALL r351_oga_1()
             #FUN-A60056--mod--end
              FOREACH r351_c4_3 INTO sr.glno, sr.gl_amt
                   LET sr.ar_amt =0
                   LET sr.ar_amt2=0
                   LET sr.ws_amt =0
                   LET sr.apno = NULL #CHI-C60007
                   EXECUTE insert_prep USING                                    
                           sr.glno,sr.ar_amt,sr.ar_amt2,sr.ws_amt,sr.gl_amt,'',sr.apno #CHI-C60007     
              END FOREACH
              #No.CHI-860010---End
     END CASE   
     #--NO:3538 
     #-----------------------------------------------------------------------
   #No.FUN-750115---Begin                                                         
   # FINISH REPORT r351_rep                                                       
                                                                                
     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED   #MOD-9C0323 mod
     LET g_str = ''                                                               
     LET g_str = tm.b_date,';',tm.e_date,';',g_azi04                              
  #  CALL cl_prt(l_name,g_prtway,g_copies,g_len)                                  
     CALL cl_prt_cs3('axrr351','axrr351',l_sql,g_str)                             
   #No.FUN-750115---End 
END FUNCTION
 
#No.FUN-750115---Begin
{
REPORT r351_rep(sr)
   DEFINE
          l_last_sw LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)
          l_dash    LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)
          cnt,i     LIKE type_file.num5,          #No.FUN-680123 smallint
          g_head1   STRING,
          l_amt1,l_amt2,l_amt3,l_amt4   LIKE type_file.num20_6   #No.FUN-680123 DEC(20,6)
   DEFINE sr        RECORD 
                    glno        LIKE npp_file.nppglno,           #No.FUN-680123 VARCHAR(16)
                    ar_amt      LIKE type_file.num20_6,          # A/R AMT #No.FUN-680123 DEC(20,6)
                    ar_amt2     LIKE type_file.num20_6,          # A/R AMT (Unconfirmed) #No.FUN-680123 DEC(20,6)
                    ws_amt      LIKE type_file.num20_6,          # W/S AMT #No.FUN-680123 DEC(20,6)
                    gl_amt      LIKE type_file.num20_6           # G/L AMT #No.FUN-680123 DEC(20,6)
                    END RECORD
 
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
   ORDER BY sr.glno
   FORMAT
    PAGE HEADER
       PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]      #No.TQC-6B0051
       LET g_pageno = g_pageno + 1
       LET pageno_total = PAGENO USING '<<<',"/pageno"
       PRINT g_head CLIPPED, pageno_total              
       PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]      #No.TQC-6B0051
       LET g_head1 =g_x[9] CLIPPED,tm.b_date,'-',tm.e_date
       #PRINT g_head1                        #FUN-660060 remark
       PRINT COLUMN (g_len-FGL_WIDTH(g_head1))/2+1, g_head1  #FUN-660060
       
       PRINT g_dash[1,g_len]
       #PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35]   #TQC-620049
       PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]   #TQC-620049
       PRINT g_dash1
       LET l_last_sw = 'n'
 
    AFTER GROUP OF sr.glno 
       LET l_amt1=GROUP SUM(sr.ar_amt)
       LET l_amt2=GROUP SUM(sr.ar_amt2)
       LET l_amt3=GROUP SUM(sr.ws_amt)
       LET l_amt4=GROUP SUM(sr.gl_amt)
       #IF l_amt1=l_amt2 AND l_amt1=l_amt3 THEN ELSE   #NO:7775
          PRINT COLUMN g_c[31],sr.glno,
                COLUMN g_c[32],cl_numfor(l_amt1,32,g_azi04),
                COLUMN g_c[33],cl_numfor(l_amt2,33,g_azi04),
                COLUMN g_c[34],cl_numfor(l_amt3,34,g_azi04);     #TQC-620049
                #COLUMN g_c[35],cl_numfor(l_amt4,35,g_azi04)      #TQC-620049
       #-----TQC-620049---------
       IF cl_numfor(l_amt1,32,g_azi04) - cl_numfor(l_amt3,34,g_azi04) <> 0 or
          cl_numfor(l_amt3,34,g_azi04) - cl_numfor(l_amt4,35,g_azi04) <> 0 THEN
          PRINT COLUMN g_c[35],cl_numfor(l_amt4,35,g_azi04),
                COLUMN g_c[36],'x'
       ELSE
          PRINT COLUMN g_c[35],cl_numfor(l_amt4,35,g_azi04)
       END IF
       #-----END TQC-620049-----
 
       #END IF
    ON LAST ROW
       PRINT g_dash[1,g_len]
       LET l_last_sw = 'y'
       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
    PAGE TRAILER
       IF l_last_sw = 'n' THEN
          PRINT g_dash[1,g_len]
          PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE
          SKIP 2 LINE
       END IF
END REPORT}
#No.FUN-750115---End 

#FUN-A60056--add--str--
FUNCTION r351_oga() 
DEFINE l_glno   LIKE npp_file.nppglno 
DEFINE l_ar_amt    LIKE type_file.num20_6 
DEFINE l_ar_amt2   LIKE type_file.num20_6
DEFINE l_ws_amt    LIKE type_file.num20_6
DEFINE l_gl_amt    LIKE type_file.num20_6 
DEFINE l_conf      LIKE type_file.chr1
DEFINE l_sql       STRING
DEFINE l_azw01     LIKE azw_file.azw01 
DEFINE l_apno   LIKE apa_file.apa01  #CHI-C60007

 LET l_sql = "SELECT azw01 FROM azw_file WHERE azwacti = 'Y'",
             "   AND azw02 = '",g_legal,"'"
 PREPARE sel_azw01_pre1 FROM l_sql
 DECLARE sel_azw01_cur1 CURSOR FOR sel_azw01_pre1
 FOREACH sel_azw01_cur1 INTO l_azw01
     LET l_sql =
         " SELECT oga907,ogaconf,SUM(oga53*oga24),oga01 ", #CHI-C60007
         "   FROM ",cl_get_target_table(l_azw01,'oga_file'),",",
         "        ",cl_get_target_table(l_azw01,'oay_file'),
         " WHERE oga02   BETWEEN '",tm.b_date,"' AND '",tm.e_date,"'" ,
         "   AND ogauser BETWEEN '",tm.b_user,"' AND '",tm.e_user,"'" ,
         "   AND ogaconf != 'X' AND oga09= '2' AND oga07 ='Y' ",
         "   AND oga01[1,3] =oayslip ",
         "   GROUP BY oga907,ogaconf,oga01 " #CHI-C60007
     PREPARE r351_pr6 FROM l_sql
     DECLARE r351_c6 CURSOR FOR r351_pr6
     FOREACH r351_c6 INTO l_glno, l_conf, l_ar_amt,l_apno #CHI-C60007
        IF l_conf='Y' THEN
           LET l_ar_amt2 =0
        ELSE
           LET l_ar_amt2 =l_ar_amt
        END IF
        LET l_ws_amt=0
        LET l_gl_amt=0
        EXECUTE insert_prep USING
            l_glno,l_ar_amt,l_ar_amt2,l_ws_amt,l_gl_amt,'',l_apno #CHI-C60007
     END FOREACH
 END FOREACH 
END FUNCTION

FUNCTION r351_oga_1()
DEFINE l_sql      STRING
DEFINE l_glno     LIKE npp_file.nppglno
DEFINE l_omauser  LIKE oma_file.omauser
DEFINE l_ooauser  LIKE ooa_file.ooauser
DEFINE l_ogauser  LIKE oga_file.ogauser
DEFINE l_ws_amt   LIKE type_file.num20_6 
DEFINE l_ar_amt   LIKE type_file.num20_6
DEFINE l_ar_amt2  LIKE type_file.num20_6
DEFINE l_gl_amt   LIKE type_file.num20_6
DEFINE l_azw01    LIKE azw_file.azw01
DEFINE l_apno   LIKE apa_file.apa01  #CHI-C60007

 LET l_sql = "SELECT azw01 FROM azw_file WHERE azwacti = 'Y'",
             "   AND azw02 = '",g_legal,"'"
 PREPARE sel_azw01_pre2 FROM l_sql
 DECLARE sel_azw01_cur2 CURSOR FOR sel_azw01_pre2
 FOREACH sel_azw01_cur2 INTO l_azw01
    LET l_sql = 
         "SELECT nppglno, '', '',ogauser,SUM(npq07),npp01", #CHI-C60007
         "  FROM npp_file, npq_file, OUTER ",cl_get_target_table(l_azw01,'oga_file'),
         " WHERE npp02  BETWEEN '",tm.b_date,"' AND '",tm.e_date,"'",
         "   AND nppsys=npqsys AND npp00=npq00",
         "   AND npp011=npq011 AND npp01=npq01",
         "   AND npp00='1' AND nppsys='AR' ",
         "   AND npq06='1' AND npp_file.npp01=oga_file.oga01",
         "   AND ogaconf !='X' ",
         " GROUP BY npp01,nppglno,ogauser "
    PREPARE r351_c3_pre3 FROM l_sql
    DECLARE r351_c3_3 CURSOR FOR r351_c3_pre3
    FOREACH r351_c3_3 INTO l_glno, l_omauser, l_ooauser,l_ogauser,l_ws_amt,l_apno #CHI-C60007 
        IF (l_omauser >= tm.b_user AND l_omauser <= tm.e_user) OR
           (l_ooauser >= tm.b_user AND l_ooauser <= tm.e_user) OR
           (l_ogauser >= tm.b_user AND l_ogauser <= tm.e_user) 
           THEN ELSE CONTINUE FOREACH
        END IF
        LET l_ar_amt =0
        LET l_ar_amt2=0
        LET l_gl_amt =0
        EXECUTE insert_prep USING
                l_glno,l_ar_amt,l_ar_amt2,l_ws_amt,l_gl_amt,'',l_apno #CHI-C60007
    END FOREACH
 END FOREACH
END FUNCTION
#FUN-A60056--add--end
