# Prog. Version..: '5.30.05-06.02.11(00001)'     #
# Pattern name...: gglq931.4gl
# Descriptions...: 应收模块月结作业
# Date & Author..: 2013/05/06 By Exia 
# Modify.........: No:140304  By yangjian  金额判断改为不等于0

DATABASE ds
GLOBALS "../../../tiptop/config/top.global"

DEFINE p_row,p_col     LIKE type_file.num5
DEFINE g_cnt           LIKE type_file.num10  
DEFINE l_ac    LIKE type_file.num5
DEFINE g_rec_b,g_rec_b2  LIKE type_file.num5
DEFINE g_wc2    STRING
DEFINE g_sql    STRING
DEFINE l_table_axrr151   STRING
DEFINE l_table_aapr150   STRING
DEFINE l_table_afar201   STRING

DEFINE tm    RECORD
          a    LIKE aaa_file.aaa01,
          yy   LIKE type_file.num5,
          mm   LIKE type_file.num5,
          b    LIKE type_file.chr1,
          c    LIKE type_file.chr1,
          d    LIKE type_file.chr1,
          wc   STRING
             END RECORD
DEFINE g_xx  DYNAMIC ARRAY OF RECORD
          km    LIKE  aag_file.aag01,
          kmm   LIKE  aag_file.aag02,
          cyye  LIKE  type_file.num20_6,
          cbye  LIKE  type_file.num20_6,
          zyye  LIKE  type_file.num20_6,
          zbye  LIKE  type_file.num20_6,
          yce   LIKE  type_file.num20_6,
          bce   LIKE  type_file.num20_6,
          bz    LIKE  tc_aag_file.tc_aag04
       END RECORD 
DEFINE g_xx_att  DYNAMIC ARRAY OF RECORD
          km    STRING,
          kmm   STRING,
          cyye  STRING,
          cbye  STRING,
          zyye  STRING,
          zbye  STRING,
          yce   STRING,
          bce   STRING,
          bz    STRING
       END RECORD 
DEFINE g_b_xx  DYNAMIC ARRAY OF RECORD
         b_km    LIKE  aag_file.aag01,
         b_kmm   LIKE  aag_file.aag02,
         b_c_s   LIKE  occ_file.occ01,
         b_c_sm  LIKE  occ_file.occ02,
         b_cyye  LIKE  type_file.num20_6,
         b_cbye  LIKE  type_file.num20_6,
         b_zyye  LIKE  type_file.num20_6,
         b_zbye  LIKE  type_file.num20_6,
         b_yce   LIKE  type_file.num20_6,
         b_bce   LIKE  type_file.num20_6,
         b_bz    LIKE  tc_aag_file.tc_aag04
       END RECORD 
DEFINE g_b_xx_att  DYNAMIC ARRAY OF RECORD
         b_km    STRING, 
         b_kmm   STRING,
         b_c_s   STRING,
         b_c_sm  STRING,
         b_cyye  STRING,
         b_cbye  STRING,
         b_zyye  STRING,
         b_zbye  STRING,
         b_yce   STRING,
         b_bce   STRING,
         b_bz    STRING 
       END RECORD 
       
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
   WHENEVER ERROR CONTINUE
  
   IF (NOT cl_setup("CGGL")) THEN
      EXIT PROGRAM
   END IF
 #读取应收系统参数，应付系统参数
   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00 = '0'
   SELECT * INTO g_apz.* FROM apz_file WHERE apz00 = '0'
   CALL cl_used(g_prog,g_time,1) RETURNING g_time    
   LET p_row = 3 LET p_col = 13
    OPEN WINDOW q931_w AT p_row,p_col WITH FORM "cggl/42f/gglq931"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    CALL cl_ui_init()
    
    CALL q931_table()
    CALL q931_menu()

    CLOSE WINDOW q931_w     
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN

FUNCTION q931_menu()
   WHILE TRUE
      CALL q931_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q931_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg" 
            CALL cl_cmdask() 
      END CASE
   END WHILE

END FUNCTION

FUNCTION q931_table()
            
   ## *** axrr151 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql = "oma00.oma_file.oma00,",  
               "oma01.oma_file.oma01," ,
               "oma02.oma_file.oma02," ,
               "oma03.oma_file.oma03," ,
               "oma032.oma_file.oma032,",
               "oma23.oma_file.oma23,"  ,
               "oma33.oma_file.oma33,"  ,
               "oma18.oma_file.oma18,"  ,
               "aag02.aag_file.aag02," ,
               "oma54t.oma_file.oma54t,",
               "oma56t.oma_file.oma56t,",
               "azi04.azi_file.azi04, ", 
               "azi05.azi_file.azi05, ", 
               "g_azi04.azi_file.azi04,",
               "g_azi05.azi_file.azi05,",
               "plant.azp_file.azp01, " ,             #FUN-8B0025 add plant 
               "npq04.npq_file.npq04 "       #No:120920  Add  <-yangjian-
   LET l_table_axrr151 = cl_prt_temptable('axrr151',g_sql) CLIPPED   # 產生Temp Table
   IF l_table_axrr151 = -1 THEN EXIT PROGRAM END IF# Temp Table產生

   ## *** aapr150 與 Crystal Reports 串聯段 - <<<< 產生Temp Table >>>> CR11 *** ##
   LET g_sql="apa02.apa_file.apa02,apa44.apa_file.apa44,apa01.apa_file.apa01,",
             "apa06.apa_file.apa06,apa07.apa_file.apa07,apa25.apa_file.apa25,",
             "apc02.apc_file.apc02,", #CHI-AB0004 add
             "apa12.apa_file.apa12,apa13.apa_file.apa13,apa34f.apa_file.apa34f,", #CHI-AB0019 add apa12
             "apa34.apa_file.apa34,apa54.apa_file.apa54,aag02.aag_file.aag02,",
             "azi03.azi_file.azi03,azi04.azi_file.azi04,azi05.azi_file.azi05"
   LET l_table_aapr150 = cl_prt_temptable('aapr150',g_sql) CLIPPED
   IF l_table_aapr150 = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql="faf02.faf_file.faf02,",                                                                                              
              "faj02.faj_file.faj02,",                                                                                              
              "faj022.faj_file.faj022,",                                                                                            
              "faj04.faj_file.faj04,",                                                                                              
              "faj05.faj_file.faj05,",                                                                                              
              "faj06.faj_file.faj06,",                                                                                              
              "faj07.faj_file.faj07,",                                                                                              
              "faj08.faj_file.faj08,",                                                                                              
              "faj19.faj_file.faj19,",                                                                                              
              "faj20.faj_file.faj20,",                                                                                              
              "faj21.faj_file.faj21,",                                                                                              
              "faj22.faj_file.faj22,",                                                                                              
              "faj27.faj_file.faj27,",                                                                                              
              "faj29.faj_file.faj29,",                                                                                              
              "faj43.faj_file.faj43,",                                                                                              
              "tmp01.faj_file.faj60,",
              "tmp02.faj_file.faj60,",
              "tmp03.faj_file.faj60,",
              "tmp04.faj_file.faj60,",
              "tmp05.faj_file.faj60,",
              "tmp06.faj_file.faj60,",
              "tmp08.faj_file.faj60",
              ",faj93.faj_file.faj93"                             #FUN-B60045   Add
 
     LET l_table_afar201 = cl_prt_temptable('afar201',g_sql) CLIPPED                                                                        
     IF l_table_afar201 -1 THEN EXIT PROGRAM END IF                                                                                        

   DROP TABLE gglq931_tmp
   CREATE TEMP TABLE gglq931_tmp(
      km    VARCHAR(24),
      kmm   VARCHAR(120),
      c_s   VARCHAR(10),
      c_sm  VARCHAR(40),
      cyye  DEC(20,6),
      cbye  DEC(20,6),
      zyye  DEC(20,6),
      zbye  DEC(20,6),
      yce   DEC(20,6),
      bce   DEC(20,6),
      bz    VARCHAR(255)
      )
   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table_axrr151 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"  
   PREPARE axrr151_insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep_axrr151:',status,1) EXIT PROGRAM
   END IF   
   
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table_aapr150 CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)" #CHI-AB0019 add ? #CHI-AB0004 add ?
   PREPARE aapr150_insert_prep FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep_aapr150:',status,1) EXIT PROGRAM
   END IF
   
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table_afar201 CLIPPED,                                                                            
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",                                                                                         
               "        ?,?,?,?,?, ?,?,?,?,?,",                                                                                         
               "        ?,?,?)"     #FUN-B60045   Add ,?
    PREPARE afar201_insert_prep FROM g_sql                                                                                                  
    IF STATUS THEN                                                                                                                  
       CALL cl_err('insert_prep_afar201',status,1) EXIT PROGRAM                                                                             
    END IF  
      
END FUNCTION 

FUNCTION q931_bp(p_ud) 
DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_xx TO  s_xx.*  ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY 
            CALL dialog.setArrayAttributes("s_xx",g_xx_att)
            CALL dialog.setArrayAttributes("s_b_xx",g_b_xx_att)
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL q931_d_fill(g_xx[l_ac].km)
            CALL cl_show_fld_cont()
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG
      END DISPLAY
      DISPLAY ARRAY g_b_xx TO  s_b_xx.*  ATTRIBUTE(COUNT=g_rec_b2)
         BEFORE DISPLAY 
            CALL dialog.setArrayAttributes("s_b_xx",g_b_xx_att)
         BEFORE ROW
            CALL cl_show_fld_cont()
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT DIALOG
      END DISPLAY

      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DIALOG
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DIALOG
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION about
         CALL cl_about()
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION q931_q()
   CALL q931_b_askkey()
END FUNCTION

FUNCTION q931_b_askkey()
   CLEAR FORM
   CALL g_xx.clear()
   CALL g_b_xx.clear()
   
   DIALOG ATTRIBUTES(UNBUFFERED)
   INPUT BY NAME tm.a,tm.yy,tm.mm,tm.b,tm.c,tm.d
      BEFORE INPUT
         LET tm.yy = YEAR(g_today)
         LET tm.mm = MONTH(g_today)
         LET tm.b = '1'
         LET tm.c = '1'
         LET tm.d = 'Y'
         LET tm.a = g_aza.aza81
         DISPLAY BY NAME tm.yy,tm.mm,tm.b,tm.c,tm.d,tm.a

      ON ACTION controlp
         CASE
            WHEN INFIELD(a)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aaa"
               LET g_qryparam.default1 = tm.a
               CALL cl_create_qry() RETURNING tm.a
               DISPLAY BY NAME tm.a
               NEXT FIELD a
            OTHERWISE EXIT CASE
         END CASE
   END INPUT
   
   CONSTRUCT tm.wc ON km FROM s_xx[1].km
      BEFORE CONSTRUCT 
         CALL cl_qbe_init()
         
       ON ACTION controlp
         CASE
            WHEN INFIELD(km)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_aag"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO km
               NEXT FIELD km
            OTHERWISE EXIT CASE
         END CASE     
   END CONSTRUCT 
         
   ON ACTION CONTROLG 
      CALL cl_cmdask()    

   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE DIALOG
      
   ON ACTION accept
      EXIT DIALOG 
      
   ON ACTION cancel
      LET INT_FLAG = 1
      EXIT DIALOG
 
   ON ACTION exit
      LET INT_FLAG = 1
      EXIT DIALOG
 
   END DIALOG

   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   CALL q931_b_fill()
END FUNCTION

FUNCTION q931_curs()
 DEFINE l_wc  STRING
 
  #-----------------1.总账本期期末金额--------------------------------
  #总账本/原币（AR/AP)  抓aed_file(ted_file[原币]/条件是年度=本年度，期别<本期+abb_file[凭证(需考虑凭证的状态)]
  #-->1.1.1总账本币金额（AR/AP)
   LET g_sql = "SELECT SUM(aed05),SUM(aed06) FROM aed_file ",
               " WHERE aed00 = '",tm.a,"' AND aed01 = ? ",
               "   AND aed03 = ",tm.yy,"  AND aed04 < ",tm.mm,
               "   AND aed011 = '1'  AND aed02 = ? "
   PREPARE q931_z_prep1 FROM g_sql
  #-->1.1.2总账原币金额（AR/AP)
   LET g_sql = "SELECT SUM(ted10),SUM(ted11) FROM ted_file ",
               " WHERE ted00 = '",tm.a,"' AND ted01 = ? ",
               "   AND ted03 = ",tm.yy,"  AND ted04 < ",tm.mm,
               "   AND ted011 = '1'  AND ted02 = ? "
   PREPARE q931_z_prep2 FROM g_sql
   #总账本/原币（非AR/AP)抓aah_file(tah_file[原币]条件是年度=本年度，期别<本期+abb_file[凭证(需考虑凭证的状态)]
  #-->1.2.1总账本币金额（非AR/AP)
   LET g_sql = "SELECT SUM(aah04),SUM(aah05)  FROM aah_file ",
               " WHERE aah00 = '",tm.a,"'  AND aah01 = ? ",
               "   AND aah02 =  ",tm.yy,"  AND aah03 < ",tm.mm
   PREPARE q931_z_prep3 FROM g_sql
  #-->1.2.2总账原币金额（非AR/AP)
   LET g_sql = "SELECT SUM(tah09),SUM(tah10)  FROM tah_file ",
               " WHERE tah00 = '",tm.a,"'  AND tah01 = ? ",
               "   AND tah02 =  ",tm.yy,"  AND tah03 < ",tm.mm
   PREPARE q931_z_prep4 FROM g_sql  
   #-->1.3.1 总账本期明细--AP/AP 借方
   LET g_sql = "SELECT SUM(abb07),SUM(abb07f) FROM abb_file,aba_file",
               " WHERE aba00=abb00 AND aba01=abb01 ",
               "   AND aba00='",tm.a,"' ", 
               "   AND aba03=",tm.yy,
               "   AND aba04=",tm.mm,
               "   AND abaacti = 'Y' ",
               "   AND abb06='1' ",
               "   AND abb03= ? ",
               "   AND abb11= ? "
   IF tm.b = '1' THEN 
   	 LET g_sql = g_sql||" AND abapost = 'Y' "
   ELSE 
      IF tm.b = '3' THEN
      	  LET g_sql = g_sql||" AND aba19 = 'Y' "
      END IF 
   END IF 
   PREPARE q931_z_prep5 FROM g_sql
   #-->1.3.2 总账本期明细--AP/AP 贷方
   LET g_sql = "SELECT SUM(abb07),SUM(abb07f) FROM abb_file,aba_file",
               " WHERE aba00=abb00 AND aba01=abb01 ",
               "   AND aba00='",tm.a,"' ", 
               "   AND aba03=",tm.yy,
               "   AND aba04=",tm.mm,
               "   AND abaacti = 'Y' ",
               "   AND abb06='2' ",
               "   AND abb03= ? ",
               "   AND abb11= ? "
   IF tm.b = '1' THEN 
   	 LET g_sql = g_sql||" AND abapost = 'Y' "
   ELSE 
      IF tm.b = '3' THEN
      	  LET g_sql = g_sql||" AND aba19 = 'Y' "
      END IF 
   END IF 
   PREPARE q931_z_prep6 FROM g_sql     
   #-->1.3.3 总账本期明细--非AP/AP 借方
   LET g_sql = "SELECT SUM(abb07),SUM(abb07f) FROM abb_file,aba_file",
               " WHERE aba00=abb00 AND aba01=abb01 ",
               "   AND aba00='",tm.a,"' ", 
               "   AND aba03=",tm.yy,
               "   AND aba04=",tm.mm,
               "   AND abaacti = 'Y' ",
               "   AND abb06='1' ",
               "   AND abb03= ? "
   IF tm.b = '1' THEN 
   	 LET g_sql = g_sql||" AND abapost = 'Y' "
   ELSE 
      IF tm.b = '3' THEN
      	  LET g_sql = g_sql||" AND aba19 = 'Y' "
      END IF 
   END IF            
   PREPARE q931_z_prep7 FROM g_sql
   #-->1.3.4 总账本期明细--非AP/AP 贷方
   LET g_sql = "SELECT SUM(abb07),SUM(abb07f) FROM abb_file,aba_file",
               " WHERE aba00=abb00 AND aba01=abb01 ",
               "   AND aba00='",tm.a,"' ", 
               "   AND aba03=",tm.yy,
               "   AND aba04=",tm.mm,
               "   AND abaacti = 'Y' ",
               "   AND abb06='2' ",
               "   AND abb03= ? "
   IF tm.b = '1' THEN 
   	 LET g_sql = g_sql||" AND abapost = 'Y' "
   ELSE 
      IF tm.b = '3' THEN
      	  LET g_sql = g_sql||" AND aba19 = 'Y' "
      END IF 
   END IF               
   PREPARE q931_z_prep8 FROM g_sql  

  #-----------------2.子系统月结金额--------------------------------
   #-->2.1 AP/AR
   LET g_sql = "SELECT SUM(npr06),SUM(npr06f),SUM(npr07),SUM(npr07f) FROM npr_file",
               " WHERE npr00 = ?  AND npr01 = ? ",
               "   AND npr04 = ",tm.yy,
               "   AND npr05 <= ",tm.mm,
               "   AND npr09 = '",tm.a,"' "
   PREPARE q931_sysMon_prep1 FROM g_sql
   LET g_sql = "SELECT SUM(npr06),SUM(npr06f),SUM(npr07),SUM(npr07f) FROM npr_file",
               " WHERE npr00 = ? ",
               "   AND npr04 = ",tm.yy,
               "   AND npr05 <= ",tm.mm,
               "   AND npr09 = '",tm.a,"' "
   PREPARE q931_sysMon_prep11 FROM g_sql
   #-->2.2 货币资金
  #LET g_sql = "SELECT SUM(nmp07),SUM(nmp08),SUM(nmp05),SUM(nmp06) FROM nmp_file,nma_file ",
   LET g_sql = "SELECT SUM(nmp09),0,SUM(nmp06),0 FROM nmp_file,nma_file ",
               " WHERE nmp02 = ",tm.yy,
               "   AND nmp03 = ",tm.mm,
               "   AND nmp01 = nma01 ",
               "   AND nma05 = ? "   
   PREPARE q931_sysMon_prep2 FROM g_sql    
  ##固资，折旧，减值从afar102报表中取        
  ##固资，折旧，减值
  ##-->2.3 固资
  #LET g_sql = "SELECT SUM(fan14),SUM(fan15),SUM(fan17) FROM fan_file",
  #            " WHERE fan11 = ?  ",
  #            "   AND fan03 = ",tm.yy,
  #            "   AND fan04 = ",tm.mm,
  #            "   AND fan05 IN('1','2') "
  #PREPARE q931_sysMon_prep3 FROM g_sql  
  ##-->2.4 折旧
  #LET g_sql = "SELECT SUM(fan15) FROM fan_file",
  #            " WHERE fan20 = ?  ",
  #            "   AND fan03 = ",tm.yy,
  #            "   AND fan04 = ",tm.mm,
  #            "   AND fan05 IN('1','2') "
  #PREPARE q931_sysMon_prep4 FROM g_sql     
  ##-->2.5 减值
  #LET g_sql = "SELECT SUM(fan17) FROM fan_file,fbz_file",
  #            " WHERE fbz17 = ?  ",
  #            "   AND fbz00 = '0' ",
  #            "   AND fan03 = ",tm.yy,
  #            "   AND fan04 = ",tm.mm,
  #            "   AND fan05 IN('1','2') "
  #PREPARE q931_sysMon_prep5 FROM g_sql                 
   #-->2.6 应收票据
   LET g_sql = "SELECT SUM(nmh32-nmh17-nmh42) FROM nmh_file",
               " WHERE nmh26 = ? ",
               "   AND nmh38 = 'Y' ",
               "   AND YEAR(nmh04) =",tm.yy,
               "   AND MONTH(nmh04) <=",tm.mm
   PREPARE q931_sysMon_prep6 FROM g_sql
   #-->2.7 应付票据
   LET g_sql = "SELECT SUM(nmd26-nmd55) FROM nmd_file ",
               " WHERE nmd23 = ? ",
               "   AND nmd30 = 'Y' ",
               "   AND YEAR(nmd07) = ",tm.yy,
               "   AND MONTH(nmd07) <=",tm.mm
   PREPARE q931_sysMon_prep7 FROM g_sql

  #-----------------3.子系统单据金额-------------------------------              
   #-->3.1 AR单据金额
     #axrr151 
   #-->3.2 AP单据金额
     #aapp150 
   
   #-->3.3 货币资金，同2.2
   #-->3.4 固资，同2.3
   #-->3.5 折旧，同2.4
   #-->3.6 减值，同2.5
   #-->3.7 应收票据，同2.6
   #-->3.8 应付票据，同2.7
   
   #抓取所有科目
   LET l_wc = cl_replace_str(tm.wc,"km","tc_aag01") 
   LET g_sql = "SELECT tc_aag01,tc_aag02,tc_aag03 FROM tc_aag_file ",
               " WHERE tc_aag00 = '",tm.a,"' AND tc_aag04 ='Y' ",
               "   AND ",l_wc CLIPPED,
               " ORDER BY tc_aag01 "
   PREPARE q931_sel_pre1 FROM g_sql
   DECLARE q931_sel_cs1 CURSOR FOR q931_sel_pre1
   
   #抓取科目对应核算项（客户，供应商）
   LET g_sql = "SELECT DISTINCT aed02 c_s FROM aed_file ",
               " WHERE aed00 = '",tm.a,"' ",
               "   AND aed01 = ? ",
               "   AND aed03 = ",tm.yy,
               "   AND aed04 < ",tm.mm,
               " UNION ",
               "SELECT DISTINCT abb11 c_s FROM abb_file,aba_file ",
               " WHERE abb00 = aba00 ",
               "   AND abb01 = aba01 ",
               "   AND aba00 = '",tm.a,"' ",
               "   AND aba03 = ",tm.yy,
               "   AND aba04 = ",tm.mm,
               "   AND abb03 = ? ",
               "   AND abaacti = 'Y' "
   CASE tm.b 
      WHEN '1'  LET g_sql = g_sql||" AND abapost = 'Y' "
      WHEN '2'
      WHEN '3'  LET g_sql = g_sql||" AND aba19 = 'Y' "
   END CASE 
   LET g_sql = g_sql||
               " UNION ",
               "SELECT DISTINCT npr01 c_s FROM npr_file ",
               " WHERE npr09 = '",tm.a,"' ",
               "   AND npr00 = ? ",
               "   AND npr04 = ",tm.yy,
               "   AND npr05 <= ",tm.mm   #add = by chentao 140221
   LET g_sql = g_sql||" ORDER BY c_s " 
   PREPARE q931_sel_pre2 FROM g_sql
   DECLARE q931_sel_cs2 CURSOR FOR q931_sel_pre2

END FUNCTION


FUNCTION q931_b_fill()
DEFINE i              LIKE type_file.num5
DEFINE l_bdate        LIKE type_file.dat
DEFINE l_edate        LIKE type_file.dat
DEFINE l_flag         LIKE type_file.chr1
DEFINE l_zbd,l_zbc,l_zyd,l_zyc,l_zdb,l_zdy,l_zcb,l_zcy  LIKE  type_file.num20_6
DEFINE l_hbzj_db,l_hbzj_cb,l_hbzj_dy,l_hbzj_cy,l_gdzc,l_zczj,l_zcjz,l_yfpj,l_yspj   LIKE type_file.num20_6
DEFINE l_yskx_db,l_yskx_dy,l_yskx_cb,l_yskx_cy,l_yfkx_db,l_yfkx_dy,l_yfkx_cb,l_yfkx_cy  LIKE type_file.num20_6
DEFINE l_ys_sysb,l_ys_sysy,l_yf_sysb,l_yf_sysy  LIKE type_file.num20_6
DEFINE l_aag06        LIKE aag_file.aag06
DEFINE l_wc           STRING
DEFINE l_tc_aag01     LIKE tc_aag_file.tc_aag01
DEFINE l_tc_aag02     LIKE tc_aag_file.tc_aag02
DEFINE l_tc_aag03     LIKE tc_aag_file.tc_aag03
DEFINE l_cs           LIKE npr_file.npr01
DEFINE l_c_s        DYNAMIC  ARRAY OF RECORD
          tc_aag01   LIKE tc_aag_file.tc_aag01,
          tc_aag02   LIKE tc_aag_file.tc_aag02,
          c_s        LIKE occ_file.occ01,
          tc_aag03   LIKE tc_aag_file.tc_aag03
               END RECORD
DEFINE l_xx  RECORD
         km    LIKE  aag_file.aag01,
         kmm   LIKE  aag_file.aag02,
         c_s   LIKE  occ_file.occ01,
         c_sm  LIKE  occ_file.occ02,
         cyye  LIKE  type_file.num20_6,
         cbye  LIKE  type_file.num20_6,
         zyye  LIKE  type_file.num20_6,
         zbye  LIKE  type_file.num20_6,
         yce   LIKE  type_file.num20_6,
         bce   LIKE  type_file.num20_6,
         bz    LIKE  tc_aag_file.tc_aag04
       END RECORD    
DEFINE l_aag15 LIKE  aag_file.aag15
DEFINE l_cnt   LIKE  type_file.num5

   IF cl_null(tm.yy) OR cl_null(tm.mm) THEN
      RETURN
   END IF
   
   CALL s_azm(tm.yy,tm.mm) RETURNING l_flag,l_bdate,l_edate
   IF l_flag = '1' THEN
      CALL cl_err('检查aoos020期别设置',"!",1)
      RETURN 
   END IF 

   IF tm.d ='N' THEN
      CALL cl_set_comp_visible("cyye,zyye,yce,b_cyye,b_zyye,b_yce",FALSE)
   ELSE
      CALL cl_set_comp_visible("cyye,zyye,yce,b_cyye,b_zyye,b_yce",TRUE)
   END IF 

   CALL g_xx.clear()

   CALL q931_curs()
   DELETE FROM gglq931_tmp WHERE 1=1
   FOREACH q931_sel_cs1 INTO l_tc_aag01,l_tc_aag02,l_tc_aag03
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF 
      
      IF l_tc_aag02 MATCHES '[78]' THEN 
         FOREACH q931_sel_cs2 USING l_tc_aag01,l_tc_aag01,l_tc_aag01 INTO l_cs
            CALL l_c_s.appendElement()
            LET l_c_s[l_c_s.getLength()].tc_aag01 = l_tc_aag01
            LET l_c_s[l_c_s.getLength()].tc_aag02 = l_tc_aag02
            LET l_c_s[l_c_s.getLength()].c_s = l_cs
            LET l_c_s[l_c_s.getLength()].tc_aag03 = l_tc_aag03
         END FOREACH 

        #添加一个判断，78类型的总账也可能不做核算项，这里核算项给个'*'星号
        #下面抓数据时，碰到这种核算项直接抓aah,tah统计档
         LET l_aag15 = NULL
         SELECT aag15 INTO l_aag15 FROM aag_file WHERE aag01 = l_tc_aag01
            AND aag00 = tm.a
        #SELECT COUNT(*) INTO l_cnt FROM aag_file WHERE aag01 = l_tc_aag01
        #   AND aag00 = tm.a
        #   AND (aag15 IS NULL AND aag16 IS NULL AND aag17 IS NULL AND aag18 IS NULL
        #       AND aag32 IS NULL AND aag33 IS NULL AND aag34 IS NULL AND aag37 IS NULL)
        #IF l_cnt > 0 THEN 
         IF l_aag15 IS NULL THEN 
            CALL l_c_s.appendElement()
            LET l_c_s[l_c_s.getLength()].tc_aag01 = l_tc_aag01
            LET l_c_s[l_c_s.getLength()].tc_aag02 = l_tc_aag02
            LET l_c_s[l_c_s.getLength()].c_s = 'XXX'
            LET l_c_s[l_c_s.getLength()].tc_aag03 = l_tc_aag03
         END IF 
      ELSE 
         CALL l_c_s.appendElement()
         LET l_c_s[l_c_s.getLength()].tc_aag01 = l_tc_aag01
         LET l_c_s[l_c_s.getLength()].tc_aag02 = l_tc_aag02
         LET l_c_s[l_c_s.getLength()].c_s = NULL
         LET l_c_s[l_c_s.getLength()].tc_aag03 = l_tc_aag03
      END IF 
   END FOREACH
   
   FOR i =1 TO l_c_s.getLength()
       #金额清0
       LET l_zbd=0   LET l_zbc=0   LET l_zyd=0    LET l_zyc=0
       LET l_zdb=0   LET l_zdy=0   LET l_zcb=0    LET l_zcy=0
       LET l_hbzj_db=0   LET l_hbzj_cb=0   LET l_hbzj_dy=0   LET l_hbzj_cy=0
       LET l_gdzc=0    LET l_zczj=0   LET l_zcjz=0   LET l_yfpj=0   LET l_yspj=0
       LET l_yskx_db=0   LET l_yskx_dy=0   LET l_yskx_cb=0   LET l_yskx_cy=0
       LET l_yfkx_db=0   LET l_yfkx_dy=0   LET l_yfkx_cb=0   LET l_yfkx_cy=0
       LET l_ys_sysb=0   LET l_ys_sysy=0   LET l_yf_sysb=0   LET l_yf_sysy=0
       #1.抓总账金额
       IF l_c_s[i].tc_aag02 MATCHES '[78]' THEN 
          IF l_c_s[i].c_s = 'XXX' THEN 
       	     EXECUTE q931_z_prep3 USING l_c_s[i].tc_aag01 INTO l_zbd,l_zbc
       	     EXECUTE q931_z_prep4 USING l_c_s[i].tc_aag01 INTO l_zyd,l_zyc
       	     EXECUTE q931_z_prep7 USING l_c_s[i].tc_aag01 INTO l_zdb,l_zdy
       	     EXECUTE q931_z_prep8 USING l_c_s[i].tc_aag01 INTO l_zcb,l_zcy       
          ELSE 
       	     EXECUTE q931_z_prep1 USING l_c_s[i].tc_aag01,l_c_s[i].c_s INTO l_zbd,l_zbc
       	     EXECUTE q931_z_prep2 USING l_c_s[i].tc_aag01,l_c_s[i].c_s INTO l_zyd,l_zyc
       	     EXECUTE q931_z_prep5 USING l_c_s[i].tc_aag01,l_c_s[i].c_s INTO l_zdb,l_zdy
       	     EXECUTE q931_z_prep6 USING l_c_s[i].tc_aag01,l_c_s[i].c_s INTO l_zcb,l_zcy
          END IF 
       END IF
       IF l_c_s[i].tc_aag02 MATCHES '[123456]' THEN 
       	  EXECUTE q931_z_prep3 USING l_c_s[i].tc_aag01 INTO l_zbd,l_zbc
       	  EXECUTE q931_z_prep4 USING l_c_s[i].tc_aag01 INTO l_zyd,l_zyc
       	  EXECUTE q931_z_prep7 USING l_c_s[i].tc_aag01 INTO l_zdb,l_zdy
       	  EXECUTE q931_z_prep8 USING l_c_s[i].tc_aag01 INTO l_zcb,l_zcy       
       END IF 
       #固资，减值，折旧不区分原币，本币，全部抓本币金额
       IF l_c_s[i].tc_aag02 MATCHES '[234]' THEN 
          LET l_zyd = l_zbd
          LET l_zyc = l_zbc
          LET l_zdy = l_zdb
          LET l_zcy = l_zcb
       END IF 
       #2.抓子系统数据
       CASE tm.c
          WHEN '1'    #子系统月结
             CASE l_c_s[i].tc_aag02 
                WHEN '1'  #货币资金
                   EXECUTE q931_sysMon_prep2 USING l_c_s[i].tc_aag01 INTO l_hbzj_db,l_hbzj_cb,l_hbzj_dy,l_hbzj_cy
                WHEN '2'  #固定资产
                  #EXECUTE q931_sysMon_prep3 USING l_c_s[i].tc_aag01 INTO l_gdzc
                   CALL afar201(l_c_s[i].tc_aag01,'2') RETURNING l_gdzc
                WHEN '3'  #资产折旧
                  #EXECUTE q931_sysMon_prep4 USING l_c_s[i].tc_aag01 INTO l_zczj    
                   CALL afar201(l_c_s[i].tc_aag01,'3') RETURNING l_zczj
                WHEN '4'  #资产减值
                  #EXECUTE q931_sysMon_prep5 USING l_c_s[i].tc_aag01 INTO l_zcjz 
                   CALL afar201(l_c_s[i].tc_aag01,'4') RETURNING l_zcjz
                WHEN '5'  #应付票据
                   EXECUTE q931_sysMon_prep7 USING l_c_s[i].tc_aag01 INTO l_yfpj
                WHEN '6'  #应收票据
                   EXECUTE q931_sysMon_prep6 USING l_c_s[i].tc_aag01 INTO l_yspj
                WHEN '7'  #应收款项
                   IF l_c_s[i].c_s = 'XXX' THEN
                     #EXECUTE q931_sysMon_prep11 USING l_c_s[i].tc_aag01 INTO l_yskx_db,l_yskx_dy,l_yskx_cb,l_yskx_cy  #No:131101  Mark 
                      LET l_yskx_db = 0
                      LET l_yskx_dy = 0
                      LET l_yskx_cb = 0
                      LET l_yskx_cy = 0
                   ELSE
                      EXECUTE q931_sysMon_prep1 USING l_c_s[i].tc_aag01,l_c_s[i].c_s INTO l_yskx_db,l_yskx_dy,l_yskx_cb,l_yskx_cy
                   END IF 
                WHEN '8'  #应付款项
                   IF l_c_s[i].c_s = 'XXX' THEN
                     #EXECUTE q931_sysMon_prep11 USING l_c_s[i].tc_aag01 INTO l_yfkx_db,l_yfkx_dy,l_yfkx_cb,l_yfkx_cy
                      LET l_yfkx_db = 0
                      LET l_yfkx_dy = 0
                      LET l_yfkx_cb = 0
                      LET l_yfkx_cy = 0
                   ELSE
                      EXECUTE q931_sysMon_prep1 USING l_c_s[i].tc_aag01,l_c_s[i].c_s INTO l_yfkx_db,l_yfkx_dy,l_yfkx_cb,l_yfkx_cy
                   END IF 
             END CASE 
          WHEN '2'    #子系统单据
             CASE l_c_s[i].tc_aag02              
                WHEN '1'  #货币资金
                   EXECUTE q931_sysMon_prep2 USING l_c_s[i].tc_aag01 INTO l_hbzj_db,l_hbzj_cb,l_hbzj_dy,l_hbzj_cy
                WHEN '2'  #固定资产
                  #EXECUTE q931_sysMon_prep3 USING l_c_s[i].tc_aag01 INTO l_gdzc
                   CALL afar201(l_c_s[i].tc_aag01,'2') RETURNING l_gdzc
                WHEN '3'  #资产折旧
                  #EXECUTE q931_sysMon_prep4 USING l_c_s[i].tc_aag01 INTO l_zczj    
                   CALL afar201(l_c_s[i].tc_aag01,'3') RETURNING l_zczj
                WHEN '4'  #资产减值
                  #EXECUTE q931_sysMon_prep5 USING l_c_s[i].tc_aag01 INTO l_zcjz 
                   CALL afar201(l_c_s[i].tc_aag01,'4') RETURNING l_zcjz
                WHEN '5'  #应付票据
                   EXECUTE q931_sysMon_prep7 USING l_c_s[i].tc_aag01 INTO l_yfpj
                WHEN '6'  #应收票据
                   EXECUTE q931_sysMon_prep6 USING l_c_s[i].tc_aag01 INTO l_yspj
                WHEN '7'  #应收款项
                   CALL axrr151(l_c_s[i].tc_aag01,l_c_s[i].c_s) RETURNING l_ys_sysb,l_ys_sysy
                WHEN '8'  #应付款项
                   CALL aapr150(l_c_s[i].tc_aag01,l_c_s[i].c_s) RETURNING l_yf_sysb,l_yf_sysy
             END CASE 
       END CASE 
       IF cl_null(l_zbd) THEN LET l_zbd = 0 END IF 
       IF cl_null(l_zbc) THEN LET l_zbc = 0 END IF 
       IF cl_null(l_zyd) THEN LET l_zyd = 0 END IF 
       IF cl_null(l_zyc) THEN LET l_zyc = 0 END IF 
       IF cl_null(l_zdb) THEN LET l_zdb = 0 END IF 
       IF cl_null(l_zdy) THEN LET l_zdy = 0 END IF 
       IF cl_null(l_zcb) THEN LET l_zcb = 0 END IF 
       IF cl_null(l_zcy) THEN LET l_zcy = 0 END IF 
       IF cl_null(l_hbzj_db) THEN LET l_hbzj_db = 0 END IF 
       IF cl_null(l_hbzj_cb) THEN LET l_hbzj_cb = 0 END IF 
       IF cl_null(l_hbzj_dy) THEN LET l_hbzj_dy = 0 END IF
       IF cl_null(l_hbzj_cy) THEN LET l_hbzj_cy = 0 END IF
       IF cl_null(l_gdzc) THEN LET l_gdzc = 0 END IF
       IF cl_null(l_zczj) THEN LET l_zczj = 0 END IF
       IF cl_null(l_zcjz) THEN LET l_zcjz = 0 END IF
       IF cl_null(l_yfpj) THEN LET l_yfpj = 0 END IF
       IF cl_null(l_yspj) THEN LET l_yspj = 0 END IF
       IF cl_null(l_yskx_db) THEN LET l_yskx_db = 0 END IF
       IF cl_null(l_yskx_dy) THEN LET l_yskx_dy = 0 END IF
       IF cl_null(l_yskx_cb) THEN LET l_yskx_cb = 0 END IF
       IF cl_null(l_yskx_cy) THEN LET l_yskx_cy = 0 END IF
       IF cl_null(l_yfkx_db) THEN LET l_yfkx_db = 0 END IF
       IF cl_null(l_yfkx_dy) THEN LET l_yfkx_dy = 0 END IF
       IF cl_null(l_yfkx_cb) THEN LET l_yfkx_cb = 0 END IF
       IF cl_null(l_yfkx_cy) THEN LET l_yfkx_cy = 0 END IF   
       IF cl_null(l_ys_sysb) THEN LET l_ys_sysb = 0 END IF 
       IF cl_null(l_ys_sysy) THEN LET l_ys_sysy = 0 END IF   
       IF cl_null(l_yf_sysb) THEN LET l_yf_sysb = 0 END IF 
       IF cl_null(l_yf_sysy) THEN LET l_yf_sysy = 0 END IF    
       SELECT aag02,aag06 INTO l_xx.kmm,l_aag06 FROM aag_file WHERE aag01 = l_c_s[i].tc_aag01
          AND aag00 = tm.a
       IF l_aag06 = '1' THEN
          LET l_ys_sysy = l_ys_sysy
          LET l_ys_sysb = l_ys_sysb
          LET l_yf_sysy = l_yf_sysy*-1
          LET l_yf_sysb = l_yf_sysb*-1
          LET l_xx.cyye = l_hbzj_dy - l_hbzj_cy + l_gdzc + l_zczj + l_zcjz + l_yfpj + l_yspj +
                                 l_yskx_dy - l_yskx_cy + l_yfkx_dy - l_yfkx_cy+
                                 l_ys_sysy + l_yf_sysy
          LET l_xx.cbye = l_hbzj_db - l_hbzj_cb + l_gdzc + l_zczj + l_zcjz + l_yfpj + l_yspj +
                                 l_yskx_db - l_yskx_cb + l_yfkx_db - l_yfkx_cb+
                                 l_ys_sysb + l_yf_sysb
          LET l_xx.zyye = l_zyd - l_zyc + l_zdy - l_zcy
          LET l_xx.zbye = l_zbd - l_zbc + l_zdb - l_zcb  
       ELSE
          LET l_ys_sysy = l_ys_sysy*-1
          LET l_ys_sysb = l_ys_sysb*-1
          LET l_yf_sysy = l_yf_sysy
          LET l_yf_sysb = l_yf_sysb
          LET l_xx.cyye = l_hbzj_cy - l_hbzj_dy + l_gdzc + l_zczj + l_zcjz + l_yfpj + l_yspj +
                                 l_yskx_cy - l_yskx_dy + l_yfkx_cy - l_yfkx_dy+
                                 l_ys_sysy + l_yf_sysy
          LET l_xx.cbye = l_hbzj_cb - l_hbzj_db + l_gdzc + l_zczj + l_zcjz + l_yfpj + l_yspj +
                                 l_yskx_cb - l_yskx_db + l_yfkx_cb - l_yfkx_db+
                                 l_ys_sysb + l_yf_sysb
          LET l_xx.zyye = l_zyc - l_zyd + l_zcy - l_zdy
          LET l_xx.zbye = l_zbc - l_zbd + l_zcb - l_zdb   
       END IF 
       LET l_xx.yce = l_xx.cyye - l_xx.zyye 
       LET l_xx.bce = l_xx.cbye - l_xx.zbye 
       LET l_xx.km = l_c_s[i].tc_aag01
       LET l_xx.c_s = l_c_s[i].c_s
       #c_sm抓客户名，供应商名称
       SELECT occ02 INTO l_xx.c_sm FROM occ_file WHERE occ01 = l_xx.c_s
       IF SQLCA.sqlcode = 100 THEN
       	  SELECT pmc03 INTO l_xx.c_sm FROM pmc_file WHERE pmc01 = l_xx.c_s
          IF SQLCA.sqlcode = 100 THEN
             LET l_xx.c_sm = ''
          END IF 
       END IF 
       LET l_xx.bz = l_c_s[i].tc_aag03
       INSERT INTO gglq931_tmp VALUES (l_xx.*)
   END FOR

   LET g_cnt = 1 
   LET g_sql = "SELECT km,kmm,SUM(cyye),SUM(cbye),SUM(zyye),SUM(zbye),SUM(yce),SUM(bce),bz ",
               "  FROM gglq931_tmp",
               " WHERE 1=1 ",
               " GROUP BY km,kmm,bz ",
               " ORDER BY km,kmm "
   PREPARE q931_bfill_prep FROM g_sql
   DECLARE q931_bfill_cs CURSOR FOR q931_bfill_prep
   FOREACH q931_bfill_cs INTO g_xx[g_cnt].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF 
      
      LET g_cnt = g_cnt + 1 
   END FOREACH
   CALL g_xx.deleteElement(g_cnt)
   LET g_rec_b = g_cnt - 1
   DISPLAY g_rec_b TO FORMONLY.cn2 
   LET g_cnt = 0     
   CALL q931_batt()
END FUNCTION

FUNCTION q931_d_fill(p_km) 
 DEFINE  p_km  LIKE  aag_file.aag01
 
   CALL g_b_xx.clear()
   LET g_cnt = 1 
   LET g_sql = "SELECT km,kmm,c_s,c_sm,cyye,cbye,zyye,zbye,yce,bce,bz ",
               "  FROM gglq931_tmp",
               " WHERE km = '",p_km,"' ",
               "   AND NOT (cyye =0  AND cbye =0 AND zyye =0 AND zbye =0) ",
               " ORDER BY km,kmm,c_s,c_sm "
   PREPARE q931_dfill_prep FROM g_sql
   DECLARE q931_dfill_cs CURSOR FOR q931_dfill_prep
   FOREACH q931_dfill_cs INTO g_b_xx[g_cnt].*
      IF SQLCA.sqlcode THEN EXIT FOREACH END IF 
      	
      LET g_cnt = g_cnt + 1 
   END FOREACH
   CALL g_b_xx.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt - 1
   DISPLAY g_rec_b2 TO FORMONLY.cn3 
   LET g_cnt = 0   
   CALL q931_datt()

END FUNCTION

FUNCTION axrr151(p_km,p_cs)
DEFINE p_km       LIKE aag_file.aag01
DEFINE p_cs       LIKE occ_file.occ01
DEFINE l_name     LIKE type_file.chr20   # External(Disk) file name #No.FUN-680123 VARCHAR(20) 
DEFINE l_sql      STRING                 # RDSQL STATEMENT #No.FUN-680123 CHAR(1200) #MOD-B70104 mod STRING
DEFINE l_sql1     STRING                 # RDSQL STATEMENT #No.FUN-680123 CHAR(1200) #MOD-B70104 mod STRING
DEFINE l_za05     LIKE type_file.chr1000 #No.FUN-680123 VARCHAR(40)
DEFINE l_oob09    LIKE oob_file.oob09    #原幣沖帳金額
DEFINE l_oob10    LIKE oob_file.oob10    #本幣沖帳金額
DEFINE l_oob03    LIKE oob_file.oob03    #借貸方
DEFINE l_oov04f   LIKE oov_file.oov04f   #原幣沖帳金額   #MOD-690133
DEFINE l_oov04    LIKE oov_file.oov04    #本幣沖帳金額   #MOD-690133
DEFINE l_oma24    LIKE oma_file.oma24    #匯率           #CHI-890004 add
DEFINE l_oma52    LIKE oma_file.oma52    #原幣訂金       #CHI-860040 add
DEFINE l_oma53    LIKE oma_file.oma53    #本幣訂金       #CHI-860040 add
DEFINE l_oma54t   LIKE oma_file.oma54t   #CHI-860040 add
DEFINE l_oma55    LIKE oma_file.oma55    #CHI-860040 add
DEFINE l_oma56t   LIKE oma_file.oma56t   #CHI-860040 add
DEFINE l_oma57    LIKE oma_file.oma57    #CHI-860040 add
DEFINE l_oma_osum LIKE oma_file.oma57    #CHI-860040 add
DEFINE l_oma_lsum LIKE oma_file.oma57    #CHI-860040 add
DEFINE l_oox01    STRING                 #CHI-830003 add
DEFINE l_oox02    STRING                 #CHI-830003 add
DEFINE l_str      STRING                 #CHI-830003 add
DEFINE l_sql_1    STRING                 #CHI-830003 add
DEFINE l_sql_2    STRING                 #CHI-830003 add
DEFINE l_omb03    LIKE omb_file.omb03    #CHI-830003 add
DEFINE l_count    LIKE type_file.num5    #CHI-830003 add
DEFINE sr         RECORD
                   oma00  LIKE oma_file.oma00,    #帳款類別
                   oma01  LIKE oma_file.oma01,    #帳款編號
                   oma02  LIKE oma_file.oma02,    #帳款日期
                   oma03  LIKE oma_file.oma03,    #帳款客戶
                   oma032 LIKE oma_file.oma032,   #客戶簡稱
                   oma23  LIKE oma_file.oma23,    #幣別
                   oma33  LIKE oma_file.oma33,    #傳票編號
                   oma18  LIKE oma_file.oma18,    #會計科目
                   aag02  LIKE aag_file.aag02,    #科目名稱
                   oma54t LIKE oma_file.oma54t,   #原幣金額
                   oma56t LIKE oma_file.oma56t    #本幣金額
                  END RECORD
DEFINE l_omc02    LIKE omc_file.omc02             #子帳期項次  #MOD-A20045 add
DEFINE l_oma24_1  LIKE oma_file.oma24             #CHI-830003
DEFINE l_dbs      LIKE azp_file.azp03                               
DEFINE l_azp03    LIKE azp_file.azp03                               
DEFINE l_i        LIKE type_file.num5                                        
DEFINE i          LIKE type_file.num5                                   
DEFINE l_npq04    LIKE npq_file.npq04    #No:120920  Add <-yangjian-
DEFINE l_wc       STRING
DEFINE l_sysb,l_sysy  LIKE type_file.num20_6
DEFINE e_date     LIKE type_file.dat
DEFINE l_oma16    LIKE oma_file.oma16
 
   ## *** 與 Crystal Reports 串聯段 - <<<< 清除暫存資料 >>>> CR11 *** ##
   CALL cl_del_data(l_table_axrr151)
 
   LET l_wc =" oma18 = '",p_km,"' ",
              " AND oma03 = '",p_cs,"' "
  
   IF tm.mm = 12 THEN 
      LET e_date = MDY(1,1,tm.yy+1)-1
   ELSE 
      LET e_date = MDY(tm.mm+1,1,tm.yy) - 1 
   END IF 
  #LET e_date =  MDY(tm.mm+1,1,tm.yy)-1
   
   LET l_sql ="SELECT SUM(oob09),SUM(oob10)  ",
               " FROM ooa_file,oob_file",  #FUN-A10098 #FUN-8B0025 mod               
               " WHERE ooa01=oob01 ",
               #"   AND ooa37='1' ",               #FUN-B20020  #mark by dengsy170410
               "   AND ooa02 > '",e_date,"' ",
               "   AND ooaconf='Y' ",
               "   AND oob06 IS NOT NULL ",
               "   AND oob06 = ? ",
               "   AND oob03 = ? ",
               "   AND oob19 = ? "  #MOD-A20045 add
   PREPARE r151_poob FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare apg:',SQLCA.sqlcode,0)
   END IF
   DECLARE r151_coob CURSOR FOR r151_poob
   
   IF g_ooz.ooz07 = 'N' THEN
      LET l_sql = "SELECT oma00,oma01,oma02,oma03,oma032,oma23,",
                  "       oma33,oma18,aag02,(omc08-omc10),",
                  "       (omc09-omc11),omc02,oma16 ",    #No:FUN-A50103  #MOD-A20045 add omc02
                  " FROM oma_file, OUTER aag_file,omc_file", #FUN-A10098
                  " WHERE oma_file.oma18=aag_file.aag01",                        #No.FUN-730073
                  "   AND aag_file.aag00 = '",tm.a,"'",             #No.FUN-730073	
                  "   AND oma01 = omc01",                      #No.MOD-9B0115
                  "   AND omavoid = 'N'",                      #作廢否='N'
                  "   AND omaconf = 'Y'",                      #已確認
                  "   AND ", l_wc CLIPPED,
                  "   AND oma02 <='",e_date,"' ",
                  "   AND ( (oma56t-oma57) >0 OR ",
                  "       oma01 IN (SELECT oob06 FROM ooa_file,oob_file ",    #FUN-A10098
                  "                  WHERE ooa01=oob01  ",
                  "                    AND ooaconf='Y' ",
                  #"                    AND ooa37='1' ",               #FUN-B20020  #mark by dengsy170410
                  "                    AND oob06 IS NOT NULL ",
                  "                    AND ooa02 >'",e_date,"' ) OR ",    #CHI-860040 mod
                  "       oma16 IN (SELECT oma19 FROM oma_file ",            #CHI-860040 add    #No:FUN-A50103
                  "                  WHERE omaconf='Y' AND omavoid='N'",     #CHI-860040 add
                  "                    AND (oma00='12' OR oma00='13')",      #CHI-860040 add
                  "                    AND oma02 >'",e_date,"' )",        #CHI-860040 add
                  "     ) "
   ELSE                                                                                                                           
      LET l_sql = "SELECT oma00,oma01,oma02,oma03,oma032,oma23,",                                                                
                  "       oma33,oma18,aag02,(omc08-omc10),",
                  "       omc13,omc02,oma16 ",  #MOD-A20045 add omc02    #No:FUN-A50103
                  " FROM oma_file, OUTER aag_file,omc_file",  #FUN-A10098                                                                             
                  " WHERE oma_file.oma18=aag_file.aag01",                                                                                  
                  "   AND aag_file.aag00 = '",tm.a,"'",               #No.FUN-730073 
                  "   AND oma01 = omc01",                        #No.MOD-9B0115
                  "   AND omavoid = 'N'",                        #作廢否='N'                                                                           
                  "   AND omaconf = 'Y'",                        #已確認                                                                               
                  "   AND ", l_wc CLIPPED,                                                                                       
                  "   AND oma02 <='",e_date,"' ",                                                                              
                  "   AND (oma61 >0 OR ",                                                                                          
                  "      oma01 IN (SELECT oob06 FROM ooa_file,oob_file ",    #FUN-A10098                                                      
                  "                 WHERE ooa01=oob01  ",                                                                       
                  "                   AND ooaconf='Y' ",     
                  #"                   AND ooa37='1' ",               #FUN-B20020  #mark by dengsy170410                                                                   
                  "                   AND oob06 IS NOT NULL ",                                                                  
                  "                   AND ooa02 >'",e_date,"' ) OR ",           #CHI-860040 mod
                  "      oma16 IN (SELECT oma19 FROM oma_file ",  #CHI-860040 add  #FUN-A10098    #No:FUN-A50103
                  "                 WHERE omaconf='Y' AND omavoid='N'",            #CHI-860040 add
                  "                   AND (oma00='12' OR oma00='13')",             #CHI-860040 add
                  "                   AND oma02 >'",e_date,"' )",               #CHI-860040 add
                  "     ) "
   END IF                                                                                                                         
 
   PREPARE r151_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,0)
   END IF
   DECLARE r151_curs1 CURSOR FOR r151_prepare1
   FOREACH r151_curs1 INTO sr.*,l_omc02,l_oma16  
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      
      IF g_ooz.ooz07 = 'Y' THEN
         LET l_oox01 = YEAR(e_date)
         LET l_oox02 = MONTH(e_date)                           	 
         LET l_oma24_1 = ''   #MOD-9C0030 add
         WHILE cl_null(l_oma24_1)
            IF g_ooz.ooz62 = 'N' THEN
               LET l_sql_2 = "SELECT COUNT(*) FROM oox_file",  #FUN-8B0025 mod     #FUN-A10098          
                             " WHERE oox00 = 'AR' AND oox01 <= '",l_oox01,"'",
                             "   AND oox02 <= '",l_oox02,"'",
                             "   AND oox03 = '",sr.oma01,"'",
                             "   AND oox04 = '0'"
               PREPARE r151_prepare7 FROM l_sql_2
               DECLARE r151_oox7 CURSOR FOR r151_prepare7
               OPEN r151_oox7
               FETCH r151_oox7 INTO l_count
               CLOSE r151_oox7                       
               IF l_count = 0 THEN
                  EXIT WHILE          
               ELSE                  
                  LET l_sql_1 = "SELECT oox07 FROM oox_file", #FUN-8B0025 mod      #FUN-A10098                         
                                " WHERE oox00 = 'AR' AND oox01 = '",l_oox01,"'",
                                "   AND oox02 = '",l_oox02,"'",
                                "   AND oox03 = '",sr.oma01,"'",
                                "   AND oox04 = '0'"
               END IF                 
            ELSE
               LET l_sql_2 = "SELECT COUNT(*) FROM oox_file", #FUN-8B0025 mod   #FUN-A10098            
                             " WHERE oox00 = 'AR' AND oox01 <= '",l_oox01,"'",
                             "   AND oox02 <= '",l_oox02,"'",
                             "   AND oox03 = '",sr.oma01,"'",
                             "   AND oox04 <> '0'"
               PREPARE r151_prepare8 FROM l_sql_2
               DECLARE r151_oox8 CURSOR FOR r151_prepare8
               OPEN r151_oox8
               FETCH r151_oox8 INTO l_count
               CLOSE r151_oox8                       
               IF l_count = 0 THEN
                  EXIT WHILE           
               ELSE            
                  LET l_sql = "SELECT MIN(omb03) ",                                                                              
                              "  FROM omb_file",       #FUN-A10098
                              " WHERE omb01='",sr.oma01,"'"                                                                                                                                                                                  
                  PREPARE r151_pre FROM l_sql                                                                                          
                  DECLARE r151_c  CURSOR FOR r151_pre                                                                                 
                  OPEN r151_c                                                                                    
                  FETCH r151_c INTO l_omb03
                  IF cl_null(l_omb03) THEN
                     LET l_omb03 = 0
                  END IF       
                  LET l_sql_1 = "SELECT oox07 FROM oox_file",                            
                                " WHERE oox00 = 'AR' AND oox01 = '",l_oox01,"'",
                                "   AND oox02 = '",l_oox02,"'",
                                "   AND oox03 = '",sr.oma01,"'",
                                "   AND oox04 = '",l_omb03,"'"                                      
               END IF
            END IF   
            IF l_oox02 = '01' THEN
               LET l_oox02 = '12'
               LET l_oox01 = l_oox01-1
            ELSE    
               LET l_oox02 = l_oox02-1
            END IF            
            
            IF l_count <> 0 THEN        
               PREPARE r151_prepare07 FROM l_sql_1
               DECLARE r151_oox07 CURSOR FOR r151_prepare07
               OPEN r151_oox07
               FETCH r151_oox07 INTO l_oma24_1
               CLOSE r151_oox07
            END IF              
         END WHILE                                       
      END IF                                                                                 
     #No:120920   Add  <<--yangjian---
      LET l_npq04 = NULL
      SELECT npq04 INTO l_npq04 FROM npq_file
       WHERE npqsys = 'AR' 
         AND npq01 = sr.oma01
         AND npq06 = '1' 
         AND ROWNUM = 1
     #No:120920   End  <<--yangjian---
      IF cl_null(l_oma24_1) THEN 
         SELECT oma24 INTO l_oma24_1 FROM oma_file WHERE oma01 = sr.oma01
      END IF 
      #讀取截止日之後的沖帳金額
      IF sr.oma00[1,1]='1' THEN
         LET l_oob03 = '2'
      ELSE
         LET l_oob03 = '1'
      END IF
      LET l_oob09  =0
      LET l_oob10  =0
      OPEN r151_coob USING sr.oma01,l_oob03,l_omc02  #MOD-A20045 add l_omc02
      FETCH r151_coob INTO l_oob09,l_oob10
      IF SQLCA.SQLCODE <> 0 THEN
         LET l_oob09 =0
         LET l_oob10 =0
      END IF
      CLOSE r151_coob
      IF cl_null(sr.oma54t) THEN LET sr.oma54t=0 END IF
      #IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24_1) AND sr.oma54t <> 0 THEN  #TQC-B10083  #mark by dengsy170411
      IF g_ooz.ooz07 = 'Y' AND l_count <> 0 AND sr.oma54t <> 0 THEN    #add by dengsy170411  
         #LET sr.oma56t = sr.oma54t * l_oma24_1                                 #CHI-830003  #mark by wy20170426
         #CALL cl_digcut(sr.oma56t,g_azi04) RETURNING sr.oma56t                 #MOD-BB0050 add #mark by wy20170426
      END IF         
      IF cl_null(sr.oma56t) THEN LET sr.oma56t=0 END IF
      IF cl_null(l_oob09)  THEN LET l_oob09=0 END IF
      #IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN                              #CHI-830003   #TQC-B10083 mark
      #IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24_1) THEN                     #TQC-B10083 mod  #mark by dengsy170411
      IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN   #add by dengsy170411 
         #LET l_oob10 = l_oob09 * l_oma24_1  #mark  by wy20170426                                    #CHI-830003
         #CALL cl_digcut(l_oob10,g_azi04) RETURNING l_oob10 #mark  by wy20170426                     #MOD-BB0050 add
      END IF                                                                   #CHI-830003      
      IF cl_null(l_oob10)  THEN LET l_oob10=0 END IF
      LET l_oov04f = 0
      LET l_oov04  = 0
      
      LET l_sql = "SELECT SUM(oov04f),SUM(oov04)",                                                                              
                  "  FROM oov_file",  #FUN-A10098
                  " WHERE oov03='",sr.oma01,"'",                                                                                                                                                                                  
                  "   AND oov01 IN (SELECT oma01 FROM oma_file ",  #FUN-A10098
                  "                  WHERE oma00 LIKE '2%'     ",
                  "                    AND oma02 > '",e_date,"')",  #MOD-8C0271                                                                                          
                  "   AND oov05= ",l_omc02   #MOD-A20045 add
      PREPARE r151_pre1 FROM l_sql                                                                                          
      DECLARE r151_c1 CURSOR FOR r151_pre1                                                                                 
      OPEN r151_c1                                                                                    
      FETCH r151_c1 INTO l_oov04f,l_oov04
                                  
      IF cl_null(l_oov04f) THEN LET l_oov04f = 0 END IF
      #IF g_ooz.ooz07 = 'Y' AND l_count <> 0 THEN                               #CHI-830003   #TQC-B10083 mark                   
      IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24_1) THEN                      #TQC-B10083  
         LET l_oov04 = l_oov04f * l_oma24_1                                      #CHI-830003
         CALL cl_digcut(l_oov04,g_azi04) RETURNING l_oov04                       #MOD-BB0050 add
      END IF                                                                     #CHI-830003      
      IF cl_null(l_oov04) THEN LET l_oov04 = 0 END IF
      LET l_oma52 = 0   LET l_oma53 = 0   #MOD-870063 add
     #當oma00='23'的帳單號碼抓取對應到oma00='12'的oma19其單據日期>截止日期,
     #已沖金額需加回這些超出截止日期單據的oma52,oma53
      IF sr.oma00 = '23' THEN    
         LET sr.oma54t = 0   LET sr.oma56t = 0
        #改抓多帳期
         LET l_sql ="SELECT omc08-omc10,omc09-omc11,omc06",   #MOD-BC0004
                    "  FROM omc_file",
                    " WHERE omc01='",sr.oma01,"'",
                    "   AND omc02= ",l_omc02
         PREPARE r151_pre2 FROM l_sql                                                                                          
         DECLARE r151_c2 CURSOR FOR r151_pre2                                                                                 
         OPEN r151_c2                                                                                    
         FETCH r151_c2 INTO l_oma54t,l_oma56t,l_oma24                  #MOD-BC0004
          
         IF cl_null(l_oma54t) THEN LET l_oma54t=0 END IF
         IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24_1) THEN                       #TQC-B10083  
            LET l_oma56t = l_oma54t * l_oma24_1                                     #CHI-830003
            CALL cl_digcut(l_oma56t,g_azi04) RETURNING l_oma56t                     #MOD-BB0050 add
         END IF                                                                     #CHI-830003         
         IF cl_null(l_oma56t) THEN LET l_oma56t=0 END IF
         IF cl_null(l_oma24)  THEN LET l_oma24 =1 END IF   #CHI-890004 add
         LET l_sql = "SELECT SUM(oma52),SUM(oma53) ",              #MOD-B70104 
                     "  FROM oma_file",   #FUN-A10098
                     " WHERE oma19='",l_oma16,"'",     #No:FUN-A50103
                     "   AND (oma00='12' OR oma00='13') AND omaconf='Y' AND omavoid='N' ",
                     "   AND oma02 > '",e_date,"'"   #MOD-8C0271 #MOD-BC0004 mod <= -> > 
         PREPARE r151_pre3 FROM l_sql                                                                                          
         DECLARE r151_c3 CURSOR FOR r151_pre3                                                                                
         OPEN r151_c3                                                                                    
         FETCH r151_c3 INTO l_oma_osum,l_oma_lsum
            
         IF cl_null(l_oma_osum) THEN LET l_oma_osum=0 END IF
         IF g_ooz.ooz07 = 'Y' AND NOT cl_null(l_oma24_1) THEN                       #TQC-B10083  
            LET l_oma_lsum = l_oma_osum * l_oma24_1                                 #CHI-830003        
            CALL cl_digcut(l_oma_lsum,g_azi04) RETURNING l_oma_lsum                 #MOD-BB0050 add    
         END IF                                                                    #CHI-830003         
         IF cl_null(l_oma_lsum) THEN LET l_oma_lsum=0 END IF
         #當原幣合計金額等於原幣已沖合計金額,那就讓本幣合計金額等於本幣已沖金額
         IF l_oma_osum=l_oma55 THEN LET l_oma_lsum=l_oma57 END IF
 
        #未沖金額 = 應收 - 已收
         LET l_oma52 = l_oma54t + l_oma_osum  #MOD-BC0004 mod - -> +
        #IF g_ooz.ooz07 = 'Y' THEN                                #MOD-BB0120 add #MOD-C10005 mark
        #預收待抵本幣金額 = 預收剩餘原幣 x 原立帳匯率
         #LET l_oma53 = l_oma52 * l_oma24                          #CHI-890004    #mark by xujw161117
         LET l_oma53 = l_oma52 * l_oma24_1                                        #add by xujw161117
        #ELSE                                                     #MOD-BB0120 add #MOD-C10005 mark
        #   LET l_oma53 = l_oma56t + l_oma_lsum                   #MOD-BB0120 add #MOD-BC0004 mod-->+ #MOD-C10005 mark 
        #END IF                                                   #MOD-BB0120 add #MOD-C10005 mark
         CALL cl_digcut(l_oma53,g_azi04) RETURNING l_oma53        #MOD-BB0050 add 
      END IF
      IF cl_null(l_oma52) THEN LET l_oma52 =0 END IF
      IF cl_null(l_oma53) THEN LET l_oma53 =0 END IF
      LET sr.oma54t = sr.oma54t + l_oob09 + l_oov04f + l_oma52   #CHI-860040 #MOD-BC0004 move sr.oma54t #MOD-C10005加回sr.oma54t
      LET sr.oma56t = sr.oma56t + l_oob10 + l_oov04  + l_oma53   #CHI-860040 #MOD-BC0004 move sr.oma56t #MOD-C10005加回sr.oma56t
IF g_plant<>'GLTP' THEN #151104wudj
      LET sr.oma54t = cl_digcut(sr.oma54t,t_azi04)  #MOD-C10175
END IF
      LET sr.oma56t = cl_digcut(sr.oma56t,g_azi04)  #MOD-C10175
      IF sr.oma00[1,1] = '2' THEN
         LET sr.oma54t = sr.oma54t * -1
         LET sr.oma56t = sr.oma56t * -1
      END IF
       
     #str MOD-A20045 add
     #原幣與本幣金額皆為0時,不需印出
      IF sr.oma54t=0 AND sr.oma56t=0 THEN
         CONTINUE FOREACH
      END IF
     #end MOD-A20045 add

      LET l_sql = "SELECT azi04,azi05",                                                                              
                  "  FROM azi_file",  #FUN-A10098
                  " WHERE azi01='",sr.oma23,"'"                                                                                                                                                                                  
      PREPARE r151_pre4 FROM l_sql                                                                                          
      DECLARE r151_c4 CURSOR FOR r151_pre4                                                                                
      OPEN r151_c4                                                                                    
      FETCH r151_c4 INTO t_azi04,t_azi05
       
      IF sr.oma18 IS NULL THEN LET sr.oma18=' ' END IF

     #str CHI-B60073 add
     #23.預收待抵增加抓取訂金的傳票編號來顯示
      IF sr.oma00='23' THEN
         SELECT oma33 INTO sr.oma33 FROM oma_file
          WHERE oma19=sr.oma01 AND oma00='11'
      END IF
     #end CHI-B60073 add
 
      ## *** 與 Crystal Reports 串聯段 - <<<< 寫入暫存檔 >>>> CR11 *** ##
      EXECUTE axrr151_insert_prep USING  sr.*,t_azi04,t_azi05,g_azi04,g_azi05,' ',l_npq04 
      #------------------------------ CR (3) ------------------------------#
   END FOREACH
 
   ## **** 與 Crystal Reports 串聯段 - <<<< CALL cs3() >>>> CR11 **** ##
   LET l_sql = "SELECT SUM(oma56t),SUM(oma54t) FROM ",g_cr_db_str CLIPPED,l_table_axrr151 CLIPPED 
   PREPARE axrr151_prep FROM l_sql
   EXECUTE axrr151_prep INTO l_sysb,l_sysy 
   RETURN l_sysb,l_sysy
   
END FUNCTION 

FUNCTION aapr150(p_km,p_cs)
DEFINE p_km      LIKE aag_file.aag01
DEFINE p_cs      LIKE pmc_file.pmc01
DEFINE l_name    LIKE type_file.chr20          # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
DEFINE l_sql      STRING            # RDSQL STATEMENT
DEFINE l_sql1     STRING            # RDSQL STATEMENT
DEFINE l_sql2     STRING            # RDSQL STATEMENT   #FUN-720033 add
DEFINE l_apg05f  LIKE apg_file.apg05f    #原幣沖帳金額
DEFINE l_apg05   LIKE apg_file.apg05     #本幣沖帳金額
DEFINE l_apv04f  LIKE apv_file.apv04f    #原幣沖帳金額
DEFINE l_apv04   LIKE apv_file.apv04     #本幣沖帳金額
DEFINE l_aph05f  LIKE aph_file.aph05f    #原幣沖帳金額
DEFINE l_aph05f_1 LIKE aph_file.aph05f   #MOD-B60199 add
DEFINE l_aph05   LIKE aph_file.aph05     #本幣沖帳金額
DEFINE l_aph05_1 LIKE aph_file.aph05     #MOD-B60199 add
DEFINE l_oob09   LIKE oob_file.oob09     #原幣沖帳金額
DEFINE l_oob10   LIKE oob_file.oob10     #本幣沖帳金額
DEFINE l_aqb04f  LIKE aqb_file.aqb04     #原幣分攤金額   #MOD-8A0192 add
DEFINE l_aqb04   LIKE aqb_file.aqb04     #本幣分攤金額   #MOD-8A0192 add
DEFINE l_apa14   LIKE apa_file.apa14     #待抵帳款匯率   #MOD-8A0192 add
DEFINE l_apa14_1 LIKE apa_file.apa14     #MOD-9C0030 add
DEFINE l_alk07   LIKE alk_file.alk07     #到單單號       #MOD-BC0170 add
DEFINE l_alh14   LIKE alh_file.alh14     #原幣沖帳金額   #CHI-850030 add
DEFINE l_alh16   LIKE alh_file.alh16     #本幣沖帳金額   #CHI-850030 add
DEFINE l_ala95f  LIKE ala_file.ala95     #原幣沖帳金額   #CHI-850030 add
DEFINE l_ala95   LIKE ala_file.ala95     #本幣沖帳金額   #CHI-850030 add
DEFINE sr        RECORD
                    apa00  LIKE apa_file.apa00,    #帳款類別
                    apa01  LIKE apa_file.apa01,    #帳款編號
                    apa02  LIKE apa_file.apa02,    #帳款日期
                    apa06  LIKE apa_file.apa06,    #廠商編號
                    apa07  LIKE apa_file.apa07,    #廠商簡稱
                    apa08  LIKE apa_file.apa08,    #發票號碼   #MOD-880086 add
                    apa58  LIKE apa_file.apa58,    #折讓性質   #MOD-880086 add
                    apc02  LIKE apc_file.apc02,    #子帳期項次 #CHI-AB0004 add
                    apa12  LIKE apa_file.apa12,    #付款日期   #CHI-AB0019 add
                    apa13  LIKE apa_file.apa13,    #幣別
                    apa25  LIKE apa_file.apa25,    #摘要
                    apa44  LIKE apa_file.apa44,    #傳票編號
                    apa54  LIKE apa_file.apa54,    #會計科目
                    aag02  LIKE aag_file.aag02,    #科目名稱
                    apa34f LIKE apa_file.apa34f,   #原幣金額
                    apa34  LIKE apa_file.apa34,    #本幣金額    #CHI-850030 add ,
                    apa74  LIKE apa_file.apa74     #外購付款否  #CHI-850030 add
                 END RECORD
#CHI-850030 add --start--
DEFINE ala       RECORD
                    ala86  LIKE ala_file.ala86,
                    ala95  LIKE ala_file.ala95,
                    ala94  LIKE ala_file.ala94,
                    ala59  LIKE ala_file.ala59,
                    ala51  LIKE ala_file.ala51,
                    ala771 LIKE ala_file.ala771   #MOD-BB0071
                 END RECORD
DEFINE alh       RECORD
                    alh14  LIKE alh_file.alh14,
                    alh16  LIKE alh_file.alh16
                 END RECORD
#CHI-850030 add --end--
DEFINE l_oox01   STRING                           #MOD-970007                                                                       
DEFINE l_oox02   STRING                           #MOD-970007                                                                       
DEFINE l_sql_1   STRING                           #MOD-970007                                                                       
DEFINE l_sql_2   STRING                           #MOD-970007                                                                       
DEFINE l_year    LIKE oox_file.oox01              #MOD-970007   
DEFINE l_tm_wc   STRING                           #CHI-850030 add                                                             
DEFINE l_tm_wc2  STRING                           #CHI-850030 add                                                               
DEFINE l_ala22   LIKE ala_file.ala22              #CHI-AB0019 add
DEFINE e_date    LIKE type_file.dat
DEFINE l_sysb,l_sysy   LIKE  type_file.num20_6
DEFINE l_wc      STRING

   CALL cl_del_data(l_table_aapr150)                      #No.FUN-770093
   INITIALIZE alh.* TO NULL                       #MOD-A90114
   INITIALIZE ala.* TO NULL                       #MOD-A90114
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 

   LET l_wc = " apa54 = '",p_km,"' ",
              " AND apa06 = '",p_cs,"' "
   
  #LET e_date =  MDY(tm.mm+1,1,tm.yy)-1
   IF tm.mm = 12 THEN 
      LET e_date = MDY(1,1,tm.yy+1)-1
   ELSE 
      LET e_date = MDY(tm.mm+1,1,tm.yy) - 1 
   END IF 

   #CHI-850030 add --start-- 
   LET l_tm_wc =""
   CALL cl_replace_str(l_wc,"apa01","ala01") RETURNING l_tm_wc
   CALL cl_replace_str(l_tm_wc,"apa06","ala05") RETURNING l_tm_wc
   CALL cl_replace_str(l_tm_wc,"apa54","ala41") RETURNING l_tm_wc
   CALL cl_replace_str(l_tm_wc,"apa44","ala72") RETURNING l_tm_wc
   LET l_tm_wc2 =""
   CALL cl_replace_str(l_wc,"apa01","alk01") RETURNING l_tm_wc2
   CALL cl_replace_str(l_tm_wc2,"apa06","alk05") RETURNING l_tm_wc2
   CALL cl_replace_str(l_tm_wc2,"apa54","alk41") RETURNING l_tm_wc2
   CALL cl_replace_str(l_tm_wc2,"apa44","alk72") RETURNING l_tm_wc2
   #CHI-850030 add --end--

   LET l_sql1 ="SELECT SUM(apv04f),SUM(apv04) ",
               " FROM apv_file,apa_file",
               " WHERE apv03= ?  AND apv01=apa01 AND apa41<>'X' ",   #MOD-770043
               "   AND apa02 > '",e_date,"' ",
               "   AND apa42 = 'N'",   #MOD-780019 #CHI-AB0004 add ,
               "   AND apv05 = ?"   #CHI-AB0004 add
 
   PREPARE r150_papv FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare apv:',SQLCA.sqlcode,0)
   END IF
   DECLARE r150_capv CURSOR FOR r150_papv
 
   #no.6128 待抵帳款要考慮到在 aapt330 與 axrt400 沖帳的情況
   LET l_sql1 = "SELECT SUM(aph05f),SUM(aph05) ",
                "  FROM aph_file,apf_file",
                " WHERE aph04 = ? AND aph01 = apf01 AND  apf41 = 'Y' ",
                "   AND apf02 > '",e_date,"' ", #CHI-AB0004 add ,
                "   AND aph17 = ? " #CHI-AB0004 add
   PREPARE r150_paph FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare aph:',SQLCA.sqlcode,0)
   END IF
   DECLARE r150_caph CURSOR FOR r150_paph
#------------------------MOD-B60199---------------------------add
   LET l_sql1 = "SELECT SUM(aph05f),SUM(aph05) ",
                "  FROM aph_file,apa_file",
                " WHERE aph04 = ? AND aph01 = apa01",
                "   AND  apa41 = 'N' ",
                "   AND aph17 = ? "
   PREPARE r150_paph1 FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare aph:',SQLCA.sqlcode,0)
   END IF
   DECLARE r150_caph1 CURSOR FOR r150_paph1

#------------------------MOD-B60199---------------------------end 

   LET l_sql1 = "SELECT SUM(oob09),SUM(oob10) ",
                "  FROM oob_file,ooa_file",
                " WHERE oob06 = ? AND oob01 = ooa01 AND  ooaconf = 'Y' ",
                "   AND oob03 = '2' AND oob04 = '9' ",
                "   AND ooa02 > '",e_date,"' ", #CHI-AB0004 add ,
                "   AND oob19 = ? " #CHI-AB0004 add
   PREPARE r150_poob FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare oob:',SQLCA.sqlcode,0)
   END IF
   DECLARE r150_coob CURSOR FOR r150_poob
#151012wudj-mark   
#
#   PREPARE r150_papg FROM l_sql1
#   IF SQLCA.sqlcode != 0 THEN
#      CALL cl_err('prepare apg:',SQLCA.sqlcode,0)
#   END IF
#   DECLARE r150_capg CURSOR FOR r150_papg
#151012wudj-mark 
   LET l_sql1 ="SELECT SUM(aqb04)",
               " FROM aqb_file,aqa_file,apa_file",
               " WHERE aqb01=aqa01 ",
               "   AND aqb02=apa01 ",
               "   AND (apa00='23' OR apa00='25') ",
               "   AND aqa04='Y' ",
               "   AND aqaconf='Y' ",
               "   AND aqa02 > '",e_date,"' ",
               "   AND aqb02 = ? "
   PREPARE r150_paqb FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare aqb:',SQLCA.sqlcode,0)
   END IF
   DECLARE r150_caqb CURSOR FOR r150_paqb
 
   #CHI-850030 add --start--
   LET l_sql1 = "SELECT SUM(alh14),SUM(alh16) ",
                "  FROM alh_file",
                " WHERE alh30 = ? ",
                "   AND alhfirm = 'Y' ",
                "   AND alh021 > '",e_date,"' "
   PREPARE r150_palh FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare alh:',SQLCA.sqlcode,0)
   END IF
   DECLARE r150_calh CURSOR FOR r150_palh

   #str MOD-BC0170 add
   CALL cl_replace_str(l_sql1,"alh30","alh01") RETURNING l_sql1
   PREPARE r150_palh01 FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare alh01:',SQLCA.sqlcode,0)
   END IF
   DECLARE r150_calh01 CURSOR FOR r150_palh01
   #end MOD-BC0170 add

   LET l_sql1 = "SELECT SUM(ala95/ala94),SUM(ala95) ",
                "  FROM ala_file",
                " WHERE ala01 = ? ",
                "   AND alafirm = 'Y' ",
                "   AND ala86 > '",e_date,"' "
   PREPARE r150_pala1 FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare ala:',SQLCA.sqlcode,0)
   END IF
   DECLARE r150_cala1 CURSOR FOR r150_pala1

   LET l_sql1 = "SELECT SUM(ala59/ala51),SUM(ala59) ",
                "  FROM ala_file",
                " WHERE ala01 = ? ",
                "   AND alafirm = 'Y' ",
                "   AND ala771 > '",e_date,"' "
   PREPARE r150_pala2 FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare ala:',SQLCA.sqlcode,0)
   END IF
   DECLARE r150_cala2 CURSOR FOR r150_pala2
   #CHI-850030 add --end--

   IF g_apz.apz27 = 'N' THEN
      LET l_sql = "SELECT apa00,apa01,apa02,apa06,apa07,apc12,apa58,apc02,apc04,apa13,apa25,",   #MOD-880086 add apa08,apa58 #CHI-AB0019 add apc04 #CHI-AB0004 add apc02
                  "       apa44,apa54,'',(apc08-apc10-apc14),",   #TQC-610098   #MOD-720128  #TQC-B70203 add apc14
                  "       (apc09-apc11-apc15),apa74 ",    #TQC-610098   #MOD-720128 #CHI-850030 add apa74  #TQC-B70203 add acp15
                  " FROM apa_file,apc_file",  #No.MOD-9B0115 
                 #" WHERE apa42 = 'N' AND apa74='N' ",   #非作廢&外購付款  #No.FUN-730064 #MOD-AB0159 mark 
                  #" WHERE apa42 = 'N' AND apa75='N' ",   #非作廢&外購付款  #No.FUN-730064 #MOD-AB0159 #mark by dengsy170410
                  " WHERE apa42 = 'N' AND (apa75 = 'N' OR apa75 IS NULL) ",  #add by dengsy170410
                  "   AND apa02 <='",e_date,"'",
                  "   AND apa01 =apc01",   #No.MOD-9B0115 
                  "   AND apa41 = 'Y'",   #已確認
                  "   AND ", l_wc CLIPPED,
                 #"   AND ( (apa34f-apa35f) >0 OR ",   #TQC-610098 #MOD-720128 #MOD-C20191 mark
                  #"   AND ( (apa34-apa35) >0 OR ",     #MOD-C20191 add  #mark by dengsy170410
                  "   AND ( (apa34-apa35) <>0 OR ",  #add by dengsy170410 
                  "        apa01 IN (SELECT apg04 FROM apf_file,apg_file ",
                  #"                   WHERE apf01=apg01 AND (apf00='33' OR apf00='34') ",   #MOD-820116  #mark by dengsy170410
                  "                   WHERE apf01=apg01 AND (apf00 LIKE '3%') ",   #add by dengsy170410
                  "                     AND apf41 = 'Y' ",
                  "                     AND apf02 >'",e_date,"' )  OR ",
                  "        apa01 IN (SELECT apv03 FROM apv_file,apa_file ",
                  "                   WHERE apv01=apa01  ",
                  "                     AND apa42 = 'N' ",   #MOD-780019
                  "                     AND apa02 >'",e_date,"' )  OR ",
                  "        apa01 IN (SELECT aph04 FROM apf_file,aph_file ",
                  "                   WHERE aph01=apf01  ",
                  "                     AND apf41 = 'Y' ",
                  "                     AND apf02 >'",e_date,"' ) OR ",
                  #No.MOD-B60199---------------------------------------------------------add
                  "        apa01 IN (SELECT aph04 FROM aph_file ",
                  "                   WHERE aph01 NOT IN (SELECT apf01 FROM apf_file) ",
                  "                     AND aph07 >'",e_date,"' ) OR ",
                  #No.MOD-B60199---------------------------------------------------------end
                  "        apa01 IN (SELECT oob06 FROM oob_file,ooa_file ",
                  "                   WHERE oob01=ooa01  ",
                  "                     AND ooaconf = 'Y' ",
                  "                     AND oob03 = '2' AND oob04 = '9' ",
                  "                     AND ooa02 >'",e_date,"' ) OR ",
                  "        apa01 IN (SELECT aqb02 FROM aqb_file,aqa_file,apa_file ",
                  "                   WHERE aqb01 = aqa01  ",
                  "                     AND aqb02 = apa01  ",
                  "                     AND (apa00 ='23' OR apa00='25')",
                  "                     AND aqa04 = 'Y' ",
                  "                     AND aqaconf = 'Y' ",
                  "                     AND aqa02 >'",e_date,"' ) OR ",
                  "        apa01 IN (SELECT api26 FROM api_file,apa_file ",
                  "                   WHERE api01 = apa01 ",
                  "                     AND api02 = '2' " , #沖暫估
                  "                     AND apa42 ='N' ",   #MOD-780019
                  "                     AND apa41 ='Y' ",
                  "                     AND apa02 >'",e_date,"')) "
      #CHI-850030 add --start--
      LET l_sql = l_sql," UNION ALL ",   #MOD-B50196 add ALL
                  "SELECT '',ala01,ala08,ala05,pmc03,'','',0,ala86,ala20,ala32,", #CHI-AB0019 add ala86 #CHI-AB0004 add 0
                  "       ala72,ala41,'',ala59/ala51,", 
                  "       ala59 ,'R' ", 
                  " FROM ala_file,pmc_file ",
                  " WHERE ala05 = pmc01 ",
                  "   AND ala08 <='",e_date,"'",
                  "   AND alafirm = 'Y'",    #已確認
                  "   AND ", l_tm_wc CLIPPED
      LET l_sql = l_sql," UNION ALL ",   #MOD-B50196 add ALL
                  "SELECT '',alk01,alk02,alk05,pmc03,alk46,'',0,alk02,alk11,alk08,", #CHI-AB0019 add alk02 #CHI-AB0004 add 0
                  "       alk72,alk41,'',alk13,", 
                 #"       alk13*alk12 ,'O' ",   #MOD-B50196 mark
                  #"       alk25+alk26 ,'O' ",   #MOD-B50196  #mark by dengsy170410
                  "       alk25 ,'O' ",   #add by dengsy170410
                  " FROM alk_file,pmc_file ",
                  " WHERE alk05 = pmc01 ",
                  "   AND alk02 <='",e_date,"'",
                  "   AND alkfirm = 'Y'",    #已確認
                  "   AND ", l_tm_wc2 CLIPPED
      #CHI-850030 add --end--
   ELSE
      LET l_sql = "SELECT apa00,apa01,apa02,apa06,apa07,apc12,apa58,apc02,apc04,apa13,apa25,",   #MOD-880086 add apa08,apa58 #CHI-AB0019 add apc04 #CHI-AB0004 add apc02
                  "       apa44,apa54,'',(apc08-apc10-apc14),",  #TQC-B70203 add apc14
                  "       apc13,apa74 ", #CHI-850030 add apa74 
                  " FROM apa_file,apc_file",   #No.MOD-9B0115 
                 #" WHERE apa42 = 'N' AND apa74='N' ",   #非作廢&外購付款 #MOD-AB0159 mark
                  #" WHERE apa42 = 'N' AND apa75='N' ",   #非作廢&外購付款 #MOD-AB0159  #mark by dengsy170410
                  " WHERE apa42 = 'N'    AND (apa75 = 'N' OR apa75 IS NULL) ", #add by dengsy170410
                  "   AND apa02 <='",e_date,"'",
                  "   AND apa01 =apc01",   #No.MOD-9B0115 
                  "   AND apa41 = 'Y'",   #已確認
                  "   AND ", l_wc CLIPPED,
                 #"   AND ( (apa34f-apa35f) >0 OR ",   #TQC-610098 #MOD-720128 #MOD-C20191 mark
                 #"   AND ( (apa34-apa35) >0 OR ",     #MOD-C20191 add
                  #"   AND ( (apa34-apa35) !=0 OR ",    #No:140304   Modify  <<--yangjian--  #mark by dengsy170410
                  "   AND ( (apa34-apa35) <>0 OR ",  #add by dengsy170410 
                  "        apa01 IN (SELECT apg04 FROM apf_file,apg_file ",
                  #"                   WHERE apf01=apg01 AND (apf00='33' OR apf00='34') ",   #MOD-820116 #mark by dengsy170410
                  "                   WHERE apf01=apg01 AND (apf00 LIKE '3%') ",    #add by dengsy170410
                  "                     AND apf41 = 'Y' ",
                  "                     AND apf02 >'",e_date,"' )  OR ",
                  "        apa01 IN (SELECT apv03 FROM apv_file,apa_file ",
                  "                   WHERE apv01=apa01  ",
                  "                     AND apa42 = 'N' ",   #MOD-780019
                  "                     AND apa02 >'",e_date,"' )  OR ",
                  "        apa01 IN (SELECT aph04 FROM apf_file,aph_file ",
                  "                   WHERE aph01=apf01  ",
                  "                     AND apf41 = 'Y' ",
                  "                     AND apf02 >'",e_date,"' ) OR ",
                  "        apa01 IN (SELECT oob06 FROM oob_file,ooa_file ",
                  "                   WHERE oob01=ooa01  ",
                  "                     AND ooaconf = 'Y' ",
                  "                     AND oob03 = '2' AND oob04 = '9' ",
                  "                     AND ooa02 >'",e_date,"' ) OR ",
                  "        apa01 IN (SELECT aqb02 FROM aqb_file,aqa_file,apa_file ",
                  "                   WHERE aqb01 = aqa01  ",
                  "                     AND aqb02 = apa01  ",
                  "                     AND (apa00 ='23' OR apa00='25')",
                  "                     AND aqa04 = 'Y' ",
                  "                     AND aqaconf = 'Y' ",
                  "                     AND aqa02 >'",e_date,"' ) OR ",
                  "        apa01 IN (SELECT api26 FROM api_file,apa_file ",
                  "                   WHERE api01 = apa01 ",
                  "                     AND api02 = '2' " , #沖暫估
                  "                     AND apa41 ='Y' ",
                  "                     AND apa42 ='N' ",   #MOD-780019
                  "                     AND apa02 >'",e_date,"')) "
      #CHI-850030 add --start--
      LET l_sql = l_sql," UNION ALL ",   #MOD-B50196 add ALL
                  "SELECT '',ala01,ala08,ala05,pmc03,'','',0,ala86,ala20,ala32,", #CHI-AB0019 add ala86 #CHI-AB0004 add 0
                  "       ala72,ala41,'',ala59/ala51,", 
                  "       ala59 ,'R' ", 
                  " FROM ala_file,pmc_file ",
                  " WHERE ala05 = pmc01 ",
                  "   AND ala08 <='",e_date,"'",
                  "   AND alafirm = 'Y'",    #已確認
                  "   AND ", l_tm_wc CLIPPED
      LET l_sql = l_sql," UNION ALL ",   #MOD-B50196 add ALL
                  "SELECT '',alk01,alk02,alk05,pmc03,alk46,'',0,alk02,alk11,alk08,", #CHI-AB0019 add alk02 #CHI-AB0004 add 0
                  "       alk72,alk41,'',alk13,", 
                 #"       alk13*alk12 ,'O' ",   #MOD-B50196 mark
                  #"       alk25+alk26 ,'O' ",   #MOD-B50196  #mark by dengsy170410
                  "       alk25 ,'O' ",  #add by dengsy170410
                  " FROM alk_file,pmc_file ",
                  " WHERE alk05 = pmc01 ",
                  "   AND alk02 <='",e_date,"'",
                  "   AND alkfirm = 'Y'",    #已確認
                  "   AND ", l_tm_wc2 CLIPPED
      #CHI-850030 add --end--
   END IF
 
   PREPARE r150_prepare1 FROM l_sql
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare:',SQLCA.sqlcode,0)
   END IF
   DECLARE r150_curs1 CURSOR FOR r150_prepare1
 

   FOREACH r150_curs1 INTO sr.*
      IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF                                                                                                                     
      SELECT aag02 INTO sr.aag02  from aag_file                                                                                       
       WHERE aag01 = sr.apa54                                                                                                         
         AND aag00 = tm.a                                                                                                        
      #No.FUN-730064  --End       #讀取截止日之後的沖帳金額
      LET l_apg05f =0
      LET l_apg05  =0
#151012wudj-str      
         if sr.apa00='16' or sr.apa00='26'  then 
    LET l_sql1 ="SELECT SUM(apg05f),SUM(apg05) ",
               " FROM apf_file,apg_file",
               " WHERE apf01=apg01 ",
               "   AND apf41='Y' ",   #已確認
               "   AND apf02 > '",e_date,"' ",
               "   AND apg04 = ? " #CHI-AB0004 add ,
    else 
   LET l_sql1 ="SELECT SUM(apg05f),SUM(apg05) ",
               " FROM apf_file,apg_file",
               " WHERE apf01=apg01 ",
               "   AND apf41='Y' ",   #已確認
               "   AND apf02 > '",e_date,"' ",
               "   AND apg04 = ? ", #CHI-AB0004 add ,
               "   AND apg06 = ? " #CHI-AB0004 add
     end if 
   PREPARE r150_papg FROM l_sql1
   IF SQLCA.sqlcode != 0 THEN
      CALL cl_err('prepare apg:',SQLCA.sqlcode,1)
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
      EXIT PROGRAM
   END IF
     DECLARE r150_capg CURSOR FOR r150_papg
 
      
    if sr.apa00='16' or sr.apa00='26'  then 
       OPEN r150_capg USING sr.apa01
     else 
      OPEN r150_capg USING sr.apa01,sr.apc02 #CHI-AB0004 add apc02
    end if      
#151012wudj-end     
   #   OPEN r150_capg USING sr.apa01,sr.apc02 #CHI-AB0004 add apc02 #151012wudj
      FETCH r150_capg INTO l_apg05f,l_apg05
      IF SQLCA.SQLCODE <> 0 THEN
         LET l_apg05f=0
         LET l_apg05 =0
      END IF
      CLOSE r150_capg
 
      #讀取截止日之後的直接沖帳金額(K.沖帳)
      LET l_apv04f =0
      LET l_apv04  =0
 
      OPEN r150_capv USING sr.apa01,sr.apc02 #CHI-AB0004 add apc02
      FETCH r150_capv INTO l_apv04f,l_apv04
      IF SQLCA.SQLCODE <> 0 THEN
         LET l_apv04f = 0
         LET l_apv04 = 0
      END IF
 
      LET l_oob09 = 0
      LET l_oob10 = 0
      LET l_aph05f = 0
      LET l_aph05 = 0
      LET l_aph05f_1=0          #MOD-B60199 add
      LET l_aph05_1=0           #MOD-B60199 add
 
      OPEN r150_caph USING sr.apa01,sr.apc02 #CHI-AB0004 add apc02
      FETCH r150_caph INTO l_aph05f,l_aph05
#----------------------------MOD-B60199------------------------------add
      OPEN r150_caph1 USING sr.apa01,sr.apc02
      FETCH r150_caph1 INTO l_aph05f_1,l_aph05_1
#----------------------------MOD-B60199------------------------------end
      OPEN r150_coob USING sr.apa01,sr.apc02 #CHI-AB0004 add apc02
      FETCH r150_coob INTO l_oob09,l_oob10
 
      IF cl_null(l_oob09) THEN
         LET l_oob09 = 0
      END IF
 
      IF cl_null(l_oob10) THEN
         LET l_oob10 = 0
      END IF
 
      IF cl_null(l_aph05f) THEN
         LET l_aph05f = 0
      END IF
 
      IF cl_null(l_aph05) THEN
         LET l_aph05 = 0
      END IF
#----------------------#MOD-B60199 add------------------------------------ 
      IF cl_null(l_aph05f_1) THEN 
         LET l_aph05f_1= 0 
      END IF           

      IF cl_null(l_aph05_1) THEN 
         LET l_aph05_1=0 
      END IF              
#----------------------#MOD-B60199 end-----------------------------------
      OPEN r150_caqb USING sr.apa01
      FETCH r150_caqb INTO l_aqb04
      IF cl_null(l_aqb04) THEN
         LET l_aqb04 = 0
      END IF

      #CHI-850030 add --start--
      LET l_ala95f = 0
      LET l_ala95 = 0
      LET l_alh14 = 0
      LET l_alh16 = 0

      INITIALIZE alh.* TO NULL                       #MOD-AB0159
      INITIALIZE ala.* TO NULL                       #MOD-AB0159
      IF sr.apa74='O' THEN  #外購
         SELECT alh14,alh16 INTO alh.* FROM alh_file WHERE alh30=sr.apa01
         IF cl_null(alh.alh14) THEN LET alh.alh14 = 0 END IF
         IF cl_null(alh.alh16) THEN LET alh.alh16 = 0 END IF
         LET sr.apa34f = sr.apa34f - alh.alh14
         LET sr.apa34  = sr.apa34  - alh.alh16
         OPEN r150_calh USING sr.apa01
         FETCH r150_calh INTO l_alh14,l_alh16
        #str MOD-BC0170 add
        #先到單後到貨時,應該改用alk07來抓l_alh14跟l_alh16
         IF cl_null(l_alh14) AND cl_null(l_alh16) THEN
            LET l_alk07=''
            SELECT alk07 INTO l_alk07 FROM alk_file WHERE alk01=sr.apa01
            OPEN r150_calh01 USING l_alk07
            FETCH r150_calh01 INTO l_alh14,l_alh16
         END IF
        #end MOD-BC0170 add
         IF cl_null(l_alh14) THEN LET l_alh14 = 0 END IF
         IF cl_null(l_alh16) THEN LET l_alh16 = 0 END IF
      END IF

      IF sr.apa74='R' THEN  #預購
         SELECT ala86,ala95,ala94,ala59,ala51,ala771 INTO ala.*    #MOD-BB0071 add ala771
            FROM ala_file
            WHERE ala01 = sr.apa01

         #若aapt711存在,則不考慮 aapt750,依付款日(ala86) ala95(本幣)須再行分析原幣與本幣
         #若aapt711不存在,則 aapt750存在,依結案日(ala771) 回溯金額則抓取 aapt720 的 ala59(本幣)
         IF ala.ala86 !="" OR (NOT cl_null(ala.ala86)) THEN
            #立帳、外購在SLECT時已用餘額計算,故預購回溯前要先求出原幣本幣餘額
            LET sr.apa34f = sr.apa34f - ala.ala95/ala.ala94
            LET sr.apa34  = sr.apa34  - ala.ala95
            OPEN r150_cala1 USING sr.apa01
            FETCH r150_cala1 INTO l_ala95f,l_ala95
         ELSE
            IF ala.ala771 !="" OR (NOT cl_null(ala.ala771)) THEN   #MOD-BB0071
               LET sr.apa34f = sr.apa34f - ala.ala59/ala.ala51
               LET sr.apa34  = sr.apa34  - ala.ala59
               OPEN r150_cala2 USING sr.apa01
               FETCH r150_cala2 INTO l_ala95f,l_ala95
            END IF                                                 #MOD-BB0071
         END IF
         IF cl_null(l_ala95f) THEN LET l_ala95f = 0 END IF
         IF cl_null(l_ala95) THEN LET l_ala95 = 0 END IF
      END IF
      #CHI-850030 add --end--

      IF g_apz.apz27 = 'Y' THEN                                                                                                     
         LET l_oox01 = YEAR(e_date)                                                                                              
         LET l_oox02 = MONTH(e_date)                                                                                             
         LET l_sql_2 = "SELECT oox01 FROM oox_file",                                                                                
                       " WHERE oox00 = 'AP' AND oox01 <= '",l_oox01,"'",                                                            
                       "   AND oox03 = '",sr.apa01,"'",                                                                             
                       "   AND oox04 = '0'",                                                                                        
                      #" ORDER BY oox01"        #MOD-B40220 mark                                                                                        
                       " ORDER BY oox01 DESC "  #MOD-B40220 
         PREPARE r150_prepare7 FROM l_sql_2                                                                                         
         DECLARE r150_oox7 CURSOR FOR r150_prepare7                                                                                 
         LET l_apa14 = ''   #MOD-9C0030 add
         FOREACH r150_oox7 INTO l_year                                                                                              
             IF l_year = l_oox01 THEN                                                                                               
                 LET l_sql_1 = "SELECT oox07 FROM oox_file",                                                                        
                               " WHERE oox00 = 'AP' AND oox01 = '",l_year,"'",                                                      
                               "   AND oox02 <= '",l_oox02,"'",                                                                     
                               "   AND oox03 = '",sr.apa01,"'",                                                                     
                               "   AND oox04 = '0'",                                                                                
                               " ORDER BY oox02 DESC "                                                                              
             ELSE                                                                                                                   
                 LET l_sql_1 = "SELECT oox07 FROM oox_file",                                                                        
                               " WHERE oox00 = 'AP' AND oox01 = '",l_year,"'",                                                      
                               "   AND oox03 = '",sr.apa01,"'",                                                                     
                               "   AND oox04 = '0'",         
                               " ORDER BY oox02 DESC "                                                                              
             END IF                                                                                                                 
             PREPARE r150_prepare07 FROM l_sql_1                                                                                    
             DECLARE r150_oox07 CURSOR FOR r150_prepare07                                                                           
             OPEN r150_oox07                                                                                                        
             FETCH r150_oox07 INTO l_apa14                                                                                          
             CLOSE r150_oox07                                                                                                       
             IF NOT cl_null(l_apa14) THEN                                                                                           
                EXIT FOREACH                                                                                                        
             ELSE                                                                                                                   
                CONTINUE FOREACH                                                                                                    
             END IF                                                                                                                 
          END FOREACH                                                                                                               
      END IF                                                                                                                        
      IF g_apz.apz27 = 'Y' AND NOT cl_null(l_apa14) THEN                                                                            
         #LET sr.apa34 = sr.apa34f * l_apa14  #mark by dengsy170309                                                                                         
      END IF                

      IF NOT cl_null(l_apa14) THEN
         LET l_apa14_1 = l_apa14
      ELSE
         LET l_apa14_1=0
         SELECT apa14 INTO l_apa14_1 FROM apa_file
          WHERE apa01=sr.apa01
            AND (apa00='23' OR apa00='25')
         IF cl_null(l_apa14_1) THEN LET l_apa14_1=1 END IF
      END IF
      LET l_aqb04f = cl_digcut(l_aqb04/l_apa14_1,g_azi04)
 
      IF cl_null(sr.apa34f) THEN LET sr.apa34f=0 END IF
      IF cl_null(sr.apa34 ) THEN LET sr.apa34 =0 END IF
      IF cl_null(l_apg05f) THEN LET l_apg05f=0 END IF
      IF cl_null(l_apg05)  THEN LET l_apg05 =0 END IF
      IF cl_null(l_apv04f) THEN LET l_apv04f=0 END IF
      IF cl_null(l_apv04)  THEN LET l_apv04 =0 END IF
 

      LET sr.apa34f = sr.apa34f + l_apg05f + l_apv04f + l_aph05f #No:B072 mark + l_oob09
                                + l_aqb04f   #MOD-8A0192 add
                                + l_alh14  + l_ala95f  #CHI-850030 add
                                + l_aph05f_1           #MOD-B60199 add
      LET sr.apa34  = sr.apa34  + l_apg05  + l_apv04  + l_aph05  #No:B072 mark + l_oob10
                                + l_aqb04    #MOD-8A0192 add
                                + l_alh16  + l_ala95   #CHI-850030 add
                                + l_aph05_1            #MOD-B60199 add
     #IF sr.apa34f =0 THEN CONTINUE FOREACH END IF  #CHI-850030 add                                                                                                  
      #IF sr.apa34 =0 THEN CONTINUE FOREACH END IF  #CHI-850030 add  #mark by dengsy170410
       IF sr.apa34 =0 AND sr.apa34f =0 THEN CONTINUE FOREACH END IF
      IF g_apz.apz27 = 'Y' AND NOT cl_null(l_apa14) THEN   #MOD-9C0030                         
         #LET sr.apa34 = sr.apa34f * l_apa14  #mark by dengsy170309                                                                                         
      END IF                                                                                                                        
 
      IF sr.apa00[1,1] = '2' THEN
         LET sr.apa34f = sr.apa34f * -1
         LET sr.apa34  = sr.apa34  * -1
      END IF
 
      IF sr.apa54 IS NULL THEN
         LET sr.apa54=' '
      END IF
 
      #抓取傳票編號(參考saapt110的t110_show_ref()段,根據不同的apa00抓法不同)
      #CALL r150_apa44_ref(sr.*) RETURNING sr.apa44   #MOD-880086 add

      #CHI-AB0019 add --start--
      IF sr.apa74='O' THEN  #外購
         SELECT ala22 INTO l_ala22 FROM ala_file WHERE ala01=sr.apa01
         LET sr.apa12 =  sr.apa12 + l_ala22 
      END IF
      #CHI-AB0019 add --end--

      #CHI-AB0004 add --start--
      IF sr.apa74 MATCHES "[RO]" THEN
         LET sr.apc02 =''
      END IF
      #CHI-AB0004 add --end--
 
      SELECT azi03,azi04,azi05 INTO t_azi03,t_azi04,t_azi05 FROM azi_file
             WHERE azi01=sr.apa13
      CALL cl_digcut(sr.apa34,t_azi04) RETURNING sr.apa34   #No:121206 Add <-yangjian-
      EXECUTE aapr150_insert_prep USING
         sr.apa02,sr.apa44,sr.apa01,sr.apa06,sr.apa07,
         sr.apa25,sr.apc02,sr.apa12,sr.apa13,sr.apa34f,sr.apa34,sr.apa54, #CHI-AB0019 add apa12 #CHI-AB0004 add apc02
         sr.aag02,t_azi03,t_azi04,t_azi05
   END FOREACH

   LET l_sql = "SELECT SUM(apa34),SUM(apa34f) FROM ",g_cr_db_str CLIPPED,l_table_aapr150
   PREPARE aapr150_prep FROM l_sql
   EXECUTE aapr150_prep INTO l_sysb,l_sysy 
   RETURN l_sysb,l_sysy   
END FUNCTION

FUNCTION afar201(p_km,p_kind)
DEFINE p_km     LIKE aag_file.aag01
DEFINE p_kind   LIKE type_file.chr1
DEFINE l_n      LIKE type_file.num5   #FUN-B60045   Add
   DEFINE l_name     LIKE type_file.chr20,             # External(Disk) file name       #No.FUN-680070 VARCHAR(20)
          l_sql      LIKE type_file.chr1000,           # RDSQL STATEMENT                #No.FUN-680070 VARCHAR(1000)
          l_chr      LIKE type_file.chr1,              #No.FUN-680070 VARCHAR(1)
          l_za05     LIKE type_file.chr1000,           #No.FUN-680070 VARCHAR(40)
          l_order    ARRAY[5] OF LIKE faj_file.faj06,  #No.FUN-680070 VARCHAR(30)
          l_bdate,l_edate LIKE type_file.dat,          #No.FUN-680070 DATE
          l_year,l_mon LIKE type_file.num5,            #No.FUN-680070 SMALLINT
          l_fan03      LIKE fan_file.fan03,            #MOD-930293 add
          l_fan04      LIKE fan_file.fan04,
          l_fan07      LIKE fan_file.fan07,            #MOD-B10186
          l_fan08      LIKE fan_file.fan08,
          l_fan14      LIKE fan_file.fan14,
          l_fan15      LIKE fan_file.fan15,
          l_fan17      LIKE fan_file.fan17,            #No.CHI-480001
          l_cnt        LIKE type_file.num5,            #No.FUN-680070 SMALLINT
          l_fap04      LIKE fap_file.fap04,
          l_fap03      LIKE fap_file.fap03,
          l_faj34      LIKE faj_file.faj34,            #MOD-950280 add
          sr           RECORD order1 LIKE faj_file.faj06,  #No.FUN-680070 VARCHAR(30)
                              order2 LIKE faj_file.faj06,  #No.FUN-680070 VARCHAR(30)
                              order3 LIKE faj_file.faj06,  #No.FUN-680070 VARCHAR(30)
                              faj04  LIKE faj_file.faj04,    # 資產分類
                              fab02  LIKE fab_file.fab02,    #
                              faj05  LIKE faj_file.faj05,    # 資產分類
                              faj02  LIKE faj_file.faj02,    # 財產編號
                              faj022 LIKE faj_file.faj022,   # 財產附號
                              faj20  LIKE faj_file.faj20,    # 保管部門
                              faj21  LIKE faj_file.faj21,    # 存放位置
                              faf02  LIKE faf_file.faf02,    # 名稱
                              faj19  LIKE faj_file.faj19,    # 保管人
                              gen02  LIKE gen_file.gen02,    # 保管人姓名
                              faj07  LIKE faj_file.faj07,    # 英文名稱
                              faj06  LIKE faj_file.faj06,    # 中文名稱
                              faj17  LIKE faj_file.faj17,    # 數量
                              faj58  LIKE faj_file.faj58,    # 銷帳數量
                              faj08  LIKE faj_file.faj08,    # 規格型號
                              faj27  LIKE faj_file.faj27,    # 折舊年月
                              faj29  LIKE faj_file.faj29,    # 耐用年限
                              faj14  LIKE faj_file.faj14,    # 本幣成本
                              faj141 LIKE faj_file.faj141,   # 調整成本
                              faj59  LIKE faj_file.faj59,    # 銷帳成本
                              faj32  LIKE faj_file.faj32,    # 累績折舊
                              faj43  LIKE faj_file.faj43,    # 狀態
                              faj57  LIKE faj_file.faj57,
                              faj571 LIKE faj_file.faj571,
                              faj100 LIKE faj_file.faj100,
                              faj60  LIKE faj_file.faj60,    # 銷帳累折
                              tmp01  LIKE faj_file.faj60,    # 數量
                              tmp02  LIKE faj_file.faj60,    # 成本
                              tmp03  LIKE faj_file.faj60,    # 前期累折
                              tmp04  LIKE faj_file.faj60,    # 本期累折
                              tmp05  LIKE faj_file.faj60,    # 累積折舊
                              tmp06  LIKE faj_file.faj60,    # 帳面價值
                              tmp07  LIKE faj_file.faj60,    # 減值準備
                              tmp08  LIKE faj_file.faj60,    # 資產淨額
                              faj101 LIKE faj_file.faj101,   # 減值準備
                              faj102 LIKE faj_file.faj102,   # 銷帳減值
                              faj22  LIKE faj_file.faj22     #MOD-620007
                             ,faj93  LIKE faj_file.faj93     #FUN-B60045
                        END RECORD
     DEFINE l_i               LIKE type_file.num5            #No.FUN-680070 SMALLINT
     DEFINE l_zaa02           LIKE zaa_file.zaa02
     #CHI-B70033 -- begin --
     DEFINE l_adj_fan07       LIKE fan_file.fan07,
            l_curr_fan07      LIKE fan_file.fan07,
            l_pre_fan15       LIKE fan_file.fan15
     DEFINE l_gdzc,l_zczj,l_zcjz   LIKE  type_file.num20_6
     DEFINE l_fbz17           LIKE fbz_file.fbz17,
            g_bdate      LIKE type_file.dat,       #No.FUN-680070 DATE
            g_edate      LIKE type_file.dat,       #No.FUN-680070 DATE
            g_fap09      LIKE fap_file.fap09,      #CHI-850036 add
            g_fap10      LIKE fap_file.fap10,      #MOD-780025
            g_fap22      LIKE fap_file.fap22,      #No.TQC-680025
            g_fap45      LIKE fap_file.fap45,      #No.CHI-480001
            g_fap54      LIKE fap_file.fap54,
            g_fap54_7    LIKE fap_file.fap54,      #No.MOD-840680 add
            g_fap57      LIKE fap_file.fap57,
            g_fap660     LIKE fap_file.fap66,
            g_fap661     LIKE fap_file.fap661,     #MOD-780025
            g_fap662     LIKE fap_file.fap66,
            g_fap670     LIKE fap_file.fap67,
            g_fap671     LIKE fap_file.fap67,
            g_fap561     LIKE fap_file.fap56       #MOD-930081
     LET l_n = 1     #FUN-B60045   Add
     CALL cl_del_data(l_table_afar201)                                   #No.FUN-770033 
     
     CASE p_kind
        WHEN '2'
           LET tm.wc = " faj53 = '",p_km,"' "
        WHEN '3'
           LET tm.wc = " faj54 = '",p_km,"' "
        WHEN '4'
           LET tm.wc = " fab24 = '",p_km,"' "
     END CASE
 
      CALL s_azn01(tm.yy,tm.mm) RETURNING g_bdate,g_edate
        LET l_sql = "SELECT '','','',",
                    " faj04, fab02,faj05,",
                    " faj02,faj022,faj20,faj21,faf02,",
                    " faj19,gen02,faj07,faj06,faj17,faj58,",
                    " faj08,faj27,faj29,faj14,faj141,faj59,",
                    " faj32,faj43,faj57,faj571,faj100,faj60,0,0,0,0,0,0,",
                    " 0,0,faj101,faj102,faj22 ",  
                    " ,faj93 ",   
                    "  FROM faj_file,OUTER fab_file,OUTER gen_file,OUTER faf_file",
                    " WHERE fajconf='Y' AND ",tm.wc CLIPPED,
                    " AND faj26 <='",g_edate,"'",
                    " AND faj_file.faj19 = gen_file.gen01 ",
                    " AND faj_file.faj21 = faf_file.faf01 ",
                    " AND faj_file.faj04 = fab_file.fab01 "
     PREPARE afar201_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        RETURN
     END IF
     DECLARE afar201_curs1 CURSOR FOR afar201_prepare1
     #--------------取得當時的資料狀態
      LET l_sql = " SELECT fap04,fap03 FROM fap_file ",
                  " WHERE fap02 = ? AND fap021= ? ",
                  " AND fap04 BETWEEN '",g_bdate,"' AND '",g_edate,"'",  #CHI-850036 add
                  " ORDER BY fap04 DESC  "
     PREPARE r201_pre2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        RETURN
     END IF
     DECLARE r201_curs2 SCROLL CURSOR FOR r201_pre2
    #取得未來的資料狀態
     LET l_sql = " SELECT fap04,fap05 FROM fap_file ",
                 " WHERE fap02 = ? AND fap021= ? ",
                 " AND fap04 > '",g_edate,"'",  
                 " ORDER BY fap04 "
     PREPARE r201_pre3 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        RETURN
     END IF
     DECLARE r201_curs3 SCROLL CURSOR FOR r201_pre3
 
     FOREACH afar201_curs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #---上線後(5)出售(6)銷帳報廢不包含(當年度處份者要納入)
       SELECT count(*) INTO l_cnt FROM fap_file
          WHERE fap02=sr.faj02 AND fap021=sr.faj022
             AND fap77 IN ('5','6') AND (YEAR(fap04) < tm.yy  
             OR (YEAR(fap04) = tm.yy AND MONTH(fap04) < tm.mm)) #MOD-710104   #No.MOD-970072 
       IF l_cnt > 0 THEN CONTINUE FOREACH END IF
       #---上線期初值
       CALL s_azn01(sr.faj57,sr.faj571) RETURNING l_bdate,l_edate

       LET g_fap09 = 0 LET g_fap10 = 0
       LET g_fap22 = 0 LET g_fap45 = 0
       LET g_fap54 = 0 LET g_fap57 = 0
       LET g_fap660= 0 LET g_fap661= 0 LET g_fap662= 0
       LET g_fap670= 0 LET g_fap671= 0
       LET g_fap561 = 0                #MOD-930081 add
 
       #----推算至截止日期之資產數量
#       CALL r201_cal(sr.faj02,sr.faj022)
 
       #數量=目前數量-銷帳數量-大於當期(異動值)+大於當期(銷帳)-大於當期(調整)
#       LET sr.tmp01=sr.faj17-sr.faj58 - g_fap660 + g_fap670 - g_fap662
 
       #----本期累折/成本/累折
       LET l_fan14 = 0
          SELECT fan14                   
            INTO l_fan14 FROM fan_file
           WHERE fan01=sr.faj02 AND fan02=sr.faj022
             AND fan03 = tm.yy AND fan04 = tm.mm
             AND fan041 IN ('0','1')    #MOD-670028
             AND fan05 IN ('1','2')    #No.MOD-540112
      #-------------------------MOD-C30825------------------(E)
       IF cl_null(l_fan14) THEN LET l_fan14=0 END IF
 
       LET l_fan08 = 0    LET l_fan15 = 0    LET l_fan17 = 0
          SELECT SUM(fan08),SUM(fan15),SUM(fan17)
            INTO l_fan08,l_fan15,l_fan17 FROM fan_file      #end No.CHI-480001
           WHERE fan01=sr.faj02 AND fan02=sr.faj022
             AND fan03 = tm.yy AND fan04 = tm.mm
             AND fan041 IN ('0','1')    #MOD-670028
             AND fan05 IN ('1','2')    #No.MOD-540112

       IF cl_null(l_fan17) OR l_fan17 = 0 THEN LET l_fan17 = sr.faj101 END IF 
       IF SQLCA.sqlcode OR cl_null(l_fan08) THEN

             SELECT faj34 INTO l_faj34 FROM faj_file
              WHERE faj02 = sr.faj02 ANd faj022 = sr.faj022
             LET l_sql="SELECT fan03,fan04 FROM fan_file",                                                                          
                       " WHERE fan01 = '",sr.faj02,"' AND fan02 = '",sr.faj022,"'",                                                 
                       "   AND fan03 = ",tm.yy," AND fan04 < ",tm.mm,                                                             
                       "   AND fan041 IN ('0','1') ",        #MOD-B70258
                       "   AND fan05 IN ('1','2') ",         #MOD-B70258
                       " ORDER BY fan03 DESC,fan04 DESC "                                                                           
          PREPARE afar201_prepare_fan FROM l_sql                                                                                    
          DECLARE afar201_curs_fan CURSOR FOR afar201_prepare_fan                                                                   
          LET l_fan03=''  LET l_fan04=''  #MOD-9C0153 add
          FOREACH afar201_curs_fan INTO l_fan03,l_fan04                                                                             
             EXIT FOREACH                                                                                                           
          END FOREACH                                                                                                               
          IF cl_null(l_fan03) THEN LET l_fan03 = 0 END IF   #MOD-930293 add
          IF cl_null(l_fan04) THEN LET l_fan04 = 0 END IF
 
          IF SQLCA.sqlcode OR l_fan04 = 0 THEN
            #-MOD-B10186-add-
                SELECT SUM(fan07) INTO l_fan07
                  FROM fan_file
                 WHERE fan01 = sr.faj02 
                   AND fan02 = sr.faj022
                   AND ((fan03 > tm.yy) OR (fan03 = tm.yy AND fan04 > tm.mm)) 
             IF cl_null(l_fan07) THEN LET l_fan07 = 0 END IF
             LET sr.faj32 = sr.faj32 - l_fan07
             IF sr.faj32 < 0 THEN LET sr.faj32 = 0 END IF
             #----視為折畢
             LET l_fan14 = sr.faj14 + sr.faj141  #成本
             LET l_fan08 = 0                     #本期折舊
             LET l_fan15 = sr.faj32              #累折
             LET l_fan17 = sr.faj101             #減值準備  #No.CHI-480001
             LET g_fap22 = 0      #No.TQC-680025
          ELSE
             #----本期累折/成本/累折
             LET l_fan14 = 0
                SELECT fan14                                
                  INTO l_fan14 FROM fan_file
                 WHERE fan01=sr.faj02 AND fan02=sr.faj022
                   AND fan03 = l_fan03 AND fan04= l_fan04   #TQC-650103  #MOD-930293 
                   AND fan041 IN ('0','1')    #MOD-670028
                   AND fan05 IN ('1','2')    #No.MOD-540112
             LET l_fan08 = 0    LET l_fan15 = 0   LET l_fan17 = 0
                SELECT SUM(fan08),SUM(fan15),SUM(fan17)
                  INTO l_fan08,l_fan15,l_fan17 FROM fan_file   #end No.CHI-480001
                 WHERE fan01=sr.faj02 AND fan02=sr.faj022
                   AND fan03 = l_fan03 AND fan04= l_fan04   #TQC-650103  #MOD-930293 
                   AND fan05 IN ('1','2')   #No.MOD-540112
          END IF
       ELSE
          LET l_fan03 = tm.yy
          LET l_fan04 = tm.mm
       END IF
       IF cl_null(l_fan08) THEN LET l_fan08 = 0 END IF
       IF l_fan03 < tm.yy THEN LET l_fan08 = 0 END IF      #MOD-9A0007 add
       IF cl_null(l_fan17) THEN LET l_fan17 = 0 END IF      #No.CHI-480001
       IF g_fap09=0 THEN LET g_fap09=l_fan14 END IF   #CHI-850036 add

       #CHI-B70033 -- begin --
       LET l_cnt = 0
       LET l_adj_fan07 = 0
          SELECT COUNT(*) INTO l_cnt FROM fan_file
           WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
             AND fan03 = tm.yy AND fan04 = tm.mm
             AND fan041 = '1'

          SELECT SUM(fan07) INTO l_adj_fan07 FROM fan_file
           WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
             AND fan03 = tm.yy AND fan04 = tm.mm
             AND fan041 = '2'
       IF cl_null(l_adj_fan07) THEN LET l_adj_fan07 = 0 END IF

       IF l_cnt > 0 THEN
          IF g_aza.aza26 <> '2' THEN
             LET l_adj_fan07 = 0
          ELSE
             #大陸版有可能先折舊再調整
                SELECT fan15 INTO l_pre_fan15 FROM fan_file
                 WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
                   AND fan041 = '1'
                   AND fan03 || fan04 IN (
                         SELECT MAX(fan03) || MAX(fan04) FROM fan_File
                          WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
                            AND ((fan03 < tm.yy) OR (fan03 = tm.yy AND fan04 < tm.mm))
                            AND fan041 = '1')

                SELECT fan07 INTO l_curr_fan07 FROM fan_file
                 WHERE fan01 = sr.faj02 AND fan02 = sr.faj022
                   AND fan03 = tm.yy AND fan04 = tm.mm
                   AND fan041 = '1'
             IF cl_null(l_curr_fan07) THEN LET l_curr_fan07 = 0 END IF

             IF l_fan15 = (l_pre_fan15 + l_curr_fan07 + l_adj_fan07) THEN
                LET l_adj_fan07 = 0
             END IF
          END IF
       END IF
       IF sr.faj43 = '1' THEN 
          LET l_adj_fan07 = 0 
       END IF 
       LET l_fan15 = l_fan15 + l_adj_fan07
       LET l_fan08 = l_fan08 + l_adj_fan07
       LET l_fan15 = l_fan15 
       LET l_fan08 = l_fan08 
       #CHI-B70033 -- end --
  
       SELECT SUM(fap54) INTO g_fap54_7 FROM fap_file
          #WHERE fap03 IN ('7')                         #MOD-C20210 mark
           WHERE fap03 IN ('7','8')                     #MOD-C20210 add 
             AND fap02=sr.faj02
             AND fap021=sr.faj022
             AND fap04 > g_edate
       IF cl_null(g_fap54_7) THEN LET g_fap54_7 = 0 END IF
       #成本=目前成本+調整成本-銷帳成本-(大於當期(調整)-大於當期(前一次調整))-大於當期(改良)
         LET sr.tmp02 = sr.faj14+sr.faj141-sr.faj59-(g_fap661-g_fap10)-g_fap54_7 + g_fap561   #MOD-930081
       #--->成本為零
       IF sr.tmp02 <=0  THEN CONTINUE FOREACH END IF              
       #No.MOD-AC0038  --End 
       LET l_year = sr.faj27[1,4]
       LET l_mon  = sr.faj27[5,6]
       IF (l_year=tm.yy AND l_mon > tm.mm) OR l_year > tm.yy THEN
          LET sr.tmp05 = 0
          LET sr.tmp07 = 0                       #No.CHI-480001
       ELSE
          LET sr.tmp05 = l_fan15 - g_fap57       #累折
          LET sr.tmp07 = l_fan17 - g_fap45       #減值準備  #No.CHI-480001
       END IF
       #-->本期累折
       IF l_fan08 = 0 THEN
          LET sr.tmp04 = 0
       ELSE
          LET sr.tmp04 = l_fan08 - g_fap54    #本期折舊  #CHI-850036 mark   #MOD-930059 mark回復
       END IF
       LET sr.tmp03 = sr.tmp05- sr.tmp04      #前期折舊 = 累折 - 本期累折   #MOD-8C0038 mark回復
     
       LET sr.tmp06 = sr.tmp02- sr.tmp05      #帳面價值 (成本-累折)
       LET sr.tmp08 = sr.tmp06- sr.tmp07      #資產淨值 (帳面價值-減值準備)

       EXECUTE afar201_insert_prep USING
                         sr.faf02,sr.faj02,sr.faj022,sr.faj04,sr.faj05,sr.faj06,
                         sr.faj07,sr.faj08,sr.faj19,sr.faj20,sr.faj21,sr.faj22,
                         sr.faj27,sr.faj29,sr.faj43,sr.tmp01,sr.tmp02,sr.tmp03,
                         sr.tmp04,sr.tmp05,sr.tmp06,sr.tmp08
                        ,sr.faj93
     END FOREACH
     LET g_sql = " SELECT SUM(tmp02),SUM(tmp05),SUM(tmp06-tmp08) FROM ",g_cr_db_str CLIPPED,l_table_afar201 CLIPPED,
                 "  WHERE 1=1 "
     PREPARE afar201_prep FROM g_sql
     EXECUTE afar201_prep INTO l_gdzc,l_zczj,l_zcjz
     CASE p_kind 
        WHEN '2' RETURN l_gdzc
        WHEN '3' RETURN l_zczj
        WHEN '4' RETURN l_zcjz
     END CASE 
     
END FUNCTION


FUNCTION q931_batt()
 DEFINE i  LIKE  type_file.num5
 DEFINE l_n  LIKE  type_file.num5

   CALL g_xx_att.clear()   

   FOR i = 1 TO g_rec_b
      IF g_xx[i].yce !=0 OR g_xx[i].bce != 0 THEN 
         LET g_xx_att[i].yce = 'red reverse'
         LET g_xx_att[i].bce = 'red reverse'
      ELSE 
         SELECT COUNT(*) INTO l_n FROM gglq931_tmp
          WHERE km = g_xx[i].km
            AND (yce !=0 OR bce!=0)
         IF l_n > 0 THEN 
            LET g_xx_att[i].yce = 'yellow reverse'
            LET g_xx_att[i].bce = 'yellow reverse'
         END IF 
      END IF       
   END FOR
END FUNCTION 

FUNCTION q931_datt()
 DEFINE i  LIKE  type_file.num5

   CALL g_b_xx_att.clear()   

   FOR i = 1 TO g_rec_b2
      IF g_b_xx[i].b_yce !=0 OR g_b_xx[i].b_bce != 0 THEN 
         LET g_b_xx_att[i].b_yce = 'red reverse'
         LET g_b_xx_att[i].b_bce = 'red reverse'
      END IF       
   END FOR

END FUNCTION


