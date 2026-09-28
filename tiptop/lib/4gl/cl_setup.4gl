# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Program name...: cl_setup.4gl
# Descriptions...: 程式執行的基本設定.
# Date & Author..: 03/09/08 by Hiko
# Usage..........: CALL cl_setup("AXM")
# Modify.........: 04/09/16 By alex 使用 g_sys時後方需加上 CLIPPED or .trim()
# Modify.........: 04/10/07 By alex add customerlized path
# Modify.........: No.MOD-4A0217 04/10/14 By saki 
# Modify.........: No.MOD-490398 04/11/10 By Danny 
# Modify.........: No.MOD-4B0133 04/11/15 By alex 增加 ABT 模組比照 ABX 模組定義
# Modify.........: No.FUN-4C0104 05/01/05 By alex 修改 4js bug 定義超長
# Modify.........: No.FUN-510026 05/01/12 By coco 修改匯率長度為 20,10
# Modify.........: No.MOD-530097 05/03/14 By alex 更新一人多群組時有單身時的權限設定
# Modify.........: No.FUN-550078 05/05/18 By saki 增加global變數g_doc_len,g_no_sp
# Modify.........: No.MOD-580397 05/09/02 By Nicola 預設t_azi*
# Modify.........: No.MOD-590069 05/09/19 By alex 抓取 GIS's isf_file
# Modify.........: No.MOD-590433 05/09/22 By alex 抓取 gas 語法修正 fit informix
# Modify.........: No.TQC-5A0020 05/10/08 By alex 放開被 mark 的權限取聯集 priv2,3
# Modify.........: No.MOD-5A0326 05/10/26 By alex 加說明
# Modify.........: No.TQC-5A0094 05/10/26 By alex 修改印表方式聯集取法
# Modify.........: No.FUN-5C0057 05/12/13 By alex 修改印表方式聯集取法 定義於zxw算全開
# Modify.........: No.FUN-5C0084 05/12/20 By ching DEFINE g_aaz 為整體變數
# Modify.........: No.TQC-620014 06/02/11 By alex 將zxw,zy的li_count分開取個數
# Modify.........: No.FUN-610062 06/02/17 By yoyo 新增atm模塊
# Modify.........: No.FUN-5C0114 06/02/21 By kim add ASR模組
# Modify.........: No.FUN-630099 06/04/03 By Echo 列表方式在zxw不全開，採取聯集的取法
# Modify.........: N0.FUN-670007 06/07/27 BY yiting 新增oax
# Modify.........: No.FUN-690005 06/09/18 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.MOD-710181 07/01/30 By Smapmin 增加CTM模組
# Modify.........: No.MOD-7B0137 07/11/14 By Pengu 抓取g_priv2會異常
# Modify.........: No.FUN-7C0042 07/12/13 By alex 修改說明及db串接符號
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-7B0013 08/01/03 By alex 修改db串接字串
# Modify.........: No.FUN-810054 08/01/18 By alex 新增判斷 os相關 Function
# Modify.........: No.FUN-820017 08/02/15 By alex 修改MSV連線字串
# Modify.........: No.FUN-820041 08/02/21 By alex 新增cl_get_tpserver_ip函式
# Modify.........: No.FUN-8A0138 08/10/30 By alex 抓IP需考量有port資料時之去除
# Modify.........: No.MOD-8C0288 08/12/30 By Duke move old aps table 
# Modify.........: No.TQC-910039 09/01/16 By Duke  補過單
# Modify.........: No.FUN-910078 09/02/05 By kim 行業別程式卡關
# Modify.........: No.FUN-940084 09/04/15 By Vicky 錯誤訊息只DISPLAY到背景但會RETURN FALSE的，都改成 CALL cl_err
# Modify.........: No.FUN-930151 09/04/27 By rainy 新增海關合同電子帳冊參數
# Modify.........: No.FUN-960058 09/06/11 By destiny 新增對法人的全局賦值
# Modify.........: No:FUN-960137 09/06/18 By Vicky 增加 cl_get_env()取得目前環境區域 
# Modify.........: No.FUN-A30020 10/03/12 By saki 單據編號規格改變,加入PlantCode
# Modify.........: No.FUN-AA0017 10/07/22 By alex 增加ASE判斷
# Modify.........: No.FUN-B20029 11/04/22 By echo 新增cl_get_tp_version 函式: 取得 TIPTOP 版本
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No:FUN-C90025 12/09/07 By Kevin 修正B2B環境,無法取出 $AZZ
# Modify.........: No:FUN-CA0071 12/10/05 By Kevin 修正B2B環境,取回 $FGLASIP
# Modify.........: No:FUN-CC0076 12/12/12 By Kevin 修正B2B環境,取回 $WEBAREA
# Modify.........: No.CHI-C90042 13/01/09 By zack  調整cl_setup,在RETURN FALSE前呼叫cl_process_logout清除gbq_file
# Modify.........: No.MOD-CA0055 12/10/11 By Polly 增加客製目錄判斷
# Modify.........: No.MOD-D30242 13/03/28 By bart 設定g_max_rec 的地方往前搬到判斷行業別前
# Modify.........: No.MOD-D80171 13/08/27 By SunLM 將設定g_max_rec 的地方往前搬到g_aza賦值后

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
GLOBALS
   DEFINE   mc_db_type         LIKE type_file.chr3  #FUN-7C0042
   DEFINE   ms_os_type         STRING               #FUN-810054
END GLOBALS
 
##################################################
# Descriptions...: 程式執行的基本設定.
# Date & Author..: 2003/09/08 by Hiko
# Input parameter: ps_module   STRING   模組代號
# Return code....: SMALLINT   設定是否成功
# Modify ........: No.MOD-470600 04/07/30 Danny  新增GXC/GFA
##################################################
 
#TQC-910039 補過單
FUNCTION cl_setup(ps_module)
 
   DEFINE   ps_module    STRING
   DEFINE   ls_prog      STRING  #FUN-910078
   DEFINE   l_cnt        LIKE type_file.num5   #FUN-910078
   DEFINE   ls_indprog   LIKE zz_file.zz01     #FUN-910078
   DEFINE   l_msg        STRING                #FUN-910078
   DEFINE   l_str        STRING                #FUN-940084
   DEFINE   lc_plantadd  LIKE aza_file.aza97   #FUN-A30020
   DEFINE   li_plantlen  LIKE aza_file.aza98   #FUN-A30020
   DEFINE   lc_doc_set   LIKE aza_file.aza41   #FUN-A30020
   DEFINE   lc_sn_set    LIKE aza_file.aza42   #FUN-A30020
 
   WHENEVER ERROR CALL cl_err_msg_log
   
   IF (NOT cl_set_priv()) THEN
     CALL cl_process_logout() #No.CHI-C90042 
     RETURN FALSE
   END IF
 
   LET mc_db_type = cl_db_get_database_type()

   CASE mc_db_type 
      WHEN "IFX" 
         SET ISOLATION TO DIRTY READ
      WHEN "MSV"
         SET ISOLATION TO DIRTY READ 
         SET LOCK MODE TO NOT WAIT
      WHEN "ASE"                    #FUN-AA0017
         SET ISOLATION TO DIRTY READ 
         SET LOCK MODE TO NOT WAIT
   END CASE
 
   LET ps_module = ps_module.toUpperCase()
   LET g_today = TODAY  
   LET g_lastdat = MDY(12,31,9999)
   SELECT azw02 INTO g_legal FROM azw_file WHERE azw01=g_plant                #NO.FUN-960058  
 
   # 2004/08/04 因為在 zz_file 中有 zz011(模組別) 的設定, 所以 g_sys 改為
   #            抓取 zz011, 初期會先進行判斷
   SELECT zz011 INTO g_sys FROM zz_file WHERE zz01=g_prog
   IF DOWNSHIFT(g_sys) <> DOWNSHIFT(ps_module.trim()) THEN
      display 'Info: Module Error in 4gl and p_zz! Check it!!'
      LET g_sys = UPSHIFT(ps_module.trim())
   ELSE
      LET g_sys = UPSHIFT(g_sys) CLIPPED
   END IF

   #LET g_max_rec = g_aza.aza34  #MOD-D30242 #MOD-D80171 mark
   #IF g_max_rec <= 0 OR cl_null(g_max_rec) THEN LET g_max_rec = 1000 END IF  #MOD-D30242 #MOD-D80171 mark
 
      # 待重整
      # ABM,ACS,AEC,AIM,AMR,AMS,APJ,APM,ASF,ASM: aza,sma
      # AOO,ACO,AWS: aza
      # AAP,AMD,GAP: aza,    apz
      # ASD,AXC,GXC: aza,sma,ccz               #NO.MOD-470600
      # AXM,GIS:     aza,sma,oaz,oax
      # AXR,GXR:     aza,    ooz
      # ANM,GNM:     aza,    nmz
      # AGL,GGL:     aza,sma,aaz
      # APY,GPY:     aza,    cpa
      # ABX,ABT:     aza,    bxz,ooz
      # ADM:         aza,sma,oaz
      # AMM:         aza,sma,mmd
      # ARM:         aza,sma,rmz
      # AFA,GFA:     aza,    aaz,faa           #NO.MOD-470600
      # APS:         aza,sma,aps_saz 
      # AQC:             sma,qcz
      # AXS:         aza,    oaz
      # ABG:                 bgz,aaz
      # ACO:         aza,coz                   #No.MOD-490398
 
   # 共用模組參數 aza,sma,gas
#MOD-590433
   SELECT * INTO g_aza.* FROM aza_file WHERE aza01='0'
   IF SQLCA.SQLCODE THEN
      CALL cl_process_logout() #No.CHI-C90042
      #--FUN-940084--start--
      #DISPLAY 'Select Parameter file of aza_file Error! Code:',SQLCA.SQLCODE CLIPPED
      #DISPLAY 'Contact to System Administrator!'
      LET l_str = "Select Parameter file of aza_file Error! Code:",SQLCA.SQLCODE CLIPPED,
                  "\n","Contact to System Administrator"
      CALL cl_err(l_str,"!",1)
      #--FUN-940084--end--
      RETURN FALSE
   ELSE
      LET g_cuelang=FALSE
   END IF
   LET g_max_rec = g_aza.aza34  #MOD-D80171 add
   IF g_max_rec <= 0 OR cl_null(g_max_rec) THEN LET g_max_rec = 1000 END IF  #MOD-D80171 add   
   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
   IF SQLCA.SQLCODE THEN
      CALL cl_process_logout() #No.CHI-C90042
      #--FUN-940084--start--
      #DISPLAY 'Select Parameter file of sma_file Error! Code:',SQLCA.SQLCODE CLIPPED
      #DISPLAY 'Contact to System Administrator!'
      LET l_str = "Select Parameter file of sma_file Error! Code:",SQLCA.SQLCODE CLIPPED,
                  "\n","Contact to System Administrator"
      CALL cl_err(l_str,"!",1)
      #--FUN-940084--end--
      RETURN FALSE
   END IF
   #FUN-910078...................begin  #若為多行業別程式,則只能執行自己行業別的程式 ex.sma124='icd',則只能執行aimi100_icd,不能執行aimi100/aimi100_slk
   #1.如果執行的程式含行業別字串,需對照是否為目前的行業別,若不是則發出錯誤訊息並離開
   #2.如果執行的程式不含行業別字串,需對照目前的行業別若為std,若是的話則通過檢查程序;
   #  如果執行的程式不含行業別字串,需對照目前的行業別若非std,則需再檢查p_zz是否存在此程式的行業別程式,若是的話則發出錯誤訊息並離開
   
   LET ls_prog = g_prog CLIPPED
   IF ls_prog.getindexof('_',ls_prog.getlength()-4) = 0 THEN  #絕非行業別程式
      IF (g_sma.sma124 <> 'std') AND (NOT cl_null(g_sma.sma124)) THEN  #若sma124為空白視為std
         LET ls_indprog = ls_prog , "_" , g_sma.sma124 CLIPPED
         SELECT COUNT(*) INTO l_cnt FROM zz_file
                                   WHERE zz01 = ls_indprog
         IF l_cnt > 0 THEN  #為行業別環境,且有此行業別程式,但執行的是一般行業別程式
            CALL cl_process_logout() #No.CHI-C90042 
            LET l_msg = cl_getmsg("lib-055",g_lang),ls_indprog
            CALL cl_err(l_msg,'!',1)
            EXIT PROGRAM
         END IF
      END IF
   ELSE     
      IF ls_prog.subString(ls_prog.getLength()-3,ls_prog.getLength()-3) = '_' THEN #倒數第四碼為底線,有可能為行業別程式
         LET ls_indprog = ls_prog.subString(ls_prog.getLength()-3+1,ls_prog.getLength())
         IF g_sma.sma124 <> ls_indprog THEN  #末三碼與目前行業別設定相同,則掠過此段檢查
            SELECT COUNT(*) INTO l_cnt FROM smb_file
                                      WHERE smb01 = ls_indprog
                                        AND smb05='N'
            IF l_cnt > 0 THEN  #為行業別環境,且執行的是行業別程式,但非本行業別的
               CALL cl_process_logout() #No.CHI-C90042
               LET l_msg = cl_getmsg("lib-055",g_lang)
               CALL cl_err(l_msg,'!',1)
               EXIT PROGRAM
            END IF
         END IF
      END IF   
   END IF
   
   #FUN-910078...................end
   SELECT * INTO g_gas.* FROM gas_file WHERE gas01='0'
   IF SQLCA.SQLCODE THEN
      DISPLAY 'Select Parameter file of gas_file Error! Code:',SQLCA.SQLCODE CLIPPED
      DISPLAY 'Notice to System Administrator! Program Continue..'
   END IF
#  SELECT aza_file.*,sma_file.*,gas_file.*
#    INTO g_aza.*, g_sma.*, g_gas.*
#    FROM aza_file, sma_file, gas_file 
#   WHERE aza01='0' AND sma00='0' AND gas01='0'
#MOD-590433
 
   #FUN-5C0084
   IF (NOT cl_set_aaz_param()) THEN
     CALL cl_process_logout() #No.CHI-C90042 
     RETURN FALSE
   END IF
   #--
 
   CASE 
      WHEN g_sys="AAP" OR g_sys="CAP"
         IF (NOT cl_set_apz_param()) THEN
            CALL cl_process_logout() #No.CHI-C90042
            RETURN FALSE
         END IF
 
         LET g_plant_new = g_apz.apz02p
         CALL cl_set_dbs_new()
         
         LET g_plant_new = g_apz.apz04p
         CALL cl_set_dbs_new()
 
      WHEN g_sys="ABG" OR g_sys="CBG"
         IF (NOT cl_set_bgz_param()) THEN
           CALL cl_process_logout() #No.CHI-C90042 
           RETURN FALSE
         END IF
 
         IF (NOT cl_set_aaz_param()) THEN
           CALL cl_process_logout() #No.CHI-C90042 
           RETURN FALSE
         END IF
 
      WHEN g_sys="ABX" OR g_sys="CBX" OR g_sys="ABT" OR g_sys="CBT"
         SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'
         IF (SQLCA.SQLCODE) THEN
            INSERT INTO ooz_file(ooz00) VALUES('0')
            CALL cl_err('Parameter setting error:', SQLCA.SQLCODE, 2)
         END IF
 
         SELECT * INTO g_bxz.* FROM bxz_file WHERE bxz00='0'
         IF (SQLCA.SQLCODE = 100) THEN
            INSERT INTO bxz_file(bxz00,bxz01) VALUES('0','N')
         END IF
 
         IF (NOT cl_setup_err("Parameter setting error")) THEN
            CALL cl_process_logout() #No.CHI-C90042
            RETURN FALSE
         END IF
         
         LET g_plant_new = g_ooz.ooz02p
         CALL cl_set_dbs_new()
         LET g_gl_dbs = g_dbs_new
 
      WHEN g_sys="ADM" OR g_sys="CDM"
         SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00='0'
         IF (SQLCA.SQLCODE) THEN
            INSERT INTO oaz_file(oaz00) VALUES('0')
            CALL cl_err('Parameter setting error:', SQLCA.SQLCODE, 2)
         END IF
 
         LET g_plant_new = g_oaz.oaz02p
         CALL cl_set_dbs_new()
         LET g_gl_dbs = g_dbs_new
 
      WHEN g_sys="AFA" OR g_sys="CFA"
         IF (NOT cl_set_aaz_param()) THEN
           CALL cl_process_logout() #No.CHI-C90042 
           RETURN FALSE
         END IF
 
         IF (NOT cl_set_faa_param()) THEN
           CALL cl_process_logout() #No.CHI-C90042 
           RETURN FALSE
         END IF
 
      WHEN g_sys="AGL" OR g_sys="CGL"
         SELECT * INTO g_aaz.* FROM aaz_file WHERE aaz00='0'
         IF (SQLCA.SQLCODE = 100) THEN
            INSERT INTO aaz_file(aaz00) VALUES('0')
         END IF
          
      WHEN g_sys="AMD" OR g_sys="CMD"
         IF (NOT cl_set_apz_param()) THEN
           CALL cl_process_logout() #No.CHI-C90042 
           RETURN FALSE
         END IF
 
         LET g_plant_new = g_apz.apz02p
         CALL cl_set_dbs_new()
         LET g_gl_dbs = g_dbs_new
 
         LET g_plant_new = g_apz.apz04p
         CALL cl_set_dbs_new()
         LET g_nm_dbs = g_dbs_new
 
      WHEN g_sys="AMM" OR g_sys="CMM"
         IF (NOT cl_set_mmd_param()) THEN
           CALL cl_process_logout() #No.CHI-C90042 
           RETURN FALSE
         END IF
 
      WHEN g_sys="ANM" OR g_sys="CNM"
         IF (NOT cl_set_nmz_param()) THEN
           CALL cl_process_logout() #No.CHI-C90042 
           RETURN FALSE
         END IF
 
      WHEN g_sys="APS" OR g_sys="CPS"
 
         #MOD-8C0288    MARK   --STR--
         #SELECT * INTO aps_saz.* FROM aps_saz WHERE saz00='0'
         #IF (SQLCA.SQLCODE = 100) THEN
         #   INSERT INTO aps_saz(saz00,saz01,saz02)
         #                VALUES('0','0','1') 
         #END IF
         # 
         #IF (NOT cl_setup_err("Parameter setting error")) THEN
         #   RETURN FALSE
         #END IF
         #MOD-8C0288   MARK   --END--
 
      #-----TQC-B90211---------
      #WHEN g_sys="APY" OR g_sys="CPY"
      #   SELECT * INTO g_cpa.* FROM cpa_file WHERE cpa00='0'
      #   IF (SQLCA.SQLCODE = 100) THEN
      #      INSERT INTO cpa_file(cpa00,cpa06,cpa061,cpa07,cpauser,cpagrup,cpadate)
      #                    VALUES('0',YEAR(g_today),MONTH(g_today),'0',g_user,g_grup,g_today)
      #   END IF
      #
      #   IF (NOT cl_setup_err("Parameter setting error")) THEN
      #      RETURN FALSE
      #   END IF
      #-----END TQC-B90211-----
 
      WHEN g_sys="AQC" OR g_sys="CQC" OR
           g_sys="ASR" OR g_sys="CSR" #FUN-5C0114
         IF (NOT cl_set_qcz_param()) THEN
            CALL cl_process_logout() #No.CHI-C90042
            RETURN FALSE
         END IF
         
      WHEN g_sys="ARM" OR g_sys="CRM"
         IF (NOT cl_set_rmz_param()) THEN
            CALL cl_process_logout() #No.CHI-C90042
            RETURN FALSE
         END IF
 
      WHEN g_sys="ASD" OR g_sys="CSD"
         IF (NOT cl_set_ccz_param()) THEN
           CALL cl_process_logout() #No.CHI-C90042 
           RETURN FALSE
         END IF
 
      WHEN g_sys="AXC" OR g_sys="CXC"
         IF (NOT cl_set_ccz_param()) THEN
           CALL cl_process_logout() #No.CHI-C90042 
           RETURN FALSE
         END IF
 
      #WHEN g_sys="AXM" OR g_sys="CXM"  OR g_sys="ATM"                      #No.FUN-610062   #MOD-710181
      WHEN g_sys="AXM" OR g_sys="CXM"  OR g_sys="ATM" OR g_sys="CTM"        #MOD-710181
         SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00='0'
         IF (SQLCA.SQLCODE) THEN
            INSERT INTO oaz_file(oaz00) VALUES('0')
            CALL cl_err('Parameter setting error:', SQLCA.SQLCODE, 2)
         END IF
         #NO.FUN-670007 start--
         SELECT * INTO g_oax.* FROM oax_file WHERE oax00='0'
         IF (SQLCA.SQLCODE) THEN
            INSERT INTO oax_file(oax00) VALUES('0')
            CALL cl_err('Parameter setting error:', SQLCA.SQLCODE, 2)
         END IF
 
         SELECT * INTO g_pod.* FROM pod_file WHERE pod00='0'
         IF (SQLCA.SQLCODE) THEN
            INSERT INTO pod_file(pod00) VALUES('0')
            CALL cl_err('Parameter setting error:', SQLCA.SQLCODE, 2)
         END IF
         #NO.FUN-670007 start--
 
         LET g_plant_new = g_oaz.oaz02p
         CALL cl_set_dbs_new()
         LET g_gl_dbs = g_dbs_new
 
      WHEN g_sys="AXR" OR g_sys="CXR"
         SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'
         IF (SQLCA.SQLCODE) THEN
            INSERT INTO ooz_file(ooz00) VALUES('0')
            CALL cl_err('Parameter setting error:', SQLCA.SQLCODE, 2)
         END IF
          #No.MOD-4A0075
         SELECT azi03,azi04,azi05,azi07 INTO t_azi03,t_azi04,t_azi05,t_azi07
           FROM azi_file WHERE azi01=g_aza.aza17
          #No.MOD-4A0075(end)
         LET g_plant_new = g_ooz.ooz02p
         CALL cl_set_dbs_new()
         LET g_gl_dbs = g_dbs_new
 
      WHEN g_sys="AXS" OR g_sys="CXS"
         SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00='0'
         IF (SQLCA.SQLCODE) THEN
            INSERT INTO oaz_file(oaz00) VALUES('0')
            CALL cl_err('Parameter setting error:', SQLCA.SQLCODE, 2)
         END IF
 
         LET g_plant_new = g_oaz.oaz02p
         CALL cl_set_dbs_new()
         LET g_gl_dbs = g_dbs_new
 
      WHEN g_sys="GAP" OR g_sys="CGAP"
         IF (NOT cl_set_apz_param()) THEN
           CALL cl_process_logout() #No.CHI-C90042 
           RETURN FALSE
         END IF
 
         LET g_plant_new = g_apz.apz02p
         CALL cl_set_dbs_new()
         LET g_gl_dbs = g_dbs_new
         
         LET g_plant_new = g_apz.apz04p
         CALL cl_set_dbs_new()
         LET g_nm_dbs = g_dbs_new
 
      WHEN g_sys="GGL" OR g_sys="CGGL"
         SELECT * INTO g_aaz.* FROM aaz_file WHERE aaz00='0'
         IF (SQLCA.SQLCODE = 100) THEN
            INSERT INTO aaz_file(aaz00) VALUES('0')
         END IF
          
      WHEN g_sys="GIS" OR g_sys="CGIS"
         SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00='0'
         IF (SQLCA.SQLCODE) THEN
            INSERT INTO oaz_file(oaz00) VALUES('0')
            CALL cl_err('Parameter setting error:', SQLCA.SQLCODE, 2)
         END IF
 
         SELECT * INTO g_isf.* FROM isf_file WHERE isf00='0'  #MOD-590069
         IF (SQLCA.SQLCODE) THEN
            INSERT INTO isf_file(isf00) VALUES('0')
            CALL cl_err('Parameter isf setting error:', SQLCA.SQLCODE, 2)
         END IF
 
         LET g_plant_new = g_oaz.oaz02p
         CALL cl_set_dbs_new()
         LET g_gl_dbs = g_dbs_new
 
      WHEN g_sys="GNM" OR g_sys="CGNM"
         IF (NOT cl_set_nmz_param()) THEN
           CALL cl_process_logout() #No.CHI-C90042 
           RETURN FALSE
         END IF
 
      #-----TQC-B90211---------
      #WHEN g_sys="GPY" OR g_sys="CGPY"
      #   # 2003/09/09 by Hiko : 此段程式與原來的做法不同(有請教苓嘉).
      #   SELECT * INTO g_cpa.* FROM cpa_file WHERE cpa00='0'
      #   IF (SQLCA.SQLCODE = 100) THEN
      #      INSERT INTO cpa_file(cpa00,cpa06,cpa061,cpa07,cpauser,cpagroup,cpadate)
      #                    VALUES('0',YEAR(g_today),MONTH(g_today),'0',g_user,g_grup,g_today)
      #   END IF
      #
      #   IF (NOT cl_setup_err("Parameter setting error")) THEN
      #      RETURN FALSE
      #   END IF
      #-----END TQC-B90211-----
 
      WHEN g_sys="GXR" OR g_sys="CGXR"
         SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'
         IF (SQLCA.SQLCODE) THEN
            INSERT INTO ooz_file(ooz00) VALUES('0')
            CALL cl_err('Parameter setting error:', SQLCA.SQLCODE, 2)
         END IF
 
         LET g_plant_new = g_ooz.ooz02p
         CALL cl_set_dbs_new()
         LET g_gl_dbs = g_dbs_new
 
       #NO.MOD-470600
      WHEN g_sys="GXC" OR g_sys="CGXC"
         IF (NOT cl_set_ccz_param()) THEN
           CALL cl_process_logout() #No.CHI-C90042 
           RETURN FALSE
         END IF
 
      WHEN g_sys="GFA" OR g_sys="CGFA"
         IF (NOT cl_set_aaz_param()) THEN
           CALL cl_process_logout() #No.CHI-C90042 
           RETURN FALSE
         END IF
 
         IF (NOT cl_set_faa_param()) THEN
           CALL cl_process_logout() #No.CHI-C90042 
           RETURN FALSE
         END IF
      #end
       # MOD-490398
      WHEN g_sys="ACO" OR g_sys="CCO"
         IF (NOT cl_set_coz_param()) THEN
           CALL cl_process_logout() #No.CHI-C90042 
           RETURN FALSE
         END IF
        #FUN-930151 add begin
         IF (NOT cl_set_cez_param()) THEN
           CALL cl_process_logout() #No.CHI-C90042
           RETURN FALSE
         END IF
        #FUN-930151 add end
   END CASE
 
   SELECT azi03,azi04,azi05,azi07 INTO g_azi03,g_azi04,g_azi05,g_azi07
     FROM azi_file
    WHERE azi01=g_aza.aza17
 
   #-----No.MOD-580397-----
   SELECT azi03,azi04,azi05,azi07 INTO t_azi03,t_azi04,t_azi05,t_azi07
     FROM azi_file
    WHERE azi01=g_aza.aza17
   #-----No.MOD-580397 END-----
 
# 2004/03/02 hjwang: 重整 zz_file 參數
# 2004/02/23 hjwang: 新增設定 g_win_style@zz_file.zz27
   SELECT zz13,zz14,zz27 INTO g_chkey,g_query,g_win_style
     FROM zz_file WHERE zz01 = g_prog
 
   IF cl_null(g_chkey)     THEN LET g_chkey = "Y"       END IF
   IF cl_null(g_win_style) THEN LET g_win_style = "sm1" END IF
 
# 2004/02/23 hjwang: 單身最大筆數修正至 aza_file.aza34
#     SELECT sma115 INTO g_max_rec FROM sma_file WHERE sma00='0'
 
   #LET g_max_rec = g_aza.aza34  #MOD-D30242
   #IF g_max_rec <= 0 OR cl_null(g_max_rec) THEN LET g_max_rec = 1000 END IF  #MOD-D30242
 
# CKP 
   LET g_show_item_value = TRUE

   #No:FUN-A30020 --start--
   CASE
      # 傳票模組單據編號設定, plantcode依照財務模組設定的legalcode
     #WHEN g_sys = "AGL" OR g_sys = "GGL"                   #MOD-CA0055 mark
      WHEN g_sys = "AGL" OR g_sys = "GGL" OR                #MOD-CA0055 add
           g_sys = "CGL" OR g_sys = "CGGL"                  #MOD-CA0055 add
           LET lc_plantadd = g_aza.aza99
           LET li_plantlen = g_aza.aza100
           LET lc_doc_set = g_aza.aza102
           LET lc_sn_set = g_aza.aza103
      # 財務模組單據編號設定
      WHEN g_sys = "AAP" OR g_sys = "GAP" OR
           g_sys = "CAP" OR g_sys = "CGAP" OR               #MOD-CA0055 add
           g_sys = "AFA" OR g_sys = "GFA" OR
           g_sys = "CFA" OR g_sys = "CGFA" OR               #MOD-CA0055 add
           g_sys = "ANM" OR g_sys = "GNM" OR
           g_sys = "CNM" OR g_sys = "CGNM" OR               #MOD-CA0055 add
           g_sys = "AXR" OR g_sys = "GXR" OR
           g_sys = "CXR" OR g_sys = "CGXR" OR               #MOD-CA0055 add
           g_sys = "AMD" OR g_sys = "GIS" OR
           g_sys = "CMD" OR g_sys = "CGIS"                  #MOD-CA0055 add
           LET lc_plantadd = g_aza.aza99
           LET li_plantlen = g_aza.aza100
           LET lc_doc_set = g_aza.aza41
           LET lc_sn_set = g_aza.aza42
      # 製造模組單據編號設定
      OTHERWISE
         LET lc_plantadd = g_aza.aza97
         LET li_plantlen = g_aza.aza98
         LET lc_doc_set = g_aza.aza41
         LET lc_sn_set = g_aza.aza42
   END CASE
   CASE lc_doc_set
      WHEN "1"   LET g_doc_len = 3
      WHEN "2"   LET g_doc_len = 4
      WHEN "3"   LET g_doc_len = 5
   END CASE
   CASE lc_sn_set
      WHEN "1"   LET g_no_ep = g_doc_len + 1 + 8
      WHEN "2"   LET g_no_ep = g_doc_len + 1 + 9
      WHEN "3"   LET g_no_ep = g_doc_len + 1 + 10
   END CASE
   # 加入Plant Code以後的單號起訖調整
   IF lc_plantadd = "Y" THEN
      LET g_no_sp = g_doc_len + 2
      LET g_sn_sp = g_doc_len + 2 + li_plantlen
      LET g_no_ep = g_no_ep + li_plantlen
   ELSE
      LET g_no_sp = g_doc_len + 2
      LET g_sn_sp = g_no_sp
   END IF

   #FUN-550078
#  CASE g_aza.aza41
#     WHEN "1"   LET g_doc_len = 3
#                LET g_no_sp = 3 + 2
#     WHEN "2"   LET g_doc_len = 4
#                LET g_no_sp = 4 + 2
#     WHEN "3"   LET g_doc_len = 5
#                LET g_no_sp = 5 + 2
#  END CASE
#  CASE g_aza.aza42
#     WHEN "1"   LET g_no_ep = g_doc_len + 1 + 8
#     WHEN "2"   LET g_no_ep = g_doc_len + 1 + 9
#     WHEN "3"   LET g_no_ep = g_doc_len + 1 + 10
#  END CASE
   #No:FUN-A30020 ---end--- 
 
   RETURN TRUE
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 設定程式執行權限.
# Date & Author..: 2003/09/09 by Hiko
# Input parameter: none
# Return code....: void
# Modify ........: 2004/09/16 zxw04 不用拿來選
##################################################
 
FUNCTION cl_set_priv()
   DEFINE   li_count           LIKE type_file.num5    #No.FUN-690005 SMALLINT
   DEFINE   li_count1          LIKE type_file.num5    #No.FUN-690005 SMALLINT    #MOD-620014
   DEFINE   li_count2          LIKE type_file.num5    #No.FUN-690005 SMALLINT    #MOD-620014
   DEFINE   ls_err_msg         STRING,
            li_success         LIKE type_file.num5    #No.FUN-690005 SMALLINT
   DEFINE   lst_act_list       base.StringTokenizer,
            ls_act             STRING,
            lst_tmp_act_list   base.StringTokenizer,
            ls_tmp_act         STRING,
            li_exist           LIKE type_file.num5,   #No.FUN-690005 SMALLINT,
            li_has_detail      LIKE type_file.num5,   #No.FUN-690005 SMALLINT,
            lc_tmp_priv1       LIKE zy_file.zy03,     #暫存使用者執行權限
            lc_tmp_priv2       LIKE zy_file.zy04,     #暫存使用者資料權限
            lc_tmp_priv3       LIKE zy_file.zy05,     #暫存使用部門資料權限
            lc_tmp_priv4       LIKE zy_file.zy06,     #暫存使用者印表權限
            lc_tmp_priv5       LIKE zy_file.zy07,     #暫存使用者單身權限
            lc_char            LIKE type_file.num5,   #No.FUN-690005 VARCHAR(1),
            li_i,li_j          LIKE type_file.num5    #No.FUN-690005 SMALLINT
DEFINE      l_priv4_tag        LIKE type_file.num5    #No.FUN-690005 SMALLINT    #FUN-630099
define      l_action_choice    varchar(40)            #darcy:2024/10/24 add
 
# Save Your Life Function
# Starting
# RETURN TRUE
# Ending
 
   # 2004/09/16 SELECT zxw error
   SELECT COUNT(*) INTO li_count FROM zxw_file WHERE zxw01=g_user
#     AND zxw04=g_prog
 
   IF (li_count = 0) THEN 
      SELECT zy03,zy04,zy05,zy06,zy07
        INTO g_priv1,g_priv2,g_priv3,g_priv4,g_priv5
        FROM zy_file
       WHERE zy01=g_clas AND zy02=g_prog
      display 'clas=',g_clas,' prog=',g_prog
       IF (SQLCA.SQLCODE) THEN                                # MOD-4A0217
         CALL cl_err_msg("", "lib-214",g_user || "|" || g_clas || "|" || g_prog || "|" || g_clas,  3)
 
         RETURN FALSE
      ELSE
         LET g_priv1 = DOWNSHIFT(g_priv1)
         #darcy:2024/10/24 add s---
         let l_action_choice = g_action_choice
         let g_action_choice = "fglrun"
         call cl_setup_record()
         let g_action_choice = l_action_choice
         #darcy:2024/10/24 add e---
         RETURN TRUE
      END IF
   END IF
 
#  #MOD-620014    #MOD-4A0217
#  SELECT COUNT(*) INTO li_count FROM zxw_file, zy_file
#   WHERE zxw01 = g_user
#     AND (( zxw_file.zxw04 = zy_file.zy01 AND zy_file.zy02 = g_prog )
#      OR zxw04 = g_prog )
 
   SELECT COUNT(*) INTO li_count1 FROM zxw_file, zy_file
    WHERE zxw01 = g_user
      AND zxw_file.zxw04 = zy_file.zy01 AND zy_file.zy02 = g_prog
 
   SELECT COUNT(*) INTO li_count2 FROM zxw_file
    WHERE zxw01 = g_user AND zxw04 = g_prog
 
   LET li_count = li_count1 + li_count2
 
   IF li_count <=0 THEN
      CALL cl_err_msg("", "lib-214",g_user || "|" || g_clas || "|" || g_prog || "|" || g_clas,  3)
 
      RETURN FALSE
   END IF
 
   DECLARE lcurs_auth CURSOR
       FOR SELECT zy03,zy04,zy05,zy06,zy07
             FROM zy_file,zxw_file
            WHERE zy01=zxw04 AND zxw01=g_user AND zy02=g_prog AND zxw03='1'
           UNION
           SELECT zxw05,zxw06,zxw07,' ',zxw08
             FROM zz_file,zxw_file
            WHERE zz01=zxw04 AND zxw01=g_user AND zxw04=g_prog AND zxw03='2'
   IF STATUS OR SQLCA.SQLCODE THEN
      CALL cl_err('Select auth Error:',STATUS,1)  #MOD-5A0326
   END IF
 
   LET l_priv4_tag = 0                          #FUN-630099
 
   FOREACH lcurs_auth
      INTO lc_tmp_priv1,lc_tmp_priv2,lc_tmp_priv3,lc_tmp_priv4,lc_tmp_priv5
      LET lc_tmp_priv1 = DOWNSHIFT(lc_tmp_priv1)
      IF (lc_tmp_priv1 IS NOT NULL) THEN
         IF (g_priv1 IS NULL) THEN
            LET g_priv1 = lc_tmp_priv1
         ELSE
            LET lst_tmp_act_list = base.StringTokenizer.create(lc_tmp_priv1 CLIPPED, ",")
            LET lst_act_list = base.StringTokenizer.create(g_priv1 CLIPPED, ",")
 
            WHILE lst_tmp_act_list.hasMoreTokens()
               LET li_exist = FALSE
               LET li_has_detail = FALSE
 
               LET ls_tmp_act = lst_tmp_act_list.nextToken()
               LET ls_tmp_act = ls_tmp_act.trim()
               
               WHILE lst_act_list.hasMoreTokens()
                  LET ls_act = lst_act_list.nextToken()
                  LET ls_act = ls_act.trim()
                  # 2003/10/07 by Hiko : 假如可執行的Action已經存在,就跳出迴圈.
                  IF (ls_act.equals(ls_tmp_act)) THEN
                     LET li_exist = TRUE
                     EXIT WHILE
#                 
 #                 ELSE  #MOD-530097
#                    # 2003/10/07 by Hiko : 判斷是否有"detail"權限.
#                    IF ((ls_tmp_act.getIndexOf("detail", 1) > 0)) THEN
#                       # 2003/10/07 by Hiko : 為了避免重複新增,因此將li_exist設為TRUE.
#                       LET li_exist = TRUE
#                       IF (ls_act.getIndexOf("detail", 1) > 0) THEN
#                          LET li_has_detail = TRUE
#                          LET g_priv1 = cl_replace_str(g_priv1, ls_act, cl_get_detail_act_setting(ls_act, ls_tmp_act))
#                       END IF
#                    END IF
                  END IF
               END WHILE
 
#              #MOD-530097
               IF ((NOT li_exist) AND (NOT li_has_detail)) THEN
                  IF NOT cl_null(g_priv1) THEN
                     LET g_priv1 = g_priv1 CLIPPED || "," || ls_tmp_act
                  ELSE
                     LET g_priv1 = ls_tmp_act
                  END IF
               END IF
            END WHILE
         END IF
      END IF
 
#TQC-5A0020 #MOD-4B0130
      IF NOT cl_null(lc_tmp_priv2) THEN
         IF cl_null(g_priv2) THEN
            LET g_priv2 = lc_tmp_priv2 CLIPPED
         ELSE
#           IF (lc_tmp_priv2 < g_priv2) THEN
#              LET g_priv2 = lc_tmp_priv2 CLIPPED
#           END IF
            CASE
               WHEN lc_tmp_priv2 = g_priv2 
                  LET g_priv2 = lc_tmp_priv2 CLIPPED
               WHEN lc_tmp_priv2 = "0" OR g_priv2 = "0"
                  LET g_priv2 = "0"
               WHEN lc_tmp_priv2 = "1" 
                  CASE g_priv2 
                     WHEN "2" LET g_priv2 = "0"
                    #------------No.MOD-7B0137 modify
                     WHEN "3" LET g_priv2 = "1"
                     WHEN "4" LET g_priv2 = "1"
                    #------------No.MOD-7B0137 mend
                  END CASE
               WHEN lc_tmp_priv2 = "2" 
                  CASE g_priv2 
                     WHEN "1" LET g_priv2 = "0"
                    #------------No.MOD-7B0137 modify
                     WHEN "3" LET g_priv2 = "2"
                     WHEN "4" LET g_priv2 = "2"
                    #------------No.MOD-7B0137 mend
                  END CASE
               WHEN lc_tmp_priv2 = "3"
                  CASE g_priv2 
                     WHEN "1" LET g_priv2 = "1"
                     WHEN "2" LET g_priv2 = "2"
                     WHEN "4" LET g_priv2 = "3"
                  END CASE
               WHEN lc_tmp_priv2 = "4"
                  LET g_priv2 = g_priv2 CLIPPED
               OTHERWISE
                  LET g_priv2 = lc_tmp_priv2 CLIPPED
            END CASE
         END IF
      END IF      
 
      IF NOT cl_null(lc_tmp_priv3) THEN
         IF cl_null(g_priv3) THEN
            LET g_priv3 = lc_tmp_priv3 CLIPPED
         ELSE
#           IF (lc_tmp_priv3 < g_priv3) THEN
#              LET g_priv3 = lc_tmp_priv3 CLIPPED
#           END IF
            CASE
               WHEN lc_tmp_priv3 = g_priv3 
                  LET g_priv3 = lc_tmp_priv3 CLIPPED
               WHEN lc_tmp_priv3 = "0" OR g_priv3 = "0"
                  LET g_priv3 = "0"
               WHEN lc_tmp_priv3 = "1" 
                  CASE g_priv3 
                    #------------No.MOD-7B0137 modify
                     WHEN "2" LET g_priv3 = "0"
                     WHEN "6" LET g_priv3 = "0"
                     WHEN "8" LET g_priv3 = "0"
                     WHEN "3" LET g_priv3 = "1"
                     WHEN "4" LET g_priv3 = "1"
                     WHEN "5" LET g_priv3 = "1"
                     WHEN "7" LET g_priv3 = "1"
                    #------------No.MOD-7B0137 end
                  END CASE
               WHEN lc_tmp_priv3 = "2" 
                  CASE g_priv3 
                    #------------No.MOD-7B0137 modify
                     WHEN "1" LET g_priv3 = "0"
                     WHEN "5" LET g_priv3 = "0"
                     WHEN "8" LET g_priv3 = "0"
                     WHEN "3" LET g_priv3 = "2"
                     WHEN "4" LET g_priv3 = "2"
                     WHEN "6" LET g_priv3 = "2"
                     WHEN "7" LET g_priv3 = "2"
                    #------------No.MOD-7B0137 end
                  END CASE
               WHEN lc_tmp_priv3 = "3"
                  CASE g_priv3 
                    #------------No.MOD-7B0137 modify
                     WHEN "1" LET g_priv3 = "1"
                     WHEN "5" LET g_priv3 = "1"
                     WHEN "2" LET g_priv3 = "2"
                     WHEN "6" LET g_priv3 = "2"
                     WHEN "4" LET g_priv3 = "3"
                     WHEN "7" LET g_priv3 = "3"
                    #------------No.MOD-7B0137 modify
                     WHEN "8" LET g_priv3 = "0"
                  END CASE
               WHEN lc_tmp_priv3 = "4"
                  LET g_priv3 = g_priv3 CLIPPED
               WHEN lc_tmp_priv3 = "5"
                  CASE g_priv3 
                     WHEN "2" LET g_priv3 = "0"
                    #------------No.MOD-7B0137 modify
                     WHEN "1" LET g_priv3 = "1"
                     WHEN "3" LET g_priv3 = "1"
                     WHEN "6" LET g_priv3 = "8"
                     WHEN "8" LET g_priv3 = "8"
                     WHEN "4" LET g_priv3 = "5"
                     WHEN "7" LET g_priv3 = "5"
                    #------------No.MOD-7B0137 end
                  END CASE
               WHEN lc_tmp_priv3 = "6"
                  CASE g_priv3 
                     WHEN "1" LET g_priv3 = "0"
                    #------------No.MOD-7B0137 modify
                     WHEN "2" LET g_priv3 = "2"
                     WHEN "3" LET g_priv3 = "2"
                     WHEN "5" LET g_priv3 = "8"
                     WHEN "8" LET g_priv3 = "8"
                     WHEN "4" LET g_priv3 = "6"
                     WHEN "7" LET g_priv3 = "6"
                    #------------No.MOD-7B0137 end
                  END CASE
               WHEN lc_tmp_priv3 = "7"
                  IF g_priv3 = "4" THEN
                     LET g_priv3 = "7"
                  ELSE
                     LET g_priv3 = g_priv3 CLIPPED
                  END IF
               WHEN lc_tmp_priv3 = "8"
                  CASE g_priv3 
                    #------------No.MOD-7B0137 modify
                     WHEN "1" LET g_priv3 = "0"
                     WHEN "2" LET g_priv3 = "0"
                     WHEN "3" LET g_priv3 = "0"
                    #------------No.MOD-7B0137 end
                     OTHERWISE LET g_priv3 = "8"
                  END CASE
               OTHERWISE
                  LET g_priv3 = lc_tmp_priv3 CLIPPED
            END CASE
         END IF
      END IF
#TQC-5A0020 
 
#     #TQC-5A0094
      IF NOT cl_null(lc_tmp_priv4) THEN
         IF cl_null(g_priv4) THEN
#FUN-630099 
#          LET g_priv4 = ""                        #TQC-5A0094
           IF l_priv4_tag = 0 THEN
              LET g_priv4 = lc_tmp_priv4 CLIPPED      #TQC-5A0094  
           END IF
#END FUN-630099 
         ELSE
#          FOR li_i = 1 TO LENGTH(g_priv4)                       
           FOR li_i = 1 TO LENGTH(lc_tmp_priv4)    #FUN-5C0057  
               LET lc_char = lc_tmp_priv4[li_i,li_i]
               IF (lc_char IS NULL) THEN
                  CONTINUE FOR
               END IF
 
               FOR li_j = 1 TO 20                          #FUN-630099
                  IF (g_priv4[li_j,li_j] = lc_char) THEN
                     EXIT FOR
                  END IF
 
                  IF (g_priv4[li_j,li_j] IS NULL) THEN
                     LET g_priv4[li_j,li_j] = lc_char
                     EXIT FOR
                  END IF
               END FOR
            END FOR
         END IF
      ELSE                    #TQC-5A0094       
         LET g_priv4 = ""     #TQC-5A0094       
         LET l_priv4_tag = 1                          #FUN-630099
      END IF
      
      IF NOT cl_null(lc_tmp_priv5) THEN   #TQC-5A0020
         IF cl_null(g_priv5) THEN
            LET g_priv5 = lc_tmp_priv5 CLIPPED
         ELSE
#           IF (lc_tmp_priv5 < g_priv5) THEN
#              LET g_priv5 = lc_tmp_priv5 CLIPPED
#           END IF
            CASE
               WHEN lc_tmp_priv5 = g_priv5 
                  LET g_priv5 = lc_tmp_priv5 CLIPPED
               WHEN lc_tmp_priv5 = "0" OR g_priv5 = "0"
                  LET g_priv5 = "0"
               WHEN lc_tmp_priv5 = "1" AND g_priv5 = "2"
                  LET g_priv5 = "0"
               WHEN lc_tmp_priv5 = "2" AND g_priv5 = "1"
                  LET g_priv5 = "0"
               WHEN lc_tmp_priv5 = "3"
                  LET g_priv5 = g_priv5 CLIPPED
               WHEN g_priv5 = "3"
                  LET g_priv5 = lc_tmp_priv5 CLIPPED
               OTHERWISE
                  LET g_priv5 = lc_tmp_priv5 CLIPPED
            END CASE
         END IF
      END IF      
   END FOREACH
   #darcy:2024/10/24 add s---
   let l_action_choice = g_action_choice
   let g_action_choice = "fglrun"
   call cl_setup_record()
   let g_action_choice = l_action_choice
   #darcy:2024/10/24 add e---
   RETURN TRUE
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 抓取"detail"的權限設定.
# Date & Author..: 2003/10/07 by Hiko
# Input Parameter: ps_detail       STRING   來源資料
#                  ps_tmp_detail   STRING   判斷資料
# Return code....: SMALLINT   設定是否成功
##################################################
 
FUNCTION cl_get_detail_act_setting(ps_detail, ps_tmp_detail)
   DEFINE   ps_detail                   STRING,
            ps_tmp_detail               STRING
   DEFINE   li_left_square_bracket      LIKE type_file.num5,   #No.FUN-690005 SMALLINT,
            li_right_square_bracket     LIKE type_file.num5,   #No.FUN-690005 SMALLINT,
            li_normal                   LIKE type_file.num5,   #No.FUN-690005 SMALLINT,
            ls_detail_act_setting       STRING,
            lc_insert_setting           LIKE type_file.chr1,   #No.FUN-690005 VARCHAR(1),
            lc_delete_setting           LIKE type_file.chr1,   #No.FUN-690005 VARCHAR(1),
            ls_tmp_detail_act_setting   STRING
 
 
   LET li_normal = TRUE
 
   # 2003/10/07 by Hiko : 因為"detail"的長度為6,因此從第7個位置開始找尋左右中括號([,]).
   LET li_left_square_bracket = ps_detail.getIndexOf("[", 7)         
   IF (li_left_square_bracket > 0) THEN
      LET li_right_square_bracket = ps_detail.getIndexOf("]", 7)
      IF (li_right_square_bracket > 0) THEN
         LET ls_detail_act_setting = ls_detail_act_setting.subString(li_left_square_bracket+1, li_left_square_bracket-1)
      ELSE
         LET li_normal = FALSE
      END IF 
   ELSE
      LET li_normal = FALSE
   END IF
 
   # 2003/10/08 by Hiko : 若是來源資料格式有問題,則回傳預設的資料格式.
   IF (NOT li_normal) THEN
      RETURN "detail[yy]"
   END IF
 
   LET li_left_square_bracket = ps_tmp_detail.getIndexOf("[", 7)         
   IF (li_left_square_bracket > 0) THEN
      LET li_right_square_bracket = ps_tmp_detail.getIndexOf("]", 7)
      IF (li_right_square_bracket > 0) THEN
         LET ls_tmp_detail_act_setting = ls_tmp_detail_act_setting.subString(li_left_square_bracket+1, li_left_square_bracket-1)
      ELSE
         LET li_normal = FALSE
      END IF
   ELSE
      LET li_normal = FALSE
   END IF
   
   # 2003/10/08 by Hiko : 若是判斷資料格式有問題,則回傳來源資料.
   IF (NOT li_normal) THEN
      RETURN ps_detail
   END IF
   
   LET lc_insert_setting = ls_detail_act_setting.getCharAt(1)
   IF (lc_insert_setting = 'n') THEN
      # 2003/10/08 by Hiko : 因為聯集的關係,所以在"insert"為'n'時才要判斷.
      LET lc_insert_setting = ls_tmp_detail_act_setting.getCharAt(1)
   END IF
 
   LET lc_delete_setting = ls_detail_act_setting.getCharAt(2)
   IF (lc_delete_setting = 'n') THEN
      # 2003/10/08 by Hiko : 因為聯集的關係,所以在"delete"為'n'時才要判斷.
      LET lc_delete_setting = ls_tmp_detail_act_setting.getCharAt(2)
   END IF
 
   LET ps_detail = "detail[" || lc_insert_setting || lc_delete_setting || "]"
 
   RETURN ps_detail
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 設定g_aaz.
# Date & Author..: 2003/09/08 by Hiko
# Input Parameter: none
# Return code....: SMALLINT   設定是否成功
##################################################
 
FUNCTION cl_set_aaz_param()
   SELECT * INTO g_aaz.* FROM aaz_file WHERE aaz00='0'
   RETURN cl_setup_err("Parameter setting error")
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 設定g_apz.
# Date & Author..: 2003/09/08 by Hiko
# Input Parameter: none
# Return code....: SMALLINT   設定是否成功
##################################################
 
FUNCTION cl_set_apz_param()
   SELECT * INTO g_apz.* FROM apz_file WHERE apz00='0'
   RETURN cl_setup_err("Parameter setting error")
END FUNCTION
 
 
##################################################
# Private Func...: TRUE
# Descriptions...: 設定g_aza.
# Date & Author..: 2003/09/08 by Hiko
# Input Parameter: none
# Return code....: SMALLINT   設定是否成功
##################################################
 
FUNCTION cl_set_aza_param()
   SELECT * INTO g_aza.* FROM aza_file WHERE aza01='0'
   RETURN cl_setup_err("Parameter setting error")
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 設定g_bgz.
# Date & Author..: 2003/09/08 by Hiko
# Input Parameter: none
# Return code....: SMALLINT   設定是否成功
##################################################
 
FUNCTION cl_set_bgz_param()
   SELECT * INTO g_bgz.* FROM bgz_file WHERE bgz00='0'
   RETURN cl_setup_err("Parameter setting error")
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 設定g_ccz.
# Date & Author..: 2003/09/08 by Hiko
# Input Parameter: none
# Return code....: SMALLINT   設定是否成功
##################################################
 
FUNCTION cl_set_ccz_param()
   SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
   RETURN cl_setup_err("Parameter setting error")
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 設定g_faa.
# Date & Author..: 2003/09/08 by Hiko
# Input Parameter: none
# Return code....: SMALLINT   設定是否成功
##################################################
 
FUNCTION cl_set_faa_param()
   SELECT * INTO g_faa.* FROM faa_file WHERE faa00='0'
   RETURN cl_setup_err("Parameter setting error")
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 設定g_mmd.
# Date & Author..: 2003/09/08 by Hiko
# Input Parameter: none
# Return code....: SMALLINT   設定是否成功
##################################################
 
FUNCTION cl_set_mmd_param()
   SELECT * INTO g_mmd.* FROM mmd_file WHERE mmd00='0'
   RETURN cl_setup_err("Parameter setting error")
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 設定g_nmz.
# Date & Author..: 2003/09/08 by Hiko
# Input Parameter: none
# Return code....: SMALLINT   設定是否成功
##################################################
 
FUNCTION cl_set_nmz_param()
   SELECT * INTO g_nmz.* FROM nmz_file WHERE nmz00='0'
   RETURN cl_setup_err("Parameter setting error")
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 設定g_qcz.
# Date & Author..: 2003/09/08 by Hiko
# Input Parameter: none
# Return code....: SMALLINT   設定是否成功
##################################################
 
FUNCTION cl_set_qcz_param()
   SELECT * INTO g_qcz.* FROM qcz_file WHERE qcz00='0'
   RETURN cl_setup_err("Parameter setting error")
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 設定g_rmz.
# Date & Author..: 2003/09/08 by Hiko
# Input Parameter: none
# Return code....: SMALLINT   設定是否成功
##################################################
 
FUNCTION cl_set_rmz_param()
   SELECT * INTO g_rmz.* FROM rmz_file
   RETURN cl_setup_err("Parameter setting error")
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 設定g_sma.
# Date & Author..: 2003/09/08 by Hiko
# Input Parameter: none
# Return code....: SMALLINT   設定是否成功
##################################################
 
FUNCTION cl_set_sma_param()
   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
   RETURN cl_setup_err("Parameter setting error")
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 設定g_coz.
# Date & Author..: 2003/09/08 by Hiko
# Input Parameter: none
# Return code....: SMALLINT   設定是否成功
# Modify.........: 04/11/01 MOD-490398 danny
##################################################
 
FUNCTION cl_set_coz_param()
   SELECT * INTO g_coz.* FROM coz_file WHERE coz00='0'
   RETURN cl_setup_err("Parameter setting error")
END FUNCTION
 
#FUN-930151 add begin
##################################################
# Private Func...: TRUE
# Descriptions...: 設定g_cez.
# Date & Author..: 2009/04/08 by Rainy
# Input Parameter: none
# Return code....: SMALLINT   設定是否成功
##################################################
 
FUNCTION cl_set_cez_param()
   SELECT * INTO g_cez.* FROM cez_file WHERE cez00='0'
   RETURN cl_setup_err("Parameter setting error")
END FUNCTION
#FUN-930151 add end
 
##################################################
# Private Func...: TRUE
# Descriptions...: 檢查參數設定是否成功.
# Date & Author..: 2003/09/08 by Hiko
# Input Parameter: ps_title   STRING   錯誤訊息視窗Title
# Return code....: SMALLINT   設定是否成功
##################################################
 
FUNCTION cl_setup_err(ps_title)
   DEFINE   ps_title   STRING
 
 
   IF (SQLCA.SQLCODE) THEN
      #CALL cl_err_msg("Parameter setting error", SQLCA.SQLCODE, NULL)
      CALL cl_err("Parameter setting error:", SQLCA.SQLCODE, 2)
      RETURN FALSE
   END IF
 
   RETURN TRUE
END FUNCTION
 
##################################################
# Private Func...: TRUE
# Descriptions...: 設定g_dbs_new
# Date & Author..: 2003/09/08 by Hiko
# Input Parameter: none
# Return code....: void
# Modify.........: No.FUN-7C0042 07/12/13 By alex 修改說明及db串接符號
##################################################
 
FUNCTION cl_set_dbs_new()
   IF (g_plant_new = g_plant) THEN
      LET g_dbs_new = NULL
   ELSE
      SELECT azp03 INTO g_dbs_new FROM azp_file WHERE azp01=g_plant_new
      IF (SQLCA.SQLCODE) THEN
         LET g_dbs_new = NULL
      ELSE
#       LET g_dbs_new[21,21] = ':'           #FUN-7B0013
        CASE cl_db_get_database_type()
           WHEN "ORA"
              LET g_dbs_new = g_dbs_new CLIPPED,'.'
           WHEN "IFX"
              LET g_dbs_new = g_dbs_new CLIPPED,':'
           WHEN "MSV"   #FUN-820017
              LET g_dbs_new = FGL_GETENV("MSSQLAREA") CLIPPED,"_",g_dbs_new CLIPPED,".dbo."
           WHEN "ASE"   #FUN-AA0017
              LET g_dbs_new = g_dbs_new CLIPPED,".dbo."
           OTHERWISE
              LET g_dbs_new = g_dbs_new CLIPPED,'.'
        END CASE
      END IF
   END IF
END FUNCTION
 
##################################################
# Descriptions...: 回傳一個資料庫形態判別字串
# Date & Author..: 2007/12/13 by alex
# Input Parameter: none
# Return code....: db_type VARCHAR(3)  ORA,IFX,MSV
# Modify.........: No.FUN-7C0042
##################################################
 
FUNCTION cl_db_get_database_type()
   DEFINE l_sid01 like sid_file.sid01

   IF mc_db_type IS NULL OR mc_db_type = "" THEN
      LET mc_db_type = db_get_database_type()
   END IF
 
   RETURN mc_db_type
 
END FUNCTION
 
##################################################
# Descriptions...: 回傳一個作業系統判別字串
# Date & Author..: 08/01/16 by alex
# Input Parameter: none
# Return code....: db_type VARCHAR(3)  AIX,LNX,HPX,SUN,WIN
##################################################
 
FUNCTION cl_get_os_type()
 
   DEFINE ls_ostype   STRING
   DEFINE lch_cmd     base.Channel
 
   IF ms_os_type IS NULL OR ms_os_type = "" THEN
      LET lch_cmd = base.Channel.create()
      CALL lch_cmd.openPipe("uname -s", "r")
      WHILE lch_cmd.read(ls_ostype)
      END WHILE
      CALL lch_cmd.close()
      LET ls_ostype = ls_ostype.toUpperCase()
      CASE
          WHEN ls_ostype MATCHES "AIX*"     LET ms_os_type = "AIX"
          WHEN ls_ostype MATCHES "LINUX*"   LET ms_os_type = "LINUX"
          WHEN ls_ostype MATCHES "HP-UX*"   LET ms_os_type = "HP-UX"
          WHEN ls_ostype MATCHES "SUNOS*"   LET ms_os_type = "SUNOS"
          WHEN ls_ostype MATCHES "WINDOWS*" LET ms_os_type = "WINDOWS"
      END CASE
   END IF
 
   RETURN ms_os_type
 
END FUNCTION
 
##################################################
# Descriptions...: 回傳一個TIPTOP GP Server主機IP位址字串
# Date & Author..: 08/02/22 by alex
# Input Parameter: none
# Return code....: ls_server_ip STRING 
##################################################
 
FUNCTION cl_get_tpserver_ip()    #FUN-820041
 
   DEFINE lc_aza58     LIKE aza_file.aza58
   DEFINE ls_serverip  STRING
 
   #FUN-CA0071 start
   IF NOT cl_null(FGL_GETENV("WEBAREA")) THEN
      LET ls_serverip = FGL_GETENV("FGLASIP")
   ELSE
      SELECT aza58 INTO lc_aza58 FROM aza_file WHERE aza01="0"
      LET ls_serverip = DOWNSHIFT(lc_aza58) CLIPPED
   END IF
   #FUN-CA0071 end
 
   IF ls_serverip IS NULL OR ls_serverip = " " THEN
      LET ls_serverip = "127.0.0.1"
   ELSE
      IF ls_serverip.getIndexOf("http://",1) THEN
         LET ls_serverip = ls_serverip.subString(ls_serverip.getIndexOf("http://",1)+7,ls_serverip.getLength())
      END IF
      IF ls_serverip.getIndexOf("/",1) THEN
         LET ls_serverip = ls_serverip.subString(1,ls_serverip.getIndexOf("/",1)-1)
      END IF
 
      #FUN-8A0138 去除冒號以後的字串
      IF ls_serverip.getIndexOf(":",1) THEN
         LET ls_serverip = ls_serverip.subString(1,ls_serverip.getIndexOf(":",1)-1)
      END IF
 
      IF ls_serverip.getLength() < 7 THEN
         LET ls_serverip = "127.0.0.1"
      END IF
   END IF
 
   RETURN ls_serverip.trim()
 
END FUNCTION

#--FUN-960137--start--
##################################################
# Descriptions...: 回傳目前環境區域
# Date & Author..: 09/06/18 by Vicky
# Input Parameter: none
# Return code....: l_env STRING
##################################################

FUNCTION cl_get_env()
  DEFINE l_env    STRING,
         l_dbtype STRING

  LET l_dbtype = cl_db_get_database_type()

  #FUN-CC0076 start
  IF NOT cl_null(FGL_GETENV("WEBAREA")) THEN
     RETURN FGL_GETENV("WEBAREA")
  END IF
  #FUN-CC0076 end

  CASE l_dbtype
    WHEN "ORA" LET l_env = FGL_GETENV("ORACLE_SID")
    WHEN "IFX" LET l_env = FGL_GETENV("INFORMIXSERVER")
    WHEN "MSV" LET l_env = FGL_GETENV("MSSQLAREA")
    WHEN "ASE" LET l_env = FGL_GETENV("DSQUERY")        #FUN-AA0017
    OTHERWISE  LET l_env = " "
  END CASE

  RETURN l_env
END FUNCTION
#--FUN-960137--end--

#--FUN-B20029--start--
#[
# Description....: 取得 TIPTOP 產品版本
# Date & Author..: 2011/03/18 by Echo
# Parameter......: none
# Return.........: l_str     - STRING     - TIPTOP 產品版本
# Memo...........:
# Modify.........:
#   
#]  
FUNCTION cl_get_tp_version()
DEFINE ls_each                STRING
DEFINE l_cmd                  base.Channel
DEFINE l_str                  STRING

    #讀取4gl的第一行程式版本資訊，如: 5.25 
    LET l_cmd = base.Channel.create()
    #CALL l_cmd.openPipe("cat $AZZ/4gl/p_zx.4gl | grep 'Prog.'", "r")           #FUN-C90025
    CALL l_cmd.openPipe("cat $LIB/4gl/cl_setup.4gl | grep 'Prog.'", "r")        #FUN-C90025
    WHILE l_cmd.read(ls_each)
       LET l_str = ls_each.subString(ls_each.getIndexOf("'",1)+1,ls_each.getIndexOf("-",1))
       LET l_str = l_str.subString(1,l_str.getIndexOf(".",l_str.getIndexOf(".",1)+1)-1)
       EXIT WHILE
    END WHILE
    CALL l_cmd.close()   #MOD-D30242
    RETURN l_str
END FUNCTION
#--FUN-B20029--end--
#darcy:2024/10/23 add s---
private function cl_setup_record()
   define l_zxa   record like zxa_file.*
   define l_sql   string
   define l_zxa01 varchar(40)
   define l_zxd01 varchar(40)
   define l_cnt   integer

   let l_zxd01 = g_action_choice
   select count(1) into l_cnt from zxd_file where zxd01 = l_zxd01
   if l_cnt = 0 then
      return
   end if

   initialize l_zxa.* to null

   let l_zxa.zxa03 = g_prog
   let l_zxa.zxa04 = g_action_choice
   let l_zxa.zxa07 = g_today
   let l_zxa.zxa08 = current hour to second

   let l_zxa.zxa01 = g_user
   let l_zxa.zxa02 = '1'
   #  人员 + 作业权限 记录
   insert into zxa_file values (l_zxa.*)

   let l_sql = "select zy01 from zy_file ",
               " where zy01 in ( ",
               " select zx04 from zx_file where zx01 = '",g_user,"'",
               " union select zxw04 from zxw_file where zxw01 = '",g_user,"' and zxw03 ='1'",
               " ) and zy02 = '",g_prog,"' " 

   declare zxa_ins2 cursor from l_sql
   foreach zxa_ins2 into l_zxa01
      if sqlca.sqlcode then
         # call cl_err("zxa_ins1",sqlca.sqlcode,1)
         exit foreach
      end if
      let l_zxa.zxa01 = l_zxa01
      let l_zxa.zxa02 = '2'
      # 权限类型 + 作业权限 记录
      insert into zxa_file values (l_zxa.*)
   end foreach

end function
#darcy:2024/10/23 add e---
