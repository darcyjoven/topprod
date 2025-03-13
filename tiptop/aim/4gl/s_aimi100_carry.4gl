# Prog. Version..: '5.30.06-13.03.28(00010)'     #
#
# Program name...: s_aimi100_carry.4gl
# Descriptions...: 料件資料整批拋轉
# Date & Author..: 08/01/24 By Carrier FUN-7C0010
# Usage..........: CALL s_aimi100_carry(p_ima,p_azp,p_gev04)
# Input PARAMETER: p_ima 拋轉TABLE LIST (DYNAMIC ARRAY)
#                  p_azp    拋轉至DB 清單 (DYNAMIC ARRAY)
#                  p_gev04  資料中心代碼
# Modify.........: No.MOD-810229 08/03/23 By Pengu 工程圖檔無法拋轉至料件基本檔
# Modify.........: FUN-830090 08/03/24 By Carrier add upload logical
# Modify.........: NO.FUN-840018 08/04/03 BY Yiting aimi150納入aooi602規則處理
# Modify.........: No.MOD-840117 08/04/15 By claire 拋轉資料時,若沒選擇DB不應更新單據為已拋轉
# Modify.........: NO.FUN-840033 08/04/17 BY Yiting 未拋轉成功時不寄發通知郵件
# Modify.........: no.FUN-840090 08/04/20 by yiting 依gew03設定拋.
# Modify.........: no.MOD-840158 08/04/20 by yiting 資料拋轉建議選擇與Exist欄位預設為N，且營運中心開窗無效。
# Modify.........: No.MOD-840392 08/04/21 By Carrier 修改拋轉DB INPUT功能
# Modify.........: No.MOD-840397 08/04/21 By Carrier 拋轉時以接收端的料件分群碼帶出當地預設資料,不以拋轉端資料直接帶入
# Modify.........: No.FUN-840160 08/04/23 By Nicola 加入批/序號拋轉
# Modify.........: No.FUN-840194 08/06/25 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.CHI-870044 08/08/01 By Smapmin 資料拋轉不應只限20個DB
# Modify.........: No.CHI-860003 08/08/14 By sherry 過濾掉不存在p_zxy的DB
# Modify.........: No.CHI-890001 08/09/19 By claire 拋轉資料時,應以目的資料庫的分群碼做default
# Modify.........: No.MOD-8A0257 08/10/29 By claire 拋轉資料時,若為本站時,不需重帶imz_file
# Modify.........: No.FUN-930108 09/03/25 By zhaijie修改i150_dbs_ins(),增加欄位imaa926
# Modify.........: No.MOD-950012 09/05/05 By lutingting insert ima_file時,加入ima150,ima151,ima152
# Modify.........: No.MOD-950038 09/05/06 By lilingyu 程式里使用EXECUTE的部分,應搭配PREPARE使用，而不該用DECLARE CURSOR  
# Modify.........: No.TQC-940177 09/05/11 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法  
# Modify.........: No.FUN-950007 09/05/12 By sabrina 跨主機資料拋轉，shell手工調整
# Modify.........: No.FUN-960007 09/06/02 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.MOD-980161 09/08/20 By Smapmin EXECUTE之前不可有DECLARE的語法
# Modify.........: No.TQC-980264 09/08/26 By lilingyu 系統采用料件申請和自動編碼功能,在aooi600中有料件,但是"拋轉設置"中沒有設置任何值,點擊aimi150作業中的"資料拋轉",系統提示拋轉成功,并更新狀況碼為"已拋轉",但是在aimi100卻查不到此筆料號
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-870100 09/09/02 By Cockroach insert ima_file時,加入ima154,ima155 
# Modify.........: No.FUN-980059 09/09/15 By arman  GP5.2架構,修改SUB相關傳入參數 
# Modify.........: No.MOD-990247 09/09/29 By Smapmin 判斷主/次帳別,應抓取目的端的資料
# Modify.........: No.FUN-960186 09/10/13 By jan 自動拋轉時，錯誤提示方式修
# Modify.........: No.TQC-9A0125 09/10/26 By xiaofeizhu 標準SQL修改
# Modify.........: NO.FUN-9A0092 09/10/30 By baofei GP5.2資料中心修改 
# Modify.........: NO.TQC-9B0003 09/11/02 By Carrier SQL STANDARDIZE
# Modify.........: No:MOD-9B0002 09/11/06 By Pengu 用web連線執行資料下載，會出現錯誤訊息
# Modify.........: No:CHI-950017 09/11/27 By sabrina 料件申請選擇修改時會判斷無前申請單而無法選擇拋轉營運中心
# Modify.........: No:MOD-950117 09/11/27 By sabrina 資料拋轉時應用目的端的料件分群碼default相關欄位
# Modify.........: No:FUN-9C0072 09/12/16 By vealxu 精簡程式碼
# Modify.........: No.TQC-A10060 10/01/09 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位
# Modify.........: No:MOD-A20098 10/02/25 By Sarah 延續MOD-950117,aimi100與aimi150拋轉時不詢問aim-010,均直接default目的端的料件分群碼相關欄位
# Modify.........: No.FUN-A40023 10/03/22 By dxfwo ima26x改
# Modify.........: No:CHI-A50006 10/05/12 By Summer 增加拋轉圖檔
# Modify.........: No.FUN-A50102 10/06/08 By lutingtingGP5.3集團架構優化:跨庫統一改為使用cl_get_target_table()實现
# Modify.........: No:CHI-A60011 10/07/26 By Summer 在拋轉資料前,將該Lock的Table都先做Lock,確定資料沒被其他人Lock住才能做拋轉
# Modify.........: No:MOD-A30102 10/07/27 By Pengu l_imaano變數沒有使用，所mark抓取imaano的SQL
# Modify.........: No:MOD-A50071 10/07/30 By Smapmin MOD-840117
# Modify.........: No:FUN-A80036 10/08/11 By Carrier 资料抛转时,使用的中间表变成动态表名
# Modify.........: No.FUN-950057 10/09/02 By vealxu gew03 = '1'時,確認時自動拋轉
# Modify.........: No.FUN-A90049 10/09/25 By vealxu ima_file加一料件性質ima120
# Modify.........: No.FUN-AB0011 10/11/03 By vealxu 資料拋轉不成功
# Modify.........: No.MOD-AB0077 10/11/09 By sabrina INSERT INTO ima_file少了ima022,ima156,ima158,ima927
# Modify.........: No.TQC-AC0147 10/12/13 By jan 拋轉成功后提示信息用中文顯示
# Modify.........: No.TQC-B30008 10/12/13 By destiny INSERT INTO ima_file少了ima251
# Modify.........: No.FUN-B30043 11/03/12 By shenyang 在aimi150中添加icd行業別
# Modify.........: No.FUN-B30156 11/03/21 By shenyang 修改aimi150 資料拋磚問題
# Modify.........: No.FUN-9C0141 11/04/28 By shenyang  添加imaa153欄位 
# Modify.........: No.FUN-B50106 11/05/20 By lixh1 修改行業別邏輯
# Modify.........: No:TQC-B60316 11/06/28 By JoHung 資料拋轉為update時，單位相關欄位從來源營運中心帶到目的營運中心
#                                                   單價相關欄位及呆滯日期保留目的營運中心資料
# Modify.........: No:FUN-AC0026 11/07/05 By Mandy PLM-資料中心功能
# Modify.........: No.FUN-B50096 11/08/29 By lixh1 拋磚時增加imaa159字段
# Modify.........: No:MOD-BA0053 11/10/11 By johung mark imaicd_cur, 程式中直接執行imaicd_p，沒有用到cursor
# Modify.........: No.TQC-B90236 11/10/17 By yuhuabao i150_dbs_ins()增加寫入imaa928,imaa929至ima_file的ima928,ima929中
# Modify.........: No.FUN-B80032 11/10/31 By yangxf ima_file 更新揮寫rtepos
# Modify.........: No:FUN-BB0031 11/11/15 By LeoChang 修正拋轉圖檔時gex05拋轉主鍵值錯誤
# Modify.........: No:CHI-BB0038 11/11/15 By jason 更新拋轉資料時imaicd_file的欄位值update
# Modify.........: No:FUN-BA0054 12/01/02 By jason 新增拋轉smd_file的資料for icd
# Modify.........: No:FUN-BB0086 12/01/04 By tanxc 增加數量欄位小數取位
# Modify.........: No:FUN-BC0100 12/01/04 By bart icd確認時檢查BIN群組及WAFER型號是否已存在icf_file，沒有則新增                                               
# Modify.........: No:FUN-BC0076 12/02/03 By baogc 料件申請作業拋轉添加ima149,ima1491,ima940,ima941,ima151,ima154字段
# Modify.........: No:MOD-C30121 12/03/10 By yuhuabao 拋轉一併拋轉特性資料
# Modify.........: No:TQC-C30236 12/03/16 By bart 加上cl_get_target_table()
# Modify.........: No:MOD-C30903 12/04/02 By Elise 修正l_ima63定義
# Modify.........: No.FUN-C40011 12/05/15 By bart aimi150拋轉時同aimi100自動產生料號
# Modify.........: No:FUN-C50036 12/05/21 By yangxf 新增ima160字段，给预设值
# Modify.........: No:FUN-C50132 12/05/28 By bart 當有串aici020要自動產生料號與BOM前,也要將imaa01這個料號產生到料件主檔
# Modify.........: No:MOD-C60104 12/06/15 By suncx 系統設置為大陸版時，不走s_aimi100_set_by_ima06邏輯
# Modify.........: No:FUN-C50110 12/06/15 By bart icb_file回寫與拋轉
# Modify.........: No:CHI-C30038 12/06/15 By bart 檢查母料不存在不可拋轉
# Modify.........: No:TQC-C50255 12/06/25 By fengrui 根據aooi602中"更新存在資料"gew07這個字段的設置,應該允許沒有拋轉過的營運中心繼續拋轉
# Modify.........: No:TQC-C70017 12/07/03 By fengrui 系統設置為大陸版時，不對分群碼做檢查
# Modify.........: No:TQC-C70016 12/07/04 By fengrui 系統設置為大陸版時，aimi150拋轉時不應根據分群碼賦予基本資料,與檢查imz_file
# Modify.........: No:TQC-C80003 12/08/09 By xujing  調整aimi150第二次拋轉,導致拋磚到aimi100後,資料狀態碼不正確
# Modify.........: No:CHI-C50068 12/11/07 By bart 增加ima721,imaa721欄位
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷
# Modify.........: No:CHI-CB0017 12/12/05 By Lori 資料拋轉新增s_data_transfer拋相關文件
# Modify.........: No:CHI-CA0073 13/01/30 By pauline 將ima1015用ima1401替代
# Modify.........: No:FUN-D30006 13/03/04 By baogc 添加imaa1030欄位
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 抓ime_file資料添加imeacti='Y'條件
# Modify.........: No.FUN-D60083 13/08/27 By yangtt 增加ima164/ima1641来源於imaa164/imaa1641

IMPORT os      #No:MOD-9B0002 add
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../aim/4gl/aimi100.global"  #FUN-7C0010
GLOBALS "../../sub/4gl/s_data_center.global"   #No.FUN-7C0010

DEFINE g_ima_1    DYNAMIC ARRAY OF RECORD 
                  sel      LIKE type_file.chr1,
                  ima01    LIKE ima_file.ima01
                  END RECORD
DEFINE g_azp      DYNAMIC ARRAY OF RECORD
                  sel      LIKE type_file.chr1,
                  azp01    LIKE azp_file.azp01,
                  azp02    LIKE azp_file.azp02,
                  azp03    LIKE azp_file.azp03
                  END RECORD
DEFINE tm         DYNAMIC ARRAY of RECORD         #CHI-870044                          
                  sel    LIKE type_file.chr1,    #No.FUN-680137 CHAR
                  azp01    LIKE azp_file.azp01,                       
                  azp02    LIKE azp_file.azp02,                       
                  azp03    LIKE azp_file.azp03,                       
                  plant    LIKE type_file.chr1000, #FUN-9A0092
                  exist    LIKE type_file.chr1     #TQC-740090 add    
                  END RECORD 
DEFINE g_imaa     RECORD LIKE imaa_file.*
DEFINE g_gev04    LIKE gev_file.gev04
DEFINE g_msg1     LIKE type_file.chr1000
DEFINE g_msg2     LIKE type_file.chr1000
DEFINE g_msg3     LIKE type_file.chr1000
DEFINE g_msg4     LIKE type_file.chr1000
DEFINE g_msg_x    LIKE type_file.chr1000
DEFINE g_err      LIKE type_file.chr1000
DEFINE g_smd      RECORD LIKE smd_file.*
DEFINE g_imc      RECORD LIKE imc_file.*
DEFINE g_dbs_sep  LIKE type_file.chr50
DEFINE g_all_cnt  LIKE type_file.num10    #總共要拋轉的筆數
DEFINE g_cur_cnt  LIKE type_file.num10    #當前營運中心滿足拋轉條件的筆數
DEFINE g_flagx    LIKE type_file.chr1     #No.FUN-830090
DEFINE g_ans1     LIKE type_file.num5     #No.MOD-840397
DEFINE g_imaa1    RECORD LIKE imaa_file.* #No.MOD-840397
DEFINE g_db_type  LIKE type_file.chr21    #CHI-890001 add
DEFINE g_dbase    LIKE type_file.chr21    #CHI-890001 add
DEFINE g_azp01  LIKE azp_file.azp01     #FUN-A50102
DEFINE g_gew03    LIKE gew_file.gew03     #TQC-980264 
DEFINE p_plant              LIKE azp_file.azp01     #No.FUN-980059
DEFINE g_gca      RECORD LIKE gca_file.*  #CHI-A50006 add
DEFINE g_gcb      RECORD LIKE gcb_file.*  #CHI-A50006 add
DEFINE g_icb      RECORD LIKE icb_file.*  #FUN-C50110
DEFINE g_forupd_sql      STRING           #SELECT ... FOR UPDATE NOWAIT SQL #CHI-A60011 add
DEFINE l_hist_tab        LIKE type_file.chr50    #for mail   #CHI-A60011 add
#FUN-C40011---begin
DEFINE g_imax               DYNAMIC ARRAY OF RECORD 
                            sel      LIKE type_file.chr1,
                            ima01    LIKE ima_file.ima01
                            END RECORD
#FUN-C40011---end

FUNCTION s_aimi100_carry(p_ima,p_azp,p_gev04,p_flagx) #No.FUN-830090
  DEFINE p_ima                DYNAMIC ARRAY OF RECORD 
                              sel      LIKE type_file.chr1,
                              ima01    LIKE ima_file.ima01
                              END RECORD
  DEFINE p_azp                DYNAMIC ARRAY OF RECORD
                              sel      LIKE type_file.chr1,
                              azp01    LIKE azp_file.azp01,
                              azp02    LIKE azp_file.azp02,
                              azp03    LIKE azp_file.azp03
                              END RECORD
  DEFINE p_gev04              LIKE gev_file.gev04
  DEFINE p_flagx              LIKE type_file.chr1    #No.FUN-830090
  DEFINE l_i                  LIKE type_file.num10
  DEFINE l_j                  LIKE type_file.num10
  DEFINE l_str1               STRING
  DEFINE l_str2               STRING
  DEFINE l_str3               STRING
  DEFINE l_str4               STRING
  DEFINE l_str1_smd           STRING
  DEFINE l_str2_smd           STRING
  DEFINE l_str3_smd           STRING
  DEFINE l_str4_smd           STRING
  DEFINE l_str1_imc           STRING
  DEFINE l_str2_imc           STRING
  DEFINE l_str3_imc           STRING
  DEFINE l_str4_imc           STRING
  DEFINE l_ima01              LIKE ima_file.ima01
  DEFINE l_ima01_old          LIKE ima_file.ima01
  DEFINE l_ima06              LIKE ima_file.ima06
  DEFINE l_ima109             LIKE ima_file.ima109
  DEFINE l_dbs_sep            LIKE type_file.chr50
  DEFINE l_gew05              LIKE gew_file.gew05
  DEFINE l_gew07              LIKE gew_file.gew07
  DEFINE l_gez04              LIKE gez_file.gez04
  DEFINE l_gez05              LIKE gez_file.gez05
  DEFINE l_tabname            LIKE type_file.chr50 
  DEFINE l_ima                RECORD LIKE ima_file.*
  DEFINE l_imaicd             RECORD LIKE imaicd_file.*  #FUN-810038
  DEFINE l_str1_imaicd        STRING
  DEFINE l_str2_imaicd        STRING
  DEFINE l_str3_imaicd        STRING
  DEFINE l_str4_imaicd        STRING
  DEFINE l_ima_upd            LIKE type_file.chr1
  DEFINE l_gew08              LIKE gew_file.gew08     #for mail
 #DEFINE l_hist_tab           LIKE type_file.chr50    #for mail   #CHI-A60011 mark
  DEFINE l_hs_flag            LIKE type_file.chr1     #for mail
  DEFINE l_hs_path            LIKE ze_file.ze03       #for mail
  #CHI-A50006 add --start--
  DEFINE l_str1_gca           STRING
  DEFINE l_str2_gca           STRING
  DEFINE l_str3_gca           STRING
  DEFINE l_str4_gca           STRING
  DEFINE l_str1_gcb           STRING
  DEFINE l_str2_gcb           STRING
  DEFINE l_str3_gcb           STRING
  DEFINE l_str4_gcb           STRING
  DEFINE l_azp01              LIKE azp_file.azp01 
  #CHI-A50006 add --end--  
  DEFINE l_ima_2              RECORD LIKE ima_file.*     #CHI-A60011 add
  DEFINE l_imaicd_2           RECORD LIKE imaicd_file.*  #CHI-A60011 add
#TQC-B60316 -- begin --
  DEFINE l_ima25              LIKE ima_file.ima25,
         l_ima31              LIKE ima_file.ima31,
         l_ima31_fac          LIKE ima_file.ima31_fac,
         l_ima44              LIKE ima_file.ima44,
         l_ima44_fac          LIKE ima_file.ima44_fac,
         l_ima55              LIKE ima_file.ima55,
         l_ima55_fac          LIKE ima_file.ima55_fac,
        #l_ima63              LIKE ima_file.ima66,    #MOD-C30903 mark
         l_ima63              LIKE ima_file.ima63,    #MOD-C30903
         l_ima63_fac          LIKE ima_file.ima63_fac,
         l_ima86              LIKE ima_file.ima86,
         l_ima86_fac          LIKE ima_file.ima86_fac,
         l_ima906             LIKE ima_file.ima906,
         l_ima907             LIKE ima_file.ima907,
         l_ima908             LIKE ima_file.ima908
#TQC-B60316 -- end --
  DEFINE l_ima928             LIKE ima_file.ima928  #CHI-C30038
  DEFINE l_value1             LIKE type_file.chr30   #CHI-CB0017 add
  DEFINE l_value2             LIKE type_file.chr30   #CHI-CB0017 add
  
  WHENEVER ERROR CALL cl_err_msg_log
  
  LET g_flagx = p_flagx     #No.FUN-830090  0.carry  1.upload
  
  IF g_flagx <> '1' THEN
     IF p_ima.getLength() = 0 THEN RETURN END IF
  END IF
  
  IF p_azp.getLength() = 0 THEN RETURN END IF
  
  CALL g_ima_1.clear()
  
  #前置准備
  FOR l_i = 1 TO p_ima.getLength()
      LET g_ima_1[l_i].* = p_ima[l_i].*
  END FOR
  FOR l_i = 1 TO p_azp.getLength()
      LET g_azp[l_i].* = p_azp[l_i].*
  END FOR
  LET g_gev04 = p_gev04
  LET g_db_type=cl_db_get_database_type()
  
  #定義cursor
  CALL s_carry_p_cs()
  #default aooi602中設置的預設值
  LET g_sql = " SELECT gez04,gez05 FROM gez_file ",
              "  WHERE gez01 = '",g_gev04 CLIPPED,"'",
              "    AND gez02 = '1'",
              "    AND gez03 = ?  "
  PREPARE gez_p FROM g_sql
  DECLARE gez_cur CURSOR WITH HOLD FOR gez_p 
  #組column
  CALL s_carry_col('ima_file') RETURNING l_str1,l_str2,l_str3
  CALL s_carry_col('smd_file') RETURNING l_str1_smd,l_str2_smd,l_str3_smd
  CALL s_carry_col('imc_file') RETURNING l_str1_imc,l_str2_imc,l_str3_imc
  CALL s_carry_col('gca_file') RETURNING l_str1_gca,l_str2_gca,l_str3_gca  #CHI-A50006 add
  CALL s_carry_col('gcb_file') RETURNING l_str1_gcb,l_str2_gcb,l_str3_gcb  #CHI-A50006 add
  #組index
  CALL s_carry_idx('ima_file') RETURNING l_str4
  CALL s_carry_idx('smd_file') RETURNING l_str4_smd
  CALL s_carry_idx('imc_file') RETURNING l_str4_imc
  CALL s_carry_idx('gca_file') RETURNING l_str4_gca  #CHI-A50006 add
  CALL s_carry_idx('gcb_file') RETURNING l_str4_gcb  #CHI-A50006 add
  IF s_industry('icd') THEN
     CALL s_carry_idx('imaicd_file') RETURNING l_str4_imaicd
     CALL s_carry_col('imaicd_file') RETURNING l_str1_imaicd,l_str2_imaicd,l_str3_imaicd
  END IF
  
  #建立臨時表,用于存放拋轉的資料
  CALL s_aimi100_carry_p1() RETURNING l_tabname
  IF g_all_cnt = 0 THEN
     CALL cl_err('','aap-129',1)
     RETURN
  END IF
  
 
  IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0026 add if判斷
      #建立歷史資料拋轉的臨時表
      CALL s_dc_cre_temp_table("gex_file") RETURNING l_hist_tab
  #FUN-AC0026---add----str---
  ELSE
      LET l_hist_tab = g_dc_hist_tab
  END IF
  #FUN-AC0026---add----end---
 
  #ima對應smd_file拋轉的cursor定義   
  IF g_flagx <> '1' THEN                                  
     LET g_sql = " SELECT * FROM smd_file ",                                      
                 "  WHERE smd01 = ? "
  ELSE
     LET g_sql = " SELECT * FROM smd_file_bak1 ",                                      
                 "  WHERE smd01 = ? "
  END IF
  PREPARE smd_p FROM g_sql                                                     
  DECLARE smd_cur CURSOR WITH HOLD FOR smd_p
 
  #ima對應imc_file拋轉的cursor定義                                         
  IF g_flagx <> '1' THEN                                  
     LET g_sql = " SELECT * FROM imc_file ",                                      
                 "  WHERE imc01 = ? "
  ELSE
     LET g_sql = " SELECT * FROM imc_file_bak1 ",                                      
                 "  WHERE imc01 = ? "
  END IF
  PREPARE imc_p FROM g_sql                                                     
  DECLARE imc_cur CURSOR WITH HOLD FOR imc_p
 
  #ima對應imaicd_file拋轉的cursor定義                                         
  IF g_flagx <> '1' THEN                                  
     LET g_sql = " SELECT * FROM imaicd_file ",                                      
                 "  WHERE imaicd00 = ? "
  ELSE
     LET g_sql = " SELECT * FROM imaicd_file_bak1 ",                                      
                 "  WHERE imaicd00 = ? "
  END IF
  PREPARE imaicd_p FROM g_sql                                                     
 #DECLARE imaicd_cur CURSOR WITH HOLD FOR imc_p   #MOD-BA0053 mark
 
  #CHI-A50006 add --start--
  #ima對應gca_file拋轉的cursor定義                                         
  IF g_flagx <> '1' THEN                                  
     LET g_sql = " SELECT * FROM gca_file ",                                      
                 "  WHERE gca01 = ? ",
                 "    AND gca08 = 'FLD' "
  ELSE
     LET g_sql = " SELECT * FROM gca_file_bak1 ",                                      
                 "  WHERE gca01 = ? ",
                 "    AND gca08 = 'FLD' "
  END IF
  PREPARE gca_p FROM g_sql                                                     
  DECLARE gca_cur CURSOR WITH HOLD FOR gca_p
  #CHI-A50006 add --end--

  FOR l_j = 1 TO g_azp.getLength()
      IF cl_null(g_azp[l_j].azp03) THEN CONTINUE FOR END IF
      IF g_azp[l_j].sel = 'N' THEN CONTINUE FOR END IF
 
      SELECT gew05,gew07,gew08 INTO l_gew05,l_gew07,l_gew08 FROM gew_file
       WHERE gew01 = g_gev04
         AND gew02 = '1'
         AND gew04 = g_azp[l_j].azp01
      IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF
 
      #mail_1                                                              
      CALL s_dc_carry_send_mail_1(g_azp[l_j].azp01,l_j,g_gev04,'1',l_hist_tab)
           RETURNING l_hs_flag,l_hs_path
 
      CALL s_dbstring(g_azp[l_j].azp03) RETURNING l_dbs_sep
      LET g_dbs_sep = l_dbs_sep
 
     #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"ima_file",                      #CHI-A50006 mark
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01, 'ima_file'), #CHI-A50006
                  " VALUES(",l_str2,")"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs1 FROM g_sql
     #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"ima_file",                      #CHI-A50006 mark
      LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01, 'ima_file'), #CHI-A50006
                  "   SET ",l_str3,
                  " WHERE ",l_str4
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs2 FROM g_sql
      #CHI-A60011 add --start--
      LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(g_azp[l_j].azp01, 'ima_file'),
                         " WHERE ",l_str4," FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
      CALL cl_parse_qry_sql(g_forupd_sql,g_azp[l_j].azp01) RETURNING g_forupd_sql  #FUN-A50102
      DECLARE db_cs2_ima_lock CURSOR FROM g_forupd_sql
      #CHI-A60011 add --end--
     #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"ima_file",                      #CHI-A50006 mark
      LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01, 'ima_file'), #CHI-A50006
                  "   SET ima05 = '',",
                  "       ima16 = 99,",
#                  "       ima26 = 0,",  #No.FUN-A40023
#                  "       ima261= 0,",  #No.FUN-A40023
#                  "       ima262= 0,",  #No.FUN-A40023
                  "       ima29 = '',",
                  "       ima30 = '',",
                  "       ima40 = 0,",
                  "       ima41 = 0,",
                  "       ima532= '",g_today,"',",
                  "       ima57 = 0,",
                  "       ima73 = '',",
                  "       ima74 = '',",
                  "       ima78 = 0,",
                  "       ima80 = 0,",
                  "       ima853= 'N',",
                  "       ima88 = 0,",
                  "       ima881= '',",
                  "       ima89 = 0,",
                  "       ima91 = 0,",
                  "       ima92 = 'N',",
                  "       ima93 = 'NNNNNNNN',",
                  "       ima98 = 0,",
                  "       ima146= '',",
                  "       ima901= '",g_today,"',",
                  "       ima1012= '',",
                  "       ima1013= '',",
                 #"       ima1015= '' ",   #CHI-CA0073 mark 
                  "       ima1401= '' ",   #CHI-CA0073 add
                  " WHERE ",l_str4
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs3 FROM g_sql
     #LET g_sql = "SELECT * FROM ",l_dbs_sep CLIPPED,"ima_file",                      #CHI-A50006 mark
      LET g_sql = "SELECT * FROM ",cl_get_target_table(g_azp[l_j].azp01, 'ima_file'), #CHI-A50006
                  " WHERE ",l_str4
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs4 FROM g_sql
 
     #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"smd_file",                      #CHI-A50006 mark
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01, 'smd_file'), #CHI-A50006
                  " VALUES(",l_str2_smd,")"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs1_smd FROM g_sql
     #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"smd_file",                      #CHI-A50006 mark
      LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01, 'smd_file'), #CHI-A50006
                  "   SET ",l_str3_smd,
                  " WHERE ",l_str4_smd
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs2_smd FROM g_sql
      #CHI-A60011 add --start--
      LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(g_azp[l_j].azp01, 'smd_file'),
                         " WHERE ",l_str4_smd," FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
      CALL cl_parse_qry_sql(g_forupd_sql,g_azp[l_j].azp01) RETURNING g_forupd_sql  #FUN-A50102
      DECLARE db_cs2_smd_lock CURSOR FROM g_forupd_sql
      #CHI-A60011 add --end--
      
     #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"imc_file",                      #CHI-A50006 mark
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01, 'imc_file'), #CHI-A50006
                  " VALUES(",l_str2_imc,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs1_imc FROM g_sql
     #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"imc_file",                      #CHI-A50006 mark
      LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01, 'imc_file'), #CHI-A50006
                  "   SET ",l_str3_imc,
                  " WHERE ",l_str4_imc
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs2_imc FROM g_sql
      #CHI-A60011 add --start--
      LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(g_azp[l_j].azp01, 'imc_file'),
                         " WHERE ",l_str4_imc," FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
      CALL cl_parse_qry_sql(g_forupd_sql,g_azp[l_j].azp01) RETURNING g_forupd_sql  #FUN-A50102
      DECLARE db_cs2_imc_lock CURSOR FROM g_forupd_sql
      #CHI-A60011 add --end--
 
      IF s_industry('icd') THEN
        #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"imaicd_file",                      #CHI-A50006 mark
         LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01, 'imaicd_file'), #CHI-A50006
                     " VALUES(",l_str2_imaicd,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
         PREPARE db_cs1_imaicd FROM g_sql
        #LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,"imaicd_file",                      #CHI-A50006 mark
         LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01, 'imaicd_file'), #CHI-A50006
                     "   SET ",l_str3_imaicd,
                     " WHERE ",l_str4_imaicd
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
         PREPARE db_cs2_imaicd FROM g_sql
         #CHI-A60011 add --start--
         LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(g_azp[l_j].azp01, 'imaicd_file'),
                            " WHERE ",l_str4_imaicd," FOR UPDATE"
         LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
         CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
         CALL cl_parse_qry_sql(g_forupd_sql,g_azp[l_j].azp01) RETURNING g_forupd_sql  #FUN-A50102
         DECLARE db_cs2_imaicd_lock CURSOR FROM g_forupd_sql
         #CHI-A60011 add --end--
      END IF
 
      #CHI-A50006 add --start--
      #gca
     #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"gca_file",                      #CHI-A50006 mark
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01, 'gca_file'), #CHI-A50006
                  " VALUES(",l_str2_gca,")"
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs1_gca FROM g_sql
     #LET g_sql = "DELETE FROM ",l_dbs_sep CLIPPED,"gca_file",                      #CHI-A50006 mark
      LET g_sql = "DELETE FROM ",cl_get_target_table(g_azp[l_j].azp01, 'gca_file'), #CHI-A50006
                  " WHERE gca01 = ? ",
                  "   AND gca08 ='FLD' "
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs2_gca FROM g_sql
     
      #gcb 
     #LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,"gcb_file",                      #CHI-A50006 mark
      LET g_sql = "INSERT INTO ",cl_get_target_table(g_azp[l_j].azp01, 'gcb_file'), #CHI-A50006
                  #" VALUES(",l_str2_gcb,")"
                  " (SELECT * FROM gcb_file ",                                      
                  "  WHERE gcb01 = ? ",
                  "    AND gcb02 = ? ",
                  "    AND gcb03 = ? ",
                  "    AND gcb04 = ? ) "
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql		
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs1_gcb FROM g_sql
     #LET g_sql = "DELETE FROM ",l_dbs_sep CLIPPED,"gcb_file",                      #CHI-A50006 mark
      LET g_sql = "DELETE FROM ",cl_get_target_table(g_azp[l_j].azp01, 'gcb_file'), #CHI-A50006
                  " WHERE ",l_str4_gcb
	CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql  #FUN-A50102
      PREPARE db_cs2_gcb FROM g_sql
      #CHI-A50006 add --end--

      #default aooi602中設置的預設值                                           
      LET l_ima01 = NULL                                                       
      LET l_ima06 = NULL                                                       
      LET l_ima109= NULL                                                       
      FOREACH gez_cur USING g_azp[l_j].azp01 INTO l_gez04,l_gez05              
         IF SQLCA.sqlcode THEN                                                 
            CALL s_errmsg('gez03',g_azp[l_j].azp01,'foreach',SQLCA.sqlcode,1)  
            CONTINUE FOREACH                                                   
         END IF                                                                
         IF l_gez04 = 'ima01'  THEN LET l_ima01  = l_gez05 END IF              
         IF l_gez04 = 'ima06'  THEN LET l_ima06  = l_gez05 END IF              
         IF l_gez04 = 'ima109' THEN LET l_ima109 = l_gez05 END IF              
      END FOREACH
 
      #定義拋轉的SQL                                                           
      LET g_sql = " SELECT * FROM ",l_tabname CLIPPED,                         
                  "  WHERE ",l_gew05 CLIPPED                                   
      PREPARE carry_p1 FROM g_sql                                              
      DECLARE carry_cur1 CURSOR WITH HOLD FOR carry_p1
 
      #當前營運中心,滿足aooi602拋轉條件的筆數
      LET g_cur_cnt = 0
      LET g_sql = " SELECT COUNT(*) FROM ",l_tabname CLIPPED,                         
                  "  WHERE ",l_gew05 CLIPPED                                   
      PREPARE cnt_p1 FROM g_sql                                              
      EXECUTE cnt_p1 INTO g_cur_cnt
      IF cl_null(g_cur_cnt) THEN LET g_cur_cnt = 0 END IF
      IF g_all_cnt <> g_cur_cnt THEN   #aooi602中有設置,部分資料不滿足拋轉
         LET g_showmsg = g_azp[l_j].azp01,"/",g_all_cnt USING "<<<<&","/",g_cur_cnt USING "<<<<&"
         CALL s_errmsg("azp01,all_cnt,cur_cnt",g_showmsg,"cnt_p1","aoo-049",1)
      END IF
      
     #str MOD-A20098 mark
     #IF g_cur_cnt > 0 THEN
     #   LET g_ans1 = FALSE
     #   LET g_msg1 = '(',g_azp[l_j].azp01,')'
     #   CALL cl_confirm2('aim-010',g_msg1) RETURNING g_ans1
     #END IF
     #end MOD-A20098 mark
      LET l_ima_upd = 'N'     #No.FUN-A80036
      FOREACH carry_cur1 INTO g_ima.*                                          
         IF SQLCA.sqlcode THEN                                                
            CALL s_errmsg('ima01',g_ima.ima01,'foreach',SQLCA.sqlcode,1)      
            CONTINUE FOREACH                                                  
         END IF                                                               
         IF g_ima.imaacti <> 'Y' THEN  #僅報一次錯誤
            IF l_j = 1 THEN  #僅報一次錯誤
               LET g_showmsg = g_plant,":",g_ima.ima01
               CALL s_errmsg('azp01,ima01',g_showmsg,'imaacti','aoo-090',1)
            END IF
            CONTINUE FOREACH
         END IF
 
         LET g_success = 'Y'
         IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0026 add if 判斷
             BEGIN WORK
         END IF                         #FUN-AC0026 add
      
         #LET l_ima_upd = 'N'  #No.FUN-A80036
 
         IF NOT cl_null(l_ima06)  THEN LET g_ima.ima06  = l_ima06  END IF
 
         #check當前ima_file資料對應的各value是否OK
         IF g_aza.aza26 <> '2' THEN  #TQC-C70017 add
            IF NOT s_aimi100_chkdb_ima06() THEN
               LET g_success = 'N'
            END IF
         END IF  #TQC-C70017
         #CHI-C30038---begin
         IF NOT cl_null(g_ima.ima929) THEN
            LET l_ima928 = 'N'
            LET g_sql = "SELECT ima928 FROM ",cl_get_target_table(g_azp[l_j].azp01, 'ima_file'),
                         " WHERE ima01 = ?"
            LET g_sql = cl_forupd_sql(g_sql)
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql 
            #DECLARE db_cs2_imc_lock CURSOR FROM g_sql
            PREPARE pr_ima928 FROM g_sql  
            EXECUTE pr_ima928 USING g_ima.ima929 INTO l_ima928 

            IF l_ima928 <> 'Y' THEN
               LET g_showmsg = g_plant,":",g_ima.ima01
               CALL s_errmsg('ima928',g_showmsg,g_ima.ima929,'aoo-306',1)
               LET g_success = 'N'
            END IF 
         END IF  
         #CHI-C30038---end
        #IF g_ans1 AND g_success = 'Y' THEN                        #MOD-A20098 mark
         IF g_azp[l_j].azp01 <> g_plant AND g_success = 'Y' THEN   #MOD-A20098
            IF NOT cl_null(g_ima.ima06) THEN
#TQC-B60316 -- begin --
               LET l_ima25     = g_ima.ima25
               LET l_ima31     = g_ima.ima31
               LET l_ima31_fac = g_ima.ima31_fac
               LET l_ima44     = g_ima.ima44
               LET l_ima44_fac = g_ima.ima44_fac
               LET l_ima55     = g_ima.ima55
               LET l_ima55_fac = g_ima.ima55_fac
               LET l_ima63     = g_ima.ima63
               LET l_ima63_fac = g_ima.ima63_fac
               LET l_ima86     = g_ima.ima86
               LET l_ima86_fac = g_ima.ima86_fac
               LET l_ima906    = g_ima.ima906
               LET l_ima907    = g_ima.ima907
               LET l_ima908    = g_ima.ima908
#TQC-B60316 -- end --
              #CALL s_aimi100_set_by_ima06(l_dbs_sep,g_ima.ima06,'1')  #FUN-A50102
               IF g_aza.aza26 <> '2' THEN   #MOD-C60104
                  CALL s_aimi100_set_by_ima06(g_azp[l_j].azp01,g_ima.ima06,'1')  #FUN-A50102
               END IF  #MOD-C60104
            END IF
         #FUN-C50132---begin
         ELSE
               LET l_ima25     = g_ima.ima25
               LET l_ima31     = g_ima.ima31
               LET l_ima31_fac = g_ima.ima31_fac
               LET l_ima44     = g_ima.ima44
               LET l_ima44_fac = g_ima.ima44_fac
               LET l_ima55     = g_ima.ima55
               LET l_ima55_fac = g_ima.ima55_fac
               LET l_ima63     = g_ima.ima63
               LET l_ima63_fac = g_ima.ima63_fac
               LET l_ima86     = g_ima.ima86
               LET l_ima86_fac = g_ima.ima86_fac
               LET l_ima906    = g_ima.ima906
               LET l_ima907    = g_ima.ima907
               LET l_ima908    = g_ima.ima908
         #FUN-C50132---end
         END IF
         IF NOT cl_null(l_ima109) THEN LET g_ima.ima109 = l_ima109 END IF
        #IF NOT s_aimi100_chk_rel_ima06('a',g_azp[l_j].azp03) THEN  #FUN-A50102
         IF NOT s_aimi100_chk_rel_ima06('a',g_azp[l_j].azp01) THEN  #FUN-A50102
            LET g_success = 'N'
         END IF
         
         LET g_msg1 = 'ins ',g_azp[l_j].azp03 CLIPPED,':',g_ima_1[l_i].ima01,':'
         LET g_msg2 = 'upd ',g_azp[l_j].azp03 CLIPPED,':',g_ima_1[l_i].ima01,':'
 
         LET l_ima01_old = g_ima.ima01                                        
         IF NOT cl_null(l_ima01)  THEN LET g_ima.ima01  = l_ima01  END IF        
 
         #ima916,ima917
         LET g_ima.ima916 = g_plant
         LET g_ima.ima917 = 1
         IF cl_null(g_ima.ima160) THEN LET g_ima.ima160 = 'N' END IF      #FUN-C50036  add 
         EXECUTE db_cs1 USING g_ima.*
         IF SQLCA.sqlcode = 0 THEN
            EXECUTE db_cs3 USING g_ima.ima01
            IF SQLCA.sqlcode THEN
               LET g_msg_x = g_azp[l_j].azp01,':upd'
               CALL s_errmsg('ima01',g_ima.ima01,g_msg_x,SQLCA.sqlcode,1)
               MESSAGE g_msg2,':fail'
               CALL ui.Interface.refresh()
               LET g_success = 'N'
            ELSE
               #LET l_ima_upd = 'Y'   #No.FUN-A80036
               IF s_industry('icd') THEN
                  #FUN-810038................begin
                  EXECUTE imaicd_p USING l_ima01_old INTO l_imaicd.*      #MOD-950038
                  IF SQLCA.sqlcode = 0 THEN
                     IF NOT cl_null(l_ima01)  THEN LET l_imaicd.imaicd00  = l_ima01  END IF        
                     EXECUTE db_cs1_imaicd USING l_imaicd.*
                     IF SQLCA.sqlcode THEN
                        IF NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN        #FUN-B30156
                           LET g_msg_x = g_azp[l_j].azp01,':imaicd:ins'
                           CALL s_errmsg('imaicd00',g_ima.ima01,g_msg_x,SQLCA.sqlcode,1)
                           MESSAGE g_msg1,':fail'
                           CALL ui.Interface.refresh()
                           LET g_success = 'N'
                        END IF
                     END IF
                  #No.FUN-A80036  --Begin
                  ELSE
                     LET g_success = 'N'
                  #No.FUN-A80036  --End  
                  END IF
               END IF
 
               IF g_success = 'Y' THEN
                  MESSAGE g_msg1,':ok'
                  CALL ui.Interface.refresh()
               END IF
            END IF
         ELSE
           #IF SQLCA.sqlcode = -239 THEN             #CHI-A50006 mark
            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #CHI-A50006
               IF l_gew07 = 'N' THEN           
                  MESSAGE g_msg1,':exist'      
                  CALL ui.Interface.refresh()  
                  LET g_success = 'N'      #No.FUN-A80036
               ELSE
                  #CHI-A60011 add --start--
                  OPEN db_cs2_ima_lock USING l_ima01_old
                  IF STATUS THEN
                     LET g_msg_x = g_azp[l_j].azp01,':ima_file:lock'
                     CALL s_errmsg('ima01',g_ima.ima01,g_msg_x,STATUS,1)
                     MESSAGE g_msg1,':fail'
                     CALL ui.Interface.refresh()
                     CLOSE db_cs2_ima_lock
                     LET g_success = 'N'
                     #LET l_ima_upd = 'N'   #No.FUN-A80036
                     EXIT FOREACH
                  END IF
                  FETCH db_cs2_ima_lock INTO l_ima_2.* 
                  IF SQLCA.SQLCODE THEN
                     LET g_msg_x = g_azp[l_j].azp01,':ima_file:lock'
                     CALL s_errmsg('ima01',g_ima.ima01,g_msg_x,SQLCA.SQLCODE,1)
                     MESSAGE g_msg1,':fail'
                     CALL ui.Interface.refresh()
                     CLOSE db_cs2_ima_lock
                     LET g_success = 'N'
                     #LET l_ima_upd = 'N'   #No.FUN-A80036
                     EXIT FOREACH
                  END IF
                  #CHI-A60011 add --end--
                  EXECUTE db_cs4 INTO l_ima.* USING l_ima01_old
                  #update時,部分值要取原來的內容
                  LET g_ima.ima917 = l_ima.ima917
                  IF cl_null(g_ima.ima917) THEN LET g_ima.ima917 = 0 END IF
                  LET g_ima.ima917 = g_ima.ima917 + 1
                  LET g_ima.ima05  = l_ima.ima05
                  LET g_ima.ima16  = l_ima.ima16
#                  LET g_ima.ima26  = l_ima.ima26   #No.FUN-A40023
#                  LET g_ima.ima261 = l_ima.ima261  #No.FUN-A40023
#                  LET g_ima.ima262 = l_ima.ima262  #No.FUN-A40023
                  LET g_ima.ima29  = l_ima.ima29
                  LET g_ima.ima30  = l_ima.ima30
                  LET g_ima.ima40  = l_ima.ima40
                  LET g_ima.ima41  = l_ima.ima41
                  LET g_ima.ima532 = l_ima.ima532
                  LET g_ima.ima57  = l_ima.ima57
                  LET g_ima.ima73  = l_ima.ima73
                  LET g_ima.ima74  = l_ima.ima74
                  LET g_ima.ima78  = l_ima.ima78
                  LET g_ima.ima80  = l_ima.ima80
                  LET g_ima.ima853 = l_ima.ima853
                  LET g_ima.ima88  = l_ima.ima88
                  LET g_ima.ima881 = l_ima.ima881
                  LET g_ima.ima89  = l_ima.ima89
                  LET g_ima.ima91  = l_ima.ima91
                  LET g_ima.ima92  = l_ima.ima92
                  LET g_ima.ima93  = l_ima.ima93
                  LET g_ima.ima98  = l_ima.ima98
                  LET g_ima.ima146 = l_ima.ima146
                  LET g_ima.ima901 = l_ima.ima901
                  LET g_ima.ima1012= l_ima.ima1012
                  LET g_ima.ima1013= l_ima.ima1013
                 #LET g_ima.ima1015= l_ima.ima1015   #CHI-CA0073 mark 
                  LET g_ima.ima1401= l_ima.ima1401  #CHI-CA0073 add
                  LET g_ima.ima120 = l_ima.ima120              #FUN-A90049 add

#TQC-B60316 -- begin --
#update時，部分欄位要取來源營運中心的資料
                  LET g_ima.ima25     = l_ima25
                  LET g_ima.ima31     = l_ima31
                  LET g_ima.ima31_fac = l_ima31_fac
                  LET g_ima.ima44     = l_ima44
                  LET g_ima.ima44_fac = l_ima44_fac
                  LET g_ima.ima55     = l_ima55
                  LET g_ima.ima55_fac = l_ima55_fac
                  LET g_ima.ima63     = l_ima63
                  LET g_ima.ima63_fac = l_ima63_fac
                  LET g_ima.ima86     = l_ima86
                  LET g_ima.ima86_fac = l_ima86_fac
                  LET g_ima.ima906    = l_ima906
                  LET g_ima.ima907    = l_ima907
                  LET g_ima.ima908    = l_ima908
#update時，部分欄位要保留目的營運中心的資料
                  LET g_ima.ima32     = l_ima.ima32
                  LET g_ima.ima33     = l_ima.ima33
                  LET g_ima.ima53     = l_ima.ima53
                  LET g_ima.ima531    = l_ima.ima531
                  LET g_ima.ima58     = l_ima.ima58
                  LET g_ima.ima72     = l_ima.ima72
                  LET g_ima.ima721    = l_ima.ima721  #CHI-C50068
                  LET g_ima.ima95     = l_ima.ima95
                  LET g_ima.ima127    = l_ima.ima127
                  LET g_ima.ima128    = l_ima.ima128
                  LET g_ima.ima902    = l_ima.ima902
#TQC-B60316 -- end --
                 #FUN-B80032---------STA-------
                  LET g_sql = "SELECT * FROM ",cl_get_target_table(g_azp[l_j].azp01, 'ima_file'),
                              " WHERE ima01 = '",g_ima.ima01,"'"  
                  CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql
                  PREPARE ds_sel FROM g_sql 
                  EXECUTE ds_sel INTO l_ima.*
                  IF l_ima.ima02 <> g_ima.ima02 OR l_ima.ima021 <> g_ima.ima021
                     OR l_ima.ima25 <> g_ima.ima25 OR l_ima.ima45 <> g_ima.ima45 THEN
                     IF g_aza.aza88 = 'Y' THEN
                        LET g_sql = "UPDATE ",cl_get_target_table(g_azp[l_j].azp01, 'rte_file'),
                                    " SET rtepos = '2' WHERE rte03 = '",g_ima.ima01,"' AND rtepos = '3' "
                        CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql
                        PREPARE db_update FROM g_sql 
                        EXECUTE db_update 
                     END IF
                  END IF 
                 #FUN-B80032---------END-------
                  EXECUTE db_cs2 USING g_ima.*,l_ima01_old
                  IF SQLCA.sqlcode = 0 THEN
                     #LET l_ima_upd = 'Y'   #No.FUN-A80036
                     IF s_industry('icd') THEN
                        EXECUTE imaicd_p USING l_ima01_old INTO l_imaicd.*       #MOD-950038
                        IF SQLCA.sqlcode = 0 THEN
                           IF NOT cl_null(l_ima01)  THEN LET l_imaicd.imaicd00  = l_ima01  END IF        
                           EXECUTE db_cs1_imaicd USING l_imaicd.*
                           #IF SQLCA.sqlcode = - 239 THEN   #CHI-BB0038 mark(會回傳-268導至誤判)
                           IF cl_sql_dup_value(SQLCA.sqlcode) THEN   #CHI-BB0038
                              #CHI-A60011 add --start--
                              OPEN db_cs2_imaicd_lock USING l_ima01_old
                              IF STATUS THEN
                                 LET g_msg_x = g_azp[l_j].azp01,':imaicd_file:lock'
                                 CALL s_errmsg('imaicd00',g_ima.ima01,g_msg_x,STATUS,1)
                                 MESSAGE g_msg1,':fail'
                                 CALL ui.Interface.refresh()
                                 CLOSE db_cs2_imaicd_lock
                                 LET g_success = 'N'
                                 #LET l_ima_upd = 'N'   #No.FUN-A80036
                                 EXIT FOREACH
                              END IF
                              FETCH db_cs2_imaicd_lock INTO l_imaicd_2.* 
                              IF SQLCA.SQLCODE THEN
                                 LET g_msg_x = g_azp[l_j].azp01,':imaicd_file:lock'
                                 CALL s_errmsg('imaicd00',g_ima.ima01,g_msg_x,SQLCA.SQLCODE,1)
                                 MESSAGE g_msg1,':fail'
                                 CALL ui.Interface.refresh()
                                 CLOSE db_cs2_imaicd_lock
                                 LET g_success = 'N'
                                 #LET l_ima_upd = 'N'   #No.FUN-A80036
                                 EXIT FOREACH
                              END IF
                              #CHI-A60011 add --end--
                              EXECUTE db_cs2_imaicd USING l_imaicd.*,l_ima01_old
                              IF SQLCA.sqlcode THEN
                                 LET g_msg_x = g_azp[l_j].azp01,':imaicd:upd'
                                 CALL s_errmsg('imaicd00',g_ima.ima01,g_msg_x,SQLCA.sqlcode,1)
                                 MESSAGE g_msg2,':fail'
                                 CALL ui.Interface.refresh()
                                 LET g_success = 'N'
                              END IF
                              CLOSE db_cs2_imaicd_lock  #CHI-A60011 add
                           END IF
                        #No.FUN-A80036  --Begin
                        ELSE
                           LET g_success = 'N'
                        #No.FUN-A80036  --End  
                        END IF
                     END IF
                     IF g_success = 'Y' THEN
                        MESSAGE g_msg2,':ok'
                        CALL ui.Interface.refresh()
                     END IF
                  ELSE
                     LET g_msg_x = g_azp[l_j].azp01,':upd'
                     CALL s_errmsg('ima01',g_ima.ima01,g_msg_x,SQLCA.sqlcode,1)
                     MESSAGE g_msg2,':fail'
                     CALL ui.Interface.refresh()
                     LET g_success = 'N'
                  END IF
                  CLOSE db_cs2_ima_lock  #CHI-A60011 add
               END IF
            ELSE
               LET g_msg_x = g_azp[l_j].azp01,':ins'
               CALL s_errmsg('ima01',g_ima.ima01,g_msg_x,SQLCA.sqlcode,1)
               MESSAGE g_msg1,':fail'
               CALL ui.Interface.refresh()
               LET g_success = 'N'
            END IF
         END IF
         #No.FUN-A80036  --Begin
         #IF l_ima_upd = 'Y' THEN
         IF g_success = 'Y' THEN
         #No.FUN-A80036  --End  
            CALL s_dc_carry_record(g_gev04,g_azp[l_j].azp01,g_prog,g_ima.ima01,'1')
            CALL s_aimi100_smd(l_ima01_old,l_ima01,g_azp[l_j].azp01,l_gew07)
            CALL s_aimi100_imc(l_ima01_old,l_ima01,g_azp[l_j].azp01,l_gew07)
           #CALL s_aimi100_gca(l_ima01_old,l_ima01,g_azp[l_j].azp01,l_gew07)  #CHI-A50006 add    #CHI-CB0017 mark
           #CALL s_aimi100_gcb(l_ima01_old,l_ima01,g_azp[l_j].azp01,l_gew07)  #CHI-A50006 add    #CHI-CB0017 mark
           #CHI-CB0017 add begin---
           LET l_value1 = g_ima.ima01
           LET l_value2 = g_ima.ima01
           CALL s_data_transfer(g_azp[l_j].azp01,'1',g_prog,l_value1,l_value2,'','','')
           #CHI-CB0017 add end-----
            IF l_imaicd.imaicd04 = '0' OR l_imaicd.imaicd04 = '1' OR l_imaicd.imaicd04 = '2' THEN  #FUN-C50110
               CALL s_aimi100_icb(g_ima.ima01,g_azp[l_j].azp01)    #FUN-C50110
            END iF   #FUN-C50110
         END IF
         IF g_success = 'N' THEN
            #LET l_ima_upd = 'N'   #NO.FUN-840033   #No.FUN-A80036
            IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0026 add if 判斷
                ROLLBACK WORK
            END IF                         #FUN-AC0026 add
         ELSE
            LET l_ima_upd = 'Y'  #NO.FUN-840033
            IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0026 add if 判斷
                COMMIT WORK
            END IF                         #FUN-AC0026 add
         END IF
      END FOREACH
      IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0026 add if判斷
          #mail 2                                                                  
          IF l_ima_upd ='Y' THEN   #NO.FUN-840033 add      
              CALL s_dc_carry_send_mail_2(l_hs_flag,l_gew08,l_hs_path,l_hist_tab)
          END IF                   #NO.FUN-840033 add
      END IF #FUN-AC0026 add
  END FOR
 
  IF g_prog <> 'aws_ttsrv2' THEN #FUN-AC0026 add if判斷
      CALL s_dc_drop_temp_table(l_tabname)
      CALL s_dc_drop_temp_table(l_hist_tab)
  #FUN-AC0026--add---str--
  ELSE
      CALL s_dc_del_tmp(l_tabname)
      CALL s_dc_del_tmp(l_hist_tab)
  END IF 
  #FUN-AC0026--add---end--
 
  IF l_ima_upd = 'Y' THEN      #NO.FUN-840033 add
     #MESSAGE 'Data Carry Finish!' #TQC-AC0147
      CALL cl_err('','aim-162',0)  #TQC-AC0147
  END IF                       #NO.FUN-840033 add
  CALL ui.Interface.refresh()
END FUNCTION
#FUN-C50110---begin
FUNCTION s_aimi100_icb(p_ima01,p_plant)    
 
   DEFINE p_ima01    LIKE ima_file.ima01
   DEFINE p_dbname   LIKE azp_file.azp03  
   DEFINE p_plant    LIKE azp_file.azp01 
   DEFINE l_sql      STRING
   DEFINE l_crossdb  STRING
   DEFINE l_legal    LIKE oebi_file.oebilegal    
   DEFINE l_dbs_tra  LIKE type_file.chr21  
   DEFINE l_cnt      LIKE type_file.num5  

   LET g_plant_new = p_plant CLIPPED  
   CALL s_getlegal(p_plant) RETURNING l_legal 
 
   CALL s_gettrandbs()       
   LET l_dbs_tra = g_dbs_tra   
   LET l_crossdb = s_dbstring(l_dbs_tra)   

   SELECT * INTO g_icb.* FROM  icb_file                                
    WHERE icb01 = p_ima01  

   LET l_cnt = 0
   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'icb_file'),
               " WHERE icb01 = '",p_ima01,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql
   PREPARE s_icb_pre1 FROM l_sql
   EXECUTE s_icb_pre1 INTO l_cnt
   IF l_cnt = 0 THEN 
      #預設值指派
      IF cl_null(g_icb.icb05) THEN
         LET g_icb.icb05=1
      END IF
 
      IF cl_null(l_crossdb) THEN  #有新增欄位不需改 
         INSERT INTO icb_file VALUES (g_icb.*)
      ELSE  #有新增欄位需加?,否則新加的欄位不會新增到資料庫
         LET l_sql="INSERT INTO ",cl_get_target_table(p_plant,'icb_file'),
                " (icb01,icb02,icb03,icb04,icb05,icb06,icb07,icb08,icb09,icb10,",  
                " icb11,icb12,icb13,icb14,icb15,icb16,icb17,icb18,icb19,icb20,",  
                " icb21,icb22,icb23,icb24,icb25,icb26,icb27,icb28,icb29,icb30,",
                " icb31,icb32,icb33,icb34,icb35,icb36,icb37,icb38,icb39,icb40,",
                " icb41,icb42,icb43,icb44,icb45,icb455,icb46,icb47,icb48,icb49,icb50,",
                " icb51,icb52,icb53,icb54,icb55,icb56,icb57,icb58,icb59,icb60,",
                " icb61,icb62,icb63,icb64,icb65,icb66,icb67,icb68,icb69,icb70,",
                " icb71,icb72,icb73,icb74,icb75,icb76,icb77,icb78,icb79,",
                " icbacti,icbdate,icbgrup,icbmodu,icbuser,icbud01,icbud02,icbud03,icbud04,icbud05,",
                " icbud06,icbud07,icbud08,icbud09,icbud10,icbud11,icbud12,icbud13,icbud14,icbud15,",
                " icboriu,icborig)",
                "  VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                "          ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                "          ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                "          ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                "          ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                "          ?,? )"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              						
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql         
         PREPARE ins_icb_p FROM l_sql
         EXECUTE ins_icb_p USING g_icb.icb01,g_icb.icb02,g_icb.icb03,g_icb.icb04,g_icb.icb05,g_icb.icb06,g_icb.icb07,g_icb.icb08,g_icb.icb09,g_icb.icb10, 
                g_icb.icb11,g_icb.icb12,g_icb.icb13,g_icb.icb14,g_icb.icb15,g_icb.icb16,g_icb.icb17,g_icb.icb18,g_icb.icb19,g_icb.icb20,  
                g_icb.icb21,g_icb.icb22,g_icb.icb23,g_icb.icb24,g_icb.icb25,g_icb.icb26,g_icb.icb27,g_icb.icb28,g_icb.icb29,g_icb.icb30,
                g_icb.icb31,g_icb.icb32,g_icb.icb33,g_icb.icb34,g_icb.icb35,g_icb.icb36,g_icb.icb37,g_icb.icb38,g_icb.icb39,g_icb.icb40,
                g_icb.icb41,g_icb.icb42,g_icb.icb43,g_icb.icb44,g_icb.icb45,g_icb.icb455,g_icb.icb46,g_icb.icb47,g_icb.icb48,g_icb.icb49,g_icb.icb50,
                g_icb.icb51,g_icb.icb52,g_icb.icb53,g_icb.icb54,g_icb.icb55,g_icb.icb56,g_icb.icb57,g_icb.icb58,g_icb.icb59,g_icb.icb60,
                g_icb.icb61,g_icb.icb62,g_icb.icb63,g_icb.icb64,g_icb.icb65,g_icb.icb66,g_icb.icb67,g_icb.icb68,g_icb.icb69,g_icb.icb70,
                g_icb.icb71,g_icb.icb72,g_icb.icb73,g_icb.icb74,g_icb.icb75,g_icb.icb76,g_icb.icb77,g_icb.icb78,g_icb.icb79,
                g_icb.icbacti,g_icb.icbdate,g_icb.icbgrup,g_icb.icbmodu,g_icb.icbuser,g_icb.icbud01,g_icb.icbud02,g_icb.icbud03,g_icb.icbud04,g_icb.icbud05,
                g_icb.icbud06,g_icb.icbud07,g_icb.icbud08,g_icb.icbud09,g_icb.icbud10,g_icb.icbud11,g_icb.icbud12,g_icb.icbud13,g_icb.icbud14,g_icb.icbud15,
                g_icb.icboriu,g_icb.icborig
      END IF
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg("icb01",p_ima01,"INS icb_file",SQLCA.sqlcode,1)
            LET g_totsuccess='N'
         ELSE
            CALL cl_err3("ins","icb_file",p_ima01,"",SQLCA.sqlcode,"","",1)             
         END IF
         #RETURN FALSE                       
      END IF
   END IF 
   #RETURN TRUE                            
END FUNCTION
#FUN-C50110---end
FUNCTION s_aimi100_chk_cur(p_sql)
  DEFINE p_sql         STRING
  DEFINE l_cnt         LIKE type_file.num5
  DEFINE l_result      LIKE type_file.chr1
  DEFINE l_dbase       LIKE type_file.chr21
 
   IF NOT cl_null(g_dbs_sep) THEN  #指定資料庫,Table Name 前面加上資料庫名稱,如果有兩個Tablename,則此處理必須改寫
      LET l_dbase=" FROM ",g_dbs_sep CLIPPED
      CALL cl_replace_once()
      LET p_sql=cl_replace_str(p_sql," FROM ",l_dbase)
      CALL cl_replace_init()
   END IF
 	 CALL cl_replace_sqldb(p_sql) RETURNING l_dbase        #FUN-920032    #FUN-950007 add
   PREPARE s_aimi100_chk_cur_p FROM p_sql
   DECLARE s_aimi100_chk_cur_c CURSOR FOR s_aimi100_chk_cur_p
   OPEN s_aimi100_chk_cur_c
   FETCH s_aimi100_chk_cur_c INTO l_cnt
   IF SQLCA.sqlcode OR l_cnt=0 THEN
      LET l_result=FALSE
   ELSE
      LET l_result=TRUE
   END IF
   FREE s_aimi100_chk_cur_p
   CLOSE s_aimi100_chk_cur_c
   RETURN l_result
END FUNCTION
 
FUNCTION s_aimi100_chkdb_ima06()
   IF cl_null(g_ima.ima06) THEN
      RETURN TRUE
   END IF
 
   LET g_sql="SELECT COUNT(*) FROM imz_file ",
             "WHERE imz01='",g_ima.ima06,"' ",
             "AND imzacti='Y'"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima06
      CALL s_errmsg('azp01,ima01,ima06',g_showmsg,'sel ima06','mfg3179',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
#FUNCTION s_aimi100_chk_rel_ima06(p_cmd,p_azp03)   #FUN-A50102
FUNCTION s_aimi100_chk_rel_ima06(p_cmd,p_azp01)    #FUN-A50102
  DEFINE p_cmd    LIKE type_file.chr1
  DEFINE p_azp03  LIKE azp_file.azp03
  DEFINE p_azp01  LIKE azp_file.azp01   #FUN-A50102
  DEFINE l_flag   LIKE type_file.chr1
 
   LET l_flag = 'Y'
   IF NOT s_aimi100_chk_ima09() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima10() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima11() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima12() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima23() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima25() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima31() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima35() THEN
      LET l_flag = 'N'
   END IF
  #IF NOT s_aimi100_chk_ima39(p_azp03) THEN   #MOD-990247   #FUN-A50102
   IF NOT s_aimi100_chk_ima39(p_azp01) THEN   #FUN-A50102
      LET l_flag = 'N'
   END IF
  #IF NOT s_aimi100_chk_ima391(p_azp03) THEN   #MOD-990247  #FUN-A50102
   IF NOT s_aimi100_chk_ima391(p_azp01) THEN   #FUN-A50102
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima43() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima44() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima54() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima55() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima571() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima63() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima67() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima86() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima87() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima872() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima874() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima109() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima131() THEN
      LET l_flag = 'N'
   END IF
  #IF NOT s_aimi100_chk_ima132(p_azp03) THEN   #MOD-990247  #FUN-A50102
   IF NOT s_aimi100_chk_ima132(p_azp01) THEN   #FUN-A50102
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima133(p_cmd) THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima134() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima136() THEN
      LET l_flag = 'N'
   END IF
   IF NOT s_aimi100_chk_ima137() THEN
      LET l_flag = 'N'
   END IF
  #IF NOT s_aimi100_chk_ima907(p_cmd,p_azp03) THEN   #FUN-A50102
   IF NOT s_aimi100_chk_ima907(p_cmd,p_azp01) THEN   #FUN-A50102
      LET l_flag = 'N'
   END IF
  #IF NOT s_aimi100_chk_ima908(p_cmd,p_azp03) THEN   #FUN-A50102
   IF NOT s_aimi100_chk_ima908(p_cmd,p_azp01) THEN   #FUN-A50102
      LET l_flag = 'N'
   END IF
   IF l_flag = 'Y' THEN
      RETURN TRUE
   ELSE
      RETURN FALSE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima09()
   IF cl_null(g_ima.ima09) THEN
      RETURN TRUE
   END IF
   LET g_sql= "SELECT COUNT(*) FROM azf_file ",
              " WHERE azf01='",g_ima.ima09,"' AND azf02='D' ",
              " AND azfacti='Y'"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima09
      CALL s_errmsg('azp01,ima01,ima09',g_showmsg,'sel ima09','mfg1306',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima10()
   IF cl_null(g_ima.ima10) THEN
      RETURN TRUE
   END IF
   LET g_sql= "SELECT COUNT(*) FROM azf_file ",
              "WHERE azf01='",g_ima.ima10,"' AND azf02='E' ",
              "AND azfacti='Y'"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima10
      CALL s_errmsg('azp01,ima01,ima10',g_showmsg,'sel ima10','mfg1306',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima11()
   IF cl_null(g_ima.ima11) THEN
      RETURN TRUE
   END IF
   LET g_sql= "SELECT COUNT(*) FROM azf_file ",
              "WHERE azf01='",g_ima.ima11,"' AND azf02='F' ",
              "AND azfacti='Y'"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima11
      CALL s_errmsg('azp01,ima01,ima11',g_showmsg,'sel ima11','mfg1306',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima12()
   IF cl_null(g_ima.ima12) THEN
      RETURN TRUE
   END IF
   LET g_sql= "SELECT COUNT(*) FROM azf_file ",
              "WHERE azf01='",g_ima.ima12,"' AND azf02='G' ",
              "AND azfacti='Y'"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima12
      CALL s_errmsg('azp01,ima01,ima12',g_showmsg,'sel ima12','mfg1306',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima23()
   IF cl_null(g_ima.ima23) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM gen_file ",
             "WHERE gen01='",g_ima.ima23,"' ",
             "AND genacti='Y'"
 
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima23
      CALL s_errmsg('azp01,ima01,ima23',g_showmsg,'sel ima23','aoo-001',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima25()
   IF cl_null(g_ima.ima25) THEN
      RETURN TRUE
   END IF
   LET g_sql= "SELECT COUNT(*) FROM gfe_file ",
              "WHERE gfe01='",g_ima.ima25,"' ",
              "AND gfeacti IN ('y','Y')"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima25
      CALL s_errmsg('azp01,ima01,ima25',g_showmsg,'sel ima25','mfg1200',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima31()
   IF cl_null(g_ima.ima31) THEN
      RETURN TRUE
   END IF
   LET g_sql= "SELECT COUNT(*) FROM gfe_file ",
              "WHERE gfe01='",g_ima.ima31,"' ",
              "AND gfeacti IN ('y','Y')"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima31
      CALL s_errmsg('azp01,ima01,ima31',g_showmsg,'sel ima31','mfg1311',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima35()
   IF cl_null(g_ima.ima35) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM imd_file ",
             "WHERE imd01='",g_ima.ima35,"' AND imdacti='Y'"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima35
      CALL s_errmsg('azp01,ima01,ima35',g_showmsg,'sel ima35','mfg1100',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
#FUNCTION s_aimi100_chk_ima39()   #MOD-990247
#FUNCTION s_aimi100_chk_ima39(p_azp03)   #MOD-990247   #FUN-A50102
FUNCTION s_aimi100_chk_ima39(p_azp01)    #FUN-A50102
   DEFINE p_azp03   LIKE azp_file.azp03   #MOD-990247
   DEFINE l_dbs_sep LIKE type_file.chr50  #MOD-990247
   DEFINE l_aza81   LIKE aza_file.aza81   #MOD-990247
   DEFINE p_azp01   LIKE azp_file.azp01   #FUN-A50102 
 
   IF cl_null(g_ima.ima39) THEN
      RETURN TRUE
   END IF
 
   CALL s_dbstring(p_azp03) RETURNING l_dbs_sep
  #LET g_sql = "SELECT aza81 FROM ",l_dbs_sep CLIPPED,"aza_file"  #FUN-A50102
   LET g_sql = "SELECT aza81 FROM ",cl_get_target_table(p_azp01,'aza_file')  #FUN-A50102
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
   CALL cl_parse_qry_sql(g_sql,p_azp01) RETURNING g_sql  #FUN-A50102
   PREPARE db_cs5 FROM g_sql
   EXECUTE db_cs5 INTO l_aza81
   LET g_sql="SELECT COUNT(*) FROM aag_file ",
             "WHERE aag01 = '",g_ima.ima39,"' ",
             "  AND aag07 <> '1'",
             "  AND aag00 = '",l_aza81,"'"   #MOD-990247
 
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima39
      CALL s_errmsg('azp01,ima01,ima39',g_showmsg,'sel ima39','anm-001',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
 
#FUNCTION s_aimi100_chk_ima391(p_azp03)   #MOD-990247   #FUN-A50102
FUNCTION s_aimi100_chk_ima391(p_azp01)    #FUN-A50102
   DEFINE p_azp03   LIKE azp_file.azp03   #MOD-990247
   DEFINE l_dbs_sep LIKE type_file.chr50  #MOD-990247
   DEFINE l_aza82   LIKE aza_file.aza82   #MOD-990247
   DEFINE l_aza63   LIKE aza_file.aza63   #MOD-990247
   DEFINE p_azp01   LIKE azp_file.azp01   #FUN-A50102
 
   IF cl_null(g_ima.ima391) THEN
      RETURN TRUE
   END IF
 
   CALL s_dbstring(p_azp03) RETURNING l_dbs_sep
  #LET g_sql = "SELECT aza82,aza63 FROM ",l_dbs_sep CLIPPED,"aza_file"  #FUN-A50102
   LET g_sql = "SELECT aza82,aza63 FROM ",cl_get_target_table(p_azp01,'aza_file')   #FUN-A50102
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
   CALL cl_parse_qry_sql(g_sql,p_azp01) RETURNING g_sql   #FUN-A50102
   PREPARE db_cs6 FROM g_sql
   EXECUTE db_cs6 INTO l_aza82,l_aza63
   IF l_aza63 = 'N' THEN
      RETURN TRUE
   END IF
 
   LET g_sql="SELECT COUNT(*) FROM aag_file ",
             "WHERE aag01 = '",g_ima.ima391,"' ",
             "  AND aag07 <> '1'",
             "  AND aag00 = '",l_aza82,"'"   #MOD-990247
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima391
      CALL s_errmsg('azp01,ima01,ima391',g_showmsg,'sel ima391','anm-001',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima43()
   IF cl_null(g_ima.ima43) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM gen_file ",
             "WHERE gen01='",g_ima.ima43,"' ",
             "AND genacti='Y'"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima43
      CALL s_errmsg('azp01,ima01,ima43',g_showmsg,'sel ima43','apm-048',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima44()
   IF cl_null(g_ima.ima44) THEN
      RETURN TRUE
   END IF
   LET g_sql= "SELECT COUNT(*) FROM gfe_file ",
              "WHERE gfe01='",g_ima.ima44,"' ",
              "AND gfeacti IN ('y','Y')"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima44
      CALL s_errmsg('azp01,ima01,ima44',g_showmsg,'sel ima44','apm-047',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima54()
   IF cl_null(g_ima.ima54) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM pmc_file ",
             "WHERE pmc01 = '",g_ima.ima54,"' ",
             "AND pmcacti='Y'"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima54
      CALL s_errmsg('azp01,ima01,ima54',g_showmsg,'sel ima54','mfg3001',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima55()
   IF cl_null(g_ima.ima55) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM gfe_file ",
             "WHERE gfe01='",g_ima.ima55,"' ",
             "AND gfeacti IN ('y','Y')"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima55
      CALL s_errmsg('azp01,ima01,ima55',g_showmsg,'sel ima55','mfg1325',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima571()
   IF cl_null(g_ima.ima571) THEN
      RETURN TRUE
   END IF
   IF g_ima.ima01=g_ima.ima571 THEN
      RETURN TRUE
   END IF
   LET g_sql= "SELECT COUNT(*) FROM ecu_file ",
              "WHERE ecu01='",g_ima.ima571,"' ",
              " AND ecuacti = 'Y' "  #CHI-C90006
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima571
      CALL s_errmsg('azp01,ima01,ima571',g_showmsg,'sel ima571','aec-014',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima63()
   IF cl_null(g_ima.ima63) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM gfe_file ",
             "WHERE gfe01='",g_ima.ima63,"' ",
             "AND gfeacti IN ('y','Y')"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima63
      CALL s_errmsg('azp01,ima01,ima63',g_showmsg,'sel ima63','mfg1326',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima67()
   IF cl_null(g_ima.ima67) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM gen_file ",
             "WHERE gen01='",g_ima.ima67,"' ",
             "AND genacti='Y'"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima67
      CALL s_errmsg('azp01,ima01,ima67',g_showmsg,'sel ima67','arm-045',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima86()
   IF cl_null(g_ima.ima86) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM gfe_file ",
             "WHERE gfe01='",g_ima.ima86,"' ",
             "AND gfeacti IN ('y','Y')"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima86
      CALL s_errmsg('azp01,ima01,ima86',g_showmsg,'sel ima86','mfg1203',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima87()
   IF cl_null(g_ima.ima87) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM smg_file ",
             "WHERE smg01 = '",g_ima.ima87,"' ",
             "AND smgacti='Y'"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima87
      CALL s_errmsg('azp01,ima01,ima86',g_showmsg,'sel ima86','mfg1203',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima872()
   IF cl_null(g_ima.ima872) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM smg_file ",
             "WHERE smg01 = '",g_ima.ima872,"' ",
             "AND smgacti='Y'"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima872
      CALL s_errmsg('azp01,ima01,ima872',g_showmsg,'sel ima872','mfg1313',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima874()
   IF cl_null(g_ima.ima874) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM smg_file ",
             "WHERE smg01 = '",g_ima.ima874,"' ",
             "AND smgacti='Y'"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima874
      CALL s_errmsg('azp01,ima01,ima874',g_showmsg,'sel ima874','mfg1313',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima109()
   IF cl_null(g_ima.ima109) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM azf_file ",
             "WHERE azf01='",g_ima.ima109,"' AND azf02='8' ",
             "AND azfacti='Y'"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima109
      CALL s_errmsg('azp01,ima01,ima109',g_showmsg,'sel ima109','mfg1306',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima131()
   IF cl_null(g_ima.ima131) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM oba_file ",
             "WHERE oba01='",g_ima.ima131,"' "
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima131
      CALL s_errmsg('azp01,ima01,ima131',g_showmsg,'sel ima131','aim-142',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
#FUNCTION s_aimi100_chk_ima132(p_azp03)   #MOD-990247   #FUN-A50102
FUNCTION s_aimi100_chk_ima132(p_azp01)   #FUN-A50102
   DEFINE p_azp03   LIKE azp_file.azp03   #MOD-990247
   DEFINE l_dbs_sep LIKE type_file.chr50  #MOD-990247
   DEFINE l_aza81   LIKE aza_file.aza81   #MOD-990247
   DEFINE p_azp01   LIKE azp_file.azp01   #FUN-A50102

   IF cl_null(g_ima.ima132) THEN
      RETURN TRUE
   END IF
 
   CALL s_dbstring(p_azp03) RETURNING l_dbs_sep
  #LET g_sql = "SELECT aza81 FROM ",l_dbs_sep CLIPPED,"aza_file"   #FUN-A50102
   LET g_sql = "SELECT aza81 FROM ",cl_get_target_table(p_azp01,'aza_file')   #FUN-A50102
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql	
   CALL cl_parse_qry_sql(g_sql,p_azp01) RETURNING g_sql   #FUN-A50102
   PREPARE db_cs7 FROM g_sql
   EXECUTE db_cs7 INTO l_aza81
   LET g_sql="SELECT count(*) FROM aag_file ",
             "WHERE aag01 = '",g_ima.ima132,"' ",
             #"  AND aag00 = '",g_aza.aza81,"'"   #MOD-990247
             "  AND aag00 = '",l_aza81,"'"   #MOD-990247
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima132
      CALL s_errmsg('azp01,ima01,ima132',g_showmsg,'sel ima132','anm-001',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima133(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1
 
   IF cl_null(g_ima.ima133) THEN
      RETURN TRUE
   END IF
   #carrier add
   IF g_ima.ima01 = g_ima.ima133 THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM ima_file ",  
             " WHERE ima01 = '",g_ima.ima133,"' "
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima133
      CALL s_errmsg('azp01,ima01,ima133',g_showmsg,'sel ima133','axm-297',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima134()
   IF cl_null(g_ima.ima134) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM obe_file ",
             "WHERE obe01='",g_ima.ima134,"' "
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima134
      CALL s_errmsg('azp01,ima01,ima134',g_showmsg,'sel ima134','axm-810',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima136()
   IF cl_null(g_ima.ima136) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM imd_file ",
             "WHERE imd01='",g_ima.ima136,"' ",
             "AND imdacti='Y'"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima136
      CALL s_errmsg('azp01,ima01,ima136',g_showmsg,'sel ima136','mfg1100',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
FUNCTION s_aimi100_chk_ima137()
   IF cl_null(g_ima.ima137) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM ime_file ",
             "WHERE ime01='",g_ima.ima136,"' ",
             "AND ime02='",g_ima.ima137,"' ",
		"   AND imeacti='Y' "  #FUN-D40103 add
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima137
      CALL s_errmsg('azp01,ima01,ima137',g_showmsg,'sel ima137','mfg1101',1)
      RETURN FALSE
   ELSE
      RETURN TRUE
   END IF
END FUNCTION
 
#FUNCTION s_aimi100_chk_ima907(p_cmd,p_azp03)   #FUN-A50102
FUNCTION s_aimi100_chk_ima907(p_cmd,p_azp01)    #FUN-A50102
  DEFINE p_cmd           LIKE type_file.chr1
  DEFINE p_azp03         LIKE azp_file.azp03
  DEFINE l_factor        LIKE img_file.img21
  DEFINE p_azp01         LIKE azp_file.azp01    #FUN-A50102 

   IF cl_null(g_ima.ima907) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM gfe_file ",
             "WHERE gfe01='",g_ima.ima907,"' ",
             "AND gfeacti IN ('Y','y')"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima907
      CALL s_errmsg('azp01,ima01,ima907',g_showmsg,'sel ima907','mfg0019',1)
      RETURN FALSE
   END IF
 
   CALL s_du_umfchk1(g_ima.ima01,'','','',g_ima.ima25,
                    g_ima.ima907,g_ima.ima906,p_plant)  #No.FUN-980059
        RETURNING g_errno,l_factor
   IF NOT cl_null(g_errno) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima907
      CALL s_errmsg('azp01,ima01,ima907',g_showmsg,'sel ima907',g_errno,1)
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
 
#FUNCTION s_aimi100_chk_ima908(p_cmd,p_azp03)  #FUN-A50102
FUNCTION s_aimi100_chk_ima908(p_cmd,p_azp01)   #FUN-A50102
  DEFINE p_cmd    LIKE type_file.chr1
  DEFINE p_azp03  LIKE azp_file.azp03
  DEFINE l_factor LIKE img_file.img21
  DEFINE p_azp01  LIKE azp_file.azp01    #FUN-A50102
 
   IF cl_null(g_ima.ima908) THEN
      RETURN TRUE
   END IF
   LET g_sql="SELECT COUNT(*) FROM gfe_file ",
             "WHERE gfe01='",g_ima.ima908,"' ",
             "AND gfeacti IN ('Y','y')"
   IF NOT s_aimi100_chk_cur(g_sql) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima908
      CALL s_errmsg('azp01,ima01,ima908',g_showmsg,'sel ima908','mfg0019',1)
      RETURN FALSE
   END IF
 
   CALL s_du_umfchk1(g_ima.ima01,'','','',g_ima.ima25,
                    g_ima.ima908,'2',p_plant) #No.FUN-980059
        RETURNING g_errno,l_factor
   IF NOT cl_null(g_errno) THEN
      LET g_showmsg = g_dbs_sep,"/",g_ima.ima01,"/",g_ima.ima908
      CALL s_errmsg('azp01,ima01,ima908',g_showmsg,'sel ima908',g_errno,1)
      RETURN FALSE
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION s_aimi100_smd(p_ima01_old,p_ima01_new,p_azp01,p_gew07)
   DEFINE p_ima01_old     LIKE ima_file.ima01
   DEFINE p_ima01_new     LIKE ima_file.ima01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_smd_2         RECORD LIKE smd_file.*  #CHI-A60011 add
 
   FOREACH smd_cur USING p_ima01_old INTO g_smd.* 
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('smd01',g_smd.smd01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_ima01_new) THEN LET g_smd.smd01 = p_ima01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_smd.smd01,'+',g_smd.smd02,'+',g_smd.smd03,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_smd.smd01,'+',g_smd.smd02,'+',g_smd.smd03,':'
      EXECUTE db_cs1_smd USING g_smd.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
        #IF SQLCA.sqlcode = -239 THEN             #CHI-A50006 mark
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #CHI-A50006
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3,':exist'
               CALL ui.Interface.refresh()
               #No.FUN-A80036  --Begin
               LET g_success = 'N'
               #No.FUN-A80036  --End  
            ELSE
               #CHI-A60011 add --start--
               OPEN db_cs2_smd_lock USING p_ima01_old,g_smd.smd02,g_smd.smd03
               IF STATUS THEN
                  LET g_msg_x = p_azp01,':smd_file:lock'
                  LET g_showmsg = g_smd.smd01,'/',g_smd.smd02,'/',g_smd.smd03
                  CALL s_errmsg('smd01,smd02,smd03',g_showmsg,g_msg_x,STATUS,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_smd_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               FETCH db_cs2_smd_lock INTO l_smd_2.* 
               IF SQLCA.SQLCODE THEN
                  LET g_msg_x = p_azp01,':smd_file:lock'
                  LET g_showmsg = g_smd.smd01,'/',g_smd.smd02,'/',g_smd.smd03
                  CALL s_errmsg('smd01,smd02,smd03',g_showmsg,g_msg_x,SQLCA.SQLCODE,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_smd_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               #CHI-A60011 add --end--
               EXECUTE db_cs2_smd USING g_smd.*,p_ima01_old,g_smd.smd02,g_smd.smd03
               IF SQLCA.sqlcode = 0 THEN
                  IF g_success = 'Y' THEN
                     MESSAGE g_msg4,':ok'
                     CALL ui.Interface.refresh()
                  END IF
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_smd.smd01,'/',g_smd.smd02,'/',g_smd.smd03
                  CALL s_errmsg('smd01,smd02,smd03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
               CLOSE db_cs2_smd_lock #CHI-A60011 add
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_smd.smd01,'/',g_smd.smd02,'/',g_smd.smd03
            CALL s_errmsg('smd01,smd02,smd03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_smd.smd01||'+'||g_smd.smd02||'+'||g_smd.smd03,'1')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION s_aimi100_imc(p_ima01_old,p_ima01_new,p_azp01,p_gew07)
   DEFINE p_ima01_old     LIKE ima_file.ima01
   DEFINE p_ima01_new     LIKE ima_file.ima01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_imc_2         RECORD LIKE imc_file.*  #CHI-A60011 add
 
   FOREACH imc_cur USING p_ima01_old INTO g_imc.* 
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('imc01',g_imc.imc01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_ima01_new) THEN LET g_imc.imc01 = p_ima01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_imc.imc01,'+',g_imc.imc02,'+',g_imc.imc03,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_imc.imc01,'+',g_imc.imc02,'+',g_imc.imc03,':'
      EXECUTE db_cs1_imc USING g_imc.*
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg3,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
        #IF SQLCA.sqlcode = -239 THEN             #CHI-A50006 mark
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #CHI-A50006
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3,':exist'
               CALL ui.Interface.refresh()
               #No.FUN-A80036  --Begin
               LET g_success = 'N'
               #No.FUN-A80036  --End  
            ELSE
               #CHI-A60011 add --start--
               OPEN db_cs2_imc_lock USING p_ima01_old,g_imc.imc02,g_imc.imc03
               IF STATUS THEN
                  LET g_msg_x = p_azp01,':imc_file:lock'
                  LET g_showmsg = g_imc.imc01,'/',g_imc.imc02,'/',g_imc.imc03
                  CALL s_errmsg('imc01,imc02,imc03',g_showmsg,g_msg_x,STATUS,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_imc_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               FETCH db_cs2_imc_lock INTO l_imc_2.* 
               IF SQLCA.SQLCODE THEN
                  LET g_msg_x = p_azp01,':imc_file:lock'
                  LET g_showmsg = g_imc.imc01,'/',g_imc.imc02,'/',g_imc.imc03
                  CALL s_errmsg('imc01,imc02,imc03',g_showmsg,g_msg_x,SQLCA.SQLCODE,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_imc_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               #CHI-A60011 add --end--
               EXECUTE db_cs2_imc USING g_imc.*,p_ima01_old,g_imc.imc02,g_imc.imc03
               IF SQLCA.sqlcode = 0 THEN
                  IF g_success = 'Y' THEN
                     MESSAGE g_msg4,':ok'
                     CALL ui.Interface.refresh()
                  END IF
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_imc.imc01,'/',g_imc.imc02,'/',g_imc.imc03
                  CALL s_errmsg('imc01,imc02,imc03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
               CLOSE db_cs2_imc_lock  #CHI-A60011 add
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_imc.imc01,'/',g_imc.imc02,'/',g_imc.imc03
            CALL s_errmsg('imc01,imc02,imc03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_imc.imc01||'+'||g_imc.imc02||'+'||g_imc.imc03,'1')
      END IF
   END FOREACH
END FUNCTION
 
#CHI-A50006 add --start--
FUNCTION s_aimi100_gca(p_ima01_old,p_ima01_new,p_azp01,p_gew07)
   DEFINE p_ima01_old     LIKE ima_file.ima01
   DEFINE p_ima01_new     LIKE ima_file.ima01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_gca01_old     LIKE gca_file.gca01
   DEFINE l_n             LIKE type_file.num5

   LET l_gca01_old="ima01=",p_ima01_old

   EXECUTE db_cs2_gca USING l_gca01_old
   IF SQLCA.sqlcode = 0 THEN
      IF g_success = 'Y' THEN
         MESSAGE g_msg4,':ok'
         CALL ui.Interface.refresh()
      END IF
      OPEN gca_cur USING l_gca01_old
      FETCH gca_cur INTO g_gca.*
      EXECUTE db_cs2_gcb USING g_gca.gca07,g_gca.gca08,g_gca.gca09,g_gca.gca10
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            MESSAGE g_msg4,':ok'
            CALL ui.Interface.refresh()
         END IF
      #No.FUN-A80036  --Begin
      ELSE
         LET g_success = 'N'
      #No.FUN-A80036  --Begin
      END IF
      SELECT COUNT(*) INTO l_n FROM　gca_file 
         WHERE gca01 = l_gca01_old
           AND gca08 = 'FLD'
      IF l_n > 0 THEN 
          EXECUTE db_cs1_gca USING g_gca.*
          IF SQLCA.sqlcode = 0 THEN
             IF g_success = 'Y' THEN
                MESSAGE g_msg4,':ok'
                CALL ui.Interface.refresh()
             END IF
          ELSE
             LET g_msg_x = p_azp01,':ins'
             LET g_showmsg = g_gca.gca01,'/',g_gca.gca02,'/',g_gca.gca03,'/',g_gca.gca04,'/',g_gca.gca05,'/',g_gca.gca06
             CALL s_errmsg('gca01,gca02,gca03,gca04,gca05,gca06',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
             MESSAGE g_msg4,':fail'
             CALL ui.Interface.refresh()
             LET g_success = 'N'
          END IF
      END IF
   ELSE
      LET g_msg_x = p_azp01,':del'
      LET g_showmsg = g_gca.gca01,'/',g_gca.gca02,'/',g_gca.gca03,'/',g_gca.gca04,'/',g_gca.gca05,'/',g_gca.gca06
      CALL s_errmsg('gca01,gca02,gca03,gca04,gca05,gca06',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
      MESSAGE g_msg4,':fail'
      CALL ui.Interface.refresh()
      LET g_success = 'N'
   END IF
   #No.FUN-A80036  --Begin
   IF SQLCA.sqlerrd[3] > 0 THEN
   #IF g_success = 'Y' THEN  #此处不做修改
   #No.FUN-A80036  --End  
      CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_gca.gca01||'+'||g_gca.gca02||'+'||g_gca.gca03||'+'||g_gca.gca04||'+'||g_gca.gca05||'+'||g_gca.gca06,'1')
   END IF
END FUNCTION

FUNCTION s_aimi100_gcb(p_ima01_old,p_ima01_new,p_azp01,p_gew07)
   DEFINE p_ima01_old     LIKE ima_file.ima01
   DEFINE p_ima01_new     LIKE ima_file.ima01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_gca01_old     LIKE gca_file.gca01
   DEFINE l_n             LIKE type_file.num5

   LET l_gca01_old="ima01=",p_ima01_old
   SELECT COUNT(*) INTO l_n FROM　gcb_file 
      WHERE gcb01= g_gca.gca07
        AND gcb02= g_gca.gca08
        AND gcb03= g_gca.gca09
        AND gcb04= g_gca.gca10
   IF l_n > 0 THEN 
      EXECUTE db_cs1_gcb USING g_gca.gca07,g_gca.gca08,g_gca.gca09,g_gca.gca10
      IF SQLCA.sqlcode = 0 THEN
         IF g_success = 'Y' THEN
            #--- FUN-BB0031 add star ---
            IF SQLCA.sqlerrd[3] > 0 THEN
               CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_gca.gca07||'+'||g_gca.gca08||'+'||g_gca.gca09||'+'||g_gca.gca10,'1')    
            END IF
            #--- FUN-BB0031 add end ---
            MESSAGE g_msg4,':ok'
            CALL ui.Interface.refresh()
         END IF
      ELSE
         LET g_msg_x = p_azp01,':ins'
         LET g_showmsg = g_gcb.gcb01,'/',g_gcb.gcb02,'/',g_gcb.gcb03,'/',g_gcb.gcb04
         CALL s_errmsg('gcb01,gcb02,gcb03,gcb04',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
         MESSAGE g_msg4,':fail'
         CALL ui.Interface.refresh()
         LET g_success = 'N'
      END IF
  END IF
  #--- FUN-BB0031 Mark star ---
  #No.FUN-A80036  --Begin
  #IF SQLCA.sqlerrd[3] > 0 THEN
  #IF g_success = 'Y' THEN  #此处不做修改
  #No.FUN-A80036  --End  
  #   CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_gcb.gcb01||'+'||g_gcb.gcb02||'+'||g_gcb.gcb03||'+'||g_gcb.gcb04,'1')
  #END IF
  #--- FUN-BB0031 Mark end ---
END FUNCTION
#CHI-A50006 add --end--

FUNCTION s_aimi100_carry_p1()
   DEFINE l_i                  LIKE type_file.num10
   DEFINE l_tabname            STRING                    #No.FUN-A80036         
   DEFINE l_str                STRING                    #No.FUN-A80036
 
  #FUN-AC0026---mark---str---
  #CALL s_dc_cre_temp_table("ima_file") RETURNING l_tabname
  #FUN-AC0026---mark---end---
  #FUN-AC0026---add----str---
   IF g_prog <> 'aws_ttsrv2' THEN 
       CALL s_dc_cre_temp_table("ima_file") RETURNING l_tabname
   ELSE
       LET l_tabname = g_dc_tabname
   END IF
  #FUN-AC0026---add----end---
   #No.FUN-A80036  --Begin
   #LET g_sql = " CREATE UNIQUE INDEX ima_file_bak_01 ON ",l_tabname CLIPPED,"(ima01)"
   LET g_sql = " CREATE UNIQUE INDEX ",l_tabname CLIPPED,"_01 ON ",l_tabname CLIPPED,"(ima01)"
   #No.FUN-A80036  --End  
   PREPARE unique_p1 FROM g_sql
   EXECUTE unique_p1
 
   LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM ima_file",
                                                 "  WHERE ima01 = ?"
   PREPARE ins_pp FROM g_sql
 
   LET g_all_cnt = 0
   IF cl_null(g_flagx) THEN LET g_flagx = '0' END IF
   IF g_flagx <> '1' THEN
      FOR l_i = 1 TO g_ima_1.getLength()
          IF cl_null(g_ima_1[l_i].ima01) THEN
             CONTINUE FOR
          END IF
          IF g_ima_1[l_i].sel = 'N' THEN
             CONTINUE FOR
          END IF
          EXECUTE ins_pp USING g_ima_1[l_i].ima01
          IF SQLCA.sqlcode THEN
             LET l_str = "ins ",l_tabname                   #No.FUN-A80036      
            #IF g_bgerr THEN                                #No.FUN-AC0026 mark
             IF g_bgerr OR g_prog = 'aws_ttsrv2' THEN       #No.FUN-AC0026 add
                CALL s_errmsg('','',l_str,SQLCA.sqlcode,1)  #No.FUN-A80036      
             ELSE                                                               
                CALL cl_err(l_str,SQLCA.sqlcode,1)          #No.FUN-A80036      
             END IF
             CONTINUE FOR
          END IF
          LET g_all_cnt = g_all_cnt + 1
      END FOR
   ELSE
      LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM ima_file_bak1"
      PREPARE ins_ppx FROM g_sql
      EXECUTE ins_ppx
      LET g_sql = " SELECT COUNT(*) FROM ",l_tabname
      PREPARE cnt_ppx FROM g_sql
      EXECUTE cnt_ppx INTO g_all_cnt
      IF cl_null(g_all_cnt) THEN LET g_all_cnt = 0 END IF
   END IF
   RETURN l_tabname
END FUNCTION   
 
FUNCTION s_aimi100_download(p_ima)
  DEFINE p_ima        DYNAMIC ARRAY OF RECORD 
                      sel      LIKE type_file.chr1,
                      ima01    LIKE ima_file.ima01
                      END RECORD
  DEFINE l_path       LIKE ze_file.ze03
  DEFINE l_i          LIKE type_file.num10
 
    #前置准備
    FOR l_i = 1 TO p_ima.getLength()
        LET g_ima_1[l_i].* = p_ima[l_i].*
    END FOR
 
    CALL s_dc_download_path() RETURNING l_path
    IF cl_null(l_path) THEN RETURN END IF
    CALL s_aimi100_download_files(l_path)
 
END FUNCTION
 
FUNCTION s_aimi100_download_files(p_path)
  DEFINE p_path            LIKE ze_file.ze03
  DEFINE l_download_file   LIKE ze_file.ze03
  DEFINE l_upload_file     STRING   #LIKE ze_file.ze03  #No:MOD-9B0002 modify
  DEFINE l_status          LIKE type_file.num5
  DEFINE l_n               LIKE type_file.num5
  DEFINE l_i               LIKE type_file.num5
  DEFINE l_tempdir         LIKE ze_file.ze03
  DEFINE l_temp_file       LIKE ze_file.ze03                                    
  DEFINE l_temp_file1      LIKE ze_file.ze03                                    
  DEFINE l_tabname         LIKE type_file.chr50
                                                                                
   LET l_tempdir=FGL_GETENV("TEMPDIR")
   LET l_n=LENGTH(l_tempdir)
   IF l_n>0 THEN
      IF l_tempdir[l_n,l_n]='/' THEN
         LET l_tempdir[l_n,l_n]=' '
      END IF
   END IF
   LET l_n=LENGTH(p_path)
   IF l_n>0 THEN
      IF p_path[l_n,l_n]='/' THEN
         LET p_path[l_n,l_n]=' '
      END IF
   END IF
 
   LET l_tempdir    = fgl_getenv('TEMPDIR')                                     
 
   #建立臨時表,用于存放拋轉的資料
   CALL s_aimi100_carry_p1() RETURNING l_tabname
 
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog CLIPPED,'_ima_file_1.txt'  #No.FUN-830090
   LET l_download_file = p_path CLIPPED,"/",g_prog CLIPPED,"_ima_file_1.txt"   #No.FUN-830090
   IF os.Path.exists(l_upload_file.trim()) THEN    #No:MOD-9B0002 add
      LET g_sql = "rm ",l_upload_file CLIPPED
      RUN g_sql 
   END IF                                       #No:MOD-9B0002 add
   
   LET g_sql = "SELECT * FROM ",l_tabname
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
   
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   IF os.Path.exists(l_upload_file.trim()) THEN    #No:MOD-9B0002 add
      LET g_sql = "rm ",l_upload_file CLIPPED
      RUN g_sql 
   END IF                                       #No:MOD-9B0002 add
 
   #smd
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog CLIPPED,'_smd_file_1.txt'  #No.FUN-830090
   LET l_download_file = p_path CLIPPED,"/",g_prog CLIPPED,"_smd_file_1.txt"   #No.FUN-830090
   IF os.Path.exists(l_upload_file.trim()) THEN    #No:MOD-9B0002 add
      LET g_sql = "rm ",l_upload_file CLIPPED
      RUN g_sql 
   END IF                                       #No:MOD-9B0002 add
   
   LET g_sql = "SELECT * FROM smd_file WHERE ",
               "   smd01 IN (SELECT ima01 FROM ",l_tabname CLIPPED,")"
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
   
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   IF os.Path.exists(l_upload_file.trim()) THEN    #No:MOD-9B0002 add
      LET g_sql = "rm ",l_upload_file CLIPPED
      RUN g_sql 
   END IF                                       #No:MOD-9B0002 add
 
   #imc
   LET l_upload_file = l_tempdir CLIPPED,'/',g_prog CLIPPED,'_imc_file_1.txt'  #No.FUN-830090
   LET l_download_file = p_path CLIPPED,"/",g_prog CLIPPED,"_imc_file_1.txt"   #No.FUN-830090
   IF os.Path.exists(l_upload_file.trim()) THEN    #No:MOD-9B0002 add
      LET g_sql = "rm ",l_upload_file CLIPPED
      RUN g_sql 
   END IF                                       #No:MOD-9B0002 add
   
   LET g_sql = "SELECT * FROM imc_file WHERE ",
               "   imc01 IN (SELECT ima01 FROM ",l_tabname CLIPPED,")"
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload',SQLCA.sqlcode,1)
   END IF
   
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   IF os.Path.exists(l_upload_file.trim()) THEN    #No:MOD-9B0002 add
      LET g_sql = "rm ",l_upload_file CLIPPED
      RUN g_sql 
   END IF                                       #No:MOD-9B0002 add
 
   #imaicd
   IF s_industry('icd') THEN
      LET l_upload_file = l_tempdir CLIPPED,'/',g_prog CLIPPED,'_imaicd_file_1.txt'  #No.FUN-830090
      LET l_download_file = p_path CLIPPED,"/",g_prog CLIPPED,"_imaicd_file_1.txt"   #No.FUN-830090
      IF os.Path.exists(l_upload_file.trim()) THEN    #No:MOD-9B0002 add
         LET g_sql = "rm ",l_upload_file CLIPPED
         RUN g_sql 
      END IF                                       #No:MOD-9B0002 add
      
      LET g_sql = "SELECT * FROM imaicd_file WHERE ",
                  "   imaicd00 IN (SELECT ima01 FROM ",l_tabname CLIPPED,")"
      UNLOAD TO l_upload_file g_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('unload',SQLCA.sqlcode,1)
      END IF
      
      CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
      IF l_status THEN
         MESSAGE 'Download:ok'
      ELSE
         CALL cl_err(l_upload_file,STATUS,1)
         RETURN
      END IF
      IF os.Path.exists(l_upload_file.trim()) THEN    #No:MOD-9B0002 add
         LET g_sql = "rm ",l_upload_file CLIPPED
         RUN g_sql 
      END IF                                       #No:MOD-9B0002 add
   END IF
 
END FUNCTION
 
#aimi150的邏輯
FUNCTION i150_dbs(p_imaa) 
   DEFINE p_imaa        RECORD LIKE imaa_file.*
   DEFINE l_ans         LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_exit_sw     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_c,l_s,i     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_cnt         LIKE type_file.num5     #No.FUN-690026 SMALLINT
   DEFINE l_check       LIKE type_file.chr1     #No.MOD-810253 add
   DEFINE l_gew03        LIKE gew_file.gew03    #FUN-950057                     
   DEFINE l_gev04        LIKE gev_file.gev04    #FUN-950057                     
   DEFINE l_flag        LIKE type_file.chr1     #FUN-950057
   DEFINE l_count       LIKE type_file.num5     #FUN-BC0100
   DEFINE l_icu01       LIKE icu_file.icu01     #FUN-C40011
   DEFINE l_icu02       LIKE icu_file.icu02     #FUN-C40011
 
   LET g_imaa.* = p_imaa.*
 
   #TQC-C50255--mark--str--
   #IF g_imaa.imaa1010='2' THEN
   #    #已拋轉，不可再異動!
   #    CALL cl_err(g_imaa.imaano,'axm-225',1)
   #    LET g_success = 'N'
   #    RETURN
   #END IF
   #TQC-C50255--mark--end--
 
   #IF g_imaa.imaa1010!='1' THEN               #TQC-C50255 mark
   IF g_imaa.imaa1010 NOT MATCHES '[12]' THEN  #TQC-C50255 add
       #不在確認狀態，不可異動！
       CALL cl_err('','atm-053',0)
       RETURN 
   END IF
 
   IF s_shut(0) THEN RETURN END IF
   
   CALL tm.clear()
   LET g_gev04 = NULL
   #是否為資料中心的拋轉DB
   SELECT gev04 INTO g_gev04 FROM gev_file 
    WHERE gev01 = '1' AND gev02 = g_plant
      AND gev03 = 'Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gev04,'aoo-036',0)  #FUN-960186
      RETURN
   END IF
   #NO.FUN-840018 end------------------------------
 
   CALL s_carry_data() 
 
   IF cl_null(g_gew03) THEN 
      CALL cl_err('','aim-201',1)
      RETURN 
   END IF 
   
   IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
   END IF
   LET l_check = 'N' 
   FOR i = 1 TO tm.getLength()   #CHI-870044
       #IF tm[i].a = 'Y' THEN
       IF tm[i].sel = 'Y' THEN   #NO.FUN-840018
          LET l_check = 'Y'
          EXIT FOR
       END IF
   END FOR
#FUN-950057 -------------------------add start-------------------------
   SELECT gev04 INTO l_gev04 FROM gev_file                                      
    WHERE gev01 = '1' and gev02 = g_plant                                       
   SELECT DISTINCT gew03 INTO l_gew03 FROM gew_file                               
    WHERE gew01 = l_gev04                                                       
      AND gew02 = '1'                                                           
   #chech是否所有营运中心皆己存在此料号抛转                                     
   LET l_flag = 'N'                                                             
   FOR i = 1 TO tm.getLength()                                                  
       IF tm[i].exist = 'N' THEN                                                
          LET l_flag = 'Y'                                                      
          EXIT FOR                                                              
       ELSE                                                                     
          LET l_flag = 'N'                                                      
       END IF                                                                   
   END FOR                                                                      
   IF l_gew03 = '2' THEN
      IF NOT cl_confirm('anm-929') THEN RETURN END IF   #是否確定拋轉以上資料?
   END IF 
#FUN-950057 ------------------------add end-----------------------------------
  #IF l_check ='N' THEN                        #FUN-950057 mark
   IF l_gew03 = '3' AND l_check ='N' AND l_flag = 'Y' THEN   #FUN-950057
      CALL cl_err('','aim-505',1)
      RETURN
   END IF
#FUN-950057 ---------------------add start----------------------------------
   IF l_check = 'N' AND l_flag = 'N' THEN                                       
       CALL cl_err('','aim1009',1)                                              
   END IF
#FUN-950057 --------------------add end-------------------------------------
   LET l_flag = ' '          #FUN-950057 add 
 # IF NOT cl_confirm('anm-929') THEN RETURN END IF    #是否確定拋轉以上資料?  #FUN-950057 mark
 
   CALL s_showmsg_init()  #No.MOD-840397

   #建立歷史資料拋轉的臨時表
   CALL s_dc_cre_temp_table("gex_file") RETURNING l_hist_tab   #CHI-A60011 add

   BEGIN WORK
 
   LET g_success='Y'
   FOR i = 1 TO tm.getLength()   #CHI-870044
       IF cl_null(tm[i].azp03) OR tm[i].sel = 'N' THEN LET g_success='N' CONTINUE FOR END IF 
       LET g_success='Y' 
       EXIT FOR      
   END FOR
   IF g_success = 'Y' THEN   #MOD-A50071
      IF g_imaa.imaa00 = 'I' THEN   #MOD-A50071 AND g_success='Y' THEN   #MOD-840117 modify g_success='Y'
         #FUN-C40011---begin
         IF s_industry('icd') AND NOT cl_null(g_imaa.imaaicd01) THEN
            SELECT icu01,icu02 INTO l_icu01,l_icu02
              FROM icu_file WHERE icu01 = g_imaa.imaaicd01
               AND icu02 = g_imaa.imaa94
            IF SQLCA.sqlcode = 0 THEN
               #FUN-C50132---begin
               CALL i150_dbs_ins() #新增   
               UPDATE imaicd_file
               SET imaicd11 = g_imaa.imaano
               WHERE imaicd00 = g_imaa.imaa01
               #FUN-C50132---end
               CALL i150_dbs_icd_ins(l_icu01,l_icu02) #新增
            ELSE
               CALL i150_dbs_ins() #新增
            END IF
         ELSE
         #FUN-C40011---end
            CALL i150_dbs_ins() #新增
         END IF  #FUN-C40011
      ELSE
         CALL i150_dbs_upd() #修改
      END IF
   END IF   #MOD-A50071
   IF g_success = 'Y' THEN
       #更新狀況碼
       UPDATE imaa_file
          SET imaa1010 = '2' #已拋轉
        WHERE imaano = g_imaa.imaano
       IF SQLCA.sqlcode OR sqlca.sqlerrd[3] <= 0 THEN
           #狀況碼更新不成功
           CALL s_errmsg('imaano',g_imaa.imaano,'','lib-30',1)
           LET g_success = 'N'
       END IF
   END IF
   IF g_success='Y' THEN
      #FUN-BC0100---begin---
      IF s_industry('icd') THEN
         LET l_count = 0
         IF NOT cl_null(g_imaa.imaaicd01) THEN
            SELECT COUNT(1) INTO l_count FROM icf_file
            WHERE icf01 = g_imaa.imaaicd01
            IF l_count = 0 THEN
               INSERT INTO icf_file(icf01,icf02,icf04,icf05)
                VALUES(g_imaa.imaaicd01,'BIN01','Y','0')
            END IF
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('imaaicd01',g_imaa.imaaicd01,'',SQLCA.sqlcode,1)
            END IF
         END IF
         LET l_count = 0
         IF NOT cl_null(g_imaa.imaaicd16) THEN
            SELECT COUNT(1) INTO l_count FROM icf_file
            WHERE icf01 = g_imaa.imaaicd16
            IF l_count = 0 THEN
               INSERT INTO icf_file(icf01,icf02,icf04,icf05)
               VALUES(g_imaa.imaaicd16,'BIN01','Y','0')
            END IF
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('imaaicd16',g_imaa.imaaicd16,'',SQLCA.sqlcode,1)
            END IF
         END IF
      END IF
      #FUN-BC0100---end---
      COMMIT WORK
      CALL cl_cmmsg(4)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(4)
   END IF
   CALL s_dc_drop_temp_table(l_hist_tab)   #CHI-A60011 add
   CALL s_showmsg()       #No.MOD-840397
   SELECT * INTO g_imaa.* FROM imaa_file WHERE imaano = g_imaa.imaano        #TQC-9A0125 Add
END FUNCTION
 
FUNCTION i150_dbs_ins()
   DEFINE l_imaa        RECORD LIKE imaa_file.*   #061113
   DEFINE i             LIKE type_file.num5       #No.FUN-690026 SMALLINT
   DEFINE l_imaicd      RECORD LIKE imaicd_file.* #No.FUN-7B0018
   DEFINE l_cnt         LIKE type_file.num5    #No.MOD-810229
   DEFINE l_str         LIKE gca_file.gca01    #No.MOD-810229
   DEFINE l_gew08              LIKE gew_file.gew08     #for mail
  #DEFINE l_hist_tab           LIKE type_file.chr50    #for mail   #CHI-A60011 mark
   DEFINE l_hs_flag            LIKE type_file.chr1     #for mail
   DEFINE l_hs_path            LIKE ze_file.ze03       #for mail
   DEFINE l_j                  LIKE type_file.num10
   DEFINE l_gew05              LIKE gew_file.gew05
   DEFINE l_gew07              LIKE gew_file.gew07
   DEFINE l_all_cnt            LIKE type_file.num5    
   DEFINE l_cur_cnt            LIKE type_file.num5
   DEFINE l_ima_ins            LIKE type_file.chr1   #NO.FUN-840033
   DEFINE l_imaa1              RECORD LIKE imaa_file.*  #No.MOD-840397
   DEFINE l_ima                RECORD LIKE ima_file.*   #No.CHI-890001 add
   DEFINE l_db                 LIKE type_file.chr50     #No.TQC-9B0003
   DEFINE l_sql                STRING   #FUN-B50106 
   DEFINE l_ima928             LIKE ima_file.ima928     #CHI-C30038
   DEFINE l_value1             LIKE type_file.chr30   #CHI-CB0017 add
   DEFINE l_value2             LIKE type_file.chr30   #CHI-CB0017 add

   MESSAGE ' COPY FOR INSERT .... '
 
  #讀取相關資料..........................................
   SELECT * INTO l_imaa.* FROM imaa_file 
    WHERE imaano = g_imaa.imaano
#FUN-B50106 -------------Begin--------------
#FUN-B30043--add--begin
# IF NOT s_industry('std') THEN  #FUN-B30156 
#   SELECT * INTO l_imaicd.*
#             FROM imaicd_file
#            WHERE imaicd00=g_imaa.imaa01
# END IF                         #FUN-B30156
#FUN-B50106 -------------End----------------
#FUN-B30043--add--end 
   IF STATUS THEN 
       #CALL cl_err(g_msg,SQLCA.sqlcode,1)
       CALL s_errmsg('imaano',g_imaa.imaano,'',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
   END IF
 
   LET l_imaa1.* = l_imaa.*   #No.MOD-840397
 
   LET l_str = 'imaa01=',l_imaa.imaa01
   DROP TABLE x
   DROP TABLE y
   SELECT * FROM gca_file WHERE gca01=l_str AND gca09='imaa04' INTO TEMP x
   SELECT gcb01,gcb02,gcb03,gcb04,gcb05,gcb06,gcb07,gcb08,gcb09,
          gcb10,gcb11,gcb12,gcb13,gcb14,gcb15,gcb16,gcb17,gcb18
            FROM gcb_file,gca_file WHERE gca01=l_str AND gca09='imaa04'
                                     AND gca07 = gcb01 AND gcb03='imaa04'
                                     INTO TEMP y
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM x
   IF l_cnt > 0 THEN
      LET l_str = 'ima01=',l_imaa.imaa01
      UPDATE x SET gca01 = l_str,
                   gca09 = 'ima04'
      UPDATE y SET gcb03 = 'ima04'
      FOR i = 1 TO tm.getLength()   #CHI-870044
          IF cl_null(tm[i].azp03) OR tm[i].sel = 'N' THEN  CONTINUE FOR END IF  #no.FUN-840018  mod
          #CALL s_dbstring(tm[i].azp03 CLIPPED) RETURNING l_db #CHI-A60011 mark
          #LET g_sql='INSERT INTO ',l_db CLIPPED,'gca_file SELECT * FROM x'  #NO.FUN-840018 mod #CHI-A60011 mark
          LET g_sql='INSERT INTO ',cl_get_target_table(tm[i].azp01,'gca_file'),' SELECT * FROM x'  #CHI-A60011
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #CHI-A60011 add
          CALL cl_parse_qry_sql(g_sql,tm[i].azp01) RETURNING g_sql  #FUN-A50102
          EXECUTE IMMEDIATE g_sql
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              #LET g_msg = 'INSERT ',l_db CLIPPED,'ima_file'  #NO.FUN-840018 MOD #CHI-A60011 mark
              LET g_msg = 'INSERT ',cl_get_target_table(tm[i].azp01,'ima_file')  #CHI-A60011
              LET g_showmsg = tm[i].azp03,'/',l_str
              CALL s_errmsg('azp03,gca01',g_showmsg,g_msg,'lib-028',1) 
              LET g_success = 'N'
              EXIT FOR
          END IF
 
          #LET g_sql='INSERT INTO ',l_db CLIPPED,'gcb_file SELECT * FROM y'  #NO.FUN-840018 MOD #CHI-A60011 mark
          LET g_sql='INSERT INTO ',cl_get_target_table(tm[i].azp01,'gcb_file'),' SELECT * FROM y'  #CHI-A60011
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #CHI-A60011 add
          CALL cl_parse_qry_sql(g_sql,tm[i].azp01) RETURNING g_sql  #FUN-A50102
          EXECUTE IMMEDIATE g_sql
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              #LET g_msg = 'INSERT ',l_db CLIPPED,'ima_file'  #NO.FUN-840018 MOD #CHI-A60011 mark
              LET g_msg = 'INSERT ',cl_get_target_table(tm[i].azp01,'ima_file')  #CHI-A60011
              LET g_showmsg = tm[i].azp03,'/',l_str
              CALL s_errmsg('azp03,gcb01',g_showmsg,g_msg,'lib-028',1) 
              LET g_success = 'N'
              EXIT FOR
          END IF
      END FOR
   END IF
 
   LET g_dbase=NULL   #CHI-890001
   LET g_azp01 = NULL   #FUN-A50102
   FOR i = 1 TO tm.getLength()   #CHI-870044
       
       LET l_ima_ins = 'N'    #NO.FUN-840033 add
       #建立歷史資料拋轉的臨時表
      #CALL s_dc_cre_temp_table("gex_file") RETURNING l_hist_tab   #CHI-A60011 mark
       IF cl_null(tm[i].azp03) THEN CONTINUE FOR END IF
       IF tm[i].sel = 'N' THEN CONTINUE FOR END IF
 
       SELECT gew05,gew07,gew08 INTO l_gew05,l_gew07,l_gew08 FROM gew_file
        WHERE gew01 = g_gev04
          AND gew02 = '1'
          AND gew04 = tm[i].azp01
       IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF
 
       #mail_1                                                              
       CALL s_dc_carry_send_mail_1(tm[i].azp01,i,g_gev04,'1',l_hist_tab)
        RETURNING l_hs_flag,l_hs_path
 
       IF cl_null(tm[i].azp03) OR tm[i].sel = 'N' THEN  CONTINUE FOR END IF  #NO.FUN-840018 MOD
       LET g_dbase=tm[i].azp03 CLIPPED   #MOD-A20098 mod
       LET g_azp01 = tm[i].azp01 CLIPPED  #FUN-A50102
       IF tm[i].azp01 <> g_plant AND g_aza.aza26 <> '2' THEN   #MOD-8A0257 add  #TQC-C70016 add g_aza.aza26
          CALL i150_default_imz(l_imaa.*) RETURNING l_imaa.*   #CHI-890001 add
       ELSE
          LET l_imaa.* = l_imaa1.*
       END IF                                                  #MOD-8A0257 add
         #CHI-C30038---begin
         IF NOT cl_null(l_imaa.imaa929) THEN
            LET l_ima928 = 'N'
            LET g_sql = "SELECT ima928 FROM ",cl_get_target_table(tm[i].azp01, 'ima_file'),
                         " WHERE ima01 = ?"
            LET g_sql = cl_forupd_sql(g_sql)
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,tm[i].azp01) RETURNING g_sql 
            #DECLARE db_cs2_imc_lock CURSOR FROM g_sql
            PREPARE pr_ima928_1 FROM g_sql  
            EXECUTE pr_ima928_1 USING l_imaa.imaa929 INTO l_ima928 

            IF l_ima928 <> 'Y' THEN
               LET g_showmsg = g_plant,":",l_imaa.imaa01
               CALL s_errmsg('ima928',g_showmsg,l_imaa.imaa929,'aoo-306',1)
               LET g_success = 'N'
            END IF 
         END IF  
         #CHI-C30038---end
         LET l_imaa.imaa1010 = '1'    #TQC-C80003
       #CALL s_dbstring(tm[i].azp03 CLIPPED) RETURNING l_db #CHI-A60011 mark
       #LET g_sql='INSERT INTO ',l_db CLIPPED,'ima_file(',   #NO.FUN-840018 MOD #CHI-A60011 mark
       LET g_sql='INSERT INTO ',cl_get_target_table(tm[i].azp01,'ima_file'),'(',   #CHI-A60011
 ' ima01      ,', 
 ' ima02      ,', 
 ' ima021     ,', 
 ' ima03      ,', 
 ' ima04      ,', 
 ' ima05      ,', 
 ' ima06      ,', 
 ' ima07      ,', 
 ' ima08      ,', 
 ' ima09      ,', 
 ' ima10      ,', 
 ' ima11      ,', 
 ' ima12      ,', 
 ' ima13      ,', 
 ' ima14      ,', 
 ' ima15      ,', 
 ' ima16      ,', 
 ' ima17      ,', 
 ' ima17_fac  ,', 
 ' ima18      ,', 
 ' ima19      ,', 
 ' ima20      ,', 
 ' ima21      ,', 
 ' ima22      ,', 
 ' ima23      ,', 
 ' ima24      ,', 
 ' ima25      ,', 
#' ima26      ,', #No.FUN-A40023
#' ima261     ,', #No.FUN-A40023
#' ima262     ,', #No.FUN-A40023#No.FUN-A40023
 ' ima27      ,', 
 ' ima271     ,', 
 ' ima28      ,', 
 ' ima29      ,', 
 ' ima30      ,', 
 ' ima31      ,', 
 ' ima31_fac  ,', 
 ' ima32      ,', 
 ' ima33      ,', 
 ' ima34      ,', 
 ' ima35      ,', 
 ' ima36      ,', 
 ' ima37      ,', 
 ' ima38      ,', 
 ' ima39      ,', 
 ' ima40      ,', 
 ' ima41      ,', 
 ' ima42      ,', 
 ' ima43      ,', 
 ' ima44      ,', 
 ' ima44_fac  ,', 
 ' ima45      ,', 
 ' ima46      ,', 
 ' ima47      ,', 
 ' ima48      ,', 
 ' ima49      ,', 
 ' ima491     ,', 
 ' ima50      ,', 
 ' ima51      ,', 
 ' ima52      ,', 
 ' ima53      ,', 
 ' ima531     ,', 
 ' ima532     ,', 
 ' ima54      ,', 
 ' ima55      ,', 
 ' ima55_fac  ,', 
 ' ima56      ,', 
 ' ima561     ,', 
 ' ima562     ,', 
 ' ima57      ,', 
 ' ima571     ,', 
 ' ima58      ,', 
 ' ima59      ,', 
 ' ima60      ,', 
 ' ima61      ,', 
 ' ima62      ,', 
 ' ima63      ,', 
 ' ima63_fac  ,', 
 ' ima64      ,', 
 ' ima641     ,', 
 ' ima65      ,', 
 ' ima66      ,', 
 ' ima67      ,', 
 ' ima68      ,',
 ' ima69      ,',
 ' ima70      ,', 
 ' ima71      ,', 
 ' ima72      ,', 
 ' ima721     ,',  #CHI-C50068
 ' ima73      ,', 
 ' ima74      ,', 
 ' ima86      ,', 
 ' ima86_fac  ,', 
 ' ima87      ,', 
 ' ima871     ,', 
 ' ima872     ,', 
 ' ima873     ,', 
 ' ima874     ,', 
 ' ima88      ,', 
 ' ima881     ,', 
 ' ima89      ,',    #FUN-AB0011 add 
 ' ima90      ,', 
 ' ima91      ,', 
 ' ima92      ,', 
 ' ima93      ,', 
 ' ima94      ,', 
 ' ima95      ,', 
 ' ima75      ,', 
 ' ima76      ,', 
 ' ima77      ,', 
 ' ima78      ,', 
 ' ima79      ,', 
 ' ima80      ,', 
 ' ima81      ,', 
 ' ima82      ,', 
 ' ima83      ,', 
 ' ima84      ,', 
 ' ima85      ,', 
 ' ima851     ,', 
 ' ima852     ,', 
 ' ima853     ,', 
 ' ima96      ,', 
 ' ima97      ,', 
 ' ima98      ,', 
 ' ima99      ,', 
 ' ima100     ,', 
 ' ima101     ,', 
 ' ima102     ,', 
 ' ima103     ,', 
 ' ima104     ,', 
 ' ima105     ,', 
 ' ima106     ,', 
 ' ima107     ,', 
 ' ima108     ,', 
 ' ima109     ,', 
 ' ima110     ,', 
 ' ima111     ,', 
 ' ima121     ,', 
 ' ima122     ,', 
 ' ima123     ,', 
 ' ima124     ,', 
 ' ima125     ,', 
 ' ima126     ,', 
 ' ima127     ,', 
 ' ima128     ,', 
 ' ima129     ,', 
 ' ima130     ,', 
 ' ima131     ,', 
 ' ima132     ,', 
 ' ima133     ,', 
 ' ima134     ,', 
 ' ima135     ,', 
 ' ima136     ,', 
 ' ima137     ,', 
 ' ima138     ,', 
 ' ima139     ,', 
 ' ima140     ,', 
 ' ima141     ,', 
 ' ima142     ,', 
 ' ima143     ,', 
 ' ima144     ,', 
 ' ima145     ,', 
 ' ima146     ,', 
 ' ima147     ,',
 ' ima148     ,',
 ' ima901     ,', 
 ' ima902     ,', 
 ' ima903     ,', 
 ' ima904     ,', 
 ' ima905     ,', 
 ' ima906     ,', 
 ' ima907     ,', 
 ' ima908     ,', 
 ' ima909     ,',
 ' ima153     ,',      #FUN-9C0141 
 ' ima910     ,',
 ' imaacti    ,', 
 ' imauser    ,', 
 ' imagrup    ,', 
 ' imamodu    ,', 
 ' imadate    ,', 
 ' imaag      ,', 
 ' imaag1     ,', 
 ' imaud01    ,', 
 ' imaud02    ,', 
 ' imaud03    ,', 
 ' imaud04    ,', 
 ' imaud05    ,', 
 ' imaud06    ,', 
 ' imaud07    ,', 
 ' imaud08    ,', 
 ' imaud09    ,', 
 ' imaud10    ,', 
 ' imaud11    ,', 
 ' imaud12    ,', 
 ' imaud13    ,', 
 ' imaud14    ,', 
 ' imaud15    ,', 
 ' ima1001    ,', 
 ' ima1002    ,', 
 ' ima1003    ,', 
 ' ima1004    ,', 
 ' ima1005    ,', 
 ' ima1006    ,', 
 ' ima1007    ,', 
 ' ima1008    ,', 
 ' ima1009    ,', 
 ' ima1010    ,', 
 ' ima1011    ,', 
 ' ima1012    ,', 
 ' ima1013    ,', 
 ' ima1014    ,', 
#' ima1015    ,',   #CHI-CA0073 mark 
 ' ima1401    ,',   #CHI-CA0073 add
 ' ima1016    ,', 
 ' ima1017    ,', 
 ' ima1018    ,', 
 ' ima1019    ,', 
 ' ima1020    ,', 
 ' ima1021    ,', 
 ' ima1022    ,', 
 ' ima1023    ,', 
 ' ima1024    ,', 
 ' ima1025    ,', 
 ' ima1026    ,', 
 ' ima1027    ,', 
 ' ima1028    ,', 
 ' ima1029    ,', 
 ' ima911     ,', 
 ' ima912     ,', 
 ' ima913     ,', 
 ' ima914     ,', 
 ' ima391     ,', 
 ' ima1321    ,',   #FUN-710060 mod
 ' ima915     ,',   #MOD-780101 mod  #FUN-710060 mod  #No.FUN-810036
 ' ima916     ,',   #No.MOD-840392   #No.MOD-840392
 ' ima918     ,',  #No.FUN-810036
 ' ima919     ,',  #No.FUN-840160
 ' ima920     ,',  #No.FUN-840160
 ' ima921     ,',  #No.FUN-810036
 ' ima922     ,',  #No.FUN-840160
 ' ima923     ,',  #No.FUN-840160
 ' ima924     ,',  #No.FUN-840160 #240
 ' ima251     ,',  #TQC-B30008
 ' ima150,ima151,ima152,',  #MOD-950012  add
 ' ima154,ima155,',          #FUN-870100 ADD 
 ' ima926     ,',  #No.FUN-930108 add ima926
 ' ima120     ,',  #No.FUN-A90049 add ima120
 ' ima022,ima156,ima158,ima927, ',    #MOD-AB0077 add             
 ' ima928,ima929,',  #TQC-B90236 add ima928,ima929
 ' ima149,ima1491,ima940,ima941,', #FUN-BC0076 ADD ima149,ima1491,ima940,ima941
 ' ima925,ima601,imaoriu,imaorig,ima159,ima160,ima1030,ima164,ima1641)', #TQC-A10060  add imaoriu,imaorig  #No.FUN-810036  #FUN-840194 #TQC-B30008  #FUN-B50096 add ima159 #FUN-C50036 add ima160 #FUN-D30006 Add ima1030  #FUN-D60083 add ima164,ima1641
 ' VALUES(?, ',
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #10
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #20
#' ?,?,?,?,?,  ?,?,?,?,?, ', #30    #NO.FUN-A40023
#' ?,?,?,?,?,  ?,? ', #30           #NO.FUN-A40023    #FUN-AB0011 mark
 ' ?,?,?,?,?,  ?,?, ',              #FUN-AB0011 add    
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #40
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #50
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #60
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #70   #FUN-AB0011 add 3? 
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #80
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #90
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #100
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #110
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #120
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #130
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #140
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #150
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #160
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #170
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #180
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #190
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #200
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #210
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #220
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #230
 ' ?,?,?,?, ',               #MOD-AB0077 add
 ' ?,?,?,?, ',           #FUN-BC0076 ADD ima149,ima1491,ima940,ima941 (4 ?)
 ' ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)' #TQC-B90236 add ?,?, #TQC-A10060  add ?,?  #No.FUN-840160  #241  #No.FUN-810036  #FUN-710060 add ?  #No.MOD-840392  #FUN-840194 #FUN-930108 add ?  #MOD-950012 add ?,?,? #FUN-870100 ADD?,?   #FUN-A90049 add 1? #FUN-9C0141 add 1?  #FUN-B50096 add ? #FUN-C50036 add ? #CHI-C50068 #FUN-D30006 Add ?   #FUN-D60083 add ?,?
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #CHI-A60011 add
       CALL cl_parse_qry_sql(g_sql,tm[i].azp01) RETURNING g_sql  #FUN-A50102
       PREPARE ins_ima FROM g_sql
       EXECUTE ins_ima USING
 l_imaa.imaa01      ,
 l_imaa.imaa02      ,
 l_imaa.imaa021     ,
 l_imaa.imaa03      ,
 l_imaa.imaa04      ,
 l_imaa.imaa05      ,
 l_imaa.imaa06      ,
 l_imaa.imaa07      ,
 l_imaa.imaa08      ,
 l_imaa.imaa09      ,
 l_imaa.imaa10      ,
 l_imaa.imaa11      ,
 l_imaa.imaa12      ,
 l_imaa.imaa13      ,
 l_imaa.imaa14      ,
 l_imaa.imaa15      ,
 l_imaa.imaa16      ,
 l_imaa.imaa17      ,
 l_imaa.imaa17_fac  ,
 l_imaa.imaa18      ,
 l_imaa.imaa19      ,
 l_imaa.imaa20      ,
 l_imaa.imaa21      ,
 l_imaa.imaa22      ,
 l_imaa.imaa23      ,
 l_imaa.imaa24      ,
 l_imaa.imaa25      ,
#l_imaa.imaa26      ,    #FUN-AB0011 mark
#l_imaa.imaa261     ,    #FUN-AB0011 mark
#l_imaa.imaa262     ,    #FUN-AB0011 mark
 l_imaa.imaa27      ,
 l_imaa.imaa271     ,
 l_imaa.imaa28      ,
 l_imaa.imaa29      ,
 l_imaa.imaa30      ,
 l_imaa.imaa31      ,
 l_imaa.imaa31_fac  ,
 l_imaa.imaa32      ,
 l_imaa.imaa33      ,
 l_imaa.imaa34      ,
 l_imaa.imaa35      ,
 l_imaa.imaa36      ,
 l_imaa.imaa37      ,
 l_imaa.imaa38      ,
 l_imaa.imaa39      ,
 l_imaa.imaa40      ,
 l_imaa.imaa41      ,
 l_imaa.imaa42      ,
 l_imaa.imaa43      ,
 l_imaa.imaa44      ,
 l_imaa.imaa44_fac  ,
 l_imaa.imaa45      ,
 l_imaa.imaa46      ,
 l_imaa.imaa47      ,
 l_imaa.imaa48      ,
 l_imaa.imaa49      ,
 l_imaa.imaa491     ,
 l_imaa.imaa50      ,
 l_imaa.imaa51      ,
 l_imaa.imaa52      ,
 l_imaa.imaa53      ,
 l_imaa.imaa531     ,
 l_imaa.imaa532     ,
 l_imaa.imaa54      ,
 l_imaa.imaa55      ,
 l_imaa.imaa55_fac  ,
 l_imaa.imaa56      ,
 l_imaa.imaa561     ,
 l_imaa.imaa562     ,
 l_imaa.imaa57      ,
 l_imaa.imaa571     ,
 l_imaa.imaa58      ,
 l_imaa.imaa59      ,
 l_imaa.imaa60      ,
 l_imaa.imaa61      ,
 l_imaa.imaa62      ,
 l_imaa.imaa63      ,
 l_imaa.imaa63_fac  ,
 l_imaa.imaa64      ,
 l_imaa.imaa641     ,
 l_imaa.imaa65      ,
 l_imaa.imaa66      ,
 l_imaa.imaa67      ,
 l_imaa.imaa68      ,
 l_imaa.imaa69      ,
 l_imaa.imaa70      ,
 l_imaa.imaa71      ,
 l_imaa.imaa72      ,
 l_imaa.imaa721     , #CHI-C50068
 l_imaa.imaa73      ,
 l_imaa.imaa74      ,
 l_imaa.imaa86      ,
 l_imaa.imaa86_fac  ,
 l_imaa.imaa87      ,
 l_imaa.imaa871     ,
 l_imaa.imaa872     ,
 l_imaa.imaa873     ,
 l_imaa.imaa874     ,
 l_imaa.imaa88      ,
 l_imaa.imaa881     ,
 l_imaa.imaa89      ,
 l_imaa.imaa90      ,
 l_imaa.imaa91      ,
 l_imaa.imaa92      ,
 l_imaa.imaa93      ,
 l_imaa.imaa94      ,
 l_imaa.imaa95      ,
 l_imaa.imaa75      ,
 l_imaa.imaa76      ,
 l_imaa.imaa77      ,
 l_imaa.imaa78      ,
 l_imaa.imaa79      ,
 l_imaa.imaa80      ,
 l_imaa.imaa81      ,
 l_imaa.imaa82      ,
 l_imaa.imaa83      ,
 l_imaa.imaa84      ,
 l_imaa.imaa85      ,
 l_imaa.imaa851     ,
 l_imaa.imaa852     ,
 l_imaa.imaa853     ,
 l_imaa.imaa96      ,
 l_imaa.imaa97      ,
 l_imaa.imaa98      ,
 l_imaa.imaa99      ,
 l_imaa.imaa100     ,
 l_imaa.imaa101     ,
 l_imaa.imaa102     ,
 l_imaa.imaa103     ,
 l_imaa.imaa104     ,
 l_imaa.imaa105     ,
 l_imaa.imaa106     ,
 l_imaa.imaa107     ,
 l_imaa.imaa108     ,
 l_imaa.imaa109     ,
 l_imaa.imaa110     ,
 l_imaa.imaa111     ,
 l_imaa.imaa121     ,
 l_imaa.imaa122     ,
 l_imaa.imaa123     ,
 l_imaa.imaa124     ,
 l_imaa.imaa125     ,
 l_imaa.imaa126     ,
 l_imaa.imaa127     ,
 l_imaa.imaa128     ,
 l_imaa.imaa129     ,
 l_imaa.imaa130     ,
 l_imaa.imaa131     ,
 l_imaa.imaa132     ,
 l_imaa.imaa133     ,
 l_imaa.imaa134     ,
 l_imaa.imaa135     ,
 l_imaa.imaa136     ,
 l_imaa.imaa137     ,
 l_imaa.imaa138     ,
 l_imaa.imaa139     ,
 l_imaa.imaa140     ,
 l_imaa.imaa141     ,
 l_imaa.imaa142     ,
 l_imaa.imaa143     ,
 l_imaa.imaa144     ,
 l_imaa.imaa145     ,
 l_imaa.imaa146     ,
 l_imaa.imaa147     ,
 l_imaa.imaa148     ,
 l_imaa.imaa901     ,
 l_imaa.imaa902     ,
 l_imaa.imaa903     ,
 l_imaa.imaa904     ,
 l_imaa.imaa905     ,
 l_imaa.imaa906     ,
 l_imaa.imaa907     ,
 l_imaa.imaa908     ,
 l_imaa.imaa909     ,
 l_imaa.imaa153     ,        #FUN-9C0141 add
 l_imaa.imaa910     ,
 l_imaa.imaaacti    ,
     g_user,   #資料所有者  
     g_grup,   #資料所有部門
     '',       #資料修改者  
     g_today,  #最近修改日   
 l_imaa.imaaag      ,
 l_imaa.imaaag1     ,
 l_imaa.imaaud01    ,
 l_imaa.imaaud02    ,
 l_imaa.imaaud03    ,
 l_imaa.imaaud04    ,
 l_imaa.imaaud05    ,
 l_imaa.imaaud06    ,
 l_imaa.imaaud07    ,
 l_imaa.imaaud08    ,
 l_imaa.imaaud09    ,
 l_imaa.imaaud10    ,
 l_imaa.imaaud11    ,
 l_imaa.imaaud12    ,
 l_imaa.imaaud13    ,
 l_imaa.imaaud14    ,
 l_imaa.imaaud15    ,
 l_imaa.imaa1001    ,
 l_imaa.imaa1002    ,
 l_imaa.imaa1003    ,
 l_imaa.imaa1004    ,
 l_imaa.imaa1005    ,
 l_imaa.imaa1006    ,
 l_imaa.imaa1007    ,
 l_imaa.imaa1008    ,
 l_imaa.imaa1009    ,
 l_imaa.imaa1010    ,
 l_imaa.imaa1011    ,
 l_imaa.imaa1012    ,
 l_imaa.imaa1013    ,
 l_imaa.imaa1014    ,
 l_imaa.imaa1015    ,
 l_imaa.imaa1016    ,
 l_imaa.imaa1017    ,
 l_imaa.imaa1018    ,
 l_imaa.imaa1019    ,
 l_imaa.imaa1020    ,
 l_imaa.imaa1021    ,
 l_imaa.imaa1022    ,
 l_imaa.imaa1023    ,
 l_imaa.imaa1024    ,
 l_imaa.imaa1025    ,
 l_imaa.imaa1026    ,
 l_imaa.imaa1027    ,
 l_imaa.imaa1028    ,
 l_imaa.imaa1029    ,
 l_imaa.imaa911     ,
 l_imaa.imaa912     ,
 l_imaa.imaa913     ,
 l_imaa.imaa914     ,
 l_imaa.imaa391     ,
 l_imaa.imaa1321    ,   
 l_imaa.imaa915     ,  #FUN-710060 add
 g_plant            ,  #No.MOD-840392
 l_imaa.imaa918     ,   #No.MOD-840160
 l_imaa.imaa919     ,   #No.MOD-840160
 l_imaa.imaa920     ,   #No.MOD-840160
 l_imaa.imaa921     ,   #No.MOD-840160
 l_imaa.imaa922     ,   #No.MOD-840160
 l_imaa.imaa923     ,   #No.MOD-840160
 l_imaa.imaa924     ,   #No.MOD-840160
 l_imaa.imaa251     ,   #TQC-B30008
#'0','N','0'        ,   #No.MOD-950012 add #FUN-BC0076 Mark
 '0',l_imaa.imaa151,'0' ,                  #FUN-BC0076 Add
#'N','N'            ,   #No.FUN-870100 ADD #FUN-BC0076 Mark
 l_imaa.imaa154,'N' ,                      #FUN-BC0076 Add
 l_imaa.imaa926     ,   #No.FUN-930108 add imaa926
 l_imaa.imaa120     ,   #No.FUN-A90049 add imaa120 
#'0',' ',' ','N',         #MOD-AB0077 add                       #TQC-B30008
 l_imaa.imaa022,' ',' ','N',         #MOD-AB0077 add            #TQC-B30008   
 l_imaa.imaa928,l_imaa.imaa929,      #TQC-B90236 add l_imaa.imaa928,l_imaa.imaa929
 l_imaa.imaa149,l_imaa.imaa1491,l_imaa.imaa940,l_imaa.imaa941,  #FUN-BC0076 Add
 l_imaa.imaa925,'1',l_imaa.imaaoriu,l_imaa.imaaorig,l_imaa.imaa159,'N',l_imaa.imaa1030,    #TQC-A10060  addl_imaa.imaaoriu,l_imaa.imaaorig    #No.MOD-840160 #FUN-840194  #FUN-B50096 add imaa159 #FUN-C50036 add 'N' #FUN-D30006 Add imaa1030
 l_imaa.imaa164,l_imaa.imaa1641    #FUN-D60083 add
                     
 
#-------------------- COPY FILE ------------------------------
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           #LET g_msg = 'INSERT ',l_db CLIPPED,'ima_file'  #NO.FUN-840018 MOD #CHI-A60011 mark
           LET g_msg = 'INSERT ',cl_get_target_table(tm[i].azp01,'ima_file')  #CHI-A60011
           DISPLAY '錯誤碼=>',SQLCA.sqlcode
           LET g_showmsg=tm[i].azp03,'/',l_imaa.imaa01
           CALL s_errmsg('azp03,ima01',g_showmsg,g_msg,'lib-028',1)
           LET g_success = 'N'
           EXIT FOR
       ELSE
          IF NOT i150_ins_imac(tm[i].azp01,l_imaa.imaa01) THEN  #MOD-C30121 add #拋轉對應的特性資料至imac_file
             LET g_success = 'N'                                #MOD-C30121 add
             EXIT FOR                                           #MOD-C30121 add
          END IF                                                #MOD-C30121 add
          IF s_industry('icd') THEN   #FUN-BA0054
          INITIALIZE l_imaicd.* TO NULL  
          LET l_imaicd.imaicd00 = l_imaa.imaa01    
          #IF NOT s_industry('std') THEN #FUN-BA0054 mark
             LET l_cnt =0
          #FUN-B50106 --------------Begin--------------------    
          #  SELECT count(*) INTO l_cnt FROM imaicd_file
          #   WHERE imaicd00= l_imaicd.imaicd00 
             LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(tm[i].azp01,'imaicd_file'),
                         " WHERE imaicd00 = '",l_imaicd.imaicd00,"'"
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql
             CALL cl_parse_qry_sql(l_sql,tm[i].azp01) RETURNING l_sql
             PREPARE s_aimi100_pre FROM l_sql
             EXECUTE s_aimi100_pre INTO l_cnt
           #FUN-B50106 --------------End---------------------
             IF l_cnt = 0 THEN   #FUN-B50106 mark
                #IF NOT s_ins_imaicd(l_imaicd.*,tm[i].azp03) THEN   #no.FUN-840018 mod
          #FUN-B50106 ----------------------Begin-----------------------------
                LET l_imaicd.imaicd01 = l_imaa.imaaicd01
                LET l_imaicd.imaicd02 = l_imaa.imaaicd02
                LET l_imaicd.imaicd03 = l_imaa.imaaicd03
                LET l_imaicd.imaicd04 = l_imaa.imaaicd04
                LET l_imaicd.imaicd05 = l_imaa.imaaicd05
                LET l_imaicd.imaicd06 = l_imaa.imaaicd06
                LET l_imaicd.imaicd07 = l_imaa.imaaicd07
                LET l_imaicd.imaicd08 = l_imaa.imaaicd08
                LET l_imaicd.imaicd09 = l_imaa.imaaicd09
                LET l_imaicd.imaicd10 = l_imaa.imaaicd10
                LET l_imaicd.imaicd12 = l_imaa.imaaicd12
                LET l_imaicd.imaicd13 = l_imaa.imaaicd13
                LET l_imaicd.imaicd14 = l_imaa.imaaicd14       
                LET l_imaicd.imaicd15 = l_imaa.imaaicd15
                LET l_imaicd.imaicd16 = l_imaa.imaaicd16
          #FUN-B50106 ----------------------End-------------------------------
                IF NOT s_ins_imaicd(l_imaicd.*,tm[i].azp01) THEN   #FUN-A50102
                   LET g_success = 'N'
                   EXIT FOR
                END IF
                #FUN-C50132---begin
                IF l_imaicd.imaicd04 = '0' OR l_imaicd.imaicd04 = '1' OR l_imaicd.imaicd04 = '2' THEN
                   LET l_cnt = 0
                   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(tm[i].azp01,'icb_file'),
                               " WHERE icb01 = '",l_imaa.imaa01,"'"
                   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                   CALL cl_parse_qry_sql(l_sql,tm[i].azp01) RETURNING l_sql
                   PREPARE s_icb_pre2 FROM l_sql
                   EXECUTE s_icb_pre2 INTO l_cnt
                   #SELECT COUNT(*) INTO l_cnt FROM icb_file
                    #WHERE icb01 = l_imaa.imaa01
                   IF l_cnt = 0 THEN
                      LET g_sql="INSERT INTO ",cl_get_target_table(tm[i].azp01,'icb_file')," (icb01,icb05) VALUES ('",l_imaa.imaa01,"',",l_imaicd.imaicd14,")"
                      CALL cl_replace_sqldb(g_sql) RETURNING g_sql  
                      CALL cl_parse_qry_sql(g_sql,tm[i].azp01) RETURNING g_sql  
                      EXECUTE IMMEDIATE g_sql
                      #INSERT INTO icb_file(icb01,icb05) VALUES (l_imaa.imaa01,l_imaicd.imaicd14)
                      IF SQLCA.SQLCODE THEN 
                         CALL cl_err(l_imaa.imaa01,SQLCA.SQLCODE,0)
                      END IF 
                   ELSE
                      LET g_sql="UPDATE ",cl_get_target_table(tm[i].azp01,'icb_file')," SET icb05 =",l_imaicd.imaicd14,
                      " WHERE icb01 = '",l_imaa.imaa01,"'"
                      CALL cl_replace_sqldb(g_sql) RETURNING g_sql  
                      CALL cl_parse_qry_sql(g_sql,tm[i].azp01) RETURNING g_sql  
                      EXECUTE IMMEDIATE g_sql
                      #UPDATE icb_file SET icb05 = l_imaicd.imaicd14
                       #WHERE icb01 = l_imaa.imaa01
                      IF SQLCA.SQLCODE THEN 
                         CALL cl_err(l_imaa.imaa01,SQLCA.SQLCODE,0)
                      END IF 
                   END IF  
                END IF   
                #FUN-C50132---end
             END IF   
             #FUN-BA0054 --START--
             IF NOT i150_chk_smd(i,l_imaa.imaa01) THEN
                LET g_success = 'N'
                EXIT FOR            
             END IF
             #FUN-BA0054 --END--   
          END IF
           CALL i150_ins_imab(tm[i].azp03) #新增主檔拋轉記錄檔    #NO.FUN-840018 mod
           CALL s_dc_carry_record(g_gev04,tm[i].azp01,g_prog,g_imaa.imaa01,'1')  #NO.FUN-840018 add
           IF g_success = 'N' THEN EXIT FOR END IF
           LET l_ima_ins = 'Y'      #NO.FUN-840033 add
       END IF
 
       IF l_ima_ins = 'Y' THEN   #NO.FUN-840033 add                                                   
           CALL s_dc_carry_send_mail_2(l_hs_flag,l_gew08,l_hs_path,l_hist_tab)
           #CHI-CB0017 add begin---
           LET l_value1 = g_imaa.imaano
           LET l_value2 = g_imaa.imaa01
           CALL s_data_transfer(tm[i].azp01,'1',g_prog,l_value1,l_value2,'','','')
           #CHI-CB0017 add end-----
       END IF                   #NO.FUN-840033 add
   END FOR
 
  #CALL s_dc_drop_temp_table(l_hist_tab)   #CHI-A60011 mark
 
   IF l_ima_ins = 'Y' THEN      #NO.FUN-840033 add
      #MESSAGE 'Data Carry Finish!' #TQC-AC0147
       CALL cl_err('','aim-162',0)  #TQC-AC0147
   END IF                       #NO.FUN-840033 add
   CALL ui.Interface.refresh()
END FUNCTION
 
FUNCTION i150_dbs_upd()
   DEFINE l_imaa        RECORD LIKE imaa_file.*,
          l_c,l_s,i     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_sql         LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(9000)
          l_cnt         LIKE type_file.num5     #No.FUN-690026 SMALLINT
   DEFINE l_gew08              LIKE gew_file.gew08     #for mail
  #DEFINE l_hist_tab           LIKE type_file.chr50    #for mail   #CHI-A60011 mark
   DEFINE l_hs_flag            LIKE type_file.chr1     #for mail
   DEFINE l_hs_path            LIKE ze_file.ze03       #for mail
   DEFINE l_j                  LIKE type_file.num10
   DEFINE l_gew05              LIKE gew_file.gew05
   DEFINE l_gew07              LIKE gew_file.gew07
   DEFINE l_all_cnt            LIKE type_file.num5    
   DEFINE l_cur_cnt            LIKE type_file.num5
   DEFINE l_ima_upd            LIKE type_file.chr1   #NO.FUN-840033
   DEFINE l_db                 LIKE type_file.chr50     #No.TQC-9B0003
   DEFINE l_ima_2       RECORD LIKE ima_file.* #CHI-A60011 add
   DEFINE l_value1             LIKE type_file.chr30   #CHI-CB0017 add
   DEFINE l_value2             LIKE type_file.chr30   #CHI-CB0017 add
 
  #讀取相關資料..........................................
 
   LET g_sql='SELECT * FROM imaa_file WHERE imaano="',g_imaa.imaano CLIPPED,'" '
   PREPARE s_imaa_p FROM g_sql
   DECLARE s_imaa CURSOR FOR s_imaa_p
 
   FOR i = 1 TO tm.getLength()   #CHI-870044
       LET l_ima_upd = 'N'  #NO.FUN-840033
       #建立歷史資料拋轉的臨時表
      #CALL s_dc_cre_temp_table("gex_file") RETURNING l_hist_tab   #CHI-A60011 mark
       IF cl_null(tm[i].azp03) THEN CONTINUE FOR END IF
       IF tm[i].sel = 'N' THEN CONTINUE FOR END IF
 
       SELECT gew05,gew07,gew08 INTO l_gew05,l_gew07,l_gew08 FROM gew_file
        WHERE gew01 = g_gev04
          AND gew02 = '1'
          AND gew04 = tm[i].azp01
       IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF
 
       #mail_1                                                              
       CALL s_dc_carry_send_mail_1(tm[i].azp01,i,g_gev04,'1',l_hist_tab)
        RETURNING l_hs_flag,l_hs_path
 
       IF cl_null(tm[i].azp03) OR tm[i].sel = 'N' THEN  CONTINUE FOR END IF  #no.FUN-840018 mod
       #CALL s_dbstring(tm[i].azp03 CLIPPED) RETURNING l_db #CHI-A60011 mark
       #LET g_sql='SELECT COUNT(*) FROM ',l_db CLIPPED,'imaa_file ',  #NO.FUN-840018  mod #CHI-A60011 mark
       LET g_sql='SELECT COUNT(*) FROM ',cl_get_target_table(tm[i].azp01,'imaa_file'),  #CHI-A60011
                 'WHERE imaano = ? '
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql  #CHI-A60011 add
       CALL cl_parse_qry_sql(g_sql,tm[i].azp01) RETURNING g_sql  #FUN-A50102
       PREPARE c_imaa_p FROM g_sql
       DECLARE c_imaa CURSOR FOR c_imaa_p
 
 
       #-------------------- UPDATE FILE.dbo.imaa_file ------------------------------
       FOREACH s_imaa INTO l_imaa.*
          IF STATUS THEN
             CALL cl_err('foreach imaa',STATUS,0)
             EXIT FOREACH
          END IF
          OPEN c_imaa USING l_imaa.imaano
          FETCH c_imaa INTO l_cnt
             #CHI-A60011 add --start--
             LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(tm[i].azp01, 'ima_file'),
                                " WHERE ima01=? FOR UPDATE"
             LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
             CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
             CALL cl_parse_qry_sql(g_forupd_sql,tm[i].azp01) RETURNING g_forupd_sql  #FUN-A50102
             DECLARE i150_cs2_ima_lock CURSOR FROM g_forupd_sql
             OPEN i150_cs2_ima_lock USING l_imaa.imaa01
             IF STATUS THEN
                LET g_msg = tm[i].azp03 CLIPPED,':ima_file:lock'
                LET g_showmsg=tm[i].azp03,'/',l_imaa.imaa01
                CALL s_errmsg('azp03,ima01',g_showmsg,g_msg,STATUS,1)
                CLOSE i150_cs2_ima_lock
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             FETCH i150_cs2_ima_lock INTO l_ima_2.* 
             IF SQLCA.SQLCODE THEN
                LET g_msg = tm[i].azp03 CLIPPED,':ima_file:lock'
                LET g_showmsg=tm[i].azp03,'/',l_imaa.imaa01
                CALL s_errmsg('azp03,ima01',g_showmsg,g_msg,SQLCA.SQLCODE,1)
                CLOSE i150_cs2_ima_lock
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             #CHI-A60011 add --end--
            #LET l_sql='UPDATE ',l_db CLIPPED,'ima_file ',  #NO.FUN-840018 mod #CHI-A60011 mark
             LET l_sql='UPDATE ',cl_get_target_table(tm[i].azp01,'ima_file'),  #CHI-A60011
                       '   SET ima02=?   ,ima021 =? ,',
                       '       ima916=?             ,', #No.MOD-840392
                       '       imamodu=? ,imadate=?  ', #TQC-740343 add
                       ' WHERE ima01 =? '
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql  #CHI-A60011 add
             CALL cl_parse_qry_sql(l_sql,tm[i].azp01) RETURNING l_sql  #FUN-A50102
             PREPARE u_imaa FROM l_sql
             EXECUTE u_imaa USING l_imaa.imaa02 ,l_imaa.imaa021, 
                                  g_plant,             #N.MOD-840392
                                  g_user,g_today,      #TQC-740343 add
                                  l_imaa.imaa01
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                #LET g_msg = 'UPDATE ',l_db CLIPPED,'ima_file'  #NO.FUN-840018 mod #CHI-A60011 mark
                 LET g_msg = 'UPDATE ',cl_get_target_table(tm[i].azp01,'ima_file') #CHI-A60011
                 LET g_showmsg=tm[i].azp03,'/',l_imaa.imaa01
                 CALL s_errmsg('azp03,ima01',g_showmsg,g_msg,'lib-028',1)
                 LET g_success = 'N'
                 EXIT FOREACH
             ELSE
                 #FUN-BA0054 --START--
                 IF s_industry('icd') THEN 
                    IF NOT i150_chk_smd(i,l_imaa.imaa01) THEN
                       LET g_success = 'N'
                       EXIT FOREACH            
                    END IF    
                 END IF                  
                 #FUN-BA0054 --END--
                 CALL i150_ins_imab(tm[i].azp03) #新增主檔拋轉記錄檔   #NO.FUN-840018 MOD
                 CALL s_dc_carry_record(g_gev04,tm[i].azp01,g_prog,g_imaa.imaa01,'1')  #NO.FUN-840018 add
                 IF g_success = 'N' THEN EXIT FOREACH END IF
                 LET l_ima_upd = 'Y'   #NO.FUN-840033 add
             END IF
             CLOSE i150_cs2_ima_lock  #CHI-A60011 add
       END FOREACH
       IF l_ima_upd = 'Y' THEN    #NO.FUN-840033 add                                                              
           CALL s_dc_carry_send_mail_2(l_hs_flag,l_gew08,l_hs_path,l_hist_tab)
           #CHI-CB0017 add begin---
           LET l_value1 = g_imaa.imaano
           LET l_value2 = g_imaa.imaa01
           CALL s_data_transfer(tm[i].azp01,'1',g_prog,l_value1,l_value2,'','','')
           #CHI-CB0017 add end-----
       END IF                     #NO.FUN-840033 add
   END FOR
  #CALL s_dc_drop_temp_table(l_hist_tab)   #CHI-A60011 mark
 
   IF l_ima_upd = 'Y' THEN     #NO.FUN-840033 add
      #MESSAGE 'Data Carry Finish!' #TQC-AC0147
       CALL cl_err('','aim-162',0)  #TQC-AC0147
   END IF                      #NO.FUN-840033 add
   CALL ui.Interface.refresh()
 
END FUNCTION
 
#資料拋轉時會用到的副程式
FUNCTION s_carry_data()
   DEFINE l_imaano       LIKE imaa_file.imaano
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_arrno        LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_ac           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_exit_sw      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_wc           LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
          l_sql          LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(1000)
          l_do_ok        LIKE type_file.chr1     #No.FUN-690026 VARCHAR(1)
   DEFINE l_rec_b        LIKE type_file.num5     #No.FUN-610048  #No.FUN-690026 SMALLINT
   DEFINE l_cnt          LIKE type_file.num5     #TQC-740090 add DEFINE l_dbs          LIKE type_file.chr21    #TQC-740090 add
   DEFINE l_i            LIKE type_file.num5     #NO.FUN-840018
   DEFINE l_gew03        LIKE gew_file.gew03     #NO.FUN-840018
   DEFINE l_gev04        LIKE gev_file.gev04     #NO.FUN-840018
   DEFINE l_geu02        LIKE geu_file.geu02     #NO.FUN-840018
   DEFINE l_allow_insert  LIKE type_file.num5                 #可新增否 #NO.FUN-840018 
   DEFINE l_allow_delete  LIKE type_file.num5                 #可刪除否 #NO.FUN-840018
   DEFINE l_dbs           STRING                 #no.FUN-840090
   DEFINE p_sql           LIKE type_file.chr1000   #NO.MOD-840158
   DEFINE l_dbs_sep            LIKE type_file.chr50  #no.MOD-840158
   DEFINE l_chk          LIKE type_file.num5    #CHI-860003
   DEFINE l_n            LIKE type_file.num5  #FUN-9A0092                                                                             
   DEFINE l_azw01        LIKE azw_file.azw01  #FUN-9A0092                                                                              
   DEFINE l_azw06        LIKE azw_file.azw06  #FUN-9A0092                                                                               
   DEFINE l_str          STRING               #FUN-9A0092 
 
   SELECT UNIQUE gew03 INTO l_gew03 FROM gew_file
    WHERE gew01 = g_gev04
      AND gew02 = '1'
   IF SQLCA.sqlcode THEN
      IF SQLCA.sqlcode = -284 THEN
         LET l_gew03 = '3'
      END IF
   END IF
 
  #IF l_gew03 = '2' OR l_gew03 = '3' THEN              #NO.FUN-840090     #FUN-950057 mark
   IF l_gew03 = '3' THEN                                                  #FUN-950057 
       OPEN WINDOW s_dc_1_w WITH FORM "sub/42f/s_dc_sel_db1"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
       CALL cl_ui_locale("s_dc_sel_db1")                #NO.FUN-840090
 
       SELECT gev04 INTO l_gev04 FROM gev_file
        WHERE gev01 = '1' and gev02 = g_plant
       SELECT geu02 INTO l_geu02 FROM geu_file
        WHERE geu01 = l_gev04
       DISPLAY l_gev04 TO FORMONLY.gev04
       DISPLAY l_geu02 TO FORMONLY.geu02
    LET l_n = 0                                                                                                                     
    SELECT COUNT(*) INTO l_n FROM azw_file                                                                                          
     WHERE azw05 <> azw06                                                                                                           
    IF l_n  = 0  THEN                                                                                                               
       CALL cl_set_comp_visible("plant",FALSE)                                                                                      
    END IF       

 
   END IF             #no.FUN-840090
 
   IF g_imaa.imaa00 = 'I' THEN #新增
 
       # IF l_gew03 = '1' OR l_gew03 = '2' THEN   #FUN-950057 mark
         IF l_gew03 MATCHES '[123]' THEN          #FUN-950057
             LET l_sql = " SELECT 'Y',gew04,azp02,azp03,' ','N' FROM gew_file,azp_file ",   #FUN-9A0092
                        "  WHERE gew01 = '",g_gev04,"'",
                        "    AND gew02 = '1'",
                        "    AND gew04 = azp01 "
            PREPARE s_carry_data_prepare1 FROM l_sql
            DECLARE azp_curs1 CURSOR FOR s_carry_data_prepare1
            LET g_cnt = 1
            FOREACH azp_curs1 INTO tm[g_cnt].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err('foreach s_dc_sel_azp:',SQLCA.sqlcode,1)
                   EXIT FOREACH
                END IF
 
                SELECT COUNT(*) INTO l_chk FROM zxy_file
                 WHERE zxy01=g_user
                   AND zxy03=tm[g_cnt].azp01
                IF l_chk=0 THEN CONTINUE FOREACH END IF
 
                CALL s_getdbs_curr(tm[g_cnt].azp01) RETURNING l_dbs
                LET l_cnt = 0 
               #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"ima_file",  #FUN-A50102
                LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(tm[g_cnt].azp01,'ima_file'),  #FUN-A50102 
                            " WHERE ima01 ='",g_imaa.imaa01,"'"
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,tm[g_cnt].azp01) RETURNING l_sql  #FUN-A50102
                PREPARE ima_count_pre1 FROM l_sql
                EXECUTE ima_count_pre1 INTO l_cnt    #MOD-950038
   
                IF NOT cl_null(l_cnt) THEN
                    #新增時,已存在的不能選取
                    #修改時,已存在的選取
                    IF g_imaa.imaa00 = 'I' THEN #新增
                        IF l_cnt >= 1 THEN
                            LET tm[g_cnt].exist = 'Y'     #存在
                            LET tm[g_cnt].sel = 'N'     #選取
                        END IF
                    ELSE
                        IF l_cnt >= 1 THEN
                            LET tm[g_cnt].exist = 'Y'     #存在
                            LET tm[g_cnt].sel    = 'Y'     #選取
                        END IF
                    END IF
                END IF
          LET l_azw06 = NULL                                                                                                        
          LET l_azw01 = NULL                                                                                                        
          LET l_str = ''                                                                                                            
          SELECT azw06 INTO l_azw06 FROM azw_file WHERE azw01 = tm[g_cnt].azp01                                                 
          DECLARE s_dc_db1  CURSOR  FOR                                                                                             
                  SELECT azw01 FROM azw_file WHERE azw06 = l_azw06                                                                  
          FOREACH s_dc_db1  INTO l_azw01                                                                                            
            IF STATUS THEN                                                                                                          
               CALL cl_err('foreach:',STATUS,1)                                                                                     
               EXIT FOREACH                                                                                                         
            END IF                                                                                                                  
            IF l_azw01 = tm[g_cnt].azp01 THEN                                                                                   
               LET l_azw01 = NULL                                                                                                   
               CONTINUE FOREACH                                                                                                     
            END IF                                                                                                                  
            IF cl_null(l_str)  THEN                                                                                                 
               LET l_str = l_azw01                                                                                                  
            ELSE                                                                                                                    
               LET l_str = l_str,",",l_azw01                                                                                        
            END IF                                                                                                                  
          END FOREACH                                                                                                               
          LET tm[g_cnt].plant = l_str   
                LET g_cnt = g_cnt + 1
             
            END FOREACH
            CALL tm.deleteElement(g_cnt)
         END IF
     ELSE
          LET l_sql = " SELECT 'N',gew04,azp02,azp03,'N' ",
                      "   FROM gew_file,azp_file ",
                      "  WHERE gew01 = '",g_gev04,"'",
                      "    AND azp053 = 'Y' ",
                      "    AND gew02 = '1'",
                      "    AND gew04 = azp01 "
           #SELECT imaano INTO l_imaano FROM imaa_file    #No:MOD-A30102 mark
            PREPARE s_carry_data_prepare2 FROM l_sql
            DECLARE azp_curs2 CURSOR FOR s_carry_data_prepare2
            LET g_cnt = 1
            FOREACH azp_curs2 INTO tm[g_cnt].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err('foreach s_dc_sel_azp:',SQLCA.sqlcode,1)
                   EXIT FOREACH
                END IF
 
                SELECT COUNT(*) INTO l_chk FROM zxy_file
                 WHERE zxy01=g_user
                   AND zxy03=tm[g_cnt].azp01
                IF l_chk=0 THEN CONTINUE FOREACH END IF
                
                LET l_cnt = NULL
                CALL s_getdbs_curr(tm[g_cnt].azp01) RETURNING l_dbs
                #LET g_sql="SELECT COUNT(*) FROM ima_file ",   #TQC-C30236
                LET g_sql="SELECT COUNT(*) FROM ",cl_get_target_table(tm[g_cnt].azp01,'ima_file'), #TQC-C30236
                          "WHERE ima01='",g_imaa.imaa01,"' ",
                          "AND imaacti='Y'"
                IF NOT s_aimi100_chk_cur(g_sql) THEN
                   LET tm[g_cnt].exist = 'Y'
                ELSE
                   LET tm[g_cnt].exist = 'N'
                END IF
                DISPLAY BY NAME tm[g_cnt].exist
               #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"ima_file",   #FUN-A50102
                LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(tm[g_cnt].azp01,'ima_file'),  #FUN-A50102  
                            " WHERE ima01 ='",g_imaa.imaa01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                CALL cl_parse_qry_sql(l_sql,tm[g_cnt].azp01) RETURNING l_sql   #FUN-A50102
                PREPARE ima_count_pre2 FROM l_sql
                EXECUTE ima_count_pre2 INTO l_cnt    #MOD-950038
   
                IF NOT cl_null(l_cnt) THEN
                    #新增時,已存在的不能選取
                    #修改時,已存在的選取
                    IF g_imaa.imaa00 = 'I' THEN #新增
                        IF l_cnt >= 1 THEN
                            LET tm[g_cnt].exist = 'Y'     #存在
                            LET tm[g_cnt].sel = 'N'     #選取
                        END IF
                    ELSE
                        IF l_cnt >= 1 THEN
                            LET tm[g_cnt].exist = 'Y'     #存在
                            LET tm[g_cnt].sel    = 'Y'     #選取
                        END IF
                    END IF
                END IF
          LET l_azw06 = NULL                                                                                                        
          LET l_azw01 = NULL                                                                                                        
          LET l_str = ''                                                                                                            
          SELECT azw06 INTO l_azw06 FROM azw_file WHERE azw01 = tm[g_cnt].azp01                                                     
          DECLARE s_dc_db2  CURSOR  FOR                                                                                             
                  SELECT azw01 FROM azw_file WHERE azw06 = l_azw06                                                                  
          FOREACH s_dc_db2  INTO l_azw01                                                                                            
            IF STATUS THEN                                                                                                          
               CALL cl_err('foreach:',STATUS,1)                                                                                     
               EXIT FOREACH                                                                                                         
            END IF                                                                                                                  
            IF l_azw01 = tm[g_cnt].azp01 THEN                                                                                       
               LET l_azw01 = NULL                                                                                                   
               CONTINUE FOREACH                                                                                                     
            END IF                                                                                                                  
            IF cl_null(l_str)  THEN                                                                                                 
               LET l_str = l_azw01                                                                                                  
            ELSE                                                                                                                    
               LET l_str = l_str,",",l_azw01                                                                                        
            END IF                                                                                                                  
          END FOREACH                                                                                                               
          LET tm[g_cnt].plant = l_str                                                                                               
                LET g_cnt = g_cnt + 1
             
            END FOREACH
            CALL tm.deleteElement(g_cnt)
   END IF
 
   LET l_rec_b = g_cnt -1   
   WHILE TRUE
   LET l_exit_sw = "n"
 
   #IF l_gew03 = '2' OR l_gew03 = '3' THEN              #NO.FUN-840090  #FUN-950057 makr
   IF l_gew03 = '3' THEN                            #FUN-950057  
      IF g_imaa.imaa00 = 'U' THEN 
          LET l_allow_insert = FALSE
      ELSE
          LET l_allow_insert = TRUE
      END IF

      INPUT ARRAY tm WITHOUT DEFAULTS FROM s_azp.*   
           ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED, 
                      INSERT ROW=l_allow_insert,DELETE ROW=TRUE,APPEND ROW=l_allow_insert)    #FUN-840018
      
         BEFORE ROW   
            LET l_ac = ARR_CURR()
            #新增時,已存在的不能選取
            #修改時,不存在的不能選取
            IF g_imaa.imaa00 = 'I' THEN #新增
                IF tm[l_ac].exist = 'Y' THEN #存在
                    IF l_ac <> l_rec_b THEN
                       NEXT FIELD exist
                    ELSE
                       LET l_exit_sw = "y"   #no.MOD-840158 
                       EXIT INPUT
                    END IF
                END IF
            ELSE
                IF tm[l_ac].exist = 'N' THEN #不存在
                    IF l_ac <> l_rec_b THEN
                        NEXT FIELD exist
                    ELSE
                        LET l_exit_sw = "y"   #no.MOD-840158 
                        EXIT INPUT
                    END IF
                END IF
            END IF
            CALL i100_150_set_entry( )
            CALL i100_150_set_no_entry(l_ac)
      
          AFTER FIELD azp01
          IF NOT cl_null(tm[l_ac].azp01) THEN
             CALL i100_sel_db_azp01(l_ac)
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(tm[l_ac].azp01,g_errno,0)
                NEXT FIELD azp01
             ELSE
                 CALL s_getdbs_curr(tm[l_ac].azp01) RETURNING l_dbs
                #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"ima_file",  #FUN-A50102
                 LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(tm[l_ac].azp01,'ima_file'),  #FUN-A50102 
                             " WHERE ima01 ='",g_imaa.imaa01,"'"
  	   CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql,tm[l_ac].azp01) RETURNING l_sql   #FUN-A50102
                 PREPARE ima_count_pre FROM l_sql
                 EXECUTE ima_count_pre INTO l_cnt    #MOD-950038
   
                 IF NOT cl_null(l_cnt) THEN
                     IF l_cnt >= 1 THEN
                         LET tm[l_ac].exist = 'Y'     #存在
                     ELSE
                         LET tm[l_ac].exist = 'N'
                     END IF
                 END IF
                 DISPLAY BY NAME tm[l_ac].exist
              END IF
          ELSE
             LET tm[l_ac].azp02 = NULL
             LET tm[l_ac].azp03 = NULL
          END IF
 
           ON ACTION controlp
              CASE
                 WHEN INFIELD(azp01)        #azp_file
                      CALL cl_init_qry_var()
                      LET g_qryparam.form     = "q_gew04"
                      LET g_qryparam.arg1     = g_gev04
                      LET g_qryparam.arg2     = '1'
                      LET g_qryparam.default1 = tm[l_ac].azp01
                      CALL cl_create_qry() RETURNING tm[l_ac].azp01
                      CALL i100_sel_db_azp01(l_ac)
                      NEXT FIELD azp01
              END CASE
 
           ON ACTION accept
            LET l_exit_sw = 'y'
            EXIT INPUT     
      
           ON ACTION select_all   #全部選取
            CALL i150_sel_all('Y',l_rec_b)
 
           ON ACTION select_non   #全部不選
              CALL i150_sel_all('N',l_rec_b)
         END INPUT   
   ELSE              #no.FUN-840090
      EXIT WHILE     #NO.FUN-840090
   END IF            #NO.FUN-840090
      
   IF INT_FLAG THEN 
      LET l_exit_sw = 'y'
   END IF
   
   IF l_exit_sw = "y" THEN 
      EXIT WHILE  
   END IF
END WHILE
IF l_gew03 = '3' THEN              #FUN-950057 add  
  CLOSE WINDOW s_dc_1_w
END IF                             #FUN-950057 add   

  LET g_gew03 = l_gew03   #TQC-980264
END FUNCTION
 


FUNCTION i150_sel_all(p_flag,l_rec_b)
  DEFINE  p_flag      LIKE type_file.chr1 
  DEFINE  l_i         LIKE type_file.num5
  DEFINE  l_rec_b     LIKE type_file.num5     # SMALLINT
 
  FOR l_i = 1 TO l_rec_b 
    IF p_flag = 'Y' THEN
        #新增時,不存在的才能選取
        #修改時,已存在的不能選取
        IF g_imaa.imaa00 = 'I' THEN #新增
            IF tm[l_i].exist = 'N' THEN #不存在
                #LET tm[l_i].a = p_flag  
                LET tm[l_i].sel = p_flag   #NO.FUN-840018
            END IF
        ELSE
            IF tm[l_i].exist = 'Y' THEN #存在
                LET tm[l_i].sel = p_flag  #NO.FUN-840018
            END IF
        END IF
    ELSE
        LET tm[l_i].sel = p_flag  #NO.FUN-840018
    END IF
    DISPLAY BY NAME tm[l_i].sel  #NO.FUN-840018
  END FOR 
END FUNCTION
 
FUNCTION i150_ins_imab(l_dbs) #新增主檔拋轉記錄檔
  DEFINE l_dbs        LIKE azp_file.azp03
 
    INSERT INTO imab_file(imab00,imabno,imab01,imabtype,imabdate,imabdb)
       VALUES (g_imaa.imaa00,g_imaa.imaano,g_imaa.imaa01,'1',g_today,l_dbs)
    IF SQLCA.sqlcode THEN
        LET g_showmsg=g_imaa.imaa00,'/',g_imaa.imaano,'/',g_imaa.imaa01
        CALL s_errmsg('imaa00,imaano,imaa01',g_showmsg,'',SQLCA.sqlcode,1)
        LET g_success='N'
    END IF
    IF SQLCA.sqlerrd[3]=0 THEN
        LET g_showmsg=g_imaa.imaa00,'/',g_imaa.imaano,'/',g_imaa.imaa01
        CALL s_errmsg('imaa00,imaano,imaa01',g_showmsg,'',SQLCA.sqlcode,1)
        LET g_success='N'
    END IF
END FUNCTION
 
FUNCTION i100_150_set_entry()
         CALL cl_set_comp_entry("azp01",TRUE)
END FUNCTION
 
FUNCTION i100_150_set_no_entry(p_i)
DEFINE p_i  LIKE type_file.num5
 
    IF (tm[p_i].exist = 'Y') OR g_imaa.imaa00 = 'U' AND cl_null(tm[p_i].exist) THEN
         CALL cl_set_comp_entry("azp01",FALSE)
    END IF
END FUNCTION
 
FUNCTION i100_sel_db_azp01(i)
    DEFINE i       LIKE type_file.num10
    DEFINE l_i     LIKE type_file.num10
    DEFINE l_azp02   LIKE azp_file.azp02
    DEFINE l_azp03   LIKE azp_file.azp03
    DEFINE l_gew04   LIKE gew_file.gew04
 
    LET g_errno = ' '
    SELECT azp02,azp03 INTO l_azp02,l_azp03
      FROM azp_file WHERE azp01=tm[i].azp01
    CASE
        WHEN STATUS=100      LET g_errno = 100
        OTHERWISE            LET g_errno = SQLCA.sqlcode USING'-------'
    END CASE
    IF cl_null(g_errno) THEN
       SELECT gew04 INTO l_gew04 FROM gew_file
        WHERE gew01 = g_gev04
          AND gew02 ='1' 
          AND gew04 = tm[i].azp01
       CASE
           WHEN STATUS=100        LET g_errno = 'aoo-034'
           OTHERWISE              LET g_errno = SQLCA.sqlcode USING'-------'
       END CASE
    END IF
    #相同的DB不要能KEY多次
    IF cl_null(g_errno) THEN
       FOR l_i = 1 TO tm.getLength()
           IF l_i = i THEN
              CONTINUE FOR
           END IF
           IF tm[i].azp01 = tm[l_i].azp01 THEN
              LET g_errno = '-239'
           END IF
       END FOR
    END IF
    IF NOT cl_null(g_errno) THEN
       LET l_azp03 = NULL
       LET l_azp02 = NULL
    END IF
    IF cl_null(g_errno) THEN
       LET tm[i].azp02 = l_azp02
       LET tm[i].azp03 = l_azp03
    END IF
END FUNCTION
 
#FUNCTION s_aimi100_set_by_ima06(p_dbs_sep,p_imz01,p_flag)   #FUN-A50102
FUNCTION s_aimi100_set_by_ima06(p_plant,p_imz01,p_flag)   #FUN-A50102
  DEFINE p_dbs_sep        LIKE type_file.chr50
  DEFINE p_imz01          LIKE imz_file.imz01
  DEFINE p_flag           LIKE type_file.chr1
  DEFINE p_plant          LIKE azp_file.azp01   #FUN-A50102 

  LET g_sql = "SELECT imz01,imz03,imz04,",
              "       imz07,imz08,imz09,imz10,",
              "       imz11,imz12,imz14,imz15,",
              "       imz17,imz19,imz21,",
              "       imz23,imz24,imz25,imz27,",
              "       imz28,imz31,imz31_fac,imz34,",
              "       imz35,imz36,imz37,imz38,",
              "       imz39,imz42,imz43,imz44,",
              "       imz44_fac,imz45,imz46 ,imz47,",
              "       imz48,imz49,imz491,imz50,",
              "       imz51,imz52,imz54,imz55,",
              "       imz55_fac,imz56,imz561,imz562,",
              "       imz571,",
              "       imz59 ,imz60,imz61,imz62,",
              "       imz63,imz63_fac ,imz64,imz641,",
              "       imz65,imz66,imz67,imz68,",
              "       imz69,imz70,imz71,imz86,",
              "       imz86_fac ,imz87,imz871,imz872,",
              "       imz873,imz874,imz88,imz89,",
              "       imz90,imz94,imz99,imz100 ,",
              "       imz101,imz102 ,imz103,imz105,",
              "       imz106,imz107,imz108,imz109,",
              "       imz110,imz130,imz131,imz132,",
              "       imz133,imz134,",
              "       imz147,imz148,imz903,",
              "       imz906,imz907,imz908,imz909,imz153,",        #FUN-9C0141 add imz153
              "       imz911,",
              "       imz136,imz137,imz391,imz1321,",
              "       imz72",
             #"  FROM ",p_dbs_sep CLIPPED,"imz_file",  #FUN-A50102
              "  FROM ",cl_get_target_table(p_plant,'imz_file'),     #FUN-A50102
              " WHERE imz01 = '",p_imz01,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
  CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql       #FUN-A50102
  PREPARE ima06_p1 FROM g_sql
  IF p_flag = '1' THEN
     EXECUTE ima06_p1 INTO g_ima.ima06,g_ima.ima03,g_ima.ima04,
                           g_ima.ima07,g_ima.ima08,g_ima.ima09,g_ima.ima10,
                           g_ima.ima11,g_ima.ima12,g_ima.ima14,g_ima.ima15,
                           g_ima.ima17,g_ima.ima19,g_ima.ima21,
                           g_ima.ima23,g_ima.ima24,g_ima.ima25,g_ima.ima27,
                           g_ima.ima28,g_ima.ima31,g_ima.ima31_fac,g_ima.ima34,
                           g_ima.ima35,g_ima.ima36,g_ima.ima37,g_ima.ima38,
                           g_ima.ima39,g_ima.ima42,g_ima.ima43,g_ima.ima44,
                           g_ima.ima44_fac,g_ima.ima45,g_ima.ima46,g_ima.ima47,
                           g_ima.ima48,g_ima.ima49,g_ima.ima491,g_ima.ima50,
                           g_ima.ima51,g_ima.ima52,g_ima.ima54,g_ima.ima55,
                           g_ima.ima55_fac,g_ima.ima56,g_ima.ima561,g_ima.ima562,
                           g_ima.ima571,
                           g_ima.ima59, g_ima.ima60,g_ima.ima61,g_ima.ima62,
                           g_ima.ima63, g_ima.ima63_fac,g_ima.ima64,g_ima.ima641,
                           g_ima.ima65, g_ima.ima66,g_ima.ima67,g_ima.ima68,
                           g_ima.ima69, g_ima.ima70,g_ima.ima71,g_ima.ima86,
                           g_ima.ima86_fac, g_ima.ima87,g_ima.ima871,g_ima.ima872,
                           g_ima.ima873, g_ima.ima874,g_ima.ima88,g_ima.ima89,
                           g_ima.ima90,g_ima.ima94,g_ima.ima99,g_ima.ima100,     
                           g_ima.ima101,g_ima.ima102,g_ima.ima103,g_ima.ima105,  
                           g_ima.ima106,g_ima.ima107,g_ima.ima108,g_ima.ima109,  
                           g_ima.ima110,g_ima.ima130,g_ima.ima131,g_ima.ima132,  
                           g_ima.ima133,g_ima.ima134,                            
                           g_ima.ima147,g_ima.ima148,g_ima.ima903,
                           g_ima.ima906,g_ima.ima907,g_ima.ima908,g_ima.ima909,g_ima.ima153,  #FUN-9C0141  add ima153  
                           g_ima.ima911,                                         
                           g_ima.ima136,g_ima.ima137,g_ima.ima391,g_ima.ima1321, 
                           g_ima.ima915                                          
     IF g_ima.ima99  IS NULL THEN LET g_ima.ima99 = 0 END IF
     IF g_ima.ima133 IS NULL THEN LET g_ima.ima133 = g_ima.ima01 END IF
     IF g_ima.ima01[1,4]='MISC' THEN 
        LET g_ima.ima08='Z'
     END IF
  ELSE
     EXECUTE ima06_p1 INTO g_imaa1.imaa06,g_imaa1.imaa03,g_imaa1.imaa04,
                           g_imaa1.imaa07,g_imaa1.imaa08,g_imaa1.imaa09,g_imaa1.imaa10,
                           g_imaa1.imaa11,g_imaa1.imaa12,g_imaa1.imaa14,g_imaa1.imaa15,
                           g_imaa1.imaa17,g_imaa1.imaa19,g_imaa1.imaa21,
                           g_imaa1.imaa23,g_imaa1.imaa24,g_imaa1.imaa25,g_imaa1.imaa27,
                           g_imaa1.imaa28,g_imaa1.imaa31,g_imaa1.imaa31_fac,g_imaa1.imaa34,
                           g_imaa1.imaa35,g_imaa1.imaa36,g_imaa1.imaa37,g_imaa1.imaa38,
                           g_imaa1.imaa39,g_imaa1.imaa42,g_imaa1.imaa43,g_imaa1.imaa44,
                           g_imaa1.imaa44_fac,g_imaa1.imaa45,g_imaa1.imaa46,g_imaa1.imaa47,
                           g_imaa1.imaa48,g_imaa1.imaa49,g_imaa1.imaa491,g_imaa1.imaa50,
                           g_imaa1.imaa51,g_imaa1.imaa52,g_imaa1.imaa54,g_imaa1.imaa55,
                           g_imaa1.imaa55_fac,g_imaa1.imaa56,g_imaa1.imaa561,g_imaa1.imaa562,
                           g_imaa1.imaa571,
                           g_imaa1.imaa59, g_imaa1.imaa60,g_imaa1.imaa61,g_imaa1.imaa62,
                           g_imaa1.imaa63, g_imaa1.imaa63_fac,g_imaa1.imaa64,g_imaa1.imaa641,
                           g_imaa1.imaa65, g_imaa1.imaa66,g_imaa1.imaa67,g_imaa1.imaa68,
                           g_imaa1.imaa69, g_imaa1.imaa70,g_imaa1.imaa71,g_imaa1.imaa86,
                           g_imaa1.imaa86_fac, g_imaa1.imaa87,g_imaa1.imaa871,g_imaa1.imaa872,
                           g_imaa1.imaa873, g_imaa1.imaa874,g_imaa1.imaa88,g_imaa1.imaa89,
                           g_imaa1.imaa90,g_imaa1.imaa94,g_imaa1.imaa99,g_imaa1.imaa100,     
                           g_imaa1.imaa101,g_imaa1.imaa102,g_imaa1.imaa103,g_imaa1.imaa105,  
                           g_imaa1.imaa106,g_imaa1.imaa107,g_imaa1.imaa108,g_imaa1.imaa109,  
                           g_imaa1.imaa110,g_imaa1.imaa130,g_imaa1.imaa131,g_imaa1.imaa132,  
                           g_imaa1.imaa133,g_imaa1.imaa134,                            
                           g_imaa1.imaa147,g_imaa1.imaa148,g_imaa1.imaa903,
                           g_imaa1.imaa906,g_imaa1.imaa907,g_imaa1.imaa908,g_imaa1.imaa909,g_imaa1.imaa153,  #FUN-9C0141 add imaa153  
                           g_imaa1.imaa911,                                         
                           g_imaa1.imaa136,g_imaa1.imaa137,g_imaa1.imaa391,g_imaa1.imaa1321, 
                           g_imaa1.imaa915                                          
     IF g_imaa1.imaa99  IS NULL THEN LET g_imaa1.imaa99 = 0 END IF
     IF g_imaa1.imaa133 IS NULL THEN LET g_imaa1.imaa133 = g_imaa1.imaa01 END IF
     IF g_imaa1.imaa01[1,4]='MISC' THEN 
        LET g_imaa1.imaa08='Z'
     END IF
  END IF
END FUNCTION
 
FUNCTION i150_default_imz(p_imaa)
   DEFINE p_imaa RECORD LIKE imaa_file.*
   LET g_sql = "SELECT imz03,imz04,",
               "       imz07,imz08,imz09,imz10,",
               "       imz11,imz12,imz14,imz15,",
               "       imz17,imz19,imz21,",
               "       imz23,imz24,imz27,",
               "       imz28,imz34,",
               "       imz35,imz36,imz37,imz38,",
               "       imz39,imz42,imz43,",
               "       imz45,imz46 ,imz47,",
               "       imz48,imz49,imz491,imz50,",
               "       imz51,imz52,imz54,",
               "       imz56,imz561,imz562,",
               "       imz571,",
               "       imz59 ,imz60,imz61,imz62,",
               "       imz64,imz641,",
               "       imz65,imz66,imz67,imz68,",
               "       imz69,imz70,imz71,",
               "       imz87,imz871,imz872,",
               "       imz873,imz874,imz88,imz89,",
               "       imz90,imz94,imz99,imz100 ,",
               "       imz101,imz102 ,imz103,imz105,",
               "       imz106,imz107,imz108,imz109,",
               "       imz110,imz130,imz131,imz132,",
               "       imz133,imz134,",
               "       imz147,imz148,imz903,",
               "       imz909,imz153,",      #FUN-9C0141 add imz153
               "       imz911,",
               "       imz136,imz137,imz391,imz1321,",
               "       imz72",
              #FUN-B50106 -----------------Begin-------------------
               "      ,imzicd01,imzicd02,imzicd03,imzicd04,imzicd05,",
               "       imzicd06,imzicd07,imzicd08,imzicd09,imzicd10,",
               "       imzicd12,imzicd13,imzicd14,imzicd15,imzicd16", 
              #FUN-B50106 -----------------End---------------------
              #"  FROM ",s_dbstring(g_dbase CLIPPED),"imz_file",        #TQC-940177  #FUN-A50102
               "  FROM ",cl_get_target_table(g_azp01,'imz_file'),     #FUN-A50102 
               " WHERE imz01 ='",p_imaa.imaa06 CLIPPED,"'" 
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_azp01) RETURNING g_sql   #FUN-A50102
   PREPARE ima06_p11 FROM g_sql
 
   EXECUTE ima06_p11 INTO p_imaa.imaa03,p_imaa.imaa04,
                         p_imaa.imaa07,p_imaa.imaa08,p_imaa.imaa09,p_imaa.imaa10,
                         p_imaa.imaa11,p_imaa.imaa12,p_imaa.imaa14,p_imaa.imaa15,
                         p_imaa.imaa17,p_imaa.imaa19,p_imaa.imaa21,
                         p_imaa.imaa23,p_imaa.imaa24,p_imaa.imaa27,
                         p_imaa.imaa28,p_imaa.imaa34,
                         p_imaa.imaa35,p_imaa.imaa36,p_imaa.imaa37,p_imaa.imaa38,
                         p_imaa.imaa39,p_imaa.imaa42,p_imaa.imaa43,
                         p_imaa.imaa45,p_imaa.imaa46,p_imaa.imaa47,
                         p_imaa.imaa48,p_imaa.imaa49,p_imaa.imaa491,p_imaa.imaa50,
                         p_imaa.imaa51,p_imaa.imaa52,p_imaa.imaa54,
                         p_imaa.imaa56,p_imaa.imaa561,p_imaa.imaa562,
                         p_imaa.imaa571,
                         p_imaa.imaa59,p_imaa.imaa60,p_imaa.imaa61,p_imaa.imaa62,
                         p_imaa.imaa64,p_imaa.imaa641,
                         p_imaa.imaa65,p_imaa.imaa66,p_imaa.imaa67,p_imaa.imaa68,
                         p_imaa.imaa69,p_imaa.imaa70,p_imaa.imaa71,
                         p_imaa.imaa87,p_imaa.imaa871,p_imaa.imaa872,
                         p_imaa.imaa873,p_imaa.imaa874,p_imaa.imaa88,p_imaa.imaa89,
                         p_imaa.imaa90,p_imaa.imaa94,p_imaa.imaa99,p_imaa.imaa100,     
                         p_imaa.imaa101,p_imaa.imaa102,p_imaa.imaa103,p_imaa.imaa105,  
                         p_imaa.imaa106,p_imaa.imaa107,p_imaa.imaa108,p_imaa.imaa109,  
                         p_imaa.imaa110,p_imaa.imaa130,p_imaa.imaa131,p_imaa.imaa132,  
                         p_imaa.imaa133,p_imaa.imaa134,                            
                         p_imaa.imaa147,p_imaa.imaa148,p_imaa.imaa903,
                         p_imaa.imaa909,p_imaa.imaa153,         #FUN-9C0141  add imaa153  
                         p_imaa.imaa911,                                         
                         p_imaa.imaa136,p_imaa.imaa137,p_imaa.imaa391,p_imaa.imaa1321, 
                         p_imaa.imaa915                                          
                       #FUN-B50106 --------------------Begin----------------------
                        ,p_imaa.imaaicd01,p_imaa.imaaicd02,p_imaa.imaaicd03,
                         p_imaa.imaaicd04,p_imaa.imaaicd05,p_imaa.imaaicd06,
                         p_imaa.imaaicd07,p_imaa.imaaicd08,p_imaa.imaaicd09,
                         p_imaa.imaaicd10,p_imaa.imaaicd12,p_imaa.imaaicd13,
                         p_imaa.imaaicd14,p_imaa.imaaicd15,p_imaa.imaaicd16
                       #FUN-B50106 --------------------End------------------------
      IF STATUS THEN
         #TQC-C70016--modify--str--
         #CALL cl_err('sel imz',SQLCA.sqlcode,1)
         IF SQLCA.sqlcode = 100 THEN 
            CALL cl_err(p_imaa.imaa06,'mfg3179',1)
         ELSE
            CALL cl_err('sel imz',SQLCA.sqlcode,1)
         END IF
         #TQC-C70016--modify--end--
         LET g_success = 'N'
         RETURN p_imaa.*     #FUN-9C0141
      END IF
   IF p_imaa.imaa99  IS NULL THEN LET p_imaa.imaa99 = 0 END IF
   IF p_imaa.imaa133 IS NULL THEN LET p_imaa.imaa133 = p_imaa.imaa01 END IF
   RETURN p_imaa.*
 
END FUNCTION
#FUN-BA0054 --START--
FUNCTION i150_chk_smd(i,l_ima01) 
DEFINE i        LIKE type_file.num5
DEFINE l_ima01  LIKE ima_file.ima01 
DEFINE l_sql    LIKE type_file.chr1000
DEFINE l_ima    RECORD LIKE ima_file.*
DEFINE l_imaicd RECORD LIKE imaicd_file.* 
DEFINE l_smd    RECORD LIKE smd_file.*

    LET g_showmsg=tm[i].azp03,'/',l_ima01

    #sel ima_file
    #LET l_sql = "SELECT * FROM ima_file WHERE ima01 = ? "  #TQC-C30236
    LET l_sql = "SELECT * FROM ",cl_get_target_table(tm[i].azp01,'ima_file')," WHERE ima01 = ? "   #TQC-C30236
    PREPARE icd_ima_c1 FROM l_sql
    EXECUTE icd_ima_c1 INTO l_ima.* USING l_ima01
    IF SQLCA.sqlcode THEN
       LET g_msg = 'select ',cl_get_target_table(tm[i].azp01,'ima_file')    
       CALL s_errmsg('azp03,ima01',g_showmsg,g_msg,SQLCA.SQLCODE,1)
    END IF
    IF cl_null(l_ima.ima01) THEN
       RETURN FALSE
    END IF  

    #sel imaicd_file
    #LET l_sql = "SELECT * FROM imaicd_file WHERE imaicd00 = ? "   #TQC-C30236
    LET l_sql = "SELECT * FROM ",cl_get_target_table(tm[i].azp01,'imaicd_file')," WHERE imaicd00 = ? "  #TQC-C30236
    PREPARE icd_imaicd_c1 FROM l_sql
    EXECUTE icd_imaicd_c1 INTO l_imaicd.* USING l_ima01 
    IF SQLCA.sqlcode THEN
       LET g_msg = 'select ',cl_get_target_table(tm[i].azp01,'imaicd_file')    
       CALL s_errmsg('azp03,imaicd00',g_showmsg,g_msg,SQLCA.SQLCODE,1)
    END IF
    IF cl_null(l_imaicd.imaicd00) THEN 
       RETURN FALSE
    END IF  
    
    
  

    #sel imaicd_file
    
    LET l_smd.smd01 =  l_ima.ima01
    LET l_smd.smdacti = 'Y'          
    LET l_smd.smdpos =  '1'
    LET l_smd.smddate =  NULL
    
    CASE l_ima.ima906    
       WHEN '1'   #單一單位
          LET l_smd.smd02 = l_ima.ima25
          LET l_smd.smd03 = l_ima.ima25
          LET l_smd.smd04 = 1          
          LET l_smd.smd06 = 1          
          IF NOT i150_ins_smd(i,l_smd.*) THEN
             RETURN FALSE
          END IF
       WHEN '3'   #參考單位
          IF l_imaicd.imaicd14 = 0 OR cl_null(l_imaicd.imaicd14) THEN
             RETURN FALSE
          END IF  
          #第一筆
          LET l_smd.smd02 = l_ima.ima25
          LET l_smd.smd03 = l_ima.ima907
          LET l_smd.smd04 = 1          
          LET l_smd.smd06 = l_imaicd.imaicd14
          LET l_smd.smd06 = s_digqty(l_smd.smd06,l_smd.smd03)   #No.FUN-BB0086          
          IF NOT i150_ins_smd(i,l_smd.*) THEN
             RETURN FALSE
          END IF
          #第二筆
          LET l_smd.smd02 = l_ima.ima907
          LET l_smd.smd03 = l_ima.ima25
          LET l_smd.smd04 = l_imaicd.imaicd14       
          LET l_smd.smd04 = s_digqty(l_smd.smd04,l_smd.smd02)   #No.FUN-BB0086
          LET l_smd.smd06 = 1          
          IF NOT i150_ins_smd(i,l_smd.*) THEN
             RETURN FALSE
          END IF 
    END CASE 
    RETURN TRUE     
END FUNCTION

FUNCTION i150_ins_smd(i,l_smd)
DEFINE i     LIKE type_file.num5
DEFINE l_sql LIKE type_file.chr1000
DEFINE l_cnt LIKE type_file.num10
DEFINE l_smd RECORD LIKE smd_file.*
DEFINE l_str1_smd           STRING
DEFINE l_str2_smd           STRING
DEFINE l_str3_smd           STRING

    LET g_showmsg=tm[i].azp03,'/',l_smd.smd01
    #sel smd_file count
    LET l_sql = "SELECT COUNT(smd01) FROM ",cl_get_target_table(tm[i].azp01,'smd_file'),
                " WHERE smd01 = ? AND smd02 = ? AND smd03 = ? "
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
    CALL cl_parse_qry_sql(l_sql,tm[i].azp01) RETURNING l_sql
    PREPARE icd_smd_c1 FROM l_sql
    EXECUTE icd_smd_c1 INTO l_cnt USING l_smd.smd01,l_smd.smd02,l_smd.smd03
    IF SQLCA.sqlcode THEN
       LET g_msg = 'select ',cl_get_target_table(tm[i].azp01,'smd_file')    
       CALL s_errmsg('azp03,smd01',g_showmsg,g_msg,SQLCA.SQLCODE,1)
       RETURN FALSE
    END IF
    
    IF l_cnt > 0 THEN   #已存在更新新GROSS換算率
       LET l_sql = "UPDATE ",cl_get_target_table(tm[i].azp01,'smd_file'),
                    " SET smd04 = ?, smd06 = ?",
                    " WHERE smd01 = ? AND smd02 = ? AND smd03 = ?"
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
       CALL cl_parse_qry_sql(l_sql,tm[i].azp01) RETURNING l_sql
       PREPARE icd_smd_c2 FROM l_sql
       EXECUTE icd_smd_c2 USING l_smd.smd04,l_smd.smd06,
                                l_smd.smd01,l_smd.smd02,l_smd.smd03             
       IF SQLCA.sqlcode THEN
          LET g_msg = 'update ',cl_get_target_table(tm[i].azp01,'smd_file')
          CALL s_errmsg('azp03,smd01',g_showmsg,g_msg,SQLCA.SQLCODE,1)
          RETURN FALSE
       END IF
    ELSE
       #定義cursor
       CALL s_carry_p_cs()    
       CALL s_carry_col('smd_file') RETURNING l_str1_smd,l_str2_smd,l_str3_smd
       LET l_sql = "INSERT INTO ",cl_get_target_table(tm[i].azp01,'smd_file'),
                  " VALUES(",l_str2_smd,")"       
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        
       CALL cl_parse_qry_sql(l_sql,tm[i].azp01) RETURNING l_sql
       PREPARE icd_smd_c3 FROM l_sql
       EXECUTE icd_smd_c3 USING l_smd.*
       IF SQLCA.sqlcode THEN
          LET g_msg = 'insert ',cl_get_target_table(tm[i].azp01,'smd_file')
          CALL s_errmsg('azp03,smd01',g_showmsg,g_msg,SQLCA.SQLCODE,1)
          RETURN FALSE
       END IF       
    END IF
    RETURN TRUE 
END FUNCTION

#FUN-BA0054 --END--
#MOD-C30121 ----- add ------ begin#拋轉對應的特性資料至imac_file
FUNCTION i150_ins_imac(p_azp01,p_imaa01)
DEFINE l_imad   RECORD  LIKE imad_file.*
DEFINE p_imaa01         LIKE imaa_file.imaa01,
       p_azp01          LIKE azp_file.azp01
DEFINE l_sql1           STRING,
       l_sql2           STRING

     LET l_sql1 = 'INSERT INTO ',cl_get_target_table(p_azp01,'imac_file'),'(',
                                        'imac01 ,',
                                        'imac02 ,',
                                        'imac03 ,',
                                        'imac04 ,',
                                        'imac05 ,',
                                        'imacuser ,',
                                        'imacgrup ,',
                                        'imacoriu ,',
                                        'imacorig ,',
                                        'imacmodu ,',
                                        'imacdate )',
                   'VALUES(?,?,?,?,? ,?,?,?,?,?,?)'                                       

     PREPARE imac_ins FROM l_sql1
     LET l_sql2 = "SELECT * FROM ",cl_get_target_table(p_azp01,'imad_file'),
                  " WHERE imad01 = '",p_imaa01,"'"
     PREPARE imad_pre FROM l_sql2
     DECLARE imad_curs CURSOR FOR imad_pre
     FOREACH imad_curs INTO l_imad.*
        IF STATUS THEN
           CALL cl_err('foreach:',STATUS,1)
           RETURN FALSE
        END IF
        EXECUTE imac_ins USING l_imad.imad01,l_imad.imad02,l_imad.imad03,l_imad.imad04,
                               l_imad.imad05,l_imad.imaduser,l_imad.imadgrup,l_imad.imadoriu,
                               l_imad.imadorig,l_imad.imadmodu,l_imad.imaddate
        IF SQLCA.sqlcode THEN
          LET g_msg = 'insert ',cl_get_target_table(p_azp01,'imac_file')
          CALL s_errmsg('imac01',l_imad.imad01,g_msg,SQLCA.SQLCODE,1)
          RETURN FALSE
        END IF
     END FOREACH

     RETURN TRUE

END FUNCTION
#MOD-C30121 ----- add ------ end  #拋轉對應的特性資料至imac_file
#NO.FUN-9C0072 精簡程式碼
#FUN-C40011---begin
FUNCTION i150_dbs_icd_ins(p_icu01,p_icu02)
DEFINE p_icu01  LIKE icu_file.icu01 
DEFINE p_icu02  LIKE icu_file.icu02
DEFINE l_imaa   RECORD  LIKE imaa_file.*
DEFINE l_i      LIKE type_file.num5
   #讀取相關資料..........................................
   SELECT * INTO l_imaa.* FROM imaa_file
    WHERE imaano = g_imaa.imaano
   IF STATUS THEN
      CALL s_errmsg('imaano',g_imaa.imaano,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   CALL s_aic_bom_ins(p_icu01,p_icu02,'',l_imaa.imaano)

   ###CALL s_aic_bom_ins()產生出來的料件與BOM，只會產生在目前所在的營運中心，
   ###需再依據資料中心的設定，將料件資料與BOM拋轉到各個營運中心去
   #拋轉料件
   FOR l_i = 1 TO tm.getLength()
       LET g_azp[l_i].sel   = tm[l_i].sel
       LET g_azp[l_i].azp01 = tm[l_i].azp01
       LET g_azp[l_i].azp02 = tm[l_i].azp02
       LET g_azp[l_i].azp03 = tm[l_i].azp03
   END FOR
       
   LET g_sql = "SELECT 'Y',imaicd00 FROM imaicd_file",
               " WHERE imaicd11='",l_imaa.imaano CLIPPED,"'",
               " ORDER BY imaicd00"
   PREPARE i150_imaicd00_p FROM g_sql
   DECLARE i150_imaicd00_cs CURSOR FOR i150_imaicd00_p
       
   LET l_i = 1
   FOREACH i150_imaicd00_cs INTO g_imax[l_i].*
      LET l_i = l_i + 1
   END FOREACH
   CALL s_aimi100_carry(g_imax,g_azp,g_gev04,'0')
END FUNCTION 
#FUN-C40011----end
