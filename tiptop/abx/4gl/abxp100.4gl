# Prog. Version..: '5.30.06-13.03.14(00010)'     #
#
# Pattern name...: abxp100.4gl
# Descriptions...: 報單資料維護作業
# Date & Author..: 96/07/30 By Danny
# Modify.........: No.MOD-560254 05/07/05 By ching fix 報單類別給值
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身比數限制
# Modify.........: No.FUN-660052 05/06/13 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6A0007 06/10/31 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6B0033 06/11/17 By hellen 新增單頭折疊功能
# Modify.........: No.CHI-680018 06/12/06 By Claire 品名規格(單位)取pmn041(ogb06)單位取pmn07(ogb05)
# Modify.........: No.MOD-840593 08/04/23 By Carol rvb08-> rvb07
# Modify.........: No.MOD-940120 09/04/14 By Smapmin 查詢條件轉換有誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A50012 10/05/12 By Summer "資料來源"增加一個選項6.入庫單
# Modify.........: No:MOD-AA0016 10/10/06 By sabrina 當單身的rva08、rva21、rva100與原始單據的值不同時，就要做update
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.MOD-D30003 13/03/11 By Elise 調整同筆單據編號若報單號碼不相同或有NULL時，提示訊息 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
      g_ac,g_sl   LIKE type_file.num5,      #No.FUN-680062 SMALLINT
      g_wc        STRING,  #No.FUN-580092 HCN    
      tm          RECORD 
                  a LIKE type_file.chr1,     #No.FUN-680062 VARCHAR(01)
                  b LIKE type_file.chr1,     # 是否僅查詢報單資料為空白者 #No.FUN-680062 VARCHAR(01)
                  c LIKE occ_file.occ01       # 客戶/廠商代號
                  END RECORD,
    g_rva         DYNAMIC ARRAY OF RECORD
                  rva01   LIKE rva_file.rva01,      #單據號碼
                  rva06   LIKE rva_file.rva06,      #單據日期
                  rva05   LIKE rva_file.rva05,      #廠商/客戶
                  rva08   LIKE rva_file.rva08,                      #No.FUN-680062 VARCHAR(20)
                  rva21   LIKE rva_file.rva21,      #報單日期
                  #FUN-6A0007...............begin
                  rva100  LIKE rva_file.rva100, #保稅異動原因代碼
                  bxr02      LIKE bxr_file.bxr02,     #保稅異動原因說明
                  #FUN-6A0007...............end
                  rvb05   LIKE rvb_file.rvb05,
                 #ima02   LIKE ima_file.ima02,      #CHI-680018 mark
                  pmn041  LIKE pmn_file.pmn041,     #CHI-680018 add
                  rvb07   LIKE rvb_file.rvb07,      #MOD-840593-modify--rvb08->rvb07
                 #ima25   LIKE ima_file.ima25       #CHI-680018 mark
                  pmn07   LIKE pmn_file.pmn07       #CHI-680018 add
                  END RECORD,
    g_rva_t       RECORD
                  rva01   LIKE rva_file.rva01,      #單據號碼
                  rva06   LIKE rva_file.rva06,      #單據日期
                  rva05   LIKE rva_file.rva05,      #廠商/客戶
                  rva08   LIKE rva_file.rva08,                      #No.FUN-680062 VARCHAR(20)
                  rva21   LIKE rva_file.rva21,      #報單日期
                  #FUN-6A0007...............begin
                  rva100  LIKE rva_file.rva100, #保稅異動原因代碼
                  bxr02      LIKE bxr_file.bxr02,     #保稅異動原因說明
                  #FUN-6A0007...............end
                  rvb05   LIKE rvb_file.rvb05,
                 #ima02   LIKE ima_file.ima02,      #CHI-680018 mark
                  pmn041  LIKE pmn_file.pmn041,     #CHI-680018 add
                  rvb07   LIKE rvb_file.rvb07,      #MOD-840593-modify--rvb08->rvb07
                 #ima25   LIKE ima_file.ima25       #CHI-680018 mark
                  pmn07   LIKE pmn_file.pmn07       #CHI-680018 add
                  END RECORD,
   #MOD-AA0016---add---start---
    g_rva_o       DYNAMIC ARRAY OF RECORD
                  rva01   LIKE rva_file.rva01,      #單據號碼
                  rva06   LIKE rva_file.rva06,      #單據日期
                  rva05   LIKE rva_file.rva05,      #廠商/客戶
                  rva08   LIKE rva_file.rva08,                     
                  rva21   LIKE rva_file.rva21,      #報單日期
                  rva100  LIKE rva_file.rva100,     #保稅異動原因代碼
                  bxr02   LIKE bxr_file.bxr02,      #保稅異動原因說明
                  rvb05   LIKE rvb_file.rvb05,
                  pmn041  LIKE pmn_file.pmn041,    
                  rvb07   LIKE rvb_file.rvb07,     
                  pmn07   LIKE pmn_file.pmn07      
                  END RECORD,
   #MOD-AA0016---add---end---
    g_oga39       LIKE oga_file.oga39,
    g_rec_b       LIKE type_file.num5,    #單身筆數        #No.FUN-680062 SMALLINT
    l_flag        LIKE type_file.chr1                      #No.FUN-680062 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10              #No.FUN-680062 INTEGER
DEFINE   buf      base.StringBuffer    #MOD-940120
DEFINE   g_rva08_flag LIKE type_file.chr1            #MOD-D30003 add
 
MAIN
   DEFINE p_row,p_col    LIKE type_file.num5               #No.FUN-680062 INTEGER
 
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
         RETURNING g_time    #No.FUN-6A0062
 
    LET p_row = 4 LET p_col = 20
 
    OPEN WINDOW abxp100_w AT p_row,p_col WITH FORM "abx/42f/abxp100" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
    CALL cl_opmsg('z')
    WHILE TRUE
        CALL p100_tm()                      #接受選擇
        CALL p100_p1()
        IF INT_FLAG THEN LET INT_FLAG = 0 CONTINUE WHILE END IF #使用者中斷
        IF cl_sure(0,0) THEN 
            CALL p100_update() 
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE 
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               EXIT WHILE
            END IF
        END IF
    END WHILE
 
    CLOSE WINDOW p100_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0062
         RETURNING g_time    #No.FUN-6A0062
END MAIN
 
FUNCTION p100_tm()
   DEFINE   l_n     LIKE type_file.num5,    #screen array no        #No.FUN-680062  SMALLINT
            l_sql   LIKE type_file.chr1000  #No.FUN-680062 VARCHAR(1000)
 
 
   IF s_shut(0) THEN
      RETURN
   END IF
   CLEAR FORM
   CALL g_rva.clear()
   INITIALIZE tm.* TO NULL
   LET tm.a = '1'
   LET tm.b = 'N'
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   CONSTRUCT BY NAME g_wc ON oga02,oga01  
     
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()   #FUN-550037(smin)
      ON ACTION exit                            #加離開功能
          LET INT_FLAG = 1
          EXIT CONSTRUCT
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup') #FUN-980030
 
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      CLOSE WINDOW p100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM 
   END IF
 
   #FUN-6A0007...............begin-
   #INPUT BY NAME tm.a,tm.b WITHOUT DEFAULTS 
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
 
   INPUT BY NAME tm.a,tm.b,tm.c WITHOUT DEFAULTS 
   #FUN-6A0007...............end
 
      #FUN-6A0007...............begin-
      BEFORE FIELD a
         CALL p100_set_entry()
      #FUN-6A0007...............end
 
      AFTER FIELD a 
         #FUN-6A0007...............begin-
         #IF cl_null(tm.a) OR tm.a NOT MATCHES '[12]' THEN
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[123456]' THEN  #CHI-A50012 add 6
         #FUN-6A0007...............end
            NEXT FIELD a 
         #FUN-6A0007...............begin-
         ELSE
            CALL p100_set_no_entry()
         #FUN-6A0007...............end
         END IF
 
      AFTER FIELD b 
         IF cl_null(tm.b) OR tm.b NOT MATCHES '[YN]' THEN 
            NEXT FIELD b 
         END IF
 
      #FUN-6A0007...............begin-
      AFTER FIELD c
         IF NOT cl_null(tm.c) THEN
            IF tm.a MATCHES '[136]' THEN  #CHI-A50012 add 6
               CALL p100_pmc('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.c,g_errno,0)
                  LET tm.c = NULL
                  DISPLAY BY NAME tm.c
                  NEXT FIELD c
               END IF
            END IF
            IF tm.a MATCHES '[25]' THEN
               CALL p100_occ('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.c,g_errno,0)
                  LET tm.c = NULL
                  DISPLAY BY NAME tm.c
                  NEXT FIELD c
               END IF
            END IF
         ELSE
            DISPLAY ' ' TO FORMONLY.display
         END IF 
 
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(c)
             IF tm.a MATCHES '[136]' THEN  #CHI-A50012 add 6
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_pmc1"
                LET g_qryparam.default1 = tm.c
                CALL cl_create_qry() RETURNING tm.c
                DISPLAY BY NAME tm.c
             END IF
             IF tm.a MATCHES '[25]' THEN
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_occ"
                LET g_qryparam.default1 = tm.c
                CALL cl_create_qry() RETURNING tm.c
                DISPLAY BY NAME tm.c
             END IF
             NEXT FIELD c
         END CASE
      #FUN-6A0007...............end
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()   #FUN-550037(smin)
      ON ACTION exit                            #加離開功能
          LET INT_FLAG = 1
          EXIT INPUT
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CLOSE WINDOW p100_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM 
   END IF
END FUNCTION 
 
#FUN-6A0007...............begin-
FUNCTION p100_set_entry()
 
   CALL cl_set_comp_entry("c",TRUE)
 
END FUNCTION
 
FUNCTION p100_set_no_entry()
 
   IF tm.a NOT MATCHES '[12356]' THEN  #CHI-A50012 add 6
      CALL cl_set_comp_entry("c",FALSE)
   END IF
 
END FUNCTION
 
FUNCTION p100_pmc(p_cmd)
DEFINE  p_cmd      LIKE type_file.chr1,
        l_pmc03    LIKE pmc_file.pmc03,
        l_pmcacti  LIKE pmc_file.pmcacti
 
   LET g_errno = ''
 
   SELECT pmc03,pmcacti
     INTO l_pmc03,l_pmcacti
     FROM pmc_file
    WHERE pmc01 = tm.c
 
   IF p_cmd = 'a' THEN
      CASE
        WHEN SQLCA.SQLCODE = 100         LET g_errno = 'mfg3014'
                                         LET l_pmc03 = NULL
        WHEN l_pmcacti != 'Y'            LET g_errno = '9028'
        OTHERWISE
             LET g_errno = SQLCA.SQLCODE USING '------'
      END CASE
   END IF
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_pmc03 TO FORMONLY.display
   END IF
END FUNCTION
 
FUNCTION p100_occ(p_cmd)
DEFINE  p_cmd      LIKE type_file.chr1,
        l_occ02    LIKE occ_file.occ02,
        l_occacti  LIKE occ_file.occacti 
 
   LET g_errno = ''
 
   SELECT occ02,occacti
     INTO l_occ02,l_occacti
     FROM occ_file
    WHERE occ01 = tm.c
 
   IF p_cmd = 'a' THEN
      CASE
        WHEN SQLCA.SQLCODE = 100        LET g_errno = 'anm-045'
                                        LET l_occ02 = NULL
        WHEN l_occacti != 'Y'           LET g_errno = '9028'
        OTHERWISE
             LET g_errno = SQLCA.SQLCODE USING '------'
      END CASE
   END IF
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      DISPLAY l_occ02 TO FORMONLY.display
   END IF
 
END FUNCTION
#FUN-6A0007...............end
 
FUNCTION p100_declare()
   DEFINE  l_i,l_j    LIKE type_file.num5,          #No.FUN-680062 SMALLINT
           l_buf      LIKE type_file.chr1000,       #No.FUN-680062 VARCHAR(300)
           l_sql      LIKE type_file.chr1000        #No.FUN-680062CHAR(500)
 
   #FUN-6A0007...............begin-
   CASE tm.a
      WHEN '1'        
      #IF tm.a = '1' THEN     #驗收單
   #FUN-6A0007...............end
         #-----MOD-940120---------
         #LET l_buf = g_wc
         #LET l_j=length(l_buf)   
         #FOR l_i=1 TO l_j 
         #    IF l_buf[l_i,l_i+4]='oga01' THEN 
         #       LET l_buf[l_i,l_i+4]='rva01' 
         #    END IF
         #    IF l_buf[l_i,l_i+4]='oga02' THEN 
         #       LET l_buf[l_i,l_i+4]='rva06' 
         #    END IF
         #END FOR
         LET buf = base.StringBuffer.create() 
         CALL buf.append(g_wc)             
         CALL buf.replace("oga01","rva01",0)    
         CALL buf.replace("oga02","rva06",0)   
         LET g_wc = buf.toString()
         #-----END MOD-940120-----
        #CHI-680018-begin
         ##FUN-6A0007...............begin-
         ##LET l_sql = " SELECT rva01,rva06,rva05,rva08,rva21,rvb05,ima02,rvb08,ima25,'' ",
         #LET l_sql = " SELECT rva01,rva06,rva05,rva08,rva21,rva100,'',rvb05,ima02,rvb08,ima25,'' ",
         ##FUN-6A0007...............end
         #            "   FROM rva_file,rvb_file,OUTER ima_file ",
#MOD-840593-modify--rvb08->rvb07
#        LET l_sql = " SELECT rva01,rva06,rva05,rva08,rva21,rva100,'',rvb05,pmn041,rvb08,pmn07,'' ",
         LET l_sql = " SELECT rva01,rva06,rva05,rva08,rva21,rva100,'',rvb05,pmn041,rvb07,pmn07,'' ",
#MOD-840593-modify-end
                     "   FROM rva_file,rvb_file,OUTER pmn_file ",
        #CHI-680018-end
                     "  WHERE rvaacti != 'N' ",
                     #FUN-6A0007...............begin-
                     #"    AND rvaconf <> 'X ",
                     "    AND rvaconf = 'Y' ",
                     #FUN-6A0007...............end
                     "    AND rva01 = rvb01 ",
                    #CHI-680018-begin
                    #"    AND ima_file.ima01 = rvb05 ",
                     "    AND pmn_file.pmn01 = rvb_file.rvb04 ",
                     "    AND pmn_file.pmn02 = rvb_file.rvb03 ",
                    #CHI-680018-end
                     "    AND ",g_wc CLIPPED 
         IF tm.b = 'Y' THEN 
            LET l_sql = l_sql CLIPPED," AND (rva08 IS NULL OR rva08 = ' ')"
         END IF 
         #FUN-6A0007...............begin-
         IF NOT cl_null(tm.c) THEN
            LET l_sql = l_sql CLIPPED," AND rva05 = '",tm.c CLIPPED,"'"
         END IF
         #FUN-6A0007...............end
         LET l_sql = l_sql CLIPPED," ORDER BY rva01,rva06 "
      #FUN-6A0007...............begin-
      #ELSE                   #出貨單
      WHEN '2'
        #CHI-680018-begin
         ##LET l_sql = " SELECT oga01,oga02,oga03,oga38,oga021,ogb04,ima02,ogb12,ima25,oga39 ",
         #LET l_sql = " SELECT oga01,oga02,oga03,oga38,oga913,oga912,'',ogb04,ima02,ogb12,ima25,oga39 ",
      ##FUN-6A0007...............end
         #           "   FROM oga_file,ogb_file,OUTER ima_file ",
         LET l_sql = " SELECT oga01,oga02,oga03,oga38,oga913,oga912,'',ogb04,ogb06,ogb12,ogb05,oga39 ",
                     "   FROM oga_file,ogb_file ",
        #CHI-680018-end
                     "  WHERE ",g_wc CLIPPED,
                     "    AND oga09 = '2' ",
                     "    AND ogaconf = 'Y' ", #01/08/20 mandy
                     "    AND ogapost = 'Y' ", #FUN-6A0007
                     "    AND oga01 = ogb01 "
                    #"    AND ima_file.ima01 = ogb04 "  #CHI-680018 mark
         IF tm.b = 'Y' THEN 
            LET l_sql = l_sql CLIPPED," AND (oga38 IS NULL OR oga38 = ' ')"
         END IF 
         #FUN-6A0007...............begin-
         IF NOT cl_null(tm.c) THEN
            LET l_sql = l_sql CLIPPED," AND oga03 ='",tm.c CLIPPED,"'"
         END IF
         #FUN-6A0007...............end
         LET l_sql = l_sql CLIPPED," ORDER BY oga01,oga02 "
      #FUN-6A0007...............begin
      #END IF
      WHEN '3'
         #-----MOD-940120---------
         #LET l_buf = g_wc
         #LET l_j=length(l_buf)   
         #FOR l_i=1 TO l_j 
         #    IF l_buf[l_i,l_i+4]='oga01' THEN 
         #       LET l_buf[l_i,l_i+4]='rvu01' 
         #    END IF
         #    IF l_buf[l_i,l_i+4]='oga02' THEN 
         #       LET l_buf[l_i,l_i+4]='rvu03' 
         #    END IF
         #END FOR
         #LET g_wc = l_buf
         LET buf = base.StringBuffer.create() 
         CALL buf.append(g_wc)             
         CALL buf.replace("oga01","rvu01",0)    
         CALL buf.replace("oga02","rvu03",0)   
         LET g_wc = buf.toString()
         #-----END MOD-940120-----
         LET l_sql = " SELECT rvu01,rvu03,rvu04,rvu101,rvu102,rvu100,'',rvv31,ima02,rvv17,ima25,'' ",
                     "   FROM rvu_file,rvv_file,OUTER ima_file ",
                     "  WHERE rvu01 = rvv01 ",
                     "    AND rvuconf = 'Y' ",
                     "    AND rvu00 = '3' ",
                     "    AND rvu08 <> 'TAP' ",
                     "    AND rvu08 <> 'TRI' ",
                     "    AND rvu08 <> 'SUB' ",
                     "    AND rvv_file.rvv31 = ima_file.ima01 ",
                     "    AND ",g_wc CLIPPED 
         IF tm.b = 'Y' THEN 
            LET l_sql = l_sql CLIPPED," AND (rvu101 IS NULL OR rvu101 = ' ')"
         END IF 
         IF NOT cl_null(tm.c) THEN
             LET l_sql = l_sql CLIPPED," AND rvu04 ='",tm.c CLIPPED,"'"
         END IF
         LET l_sql = l_sql CLIPPED," ORDER BY rvu01,rvu03 "
 
      WHEN '4'
         #-----MOD-940120---------
         #LET l_buf = g_wc
         #LET l_j=length(l_buf)   
         #FOR l_i=1 TO l_j 
         #    IF l_buf[l_i,l_i+4]='oga01' THEN 
         #       LET l_buf[l_i,l_i+4]='ina01' 
         #    END IF
         #    IF l_buf[l_i,l_i+4]='oga02' THEN 
         #       LET l_buf[l_i,l_i+4]='ina03' 
         #    END IF
         #END FOR
         #LET g_wc = l_buf
         LET buf = base.StringBuffer.create() 
         CALL buf.append(g_wc)             
         CALL buf.replace("oga01","ina01",0)    
         CALL buf.replace("oga02","ina03",0)   
         LET g_wc = buf.toString()
         #-----END MOD-940120-----
         LET l_sql = " SELECT ina01,ina03,' ',ina101,ina102,ina100,'',inb04,ima02,inb09,ima25,'' ",
                     "   FROM ina_file,inb_file,OUTER ima_file ",
                     "  WHERE ina01 = inb01 ",
                     "    AND inapost = 'Y' ",
                     "    AND inb_file.inb04 = ima_file.ima01 ",
                     "    AND ",g_wc CLIPPED 
         IF tm.b = 'Y' THEN 
            LET l_sql = l_sql CLIPPED," AND (ina101 IS NULL OR ina101 = ' ')"
         END IF 
         LET l_sql = l_sql CLIPPED," ORDER BY ina01,ina03 "
 
      WHEN '5'
         #-----MOD-940120---------
         #LET l_buf = g_wc
         #LET l_j=length(l_buf)   
         #FOR l_i=1 TO l_j 
         #    IF l_buf[l_i,l_i+4]='oga01' THEN 
         #       LET l_buf[l_i,l_i+4]='oha01' 
         #    END IF
         #    IF l_buf[l_i,l_i+4]='oga02' THEN 
         #       LET l_buf[l_i,l_i+4]='oha02' 
         #    END IF
         #END FOR
         #LET g_wc = l_buf
         LET buf = base.StringBuffer.create() 
         CALL buf.append(g_wc)             
         CALL buf.replace("oga01","oha01",0)    
         CALL buf.replace("oga02","oha02",0)   
         LET g_wc = buf.toString()
         #-----END MOD-940120-----
         LET l_sql = " SELECT oha01,oha02,oha03,oha101,oha102,oha100,'',ohb04,ima02,ohb12,ima25,'' ",
                     "   FROM oha_file,ohb_file,OUTER ima_file ",
                     "  WHERE oha01 = ohb01 ",
                     "    AND ohaconf = 'Y' ",
                     "    AND ohapost = 'Y' ",  #FUN-6A0007
                     "    AND ohb_file.ohb04 = ima_file.ima01 ",
                     "    AND ",g_wc CLIPPED 
         IF tm.b = 'Y' THEN 
            LET l_sql = l_sql CLIPPED," AND (oha101 IS NULL OR oha101 = ' ')"
         END IF 
         IF NOT cl_null(tm.c) THEN
            LET l_sql = l_sql CLIPPED," AND oha03 ='",tm.c CLIPPED,"'"
         END IF
         LET l_sql = l_sql CLIPPED," ORDER BY oha01,oha02 "
      #CHI-A50012 add --start--
      WHEN '6'
         LET buf = base.StringBuffer.create() 
         CALL buf.append(g_wc)             
         CALL buf.replace("oga01","rvu01",0)    
         CALL buf.replace("oga02","rvu03",0)   
         LET g_wc = buf.toString()
         LET l_sql = " SELECT rvu01,rvu03,rvu04,rvu101,rvu102,rvu100,'',rvv31,ima02,rvv17,ima25,'' ",
                     "   FROM rvu_file,rvv_file,OUTER ima_file ",
                     "  WHERE rvu01 = rvv01 ",
                     "    AND rvuconf = 'Y' ",
                     "    AND rvu00 = '1' ",
                     "    AND rvu08 <> 'TAP' ",
                     "    AND rvu08 <> 'TRI' ",
                     "    AND rvu08 <> 'SUB' ",
                     "    AND rvv31 = ima_file.ima01 ",
                     "    AND ",g_wc CLIPPED 
         IF tm.b = 'Y' THEN 
            LET l_sql = l_sql CLIPPED," AND (rvu101 IS NULL OR rvu101 = ' ')"
         END IF 
         IF NOT cl_null(tm.c) THEN
             LET l_sql = l_sql CLIPPED," AND rvu04 ='",tm.c CLIPPED,"'"
         END IF
         LET l_sql = l_sql CLIPPED," ORDER BY rvu01,rvu03 "
      #CHI-A50012 add --end--

  END CASE
  #FUN-6A0007...............end
      PREPARE p100_prepare FROM l_sql  
      IF SQLCA.sqlcode THEN                          #有問題了
         CALL cl_err('PREPARE:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM 
      END IF
      DECLARE p100_cs CURSOR FOR p100_prepare     #宣告之
END FUNCTION 
 
FUNCTION p100_p1()
     DEFINE l_exit     LIKE type_file.chr1                #No.FUN-680062 VARCHAR((01)
     DEFINE l_rvb05    LIKE rvb_file.rvb05  #--料號
     DEFINE l_ima02    LIKE ima_file.ima02  #--品名
     DEFINE l_ima25    LIKE ima_file.ima25  #--單位
     DEFINE l_rvb07    LIKE rvb_file.rvb07  #--數量       #MOD-840593-modify--rvb08->rvb07
     DEFINE l_show     LIKE type_file.chr1000             #No.FUN-680062 VARCHAR(75)
     DEFINE l_i        LIKE type_file.num5  #MOD-D30003 add
      CALL p100_declare()
 
      CALL g_rva.clear()
 
      LET g_cnt = 1                                     
      FOREACH p100_cs INTO g_rva[g_cnt].*,g_oga39
          IF SQLCA.sqlcode THEN                                  #有問題
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1) EXIT FOREACH
          END IF
          LET g_rva[g_cnt].rva08 = g_rva[g_cnt].rva08 CLIPPED,g_oga39
 
          #FUN-6A0007...............begin-
          IF NOT cl_null(g_rva[g_cnt].rva100) THEN
             SELECT bxr02 INTO g_rva[g_cnt].bxr02
               FROM bxr_file
              WHERE bxr01 = g_rva[g_cnt].rva100
          END IF
          #FUN-6A0007...............end
          LET g_cnt = g_cnt + 1                           #累加筆數
 
          #FUN-6A0007...............begin-
          IF g_cnt > g_max_rec THEN
             CALL cl_err('',9035,0)
             EXIT FOREACH
          END IF
          #FUN-6A0007...............end
      END FOREACH
      LET g_cnt = g_cnt - 1                               #正確的總筆數
      CALL SET_COUNT(g_cnt)                               #告之DISPALY ARRAY
      DISPLAY g_cnt TO FORMONLY.cn3                       #顯示總筆數
 
      WHILE TRUE 
        LET l_exit = 'y'
        INPUT ARRAY g_rva WITHOUT DEFAULTS FROM s_rva.*  #顯示並進行選擇
          ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,   #FUN-6A0007
                      INSERT ROW = FALSE,DELETE ROW=FALSE)
           BEFORE ROW
              LET g_ac = ARR_CURR()
              LET g_sl = SCR_LINE()
              LET g_rva_t.* = g_rva[g_ac].*  
              LET g_rva_o[g_ac].* = g_rva[g_ac].*      #MOD-AA0016 add 
 
           AFTER FIELD rva100
              IF NOT cl_null(g_rva[g_ac].rva100) THEN
                 CALL p100_bxr('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_rva[g_ac].rva100,g_errno,0)
                    LET g_rva[g_ac].rva100 = g_rva_t.rva100
                    DISPLAY BY NAME g_rva[g_ac].rva100
                    NEXT FIELD rva100
                 END IF
              ELSE
                 LET g_rva[g_ac].bxr02 = NULL
                 DISPLAY BY NAME g_rva[g_ac].bxr02
              END IF
           #FUN-6A0007...............end
 
            # IF tm.a = '1' THEN 
            #      DECLARE abxp100_curs2 SCROLL CURSOR FOR 
            #       SELECT rvb05,ima02,rvb08,ima25 
            #         FROM rva_file,OUTER(rvb_file,OUTER ima_file)
            #        WHERE rva01 = rvb_file.rvb01 AND rvb_file.rvb05 = ima_file.ima01 
            #          AND rva01 = g_rva[g_ac].rva01 AND rvaconf <> 'X'
            #      OPEN abxp100_curs2  
            #      FETCH FIRST abxp100_curs2 
            #       INTO l_rvb05,l_ima02,l_rvb08,l_ima25
            # ELSE                  
            #      DECLARE abxp100_curs3 SCROLL CURSOR FOR 
            #       SELECT ogb04,ima02,ogb12,ima25 
            #         FROM oga_file,OUTER(ogb_file,OUTER ima_file)
            #        WHERE oga01 = ogb_file.ogb01 AND ogb_file.ogb04 = ima_file.ima01 
            #          AND oga01 = g_rva[g_ac].rva01
            #          AND ogaconf = 'Y' #01/08/20 mandy
            #      OPEN abxp100_curs3  
            #      FETCH FIRST abxp100_curs3 
            #       INTO l_rvb05,l_ima02,l_rvb08,l_ima25
            # END IF 
            #      IF STATUS THEN 
            #         LET l_show = 'fetch err '
            #      ELSE 
            #         LET l_show = '料號:',l_rvb05 CLIPPED,
            #                      ' 品名:',l_ima02 CLIPPED,
            #                      ' 數量:',l_rvb08 USING '#########&.&&&',
            #                      ' 單位:', l_ima25 CLIPPED
            #      END IF 
            #      LET l_show = l_show CLIPPED 
            #      ERROR  l_show 
            # MESSAGE l_show          
            # SLEEP 1
              LET g_rva_t.* = g_rva[g_ac].*  

          #MOD-D30003 add start -----
           AFTER FIELD rva08
              LET g_rva08_flag = 'N'
              FOR l_i = 1 TO g_cnt
                 IF g_rva_t.rva01 = g_rva[l_i].rva01 THEN
                   IF g_rva[g_ac].rva08 != g_rva[l_i].rva08 OR (cl_null(g_rva[g_ac].rva08) AND NOT cl_null(g_rva[l_i].rva08))
                   OR (NOT cl_null(g_rva[g_ac].rva08) AND cl_null(g_rva[l_i].rva08)) THEN
                       IF g_rva08_flag = 'N' THEN
                          IF cl_confirm('abx-863') THEN
                             LET g_rva08_flag = 'Y'
                          ELSE
                             EXIT FOR
                          END IF
                       END IF
                       IF g_rva08_flag = 'Y' THEN
                          LET g_rva[l_i].rva08 = g_rva[g_ac].rva08
                       END IF
                   END IF
                 END IF
              END FOR
              LET g_rva_t.rva08 = g_rva[g_ac].rva08
          #MOD-D30003 add end   -----
 
           AFTER ROW
            # MESSAGE l_show
            # MESSAGE ' '
 
           #FUN-6A0007...............begin-
           ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(rva100)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_bxr"
                      LET g_qryparam.default1 = g_rva[g_ac].rva100
                      CALL cl_create_qry() RETURNING g_rva[g_ac].rva100
                      DISPLAY BY NAME g_rva[g_ac].rva100
                      NEXT FIELD rva100
 
                 OTHERWISE
                      EXIT CASE
              END CASE 
            #FUN-6A0007...............end
 
           ON ACTION CONTROLR
              CALL cl_show_req_fields()
           ON ACTION CONTROLG 
              CALL cl_cmdask()
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
        
        END INPUT
        IF INT_FLAG THEN RETURN END IF #使用者中斷
        IF l_exit = 'y' THEN EXIT WHILE END IF
      END WHILE
END FUNCTION
 
#FUN-6A0007...............begin-
FUNCTION p100_bxr(p_cmd)
DEFINE  p_cmd    LIKE type_file.chr1,
        l_bxr02  LIKE bxr_file.bxr02
 
   LET g_errno = ''
 
   SELECT bxr02 INTO l_bxr02
     FROM bxr_file
    WHERE bxr01 = g_rva[g_ac].rva100
 
   IF p_cmd = 'a' THEN
      CASE
        WHEN SQLCA.SQLCODE = 100            LET g_errno = 'abx-050'
                                            LET l_bxr02 = NULL
        OTHERWISE
             LET g_errno = SQLCA.SQLCODE USING '------'
      END CASE
   END IF
 
   IF p_cmd = 'd' OR cl_null(g_errno) THEN
      LET g_rva[g_ac].bxr02 = l_bxr02
      DISPLAY BY NAME g_rva[g_ac].bxr02
   END IF
END FUNCTION
#FUN-6A0007...............end
 
FUNCTION p100_update()
    DEFINE  l_i       LIKE type_file.num5,           #No.FUN-680062 SMALLINT
            l_oga38   LIKE oga_file.oga38,
            l_oga39   LIKE oga_file.oga39 
    DEFINE  l_n       LIKE type_file.num5  #CHI-A50012 add

    LET g_success = 'Y'
    BEGIN WORK
 #FUN-6A0007...............begin-
    #IF tm.a = '1' THEN 
 CASE tm.a
   WHEN '1'
 #FUN-6A0007...............end
       FOR l_i = 1 TO g_cnt  
           #FUN-6A0007...............begin-
           #IF cl_null(g_rva[l_i].rva08) OR cl_null(g_rva[l_i].rva21) THEN
           #MOD-AA0016---modify---start---
           #IF cl_null(g_rva[l_i].rva08) AND cl_null(g_rva[l_i].rva21) AND
           #   cl_null(g_rva[l_i].rva100) THEN
           ##FUN-6A0007...............end
           #   CONTINUE FOR 
           #END IF
            IF (g_rva[l_i].rva08 = g_rva_o[l_i].rva08) AND (g_rva[l_i].rva21 = g_rva_o[l_i].rva21) AND
               (g_rva[l_i].rva100 = g_rva_o[l_i].rva100) THEN
               CONTINUE FOR
            ELSE 
           #MOD-AA0016---modify---end---
               UPDATE rva_file SET rva08 = g_rva[l_i].rva08,
                                   #FUN-6A0007...............begin-
                                   #rva21 = g_rva[l_i].rva21
                                   rva21 = g_rva[l_i].rva21,
                                   rva100 = g_rva[l_i].rva100
                                   #FUN-6A0007...............end
                             WHERE rva01 = g_rva[l_i].rva01
            END IF   #MOD-AA0016 add
           IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN 
#             CALL cl_err('upd rva',STATUS,1)   #No.FUN-660052
              CALL cl_err3("upd","rva_file",g_rva[l_i].rva01,"",STATUS,"","upd rva",1) 
              LET g_success = 'N' 
              EXIT FOR 
           END IF

           #CHI-A50012 add --start--
           SELECT COUNT(*) INTO l_n FROM rvu_file
              WHERE rvu02 = g_rva[l_i].rva01
           IF l_n > 0 THEN  
              UPDATE rvu_file SET rvu101= g_rva[l_i].rva08,
                                  rvu102= g_rva[l_i].rva21,
                                  rvu100= g_rva[l_i].rva100
                            WHERE rvu02 = g_rva[l_i].rva01
              IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN 
                 CALL cl_err('upd rvu',SQLCA.SQLCODE,1) 
                 LET g_success = 'N' 
                 EXIT FOR 
              END IF
           END IF
           #CHI-A50012 add --end--

       END FOR 
    #FUN-6A0007...............begin-
    #ELSE
    WHEN '2'
    #FUN-6A0007...............end
       FOR l_i = 1 TO g_cnt 
           #FUN-6A0007...............begin-
           #IF cl_null(g_rva[l_i].rva08) OR cl_null(g_rva[l_i].rva21) THEN
          #MOD-AA0016---modify---start---
          #IF cl_null(g_rva[l_i].rva08) AND cl_null(g_rva[l_i].rva21) AND 
          #   cl_null(g_rva[l_i].rva100) THEN
          ##FUN-6A0007...............end
          #   CONTINUE FOR 
          #END IF
           IF (g_rva[l_i].rva08 = g_rva_o[l_i].rva08) AND (g_rva[l_i].rva21 = g_rva_o[l_i].rva21) AND
              (g_rva[l_i].rva100 = g_rva_o[l_i].rva100) THEN
              CONTINUE FOR
           ELSE 
          #MOD-AA0016---modify---end---
          #LET l_oga38 = g_rva[l_i].rva08[1,4]
          #LET l_oga39 = g_rva[l_i].rva08[5,20]
              LET l_oga38 = g_rva[l_i].rva08[1,2]  #MOD-560254
              LET l_oga39 = g_rva[l_i].rva08[3,20] #MOD-560254
 
              UPDATE oga_file SET oga38 = l_oga38,
                                  oga39 = l_oga39,
                                  #FUN-6A0007...............begin-
                                  #oga021= g_rva[l_i].rva21
                                  oga913= g_rva[l_i].rva21,
                                  oga912= g_rva[l_i].rva100
                                  #FUN-6A0007...............end
                            WHERE oga01 = g_rva[l_i].rva01
                              AND ogaconf = 'Y' #01/08/20 mandy
           END IF   #MOD-AA0016 add
           IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN 
#             CALL cl_err('upd oga',STATUS,1)   #No.FUN-660052
              CALL cl_err3("upd","oga_file",g_rva[l_i].rva21,"",STATUS,"","upd oga",1) 
              LET g_success = 'N' 
              EXIT FOR 
           END IF
       END FOR 
    #FUN-6A0007...............begin-
    #END IF
    WHEN '3' 
        FOR l_i = 1 TO g_cnt  
           #MOD-AA0016---modify---start---
           #IF cl_null(g_rva[l_i].rva08) AND cl_null(g_rva[l_i].rva21) AND
           #   cl_null(g_rva[l_i].rva100) THEN
           #   CONTINUE FOR 
           #END IF
            IF (g_rva[l_i].rva08 = g_rva_o[l_i].rva08) AND (g_rva[l_i].rva21 = g_rva_o[l_i].rva21) AND
               (g_rva[l_i].rva100 = g_rva_o[l_i].rva100) THEN
               CONTINUE FOR
            ELSE 
           #MOD-AA0016---modify---end---
               UPDATE rvu_file SET rvu101= g_rva[l_i].rva08,
                                   rvu102= g_rva[l_i].rva21,
                                   rvu100= g_rva[l_i].rva100
                             WHERE rvu01 = g_rva[l_i].rva01
            END IF    #MOD-AA0016 add
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN 
               CALL cl_err('upd rvu',SQLCA.SQLCODE,1) 
               LET g_success = 'N' 
               EXIT FOR 
            END IF
        END FOR 
      WHEN '4' 
        FOR l_i = 1 TO g_cnt  
           #MOD-AA0016---modify---start---
           #IF cl_null(g_rva[l_i].rva08) AND cl_null(g_rva[l_i].rva21) AND
           #   cl_null(g_rva[l_i].rva100) THEN
           #   CONTINUE FOR 
           #END IF
            IF (g_rva[l_i].rva08 = g_rva_o[l_i].rva08) AND (g_rva[l_i].rva21 = g_rva_o[l_i].rva21) AND
               (g_rva[l_i].rva100 = g_rva_o[l_i].rva100) THEN
               CONTINUE FOR
            ELSE 
           #MOD-AA0016---modify---end---
               UPDATE ina_file SET ina101= g_rva[l_i].rva08,
                                   ina102= g_rva[l_i].rva21,
                                   ina100= g_rva[l_i].rva100
                             WHERE ina01 = g_rva[l_i].rva01
            END IF    #MOD-AA0016 add
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN 
               CALL cl_err('upd rva',SQLCA.SQLCODE,1) 
               LET g_success = 'N' 
               EXIT FOR 
            END IF
        END FOR 
      WHEN '5' 
        FOR l_i = 1 TO g_cnt  
           #MOD-AA0016---modify---start---
           #IF cl_null(g_rva[l_i].rva08) AND cl_null(g_rva[l_i].rva21) AND
           #   cl_null(g_rva[l_i].rva100) THEN
           #   CONTINUE FOR 
           #END IF
            IF (g_rva[l_i].rva08 = g_rva_o[l_i].rva08) AND (g_rva[l_i].rva21 = g_rva_o[l_i].rva21) AND
               (g_rva[l_i].rva100 = g_rva_o[l_i].rva100) THEN
               CONTINUE FOR
            ELSE 
           #MOD-AA0016---modify---end---
               UPDATE oha_file SET oha101= g_rva[l_i].rva08,
                                   oha102= g_rva[l_i].rva21,
                                   oha100= g_rva[l_i].rva100
                             WHERE oha01 = g_rva[l_i].rva01
            END IF    #MOD-AA0016 add
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN 
               CALL cl_err('upd rva',SQLCA.SQLCODE,1) 
               LET g_success = 'N' 
               EXIT FOR 
            END IF
        END FOR 
    #CHI-A50012 add --start--
    WHEN '6' 
        FOR l_i = 1 TO g_cnt  
           #MOD-AA0016---modify---start---
           #IF cl_null(g_rva[l_i].rva08) AND cl_null(g_rva[l_i].rva21) AND
           #   cl_null(g_rva[l_i].rva100) THEN
           #   CONTINUE FOR 
           #END IF
            IF (g_rva[l_i].rva08 = g_rva_o[l_i].rva08) AND (g_rva[l_i].rva21 = g_rva_o[l_i].rva21) AND
               (g_rva[l_i].rva100 = g_rva_o[l_i].rva100) THEN
               CONTINUE FOR
            ELSE 
           #MOD-AA0016---modify---end---
               UPDATE rvu_file SET rvu101= g_rva[l_i].rva08,
                                   rvu102= g_rva[l_i].rva21,
                                   rvu100= g_rva[l_i].rva100
                             WHERE rvu01 = g_rva[l_i].rva01
            END IF    #MOD-AA0016 add
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN 
               CALL cl_err('upd rvu',SQLCA.SQLCODE,1) 
               LET g_success = 'N' 
               EXIT FOR 
            END IF
        END FOR 
    #CHI-A50012 add --end--
  END CASE
  #FUN-6A0007...............end 
END FUNCTION
