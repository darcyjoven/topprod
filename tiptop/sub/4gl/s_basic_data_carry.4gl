# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_basic_data_carry.4gl
# Descriptions...: 基本資料拋轉
# Date & Author..: 08/01/22 By Carrier FUN-7C0010
# Usage..........: CALL s_basic_data_carry(p_tables,p_azp)
# Input PARAMETER: p_tables 拋轉TABLE LIST (DYNAMIC ARRAY)  #No.FUN-7C0010
#                  p_azp    拋轉至DB 清單 (DYNAMIC ARRAY)
#                  p_gev04  資料中心代碼
#                  p_flag   標識 1.aoop603 DB間資料拋轉
#                                2.aoop605 txt資料進行拋轉
# Modify.........: No.FUN-830090 08/03/24 By Carrier -239的錯誤不做收集
# Modify.........: No.FUN-960132 09/07/01 By Kevin 調整成msv 架構
# Modify.........: No.MOD-980147 09/08/18 By Dido tag_file 改為 smc_file
# Modify.........: No.FUN-9B0113 09/11/19 By alex 調為使用cl_null_empty_to_file()
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:MOD-A80049 10/08/06 By lilingyu 資料拋轉時失敗:選擇索引名稱時錯誤
# Modify.........: No.FUN-A80036 10/08/11 By Carrier 临时表改名非固定命名方式
# Modify.........: No.FUN-AA0006 10/10/12 By vealxu GLOBAL 基本資料拋轉中心.新增拋轉資料檔.
# Modify.........: No.CHI-A80055 10/10/15 By Summer 加上拋轉aimi110的料件分群基本資料維護作業
# Modify.........: No.FUN-AA0083 10/10/27 By vealxu FUN-AA0006(資料中心), 程式修正
# Modify.........: No.FUN-A90024 10/11/10 By Jay 調整各DB利用sch_file取得table與field等資訊
# Modify.........: No.TQC-AB0256 10/11/29 By vealxu -239的錯誤判斷,應全部改成IF cl_sql_dup_value(SQLCA.SQLCODE)
# Modify.........: No.FUN-AC0038 10/12/21 By Carrier 选取idx时,要加上ORDER BY
# Modify.........: No.MOD-B50188 11/05/24 By sabrina 用web方式執行程式時會有錯誤訊息出現在畫面上
# Modify.........: No.FUN-B60097 11/06/20 By suncx 新增aimi200,aimi201資料拋轉
# Modify.........: No.FUN-B70021 11/07/26 By pauline 新增almi530資料拋轉
# Modify.........: No:TQC-B90211 11/10/21 By Smapmin 人事table drop
# Modify.........: No:FUN-BC0058 11/12/22 By yangxf 更改表字段
# Modify.........: No:FUN-BC0135 11/12/29 By pauline 補過單 
# Modify.........: No:CHI-CB0017 12/12/05 By Lori 新增s_data_transfer處理相關文件的拋轉
# Modify.........: NO.FUN-D40046 13/04/09 By SunLM 拋轉增加aeci650/aeci600/aeci670/aeci620

IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"

DEFINE g_tables   DYNAMIC ARRAY OF RECORD   #No.FUN-7C0010
                  sel      LIKE type_file.chr1,
                  prog     LIKE zz_file.zz01,
                  gaz03    LIKE gaz_file.gaz03,
                  zr02     LIKE gat_file.gat01,
                  gat03    LIKE gat_file.gat03,
                  temptb   STRING               #No.FUN-A80036
                  END RECORD
DEFINE g_azp      DYNAMIC ARRAY OF RECORD
                  sel      LIKE type_file.chr1,
                  azp01    LIKE azp_file.azp01,
                  azp02    LIKE azp_file.azp02,
                  azp03    LIKE azp_file.azp03
                  END RECORD
DEFINE g_gev04    LIKE gev_file.gev04
DEFINE g_msg      LIKE type_file.chr1000
DEFINE g_msg1     LIKE type_file.chr1000
DEFINE g_msg2     LIKE type_file.chr1000
DEFINE g_msg_x    LIKE type_file.chr1000
DEFINE g_sql      STRING
DEFINE g_db_type  LIKE type_file.chr3
DEFINE g_err      LIKE type_file.chr1000
DEFINE g_pi       LIKE type_file.num5
DEFINE g_path     DYNAMIC ARRAY OF RECORD
                  flag    LIKE type_file.chr1,
                  gew08   LIKE gew_file.gew08,
                  xml     LIKE ze_file.ze03,
                  attach  LIKE ze_file.ze03
                  END RECORD
                
 
FUNCTION s_basic_data_carry(p_tables,p_azp,p_gev04,p_flag)
   DEFINE p_tables             DYNAMIC ARRAY OF RECORD 
                               sel      LIKE type_file.chr1,
                               prog     LIKE zz_file.zz01,
                               gaz03    LIKE gaz_file.gaz03,
                               zr02     LIKE gat_file.gat01,
                               gat03    LIKE gat_file.gat03,
                               temptb   STRING               #No.FUN-A80036
                               END RECORD
   DEFINE p_azp                DYNAMIC ARRAY OF RECORD
                               sel      LIKE type_file.chr1,
                               azp01    LIKE azp_file.azp01,
                               azp02    LIKE azp_file.azp02,
                               azp03    LIKE azp_file.azp03
                               END RECORD
   DEFINE p_gev04              LIKE gev_file.gev04
   DEFINE p_flag               LIKE type_file.chr1
   DEFINE l_i                  LIKE type_file.num10
   DEFINE l_j                  LIKE type_file.num10
   DEFINE l_str1               STRING
   DEFINE l_str2               STRING
   DEFINE l_str3               STRING
   DEFINE l_str4               STRING
   DEFINE l_dbs_sep            LIKE type_file.chr50
   DEFINE l_gem                RECORD LIKE gem_file.*
   DEFINE l_gen                RECORD LIKE gen_file.*
   DEFINE l_azi                RECORD LIKE azi_file.*
   DEFINE l_azf                RECORD LIKE azf_file.*
   DEFINE l_geb                RECORD LIKE geb_file.*
   DEFINE l_gea                RECORD LIKE gea_file.*
   DEFINE l_gfe                RECORD LIKE gfe_file.*
  #DEFINE l_tag                RECORD LIKE tag_file.*		#MOD-980147 mark
   DEFINE l_smc                RECORD LIKE smc_file.*		#MOD-980147
   DEFINE l_geo                RECORD LIKE geo_file.*
   DEFINE l_gec                RECORD LIKE gec_file.*
   DEFINE l_ged                RECORD LIKE ged_file.*
   DEFINE l_azh                RECORD LIKE azh_file.*
   DEFINE l_apr                RECORD LIKE apr_file.*
   DEFINE l_apo                RECORD LIKE apo_file.*
   DEFINE l_fab                RECORD LIKE fab_file.*
   DEFINE l_fac                RECORD LIKE fac_file.*
   DEFINE l_fag                RECORD LIKE fag_file.*
   DEFINE l_nmb                RECORD LIKE nmb_file.*
   DEFINE l_nmc                RECORD LIKE nmc_file.*
   DEFINE l_nmk                RECORD LIKE nmk_file.*
   DEFINE l_nml                RECORD LIKE nml_file.*
   DEFINE l_nmo                RECORD LIKE nmo_file.*
   DEFINE l_nmt                RECORD LIKE nmt_file.*
   DEFINE l_pma                RECORD LIKE pma_file.*
   DEFINE l_pmb                RECORD LIKE pmb_file.*
   #DEFINE l_cph                RECORD LIKE cph_file.*   #TQC-B90211
   #DEFINE l_cpj                RECORD LIKE cpj_file.*   #TQC-B90211
   #DEFINE l_cpw                RECORD LIKE cpw_file.*   #TQC-B90211
   DEFINE l_qca                RECORD LIKE qca_file.*
   DEFINE l_qch                RECORD LIKE qch_file.*
   DEFINE l_qce                RECORD LIKE qce_file.*
   DEFINE l_qcj                RECORD LIKE qcj_file.*
   DEFINE l_qcb                RECORD LIKE qcb_file.*
   DEFINE l_obm                RECORD LIKE obm_file.*
   DEFINE l_tqa                RECORD LIKE tqa_file.*
   DEFINE l_ccd                RECORD LIKE ccd_file.*
   DEFINE l_oab                RECORD LIKE oab_file.*
   DEFINE l_oac                RECORD LIKE oac_file.*
   DEFINE l_oae                RECORD LIKE oae_file.*
   DEFINE l_oaf                RECORD LIKE oaf_file.*
   DEFINE l_oag                RECORD LIKE oag_file.*
   DEFINE l_oaj                RECORD LIKE oaj_file.*
   DEFINE l_oak                RECORD LIKE oak_file.*
   DEFINE l_ock                RECORD LIKE ock_file.*
   DEFINE l_oba                RECORD LIKE oba_file.*
   DEFINE l_obb                RECORD LIKE obb_file.*
   DEFINE l_obe                RECORD LIKE obe_file.*
   DEFINE l_oca                RECORD LIKE oca_file.*
   DEFINE l_oza                RECORD LIKE oza_file.*
   DEFINE l_ozb                RECORD LIKE ozb_file.*
   DEFINE l_ozc                RECORD LIKE ozc_file.*
   DEFINE l_imz                RECORD LIKE imz_file.* #CHI-A80055 add
   DEFINE l_tqa03              LIKE tqa_file.tqa03
   DEFINE l_lpc00              LIKE lpc_file.lpc00    #FUN-BC0058 add 
   DEFINE l_gew07              LIKE gew_file.gew07
   DEFINE l_azf02              LIKE azf_file.azf02
   DEFINE l_gew08              LIKE gew_file.gew07
   DEFINE l_flag               LIKE type_file.chr1
   DEFINE l_path               LIKE ze_file.ze03
   DEFINE l_lnk02              LIKE lnk_file.lnk02      #FUN-AA0083 
   #FUN-AA0006 -----------------------add  start---------------------
   DEFINE l_lmm                RECORD LIKE lmm_file.*
   DEFINE l_lmn                RECORD LIKE lmn_file.*
   DEFINE l_lmq                RECORD LIKE lmq_file.*
   DEFINE l_lmr                RECORD LIKE lmr_file.*
   DEFINE l_lms                RECORD LIKE lms_file.*
   DEFINE l_lmt                RECORD LIKE lmt_file.*
   DEFINE l_lnj                RECORD LIKE lnj_file.*
   DEFINE l_lnr                RECORD LIKE lnr_file.*
#FUN-BC0058 MARK---
#  DEFINE l_lpa                RECORD LIKE lpa_file.*
#  DEFINE l_lpb                RECORD LIKE lpb_file.*
#  DEFINE l_lpc                RECORD LIKE lpc_file.*
#  DEFINE l_lpd                RECORD LIKE lpd_file.*
#  DEFINE l_lpe                RECORD LIKE lpe_file.*
#  DEFINE l_lpf                RECORD LIKE lpf_file.*
#  DEFINE l_lpg                RECORD LIKE lpg_file.*
#FUN-BC0058 MARK---
#FUN-BC0058 begin---
   DEFINE l_lpc                RECORD LIKE lpc_file.*
#FUN-BC0058 end---
   DEFINE l_lph                RECORD LIKE lph_file.*
   DEFINE l_lrz                RECORD LIKE lrz_file.*
   DEFINE l_lpx                RECORD LIKE lpx_file.* 
   DEFINE l_lqf                RECORD LIKE lqf_file.*
   DEFINE l_lnk                RECORD LIKE lnk_file.*          #FUN-AA0083 add 
   DEFINE l_rya                RECORD LIKE rya_file.*
   DEFINE l_ryb                RECORD LIKE ryb_file.*
   DEFINE l_ryf                RECORD LIKE ryf_file.*
   DEFINE l_ryd                RECORD LIKE ryd_file.*
   DEFINE l_rxw                RECORD LIKE rxw_file.*
   DEFINE l_rta                RECORD LIKE rta_file.*
   DEFINE l_rtb                RECORD LIKE rtb_file.*
   DEFINE l_rtc                RECORD LIKE rtc_file.*
   DEFINE l_rvi                RECORD LIKE rvi_file.*
   DEFINE l_rvj                RECORD LIKE rvj_file.*
   DEFINE l_rvk                RECORD LIKE rvk_file.*
   DEFINE l_obp                RECORD LIKE obp_file.*
   DEFINE l_obn                RECORD LIKE obn_file.*
   DEFINE l_obo                RECORD LIKE obo_file.*
   DEFINE l_obq                RECORD LIKE obq_file.*
   DEFINE l_obr                RECORD LIKE obr_file.*  
   DEFINE l_obs                RECORD LIKE obs_file.*
   DEFINE l_obt                RECORD LIKE obt_file.*
   DEFINE l_obu                RECORD LIKE obu_file.*
   DEFINE l_obv                RECORD LIKE obv_file.*
   DEFINE l_obz                RECORD LIKE obz_file.*
   DEFINE l_adj                RECORD LIKE adj_file.*
   DEFINE l_raa                RECORD LIKE raa_file.*
   DEFINE l_tqb                RECORD LIKE tqb_file.*
   DEFINE l_imd                RECORD LIKE imd_file.*   #FUN-B60097 add 
   DEFINE l_ime                RECORD LIKE ime_file.*   #FUN-B60097 add 
   DEFINE l_lqq                RECORD LIKE lqq_file.*   #FUN-B70021 add
   DEFINE l_eca                RECORD LIKE eca_file.*   #FUN-D40046 add
   DEFINE l_ecd                RECORD LIKE ecd_file.*   #FUN-D40046 add
   DEFINE l_ecg                RECORD LIKE ecg_file.*   #FUN-D40046 add
   DEFINE l_eci                RECORD LIKE eci_file.*   #FUN-D40046 add
   #FUN-AA0006 -----------------------add end------------------------
   DEFINE l_lmm09              LIKE lmm_file.lmm09  #FUN-AA0083  
 
   WHENEVER ERROR CALL cl_err_msg_log

   IF p_tables.getLength() = 0 THEN RETURN END IF
   IF p_azp.getLength() = 0 THEN RETURN END IF
   CALL g_tables.clear()
 
   #前置准備
   FOR l_i = 1 TO p_tables.getLength()
       LET g_tables[l_i].* = p_tables[l_i].*
   END FOR
   FOR l_i = 1 TO p_azp.getLength()
       LET g_azp[l_i].* = p_azp[l_i].*
   END FOR
   LET g_gev04 = p_gev04
   LET g_db_type=cl_db_get_database_type()
 
   #定義cursor
   CALL s_carry_p_cs()
 
   CALL ui.Interface.refresh()
 
   #由于基本資料的拋轉先對table做loop,再對db做loop,對于發MAIL,有些不方便
   #故先將db的循環單列出
   FOR l_j = 1 TO g_azp.getLength()
       LET g_pi = l_j
       LET g_path[g_pi].flag   = 'N'
       LET g_path[g_pi].gew08  = NULL
       LET g_path[g_pi].xml    = NULL
       LET g_path[g_pi].attach = NULL
       IF cl_null(g_azp[l_j].azp03) THEN CONTINUE FOR END IF
       IF g_azp[l_j].sel = 'N' THEN CONTINUE FOR END IF
       #mail_1
       CALL s_basic_data_carry_send_mail_1(g_azp[l_j].azp01,l_j,g_gev04,'0')
   END FOR
 
 
   FOR l_i = 1 TO g_tables.getLength()
       IF cl_null(g_tables[l_i].zr02) THEN
          CONTINUE FOR
       END IF
       IF g_tables[l_i].sel = 'N' THEN
          CONTINUE FOR
       END IF
       #組column
       CALL s_carry_col(g_tables[l_i].zr02) RETURNING l_str1,l_str2,l_str3
       #組index
       CALL s_carry_idx(g_tables[l_i].zr02) RETURNING l_str4
       #從一個DB拋轉資料和從txt中上傳資料,不一樣處理
       #aoop603 時,table_name為正式表,比如gem_file
       #aoop605 時,table_name為臨時表,比如gem_file_bak
       IF p_flag = '1' THEN
          LET g_sql = "SELECT * FROM ",g_tables[l_i].zr02
       ELSE
          #No.FUN-A80036  --Begin                                               
          #LET g_sql = "SELECT * FROM ",g_tables[l_i].zr02 CLIPPED,"_bak"       
          LET g_sql = "SELECT * FROM ",g_tables[l_i].temptb CLIPPED             
          #No.FUN-A80036  --End
       END IF
       DECLARE sel_data_cs1 CURSOR FROM g_sql
 
       FOR l_j = 1 TO g_azp.getLength()
           IF cl_null(g_azp[l_j].azp03) THEN CONTINUE FOR END IF
           IF g_azp[l_j].sel = 'N' THEN CONTINUE FOR END IF
           SELECT gew07 INTO l_gew07 FROM gew_file
            WHERE gew01 = g_gev04
              AND gew02 = '0'
              AND gew04 = g_azp[l_j].azp01
           IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF
 
           CALL s_dbstring(g_azp[l_j].azp03) RETURNING l_dbs_sep
           LET g_sql = "INSERT INTO ",l_dbs_sep CLIPPED,
                        g_tables[l_i].zr02," VALUES(",l_str2,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
           PREPARE db_cs1 FROM g_sql
           LET g_sql = "UPDATE ",l_dbs_sep CLIPPED,
                        g_tables[l_i].zr02," SET ",l_str3,
                       " WHERE ",l_str4
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
           PREPARE db_cs2 FROM g_sql
           LET g_msg1 = 'ins ',g_azp[l_j].azp03 CLIPPED,':',g_tables[l_i].zr02,':'
           LET g_msg2 = 'upd ',g_azp[l_j].azp03 CLIPPED,':',g_tables[l_i].zr02,':'
           CASE g_tables[l_i].zr02
                WHEN 'gem_file'
                     FOREACH sel_data_cs1 INTO l_gem.*
                        EXECUTE db_cs1 USING l_gem.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_gem.gem01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN       #No.FUN-830090
                                 MESSAGE g_msg2,l_gem.gem01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_gem.*,l_gem.gem01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_gem.gem01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('gem01',l_gem.gem01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_gem.gem01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('gem01',l_gem.gem01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_gem.gem01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_gem.gem01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','gem_file',l_gem.gem01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'gen_file'
                     FOREACH sel_data_cs1 INTO l_gen.*
                        EXECUTE db_cs1 USING l_gen.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_gen.gen01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_gen.gen01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_gen.*,l_gen.gen01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_gen.gen01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('gen01',l_gen.gen01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_gen.gen01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('gen01',l_gen.gen01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_gen.gen01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_gen.gen01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','gen_file',l_gen.gen01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'azi_file'
                     FOREACH sel_data_cs1 INTO l_azi.*
                        EXECUTE db_cs1 USING l_azi.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_azi.azi01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_azi.azi01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_azi.*,l_azi.azi01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_azi.azi01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('azi01',l_azi.azi01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_azi.azi01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('azi01',l_azi.azi01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_azi.azi01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_azi.azi01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','azi_file',l_azi.azi01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'azf_file'
                     LET g_sql = "SELECT * FROM azf_file"
                     LET l_azf02 = NULL
                   # CASE g_tables[l_j].prog                 #FUN-AA0006 mark
                     CASE g_tables[l_i].prog                 #FUN-AA0006 add
                          WHEN 'aooi301' LET l_azf02 = '2'
                          WHEN 'aooi304' LET l_azf02 = '6'
                          WHEN 'aooi305' LET l_azf02 = '8'
                          WHEN 'aooi306' LET l_azf02 = 'A'
                          WHEN 'aooi309' LET l_azf02 = 'D'
                          WHEN 'aooi310' LET l_azf02 = 'E'
                          WHEN 'aooi311' LET l_azf02 = 'F'
                          WHEN 'aooi312' LET l_azf02 = 'G'
                          WHEN 'aooi313' LET l_azf02 = 'H'
                     END CASE
                     IF NOT cl_null(l_azf02) THEN
                        LET g_sql = g_sql CLIPPED," WHERE azf02 = '",l_azf02 CLIPPED,"'"
                     END IF
                     DECLARE sel_data_azf_cs CURSOR FROM g_sql
 
                     FOREACH sel_data_azf_cs INTO l_azf.*
                        EXECUTE db_cs1 USING l_azf.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_azf.azf01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_azf.azf01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_azf.*,l_azf.azf01,l_azf.azf02
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_azf.azf01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_azf.azf01,"/",l_azf.azf02
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('azf01,azf02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_azf.azf01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_azf.azf01,"/",l_azf.azf02
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('azf01,azf02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_azf.azf01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_azf.azf01||'+'||l_azf.azf02,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','azf_file',l_azf.azf01,l_azf.azf02,'','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'geb_file'
                     FOREACH sel_data_cs1 INTO l_geb.*
                        EXECUTE db_cs1 USING l_geb.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_geb.geb01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_geb.geb01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_geb.*,l_geb.geb01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_geb.geb01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('geb01',l_geb.geb01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_geb.geb01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('geb01',l_geb.geb01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_geb.geb01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_geb.geb01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','geb_file',l_geb.geb01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'gea_file'
                     FOREACH sel_data_cs1 INTO l_gea.*
                        EXECUTE db_cs1 USING l_gea.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_gea.gea01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_gea.gea01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_gea.*,l_gea.gea01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_gea.gea01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('gea01',l_gea.gea01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_gea.gea01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('gea01',l_gea.gea01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_gea.gea01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_gea.gea01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','gea_file',l_gea.gea01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'gfe_file'
                     FOREACH sel_data_cs1 INTO l_gfe.*
                        EXECUTE db_cs1 USING l_gfe.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_gfe.gfe01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_gfe.gfe01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_gfe.*,l_gfe.gfe01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_gfe.gfe01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('gfe01',l_gfe.gfe01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_gfe.gfe01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('gfe01',l_gfe.gfe01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_gfe.gfe01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_gfe.gfe01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','gfe_file',l_gfe.gfe01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
               #-MOD-980147-repace-
                WHEN 'smc_file'
                     FOREACH sel_data_cs1 INTO l_smc.*
                        EXECUTE db_cs1 USING l_smc.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_smc.smc01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_smc.smc01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_smc.*,l_smc.smc01,l_smc.smc02
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_smc.smc01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_smc.smc01,'/',l_smc.smc02
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('smc01,smc02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_smc.smc01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_smc.smc01,'/',l_smc.smc02
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('smc01,smc02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_smc.smc01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_smc.smc01||'+'||l_smc.smc02,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','smc_file',l_smc.smc01,l_smc.smc02,'','','')   #CHI-CB0017 add
                     END FOREACH
               #-MOD-980147-end-
 
                WHEN 'geo_file'
                     FOREACH sel_data_cs1 INTO l_geo.*
                        EXECUTE db_cs1 USING l_geo.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_geo.geo01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_geo.geo01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_geo.*,l_geo.geo01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_geo.geo01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('geo01',l_geo.geo01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_geo.geo01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('geo01',l_geo.geo01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_geo.geo01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_geo.geo01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','geo_file',l_geo.geo01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'gec_file'
                     FOREACH sel_data_cs1 INTO l_gec.*
                        EXECUTE db_cs1 USING l_gec.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_gec.gec01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_gec.gec01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_gec.*,l_gec.gec01,l_gec.gec011
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_gec.gec01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_gec.gec01,'/',l_gec.gec011
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('gec01,gec011',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_gec.gec01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_gec.gec01,'/',l_gec.gec011
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('gec01,gec011',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_gec.gec01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_gec.gec01||'+'||l_gec.gec011,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','gec_file',l_gec.gec01,l_gec.gec011,'','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'ged_file'
                     FOREACH sel_data_cs1 INTO l_ged.*
                        EXECUTE db_cs1 USING l_ged.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_ged.ged01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_ged.ged01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_ged.*,l_ged.ged01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_ged.ged01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('ged01',l_ged.ged01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_ged.ged01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('ged01',l_ged.ged01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_ged.ged01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_ged.ged01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','ged_file',l_ged.ged01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'azh_file'
                     FOREACH sel_data_cs1 INTO l_azh.*
                        EXECUTE db_cs1 USING l_azh.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_azh.azh01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_azh.azh01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_azh.*,l_azh.azh01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_azh.azh01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('azh01',l_azh.azh01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_azh.azh01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('azh01',l_azh.azh01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_azh.azh01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_azh.azh01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','azh_file',l_azh.azh01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'apr_file'
                     FOREACH sel_data_cs1 INTO l_apr.*
                        EXECUTE db_cs1 USING l_apr.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_apr.apr01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_apr.apr01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_apr.*,l_apr.apr01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_apr.apr01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('apr01',l_apr.apr01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_apr.apr01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('apr01',l_apr.apr01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_apr.apr01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_apr.apr01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','apr_file',l_apr.apr01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'apo_file'
                     FOREACH sel_data_cs1 INTO l_apo.*
                        EXECUTE db_cs1 USING l_apo.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_apo.apo01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_apo.apo01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_apo.*,l_apo.apo01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_apo.apo01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('apo01',l_apo.apo01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_apo.apo01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('apo01',l_apo.apo01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_apo.apo01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_apo.apo01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','apo_file',l_apo.apo01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'fab_file'
                     FOREACH sel_data_cs1 INTO l_fab.*
                        EXECUTE db_cs1 USING l_fab.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_fab.fab01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_fab.fab01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_fab.*,l_fab.fab01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_fab.fab01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('fab01',l_fab.fab01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_fab.fab01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('fab01',l_fab.fab01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_fab.fab01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_fab.fab01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','fab_file',l_fab.fab01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'fac_file'
                     FOREACH sel_data_cs1 INTO l_fac.*
                        EXECUTE db_cs1 USING l_fac.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_fac.fac01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_fac.fac01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_fac.*,l_fac.fac01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_fac.fac01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('fac01',l_fac.fac01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_fac.fac01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('fac01',l_fac.fac01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_fac.fac01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_fac.fac01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','fac_file',l_fac.fac01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'fag_file'
                     FOREACH sel_data_cs1 INTO l_fag.*
                        EXECUTE db_cs1 USING l_fag.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_fag.fag01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_fag.fag01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_fag.*,l_fag.fag01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_fag.fag01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('fag01',l_fag.fag01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_fag.fag01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('fag01',l_fag.fag01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_fag.fag01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_fag.fag01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','fag_file',l_fag.fag01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'nmb_file'
                     FOREACH sel_data_cs1 INTO l_nmb.*
                        EXECUTE db_cs1 USING l_nmb.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_nmb.nmb01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_nmb.nmb01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_nmb.*,l_nmb.nmb01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_nmb.nmb01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('nmb01',l_nmb.nmb01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_nmb.nmb01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('nmb01',l_nmb.nmb01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_nmb.nmb01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_nmb.nmb01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','nmb_file',l_nmb.nmb01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'nmc_file'
                     FOREACH sel_data_cs1 INTO l_nmc.*
                        EXECUTE db_cs1 USING l_nmc.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_nmc.nmc01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_nmc.nmc01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_nmc.*,l_nmc.nmc01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_nmc.nmc01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('nmc01',l_nmc.nmc01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_nmc.nmc01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('nmc01',l_nmc.nmc01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_nmc.nmc01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_nmc.nmc01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','nmc_file',l_nmc.nmc01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'nmk_file'
                     FOREACH sel_data_cs1 INTO l_nmk.*
                        EXECUTE db_cs1 USING l_nmk.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_nmk.nmk01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_nmk.nmk01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_nmk.*,l_nmk.nmk01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_nmk.nmk01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('nmk01',l_nmk.nmk01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_nmk.nmk01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('nmk01',l_nmk.nmk01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_nmk.nmk01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_nmk.nmk01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','nmk_file',l_nmk.nmk01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'nml_file'
                     FOREACH sel_data_cs1 INTO l_nml.*
                        EXECUTE db_cs1 USING l_nml.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_nml.nml01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_nml.nml01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_nml.*,l_nml.nml01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_nml.nml01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('nml01',l_nml.nml01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_nml.nml01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('nml01',l_nml.nml01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_nml.nml01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_nml.nml01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','nml_file',l_nml.nml01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'nmo_file'
                     FOREACH sel_data_cs1 INTO l_nmo.*
                        EXECUTE db_cs1 USING l_nmo.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_nmo.nmo01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_nmo.nmo01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_nmo.*,l_nmo.nmo01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_nmo.nmo01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('nmo01',l_nmo.nmo01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_nmo.nmo01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('nmo01',l_nmo.nmo01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_nmo.nmo01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_nmo.nmo01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','nmo_file',l_nmo.nmo01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'nmt_file'
                     FOREACH sel_data_cs1 INTO l_nmt.*
                        EXECUTE db_cs1 USING l_nmt.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_nmt.nmt01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_nmt.nmt01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_nmt.*,l_nmt.nmt01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_nmt.nmt01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('nmt01',l_nmt.nmt01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_nmt.nmt01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('nmt01',l_nmt.nmt01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_nmt.nmt01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_nmt.nmt01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','nmt_file',l_nmt.nmt01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'pma_file'
                     FOREACH sel_data_cs1 INTO l_pma.*
                        EXECUTE db_cs1 USING l_pma.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_pma.pma01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_pma.pma01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_pma.*,l_pma.pma01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_pma.pma01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('pma01',l_pma.pma01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_pma.pma01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('pma01',l_pma.pma01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_pma.pma01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_pma.pma01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','pma_file',l_pma.pma01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'pmb_file'
                     FOREACH sel_data_cs1 INTO l_pmb.*
                        EXECUTE db_cs1 USING l_pmb.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_pmb.pmb01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_pmb.pmb01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_pmb.*,l_pmb.pmb01,l_pmb.pmb03
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_pmb.pmb01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_pmb.pmb01,'/',l_pmb.pmb03
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('pmb01,pmb03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_pmb.pmb01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_pmb.pmb01,'/',l_pmb.pmb03
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('pmb01,pmb03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_pmb.pmb01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_pmb.pmb01||'+'||l_pmb.pmb03,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','pmb_file',l_pmb.pmb01,l_pmb.pmb03,'','','')   #CHI-CB0017 add
                     END FOREACH
 
                #-----TQC-B90211---------
                #WHEN 'cph_file'
                #     FOREACH sel_data_cs1 INTO l_cph.*
                #        EXECUTE db_cs1 USING l_cph.*
                #        IF SQLCA.sqlcode = 0 THEN
                #           MESSAGE g_msg1,l_cph.cph01,":ok"
                #           CALL ui.Interface.refresh()
                #        ELSE
                #           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                #              IF l_gew07 = 'N' THEN
                #                 MESSAGE g_msg2,l_cph.cph01,":exist"
                #                 CALL ui.Interface.refresh()
                #              ELSE
                #                 EXECUTE db_cs2 USING l_cph.*,l_cph.cph01
                #                 IF SQLCA.sqlcode = 0 THEN
                #                    MESSAGE g_msg2,l_cph.cph01,":ok"
                #                    CALL ui.Interface.refresh()
                #                 ELSE
                #                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                #                    CALL s_errmsg('cph01',l_cph.cph01,g_msg_x,SQLCA.sqlcode,1)
                #                    MESSAGE g_msg2,l_cph.cph01,":fail"
                #                    CALL ui.Interface.refresh()
                #                 END IF
                #              END IF
                #           ELSE
                #              LET g_msg_x = g_azp[l_j].azp01,':ins'
                #              CALL s_errmsg('cph01',l_cph.cph01,g_msg_x,SQLCA.sqlcode,1)
                #              MESSAGE g_msg1,l_cph.cph01,":fail"
                #              CALL ui.Interface.refresh()
                #           END IF
                #        END IF
                #        IF SQLCA.sqlerrd[3] > 0 THEN
                #           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                #                g_tables[l_i].prog,l_cph.cph01,'0',l_j)
                #        END IF
                #     END FOREACH
 
                #WHEN 'cpj_file'
                #     FOREACH sel_data_cs1 INTO l_cpj.*
                #        EXECUTE db_cs1 USING l_cpj.*
                #        IF SQLCA.sqlcode = 0 THEN
                #           MESSAGE g_msg1,l_cpj.cpj01,":ok"
                #           CALL ui.Interface.refresh()
                #        ELSE
                #           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                #              IF l_gew07 = 'N' THEN
                #                 MESSAGE g_msg2,l_cpj.cpj01,":exist"
                #                 CALL ui.Interface.refresh()
                #              ELSE
                #                 EXECUTE db_cs2 USING l_cpj.*,l_cpj.cpj01
                #                 IF SQLCA.sqlcode = 0 THEN
                #                    MESSAGE g_msg2,l_cpj.cpj01,":ok"
                #                    CALL ui.Interface.refresh()
                #                 ELSE
                #                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                #                    CALL s_errmsg('cpj01',l_cpj.cpj01,g_msg_x,SQLCA.sqlcode,1)
                #                    MESSAGE g_msg2,l_cpj.cpj01,":fail"
                #                    CALL ui.Interface.refresh()
                #                 END IF
                #              END IF
                #           ELSE
                #              LET g_msg_x = g_azp[l_j].azp01,':ins'
                #              CALL s_errmsg('cpj01',l_cpj.cpj01,g_msg_x,SQLCA.sqlcode,1)
                #              MESSAGE g_msg1,l_cpj.cpj01,":fail"
                #              CALL ui.Interface.refresh()
                #           END IF
                #        END IF
                #        IF SQLCA.sqlerrd[3] > 0 THEN
                #           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                #                g_tables[l_i].prog,l_cpj.cpj01,'0',l_j)
                #        END IF
                #     END FOREACH
                # 
                #WHEN 'cpw_file'
                #     FOREACH sel_data_cs1 INTO l_cpw.*
                #        EXECUTE db_cs1 USING l_cpw.*
                #        IF SQLCA.sqlcode = 0 THEN
                #           MESSAGE g_msg1,l_cpw.cpw01,":ok"
                #           CALL ui.Interface.refresh()
                #        ELSE
                #           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                #              IF l_gew07 = 'N' THEN
                #                 MESSAGE g_msg2,l_cpw.cpw01,":exist"
                #                 CALL ui.Interface.refresh()
                #              ELSE
                #                 EXECUTE db_cs2 USING l_cpw.*,l_cpw.cpw01
                #                 IF SQLCA.sqlcode = 0 THEN
                #                    MESSAGE g_msg2,l_cpw.cpw01,":ok"
                #                    CALL ui.Interface.refresh()
                #                 ELSE
                #                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                #                    CALL s_errmsg('cpw01',l_cpw.cpw01,g_msg_x,SQLCA.sqlcode,1)
                #                    MESSAGE g_msg2,l_cpw.cpw01,":fail"
                #                    CALL ui.Interface.refresh()
                #                 END IF
                #              END IF
                #           ELSE
                #              LET g_msg_x = g_azp[l_j].azp01,':ins'
                #              CALL s_errmsg('cpw01',l_cpw.cpw01,g_msg_x,SQLCA.sqlcode,1)
                #              MESSAGE g_msg1,l_cpw.cpw01,":fail"
                #              CALL ui.Interface.refresh()
                #           END IF
                #        END IF
                #        IF SQLCA.sqlerrd[3] > 0 THEN
                #           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                #                g_tables[l_i].prog,l_cpw.cpw01,'0',l_j)
                #        END IF
                #     END FOREACH
                #-----END TQC-B90211---------
 
                WHEN 'qca_file'
                     FOREACH sel_data_cs1 INTO l_qca.*
                        EXECUTE db_cs1 USING l_qca.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_qca.qca01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_qca.qca01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_qca.*,l_qca.qca01,l_qca.qca02,l_qca.qca03,l_qca.qca07
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_qca.qca01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_qca.qca01,'/',l_qca.qca02,'/',l_qca.qca03,'/',l_qca.qca07
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('qca01,qca02,qca03,qca07',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_qca.qca01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_qca.qca01,'/',l_qca.qca02,'/',l_qca.qca03,'/',l_qca.qca07
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('qca01,qca02,qca03,qca07',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_qca.qca01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_qca.qca01||'+'||l_qca.qca02||'+'||l_qca.qca03||'+'||l_qca.qca07,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','qca_file',l_qca.qca01,l_qca.qca02,l_qca.qca03,l_qca.qca07,'')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'qch_file'
                     FOREACH sel_data_cs1 INTO l_qch.*
                        EXECUTE db_cs1 USING l_qch.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_qch.qch01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_qch.qch01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_qch.*,l_qch.qch01,l_qch.qch02,l_qch.qch03,l_qch.qch07
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_qch.qch01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_qch.qch01,'/',l_qch.qch02,'/',l_qch.qch03,'/',l_qch.qch07
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('qch01,qch02,qch03,qch07',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_qch.qch01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_qch.qch01,'/',l_qch.qch02,'/',l_qch.qch03,'/',l_qch.qch07
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('qch01,qch02,qch03,qch07',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_qch.qch01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_qch.qch01||'+'||l_qch.qch02||'+'||l_qch.qch03||'+'||l_qch.qch07,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','qch_file',l_qch.qch01,l_qch.qch02,l_qch.qch03,l_qch.qch07,'')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'qce_file'
                     FOREACH sel_data_cs1 INTO l_qce.*
                        EXECUTE db_cs1 USING l_qce.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_qce.qce01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_qce.qce01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_qce.*,l_qce.qce01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_qce.qce01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('qce01',l_qce.qce01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_qce.qce01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('qce01',l_qce.qce01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_qce.qce01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_qce.qce01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','qce_file',l_qce.qce01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'qcj_file'
                     FOREACH sel_data_cs1 INTO l_qcj.*
                        EXECUTE db_cs1 USING l_qcj.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_qcj.qcj01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_qcj.qcj01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_qcj.*,l_qcj.qcj01,l_qcj.qcj02,l_qcj.qcj03,l_qcj.qcj04
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_qcj.qcj01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_qcj.qcj01,'/',l_qcj.qcj02,'/',l_qcj.qcj03,'/',l_qcj.qcj04
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('qcj01,qcj02,qcj03,qch04',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_qcj.qcj01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_qcj.qcj01,'/',l_qcj.qcj02,'/',l_qcj.qcj03,'/',l_qcj.qcj04
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('qcj01,qcj02,qcj03,qch04',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_qcj.qcj01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_qcj.qcj01||'+'||l_qcj.qcj02||'+'||l_qcj.qcj03||'+'||l_qcj.qcj04,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','qcj_file',l_qcj.qcj01,l_qcj.qcj02,l_qcj.qcj03,l_qcj.qcj04,'')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'qcb_file'
                     FOREACH sel_data_cs1 INTO l_qcb.*
                        EXECUTE db_cs1 USING l_qcb.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_qcb.qcb01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_qcb.qcb01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_qcb.*,l_qcb.qcb01,l_qcb.qcb02,l_qcb.qcb03
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_qcb.qcb01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_qcb.qcb01,'/',l_qcb.qcb02,'/',l_qcb.qcb03
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('qcb01,qcb02,qcb03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_qcb.qcb01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_qcb.qcb01,'/',l_qcb.qcb02,'/',l_qcb.qcb03
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('qcb01,qcb02,qcb03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_qcb.qcb01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_qcb.qcb01||'+'||l_qcb.qcb02||'+'||l_qcb.qcb03,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','qcb_file',l_qcb.qcb01,l_qcb.qcb02,l_qcb.qcb03,'','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'oaj_file'
                     FOREACH sel_data_cs1 INTO l_oaj.*
                        EXECUTE db_cs1 USING l_oaj.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_oaj.oaj01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_oaj.oaj01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_oaj.*,l_oaj.oaj01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_oaj.oaj01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('oaj01',l_oaj.oaj01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_oaj.oaj01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('oaj01',l_oaj.oaj01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_oaj.oaj01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_oaj.oaj01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','oaj_file',l_oaj.oaj01,'','','','')   #CHI-CB0017
                     END FOREACH
 
                WHEN 'obm_file'
                     FOREACH sel_data_cs1 INTO l_obm.*
                        EXECUTE db_cs1 USING l_obm.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_obm.obm01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_obm.obm01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_obm.*,l_obm.obm01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_obm.obm01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('obm01',l_obm.obm01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_obm.obm01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('obm01',l_obm.obm01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_obm.obm01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_obm.obm01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','obm_file',l_obm.obm01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'tqa_file'
                     LET g_sql = "SELECT * FROM tqa_file"
                     LET l_tqa03 = NULL
                   # CASE g_tables[l_j].prog                         #FUN-AA0006 mark
                     CASE g_tables[l_i].prog                         #FUN-AA0006 add
                          WHEN 'atmi401' LET l_tqa03 = '1'
                          WHEN 'atmi402' LET l_tqa03 = '2'
                          WHEN 'atmi403' LET l_tqa03 = '3'
                          WHEN 'atmi404' LET l_tqa03 = '4'
                          WHEN 'atmi405' LET l_tqa03 = '5'
                          WHEN 'atmi406' LET l_tqa03 = '6'
                          WHEN 'atmi407' LET l_tqa03 = '7'
                          WHEN 'atmi408' LET l_tqa03 = '8'
                          WHEN 'atmi409' LET l_tqa03 = '9'
                          WHEN 'atmi410' LET l_tqa03 = '10'
                          WHEN 'atmi411' LET l_tqa03 = '11'
                          WHEN 'atmi412' LET l_tqa03 = '12'
                          WHEN 'atmi413' LET l_tqa03 = '13'
                          WHEN 'atmi414' LET l_tqa03 = '14'
                          WHEN 'atmi415' LET l_tqa03 = '15'
                          WHEN 'atmi416' LET l_tqa03 = '16'
                          WHEN 'atmi417' LET l_tqa03 = '17'
                          WHEN 'atmi418' LET l_tqa03 = '18'
                          WHEN 'atmi419' LET l_tqa03 = '19'
                          WHEN 'atmi420' LET l_tqa03 = '20'
                          #FUN-AA0006 ------------------add start-------------------
                          WHEN 'arti101' LET l_tqa03 = '21'
                          WHEN 'arti102' LET l_tqa03 = '22'
                          WHEN 'arti103' LET l_tqa03 = '23' 
                          WHEN 'arti104' LET l_tqa03 = '24' 
                          #FUN-AA0006 ------------------add end--------------------
                     END CASE
                     IF NOT cl_null(l_tqa03) THEN
                        LET g_sql = g_sql CLIPPED," WHERE tqa03 = '",l_tqa03 CLIPPED,"'"
                     END IF
                     DECLARE sel_data_tqa_cs CURSOR FROM g_sql
 
                     FOREACH sel_data_tqa_cs INTO l_tqa.*
                        EXECUTE db_cs1 USING l_tqa.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_tqa.tqa01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_tqa.tqa01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_tqa.*,l_tqa.tqa01,l_tqa.tqa03
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_tqa.tqa01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_tqa.tqa01,'/',l_tqa.tqa03
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('tqa01,tqa03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_tqa.tqa01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_tqa.tqa01,'/',l_tqa.tqa03
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('tqa01,tqa03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_tqa.tqa01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_tqa.tqa01||'+'||l_tqa.tqa03,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','tqa_file',l_tqa.tqa01,l_tqa.tqa03,'','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'ccd_file'
                     FOREACH sel_data_cs1 INTO l_ccd.*
                        EXECUTE db_cs1 USING l_ccd.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_ccd.ccd01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_ccd.ccd01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_ccd.*,l_ccd.ccd01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_ccd.ccd01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('ccd01',l_ccd.ccd01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_ccd.ccd01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('ccd01',l_ccd.ccd01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_ccd.ccd01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_ccd.ccd01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','ccd_file',l_ccd.ccd01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'oab_file'
                     FOREACH sel_data_cs1 INTO l_oab.*
                        EXECUTE db_cs1 USING l_oab.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_oab.oab01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_oab.oab01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_oab.*,l_oab.oab01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_oab.oab01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('oab01',l_oab.oab01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_oab.oab01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('oab01',l_oab.oab01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_oab.oab01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_oab.oab01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','oab_file',l_oab.oab01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'oac_file'
                     FOREACH sel_data_cs1 INTO l_oac.*
                        EXECUTE db_cs1 USING l_oac.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_oac.oac01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_oac.oac01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_oac.*,l_oac.oac01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_oac.oac01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('oac01',l_oac.oac01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_oac.oac01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('oac01',l_oac.oac01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_oac.oac01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_oac.oac01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','oac_file',l_oac.oac01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'oae_file'
                     FOREACH sel_data_cs1 INTO l_oae.*
                        EXECUTE db_cs1 USING l_oae.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_oae.oae01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_oae.oae01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_oae.*,l_oae.oae01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_oae.oae01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('oae01',l_oae.oae01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_oae.oae01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('oae01',l_oae.oae01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_oae.oae01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_oae.oae01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','oae_file',l_oae.oae01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'oaf_file'
                     FOREACH sel_data_cs1 INTO l_oaf.*
                        EXECUTE db_cs1 USING l_oaf.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_oaf.oaf01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_oaf.oaf01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_oaf.*,l_oaf.oaf01,l_oaf.oaf02
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_oaf.oaf01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_oaf.oaf01,'/',l_oaf.oaf02
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('oaf01,oaf02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_oaf.oaf01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_oaf.oaf01,'/',l_oaf.oaf02
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('oaf01,oaf02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_oaf.oaf01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_oaf.oaf01||'+'||l_oaf.oaf02,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','oaf_file',l_oaf.oaf01,l_oaf.oaf02,'','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'oag_file'
                     FOREACH sel_data_cs1 INTO l_oag.*
                        EXECUTE db_cs1 USING l_oag.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_oag.oag01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_oag.oag01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_oag.*,l_oag.oag01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_oag.oag01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('oag01',l_oag.oag01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_oag.oag01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('oag01',l_oag.oag01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_oag.oag01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_oag.oag01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','oag_file',l_oag.oag01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'oak_file'
                     FOREACH sel_data_cs1 INTO l_oak.*
                        EXECUTE db_cs1 USING l_oak.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_oak.oak01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_oak.oak01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_oak.*,l_oak.oak01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_oak.oak01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('oak01',l_oak.oak01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_oak.oak01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('oak01',l_oak.oak01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_oak.oak01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_oak.oak01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','oak_file',l_oak.oak01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'ock_file'
                     FOREACH sel_data_cs1 INTO l_ock.*
                        EXECUTE db_cs1 USING l_ock.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_ock.ock01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_ock.ock01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_ock.*,l_ock.ock01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_ock.ock01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('ock01',l_ock.ock01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_ock.ock01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('ock01',l_ock.ock01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_ock.ock01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_ock.ock01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','ock_file',l_ock.ock01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'oba_file'
                     FOREACH sel_data_cs1 INTO l_oba.*
                        EXECUTE db_cs1 USING l_oba.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_oba.oba01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_oba.oba01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_oba.*,l_oba.oba01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_oba.oba01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('oba01',l_oba.oba01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_oba.oba01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('oba01',l_oba.oba01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_oba.oba01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_oba.oba01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','oba_file',l_oba.oba01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'obb_file'
                     FOREACH sel_data_cs1 INTO l_obb.*
                        EXECUTE db_cs1 USING l_obb.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_obb.obb01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_obb.obb01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_obb.*,l_obb.obb01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_obb.obb01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('obb01',l_obb.obb01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_obb.obb01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('obb01',l_obb.obb01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_obb.obb01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_obb.obb01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','obb_file',l_obb.obb01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'obe_file'
                     FOREACH sel_data_cs1 INTO l_obe.*
                        EXECUTE db_cs1 USING l_obe.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_obe.obe01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_obe.obe01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_obe.*,l_obe.obe01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_obe.obe01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('obe01',l_obe.obe01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_obe.obe01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('obe01',l_obe.obe01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_obe.obe01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_obe.obe01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','obe_file',l_obe.obe01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'oca_file'
                     FOREACH sel_data_cs1 INTO l_oca.*
                        EXECUTE db_cs1 USING l_oca.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_oca.oca01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_oca.oca01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_oca.*,l_oca.oca01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_oca.oca01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('oca01',l_oca.oca01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_oca.oca01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('oca01',l_oca.oca01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_oca.oca01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_oca.oca01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','oca_file',l_oca.oca01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'oza_file'
                     FOREACH sel_data_cs1 INTO l_oza.*
                        EXECUTE db_cs1 USING l_oza.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_oza.oza01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_oza.oza01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_oza.*,l_oza.oza01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_oza.oza01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('oza01',l_oza.oza01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_oza.oza01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('oza01',l_oza.oza01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_oza.oza01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_oza.oza01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','oza_file',l_oza.oza01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'ozb_file'
                     FOREACH sel_data_cs1 INTO l_ozb.*
                        EXECUTE db_cs1 USING l_ozb.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_ozb.ozb01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_ozb.ozb01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_ozb.*,l_ozb.ozb01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_ozb.ozb01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('ozb01',l_ozb.ozb01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_ozb.ozb01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('ozb01',l_ozb.ozb01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_ozb.ozb01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_ozb.ozb01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','ozb_file',l_ozb.ozb01,'','','','')   #CHI-CB0017 add
                     END FOREACH
 
                WHEN 'ozc_file'
                     FOREACH sel_data_cs1 INTO l_ozc.*
                        EXECUTE db_cs1 USING l_ozc.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_ozc.ozc01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_ozc.ozc01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_ozc.*,l_ozc.ozc01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_ozc.ozc01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('ozc01',l_ozc.ozc01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_ozc.ozc01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('ozc01',l_ozc.ozc01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_ozc.ozc01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_ozc.ozc01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','ozb_file',l_ozb.ozb01,'','','','')   #CHI-CB0017 add
                     END FOREACH
                
                #CHI-A80055 add --start--
                WHEN 'imz_file'
                     FOREACH sel_data_cs1 INTO l_imz.*
                        EXECUTE db_cs1 USING l_imz.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_imz.imz01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                         # IF SQLCA.sqlcode = -239 THEN      #TQC-AB0256
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #TQC-AB0256
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_imz.imz01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_imz.*,l_imz.imz01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_imz.imz01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('imz01',l_imz.imz01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_imz.imz01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('imz01',l_imz.imz01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_imz.imz01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_imz.imz01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','imz_file',l_imz.imz01,'','','','')   #CHI-CB0017 add
                     END FOREACH
                #CHI-A80055 add --end--

                 #FUN-AA0006 -------------------add start-------------------------------------
                 WHEN 'lmm_file'
                     FOREACH sel_data_cs1 INTO l_lmm.*
                        IF l_lmm.lmm09 != 'Y' THEN          #FUN-AA0083 add 
                           CONTINUE FOREACH                 #FUN-AA0083 add
                        END IF                              #FUN-AA0083 add  
                        EXECUTE db_cs1 USING l_lmm.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_lmm.lmm01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_lmm.lmm01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_lmm.*,l_lmm.lmm01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_lmm.lmm01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('lmm01',l_lmm.lmm01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_lmm.lmm01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                            # CALL s_errmsg('lmm',l_lmm.lmm01,g_msg_x,SQLCA.sqlcode,1)    #FUN-AA0083 mark
                              CALL s_errmsg('lmm01',l_lmm.lmm01,g_msg_x,SQLCA.sqlcode,1)  #FUN-AA0083 add
                              MESSAGE g_msg1,l_lmm.lmm01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_lmm.lmm01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','lmm_file',l_lmm.lmm01,'','','','')   #CHI-CB0017 add
                     END FOREACH
   
                 WHEN 'lmn_file'
                     FOREACH sel_data_cs1 INTO l_lmn.*
                        SELECT lmm09 INTO l_lmm09 FROM lmm_file WHERE lmm01 = l_lmn.lmn01         #FUN-AA0083
                        IF l_lmm09 != 'Y' THEN                                                    #FUN-AA0083
                           CONTINUE  FOREACH                                                      #FUN-AA0083
                        END IF                                                                    #FUN-AA0083 
                        EXECUTE db_cs1 USING l_lmn.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_lmn.lmn01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_lmn.lmn01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_lmn.*,l_lmn.lmn01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_lmn.lmn01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_lmn.lmn01,"/",l_lmn.lmn02                          #FUN-AA0083
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('lmn01,lmn02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)  #FUN-AA0083 add lmn02
                                    MESSAGE g_msg2,l_lmn.lmn01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_lmn.lmn01,"/",l_lmn.lmn02                          #FUN-AA0083 
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('lmn01,lmn02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)     #FUN-AA0083 add lmn02
                              MESSAGE g_msg1,l_lmn.lmn01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_lmn.lmn01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','lmn_file',l_lmn.lmn01,l_lmn.lmn02,'','','')   #CHI-CB0017 add
                     END FOREACH  

                  WHEN 'lmq_file'
                     FOREACH sel_data_cs1 INTO l_lmq.*
                        EXECUTE db_cs1 USING l_lmq.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_lmq.lmq01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_lmq.lmq01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_lmq.*,l_lmq.lmq01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_lmq.lmq01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('lmq01',l_lmq.lmq01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_lmq.lmq01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('lmq01',l_lmq.lmq01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_lmq.lmq01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_lmq.lmq01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','lmq_file',l_lmq.lmq01,'','','','')   #CHI-CB0017 add
                     END FOREACH                

                  WHEN 'lmr_file'
                     FOREACH sel_data_cs1 INTO l_lmr.*
                        EXECUTE db_cs1 USING l_lmr.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_lmr.lmr01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_lmr.lmr01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_lmr.*,l_lmr.lmr01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_lmr.lmr01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('lmr01',l_lmr.lmr01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_lmr.lmr01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('lmr01',l_lmr.lmr01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_lmr.lmr01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_lmr.lmr01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','lmr_file',l_lmr.lmr01,'','','','')   #CHI-CB0017 add
                     END FOREACH
  
                  WHEN 'lms_file'
                     FOREACH sel_data_cs1 INTO l_lms.*
                        EXECUTE db_cs1 USING l_lms.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_lms.lms01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_lms.lms01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_lms.*,l_lms.lms01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_lms.lms01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('lms01',l_lms.lms01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_lms.lms01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('lms01',l_lms.lms01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_lms.lms01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_lms.lms01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','lms_file',l_lms.lms01,'','','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'lmt_file'
                     FOREACH sel_data_cs1 INTO l_lmt.*
                        EXECUTE db_cs1 USING l_lmt.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_lmt.lmt01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_lmt.lmt01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_lmt.*,l_lmt.lmt01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_lmt.lmt01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('lmt01',l_lmt.lmt01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_lmt.lmt01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('lmt01',l_lmt.lmt01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_lmt.lmt01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_lmt.lmt01,'0',l_j)
                        END IF
                       CALL s_data_transfer(g_azp[l_j].azp01,'4','lmt_file',l_lmt.lmt01,'','','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'lnj_file'
                     FOREACH sel_data_cs1 INTO l_lnj.*
                        EXECUTE db_cs1 USING l_lnj.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_lnj.lnj01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_lnj.lnj01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_lnj.*,l_lnj.lnj01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_lnj.lnj01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('lnj01',l_lnj.lnj01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_lnj.lnj01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('lnj01',l_lnj.lnj01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_lnj.lnj01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_lnj.lnj01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','lnj_file',l_lnj.lnj01,'','','','')   #CHI-CB0017 add
                     END FOREACH 
  
                  WHEN 'lnr_file'
                     FOREACH sel_data_cs1 INTO l_lnr.*
                        EXECUTE db_cs1 USING l_lnr.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_lnr.lnr01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_lnr.lnr01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_lnr.*,l_lnr.lnr01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_lnr.lnr01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('lnr01',l_lnr.lnr01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_lnr.lnr01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('lnr01',l_lnr.lnr01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_lnr.lnr01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_lnr.lnr01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','lnr_file',l_lnr.lnr01,'','','','')   #CHI-CB0017 add
                     END FOREACH  
#FUN-BC0058 begin---
                 WHEN 'lpc_file'                     
                     LET g_sql = "SELECT * FROM lpc_file"
                     LET l_lpc00 = NULL
                     CASE g_tables[l_i].prog                         #FUN-AA0006 add
                          WHEN 'almi501' LET l_lpc00 = '1'
                          WHEN 'almi502' LET l_lpc00 = '2'
                          WHEN 'almi503' LET l_lpc00 = '3'
                          WHEN 'almi504' LET l_lpc00 = '4'
                          WHEN 'almi505' LET l_lpc00 = '5'
                          WHEN 'almi506' LET l_lpc00 = '6'
                          WHEN 'almi507' LET l_lpc00 = '7'
                          WHEN 'almi508' LET l_lpc00 = '8'
                     END CASE
                     IF NOT cl_null(l_lpc00) THEN
                        LET g_sql = g_sql CLIPPED," WHERE lpc00 = '",l_lpc00 CLIPPED,"'"
                     END IF
                     DECLARE sel_data_lpc_cs CURSOR FROM g_sql
                     FOREACH sel_data_lpc_cs INTO l_lpc.*
                        EXECUTE db_cs1 USING l_lpc.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_lpc.lpc01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN                    
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_lpc.lpc01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_lpc.*,l_lpc.lpc01,l_lpc.lpc00
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_lpc.lpc01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_lpc.lpc01,'/',l_lpc.lpc00
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('lpc01,lpc00',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_lpc.lpc01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_lpc.lpc01,'/',l_lpc.lpc00
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('lpc01,lpc00',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_lpc.lpc01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_lpc.lpc01||'+'||l_lpc.lpc00,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','lpc_file',l_lpc.lpc00,l_lpc.lpc01,'','','')   #CHI-CB0017 add
                     END FOREACH
#FUN-BC0058 end ---
#FUN-BC0058 MARK----
#                 WHEN 'lpa_file'  #FUN-BC0058 mark
#                     FOREACH sel_data_cs1 INTO l_lpa.*
#                        EXECUTE db_cs1 USING l_lpa.*
#                        IF SQLCA.sqlcode = 0 THEN
#                           MESSAGE g_msg1,l_lpa.lpa01,":ok"
#                           CALL ui.Interface.refresh()
#                        ELSE
#                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
#                              IF l_gew07 = 'N' THEN
#                                 MESSAGE g_msg2,l_lpa.lpa01,":exist"
#                                 CALL ui.Interface.refresh()
#                              ELSE
#                                 EXECUTE db_cs2 USING l_lpa.*,l_lpa.lpa01
#                                 IF SQLCA.sqlcode = 0 THEN
#                                    MESSAGE g_msg2,l_lpa.lpa01,":ok"
#                                    CALL ui.Interface.refresh()
#                                 ELSE
#                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
#                                    CALL s_errmsg('lpa01',l_lpa.lpa01,g_msg_x,SQLCA.sqlcode,1)
#                                    MESSAGE g_msg2,l_lpa.lpa01,":fail"
#                                    CALL ui.Interface.refresh()
#                                 END IF
#                              END IF
#                           ELSE
#                              LET g_msg_x = g_azp[l_j].azp01,':ins'
#                              CALL s_errmsg('lpa01',l_lpa.lpa01,g_msg_x,SQLCA.sqlcode,1)
#                              MESSAGE g_msg1,l_lpa.lpa01,":fail"
#                              CALL ui.Interface.refresh()
#                           END IF
#                        END IF
#                        IF SQLCA.sqlerrd[3] > 0 THEN
#                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
#                                g_tables[l_i].prog,l_lpa.lpa01,'0',l_j)
#                        END IF
#                     END FOREACH
#                  WHEN 'lpb_file'
#                     FOREACH sel_data_cs1 INTO l_lpb.*
#                        EXECUTE db_cs1 USING l_lpb.*
#                        IF SQLCA.sqlcode = 0 THEN
#                           MESSAGE g_msg1,l_lpb.lpb01,":ok"
#                           CALL ui.Interface.refresh()
#                        ELSE
#                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
#                              IF l_gew07 = 'N' THEN
#                                 MESSAGE g_msg2,l_lpb.lpb01,":exist"
#                                 CALL ui.Interface.refresh()
#                              ELSE
#                                 EXECUTE db_cs2 USING l_lpb.*,l_lpb.lpb01
#                                 IF SQLCA.sqlcode = 0 THEN
#                                    MESSAGE g_msg2,l_lpb.lpb01,":ok"
#                                    CALL ui.Interface.refresh()
#                                 ELSE
#                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
#                                    CALL s_errmsg('lpb01',l_lpb.lpb01,g_msg_x,SQLCA.sqlcode,1)
#                                    MESSAGE g_msg2,l_lpb.lpb01,":fail"
#                                    CALL ui.Interface.refresh()
#                                 END IF
#                              END IF
#                           ELSE
#                              LET g_msg_x = g_azp[l_j].azp01,':ins'
#                              CALL s_errmsg('lpb01',l_lpb.lpb01,g_msg_x,SQLCA.sqlcode,1)
#                              MESSAGE g_msg1,l_lpb.lpb01,":fail"
#                              CALL ui.Interface.refresh()
#                           END IF
#                        END IF
#                        IF SQLCA.sqlerrd[3] > 0 THEN
#                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
#                                g_tables[l_i].prog,l_lpb.lpb01,'0',l_j)
#                        END IF
#                     END FOREACH
#
#                  WHEN 'lpc_file'
#                     FOREACH sel_data_cs1 INTO l_lpc.*
#                        EXECUTE db_cs1 USING l_lpc.*
#                        IF SQLCA.sqlcode = 0 THEN
#                           MESSAGE g_msg1,l_lpc.lpc01,":ok"
#                           CALL ui.Interface.refresh()
#                        ELSE
#                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
#                              IF l_gew07 = 'N' THEN
#                                 MESSAGE g_msg2,l_lpc.lpc01,":exist"
#                                 CALL ui.Interface.refresh()
#                              ELSE
#                                 EXECUTE db_cs2 USING l_lpc.*,l_lpc.lpc01
#                                 IF SQLCA.sqlcode = 0 THEN
#                                    MESSAGE g_msg2,l_lpc.lpc01,":ok"
#                                    CALL ui.Interface.refresh()
#                                 ELSE
#                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
#                                    CALL s_errmsg('lpc01',l_lpc.lpc01,g_msg_x,SQLCA.sqlcode,1)
#                                    MESSAGE g_msg2,l_lpc.lpc01,":fail"
#                                    CALL ui.Interface.refresh()
#                                 END IF
#                              END IF
#                           ELSE
#                              LET g_msg_x = g_azp[l_j].azp01,':ins'
#                              CALL s_errmsg('lpc01',l_lpc.lpc01,g_msg_x,SQLCA.sqlcode,1)
#                              MESSAGE g_msg1,l_lpc.lpc01,":fail"
#                              CALL ui.Interface.refresh()
#                           END IF
#                        END IF
#                        IF SQLCA.sqlerrd[3] > 0 THEN
#                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
#                                g_tables[l_i].prog,l_lpc.lpc01,'0',l_j)
#                        END IF
#                     END FOREACH
#
#                  WHEN 'lpd_file'
#                     FOREACH sel_data_cs1 INTO l_lpd.*
#                        EXECUTE db_cs1 USING l_lpd.*
#                        IF SQLCA.sqlcode = 0 THEN
#                           MESSAGE g_msg1,l_lpd.lpd01,":ok"
#                           CALL ui.Interface.refresh()
#                        ELSE
#                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
#                              IF l_gew07 = 'N' THEN
#                                 MESSAGE g_msg2,l_lpd.lpd01,":exist"
#                                 CALL ui.Interface.refresh()
#                              ELSE
#                                 EXECUTE db_cs2 USING l_lpd.*,l_lpd.lpd01
#                                 IF SQLCA.sqlcode = 0 THEN
#                                    MESSAGE g_msg2,l_lpd.lpd01,":ok"
#                                    CALL ui.Interface.refresh()
#                                 ELSE
#                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
#                                    CALL s_errmsg('lpd01',l_lpd.lpd01,g_msg_x,SQLCA.sqlcode,1)
#                                    MESSAGE g_msg2,l_lpd.lpd01,":fail"
#                                    CALL ui.Interface.refresh()
#                                 END IF
#                              END IF
#                           ELSE
#                              LET g_msg_x = g_azp[l_j].azp01,':ins'
#                              CALL s_errmsg('lpd01',l_lpd.lpd01,g_msg_x,SQLCA.sqlcode,1)
#                              MESSAGE g_msg1,l_lpd.lpd01,":fail"
#                              CALL ui.Interface.refresh()
#                           END IF
#                        END IF
#                        IF SQLCA.sqlerrd[3] > 0 THEN
#                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
#                                g_tables[l_i].prog,l_lpd.lpd01,'0',l_j)
#                        END IF
#                     END FOREACH
#
#                  WHEN 'lpe_file'
#                     FOREACH sel_data_cs1 INTO l_lpe.*
#                        EXECUTE db_cs1 USING l_lpe.*
#                        IF SQLCA.sqlcode = 0 THEN
#                           MESSAGE g_msg1,l_lpe.lpe01,":ok"
#                           CALL ui.Interface.refresh()
#                        ELSE
#                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
#                              IF l_gew07 = 'N' THEN
#                                 MESSAGE g_msg2,l_lpe.lpe01,":exist"
#                                 CALL ui.Interface.refresh()
#                              ELSE
#                                 EXECUTE db_cs2 USING l_lpe.*,l_lpe.lpe01
#                                 IF SQLCA.sqlcode = 0 THEN
#                                    MESSAGE g_msg2,l_lpe.lpe01,":ok"
#                                    CALL ui.Interface.refresh()
#                                 ELSE
#                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
#                                    CALL s_errmsg('lpe01',l_lpe.lpe01,g_msg_x,SQLCA.sqlcode,1)
#                                    MESSAGE g_msg2,l_lpe.lpe01,":fail"
#                                    CALL ui.Interface.refresh()
#                                 END IF
#                              END IF
#                           ELSE
#                              LET g_msg_x = g_azp[l_j].azp01,':ins'
#                              CALL s_errmsg('lpe01',l_lpe.lpe01,g_msg_x,SQLCA.sqlcode,1)
#                              MESSAGE g_msg1,l_lpe.lpe01,":fail"
#                              CALL ui.Interface.refresh()
#                           END IF
#                        END IF
#                        IF SQLCA.sqlerrd[3] > 0 THEN
#                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
#                                g_tables[l_i].prog,l_lpe.lpe01,'0',l_j)
#                        END IF
#                     END FOREACH
#
#                  WHEN 'lpf_file'
#                     FOREACH sel_data_cs1 INTO l_lpf.*
#                        EXECUTE db_cs1 USING l_lpf.*
#                        IF SQLCA.sqlcode = 0 THEN
#                           MESSAGE g_msg1,l_lpf.lpf01,":ok"
#                           CALL ui.Interface.refresh()
#                        ELSE
#                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
#                              IF l_gew07 = 'N' THEN
#                                 MESSAGE g_msg2,l_lpf.lpf01,":exist"
#                                 CALL ui.Interface.refresh()
#                              ELSE
#                                 EXECUTE db_cs2 USING l_lpf.*,l_lpf.lpf01
#                                 IF SQLCA.sqlcode = 0 THEN
#                                    MESSAGE g_msg2,l_lpf.lpf01,":ok"
#                                    CALL ui.Interface.refresh()
#                                 ELSE
#                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
#                                    CALL s_errmsg('lpf01',l_lpf.lpf01,g_msg_x,SQLCA.sqlcode,1)
#                                    MESSAGE g_msg2,l_lpf.lpf01,":fail"
#                                    CALL ui.Interface.refresh()
#                                 END IF
#                              END IF
#                           ELSE
#                              LET g_msg_x = g_azp[l_j].azp01,':ins'
#                              CALL s_errmsg('lpf01',l_lpf.lpf01,g_msg_x,SQLCA.sqlcode,1)
#                              MESSAGE g_msg1,l_lpf.lpf01,":fail"
#                              CALL ui.Interface.refresh()
#                           END IF
#                        END IF
#                        IF SQLCA.sqlerrd[3] > 0 THEN
#                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
#                                g_tables[l_i].prog,l_lpf.lpf01,'0',l_j)
#                        END IF
#                     END FOREACH
#
#                  WHEN 'lpg_file'
#                     FOREACH sel_data_cs1 INTO l_lpg.*
#                        EXECUTE db_cs1 USING l_lpg.*
#                        IF SQLCA.sqlcode = 0 THEN
#                           MESSAGE g_msg1,l_lpg.lpg01,":ok"
#                           CALL ui.Interface.refresh()
#                        ELSE
#                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
#                              IF l_gew07 = 'N' THEN
#                                 MESSAGE g_msg2,l_lpg.lpg01,":exist"
#                                 CALL ui.Interface.refresh()
#                              ELSE
#                                 EXECUTE db_cs2 USING l_lpg.*,l_lpg.lpg01
#                                 IF SQLCA.sqlcode = 0 THEN
#                                    MESSAGE g_msg2,l_lpg.lpg01,":ok"
#                                    CALL ui.Interface.refresh()
#                                 ELSE
#                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
#                                    CALL s_errmsg('lpg01',l_lpg.lpg01,g_msg_x,SQLCA.sqlcode,1)
#                                    MESSAGE g_msg2,l_lpg.lpg01,":fail"
#                                    CALL ui.Interface.refresh()
#                                 END IF
#                              END IF
#                           ELSE
#                              LET g_msg_x = g_azp[l_j].azp01,':ins'
#                              CALL s_errmsg('lpg01',l_lpg.lpg01,g_msg_x,SQLCA.sqlcode,1)
#                              MESSAGE g_msg1,l_lpg.lpg01,":fail"
#                              CALL ui.Interface.refresh()
#                           END IF
#                        END IF
#                        IF SQLCA.sqlerrd[3] > 0 THEN
#                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
#                                g_tables[l_i].prog,l_lpg.lpg01,'0',l_j)
#                        END IF
#                     END FOREACH   
#FUN-BC0058 MARK----

                  WHEN 'lph_file'
                     FOREACH sel_data_cs1 INTO l_lph.*
                        IF l_lph.lph24 != 'Y' THEN             #FUN-AA0083
                           CONTINUE FOREACH                    #FUN-AA0083
                        END IF                                 #FUN-AA0083
                        EXECUTE db_cs1 USING l_lph.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_lph.lph01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_lph.lph01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_lph.*,l_lph.lph01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_lph.lph01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('lph01',l_lph.lph01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_lph.lph01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('lph01',l_lph.lph01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_lph.lph01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_lph.lph01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','lph_file',l_lph.lph01,'','','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'lrz_file'
                     FOREACH sel_data_cs1 INTO l_lrz.*
                        EXECUTE db_cs1 USING l_lrz.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_lrz.lrz01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_lrz.lrz01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_lrz.*,l_lrz.lrz01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_lrz.lrz01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('lrz01',l_lrz.lrz01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_lrz.lrz01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('lrz01',l_lrz.lrz01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_lrz.lrz01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_lrz.lrz01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','lrz_file',l_lrz.lrz01,'','','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'lpx_file'
                     FOREACH sel_data_cs1 INTO l_lpx.*
                        IF l_lpx.lpx15 != 'Y' THEN          #FUN-AA0083
                           CONTINUE FOREACH                 #FUN-AA0083
                        END IF                              #FUN-AA0083
                        EXECUTE db_cs1 USING l_lpx.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_lpx.lpx01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_lpx.lpx01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_lpx.*,l_lpx.lpx01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_lpx.lpx01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('lpx01',l_lpx.lpx01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_lpx.lpx01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('lpx01',l_lpx.lpx01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_lpx.lpx01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_lpx.lpx01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','lpx_file',l_lpx.lpx01,'','','','')   #CHI-CB0017 add
                     END FOREACH

                  #FUN-A0083------------------------------add start---------------------
                  WHEN 'lnk_file'
                     LET g_sql = "SELECT * FROM lnk_file"
                     LET l_lnk02 = NULL
                     CASE g_tables[l_i].prog
                        WHEN 'almi550' LET l_lnk02 = '1'
                        WHEN 'almi660' LET l_lnk02 = '2'
                     END CASE
                     IF NOT cl_null(l_lnk02) THEN
                        LET g_sql = g_sql CLIPPED," WHEN lnk02 = '",l_lnk02 CLIPPED,"'"
                     END IF 
                     DECLARE sel_data_lnk_cs CURSOR FROM g_sql
 
                     FOREACH sel_data_lnk_cs INTO l_lnk.*
                        EXECUTE db_cs1 USING l_lnk.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_lnk.lnk01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_lnk.lnk01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_lnk.*,l_lnk.lnk01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_lnk.lnk01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_lnk.lnk01,"/",l_lnk.lnk02,"/",l_lnk.lnk03,"/",l_lnk.lnk04           #FUN-AA0083
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('lnk01,lnk02,lnk03,lnk04',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_lnk.lnk01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_lnk.lnk01,"/",l_lnk.lnk02,"/",l_lnk.lnk03,"/",l_lnk.lnk04           #FUN-AA0083 
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('lnk01,lnk02,lnk03,lnk04',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_lnk.lnk01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_lnk.lnk01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','lnk_file',l_lnk.lnk01,l_lnk.lnk02,l_lnk.lnk03,l_lnk.lnk04,'')   #CHI-CB0017 add
                     END FOREACH
                  #FUN-AA0083 ----------------------------add end----------------------
                  WHEN 'lqf_file'
                     FOREACH sel_data_cs1 INTO l_lqf.*
                        EXECUTE db_cs1 USING l_lqf.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_lqf.lqf01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_lqf.lqf01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_lqf.*,l_lqf.lqf01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_lqf.lqf01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('lqf01',l_lqf.lqf01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_lqf.lqf01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('lqf01',l_lqf.lqf01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_lqf.lqf01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_lqf.lqf01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','lqf_file',l_lqf.lqf01,'','','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'rya_file'
                     FOREACH sel_data_cs1 INTO l_rya.*
                        EXECUTE db_cs1 USING l_rya.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_rya.rya01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_rya.rya01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_rya.*,l_rya.rya01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_rya.rya01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('rya01',l_rya.rya01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_rya.rya01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('rya01',l_rya.rya01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_rya.rya01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_rya.rya01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','rya_file',l_rya.rya01,'','','','')   #CHI-CB0017 add
                     END FOREACH   

                  WHEN 'ryb_file'
                     FOREACH sel_data_cs1 INTO l_ryb.*
                        EXECUTE db_cs1 USING l_ryb.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_ryb.ryb01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_ryb.ryb01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_ryb.*,l_ryb.ryb01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_ryb.ryb01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('ryb01',l_ryb.ryb01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_ryb.ryb01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('ryb01',l_ryb.ryb01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_ryb.ryb01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_ryb.ryb01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','ryb_file',l_ryb.ryb01,'','','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'ryf_file'
                     FOREACH sel_data_cs1 INTO l_ryf.*
                        EXECUTE db_cs1 USING l_ryf.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_ryf.ryf01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_ryf.ryf01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_ryf.*,l_ryf.ryf01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_ryf.ryf01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('ryf01',l_ryf.ryf01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_ryf.ryf01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('ryf01',l_ryf.ryf01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_ryf.ryf01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_ryf.ryf01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','ryf_file',l_ryf.ryf01,'','','','')   #CHI-CB0017 add
                     END FOREACH 

                  WHEN 'ryd_file'
                     FOREACH sel_data_cs1 INTO l_ryd.*
                        EXECUTE db_cs1 USING l_ryd.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_ryd.ryd01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_ryd.ryd01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_ryd.*,l_ryd.ryd01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_ryd.ryd01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('ryd01',l_ryd.ryd01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_ryd.ryd01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('ryd01',l_ryd.ryd01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_ryd.ryd01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_ryd.ryd01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','ryd_file',l_ryd.ryd01,l_ryd.ryd10,'','','')   #CHI-CB0017 add
                     END FOREACH 

                  WHEN 'rxw_file'
                     FOREACH sel_data_cs1 INTO l_rxw.*
                        EXECUTE db_cs1 USING l_rxw.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_rxw.rxw01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_rxw.rxw01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_rxw.*,l_rxw.rxw01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_rxw.rxw01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('rxw01',l_rxw.rxw01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_rxw.rxw01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('rxw01',l_rxw.rxw01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_rxw.rxw01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_rxw.rxw01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','rxw_file',l_rxw.rxw01,'','','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'rta_file'
                     FOREACH sel_data_cs1 INTO l_rta.*
                        EXECUTE db_cs1 USING l_rta.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_rta.rta01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_rta.rta01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_rta.*,l_rta.rta01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_rta.rta01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_rta.rta01,"/",l_rta.rta02                      #FUN-AA0083 add
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('rta01,rta02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)   #FUN-AA0083 add rta02
                                    MESSAGE g_msg2,l_rta.rta01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_rta.rta01,"/",l_rta.rta02                            #FUN-AA0083 add
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('rta01,rta02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)        #FUN-AA0083 add rta02
                              MESSAGE g_msg1,l_rta.rta01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_rta.rta01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','rta_file',l_rta.rta01,l_rta.rta02,'','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'rtb_file'
                     FOREACH sel_data_cs1 INTO l_rtb.*
                        EXECUTE db_cs1 USING l_rtb.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_rtb.rtb01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_rtb.rtb01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_rtb.*,l_rtb.rtb01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_rtb.rtb01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('rtb01',l_rtb.rtb01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_rtb.rtb01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('rtb01',l_rtb.rtb01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_rtb.rtb01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_rtb.rtb01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','rtb_file',l_rtb.rtb01,'','','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'rtc_file'
                     FOREACH sel_data_cs1 INTO l_rtc.*
                        EXECUTE db_cs1 USING l_rtc.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_rtc.rtc01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_rtc.rtc01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_rtc.*,l_rtc.rtc01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_rtc.rtc01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_rtc.rtc01,"/",l_rtc.rtc02                               #FUN-AA0083 add
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('rtc01,rtc02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)          #FUN-AA0083 add rtc02
                                    MESSAGE g_msg2,l_rtc.rtc01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_rtc.rtc01,"/",l_rtc.rtc02                               #FUN-AA0083 add
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('rtc01,rtc02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)             #FUN-A0083 add rtc02
                              MESSAGE g_msg1,l_rtc.rtc01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_rtc.rtc01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','rtc_file',l_rtc.rtc01,l_rtc.rtc02,'','','')   #CHI-CB0017 add\
                     END FOREACH 

                  WHEN 'rvi_file'
                     FOREACH sel_data_cs1 INTO l_rvi.*
                        EXECUTE db_cs1 USING l_rvi.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_rvi.rvi01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_rvi.rvi01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_rvi.*,l_rvi.rvi01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_rvi.rvi01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('rvi01',l_rvi.rvi01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_rvi.rvi01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('rvi01',l_rvi.rvi01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_rvi.rvi01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_rvi.rvi01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','rvi_file',l_rvi.rvi01,'','','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'rvj_file'
                     FOREACH sel_data_cs1 INTO l_rvj.*
                        EXECUTE db_cs1 USING l_rvj.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_rvj.rvj01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_rvj.rvj01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_rvj.*,l_rvj.rvj01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_rvj.rvj01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('rvj01',l_rvj.rvj01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_rvj.rvj01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('rvj01',l_rvj.rvj01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_rvj.rvj01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_rvj.rvj01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','rvj_file',l_rvj.rvj01,'','','','')   #CHI-CB0017 add
                     END FOREACH   

                  WHEN 'rvk_file'
                     FOREACH sel_data_cs1 INTO l_rvk.*
                        EXECUTE db_cs1 USING l_rvk.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_rvk.rvk01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_rvk.rvk01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_rvk.*,l_rvk.rvk01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_rvk.rvk01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_rvk.rvk01,"/",l_rvk.rvk02,"/",l_rvk.rvk03                     #FUN-AA0083
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('rvk01,rvk02,rvk04',g_showmsg,g_msg_x,SQLCA.sqlcode,1)          #FUN-AA0083 add rvk02,rvk04
                                    MESSAGE g_msg2,l_rvk.rvk01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_rvk.rvk01,"/",l_rvk.rvk02,"/",l_rvk.rvk03                     #FUN-AA0083
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('rvk01,rvk02,rvk04',g_showmsg,g_msg_x,SQLCA.sqlcode,1)        #FUN-AA0083 add rvk02,rvk04
                              MESSAGE g_msg1,l_rvk.rvk01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_rvk.rvk01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','rvk_file',l_rvk.rvk01,l_rvk.rvk02,l_rvk.rvk04,'','')   #CHI-CB0017 add
                     END FOREACH
#FUN-AA0083 ---------------------------mark start--------------------------------------- 
#                 WHEN 'obm_file'
#                  FOREACH sel_data_cs1 INTO l_obm.*
#                      EXECUTE db_cs1 USING l_obm.*
#                      IF SQLCA.sqlcode = 0 THEN
#                         MESSAGE g_msg1,l_obm.obm01,":ok"
#                         CALL ui.Interface.refresh()
#                      ELSE
#                         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
#                            IF l_gew07 = 'N' THEN
#                               MESSAGE g_msg2,l_obm.obm01,":exist"
#                               CALL ui.Interface.refresh()
#                           ELSE
#                              EXECUTE db_cs2 USING l_obm.*,l_obm.obm01
#                              IF SQLCA.sqlcode = 0 THEN
#                                 MESSAGE g_msg2,l_obm.obm01,":ok"
#                                 CALL ui.Interface.refresh()
#                              ELSE
#                                 LET g_msg_x = g_azp[l_j].azp01,':upd'
#                                 CALL s_errmsg('obm01',l_obm.obm01,g_msg_x,SQLCA.sqlcode,1)
#                                 MESSAGE g_msg2,l_obm.obm01,":fail"
#                                CALL ui.Interface.refresh()
#                              END IF
#                           END IF
#                        ELSE
#                           LET g_msg_x = g_azp[l_j].azp01,':ins'
#                           CALL s_errmsg('obm01',l_obm.obm01,g_msg_x,SQLCA.sqlcode,1)
#                           MESSAGE g_msg1,l_obm.obm01,":fail"
#                           CALL ui.Interface.refresh()
#                        END IF
#                     END IF
#                     IF SQLCA.sqlerrd[3] > 0 THEN
#                        CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
#                             g_tables[l_i].prog,l_obm.obm01,'0',l_j)
#                     END IF
#                  END FOREACH
#FUN-AA0083 ----------------------------mark---------------------------------

                  WHEN 'obp_file'
                     FOREACH sel_data_cs1 INTO l_obp.*
                        EXECUTE db_cs1 USING l_obp.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_obp.obp01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_obp.obp01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_obp.*,l_obp.obp01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_obp.obp01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_obp.obp01,"/",l_obp.obp02,"/",l_obp.obp03            #FUN-AA0083
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('obp01,obp02,obp03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)  #FUN-AA0083 add obp02,obp03
                                    MESSAGE g_msg2,l_obp.obp01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_obp.obp01,"/",l_obp.obp02,"/",l_obp.obp03            #FUN-AA0083
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('obp01,obp02,obp03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)     #FUN-AA0083 add obp02,obp03
                              MESSAGE g_msg1,l_obp.obp01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_obp.obp01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','obp_file',l_obp.obp01,l_obp.obp02,l_obp.obp03,'','')   #CHI-CB0017 add
                     END FOREACH   

                  WHEN 'obn_file'
                     FOREACH sel_data_cs1 INTO l_obn.*
                        EXECUTE db_cs1 USING l_obn.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_obn.obn01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_obn.obn01,":exist"
                 	               CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_obn.*,l_obn.obn01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_obn.obn01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('obn01',l_obn.obn01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_obn.obn01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('obn01',l_obn.obn01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_obn.obn01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_obn.obn01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','obn_file',l_obn.obn01,'','','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'obo_file'
                     FOREACH sel_data_cs1 INTO l_obo.*
                        EXECUTE db_cs1 USING l_obo.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_obo.obo01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_obo.obo01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_obo.*,l_obo.obo01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_obo.obo01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_obo.obo01,"/",l_obo.obo02                        #FUN-AA0083
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('obo01,obo02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)   #FUN-AA0083 add obo02
                                    MESSAGE g_msg2,l_obo.obo01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_obo.obo01,"/",l_obo.obo02                        #FUN-AA0083
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('obo01,obo02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)       #FUN-AA0083 add obo02  
                              MESSAGE g_msg1,l_obo.obo01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_obo.obo01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','obo_file',l_obo.obo01,l_obo.obo02,'','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'obq_file'
                     FOREACH sel_data_cs1 INTO l_obq.*
                        EXECUTE db_cs1 USING l_obq.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_obq.obq01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_obq.obq01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_obq.*,l_obq.obq01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_obq.obq01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('obq01',l_obq.obq01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_obq.obq01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('obq01',l_obq.obq01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_obq.obq01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_obq.obq01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','obq_file',l_obq.obq01,'','','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'obr_file'
                     FOREACH sel_data_cs1 INTO l_obr.*
                        EXECUTE db_cs1 USING l_obr.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_obr.obr01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_obr.obr01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_obr.*,l_obr.obr01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_obr.obr01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('obr01',l_obr.obr01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_obr.obr01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('obr01',l_obr.obr01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_obr.obr01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_obr.obr01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','obr_file',l_obr.obr01,'','','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'obs_file'
                     FOREACH sel_data_cs1 INTO l_obs.*
                        EXECUTE db_cs1 USING l_obs.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_obs.obs01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_obs.obs01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_obs.*,l_obs.obs01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_obs.obs01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('obs01',l_obs.obs01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_obs.obs01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('obs01',l_obs.obs01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_obs.obs01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_obs.obs01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','obs_file',l_obs.obs01,'','','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'obt_file'
                     FOREACH sel_data_cs1 INTO l_obt.*
                        EXECUTE db_cs1 USING l_obt.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_obt.obt01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_obt.obt01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_obt.*,l_obt.obt01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_obt.obt01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_obt.obt01,"/",l_obt.obt02                             #FUN-AA0083
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('obt01,obt02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)  #FUN-AA0083 add obt02
                                    MESSAGE g_msg2,l_obt.obt01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_obt.obt01,"/",l_obt.obt02                             #FUN-AA0083
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('obt01,obt02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)         #FUN-AA0083 add obt02
                              MESSAGE g_msg1,l_obt.obt01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_obt.obt01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','obt_file',l_obt.obt01,l_obt.obt02,'','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'obu_file'
                     FOREACH sel_data_cs1 INTO l_obu.*
                        EXECUTE db_cs1 USING l_obu.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_obu.obu01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_obu.obu01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_obu.*,l_obu.obu01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_obu.obu01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('obu01',l_obu.obu01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_obu.obu01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('obu01',l_obu.obu01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_obu.obu01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_obu.obu01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','obu_file',l_obu.obu01,'','','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'obv_file'
                     FOREACH sel_data_cs1 INTO l_obv.*
                        EXECUTE db_cs1 USING l_obv.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_obv.obv01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_obv.obv01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_obv.*,l_obv.obv01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_obv.obv01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_obv.obv01,"/",l_obv.obv02                            #FUN-AA0083
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('obv01,obv02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)   #FUN-AA0083 add obv02
                                    MESSAGE g_msg2,l_obv.obv01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_obv.obv01,"/",l_obv.obv02                            #FUN-AA0083
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('obv01,obv02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)        #FUN-AA0083 addd obv02
                              MESSAGE g_msg1,l_obv.obv01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_obv.obv01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','obv_file',l_obv.obv01,l_obv.obv02,'','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'obz_file'
                     FOREACH sel_data_cs1 INTO l_obz.*
                        EXECUTE db_cs1 USING l_obz.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_obz.obz01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_obz.obz01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_obz.*,l_obz.obz01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_obz.obz01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('obz01',l_obz.obz01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_obz.obz01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('obz01',l_obz.obz01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_obz.obz01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_obz.obz01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','obz_file',l_obz.obz01,'','','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'adj_file'
                     FOREACH sel_data_cs1 INTO l_adj.*
                        EXECUTE db_cs1 USING l_adj.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_adj.adj01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_adj.adj01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_adj.*,l_adj.adj01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_adj.adj01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('adj01',l_adj.adj01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_adj.adj01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('adj01',l_adj.adj01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_adj.adj01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_adj.adj01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','adj_file',l_adj.adj01,'','','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'raa_file'
                     FOREACH sel_data_cs1 INTO l_raa.*
                        EXECUTE db_cs1 USING l_raa.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_raa.raa01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_raa.raa01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_raa.*,l_raa.raa01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_raa.raa01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_showmsg = l_raa.raa01,"/",l_raa.raa02                            #FUN-AA0083
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('raa01,raa02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)   #FUN-AA0083 add raa02
                                    MESSAGE g_msg2,l_raa.raa01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_showmsg = l_raa.raa01,"/",l_raa.raa02                            #FUN-AA0083
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('raa01,raa02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)         #FUN-A0083 add raa02
                              MESSAGE g_msg1,l_raa.raa01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_raa.raa01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','raa_file',l_raa.raa01,l_raa.raa02,'','','')   #CHI-CB0017 add
                     END FOREACH

                  WHEN 'tqb_file'
                     FOREACH sel_data_cs1 INTO l_tqb.*
                        EXECUTE db_cs1 USING l_tqb.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_tqb.tqb01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_tqb.tqb01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_tqb.*,l_tqb.tqb01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_tqb.tqb01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('tqb01',l_tqb.tqb01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_tqb.tqb01,":fa`il"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('tqb01',l_tqb.tqb01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_tqb.tqb01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_tqb.tqb01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','tqb_file',l_tqb.tqb01,'','','','')   #CHI-CB0017 add
                     END FOREACH
                  #FUN-AA0006 ----------------------add end------------------------------------------ 
                  #FUN-B60097 ----------------------add begin-----------------------------------
                  WHEN 'imd_file'
                     FOREACH sel_data_cs1 INTO l_imd.*
                        EXECUTE db_cs1 USING l_imd.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_imd.imd01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_imd.imd01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_imd.*,l_imd.imd01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_imd.imd01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('imd01',l_imd.imd01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_imd.imd01,":fa`il"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('imd01',l_imd.imd01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_imd.imd01,":fail"
                              CALL ui.Interface.refresh()
                           END IF   
                        END IF      
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_imd.imd01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','imd_file',l_imd.imd01,'','','','')   #CHI-CB0017 add
                     END FOREACH 
                     
                  WHEN 'ime_file'
                     FOREACH sel_data_cs1 INTO l_ime.*
                        EXECUTE db_cs1 USING l_ime.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_ime.ime01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_ime.ime01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_ime.*,l_ime.ime01,l_ime.ime02
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_ime.ime01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('ime01',l_ime.ime01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_ime.ime01,":fa`il"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('ime01',l_ime.ime01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_ime.ime01,":fail"
                              CALL ui.Interface.refresh()
                           END IF   
                        END IF      
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_ime.ime01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','ime_file',l_ime.ime01,l_ime.ime02,'','','')   #CHI-CB0017 add
                     END FOREACH  
                  #FUN-B60097 ----------------------add end-------------------------------------
               #FUN-B70021   ADD BEGIN
                  WHEN 'lqq_file'
                     FOREACH sel_data_cs1 INTO l_lqq.*
                        EXECUTE db_cs1 USING l_lqq.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_lqq.lqq01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_lqq.lqq01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_lqq.*,l_lqq.lqq01,l_lqq.lqq02
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_lqq.lqq01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('lqq01',l_lqq.lqq01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_lqq.lqq01,":fail"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('lqq01',l_lqq.lqq01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_lqq.lqq01,":fail"
                              CALL ui.Interface.refresh()
                           END IF
                        END IF
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_lqq.lqq01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','lqq_file',l_lqq.lqq01,l_lqq.lqq02,'','','')   #CHI-CB0017 add
                     END FOREACH
               #FUN-B70021   ADD END    
                  #FUN-D40046 ----------------------add begin-----------------------------------
                  WHEN 'eca_file'
                     FOREACH sel_data_cs1 INTO l_eca.*
                        EXECUTE db_cs1 USING l_eca.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_eca.eca01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_eca.eca01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_eca.*,l_eca.eca01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_eca.eca01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('eca01',l_eca.eca01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_eca.eca01,":fa`il"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('eca01',l_eca.eca01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_eca.eca01,":fail"
                              CALL ui.Interface.refresh()
                           END IF   
                        END IF      
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_eca.eca01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','eca_file',l_eca.eca01,'','','','')   
                     END FOREACH 
                     
                  WHEN 'ecd_file'
                     FOREACH sel_data_cs1 INTO l_ecd.*
                        EXECUTE db_cs1 USING l_ecd.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_ecd.ecd01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_ecd.ecd01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_ecd.*,l_ecd.ecd01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_ecd.ecd01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('ecd01',l_ecd.ecd01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_ecd.ecd01,":fa`il"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('ecd01',l_ecd.ecd01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_ecd.ecd01,":fail"
                              CALL ui.Interface.refresh()
                           END IF   
                        END IF      
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_ecd.ecd01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','ecd_file',l_ecd.ecd01,'','','','')   
                     END FOREACH 
                  WHEN 'ecg_file'
                     FOREACH sel_data_cs1 INTO l_ecg.*
                        EXECUTE db_cs1 USING l_ecg.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_ecg.ecg01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_ecg.ecg01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_ecg.*,l_ecg.ecg01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_ecg.ecg01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('ecg01',l_ecg.ecg01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_ecg.ecg01,":fa`il"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('ecg01',l_ecg.ecg01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_ecg.ecg01,":fail"
                              CALL ui.Interface.refresh()
                           END IF   
                        END IF      
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_ecg.ecg01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','ecg_file',l_ecg.ecg01,'','','','')   
                     END FOREACH 
                  WHEN 'eci_file'
                     FOREACH sel_data_cs1 INTO l_eci.*
                        EXECUTE db_cs1 USING l_eci.*
                        IF SQLCA.sqlcode = 0 THEN
                           MESSAGE g_msg1,l_eci.eci01,":ok"
                           CALL ui.Interface.refresh()
                        ELSE
                           IF cl_sql_dup_value(SQLCA.SQLCODE) THEN    #No.FUN-A80036
                              IF l_gew07 = 'N' THEN
                                 MESSAGE g_msg2,l_eci.eci01,":exist"
                                 CALL ui.Interface.refresh()
                              ELSE
                                 EXECUTE db_cs2 USING l_eci.*,l_eci.eci01
                                 IF SQLCA.sqlcode = 0 THEN
                                    MESSAGE g_msg2,l_eci.eci01,":ok"
                                    CALL ui.Interface.refresh()
                                 ELSE
                                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                                    CALL s_errmsg('eci01',l_eci.eci01,g_msg_x,SQLCA.sqlcode,1)
                                    MESSAGE g_msg2,l_eci.eci01,":fa`il"
                                    CALL ui.Interface.refresh()
                                 END IF
                              END IF
                           ELSE
                              LET g_msg_x = g_azp[l_j].azp01,':ins'
                              CALL s_errmsg('eci01',l_eci.eci01,g_msg_x,SQLCA.sqlcode,1)
                              MESSAGE g_msg1,l_eci.eci01,":fail"
                              CALL ui.Interface.refresh()
                           END IF   
                        END IF      
                        IF SQLCA.sqlerrd[3] > 0 THEN
                           CALL s_basic_data_carry_record(g_gev04,g_azp[l_j].azp01,
                                g_tables[l_i].prog,l_eci.eci01,'0',l_j)
                        END IF
                        CALL s_data_transfer(g_azp[l_j].azp01,'4','eci_file',l_eci.eci01,'','','','')   
                     END FOREACH                                           
              #FUN-D40046 ----------------------add end------------------------------------- 
           END CASE
       END FOR
   END FOR
   MESSAGE 'Data Carry Finish!'
   CALL ui.Interface.refresh()
   FOR l_j = 1 TO g_azp.getLength()
       LET g_pi = l_j
       IF cl_null(g_azp[l_j].azp03) THEN CONTINUE FOR END IF
       IF g_azp[l_j].sel = 'N' THEN CONTINUE FOR END IF
       #mail 2
       CALL s_basic_data_carry_send_mail_2()
   END FOR
 
 
  #CALL s_carry_send_mail()
END FUNCTION
 
FUNCTION s_carry_p_cs()
    #---FUN-A90024---start-----
    #改寫各DB分別利用DB內所提供之systable取得TIPTOP table & field等資訊方式
    #目前統一用sch_file紀錄TIPTOP資料結構
    #LET g_db_type=cl_db_get_database_type() #FUN-960132
    #CASE g_db_type 
    #   WHEN 'IFX' 
    #      LET g_sql = " SELECT colname FROM syscolumns ",
    #                  "  WHERE tabid = ? ",
    #                  "  ORDER BY colno "
    #   WHEN 'MSV'  #FUN-960132
    #      LET g_sql = " SELECT name FROM sys.all_columns ",
    #                  "  WHERE object_id =object_id(?) ",
    #                  "  ORDER BY COLUMN_ID " 
    #   WHEN 'ORA'
    #      LET g_sql = " SELECT column_name FROM all_tab_columns ",
    #                  "  WHERE LOWER(owner) = 'ds' AND UPPER(table_name)= ? ",
    #                  "  ORDER BY COLUMN_ID "
    #END CASE
    LET g_sql = " SELECT sch02 FROM sch_file ",
                "  WHERE UPPER(sch01) = ? ",
                "  ORDER BY sch05 "
    #---FUN-A90024---end-------
    DECLARE sel_sys_table_cs CURSOR FROM g_sql
END FUNCTION
 
FUNCTION s_carry_col(p_zr02)
  DEFINE p_zr02               LIKE gat_file.gat01
  DEFINE l_tabid              VARCHAR(30)
  DEFINE l_colname            VARCHAR(30)
  DEFINE msb_tab_name         base.StringBuffer
  DEFINE msb_col_name         base.StringBuffer
  DEFINE lst_col_name         base.StringTokenizer
  DEFINE l_str1               STRING
  DEFINE l_str2               STRING
  DEFINE l_str3               STRING
    LET g_db_type=cl_db_get_database_type() #FUN-960132
    CASE g_db_type 
       WHEN 'IFX' 
          SELECT tabid INTO l_tabid FROM systables
           WHERE tabname=p_zr02
          LET g_showmsg = "tabname"
       WHEN 'MSV'   #FUN-960132 直接給tabname
          LET  l_tabid = p_zr02  
          LET g_showmsg = "object_id"
       WHEN 'ORA'
          LET p_zr02 = UPSHIFT(p_zr02)
          SELECT OBJECT_NAME INTO l_tabid FROM user_objects
           WHERE UPPER(object_name)=p_zr02
          LET g_showmsg = "object_name"
    END CASE #FUN-960132
    IF SQLCA.sqlcode THEN
       CALL s_errmsg(g_showmsg,p_zr02,'',SQLCA.sqlcode,1)
    END IF
 
    #組table的structure
    LET msb_tab_name = base.StringBuffer.create()
    LET msb_col_name = base.StringBuffer.create()
    LET l_str1 = ''
    LET l_str2 = ''
    LET l_str3 = ''
    FOREACH sel_sys_table_cs USING l_tabid INTO l_colname
       IF SQLCA.sqlcode THEN
          CALL s_errmsg(g_showmsg,p_zr02,'foreach',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       IF (msb_col_name.getLength() = 0) THEN
          CALL msb_col_name.append(l_colname)
          LET l_str1 = l_colname
          LET l_str2 = "?"
          LET l_str3 = l_colname,"=?"
       ELSE
          CALL msb_col_name.append("," || l_colname)
          LET l_str1 = l_str1 CLIPPED,",",l_colname
          LET l_str2 = l_str2 CLIPPED,",?"
          LET l_str3 = l_str3 CLIPPED,",",l_colname,"=?"
       END IF
    END FOREACH
    RETURN l_str1,l_str2,l_str3
END FUNCTION
 
FUNCTION s_carry_idx(p_zr02)
   DEFINE  p_zr02     LIKE gat_file.gat01
   DEFINE  l_part     RECORD
                      part01 LIKE type_file.num5,
                      part02 LIKE type_file.num5,
                      part03 LIKE type_file.num5,
                      part04 LIKE type_file.num5,
                      part05 LIKE type_file.num5,
                      part06 LIKE type_file.num5,
                      part07 LIKE type_file.num5,
                      part08 LIKE type_file.num5,
                      part09 LIKE type_file.num5,
                      part10 LIKE type_file.num5,
                      part11 LIKE type_file.num5,
                      part12 LIKE type_file.num5,
                      part13 LIKE type_file.num5,
                      part14 LIKE type_file.num5,
                      part15 LIKE type_file.num5,
                      part16 LIKE type_file.num5
                      END RECORD
   DEFINE l_i         LIKE type_file.num5
   DEFINE l_ztc04_t   LIKE type_file.chr20
   DEFINE l_gaq03     LIKE gaq_file.gaq03
   DEFINE l_idx_name  LIKE ztc_file.ztc03
   DEFINE l_part_arr  ARRAY[16] OF SMALLINT
   DEFINE l_str4      STRING
 
   CASE g_db_type
      WHEN 'IFX' 
         LET g_sql="SELECT DISTINCT idxname,part1,part2,part3,",
                   "       part4,part5,part6,part7,part8,part9,part10,",
                   "       part11,part12,part13,part14,part15,part16 ",
                   "  FROM systables a, sysindexes c ",
                   " WHERE tabname='",p_zr02 CLIPPED,"'",
                   "   AND a.tabid=c.tabid",
                   "   AND upper(idxtype)='U'"
      WHEN 'MSV'  #FUN-960132
         LET g_sql="SELECT name from sys.indexes ",
                " WHERE object_id = object_id('",p_zr02 CLIPPED,"')",
                " and is_unique=1 "  
      WHEN 'ORA'
         LET p_zr02 = UPSHIFT(p_zr02)
         LET g_sql="SELECT DISTINCT lower(index_name)",
             #  "  FROM user_indexes ",   #MOD-A80049
                "  FROM all_indexes ",    #MOD-A80049
                " WHERE upper(table_name)='",p_zr02 CLIPPED,"'",
                "   AND uniqueness='UNIQUE'"
               ,"   AND owner = 'DS'"     #MOD-A80049
   END CASE
   DECLARE p_ztc_cs CURSOR FROM g_sql
   IF sqlca.sqlcode THEN
      LET g_err="declare p_ztc_cs error(bshow):"
      CALL s_errmsg('','',g_err,SQLCA.sqlcode,1)
      RETURN
   END IF
 
   FOREACH p_ztc_cs INTO l_idx_name,l_part.*
      IF sqlca.sqlcode THEN
         LET g_err="foreach ztc data error(bshow)"
         CALL s_errmsg('','',g_err,SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET l_part_arr[1]=l_part.part01
      LET l_part_arr[2]=l_part.part02
      LET l_part_arr[3]=l_part.part03
      LET l_part_arr[4]=l_part.part04
      LET l_part_arr[5]=l_part.part05
      LET l_part_arr[6]=l_part.part06
      LET l_part_arr[7]=l_part.part07
      LET l_part_arr[8]=l_part.part08
      LET l_part_arr[9]=l_part.part09
      LET l_part_arr[10]=l_part.part10
      LET l_part_arr[11]=l_part.part11
      LET l_part_arr[12]=l_part.part12
      LET l_part_arr[13]=l_part.part13
      LET l_part_arr[14]=l_part.part14
      LET l_part_arr[15]=l_part.part15
      LET l_part_arr[16]=l_part.part16

      CASE g_db_type
         WHEN "IFX" 
            LET g_sql="SELECT colname FROM systables,syscolumns ",
                      " WHERE tabname='",p_zr02 CLIPPED,"'",
                      "   AND systables.tabid=syscolumns.tabid ",
                      " AND colno = ?"
         WHEN "MSV"  #FUN-960132
            LET g_sql= "select c.name",
                      " FROM sys.indexes i",
                      " inner join sys.index_columns ic  on ic.object_id = i.object_id and ic.index_id = i.index_id ",
                      " inner join sys.columns c on c.object_id = ic.object_id and ic.column_id = c.column_id ",
                      " where i.object_id = object_id('",p_zr02 CLIPPED,"')",
                      "   AND i.name='" ,l_idx_name CLIPPED,"'"             
         WHEN "ORA"
            #No.FUN-AC0038  --Begin
            #LET g_sql="SELECT DISTINCT lower(column_name)",      #MOD-A80049 add DISTINCT
            LET g_sql="SELECT lower(column_name)", 
            #No.FUN-AC0038  --End  
                #  "  FROM user_indexes a,user_ind_columns b",   #MOD-A80049
                   "  FROM all_indexes a,all_ind_columns b",     #MOD-A80049
                   " WHERE UPPER(a.table_name)='",p_zr02 CLIPPED,"'",
                   "   AND LOWER(a.index_name)='",l_idx_name CLIPPED,"'",
                   "   AND a.index_name=b.index_name",
                   "   AND a.owner = b.table_owner ",            #No.FUN-AC0038 add
                   "   AND a.owner = 'DS'",                      #MOD-A80048
                   " ORDER BY column_position"                   #MOD-A80049   #No.FUN-AC0038 unmark
      END CASE

      DECLARE p_ztc_cs2 CURSOR FROM g_sql

      CASE g_db_type
         WHEN "IFX" 
            FOR l_i=1 TO 16
                IF l_part_arr[l_i] IS NULL THEN EXIT FOR END IF
                FOREACH p_ztc_cs2 USING l_part_arr[l_i] INTO l_ztc04_t
                   IF sqlca.sqlcode THEN
                      LET g_err="foreach sysindexes error(bshow)"
                      CALL s_errmsg('','',g_err,SQLCA.sqlcode,1)
                      EXIT FOREACH
                   END IF
                   IF cl_null(l_str4) THEN
                      LET l_str4 = l_ztc04_t CLIPPED,"=?"
                   ELSE
                      LET l_str4 = l_str4 CLIPPED," AND ",l_ztc04_t CLIPPED,"=?"
                   END IF
                END FOREACH
            END FOR

         WHEN "MSV"
            FOREACH p_ztc_cs2 INTO l_ztc04_t
               IF SQLCA.sqlcode THEN
                  LET g_err="foreach sysindexes error(bshow)"
                  CALL s_errmsg('','',g_err,SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               IF cl_null(l_str4) THEN
                  LET l_str4 = l_ztc04_t CLIPPED,"=?"
               ELSE
                  LET l_str4 = l_str4 CLIPPED," AND ",l_ztc04_t CLIPPED,"=?"
               END IF
            END FOREACH

         WHEN "ORA"
            FOREACH p_ztc_cs2 INTO l_ztc04_t
               IF SQLCA.sqlcode THEN
                  LET g_err="foreach sysindexes error(bshow)"
                  CALL s_errmsg('','',g_err,SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               IF cl_null(l_str4) THEN
                  LET l_str4 = l_ztc04_t CLIPPED,"=?"
               ELSE
                  LET l_str4 = l_str4 CLIPPED," AND ",l_ztc04_t CLIPPED,"=?"
               END IF
            END FOREACH
      END CASE
   END FOREACH
   RETURN l_str4
END FUNCTION
 
FUNCTION s_carry_record(p_gev04,p_azp01,p_prog,p_gex05,p_gex02)
  DEFINE p_gev04   LIKE gev_file.gev04
  DEFINE p_azp01   LIKE azp_file.azp01
  DEFINE p_prog    LIKE gaz_file.gaz01
  DEFINE p_gex05   LIKE gex_file.gex05
  DEFINE p_gex02   LIKE gex_file.gex02
  DEFINE l_cnt     LIKE type_file.num10
  DEFINE l_time    LIKE type_file.chr20
 
   LET l_time = TIME
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM gex_file
    WHERE gex01 = p_gev04
      AND gex02 = p_gex02
      AND gex03 = p_azp01
      AND gex04 = p_prog
      AND gex05 = p_gex05
      AND gex07 = g_today
      AND gex08 = l_time
      AND gex09 = g_user
   IF l_cnt = 0 THEN
      INSERT INTO gex_file VALUES(p_gev04,p_gex02,p_azp01,
                  p_prog,p_gex05,1,g_today,l_time,g_user)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('gex05',p_gex05,'ins gex',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   ELSE
      UPDATE gex_file SET gex06 = l_cnt + 1
       WHERE gex01 = p_gev04
         AND gex02 = p_gex02
         AND gex03 = p_azp01
         AND gex04 = p_prog
         AND gex05 = p_gex05
         AND gex07 = g_today
         AND gex08 = l_time
         AND gex09 = g_user
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('gex05',p_gex05,'upd gex',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
END FUNCTION
 
FUNCTION s_basic_data_carry_send_mail_1(p_azp01,p_i,p_gew01,p_gew02)
 DEFINE p_azp01    LIKE azp_file.azp01
 DEFINE p_i        LIKE type_file.num5
 DEFINE p_gew01    LIKE gew_file.gew01
 DEFINE p_gew02    LIKE gew_file.gew02
 DEFINE l_gew08    LIKE gew_file.gew08
 DEFINE l_tempdir  LIKE type_file.chr20
 DEFINE lc_channel base.Channel
 DEFINE l_str      LIKE type_file.chr1000
 DEFINE l_cmd      LIKE type_file.chr1000
 DEFINE l_cmd1     LIKE type_file.chr1000
 DEFINE l_subject  LIKE type_file.chr1000
 DEFINE l_xml      LIKE ze_file.ze03
 DEFINE l_attach   LIKE ze_file.ze03
 
       #mail list
       SELECT gew08 INTO l_gew08 FROM gew_file
        WHERE gew01 = p_gew01
          AND gew02 = p_gew02
          AND gew04 = p_azp01
       IF SQLCA.sqlcode OR cl_null(l_gew08) THEN
          LET g_path[g_pi].flag   = 'N'
          LET g_path[g_pi].gew08  = NULL
          LET g_path[g_pi].xml    = NULL
          LET g_path[g_pi].attach = NULL
          RETURN
       END IF
       
       LET l_tempdir = fgl_getenv('TEMPDIR')
       
       #Subject
       LET l_cmd = g_prog CLIPPED,' ',g_today
       CALL cl_getmsg('aoo-037',g_lang) RETURNING l_cmd1
       LET l_cmd = l_cmd CLIPPED,' ',l_cmd1
       LET l_subject = l_cmd
 
       # 產生XML文本檔
       LET l_xml = l_tempdir CLIPPED,'/',g_prog CLIPPED,'-',
                   p_azp01,'-',p_i USING "<<<<<",'.htm'
 
       LET lc_channel = base.Channel.create()
       CALL lc_channel.openFile(l_xml,"w")
       CALL lc_channel.setDelimiter("")
 
       LET l_str = "<html>"
       CALL lc_channel.write(l_str)
       LET l_str = "<head>"
       CALL lc_channel.write(l_str)
 
       LET l_str = "<title>",l_subject CLIPPED,"</title>"
       CALL lc_channel.write(l_str)
       LET l_str = "</head>"
       CALL lc_channel.write(l_str)
       LET l_str = "<body>"
       CALL lc_channel.write(l_str)
 
       #本文
       LET l_str = 'Dear ALL:',"<br>"
       CALL lc_channel.write(l_str)
 
       LET l_str = ' ',"<br>"
       CALL lc_channel.write(l_str)
 
       LET l_str = p_azp01 CLIPPED,' ',cl_getmsg('aoo-038',g_lang)
       LET l_str = l_str CLIPPED,"<br>"
       CALL lc_channel.write(l_str)
 
       LET l_str = "</body>"
       CALL lc_channel.write(l_str)
       LET l_str = "</html>"
       CALL lc_channel.write(l_str)
       CALL lc_channel.close()
 
#      LET l_cmd1 = "chmod 777 ",l_xml CLIPPED           #No.FUN-9C0009
#      RUN l_cmd1                                        #No.FUN-9C0009
       IF os.Path.chrwx(l_xml CLIPPED,511) THEN END IF   #No.FUN-9C0009
 
       #抓附件
       LET l_attach = l_tempdir CLIPPED,"/",g_prog CLIPPED,"-",
                   p_azp01,"-",p_i USING "<<<<<",".txt"
      #LET l_cmd = "rm ",l_attach CLIPPED                #MOD-B50188 mark 
      #RUN l_cmd                                         #MOD-B50188 mark      

#      LET l_cmd = "cat /dev/null >",l_attach CLIPPED
#      RUN l_cmd
       CALL cl_null_cat_to_file(l_attach CLIPPED)    #FUN-9B0113

       LET l_cmd = "echo 'Data Center\tData Type\tCarry Logestic\t",
                   "Program ID\tKey Value\t",
                   "Carry Counts\tCarry Date\tCarry Time\t",
                   "Carry Person' >>",l_attach CLIPPED
       
       LET g_path[g_pi].flag   = 'Y'
       LET g_path[g_pi].gew08  = l_gew08
       LET g_path[g_pi].xml    = l_xml
       LET g_path[g_pi].attach = l_attach
      
END FUNCTION
 
FUNCTION s_basic_data_carry_send_mail_2()
 DEFINE l_cmd      LIKE type_file.chr1000
 DEFINE l_cmd1     LIKE type_file.chr1000
       
       IF g_path[g_pi].flag = 'N' THEN RETURN END IF
       IF cl_null(g_path[g_pi].gew08) THEN RETURN END IF
 
       INITIALIZE g_xml.* TO NULL
       
       #Subject
       LET l_cmd = g_prog CLIPPED,' ',g_today
       CALL cl_getmsg('aoo-037',g_lang) RETURNING l_cmd1
       LET g_xml.subject = l_cmd CLIPPED,' ',l_cmd1
 
       #抓相關應通知人員email
       LET g_xml.recipient =  g_path[g_pi].gew08
 
       IF cl_null(g_xml.recipient) THEN
          RETURN 
       END IF
 
       # 產生文本檔
       LET g_xml.body = g_path[g_pi].xml
 
       #抓附件
       LET g_xml.attach=g_path[g_pi].attach
       
       MESSAGE "Sending Mail:",g_path[g_pi].gew08
       CALL ui.Interface.refresh()
       
       DISPLAY g_xml.subject
       DISPLAY "Mail 收件人清單：" , g_xml.recipient
       CALL cl_jmail()
 
       LET l_cmd = "rm ",g_path[g_pi].xml
       RUN l_cmd
       LET l_cmd = "rm ",g_path[g_pi].attach
       RUN l_cmd
       
END FUNCTION       
 
FUNCTION s_basic_data_carry_record(p_gev04,p_azp01,p_prog,p_gex05,p_gex02,p_i)
  DEFINE p_gev04   LIKE gev_file.gev04
  DEFINE p_azp01   LIKE azp_file.azp01
  DEFINE p_prog    LIKE gaz_file.gaz01
  DEFINE p_gex05   LIKE gex_file.gex05
  DEFINE p_gex02   LIKE gex_file.gex02
  DEFINE p_i       LIKE type_file.num5 
  DEFINE l_cnt     LIKE type_file.num10
  DEFINE l_time    LIKE type_file.chr20
  DEFINE l_cmd     LIKE type_file.chr1000
 
   LET l_time = TIME
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM gex_file
    WHERE gex01 = p_gev04
      AND gex02 = p_gex02
      AND gex03 = p_azp01
      AND gex04 = p_prog
      AND gex05 = p_gex05
      AND gex07 = g_today
      AND gex08 = l_time
      AND gex09 = g_user
   IF l_cnt = 0 THEN
      INSERT INTO gex_file VALUES(p_gev04,p_gex02,p_azp01,
                  p_prog,p_gex05,1,g_today,l_time,g_user)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('gex05',p_gex05,'ins gex',SQLCA.sqlcode,1)
      END IF
      IF g_path[p_i].flag = 'Y' THEN
         LET l_cmd = "echo ",p_gev04 CLIPPED,"\t",p_gex02 CLIPPED,"\t",
                             p_azp01 CLIPPED,"\t",p_prog CLIPPED,"\t",
                             p_gex05 CLIPPED,"\t1\t",
                             g_today,"\t",TIME,"\t",
                      g_user CLIPPED," >>",g_path[p_i].attach
         RUN l_cmd
      END IF
   ELSE
      UPDATE gex_file SET gex06 = l_cnt + 1
       WHERE gex01 = p_gev04
         AND gex02 = p_gex02
         AND gex03 = p_azp01
         AND gex04 = p_prog
         AND gex05 = p_gex05
         AND gex07 = g_today
         AND gex08 = l_time
         AND gex09 = g_user
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('gex05',p_gex05,'upd gex',SQLCA.sqlcode,1)
      END IF
      IF g_path[p_i].flag = 'Y' THEN
         LET l_cmd = "echo ",p_gev04 CLIPPED,"\t",p_gex02 CLIPPED,"\t",
                             p_azp01 CLIPPED,"\t",p_prog CLIPPED,"\t",
                             p_gex05 CLIPPED,"\t",l_cnt+1 USING "<<<<&","\t",
                             g_today,"\t",TIME,"\t",
                      g_user CLIPPED," >>",g_path[p_i].attach
         RUN l_cmd
      END IF
   END IF
END FUNCTION
#FUN-BC0135
