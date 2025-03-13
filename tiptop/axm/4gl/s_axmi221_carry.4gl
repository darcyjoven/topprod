# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Program name...: s_axmi221_carry.4gl
# Descriptions...: 價格表資料整批拋轉
# Date & Author..: 08/02/21 By Carrier FUN-7C0010
# Usage..........: CALL s_axmi221_carry_occ(p_occ,p_azp,p_gev04)
# Usage..........: CALL s_axmi221_carry_tqo(p_tqo,p_azp,p_gev04)
# Input PARAMETER: p_occ    拋轉TABLE LIST (DYNAMIC ARRAY)
#                  p_azp    拋轉至DB 清單 (DYNAMIC ARRAY)
#                  p_gev04  資料中心代碼
# Modify.........: No.TQC-830033 08/03/21 By Sunyanchun 拋轉記錄中拋轉日期中時、分、秒顯示不正確
# Modify.........: FUN-830090 08/03/24 By Carrier add upload logical
# Modify.........: NO.FUN-840018 08/04/03 BY Yiting axmi250納入aooi602規則處理(營運中心/拋轉通知人)
# Modify.........: No.MOD-840117 08/04/15 By claire 拋轉資料時,若沒選擇DB不應更新單據為已拋轉
# Modify.........: NO.FUN-840033 08/04/17 BY yiting 拋轉成功才發郵件通知
# Modify.........: no.FUN-840090 08/04/20 by yiting 依gew03設定拋.
# Modify.........: No.MOD-840200 08/04/21 By Carrier 修改拋轉DB INPUT功能
# Modify.........: No.MOD-840392 08/04/21 By Carrier 申請作業拋轉時加入'資料來源'的值
# Modify.........: NO.MOD-840158 08/04/22 BY yiting 開窗時cl_ui_init檔名錯誤 
# Modify.........: No.CHI-870044 08/08/01 By Smapmin 資料拋轉不應只限20個DB
# Modify.........: No.FUN-910093 09/01/19 By jan 未經申請作業新增之客戶也可做修改之拋轉
# Modify.........: No.CHI-950007 09/05/15 By Carrier EXECUTE后接prepare_id,非cursor_id
# Modify.........: No.MOD-960140 09/07/07 By Smapmin 客戶申請選擇修改時會判斷無前申請單而無法選擇拋轉營運中心
# Modify.........: No.TQC-970389 09/07/29 By dxfwo  s_axmi221_carry.4gl 里面有些程序代碼 
#                  尚未轉成 用s_dbstring()的方式
#                  例如: 2344行: LET g_sql='INSERT INTO ',tm[i].azp03 CLIPPED,':occ_file(',
# Modify.........: No.TQC-980148 09/08/20 By sherry 拋轉不成功時，增加報錯信息      
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-9A0092 09/10/30 By baofei GP5.2資料中心修改 
# Modify.........: No:MOD-9B0035 09/11/05 By Smapmin 將多餘的message拿掉
# Modify.........: No:FUN-9C0072 09/12/16 By vealxu 精簡程式碼
# Modify.........: No.FUN-A10036 10/01/13 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No:MOD-A20085 10/02/23 By Smapmin 信用資料拋轉功能，只會更新額度金額及可超出率，應該是信用資料那個page的資料都要update
# Modify.........: No:FUN-A30110 10/04/12 By Carrier 客户/厂商简称修改
# Modify.........: No.TQC-A40128 10/06/07 By Cockroach 拋轉增加流通新增不可為空或默認值字段occ71,occpos
# Modify.........: No.FUN-A50102 10/07/26 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:CHI-A60011 10/07/26 By Summer 在拋轉資料前,將該Lock的Table都先做Lock,確定資料沒被其他人Lock住才能做拋轉
# Modify.........: NO.CHI-A60035 10/07/27 by Summer gew03 = '1'時,確認時自動拋轉
# Modify.........: No:MOD-A50071 10/07/30 By Smapmin MOD-840117
# Modify.........: No:FUN-A80036 10/09/28 By Carrier 资料抛转时,使用的中间表变成动态表名
# Modify.........: No:CHI-A80050 10/11/12 By Summer 開放axmi250其他欄位的修改,如同axmi221
# Modify.........: No:TQC-A90092 10/11/15 By Carrier 正式区ins_occ时漏了occ1015,重新过单
# Modify.........: No:FUN-B30044 11/04/22 By suncx 新增欄位"慣用訂金收款條件(occa68)"、"慣用尾款收款條件(occa69)"
# Modify.........: No:FUN-B40071 11/05/09 by jason 已傳POS否狀態調整
# Modify.........: No:MOD-B70276 11/07/29 By suncx 審核前檢查報錯沒有RETURN任然繼續審核BUG
# Modify.........: No:TQC-BB0002 11/01/01 By Carrier MISC/EMPL简称修改时,不进行各资料档案的UPDATE
# Modify.........: No:FUN-BB0049 11/11/21 By Carrier aza125='Y'&厂商及客户编号相同时,简称需保持相同,若为'N',则不需有此管控
#                                                    aza126='Y'&厂商客户简称修改后,需更新历史资料
# Modify.........: No:MOD-C50098 12/05/15 By SunLM 根據aooi602中"更新存在資料"gew07這個字段的設置,應該允許沒有拋轉過的營運中心繼續拋轉
# Modify.........: No:TQC-C50259 12/05/31 By zhuhao 資料拋轉後提示中文信息
# Modify.........: No:CHI-CB0017 12/12/05 By Lori 資料拋轉新增s_data_transfer拋相關文件
# Modify.........: No:MOD-CC0094 13/01/31 By jt_chen 移除營業執照有效日期相關欄位(occ1001/occ1002;occa1001/occa1002)

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../sub/4gl/s_data_center.global"   #No.FUN-7C0010
 
DEFINE g_occ_1              DYNAMIC ARRAY OF RECORD
                            sel      LIKE type_file.chr1,
                            occ01    LIKE occ_file.occ01
                            END RECORD
DEFINE g_tqo_1              DYNAMIC ARRAY OF RECORD
                            sel      LIKE type_file.chr1,
                            tqo01    LIKE tqo_file.tqo01,
                            tqo02    LIKE tqo_file.tqo02
                            END RECORD
DEFINE tm         DYNAMIC ARRAY of RECORD        #CHI-870044                           
                  sel      LIKE type_file.chr1,    #No.FUN-680137 CHAR
                  azp01    LIKE azp_file.azp01,                       
                  azp02    LIKE azp_file.azp02,                       
                  azp03    LIKE azp_file.azp03,                       
                  plant    LIKE type_file.chr1000, #FUN-9A0092
                  exist    LIKE type_file.chr1     #TQC-740090 add    
                  END RECORD 
DEFINE g_rec_b1             LIKE type_file.num10
DEFINE g_occ                RECORD LIKE occ_file.*
DEFINE g_occg               RECORD LIKE occg_file.*
DEFINE g_ocd                RECORD LIKE ocd_file.*
DEFINE g_oce                RECORD LIKE oce_file.*
DEFINE g_oci                RECORD LIKE oci_file.*
DEFINE g_ocj                RECORD LIKE ocj_file.*
DEFINE g_tql                RECORD LIKE tql_file.*
DEFINE g_tqk                RECORD LIKE tqk_file.*
DEFINE g_tqo                RECORD LIKE tqo_file.*
DEFINE g_tqm                RECORD LIKE tqm_file.*
DEFINE g_tqn                RECORD LIKE tqn_file.*
DEFINE g_pov                RECORD LIKE pov_file.*
DEFINE g_occa               RECORD LIKE occa_file.*
DEFINE g_gev04              LIKE gev_file.gev04
DEFINE g_flag               LIKE type_file.chr1
DEFINE g_flag1              LIKE type_file.chr1
DEFINE g_msg                LIKE type_file.chr1000
DEFINE g_msg1               LIKE type_file.chr1000
DEFINE g_msg2               LIKE type_file.chr1000
DEFINE g_msg3               LIKE type_file.chr1000
DEFINE g_msg4               LIKE type_file.chr1000
DEFINE g_msg_x              LIKE type_file.chr1000
DEFINE g_err                LIKE type_file.chr1000
DEFINE g_sql                STRING
DEFINE g_db_type            LIKE type_file.chr3
DEFINE g_str1               STRING
DEFINE g_str2               STRING
DEFINE g_str3               STRING
DEFINE g_str4               STRING
DEFINE g_str1_occg          STRING
DEFINE g_str2_occg          STRING
DEFINE g_str3_occg          STRING
DEFINE g_str4_occg          STRING
DEFINE g_str1_ocd           STRING
DEFINE g_str2_ocd           STRING
DEFINE g_str3_ocd           STRING
DEFINE g_str4_ocd           STRING
DEFINE g_str1_oce           STRING
DEFINE g_str2_oce           STRING
DEFINE g_str3_oce           STRING
DEFINE g_str4_oce           STRING
DEFINE g_str1_oci           STRING
DEFINE g_str2_oci           STRING
DEFINE g_str3_oci           STRING
DEFINE g_str4_oci           STRING
DEFINE g_str1_ocj           STRING
DEFINE g_str2_ocj           STRING
DEFINE g_str3_ocj           STRING
DEFINE g_str4_ocj           STRING
DEFINE g_str1_tql           STRING
DEFINE g_str2_tql           STRING
DEFINE g_str3_tql           STRING
DEFINE g_str4_tql           STRING
DEFINE g_str1_tqk           STRING
DEFINE g_str2_tqk           STRING
DEFINE g_str3_tqk           STRING
DEFINE g_str4_tqk           STRING
DEFINE g_str1_tqo           STRING
DEFINE g_str2_tqo           STRING
DEFINE g_str3_tqo           STRING
DEFINE g_str4_tqo           STRING
DEFINE g_str1_tqm           STRING
DEFINE g_str2_tqm           STRING
DEFINE g_str3_tqm           STRING
DEFINE g_str4_tqm           STRING
DEFINE g_str1_tqn           STRING
DEFINE g_str2_tqn           STRING
DEFINE g_str3_tqn           STRING
DEFINE g_str4_tqn           STRING
DEFINE g_str1_pov           STRING
DEFINE g_str2_pov           STRING
DEFINE g_str3_pov           STRING
DEFINE g_str4_pov           STRING
DEFINE g_all_cnt            LIKE type_file.num10    #總共要拋轉的筆數
DEFINE g_cur_cnt            LIKE type_file.num10    #當前營運中心滿足拋轉條件的筆數
DEFINE g_tqm_all_cnt        LIKE type_file.num10    #總共要拋轉的筆數
DEFINE g_tqm_cur_cnt        LIKE type_file.num10    #當前營運中心滿足拋轉條件的筆數
DEFINE g_flagx              LIKE type_file.chr1     #No.FUN-830090
DEFINE g_forupd_sql      STRING           #SELECT ... FOR UPDATE NOWAIT SQL #CHI-A60011 add
DEFINE l_hist_tab        LIKE type_file.chr50    #for mail   #CHI-A60011 add
 
#FUNCTION i221_ins_upd_occ_body(p_dbs_sep)
FUNCTION i221_ins_upd_occ_body(p_plant_sep)  #FUN-A50102
   #DEFINE p_dbs_sep            LIKE type_file.chr50
   DEFINE p_plant_sep           LIKE type_file.chr21  #FUN-A50102
 
   IF g_flag = '2' THEN
      #LET g_sql = "UPDATE ",p_dbs_sep CLIPPED,"occ_file",
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant_sep,'occ_file'), #FUN-A50102
                  "   SET occ246 = ? ,",
                  "       occ248 = ? ,",
                  #-----MOD-A20085---------
                  "       occ62  = ? ,",
                  "       occ33  = ? ,",
                  "       occ61  = ? ,",
                  "       occ36  = ? ,",
                  "       occ175 = ? ,",
                  "       occ631 = ? ,",
                  #-----END MOD-A20085-----
                  "       occ63  = ? ,",
                  "       occ64  = ?  ",
                  " WHERE occ01  = ?  "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_credit_upd_cs FROM g_sql
      #CHI-A60011 add --start--
      LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(p_plant_sep,'occ_file'),
                         " WHERE occ01=? FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
      CALL cl_parse_qry_sql(g_forupd_sql,p_plant_sep) RETURNING g_forupd_sql
      DECLARE db_cs2_credit_lock CURSOR FROM g_forupd_sql
      #CHI-A60011 add --end--
 
   END IF
   IF g_flag <> '2' THEN
      #LET g_sql = "INSERT INTO ",p_dbs_sep CLIPPED,"occ_file",
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant_sep,'occ_file'), #FUN-A50102
                  " VALUES(",g_str2,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_cs1 FROM g_sql
 
      #LET g_sql = "UPDATE ",p_dbs_sep CLIPPED,"occ_file",
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant_sep,'occ_file'), #FUN-A50102
                  "   SET ",g_str3,
                  " WHERE ",g_str4
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_cs2 FROM g_sql
      #CHI-A60011 add --start--
      LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(p_plant_sep,'occ_file'),
                         " WHERE ",g_str4," FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
      CALL cl_parse_qry_sql(g_forupd_sql,p_plant_sep) RETURNING g_forupd_sql
      DECLARE db_cs2_occ_lock CURSOR FROM g_forupd_sql
      #CHI-A60011 add --end--
 
      #LET g_sql = "UPDATE ",p_dbs_sep CLIPPED,"occ_file",
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant_sep,'occ_file'), #FUN-A50102
                  "   SET occ248 = ? ",
                  " WHERE ",g_str4
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_cs3 FROM g_sql
 
      #LET g_sql = "UPDATE ",p_dbs_sep CLIPPED,"occ_file",
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant_sep,'occ_file'), #FUN-A50102
                  "   SET occ16 = '',",
                  "       occ171= '',",
                  "       occ172= '',",
                  "       occ173= '',",
                  "       occ174= '' ",
                  " WHERE ",g_str4
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_cs4 FROM g_sql
 
      #LET g_sql = "SELECT * FROM ",p_dbs_sep CLIPPED,"occ_file",
      LET g_sql = "SELECT * FROM ",cl_get_target_table(p_plant_sep,'occ_file'), #FUN-A50102
                  " WHERE ",g_str4
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_cs5 FROM g_sql
 
      #LET g_sql = "INSERT INTO ",p_dbs_sep CLIPPED,"occg_file",
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant_sep,'occg_file'), #FUN-A50102
                  " VALUES(",g_str2_occg,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_occg1 FROM g_sql
      #LET g_sql = "UPDATE ",p_dbs_sep CLIPPED,"occg_file",
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant_sep,'occg_file'), #FUN-A50102
                  "   SET ",g_str3_occg,
                  " WHERE ",g_str4_occg
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_occg2 FROM g_sql
      #CHI-A60011 add --start--
      LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(p_plant_sep,'occg_file'),
                         " WHERE ",g_str4_occg," FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
      CALL cl_parse_qry_sql(g_forupd_sql,p_plant_sep) RETURNING g_forupd_sql
      DECLARE db_cs2_occg_lock CURSOR FROM g_forupd_sql
      #CHI-A60011 add --end--
 
      #LET g_sql = "INSERT INTO ",p_dbs_sep CLIPPED,"ocd_file",
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant_sep,'ocd_file'), #FUN-A50102
                  " VALUES(",g_str2_ocd,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_ocd1 FROM g_sql
      #LET g_sql = "UPDATE ",p_dbs_sep CLIPPED,"ocd_file",
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant_sep,'ocd_file'), #FUN-A50102
                  "   SET ",g_str3_ocd,
                  " WHERE ",g_str4_ocd
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_ocd2 FROM g_sql
      #CHI-A60011 add --start--
      LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(p_plant_sep,'ocd_file'),
                         " WHERE ",g_str4_ocd," FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
      CALL cl_parse_qry_sql(g_forupd_sql,p_plant_sep) RETURNING g_forupd_sql
      DECLARE db_cs2_ocd_lock CURSOR FROM g_forupd_sql
      #CHI-A60011 add --end--
 
      #LET g_sql = "INSERT INTO ",p_dbs_sep CLIPPED,"oce_file",
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant_sep,'oce_file'), #FUN-A50102
                  " VALUES(",g_str2_oce,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_oce1 FROM g_sql
      #LET g_sql = "UPDATE ",p_dbs_sep CLIPPED,"oce_file",
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant_sep,'oce_file'), #FUN-A50102
                  "   SET ",g_str3_oce,
                  " WHERE ",g_str4_oce
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_oce2 FROM g_sql
      #CHI-A60011 add --start--
      LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(p_plant_sep,'oce_file'),
                         " WHERE ",g_str4_oce," FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
      CALL cl_parse_qry_sql(g_forupd_sql,p_plant_sep) RETURNING g_forupd_sql
      DECLARE db_cs2_oce_lock CURSOR FROM g_forupd_sql
      #CHI-A60011 add --end--
 
      #LET g_sql = "INSERT INTO ",p_dbs_sep CLIPPED,"oci_file",
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant_sep,'oci_file'), #FUN-A50102
                  " VALUES(",g_str2_oci,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_oci1 FROM g_sql
      #LET g_sql = "UPDATE ",p_dbs_sep CLIPPED,"oci_file",
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant_sep,'oci_file'), #FUN-A50102
                  "   SET ",g_str3_oci,
                  " WHERE ",g_str4_oci
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_oci2 FROM g_sql
      #CHI-A60011 add --start--
      LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(p_plant_sep,'oci_file'),
                         " WHERE ",g_str4_oci," FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
      CALL cl_parse_qry_sql(g_forupd_sql,p_plant_sep) RETURNING g_forupd_sql
      DECLARE db_cs2_oci_lock CURSOR FROM g_forupd_sql
      #CHI-A60011 add --end--
 
      #LET g_sql = "INSERT INTO ",p_dbs_sep CLIPPED,"ocj_file",
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant_sep,'ocj_file'), #FUN-A50102
                  " VALUES(",g_str2_ocj,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_ocj1 FROM g_sql
      #LET g_sql = "UPDATE ",p_dbs_sep CLIPPED,"ocj_file",
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant_sep,'ocj_file'), #FUN-A50102
                  "   SET ",g_str3_ocj,
                  " WHERE ",g_str4_ocj
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_ocj2 FROM g_sql
      #CHI-A60011 add --start--
      LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(p_plant_sep,'ocj_file'),
                         " WHERE ",g_str4_ocj," FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
      CALL cl_parse_qry_sql(g_forupd_sql,p_plant_sep) RETURNING g_forupd_sql
      DECLARE db_cs2_ocj_lock CURSOR FROM g_forupd_sql
      #CHI-A60011 add --end--
 
      #LET g_sql = "INSERT INTO ",p_dbs_sep CLIPPED,"tql_file",
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant_sep,'tql_file'), #FUN-A50102
                  " VALUES(",g_str2_tql,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_tql1 FROM g_sql
      #LET g_sql = "UPDATE ",p_dbs_sep CLIPPED,"tql_file",
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant_sep,'tql_file'), #FUN-A50102
                  "   SET ",g_str3_tql,
                  " WHERE ",g_str4_tql
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_tql2 FROM g_sql
      #CHI-A60011 add --start--
      LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(p_plant_sep,'tql_file'),
                         " WHERE ",g_str4_tql," FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
      CALL cl_parse_qry_sql(g_forupd_sql,p_plant_sep) RETURNING g_forupd_sql
      DECLARE db_cs2_tql_lock CURSOR FROM g_forupd_sql
      #CHI-A60011 add --end--
 
      #LET g_sql = "INSERT INTO ",p_dbs_sep CLIPPED,"tqk_file",
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant_sep,'tqk_file'), #FUN-A50102
                  " VALUES(",g_str2_tqk,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_tqk1 FROM g_sql
      #LET g_sql = "UPDATE ",p_dbs_sep CLIPPED,"tqk_file",
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant_sep,'tqk_file'), #FUN-A50102
                  "   SET ",g_str3_tqk,
                  " WHERE ",g_str4_tqk
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_tqk2 FROM g_sql
      #CHI-A60011 add --start--
      LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(p_plant_sep,'tqk_file'),
                         " WHERE ",g_str4_tqk," FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
      CALL cl_parse_qry_sql(g_forupd_sql,p_plant_sep) RETURNING g_forupd_sql
      DECLARE db_cs2_tqk_lock CURSOR FROM g_forupd_sql
      #CHI-A60011 add --end--
 
      #LET g_sql = "INSERT INTO ",p_dbs_sep CLIPPED,"pov_file",
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant_sep,'pov_file'), #FUN-A50102
                  " VALUES(",g_str2_pov,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_pov1 FROM g_sql
      #LET g_sql = "UPDATE ",p_dbs_sep CLIPPED,"pov_file",
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant_sep,'pov_file'), #FUN-A50102
                  "   SET ",g_str3_pov,
                  " WHERE ",g_str4_pov
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_pov2 FROM g_sql
      #CHI-A60011 add --start--
      LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(p_plant_sep,'pov_file'),
                         " WHERE ",g_str4_pov," FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
      CALL cl_parse_qry_sql(g_forupd_sql,p_plant_sep) RETURNING g_forupd_sql
      DECLARE db_cs2_pov_lock CURSOR FROM g_forupd_sql
      #CHI-A60011 add --end--
   END IF
END FUNCTION
 
#FUNCTION i221_ins_upd_tqo_body(p_dbs_sep)
FUNCTION i221_ins_upd_tqo_body(p_plant_sep)  #FUN-A50102
   #DEFINE p_dbs_sep            LIKE type_file.chr50
   DEFINE p_plant_sep           LIKE type_file.chr21  #FUN-A50102
 
   IF g_flag <> '2' THEN
      #LET g_sql = "INSERT INTO ",p_dbs_sep CLIPPED,"tqo_file",
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant_sep,'tqo_file'), #FUN-A50102
                  " VALUES(",g_str2_tqo,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_tqo1 FROM g_sql
      #LET g_sql = "UPDATE ",p_dbs_sep CLIPPED,"tqo_file",
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant_sep,'tqo_file'), #FUN-A50102
                  "   SET ",g_str3_tqo,
                  " WHERE ",g_str4_tqo
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_tqo2 FROM g_sql
      #CHI-A60011 add --start--
      LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(p_plant_sep,'tqo_file'),
                         " WHERE ",g_str4_tqo," FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
      CALL cl_parse_qry_sql(g_forupd_sql,p_plant_sep) RETURNING g_forupd_sql
      DECLARE db_cs2_tqo_lock CURSOR FROM g_forupd_sql
      #CHI-A60011 add --end--
 
      #LET g_sql = "INSERT INTO ",p_dbs_sep CLIPPED,"tqm_file",
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant_sep,'tqm_file'), #FUN-A50102
                  " VALUES(",g_str2_tqm,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_tqm1 FROM g_sql
      #LET g_sql = "UPDATE ",p_dbs_sep CLIPPED,"tqm_file",
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant_sep,'tqm_file'), #FUN-A50102
                  "   SET ",g_str3_tqm,
                  " WHERE ",g_str4_tqm
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_tqm2 FROM g_sql
      #CHI-A60011 add --start--
      LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(p_plant_sep,'tqm_file'),
                         " WHERE ",g_str4_tqm," FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
      CALL cl_parse_qry_sql(g_forupd_sql,p_plant_sep) RETURNING g_forupd_sql
      DECLARE db_cs2_tqm_lock CURSOR FROM g_forupd_sql
      #CHI-A60011 add --end--
 
      #LET g_sql = "INSERT INTO ",p_dbs_sep CLIPPED,"tqn_file",
      LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant_sep,'tqn_file'), #FUN-A50102
                  " VALUES(",g_str2_tqn,")"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_tqn1 FROM g_sql
      #LET g_sql = "UPDATE ",p_dbs_sep CLIPPED,"tqn_file",
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant_sep,'tqn_file'), #FUN-A50102
                  "   SET ",g_str3_tqn,
                  " WHERE ",g_str4_tqn
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
      PREPARE db_tqn2 FROM g_sql
      #CHI-A60011 add --start--
      LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(p_plant_sep,'tqn_file'),
                         " WHERE ",g_str4_tqn," FOR UPDATE"
      LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
      CALL cl_replace_sqldb(g_forupd_sql) RETURNING g_forupd_sql
      CALL cl_parse_qry_sql(g_forupd_sql,p_plant_sep) RETURNING g_forupd_sql
      DECLARE db_cs2_tqn_lock CURSOR FROM g_forupd_sql
      #CHI-A60011 add --end--
   END IF
END FUNCTION
 
##################################################
# Descriptions...: 價格表資料整批拋轉
# Date & Author..: 08/02/21 By Carrier FUN-7C0010
# Input PARAMETER: p_occ    拋轉TABLE LIST (DYNAMIC ARRAY)
#                  p_azp    拋轉至DB 清單 (DYNAMIC ARRAY)
#                  p_gev04  資料中心代碼
#                  p_flag   '1' 客戶資料拋轉cust_carry
#                           '0' 客戶信用資料拋轉credit_carry
##################################################
FUNCTION s_axmi221_carry_occ(p_occ,p_azp,p_gev04,p_flag,p_flagx)  #No.FUN-830090
   DEFINE p_occ                DYNAMIC ARRAY OF RECORD
                               sel      LIKE type_file.chr1,
                               occ01    LIKE occ_file.occ01
                               END RECORD
   DEFINE p_azp                DYNAMIC ARRAY OF RECORD
                               sel      LIKE type_file.chr1,
                               azp01    LIKE azp_file.azp01,
                               azp02    LIKE azp_file.azp02,
                               azp03    LIKE azp_file.azp03
                               END RECORD
   DEFINE p_gev04              LIKE gev_file.gev04
   DEFINE p_flag               LIKE type_file.chr1
   DEFINE p_flagx              LIKE type_file.chr1    #No.FUN-830090
   DEFINE l_occ                RECORD LIKE occ_file.*
   DEFINE l_i                  LIKE type_file.num10
   DEFINE l_j                  LIKE type_file.num10
   DEFINE l_occ01              LIKE occ_file.occ01
   DEFINE l_occ01_old          LIKE occ_file.occ01
   DEFINE l_occ03              LIKE occ_file.occ03
   DEFINE l_gew05              LIKE gew_file.gew05
   DEFINE l_gew07              LIKE gew_file.gew07
   DEFINE l_dbs_sep            LIKE type_file.chr50
   DEFINE l_gez04              LIKE gez_file.gez04
   DEFINE l_gez05              LIKE gez_file.gez05
   DEFINE l_tabname            LIKE type_file.chr50
   DEFINE l_tabname1           LIKE type_file.chr50
   DEFINE m_gew05              LIKE gew_file.gew05
   DEFINE m_gew07              LIKE gew_file.gew07
   DEFINE m_tqm01              LIKE tqm_file.tqm01
   DEFINE m_tqm06              LIKE tqm_file.tqm06
   DEFINE l_gew08              LIKE gew_file.gew08     #for mail
  #DEFINE l_hist_tab           LIKE type_file.chr50    #for mail #CHI-A60011 mark
   DEFINE l_hs_flag            LIKE type_file.chr1     #for mail
   DEFINE l_hs_path            LIKE ze_file.ze03       #for mail
   DEFINE l_occ_upd            LIKE type_file.chr1     #no.FUN-840068 add
   DEFINE l_occ_2              RECORD LIKE occ_file.*  #CHI-A60011 add
   DEFINE l_value1             LIKE type_file.chr30   #CHI-CB0017 add
   DEFINE l_value2             LIKE type_file.chr30   #CHI-CB0017 add
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_flagx = p_flagx     #No.FUN-830090  0.carry  1.upload
 
   IF g_flagx <> '1' THEN
      IF p_occ.getLength() = 0 THEN RETURN END IF
   END IF
 
   IF p_azp.getLength() = 0 THEN                                                                                                    
      CALL cl_err('','aoo-068',0)                                                                                                   
      RETURN                                                                                                                        
   END IF                                                                                                                           
   CALL g_occ_1.clear()
 
   #前置准備
   FOR l_i = 1 TO p_occ.getLength()
       LET g_occ_1[l_i].* = p_occ[l_i].*
   END FOR
   FOR l_i = 1 TO p_azp.getLength()
       LET g_azp[l_i].* = p_azp[l_i].*
   END FOR
   LET g_gev04 = p_gev04
   LET g_flag = p_flag
   LET g_db_type=cl_db_get_database_type()
 
   #定義cursor
   CALL s_carry_p_cs()
   #取出10個table insert/update時的columns
   CALL i221_get_column()
   #建立臨時表,用于存放拋轉的資料
   CALL s_axmi221_carry_p1() RETURNING l_tabname
   IF g_all_cnt = 0 THEN
      CALL cl_err('','aap-129',1)
      RETURN
   END IF
 
   #建立歷史資料拋轉的臨時表
   CALL s_dc_cre_temp_table("gex_file") RETURNING l_hist_tab
 
   IF g_flag <> '2' THEN
      #default aooi602中設置的預設值
      LET g_sql = " SELECT gez04,gez05 FROM gez_file ",
                  "  WHERE gez01 = '",g_gev04 CLIPPED,"'",
                  "    AND gez02 = '4'",
                  "    AND gez03 = ?  "
      PREPARE gez_p FROM g_sql
      DECLARE gez_cur CURSOR WITH HOLD FOR gez_p
 
      CALL i221_tqm_gez()
      CALL i221_get_tqo_column()
      CALL s_axmi221_tqm_carry_p1('occ') RETURNING l_tabname1
      #occ對應單身occg_file拋轉的cursor定義
      CALL i221_occ_body()
      CALL i221_tqo_body()
 
   END IF
 
   FOR l_j = 1 TO g_azp.getLength()
       IF cl_null(g_azp[l_j].azp03) THEN CONTINUE FOR END IF
       IF g_azp[l_j].sel = 'N' THEN CONTINUE FOR END IF
 
       SELECT gew05,gew07,gew08 INTO l_gew05,l_gew07,l_gew08 FROM gew_file
        WHERE gew01 = g_gev04
          AND gew02 = '4'
          AND gew04 = g_azp[l_j].azp01
       IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF
 
       #mail_1
       CALL s_dc_carry_send_mail_1(g_azp[l_j].azp01,l_j,g_gev04,'4',l_hist_tab)
            RETURNING l_hs_flag,l_hs_path
 
       CALL s_dbstring(g_azp[l_j].azp03) RETURNING l_dbs_sep
       #CALL i221_ins_upd_occ_body(l_dbs_sep)
       CALL i221_ins_upd_occ_body(g_azp[l_j].azp01)  #FUN-A50102
 
       IF g_flag <> '2' THEN
          #CALL i221_ins_upd_tqo_body(l_dbs_sep)
          CALL i221_ins_upd_tqo_body(g_azp[l_j].azp01)  #FUN-A50102
          #default aooi602中設置的預設值
          LET l_occ01 = NULL
          LET l_occ03 = NULL
          FOREACH gez_cur USING g_azp[l_j].azp01 INTO l_gez04,l_gez05
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('gez03',g_azp[l_j].azp01,'foreach',SQLCA.sqlcode,1)
                CONTINUE FOREACH
             END IF
             IF l_gez04 = 'occ01'  THEN LET l_occ01  = l_gez05 END IF
             IF l_gez04 = 'occ03'  THEN LET l_occ03  = l_gez05 END IF
          END FOREACH
 
          #tqm/tqn相關內容
          CALL i221_tqm_part1(g_azp[l_j].azp01) RETURNING m_gew05,m_gew07,m_tqm01,m_tqm06
       END IF
 
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
 
       LET l_occ_upd = 'N'     #No.FUN-A80036
       FOREACH carry_cur1 INTO g_occ.*
           IF SQLCA.sqlcode THEN
              CALL s_errmsg('occ01',g_occ.occ01,'foreach',SQLCA.sqlcode,1)
              CONTINUE FOREACH
           END IF
           IF g_occ.occacti <> 'Y' THEN
              IF l_j = 1 THEN
                 LET g_showmsg = g_plant,":",g_occ.occ01
                 CALL s_errmsg('azp01,occ01',g_showmsg,'occacti','aoo-090',1)
              END IF
              CONTINUE FOREACH
           END IF
           LET g_success = 'Y'
           #LET l_occ_upd = 'N'   #NO.FUN-840068 add   #No.FUN-A80036
 
           BEGIN WORK
           LET g_msg1 = 'ins ',g_azp[l_j].azp03 CLIPPED,':',g_occ.occ01,':'
           LET g_msg2 = 'upd ',g_azp[l_j].azp03 CLIPPED,':',g_occ.occ01,':'
 
           LET l_occ01_old = g_occ.occ01
           IF g_flag <> '2' THEN
              IF NOT cl_null(l_occ01) THEN LET g_occ.occ01 = l_occ01 END IF
              IF NOT cl_null(l_occ03) THEN LET g_occ.occ03 = l_occ03 END IF
 
              #occ246,occ247
              LET g_occ.occ246 = g_plant
              LET g_occ.occ247 = 1
              LET g_occ.occ248 = 0
              EXECUTE db_cs1 USING g_occ.*
              IF SQLCA.sqlcode = 0 THEN
                 #CHI-A60011 add --start--
                 OPEN db_cs2_occ_lock USING g_occ.occ01
                 IF STATUS THEN
                    LET g_msg_x = g_azp[l_j].azp01,':occ_file:lock'
                    CALL s_errmsg('occ01',g_occ.occ01,g_msg_x,STATUS,1)
                    MESSAGE g_msg2,':fail'
                    CALL ui.Interface.refresh()
                    CLOSE db_cs2_occ_lock
                    LET g_success = 'N'
                    #LET l_occ_upd = 'N'   #No.FUN-A80036
                    EXIT FOREACH
                 END IF
                 FETCH db_cs2_occ_lock INTO l_occ_2.* 
                 IF SQLCA.SQLCODE THEN
                    LET g_msg_x = g_azp[l_j].azp01,':occ_file:lock'
                    CALL s_errmsg('occ01',g_occ.occ01,g_msg_x,SQLCA.SQLCODE,1)
                    MESSAGE g_msg2,':fail'
                    CALL ui.Interface.refresh()
                    CLOSE db_cs2_occ_lock
                    LET g_success = 'N'
                    #LET l_occ_upd = 'N'   #No.FUN-A80036
                    EXIT FOREACH
                 END IF
                 #CHI-A60011 add --end--
                 EXECUTE db_cs4 USING g_occ.occ01
                 IF SQLCA.sqlcode THEN
                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                    CALL s_errmsg('occ01',g_occ.occ01,g_msg_x,SQLCA.sqlcode,1)
                    MESSAGE g_msg2,':fail'
                    CALL ui.Interface.refresh()
                    LET g_success = 'N'
                 ELSE
                    MESSAGE g_msg1,':ok'
                    CALL ui.Interface.refresh()
                    CALL s_upd_abbr(g_occ.occ01,g_occ.occ02,g_azp[l_j].azp01,'2','Y','a')  #No.FUN-BB0049
                 END IF
                 CLOSE db_cs2_occ_lock  #CHI-A60011 add
              ELSE
                 #IF SQLCA.sqlcode = -239 THEN #CHI-A60011 mark
                 IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #CHI-A60011
                    IF l_gew07 = 'N' THEN
                       MESSAGE g_msg1,':exist'
                       CALL ui.Interface.refresh()
                       LET g_success = 'N'        #No.FUN-A80036
                    ELSE
                       #CHI-A60011 add --start--
                       OPEN db_cs2_occ_lock USING l_occ01_old
                       IF STATUS THEN
                          LET g_msg_x = g_azp[l_j].azp01,':occ_file:lock'
                          CALL s_errmsg('occ01',g_occ.occ01,g_msg_x,STATUS,1)
                          MESSAGE g_msg2,':fail'
                          CALL ui.Interface.refresh()
                          CLOSE db_cs2_occ_lock
                          LET g_success = 'N'
                          #LET l_occ_upd = 'N'   #No.FUN-A80036
                          EXIT FOREACH
                       END IF
                       FETCH db_cs2_occ_lock INTO l_occ_2.* 
                       IF SQLCA.SQLCODE THEN
                          LET g_msg_x = g_azp[l_j].azp01,':occ_file:lock'
                          CALL s_errmsg('occ01',g_occ.occ01,g_msg_x,SQLCA.SQLCODE,1)
                          MESSAGE g_msg2,':fail'
                          CALL ui.Interface.refresh()
                          CLOSE db_cs2_occ_lock
                          LET g_success = 'N'
                          #LET l_occ_upd = 'N'   #No.FUN-A80036
                          EXIT FOREACH
                       END IF
                       #CHI-A60011 add --end--
                       EXECUTE db_cs5 INTO l_occ.* USING l_occ01_old
                       IF SQLCA.sqlcode THEN
                          CALL s_errmsg('occ01',g_occ.occ01,'',SQLCA.sqlcode,1)
                       END IF
                       IF cl_null(g_occ.occ247) THEN LET g_occ.occ247 = 0 END IF
                       IF cl_null(g_occ.occ248) THEN LET g_occ.occ248 = 0 END IF
                       LET g_occ.occ247 = g_occ.occ247 + 1
                       LET g_occ.occ16  = l_occ.occ16
                       LET g_occ.occ171 = l_occ.occ171
                       LET g_occ.occ172 = l_occ.occ172
                       LET g_occ.occ173 = l_occ.occ173
                       LET g_occ.occ174 = l_occ.occ174
 
                       EXECUTE db_cs2 USING g_occ.*,l_occ01_old
                       IF SQLCA.sqlcode = 0 THEN
                          MESSAGE g_msg2,':ok'
                          CALL ui.Interface.refresh()
                          #No.FUN-A30110  --Begin
                          IF NOT (g_occ.occ01 MATCHES 'MISC*' OR g_occ.occ01 MATCHES 'EMPL*') THEN   #No.TQC-BB0002   
                             IF l_occ.occ02 <> g_occ.occ02 THEN
                                #CALL s_upd_abbr(g_occ.occ01,g_occ.occ02,g_azp[l_j].azp03,'2','Y')
                                CALL s_upd_abbr(g_occ.occ01,g_occ.occ02,g_azp[l_j].azp01,'2','Y','u')  #FUN-A50102  #No.FUN-BB0049
                             END IF
                          END IF    #No.TQC-BB0002
                          #No.FUN-A30110  --End
                       ELSE
                          LET g_msg_x = g_azp[l_j].azp01,':upd'
                          CALL s_errmsg('occ01',g_occ.occ01,g_msg_x,SQLCA.sqlcode,1)
                          MESSAGE g_msg2,':fail'
                          CALL ui.Interface.refresh()
                          LET g_success = 'N'
                       END IF
                       CLOSE db_cs2_occ_lock  #CHI-A60011 add
                    END IF
                 ELSE
                    LET g_msg_x = g_azp[l_j].azp01,':ins'
                    CALL s_errmsg('occ01',g_occ.occ01,g_msg_x,SQLCA.sqlcode,1)
                    MESSAGE g_msg1,':fail'
                    CALL ui.Interface.refresh()
                    LET g_success = 'N'
                 END IF
              END IF
              #No.FUN-A80036  --Begin
              #IF SQLCA.sqlerrd[3] > 0 THEN
              IF g_success = 'Y' THEN
              #No.FUN-A80036  --End  
                 CALL s_dc_carry_record(g_gev04,g_azp[l_j].azp01,g_prog,g_occ.occ01,'4')
                 CALL i221_occg(l_occ01_old,g_occ.occ248,l_occ01,g_azp[l_j].azp01,l_gew07)
                 CALL i221_ocd(l_occ01_old,l_occ01,g_azp[l_j].azp01,l_gew07)
                 CALL i221_oce(l_occ01_old,l_occ01,g_azp[l_j].azp01,l_gew07)
                 CALL i221_oci(l_occ01_old,l_occ01,g_azp[l_j].azp01,l_gew07)
                 CALL i221_ocj(l_occ01_old,l_occ01,g_azp[l_j].azp01,l_gew07)
                 CALL i221_tql(l_occ01_old,l_occ01,g_azp[l_j].azp01,l_gew07)
                 CALL i221_tqk(l_occ01_old,l_occ01,g_azp[l_j].azp01,l_gew07)
                 CALL i221_tqo('occ',l_occ01_old,l_occ01,g_azp[l_j].azp01,l_gew07,l_dbs_sep,l_tabname1,m_gew05,m_gew07,m_tqm01,m_tqm06)
                 CALL i221_pov(l_occ01_old,l_occ01,g_azp[l_j].azp01,l_gew07)
                 #CHI-CB0017 add begin---
                 LET l_value1 = g_occ.occ01
                 LET l_value2 = g_occ.occ01
                 CALL s_data_transfer(g_azp[l_j].azp01,'2',g_prog,l_value1,l_value2,'','','')
                 #CHI-CB0017 add end-----
                 #LET l_occ_upd = 'Y'   #NO.FUN-840068 add   #No.FUN-A80036
              END IF
           ELSE
              LET g_sql = "SELECT occ248 FROM ",
                          #l_dbs_sep CLIPPED,"occ_file ",
                          cl_get_target_table(g_azp[l_j].azp01,'occ_file'), #FUN-A50102
                          " WHERE occ01='",l_occ01_old CLIPPED,"'"
              CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		      CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102	            
              PREPARE occ_credit_p1 FROM g_sql
              EXECUTE occ_credit_p1 INTO g_occ.occ248
              IF cl_null(g_occ.occ248) THEN LET g_occ.occ248 = 0 END IF
              LET g_occ.occ248 = g_occ.occ248 + 1
 
              IF l_gew07 = 'Y' THEN
                 #CHI-A60011 add --start--
                 OPEN db_cs2_credit_lock USING l_occ01_old
                 IF STATUS THEN
                    LET g_msg_x = g_azp[l_j].azp01,':occ_file:lock'
                    CALL s_errmsg('occ01',g_occ.occ01,g_msg_x,STATUS,1)
                    MESSAGE g_msg2,':fail'
                    CALL ui.Interface.refresh()
                    CLOSE db_cs2_credit_lock
                    LET g_success = 'N'
                    #LET l_occ_upd = 'N'   #No.FUN-A80036
                    EXIT FOREACH
                 END IF
                 FETCH db_cs2_credit_lock INTO l_occ_2.* 
                 IF SQLCA.SQLCODE THEN
                    LET g_msg_x = g_azp[l_j].azp01,':occ_file:lock'
                    CALL s_errmsg('occ01',g_occ.occ01,g_msg_x,SQLCA.SQLCODE,1)
                    MESSAGE g_msg2,':fail'
                    CALL ui.Interface.refresh()
                    CLOSE db_cs2_credit_lock
                    LET g_success = 'N'
                    #LET l_occ_upd = 'N'   #No.FUN-A80036
                    EXIT FOREACH
                 END IF
                 #CHI-A60011 add --end--
                 EXECUTE db_credit_upd_cs USING g_occ.occ246,g_occ.occ248,
                                                #-----MOD-A20085---------
                                                g_occ.occ62,g_occ.occ33,
                                                g_occ.occ61,g_occ.occ36,
                                                g_occ.occ175,g_occ.occ631,
                                                #-----END MOD-A20085-----
                                                g_occ.occ63,g_occ.occ64,
                                                l_occ01_old
                 IF SQLCA.sqlcode = 0 THEN
                    MESSAGE g_msg2,':ok'
                    CALL ui.Interface.refresh()
                 ELSE
                    LET g_msg_x = g_azp[l_j].azp01,':upd'
                    CALL s_errmsg('occ01',g_occ.occ01,g_msg_x,SQLCA.sqlcode,1)
                    MESSAGE g_msg2,':fail'
                    CALL ui.Interface.refresh()
                    LET g_success = 'N'
                 END IF
                 #No.FUN-A80036  --Begin
                 #IF SQLCA.sqlerrd[3] > 0 THEN
                 IF g_success = 'Y' THEN
                 #No.FUN-A80036  --End  
                    CALL s_dc_carry_record(g_gev04,g_azp[l_j].azp01,g_prog,g_occ.occ01||'+credit','4')
                    #LET l_occ_upd = 'Y'   #NO.FUN-840068 add   #No.FUN-A80036
                 END IF
                 CLOSE db_cs2_credit_lock  #CHI-A60011 add
              END IF
           END IF
           IF g_success = 'N' THEN
              #LET l_occ_upd = 'N'   #NO.FUN-840068 add   #No.FUN-A80036
              ROLLBACK WORK
           ELSE
              LET l_occ_upd = 'Y'   #NO.FUN-840068 add
              COMMIT WORK
           END IF
       END FOREACH
       #mail 2
       IF l_occ_upd  = 'Y' THEN   #NO.FUN-840033 add
           CALL s_dc_carry_send_mail_2(l_hs_flag,l_gew08,l_hs_path,l_hist_tab)
       END IF                     #NO.FUN-840068
   END FOR
 
   CALL s_dc_drop_temp_table(l_tabname)
   IF g_flag <> '2' THEN
      CALL s_dc_drop_temp_table(l_tabname1)
   END IF
   CALL s_dc_drop_temp_table(l_hist_tab)
   
   IF l_occ_upd = 'Y' THEN     #NO.FUN-840068 add
      #MESSAGE 'Data Carry Finish!'     #TQC-C50259 mark
       CALL cl_err('','aim-162',0)      #TQC-C50259 add
   END IF                      #NO.FUN-840068 add
   CALL ui.Interface.refresh()
END FUNCTION
 
FUNCTION s_axmi221_carry_p1()
   DEFINE l_i                  LIKE type_file.num10
   DEFINE l_tabname            STRING   #No.FUN-A80036
   DEFINE l_str                STRING   #No.FUN-A80036
 
   CALL s_dc_cre_temp_table("occ_file") RETURNING l_tabname
   #No.FUN-A80036  --Begin
   #LET g_sql = " CREATE UNIQUE INDEX occ_file_bak_01 ON ",l_tabname CLIPPED,"(occ01)"
   LET g_sql = " CREATE UNIQUE INDEX ",l_tabname CLIPPED,"_01 ON ",l_tabname CLIPPED,"(occ01)"
   #No.FUN-A80036  --End  
   PREPARE unique_p1 FROM g_sql
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         #No.FUN-A80036  --Begin
         #CALL s_errmsg('occ_file_bak_01','','create unique index',SQLCA.sqlcode,1)
         CALL s_errmsg(l_tabname,'','create unique index',SQLCA.sqlcode,1)
         #No.FUN-A80036  --End  
      ELSE
         CALL cl_err('create unique index',SQLCA.sqlcode,1)
      END IF
   END IF
   EXECUTE unique_p1
 
   LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM occ_file",
                                                 "  WHERE occ01 = ?"
   PREPARE ins_pp FROM g_sql
 
   LET g_all_cnt = 0
   IF cl_null(g_flagx) THEN LET g_flagx = '0' END IF
   IF g_flagx <> '1' THEN
      FOR l_i = 1 TO g_occ_1.getLength()
          IF cl_null(g_occ_1[l_i].occ01) THEN
             CONTINUE FOR
          END IF
          IF g_occ_1[l_i].sel = 'N' THEN
             CONTINUE FOR
          END IF
          EXECUTE ins_pp USING g_occ_1[l_i].occ01
          IF SQLCA.sqlcode THEN
             LET l_str = "ins ",l_tabname                   #No.FUN-A80036
             IF g_bgerr THEN
                CALL s_errmsg('','',l_str,SQLCA.sqlcode,1)  #No.FUN-A80036
             ELSE
                CALL cl_err(l_str,SQLCA.sqlcode,1)          #No.FUN-A80036
             END IF
             CONTINUE FOR
          END IF
          LET g_all_cnt = g_all_cnt + 1
      END FOR
   ELSE
      LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM occ_file_bak1"
      PREPARE ins_ppx FROM g_sql
      EXECUTE ins_ppx
      LET g_sql = " SELECT COUNT(*) FROM ",l_tabname
      PREPARE cnt_ppx FROM g_sql
      EXECUTE cnt_ppx INTO g_all_cnt
      IF cl_null(g_all_cnt) THEN LET g_all_cnt = 0 END IF
   END IF
 
   RETURN l_tabname
END FUNCTION
 
FUNCTION s_axmi221_tqm_carry_p1(p_from)
   DEFINE l_i                  LIKE type_file.num10
   DEFINE l_tabname            STRING   #No.FUN-A80036
   DEFINE l_str                STRING   #No.FUN-A80036
   DEFINE p_from               LIKE type_file.chr3
 
   CALL s_dc_cre_temp_table("tqm_file") RETURNING l_tabname
   #No.FUN-A80036  --Begin
   #LET g_sql = " CREATE UNIQUE INDEX tqm_file_bak_01 ON ",l_tabname CLIPPED,"(tqm01)"
   LET g_sql = " CREATE UNIQUE INDEX ",l_tabname CLIPPED,"_01 ON ",l_tabname CLIPPED,"(tqm01)"
   #No.FUN-A80036  --End  
   PREPARE unique_tqm_p1 FROM g_sql
   EXECUTE unique_tqm_p1
 
   IF p_from = 'occ' THEN
      LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM tqm_file",
                  "        WHERE tqm01 IN (SELECT tqo02 FROM tqo_file ",
                  "                         WHERE tqo01 = ? )"
   ELSE  #tqo
      LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM tqm_file",
                  "        WHERE tqm01 = ? "
   END IF
   PREPARE ins_tqm_pp FROM g_sql
 
   LET g_tqm_all_cnt = 0
   IF cl_null(g_flagx) THEN LET g_flagx = '0' END IF
   IF g_flagx <> '1' THEN
      FOR l_i = 1 TO g_occ_1.getLength()
          IF cl_null(g_occ_1[l_i].occ01) THEN
             CONTINUE FOR
          END IF
          IF g_occ_1[l_i].sel = 'N' THEN
             CONTINUE FOR
          END IF
          IF p_from = 'occ' THEN
             EXECUTE ins_tqm_pp USING g_occ_1[l_i].occ01
          ELSE
          END IF

          #No.FUN-A80036  --Begin
          #IF SQLCA.sqlcode AND SQLCA.sqlcode <> -239 THEN
          IF SQLCA.sqlcode AND NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN
          #No.FUN-A80036  --End  
             LET l_str = "ins ",l_tabname                   #No.FUN-A80036
             IF g_bgerr THEN
                CALL s_errmsg('','',l_str,SQLCA.sqlcode,1)  #No.FUN-A80036
             ELSE
                CALL cl_err(l_str,SQLCA.sqlcode,1)          #No.FUN-A80036
             END IF
             CONTINUE FOR
          END IF
          LET g_tqm_all_cnt = g_tqm_all_cnt + 1
      END FOR
   ELSE
      LET g_sql = " INSERT INTO ",l_tabname CLIPPED," SELECT * FROM tqm_file_bak1"
      PREPARE ins_tqm_ppx FROM g_sql
      EXECUTE ins_tqm_ppx
      LET g_sql = " SELECT COUNT(*) FROM ",l_tabname
      PREPARE cnt_tqm_ppx FROM g_sql
      EXECUTE cnt_tqm_ppx INTO g_tqm_all_cnt
      IF cl_null(g_tqm_all_cnt) THEN LET g_tqm_all_cnt = 0 END IF
   END IF
 
   RETURN l_tabname
END FUNCTION
 
FUNCTION s_axmi221_download(p_occ)
  DEFINE p_occ        DYNAMIC ARRAY OF RECORD
                      sel      LIKE type_file.chr1,
                      occ01    LIKE occ_file.occ01
                      END RECORD
  DEFINE l_path       LIKE ze_file.ze03
  DEFINE l_i          LIKE type_file.num10
 
    #前置准備
    FOR l_i = 1 TO p_occ.getLength()
        LET g_occ_1[l_i].* = p_occ[l_i].*
    END FOR
 
    CALL s_dc_download_path() RETURNING l_path
    IF cl_null(l_path) THEN RETURN END IF
    CALL s_axmi221_download_files(l_path)
 
END FUNCTION
 
FUNCTION s_axmi221_download_files(p_path)
  DEFINE p_path            LIKE ze_file.ze03
  DEFINE l_download_file   LIKE ze_file.ze03
  DEFINE l_upload_file     LIKE ze_file.ze03
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
   CALL s_axmi221_carry_p1() RETURNING l_tabname
 
   #occ
   LET l_upload_file = l_tempdir CLIPPED,'/axmi221_occ_file_4.txt'
   LET l_download_file = p_path CLIPPED,"/axmi221_occ_file_4.txt"
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   LET g_sql = "SELECT * FROM ",l_tabname
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload occ',SQLCA.sqlcode,1)
   END IF
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:occ ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   #occg
   LET l_upload_file = l_tempdir CLIPPED,'/axmi221_occg_file_4.txt'
   LET l_download_file = p_path CLIPPED,"/axmi221_occg_file_4.txt"
   LET g_sql = "SELECT * FROM occg_file WHERE occg01 IN (select occ01 FROM ",l_tabname CLIPPED,")"
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload occg',SQLCA.sqlcode,1)
   END IF
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:occg ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   #ocd
   LET l_upload_file = l_tempdir CLIPPED,'/axmi221_ocd_file_4.txt'
   LET l_download_file = p_path CLIPPED,"/axmi221_ocd_file_4.txt"
   LET g_sql = "SELECT * FROM ocd_file WHERE ocd01 IN (select occ01 FROM ",l_tabname CLIPPED,")"
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload ocd',SQLCA.sqlcode,1)
   END IF
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:ocd ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   #oce
   LET l_upload_file = l_tempdir CLIPPED,'/axmi221_oce_file_4.txt'
   LET l_download_file = p_path CLIPPED,"/axmi221_oce_file_4.txt"
   LET g_sql = "SELECT * FROM oce_file WHERE oce01 IN (select occ01 FROM ",l_tabname CLIPPED,")"
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload oce',SQLCA.sqlcode,1)
   END IF
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:oce ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   #oci
   LET l_upload_file = l_tempdir CLIPPED,'/axmi221_oci_file_4.txt'
   LET l_download_file = p_path CLIPPED,"/axmi221_oci_file_4.txt"
   LET g_sql = "SELECT * FROM oci_file WHERE oci01 IN (select occ01 FROM ",l_tabname CLIPPED,")"
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload oci',SQLCA.sqlcode,1)
   END IF
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:oci ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   #ocj
   LET l_upload_file = l_tempdir CLIPPED,'/axmi221_ocj_file_4.txt'
   LET l_download_file = p_path CLIPPED,"/axmi221_ocj_file_4.txt"
   LET g_sql = "SELECT * FROM ocj_file WHERE ocj01 IN (select occ01 FROM ",l_tabname CLIPPED,")"
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload ocj',SQLCA.sqlcode,1)
   END IF
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:ocj ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   #tql
   LET l_upload_file = l_tempdir CLIPPED,'/axmi221_tql_file_4.txt'
   LET l_download_file = p_path CLIPPED,"/axmi221_tql_file_4.txt"
   LET g_sql = "SELECT * FROM tql_file WHERE tql01 IN (select occ01 FROM ",l_tabname CLIPPED,")"
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload tql',SQLCA.sqlcode,1)
   END IF
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:tql ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   #tqk
   LET l_upload_file = l_tempdir CLIPPED,'/axmi221_tqk_file_4.txt'
   LET l_download_file = p_path CLIPPED,"/axmi221_tqk_file_4.txt"
   LET g_sql = "SELECT * FROM tqk_file WHERE tqk01 IN (select occ01 FROM ",l_tabname CLIPPED,")"
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload tqk',SQLCA.sqlcode,1)
   END IF
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:tqk ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   #tqo
   LET l_upload_file = l_tempdir CLIPPED,'/axmi221_tqo_file_4.txt'
   LET l_download_file = p_path CLIPPED,"/axmi221_tqo_file_4.txt"
   LET g_sql = "SELECT * FROM tqo_file WHERE tqo01 IN (select occ01 FROM ",l_tabname CLIPPED,")"
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload tqo',SQLCA.sqlcode,1)
   END IF
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:tqo ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   #pov
   LET l_upload_file = l_tempdir CLIPPED,'/axmi221_pov_file_4.txt'
   LET l_download_file = p_path CLIPPED,"/axmi221_pov_file_4.txt"
   LET g_sql = "SELECT * FROM pov_file WHERE pov01 = '1' AND pov02 IN (select occ01 FROM ",l_tabname CLIPPED,")"
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload pov',SQLCA.sqlcode,1)
   END IF
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:pov ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   #tqm
   LET l_upload_file = l_tempdir CLIPPED,'/axmi221_tqm_file_4.txt'
   LET l_download_file = p_path CLIPPED,"/axmi221_tqm_file_4.txt"
   LET g_sql = "SELECT * FROM tqm_file WHERE tqm01 IN (",
               "    SELECT tqo02 FROM tqo_file WHERE tqo01 IN (",
               "        SELECT occ01 FROM ",l_tabname CLIPPED,"))"
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload tqm',SQLCA.sqlcode,1)
   END IF
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:tqm ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
   #tqn
   LET l_upload_file = l_tempdir CLIPPED,'/axmi221_tqn_file_4.txt'
   LET l_download_file = p_path CLIPPED,"/axmi221_tqn_file_4.txt"
   LET g_sql = "SELECT * FROM tqn_file WHERE tqn01 IN (",
               "    SELECT tqo02 FROM tqo_file WHERE tqo01 IN (",
               "        SELECT occ01 FROM ",l_tabname CLIPPED,"))"
   UNLOAD TO l_upload_file g_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('unload tqn',SQLCA.sqlcode,1)
   END IF
   CALL cl_download_file(l_upload_file,l_download_file) RETURNING l_status
   IF l_status THEN
      MESSAGE 'Download:tqn ok'
   ELSE
      CALL cl_err(l_upload_file,STATUS,1)
      RETURN
   END IF
 
   LET g_sql = "rm ",l_upload_file CLIPPED
   RUN g_sql
 
END FUNCTION
 
FUNCTION i221_get_column()
   #組column
   CALL s_carry_col('occ_file') RETURNING g_str1,g_str2,g_str3
   #組index
   CALL s_carry_idx('occ_file') RETURNING g_str4
 
   IF g_flag <> '2' THEN
      CALL s_carry_col('occg_file') RETURNING g_str1_occg,g_str2_occg,g_str3_occg
      CALL s_carry_col('ocd_file')  RETURNING g_str1_ocd,g_str2_ocd,g_str3_ocd
      CALL s_carry_col('oce_file')  RETURNING g_str1_oce,g_str2_oce,g_str3_oce
      CALL s_carry_col('oci_file')  RETURNING g_str1_oci,g_str2_oci,g_str3_oci
      CALL s_carry_col('ocj_file')  RETURNING g_str1_ocj,g_str2_ocj,g_str3_ocj
      CALL s_carry_col('tql_file')  RETURNING g_str1_tql,g_str2_tql,g_str3_tql
      CALL s_carry_col('tqk_file')  RETURNING g_str1_tqk,g_str2_tqk,g_str3_tqk
      CALL s_carry_col('pov_file')  RETURNING g_str1_pov,g_str2_pov,g_str3_pov
      CALL s_carry_idx('occg_file') RETURNING g_str4_occg
      CALL s_carry_idx('ocd_file')  RETURNING g_str4_ocd
      CALL s_carry_idx('oce_file')  RETURNING g_str4_oce
      CALL s_carry_idx('oci_file')  RETURNING g_str4_oci
      CALL s_carry_idx('ocj_file')  RETURNING g_str4_ocj
      CALL s_carry_idx('tql_file')  RETURNING g_str4_tql
      CALL s_carry_idx('tqk_file')  RETURNING g_str4_tqk
      CALL s_carry_idx('pov_file')  RETURNING g_str4_pov
   END IF
END FUNCTION
 
FUNCTION i221_get_tqo_column()
   #組column
   CALL s_carry_col('tqm_file') RETURNING g_str1_tqm,g_str2_tqm,g_str3_tqm
   CALL s_carry_col('tqn_file') RETURNING g_str1_tqn,g_str2_tqn,g_str3_tqn
   CALL s_carry_col('tqo_file')  RETURNING g_str1_tqo,g_str2_tqo,g_str3_tqo
   #組index
   CALL s_carry_idx('tqm_file') RETURNING g_str4_tqm
   CALL s_carry_idx('tqn_file') RETURNING g_str4_tqn
   CALL s_carry_idx('tqo_file')  RETURNING g_str4_tqo
END FUNCTION
 
FUNCTION i221_occ_body()
 
   #occ對應單身occg_file拋轉的cursor定義
   IF g_flagx <> '1' THEN
      LET g_sql = " SELECT * FROM occg_file ",
                  "  WHERE occg01 = ? "
   ELSE
      LET g_sql = " SELECT * FROM occg_file_bak1 ",
                  "  WHERE occg01 = ? "
   END IF
   PREPARE occg_p FROM g_sql
   DECLARE occg_cur CURSOR WITH HOLD FOR occg_p
 
   IF g_flagx <> '1' THEN
      LET g_sql = " SELECT * FROM ocd_file ",
                  "  WHERE ocd01 = ? "
   ELSE
      LET g_sql = " SELECT * FROM ocd_file_bak1 ",
                  "  WHERE ocd01 = ? "
   END IF
   PREPARE ocd_p FROM g_sql
   DECLARE ocd_cur CURSOR WITH HOLD FOR ocd_p
 
   IF g_flagx <> '1' THEN
      LET g_sql = " SELECT * FROM oce_file ",
                  "  WHERE oce01 = ? "
   ELSE
      LET g_sql = " SELECT * FROM oce_file_bak1 ",
                  "  WHERE oce01 = ? "
   END IF
   PREPARE oce_p FROM g_sql
   DECLARE oce_cur CURSOR WITH HOLD FOR oce_p
   IF g_flagx <> '1' THEN
      LET g_sql = " SELECT * FROM oci_file ",
                  "  WHERE oci01 = ? "
   ELSE
      LET g_sql = " SELECT * FROM oci_file_bak1 ",
                  "  WHERE oci01 = ? "
   END IF
   PREPARE oci_p FROM g_sql
   DECLARE oci_cur CURSOR WITH HOLD FOR oci_p
   IF g_flagx <> '1' THEN
      LET g_sql = " SELECT * FROM ocj_file ",
                  "  WHERE ocj01 = ? "
   ELSE
      LET g_sql = " SELECT * FROM ocj_file_bak1 ",
                  "  WHERE ocj01 = ? "
   END IF
   PREPARE ocj_p FROM g_sql
   DECLARE ocj_cur CURSOR WITH HOLD FOR ocj_p
   IF g_flagx <> '1' THEN
      LET g_sql = " SELECT * FROM tql_file ",
                  "  WHERE tql01 = ? "
   ELSE
      LET g_sql = " SELECT * FROM tql_file_bak1 ",
                  "  WHERE tql01 = ? "
   END IF
   PREPARE tql_p FROM g_sql
   DECLARE tql_cur CURSOR WITH HOLD FOR tql_p
   IF g_flagx <> '1' THEN
      LET g_sql = " SELECT * FROM tqk_file ",
                  "  WHERE tqk01 = ? "
   ELSE
      LET g_sql = " SELECT * FROM tqk_file_bak1 ",
                  "  WHERE tqk01 = ? "
   END IF
   PREPARE tqk_p FROM g_sql
   DECLARE tqk_cur CURSOR WITH HOLD FOR tqk_p
   IF g_flagx <> '1' THEN
      LET g_sql = " SELECT * FROM pov_file ",
                  "  WHERE pov01 = 1 ",
                  "    AND pov02 = ? "
   ELSE
      LET g_sql = " SELECT * FROM pov_file_bak1 ",
                  "  WHERE pov01 = 1 ",
                  "    AND pov02 = ? "
   END IF
   PREPARE pov_p FROM g_sql
   DECLARE pov_cur CURSOR WITH HOLD FOR pov_p
END FUNCTION
 
FUNCTION i221_tqo_body()
 
   #tqo對應單身tqm_file拋轉的cursor定義
   IF g_flagx <> '1' THEN
      LET g_sql = " SELECT * FROM tqo_file ",
                  "  WHERE tqo01 = ? "
   ELSE
      LET g_sql = " SELECT * FROM tqo_file_bak1 ",
                  "  WHERE tqo01 = ? "
   END IF
   PREPARE tqo_p FROM g_sql
   DECLARE tqo_cur CURSOR WITH HOLD FOR tqo_p
   IF g_flagx <> '1' THEN
      LET g_sql = " SELECT * FROM tqm_file ",
                  "  WHERE tqm01 = ? "
   ELSE
      LET g_sql = " SELECT * FROM tqm_file_bak1 ",
                  "  WHERE tqm01 = ? "
   END IF
   PREPARE tqm_p FROM g_sql
   DECLARE tqm_cur CURSOR WITH HOLD FOR tqm_p
   IF g_flagx <> '1' THEN
      LET g_sql = " SELECT * FROM tqn_file ",
                  "  WHERE tqn01 = ? "
   ELSE
      LET g_sql = " SELECT * FROM tqn_file_bak1 ",
                  "  WHERE tqn01 = ? "
   END IF
   PREPARE tqn_p FROM g_sql
   DECLARE tqn_cur CURSOR WITH HOLD FOR tqn_p
END FUNCTION
 
FUNCTION i221_occg(p_occ01_old,p_occ248,p_occ01_new,p_azp01,p_gew07)
   DEFINE p_occ01_old     LIKE occ_file.occ01
   DEFINE p_occ01_new     LIKE occ_file.occ01
   DEFINE p_occ248        LIKE occ_file.occ248
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_k             LIKE type_file.num10
   DEFINE l_occg_2        RECORD LIKE occg_file.*  #CHI-A60011 add
 
   #處理單身occg的insert或是update
   LET l_k = 1
   FOREACH occg_cur USING p_occ01_old INTO g_occg.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('occg01',g_occg.occg01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_occ01_new) THEN LET g_occg.occg01 = p_occ01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_occg.occg01,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_occg.occg01,':'
      EXECUTE db_occg1 USING g_occg.*
      IF SQLCA.sqlcode = 0 THEN
         MESSAGE g_msg3,':ok'
         CALL ui.Interface.refresh()
      ELSE
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlcode = -239 THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
         #No.FUN-A80036  --End  
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3,':exist'
               LET g_success = 'N'      #No.FUN-A80036
               CALL ui.Interface.refresh()
            ELSE
               #CHI-A60011 add --start--
               OPEN db_cs2_occg_lock USING p_occ01_old
               IF STATUS THEN
                  LET g_msg_x = p_azp01,':occg_file:lock'
                  LET g_showmsg = g_occg.occg01
                  CALL s_errmsg('occg01',g_showmsg,g_msg_x,STATUS,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_occg_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               FETCH db_cs2_occg_lock INTO l_occg_2.* 
               IF SQLCA.SQLCODE THEN
                  LET g_msg_x = p_azp01,':occg_file:lock'
                  LET g_showmsg = g_occg.occg01
                  CALL s_errmsg('occg01',g_showmsg,g_msg_x,SQLCA.SQLCODE,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_occg_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               #CHI-A60011 add --end--
               EXECUTE db_occg2 USING g_occg.*,p_occ01_old
               IF SQLCA.sqlcode = 0 THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_occg.occg01
                  CALL s_errmsg('occg01',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
               CLOSE db_cs2_occg_lock  #CHI-A60011 add
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_occg.occg01
            CALL s_errmsg('occg01',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         IF cl_null(g_occg.occg02) THEN LET g_occg.occg02 = 'credit' END IF
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_occg.occg01||'+'||g_occg.occg02,'4')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION i221_ocd(p_occ01_old,p_occ01_new,p_azp01,p_gew07)
   DEFINE p_occ01_old     LIKE occ_file.occ01
   DEFINE p_occ01_new     LIKE occ_file.occ01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_ocd_2         RECORD LIKE ocd_file.* #CHI-A60011 add
 
   FOREACH ocd_cur USING p_occ01_old INTO g_ocd.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ocd01',g_ocd.ocd01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_occ01_new) THEN LET g_ocd.ocd01 = p_occ01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_ocd.ocd01,'+',g_ocd.ocd02,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_ocd.ocd01,'+',g_ocd.ocd02,':'
      EXECUTE db_ocd1 USING g_ocd.*
      IF SQLCA.sqlcode = 0 THEN
         MESSAGE g_msg3,':ok'
         CALL ui.Interface.refresh()
      ELSE
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlcode = -239 THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
         #No.FUN-A80036  --End  
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'      #No.FUN-A80036
            ELSE
               #CHI-A60011 add --start--
               OPEN db_cs2_ocd_lock USING p_occ01_old,g_ocd.ocd02
               IF STATUS THEN
                  LET g_msg_x = p_azp01,':ocd_file:lock'
                  LET g_showmsg = g_ocd.ocd01,'/',g_ocd.ocd02
                  CALL s_errmsg('ocd01,ocd02',g_showmsg,g_msg_x,STATUS,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_ocd_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               FETCH db_cs2_ocd_lock INTO l_ocd_2.* 
               IF SQLCA.SQLCODE THEN
                  LET g_msg_x = p_azp01,':ocd_file:lock'
                  LET g_showmsg = g_ocd.ocd01,'/',g_ocd.ocd02
                  CALL s_errmsg('ocd01,ocd02',g_showmsg,g_msg_x,SQLCA.SQLCODE,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_ocd_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               #CHI-A60011 add --end--
               EXECUTE db_ocd2 USING g_ocd.*,p_occ01_old,g_ocd.ocd02
               IF SQLCA.sqlcode = 0 THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_ocd.ocd01,'/',g_ocd.ocd02
                  CALL s_errmsg('ocd01,ocd02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
               CLOSE db_cs2_ocd_lock  #CHI-A60011 add
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_ocd.ocd01,'/',g_ocd.ocd02
            CALL s_errmsg('ocd01,ocd02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_ocd.ocd01||'+'||g_ocd.ocd02,'4')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION i221_oce(p_occ01_old,p_occ01_new,p_azp01,p_gew07)
   DEFINE p_occ01_old     LIKE occ_file.occ01
   DEFINE p_occ01_new     LIKE occ_file.occ01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_oce_2         RECORD LIKE oce_file.* #CHI-A60011 add
 
   FOREACH oce_cur USING p_occ01_old INTO g_oce.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('oce01',g_oce.oce01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_occ01_new) THEN LET g_oce.oce01 = p_occ01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_oce.oce01,'+',g_oce.oce03,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_oce.oce01,'+',g_oce.oce03,':'
      EXECUTE db_oce1 USING g_oce.*
      IF SQLCA.sqlcode = 0 THEN
         MESSAGE g_msg3,':ok'
         CALL ui.Interface.refresh()
      ELSE
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlcode = -239 THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
         #No.FUN-A80036  --End  
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'      #No.FUN-A80036
            ELSE
               #CHI-A60011 add --start--
               OPEN db_cs2_oce_lock USING p_occ01_old,g_oce.oce03
               IF STATUS THEN
                  LET g_msg_x = p_azp01,':oce_file:lock'
                  LET g_showmsg = g_oce.oce01,'/',g_oce.oce03
                  CALL s_errmsg('oce01,oce03',g_showmsg,g_msg_x,STATUS,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_oce_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               FETCH db_cs2_oce_lock INTO l_oce_2.* 
               IF SQLCA.SQLCODE THEN
                  LET g_msg_x = p_azp01,':oce_file:lock'
                  LET g_showmsg = g_oce.oce01,'/',g_oce.oce03
                  CALL s_errmsg('oce01,oce03',g_showmsg,g_msg_x,SQLCA.SQLCODE,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_oce_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               #CHI-A60011 add --end--
               EXECUTE db_oce2 USING g_oce.*,p_occ01_old,g_oce.oce03
               IF SQLCA.sqlcode = 0 THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_oce.oce01,'/',g_oce.oce03
                  CALL s_errmsg('oce01,oce03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
               CLOSE db_cs2_oce_lock  #CHI-A60011 add
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_oce.oce01,'/',g_oce.oce03
            CALL s_errmsg('oce01,oce03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_oce.oce01||'+'||g_oce.oce03,'4')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION i221_oci(p_occ01_old,p_occ01_new,p_azp01,p_gew07)
   DEFINE p_occ01_old     LIKE occ_file.occ01
   DEFINE p_occ01_new     LIKE occ_file.occ01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_oci_2         RECORD LIKE oci_file.* #CHI-A60011 add
 
   FOREACH oci_cur USING p_occ01_old INTO g_oci.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('oci01',g_oci.oci01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_occ01_new) THEN LET g_oci.oci01 = p_occ01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_oci.oci01,'+',g_oci.oci02,'+',g_oci.oci03,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_oci.oci01,'+',g_oci.oci02,'+',g_oci.oci03,':'
      EXECUTE db_oci1 USING g_oci.*
      IF SQLCA.sqlcode = 0 THEN
         MESSAGE g_msg3,':ok'
         CALL ui.Interface.refresh()
      ELSE
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlcode = -239 THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
         #No.FUN-A80036  --End  
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'      #No.FUN-A80036
            ELSE
               #CHI-A60011 add --start--
               OPEN db_cs2_oci_lock USING p_occ01_old,g_oci.oci02,g_oci.oci03
               IF STATUS THEN
                  LET g_msg_x = p_azp01,':oci_file:lock'
                  LET g_showmsg = g_oci.oci01,'/',g_oci.oci02,'/',g_oci.oci03
                  CALL s_errmsg('oci01,oci02,oci03',g_showmsg,g_msg_x,STATUS,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_oci_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               FETCH db_cs2_oci_lock INTO l_oci_2.* 
               IF SQLCA.SQLCODE THEN
                  LET g_msg_x = p_azp01,':oci_file:lock'
                  LET g_showmsg = g_oci.oci01,'/',g_oci.oci02,'/',g_oci.oci03
                  CALL s_errmsg('oci01,oci02,oci03',g_showmsg,g_msg_x,SQLCA.SQLCODE,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_oci_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               #CHI-A60011 add --end--
               EXECUTE db_oci2 USING g_oci.*,p_occ01_old,g_oci.oci02,g_oci.oci03
               IF SQLCA.sqlcode = 0 THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_oci.oci01,'/',g_oci.oci02,'/',g_oci.oci03
                  CALL s_errmsg('oci01,oci02,oci03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
               CLOSE db_cs2_oci_lock  #CHI-A60011 add
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_oci.oci01,'/',g_oci.oci02,'/',g_oci.oci03
            CALL s_errmsg('oci01,oci02,oci03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_oci.oci01||'+'||g_oci.oci02||'+'||g_oci.oci03,'4')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION i221_ocj(p_occ01_old,p_occ01_new,p_azp01,p_gew07)
   DEFINE p_occ01_old     LIKE occ_file.occ01
   DEFINE p_occ01_new     LIKE occ_file.occ01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_ocj_2         RECORD LIKE ocj_file.* #CHI-A60011 add
 
   FOREACH ocj_cur USING p_occ01_old INTO g_ocj.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('ocj01',g_ocj.ocj01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_occ01_new) THEN LET g_ocj.ocj01 = p_occ01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_ocj.ocj01,'+',g_ocj.ocj02,'+',g_ocj.ocj03,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_ocj.ocj01,'+',g_ocj.ocj02,'+',g_ocj.ocj03,':'
      EXECUTE db_ocj1 USING g_ocj.*
      IF SQLCA.sqlcode = 0 THEN
         MESSAGE g_msg3,':ok'
         CALL ui.Interface.refresh()
      ELSE
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlcode = -239 THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
         #No.FUN-A80036  --End  
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'      #No.FUN-A80036
            ELSE
               #CHI-A60011 add --start--
               OPEN db_cs2_ocj_lock USING p_occ01_old,g_ocj.ocj02,g_ocj.ocj03
               IF STATUS THEN
                  LET g_msg_x = p_azp01,':ocj_file:lock'
                  LET g_showmsg = g_ocj.ocj01,'/',g_ocj.ocj02,'/',g_ocj.ocj03
                  CALL s_errmsg('ocj01,ocj02,ocj03',g_showmsg,g_msg_x,STATUS,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_ocj_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               FETCH db_cs2_ocj_lock INTO l_ocj_2.* 
               IF SQLCA.SQLCODE THEN
                  LET g_msg_x = p_azp01,':ocj_file:lock'
                  LET g_showmsg = g_ocj.ocj01,'/',g_ocj.ocj02,'/',g_ocj.ocj03
                  CALL s_errmsg('ocj01,ocj02,ocj03',g_showmsg,g_msg_x,SQLCA.SQLCODE,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_ocj_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               #CHI-A60011 add --end--
               EXECUTE db_ocj2 USING g_ocj.*,p_occ01_old,g_ocj.ocj02,g_ocj.ocj03
               IF SQLCA.sqlcode = 0 THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_ocj.ocj01,'/',g_ocj.ocj02,'/',g_ocj.ocj03
                  CALL s_errmsg('ocj01,ocj02,ocj03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
               CLOSE db_cs2_ocj_lock  #CHI-A60011 add
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_ocj.ocj01,'/',g_ocj.ocj02,'/',g_ocj.ocj03
            CALL s_errmsg('ocj01,ocj02,ocj03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_ocj.ocj01||'+'||g_ocj.ocj02||'+'||g_ocj.ocj03,'4')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION i221_tql(p_occ01_old,p_occ01_new,p_azp01,p_gew07)
   DEFINE p_occ01_old     LIKE occ_file.occ01
   DEFINE p_occ01_new     LIKE occ_file.occ01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_tql_2         RECORD LIKE tql_file.* #CHI-A60011 add
 
   FOREACH tql_cur USING p_occ01_old INTO g_tql.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('tql01',g_tql.tql01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_occ01_new) THEN LET g_tql.tql01 = p_occ01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_tql.tql01,'+',g_tql.tql02,'+',g_tql.tql03,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_tql.tql01,'+',g_tql.tql02,'+',g_tql.tql03,':'
      EXECUTE db_tql1 USING g_tql.*
      IF SQLCA.sqlcode = 0 THEN
         MESSAGE g_msg3,':ok'
         CALL ui.Interface.refresh()
      ELSE
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlcode = -239 THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
         #No.FUN-A80036  --End  
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'      #No.FUN-A80036
            ELSE
               #CHI-A60011 add --start--
               OPEN db_cs2_tql_lock USING p_occ01_old,g_tql.tql02,g_tql.tql03
               IF STATUS THEN
                  LET g_msg_x = p_azp01,':tql_file:lock'
                  LET g_showmsg = g_tql.tql01,'/',g_tql.tql02,'/',g_tql.tql03
                  CALL s_errmsg('tql01,tql02,tql03',g_showmsg,g_msg_x,STATUS,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_tql_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               FETCH db_cs2_tql_lock INTO l_tql_2.* 
               IF SQLCA.SQLCODE THEN
                  LET g_msg_x = p_azp01,':tql_file:lock'
                  LET g_showmsg = g_tql.tql01,'/',g_tql.tql02,'/',g_tql.tql03
                  CALL s_errmsg('tql01,tql02,tql03',g_showmsg,g_msg_x,SQLCA.SQLCODE,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_tql_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               #CHI-A60011 add --end--
               EXECUTE db_tql2 USING g_tql.*,p_occ01_old,g_tql.tql02,g_tql.tql03
               IF SQLCA.sqlcode = 0 THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_tql.tql01,'/',g_tql.tql02,'/',g_tql.tql03
                  CALL s_errmsg('tql01,tql02,tql03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
               CLOSE db_cs2_tql_lock  #CHI-A60011 add
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_tql.tql01,'/',g_tql.tql02,'/',g_tql.tql03
            CALL s_errmsg('tql01,tql02,tql03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_tql.tql01||'+'||g_tql.tql02||'+'||g_tql.tql03,'4')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION i221_tqk(p_occ01_old,p_occ01_new,p_azp01,p_gew07)
   DEFINE p_occ01_old     LIKE occ_file.occ01
   DEFINE p_occ01_new     LIKE occ_file.occ01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_tqk_2         RECORD LIKE tqk_file.* #CHI-A60011 add
 
   FOREACH tqk_cur USING p_occ01_old INTO g_tqk.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('tqk01',g_tqk.tqk01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_occ01_new) THEN LET g_tqk.tqk01 = p_occ01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_tqk.tqk01,'+',g_tqk.tqk02,'+',g_tqk.tqk03,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_tqk.tqk01,'+',g_tqk.tqk02,'+',g_tqk.tqk03,':'
      EXECUTE db_tqk1 USING g_tqk.*
      IF SQLCA.sqlcode = 0 THEN
         MESSAGE g_msg3,':ok'
         CALL ui.Interface.refresh()
      ELSE
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlcode = -239 THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
         #No.FUN-A80036  --End  
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'      #No.FUN-A80036
            ELSE
               #CHI-A60011 add --start--
               OPEN db_cs2_tqk_lock USING p_occ01_old,g_tqk.tqk02,g_tqk.tqk03
               IF STATUS THEN
                  LET g_msg_x = p_azp01,':tqk_file:lock'
                  LET g_showmsg = g_tqk.tqk01,'/',g_tqk.tqk02,'/',g_tqk.tqk03
                  CALL s_errmsg('tqk01,tqk02,tqk03',g_showmsg,g_msg_x,STATUS,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_tqk_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               FETCH db_cs2_tqk_lock INTO l_tqk_2.* 
               IF SQLCA.SQLCODE THEN
                  LET g_msg_x = p_azp01,':tqk_file:lock'
                  LET g_showmsg = g_tqk.tqk01,'/',g_tqk.tqk02,'/',g_tqk.tqk03
                  CALL s_errmsg('tqk01,tqk02,tqk03',g_showmsg,g_msg_x,SQLCA.SQLCODE,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_tqk_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               #CHI-A60011 add --end--
               EXECUTE db_tqk2 USING g_tqk.*,p_occ01_old,g_tqk.tqk02,g_tqk.tqk03
               IF SQLCA.sqlcode = 0 THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_tqk.tqk01,'/',g_tqk.tqk02,'/',g_tqk.tqk03
                  CALL s_errmsg('tqk01,tqk02,tqk03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
               CLOSE db_cs2_tqk_lock  #CHI-A60011 add
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_tqk.tqk01,'/',g_tqk.tqk02,'/',g_tqk.tqk03
            CALL s_errmsg('tqk01,tqk02,tqk03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_tqk.tqk01||'+'||g_tqk.tqk02||'+'||g_tqk.tqk03,'4')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION i221_tqo(p_from,p_occ01_old,p_occ01_new,p_azp01,p_gew07,p_dbs_sep,p_tabname1,m_gew05,m_gew07,m_tqm01,m_tqm06)
   DEFINE p_from          LIKE type_file.chr3
   DEFINE p_occ01_old     LIKE occ_file.occ01
   DEFINE p_occ01_new     LIKE occ_file.occ01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE p_dbs_sep       LIKE type_file.chr50
   DEFINE p_tabname1      LIKE type_file.chr50
   DEFINE m_gew05         LIKE gew_file.gew05
   DEFINE m_gew07         LIKE gew_file.gew07
   DEFINE m_tqm01         LIKE tqm_file.tqm01
   DEFINE m_tqm06         LIKE tqm_file.tqm06
   DEFINE l_tqo_2         RECORD LIKE tqo_file.* #CHI-A60011 add
 
   FOREACH tqo_cur USING p_occ01_old INTO g_tqo.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('tqo01',g_tqo.tqo01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_occ01_new) THEN LET g_tqo.tqo01 = p_occ01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_tqo.tqo01,'+',g_tqo.tqo03,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_tqo.tqo01,'+',g_tqo.tqo03,':'
      LET g_tqo.tqo04 = g_plant
      LET g_tqo.tqo05 = 1
      #check tqo02是否在tqm_file中存在
      LET g_flag1 = '0'
      #CALL s_axmi221_check_tqo02(p_dbs_sep,g_tqo.tqo02)
      #No.FUN-A80036  --Begin
      #CALL s_axmi221_check_tqo02(p_azp01,g_tqo.tqo02)  #FUN-A50102
      IF g_flag = '0' THEN
         CALL s_axmi221_check_tqo02(g_plant,g_tqo.tqo02)  #FUN-A50102
           RETURNING g_flag1
      END IF
      #No.FUN-A80036  --End  
      IF g_flag1 = '1' THEN
         LET g_showmsg = p_azp01,'/',p_occ01_old,'/',g_tqo.tqo02
         CALL s_errmsg('azp01,occ01,tqo02',g_showmsg,'sel tqo02','atm-256',1)
         LET g_success = 'N'
         MESSAGE g_tqo.tqo02,':sel:fail'
         CALL ui.Interface.refresh()
      END IF
      EXECUTE db_tqo1 USING g_tqo.*
      IF SQLCA.sqlcode = 0 THEN
         MESSAGE g_msg3,':ok'
         CALL ui.Interface.refresh()
      ELSE
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlcode = -239 THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
         #No.FUN-A80036  --End  
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'      #No.FUN-A80036
            ELSE
               #CHI-A60011 add --start--
               OPEN db_cs2_tqo_lock USING p_occ01_old,g_tqo.tqo03
               IF STATUS THEN
                  LET g_msg_x = p_azp01,':tqo_file:lock'
                  LET g_showmsg = g_tqo.tqo01,'/',g_tqo.tqo03
                  CALL s_errmsg('tqo01,tqo03',g_showmsg,g_msg_x,STATUS,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_tqo_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               FETCH db_cs2_tqo_lock INTO l_tqo_2.* 
               IF SQLCA.SQLCODE THEN
                  LET g_msg_x = p_azp01,':tqo_file:lock'
                  LET g_showmsg = g_tqo.tqo01,'/',g_tqo.tqo03
                  CALL s_errmsg('tqo01,tqo03',g_showmsg,g_msg_x,SQLCA.SQLCODE,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_tqo_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               #CHI-A60011 add --end--
               LET g_sql = "SELECT tqo05 FROM ",
                           #p_dbs_sep CLIPPED,"tqo_file ",
                           cl_get_target_table(p_azp01,'tqo_file'), #FUN-A50102
                           " WHERE tqo01='",p_occ01_old CLIPPED,"'",
                           "   AND tqo03=",g_tqo.tqo03
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		       CALL cl_parse_qry_sql(g_sql,p_azp01) RETURNING g_sql #FUN-A50102	            
               PREPARE tqo_p1 FROM g_sql
               EXECUTE tqo_p1 INTO g_tqo.tqo05
               IF cl_null(g_tqo.tqo05) THEN LET g_tqo.tqo05 = 0 END IF
               LET g_tqo.tqo05 = g_tqo.tqo05 + 1
               EXECUTE db_tqo2 USING g_tqo.*,p_occ01_old,g_tqo.tqo03
               IF SQLCA.sqlcode = 0 THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_tqo.tqo01,'/',g_tqo.tqo03
                  CALL s_errmsg('tqo01,tqo03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
               CLOSE db_cs2_tqo_lock  #CHI-A60011 add
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_tqo.tqo01,'/',g_tqo.tqo03
            CALL s_errmsg('tqo01,tqo03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_tqo.tqo01||'+'||g_tqo.tqo03,'4')
         CALL i221_tqm_part2(p_from,g_tqo.tqo02,p_tabname1,p_azp01,p_dbs_sep,m_gew05,m_gew07,m_tqm01,m_tqm06)
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION i221_tqm_gez()
 
   LET g_sql = " SELECT gez04,gez05 FROM gez_file ",
               "  WHERE gez01 = '",g_gev04 CLIPPED,"'",
               "    AND gez02 = '7'",
               "    AND gez03 = ?  "
   PREPARE gez_p1 FROM g_sql
   DECLARE gez_tqm_cur CURSOR WITH HOLD FOR gez_p1
 
END FUNCTION
 
FUNCTION i221_tqm_part1(p_azp01)
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE l_gew05         LIKE gew_file.gew05
   DEFINE l_gew07         LIKE gew_file.gew07
   DEFINE l_tqm01         LIKE tqm_file.tqm01
   DEFINE l_tqm06         LIKE tqm_file.tqm06
   DEFINE l_gez04         LIKE gez_file.gez04
   DEFINE l_gez05         LIKE gez_file.gez05
 
   SELECT gew05,gew07 INTO l_gew05,l_gew07 FROM gew_file
    WHERE gew01 = g_gev04
      AND gew02 = '7'
      AND gew04 = p_azp01
   IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF
 
   LET l_tqm01 = NULL
   LET l_tqm06 = NULL
   FOREACH gez_tqm_cur USING p_azp01 INTO l_gez04,l_gez05
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('gez03',p_azp01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF l_gez04 = 'tqm01'  THEN LET l_tqm01  = l_gez05 END IF
      IF l_gez04 = 'tqm06'  THEN LET l_tqm06  = l_gez05 END IF
   END FOREACH
   RETURN l_gew05,l_gew07,l_tqm01,l_tqm06
END FUNCTION
 
FUNCTION i221_tqm_part2(p_from,p_tqo01,p_tabname,p_azp01,p_dbs_sep,p_gew05,p_gew07,p_tqm01,p_tqm06)
   DEFINE p_from          LIKE type_file.chr3
   DEFINE p_tqo01         LIKE tqo_file.tqo01
   DEFINE p_tabname       LIKE type_file.chr50
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_dbs_sep       LIKE type_file.chr50
   DEFINE p_gew05         LIKE gew_file.gew05
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE p_tqm01         LIKE tqm_file.tqm01
   DEFINE p_tqm06         LIKE tqm_file.tqm06
   DEFINE l_tqm01_old     LIKE tqm_file.tqm01
   DEFINE l_tqm_2         RECORD LIKE tqm_file.* #CHI-A60011 add
   DEFINE l_tqn_2         RECORD LIKE tqn_file.* #CHI-A60011 add
 
   LET g_sql = " SELECT * FROM ",p_tabname CLIPPED,
               "  WHERE ",p_gew05 CLIPPED
   IF p_from = 'occ' THEN
      LET g_sql = g_sql CLIPPED," AND tqm01 = '",p_tqo01 CLIPPED,"'"
   END IF
   PREPARE carry_tqm_p1 FROM g_sql
   DECLARE carry_tqm_cur1 CURSOR WITH HOLD FOR carry_tqm_p1
 
 
   FOREACH carry_tqm_cur1 INTO g_tqm.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('tqm01',g_tqm.tqm01,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_tqm.tqm01,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_tqm.tqm01,':'
      LET l_tqm01_old = g_tqm.tqm01
      IF NOT cl_null(p_tqm01) THEN LET g_tqm.tqm01 = p_tqm01 END IF
      IF NOT cl_null(p_tqm06) THEN LET g_tqm.tqm06 = p_tqm06 END IF
      #tqm07,tqm08
      LET g_tqm.tqm07 = g_plant
      LET g_tqm.tqm08 = 1
      EXECUTE db_tqm1 USING g_tqm.*
      IF SQLCA.sqlcode = 0 THEN
         MESSAGE g_msg3,':ok'
         CALL ui.Interface.refresh()
      ELSE
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlcode = -239 THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
         #No.FUN-A80036  --End  
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'      #No.FUN-A80036
            ELSE
               #CHI-A60011 add --start--
               OPEN db_cs2_tqm_lock USING l_tqm01_old
               IF STATUS THEN
                  LET g_msg_x = p_azp01,':tqm_file:lock'
                  LET g_showmsg = g_tqm.tqm01
                  CALL s_errmsg('tqm01',g_showmsg,g_msg_x,STATUS,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_tqm_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               FETCH db_cs2_tqm_lock INTO l_tqm_2.* 
               IF SQLCA.SQLCODE THEN
                  LET g_msg_x = p_azp01,':tqm_file:lock'
                  LET g_showmsg = g_tqm.tqm01
                  CALL s_errmsg('tqm01',g_showmsg,g_msg_x,SQLCA.SQLCODE,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_tqm_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               #CHI-A60011 add --end--
               LET g_sql = "SELECT tqm08 FROM ",
                           #p_dbs_sep CLIPPED,"tqm_file ",
                           cl_get_target_table(p_azp01,'tqm_file'), #FUN-A50102
                           " WHERE tqm01='",g_tqm.tqm01 CLIPPED,"'"
               CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		       CALL cl_parse_qry_sql(g_sql,p_azp01) RETURNING g_sql #FUN-A50102	             
               PREPARE tqm_p1 FROM g_sql
               EXECUTE tqm_p1 INTO g_tqm.tqm08
               IF cl_null(g_tqm.tqm08) THEN LET g_tqm.tqm08 = 0 END IF
               LET g_tqm.tqm08 = g_tqm.tqm08 + 1
               EXECUTE db_tqm2 USING g_tqm.*,l_tqm01_old
               IF SQLCA.sqlcode = 0 THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_tqm.tqm01
                  CALL s_errmsg('tqm01',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
               CLOSE db_cs2_tqm_lock  #CHI-A60011 add
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_tqm.tqm01
            CALL s_errmsg('tqm01',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_tqm.tqm01,'7')
         #處理單身tqn的insert或是update
         FOREACH tqn_cur USING l_tqm01_old INTO g_tqn.*
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('tqn01',g_tqn.tqn01,'foreach',SQLCA.sqlcode,1)
               CONTINUE FOREACH
            END IF
            LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_tqm.tqm01,'+',g_tqn.tqn02,':'
            LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_tqm.tqm01,'+',g_tqn.tqn02,':'
            IF NOT cl_null(p_tqm01) THEN LET g_tqn.tqn01 = p_tqm01 END IF
            EXECUTE db_tqn1 USING g_tqn.*
            IF SQLCA.sqlcode = 0 THEN
               MESSAGE g_msg3,':ok'
               CALL ui.Interface.refresh()
            ELSE
               #No.FUN-A80036  --Begin
               #IF SQLCA.sqlcode = -239 THEN
               IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
               #No.FUN-A80036  --End  
                  IF p_gew07 = 'N' THEN
                     MESSAGE g_msg3,':exist'
                     CALL ui.Interface.refresh()
                     LET g_success = 'N'      #No.FUN-A80036
                  ELSE
                     #CHI-A60011 add --start--
                     OPEN db_cs2_tqn_lock USING l_tqm01_old,g_tqn.tqn02
                     IF STATUS THEN
                        LET g_msg_x = p_azp01,':tqn_file:lock'
                        LET g_showmsg = g_tqn.tqn01,"/",g_tqn.tqn02
                        CALL s_errmsg('tqn01,tqn02',g_showmsg,g_msg_x,STATUS,1)
                        MESSAGE g_msg4,':fail'
                        CALL ui.Interface.refresh()
                        CLOSE db_cs2_tqn_lock
                        LET g_success = 'N'
                        EXIT FOREACH
                     END IF
                     FETCH db_cs2_tqn_lock INTO l_tqn_2.* 
                     IF SQLCA.SQLCODE THEN
                        LET g_msg_x = p_azp01,':tqn_file:lock'
                        LET g_showmsg = g_tqn.tqn01,"/",g_tqn.tqn02
                        CALL s_errmsg('tqn01,tqn02',g_showmsg,g_msg_x,SQLCA.SQLCODE,1)
                        MESSAGE g_msg4,':fail'
                        CALL ui.Interface.refresh()
                        CLOSE db_cs2_tqn_lock
                        LET g_success = 'N'
                        EXIT FOREACH
                     END IF
                     #CHI-A60011 add --end--
                     EXECUTE db_tqn2 USING g_tqn.*,l_tqm01_old,g_tqn.tqn02
                     IF SQLCA.sqlcode = 0 THEN
                        MESSAGE g_msg4,':ok'
                        CALL ui.Interface.refresh()
                     ELSE
                        LET g_msg_x = p_azp01,':upd'
                        LET g_showmsg = g_tqn.tqn01,"/",g_tqn.tqn02
                        CALL s_errmsg('tqn01,tqn02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                        MESSAGE g_msg4,':fail'
                        CALL ui.Interface.refresh()
                        LET g_success = 'N'
                     END IF
                     CLOSE db_cs2_tqn_lock  #CHI-A60011 add
                  END IF
               ELSE
                  LET g_msg_x = p_azp01,':ins'
                  LET g_showmsg = g_tqn.tqn01,"/",g_tqn.tqn02
                  CALL s_errmsg('tqn01,tqn02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg3,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
            END IF
            #No.FUN-A80036  --Begin
            #IF SQLCA.sqlerrd[3] > 0 THEN
            IF g_success = 'Y' THEN
            #No.FUN-A80036  --End  
               CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_tqn.tqn01||'+'||g_tqn.tqn02,'7')
            END IF
         END FOREACH
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION i221_pov(p_occ01_old,p_occ01_new,p_azp01,p_gew07)
   DEFINE p_occ01_old     LIKE occ_file.occ01
   DEFINE p_occ01_new     LIKE occ_file.occ01
   DEFINE p_azp01         LIKE azp_file.azp01
   DEFINE p_gew07         LIKE gew_file.gew07
   DEFINE l_pov_2         RECORD LIKE pov_file.* #CHI-A60011 add
 
   FOREACH pov_cur USING p_occ01_old INTO g_pov.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('pov02',g_pov.pov02,'foreach',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      IF NOT cl_null(p_occ01_new) THEN LET g_pov.pov02 = p_occ01_new END IF
      LET g_msg3 = 'ins ',p_azp01 CLIPPED,':',g_pov.pov01,'+',g_pov.pov02,':'
      LET g_msg4 = 'upd ',p_azp01 CLIPPED,':',g_pov.pov01,'+',g_pov.pov02,':'
      EXECUTE db_pov1 USING g_pov.*
      IF SQLCA.sqlcode = 0 THEN
         MESSAGE g_msg3,':ok'
         CALL ui.Interface.refresh()
      ELSE
         #No.FUN-A80036  --Begin
         #IF SQLCA.sqlcode = -239 THEN
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
         #No.FUN-A80036  --End  
            IF p_gew07 = 'N' THEN
               MESSAGE g_msg3,':exist'
               CALL ui.Interface.refresh()
               LET g_success = 'N'      #No.FUN-A80036
            ELSE
               #CHI-A60011 add --start--
               OPEN db_cs2_pov_lock USING '1',p_occ01_old
               IF STATUS THEN
                  LET g_msg_x = p_azp01,':pov_file:lock'
                  LET g_showmsg = g_pov.pov01,'/',g_pov.pov02
                  CALL s_errmsg('pov01,pov02',g_showmsg,g_msg_x,STATUS,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_pov_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               FETCH db_cs2_pov_lock INTO l_pov_2.* 
               IF SQLCA.SQLCODE THEN
                  LET g_msg_x = p_azp01,':pov_file:lock'
                  LET g_showmsg = g_pov.pov01,'/',g_pov.pov02
                  CALL s_errmsg('pov01,pov02',g_showmsg,g_msg_x,SQLCA.SQLCODE,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  CLOSE db_cs2_pov_lock
                  LET g_success = 'N'
                  EXIT FOREACH
               END IF
               #CHI-A60011 add --end--
               EXECUTE db_pov2 USING g_pov.*,'1',p_occ01_old
               IF SQLCA.sqlcode = 0 THEN
                  MESSAGE g_msg4,':ok'
                  CALL ui.Interface.refresh()
               ELSE
                  LET g_msg_x = p_azp01,':upd'
                  LET g_showmsg = g_pov.pov01,'/',g_pov.pov02
                  CALL s_errmsg('pov01,pov02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                  MESSAGE g_msg4,':fail'
                  CALL ui.Interface.refresh()
                  LET g_success = 'N'
               END IF
               CLOSE db_cs2_pov_lock  #CHI-A60011 add
            END IF
         ELSE
            LET g_msg_x = p_azp01,':ins'
            LET g_showmsg = g_pov.pov01,'/',g_pov.pov02
            CALL s_errmsg('pov01,pov02',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
            MESSAGE g_msg3,':fail'
            CALL ui.Interface.refresh()
            LET g_success = 'N'
         END IF
      END IF
      #No.FUN-A80036  --Begin
      #IF SQLCA.sqlerrd[3] > 0 THEN
      IF g_success = 'Y' THEN
      #No.FUN-A80036  --End  
         CALL s_dc_carry_record(g_gev04,p_azp01,g_prog,g_pov.pov02||'+'||g_pov.pov01,'4')
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION s_axmi221_price_carry(p_occ01)
   DEFINE p_occ01    LIKE occ_file.occ01
   DEFINE l_i        LIKE type_file.num10
   DEFINE l_cnt      LIKE type_file.num10
   DEFINE l_occ1004  LIKE occ_file.occ1004
   DEFINE l_flag     LIKE type_file.chr1
 
   SELECT occ1004 INTO l_occ1004 FROM occ_file WHERE occ01=p_occ01
   IF l_occ1004 <> '1' THEN
      #不在確認狀態，不可異動！
      CALL cl_err('','atm-053',0)
      RETURN
   END IF
 
   DECLARE i221_tqo_curs CURSOR FOR
    SELECT 'N',tqo01,tqo02 FROM tqo_file
     WHERE tqo01 = p_occ01
   CALL g_tqo_1.clear()
   LET l_i = 1
   FOREACH i221_tqo_curs INTO g_tqo_1[l_i].*
      IF SQLCA.sqlcode THEN
         CALL cl_err('i221_tqo_curs',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF
      LET l_i = l_i + 1
   END FOREACH
   CALL g_tqo_1.deleteElement(l_i)
   LET l_cnt = l_i - 1
 
   OPEN WINDOW i221_1_w AT 6,26 WITH FORM "axm/42f/axmi221_s"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_locale("axmi221_s")
 
   DISPLAY ARRAY g_tqo_1 TO s_tqo.* ATTRIBUTE(COUNT=l_cnt,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
   END DISPLAY
 
   CALL cl_set_act_visible("accept", TRUE)
   INPUT ARRAY g_tqo_1 WITHOUT DEFAULTS FROM s_tqo.*
         ATTRIBUTE(COUNT=l_cnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
      ON ACTION select_all
         CALL i221_sel_all("Y")
 
      ON ACTION select_non
         CALL i221_sel_all("N")
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END INPUT
   IF INT_FLAG THEN
      CLOSE WINDOW i221_1_w
      RETURN
   END IF
 
   CLOSE WINDOW i221_1_w
 
   LET g_rec_b1 = l_cnt
   LET l_flag = 'N'
   FOR l_i = 1 TO g_rec_b1
       IF g_tqo_1[l_i].sel = 'Y' THEN
          LET l_flag = 'Y'
          EXIT FOR
       END IF
   END FOR
   IF l_flag = 'N' THEN
      RETURN
   END IF
 
   LET g_gev04 = NULL
   #是否為資料中心的拋轉DB
   SELECT gev04 INTO g_gev04 FROM gev_file
    WHERE gev01 = '4' AND gev02 = g_plant
      AND gev03 = 'Y' 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gev04,'aoo-036',1)
      RETURN
   END IF
 
   IF cl_null(g_gev04) THEN RETURN END IF
 
   #開窗選擇拋轉的db清單
   CALL s_dc_sel_db(g_gev04,'4')
   IF INT_FLAG THEN
      LET INT_FLAG=0
      RETURN
   END IF
 
   LET g_flag = '1'
   LET g_occ_1[1].sel = 'Y'
   LET g_occ_1[1].occ01 = p_occ01
 
   CALL s_showmsg_init()
   CALL s_axmi221_carry_tqo('1')
   CALL s_showmsg()
 
END FUNCTION
 
FUNCTION i221_sel_all(p_value)
   DEFINE p_value   LIKE type_file.chr1
   DEFINE l_i       LIKE type_file.num10
 
   FOR l_i = 1 TO g_tqo_1.getLength()
       LET g_tqo_1[l_i].sel = p_value
   END FOR
 
END FUNCTION
 
FUNCTION s_axmi221_price_carry_1(p_occ01,p_tqo,p_azp,p_gev04,p_flagx)  #No.FUN-830090
   DEFINE p_occ01              LIKE occ_file.occ01
   DEFINE p_tqo                DYNAMIC ARRAY OF RECORD
                               sel      LIKE type_file.chr1,
                               tqo01    LIKE tqo_file.tqo01,
                               tqo02    LIKE tqo_file.tqo02
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
 
   IF cl_null(p_occ01) THEN RETURN END IF
 
   LET g_flagx = p_flagx     #No.FUN-830090  0.carry  1.upload
   IF g_flagx <> '1' THEN
      IF p_tqo.getLength() = 0 THEN RETURN END IF
   END IF
 
   IF p_azp.getLength() = 0 THEN                                                                                                    
      CALL cl_err('','aoo-068',0)                                                                                                   
      RETURN                                                                                                                        
   END IF                                                                                                                           
   LET g_flag = '1'
 
   #前置准備
 
   FOR l_i = 1 TO p_tqo.getLength()
       LET g_tqo_1[l_i].* = p_tqo[l_i].*
   END FOR
   FOR l_i = 1 TO p_azp.getLength()
       LET g_azp[l_i].* = p_azp[l_i].*
   END FOR
   LET g_gev04 = p_gev04
 
   LET g_occ_1[1].sel = 'Y'
   LET g_occ_1[1].occ01 = p_occ01
 
   CALL s_axmi221_carry_tqo('2')
 
END FUNCTION
 
FUNCTION s_axmi221_carry_tqo(p_flag)
   DEFINE p_flag               LIKE type_file.chr1
   DEFINE l_i                  LIKE type_file.num10
   DEFINE l_j                  LIKE type_file.num10
   DEFINE l_cnt                LIKE type_file.num10
   DEFINE l_tabname            LIKE type_file.chr50
   DEFINE l_tabname1           LIKE type_file.chr50
   DEFINE l_gew05              LIKE gew_file.gew05
   DEFINE l_gew07              LIKE gew_file.gew07
   DEFINE l_dbs_sep            LIKE type_file.chr50
   DEFINE l_gez04              LIKE gez_file.gez04
   DEFINE l_gez05              LIKE gez_file.gez05
   DEFINE m_gew05              LIKE gew_file.gew05
   DEFINE m_gew07              LIKE gew_file.gew07
   DEFINE m_tqm01              LIKE tqm_file.tqm01
   DEFINE m_tqm06              LIKE tqm_file.tqm06
   DEFINE l_gew08              LIKE gew_file.gew08     #for mail
  #DEFINE l_hist_tab           LIKE type_file.chr50    #for mail #CHI-A60011 mark
   DEFINE l_hs_flag            LIKE type_file.chr1     #for mail
   DEFINE l_hs_path            LIKE ze_file.ze03       #for mail
   DEFINE l_tqo_upd            LIKE type_file.chr1     #no.FUN-840068 add
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF g_tqo_1.getLength() = 0 THEN RETURN END IF
   IF g_azp.getLength() = 0 THEN RETURN END IF
   #LET l_tqo_upd = 'N'    #No.FUN-840068 add   #No.FUN-A80036
 
   #定義cursor
   CALL s_carry_p_cs()
 
   CALL i221_tqm_gez()
 
   #組column
   CALL i221_get_tqo_column()
 
   #建立臨時表,用于存放拋轉的資料
   CALL s_axmi221_carry_p1() RETURNING l_tabname
   CALL s_axmi221_tqm_carry_p1('occ') RETURNING l_tabname1
 
   #建立歷史資料拋轉的臨時表
   CALL s_dc_cre_temp_table("gex_file") RETURNING l_hist_tab
 
   #occ對應單身occg_file拋轉的cursor定義
   CALL i221_tqo_body()
 
   FOR l_j = 1 TO g_azp.getLength()
       IF cl_null(g_azp[l_j].azp03) THEN CONTINUE FOR END IF
       IF g_azp[l_j].sel = 'N' THEN CONTINUE FOR END IF
       SELECT gew05,gew07,gew08 INTO l_gew05,l_gew07,l_gew08 FROM gew_file
        WHERE gew01 = g_gev04
          AND gew02 = '4'
          AND gew04 = g_azp[l_j].azp01
 
       IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF
 
       #mail_1
       CALL s_dc_carry_send_mail_1(g_azp[l_j].azp01,l_j,g_gev04,'4',l_hist_tab)
            RETURNING l_hs_flag,l_hs_path
 
       #當前營運中心,滿足aooi602拋轉條件的筆數
       LET g_cur_cnt = 0
       LET g_sql = " SELECT COUNT(*) FROM ",l_tabname CLIPPED,
                   "  WHERE ",l_gew05 CLIPPED
       PREPARE cnt_p2 FROM g_sql
       EXECUTE cnt_p2 INTO g_cur_cnt
       IF cl_null(g_cur_cnt) THEN LET g_cur_cnt = 0 END IF
       IF g_all_cnt <> g_cur_cnt THEN   #aooi602中有設置,部分資料不滿足拋轉
          LET g_showmsg = g_azp[l_j].azp01,"/",g_tqo_1.getLength() USING "<<<<&","/",g_cur_cnt USING "<<<<&"
          CALL s_errmsg("azp01,all_cnt,cur_cnt",g_showmsg,"cnt_p2","aoo-049",1)
       END IF
       IF g_cur_cnt = 0 THEN
          CONTINUE FOR
       END IF
 
       CALL s_dbstring(g_azp[l_j].azp03) RETURNING l_dbs_sep
       #CALL i221_ins_upd_tqo_body(l_dbs_sep)
       CALL i221_ins_upd_tqo_body(g_azp[l_j].azp01)  #FUN-A50102
 
       #tqm/tqn相關內容
       CALL i221_tqm_part1(g_azp[l_j].azp01) RETURNING m_gew05,m_gew07,m_tqm01,m_tqm06
 
       LET l_tqo_upd = 'N'    #No.FUN-A80036
       FOR l_i = 1 TO g_tqo_1.getLength()
           IF cl_null(g_tqo_1[l_i].tqo02) THEN CONTINUE FOR END IF
           IF g_tqo_1[l_j].sel = 'N' THEN CONTINUE FOR END IF
 
           LET g_success = 'Y'
           BEGIN WORK
           SELECT * INTO g_tqo.* FROM tqo_file WHERE tqo01 = g_occ_1[1].occ01
                                                 AND tqo02 = g_tqo_1[l_i].tqo02
 
           #check tqo02是否在tqm_file中存在
           LET g_flag1 = '0'
           #CALL s_axmi221_check_tqo02(l_dbs_sep,g_tqo.tqo02)
           #No.FUN-A80036  --Begin
           #CALL s_axmi221_check_tqo02(g_azp[l_j].azp01,g_tqo.tqo02)  #FUN-A50102
           CALL s_axmi221_check_tqo02(g_plant,g_tqo.tqo02)  #FUN-A50102
           #No.FUN-A80036  --End  
                RETURNING g_flag1
           IF g_flag1 = '1' THEN
              LET g_showmsg = g_azp[l_j].azp01,'/',g_tqo.tqo01,'/',g_tqo.tqo02
              CALL s_errmsg('azp01,tqo01,tqo02',g_showmsg,'sel tqo02','atm-256',1)
              LET g_success = 'N'
              MESSAGE g_tqo.tqo02,':sel:fail'
              CALL ui.Interface.refresh()
           END IF
           LET g_msg3 = 'ins ',g_azp[l_j].azp03 CLIPPED,':',g_occ_1[1].occ01,'+',g_tqo_1[l_i].tqo02,':'
           LET g_msg4 = 'upd ',g_azp[l_j].azp03 CLIPPED,':',g_occ_1[1].occ01,'+',g_tqo_1[l_i].tqo02,':'
 
           LET g_tqo.tqo04 = g_plant
           LET g_tqo.tqo05 = 1
           EXECUTE db_tqo1 USING g_tqo.*
           IF SQLCA.sqlcode = 0 THEN
              MESSAGE g_msg3,':ok'
              #LET l_tqo_upd = 'Y'   #NO.FUN-840068 add   #No.FUN-A80036
              CALL ui.Interface.refresh()
           ELSE
              #No.FUN-A80036  --Begin
              #IF SQLCA.sqlcode = -239 THEN
              IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
              #No.FUN-A80036  --End  
                 IF l_gew07 = 'N' THEN
                     MESSAGE g_msg3,':exist'
                     #LET l_tqo_upd = 'N'   #NO.FUN-840068 add   #No.FUN-A80036
                     LET g_success = 'N'    #No.FUN-A80036
                     CALL ui.Interface.refresh()
                 ELSE
                    LET g_sql = "SELECT tqo05 FROM ",
                                 #l_dbs_sep CLIPPED,"tqo_file ",
                                 cl_get_target_table(g_azp[l_j].azp01,'tqo_file'), #FUN-A50102
                                " WHERE tqo01='",g_occ_1[1].occ01 CLIPPED,"'",
                                "   AND tqo02='",g_tqo.tqo02,"'"
                    CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		            CALL cl_parse_qry_sql(g_sql,g_azp[l_j].azp01) RETURNING g_sql #FUN-A50102	            
                    PREPARE tqo_p2 FROM g_sql
                    EXECUTE tqo_p2 INTO g_tqo.tqo05
                    IF cl_null(g_tqo.tqo05) THEN LET g_tqo.tqo05 = 0 END IF
                    LET g_tqo.tqo05 = g_tqo.tqo05 + 1
                    EXECUTE db_tqo2 USING g_tqo.*,g_occ_1[1].occ01,g_tqo.tqo03
                    IF SQLCA.sqlcode = 0 THEN
                       MESSAGE g_msg4,':ok'
                       #LET l_tqo_upd = 'Y'         #NO.FUN-840068 add   #No.FUN-A80036
                       CALL ui.Interface.refresh()
                    ELSE
                       LET g_msg_x = g_azp[l_j].azp01,':upd'
                       LET g_showmsg = g_tqo.tqo01,'/',g_tqo.tqo03
                           CALL s_errmsg('tqo01,tqo03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                           MESSAGE g_msg4,':fail'
                           #LET l_tqo_upd = 'N'     #NO.FUN-840068 add   #No.FUN-A80036
                           CALL ui.Interface.refresh()
                           LET g_success = 'N'
                    END IF
                 END IF
              ELSE
                 LET g_msg_x = g_azp[l_j].azp01,':ins'
                 LET g_showmsg = g_tqo.tqo01,'/',g_tqo.tqo03
                 CALL s_errmsg('tqo01,tqo03',g_showmsg,g_msg_x,SQLCA.sqlcode,1)
                 MESSAGE g_msg3,':fail'
                 #LET l_tqo_upd = 'N'        #no.FUN-840068 add   #No.FUN-A80036
                 CALL ui.Interface.refresh()
                 LET g_success = 'N'
              END IF
           END IF
           #No.FUN-A80036  --Begin
           #IF SQLCA.sqlerrd[3] > 0 THEN
           IF g_success = 'Y' THEN
           #No.FUN-A80036  --End  
              CALL s_dc_carry_record(g_gev04,g_azp[l_j].azp01,g_prog,g_tqo.tqo01||'+'||g_tqo.tqo03,'4')
              IF p_flag = '1' THEN
                 CALL i221_tqm_part2('occ',g_tqo.tqo02,l_tabname1,g_azp[l_j].azp01,l_dbs_sep,m_gew05,m_gew07,m_tqm01,m_tqm06)
              END IF
           END IF
           IF g_success = 'N' THEN
              #LET l_tqo_upd = 'N'     #no.FUN-840068 add   #No.FUN-A80036
              ROLLBACK WORK
           ELSE
              LET l_tqo_upd = 'Y'     #NO.FUN-840068 add
              COMMIT WORK
           END IF
       END FOR
       #mail 2
       IF l_tqo_upd = 'Y' THEN  #no.FUN-840033 add
           CALL s_dc_carry_send_mail_2(l_hs_flag,l_gew08,l_hs_path,l_hist_tab)
       END IF                   #no.FUN-840068 add
   END FOR
 
   CALL s_dc_drop_temp_table(l_tabname)
   CALL s_dc_drop_temp_table(l_tabname1)
   CALL s_dc_drop_temp_table(l_hist_tab)
 
  #MESSAGE 'Data Carry Finish!'   #TQC-C50259 mark
  #TQC-C50259 -- add -- begin
   IF l_tqo_upd = 'Y' THEN
      CALL cl_err('','aim-162',0)
   END IF
  #TQC-C50259 -- add -- end
   CALL ui.Interface.refresh()
 
END FUNCTION
 
#FUNCTION s_axmi221_check_tqo02(p_dbs_sep,p_tqo02)
FUNCTION s_axmi221_check_tqo02(p_plant_sep,p_tqo02)  #FUN-A50102
   DEFINE p_plant_sep          LIKE type_file.chr21  #FUN-A50102
   #DEFINE p_dbs_sep            LIKE type_file.chr50
   DEFINE p_tqo02              LIKE tqo_file.tqo02
   DEFINE l_cnt                LIKE type_file.num5
 
   #LET g_sql = "SELECT COUNT(*) FROM ",p_dbs_sep CLIPPED,"tqm_file",
   LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant_sep,'tqm_file'), #FUN-A50102
               " WHERE tqm01 = '",p_tqo02,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant_sep) RETURNING g_sql #FUN-A50102
   PREPARE tqo02_p1 FROM g_sql
   EXECUTE tqo02_p1 INTO l_cnt
 
   IF l_cnt = 0 THEN
      RETURN '1'
   ELSE
      RETURN '0'
   END IF
 
END FUNCTION
 
 
 
#axmi250的邏輯
FUNCTION i250_dbs(p_occa)
   DEFINE p_occa        RECORD LIKE occa_file.* #No.FUN-7C0010
   DEFINE l_ans         LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01)
          l_exit_sw     LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_c,l_s,i     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          l_cnt         LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_check       LIKE type_file.chr1    #CHI-A60035 add
   DEFINE l_gew03       LIKE gew_file.gew03    #CHI-A60035 add 
   DEFINE l_gev04       LIKE gev_file.gev04    #CHI-A60035 add
   DEFINE l_flag        LIKE type_file.chr1    #CHI-A60035 add
 
   LET g_occa.* = p_occa.*
#MOD-C50098 mark begin 
#   IF g_occa.occa1004='2' THEN
#       #已拋轉，不可再異動!
#       CALL cl_err(g_occa.occano,'axm-225',1)
#       LET g_success = 'N'
#       RETURN
#   END IF 
#MOD-C50098 mark end
 
   #IF g_occa.occa1004!='1'  THEN #MOD-C50098
   IF g_occa.occa1004 NOT MATCHES '[12]' THEN 
       #不在確認狀態，不可異動！
       CALL cl_err('','atm-053',0)
       RETURN
   END IF
 
   IF s_shut(0) THEN RETURN END IF
 
   CALL tm.clear()
   LET g_gev04 = NULL
   #是否為資料中心的拋轉DB
   SELECT gev04 INTO g_gev04 FROM gev_file 
    WHERE gev01 = '4' AND gev02 = g_plant
      AND gev03 = 'Y'
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_gev04,'aoo-036',1)
      RETURN
   END IF
   CALL s_showmsg_init()
   CALL axmi250_s_carry_data()   #No.FUN-830090
   IF INT_FLAG THEN
       LET INT_FLAG = 0
       RETURN
   END IF

   #CHI-A60035 add --start--
   LET l_check = 'N' 
   FOR i = 1 TO tm.getLength()
       IF tm[i].sel = 'Y' THEN
          LET l_check = 'Y'
          EXIT FOR
       END IF
   END FOR

   SELECT gev04 INTO l_gev04 FROM gev_file
    WHERE gev01 = '4' and gev02 = g_plant
   SELECT UNIQUE gew03 INTO l_gew03 FROM gew_file
    WHERE gew01 = l_gev04
      AND gew02 = '4'
   #chech是否所有營運中心皆己存在此料號拋轉
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
       IF NOT cl_confirm('anm-929') THEN RETURN END IF    #是否確定拋轉以上資料?
   END IF              
   IF l_gew03 = '3' AND l_check ='N' AND l_flag = 'Y' THEN
      CALL cl_err('','aim-505',1)
      RETURN
   END IF
   IF l_check = 'N' AND l_flag = 'N' THEN
       CALL cl_err('','aim1009',1)
       RETURN   #MOD-B70276
   END IF 
   LET l_flag = ' '
   #CHI-A60035 add --end--
   #IF NOT cl_confirm('anm-929') THEN RETURN END IF    #是否確定拋轉以上資料?  #CHI-A60035 mark

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
      IF g_occa.occa00 = 'I' THEN  #MOD-A50071 AND g_success='Y' THEN   #MOD-840117 modify g_success='Y'
         CALL i250_dbs_ins() #新增
      ELSE
         CALL i250_dbs_upd() #修改
      END IF
   END IF   #MOD-A50071
   IF g_success = 'Y' THEN
       #更新狀況碼
       UPDATE occa_file
          SET occa1004 = '2' #已拋轉
        WHERE occano = g_occa.occano
       IF SQLCA.sqlcode OR sqlca.sqlerrd[3] <= 0 THEN
           #狀況碼更新不成功
           CALL cl_get_feldname('occa1004',g_lang) RETURNING g_msg
           CALL cl_err(g_msg,'lib-030',1)
           LET g_success = 'N'
       END IF
   END IF
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_cmmsg(4)
   ELSE
      ROLLBACK WORK
      CALL cl_rbmsg(4)
   END IF
   CALL s_dc_drop_temp_table(l_hist_tab)   #CHI-A60011 add
   CALL s_showmsg() #CHI-A60011 add
   SELECT * INTO g_occa.* FROM occa_file WHERE occano = g_occa.occano
END FUNCTION
 
FUNCTION i250_dbs_ins()
   DEFINE l_occa        RECORD LIKE occa_file.*  #061113
   DEFINE i             LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_gew08              LIKE gew_file.gew08     #for mail
  #DEFINE l_hist_tab           LIKE type_file.chr50    #for mail #CHI-A60011 mark
   DEFINE l_hs_flag            LIKE type_file.chr1     #for mail
   DEFINE l_hs_path            LIKE ze_file.ze03       #for mail
   DEFINE l_j                  LIKE type_file.num10
   DEFINE l_gew05              LIKE gew_file.gew05
   DEFINE l_gew07              LIKE gew_file.gew07
   DEFINE l_all_cnt            LIKE type_file.num5    
   DEFINE l_cur_cnt            LIKE type_file.num5
   DEFINE l_occa_ins           LIKE type_file.chr1     #NO.FUN-840068 add
   DEFINE l_value1             LIKE type_file.chr30   #CHI-CB0017 add
   DEFINE l_value2             LIKE type_file.chr30   #CHI-CB0017 add 
 
   MESSAGE ' COPY FOR INSERT .... '
 
  #讀取相關資料..........................................
   #061113---str
   SELECT * INTO l_occa.* FROM occa_file
    WHERE occano = g_occa.occano
   IF STATUS THEN
       CALL cl_err(g_msg,SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
   END IF
   LET l_occa_ins = 'N'    #no.FUN-840068 add
 
   FOR i = 1 TO tm.getLength()   #CHI-870044
       #建立歷史資料拋轉的臨時表
      #CALL s_dc_cre_temp_table("gex_file") RETURNING l_hist_tab  #CHI-A60011 mark
       IF cl_null(tm[i].azp03) THEN CONTINUE FOR END IF
       IF tm[i].sel = 'N' THEN CONTINUE FOR END IF
 
       SELECT gew05,gew07,gew08 INTO l_gew05,l_gew07,l_gew08 FROM gew_file
        WHERE gew01 = g_gev04
          AND gew02 = '4'
          AND gew04 = tm[i].azp01
       IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF
 
       #mail_1                                                              
       CALL s_dc_carry_send_mail_1(tm[i].azp01,i,g_gev04,'4',l_hist_tab)
        RETURNING l_hs_flag,l_hs_path
       IF cl_null(tm[i].azp03) OR tm[i].sel= 'N' THEN  CONTINUE FOR END IF
       LET tm[i].azp03 = s_dbstring(tm[i].azp03 CLIPPED)           #No.TQC-970389
       #LET g_sql='INSERT INTO ',tm[i].azp03 CLIPPED,'occ_file(',   #No.TQC-970389 
       LET g_sql='INSERT INTO ',cl_get_target_table(tm[i].azp01,'occ_file'),'(',  #FUN-A50102       
 ' occ01  ,',
 ' occ02  ,',
 ' occ03  ,',
 ' occ04  ,',
 ' occ05  ,',
 ' occ06  ,',
 ' occ07  ,',
 ' occ08  ,',
 ' occ09  ,',
 ' occ10  ,',
 ' occ11  ,',
 ' occ12  ,',
 ' occ13  ,',
 ' occ14  ,',
 ' occ15  ,',
 ' occ16  ,',
 ' occ171 ,',
 ' occ172 ,',
 ' occ173 ,',
 ' occ174 ,',
 ' occ175 ,',
 ' occ18  ,',
 ' occ19  ,',
 ' occ20  ,',
 ' occ21  ,',
 ' occ22  ,',
 ' occ231 ,',
 ' occ232 ,',
 ' occ233 ,',
 ' occ241 ,',
 ' occ242 ,',
 ' occ243 ,',
 ' occ261 ,',
 ' occ262 ,',
 ' occ263 ,',
 ' occ271 ,',
 ' occ272 ,',
 ' occ273 ,',
 ' occ28  ,',
 ' occ29  ,',
 ' occ292 ,',
 ' occ30  ,',
 ' occ302 ,',
 ' occ31  ,',
 ' occ32  ,',
 ' occ33  ,',
 ' occ34  ,',
 ' occ35  ,',
 ' occ36  ,',
 ' occ37  ,',
 ' occ38  ,',
 ' occ39  ,',
 ' occ39a ,',
 ' occ40  ,',
 ' occ41  ,',
 ' occ42  ,',
 ' occ43  ,',
 ' occ44  ,',
 ' occ45  ,',
 ' occ46  ,',
 ' occ47  ,',
 ' occ48  ,',
 ' occ49  ,',
 ' occ50  ,',
 ' occ51  ,',
 ' occ52  ,',
 ' occ53  ,',
 ' occ55  ,',
 ' occ56  ,',
 ' occ57  ,',
 ' occ61  ,',
 ' occ62  ,',
 ' occ63  ,',
 ' occ631 ,',
 ' occ64  ,',
 ' occ68  ,',    #FUN-B30044  add
 ' occ69  ,',    #FUN-B30044  add
 ' occ701 ,',
 ' occ702 ,',
 ' occ703 ,',
 ' occ704 ,',
 ' occacti,',
 ' occuser,',
 ' occgrup,',
 ' occmodu,',
 ' occdate,',
 ' occ65  ,',
#' occ1001,',    #MOD-CC0094 mark
#' occ1002,',    #MOD-CC0094 mark
 ' occ1003,',
 ' occ1004,',
 ' occ1005,',
 ' occ1006,',
 ' occ1007,',
 ' occ1008,',
 ' occ1009,',
 ' occ1010,',
 ' occ1011,',
 ' occ1012,',
 ' occ1013,',
 ' occ1014,',
 ' occ1015,',    #No.TQC-A90092
 ' occ1016,',
 ' occ1017,',
 ' occ1018,',
 ' occ1019,',
 ' occ1020,',
 ' occ1021,',
 ' occ1022,',
 ' occ1023,',
 ' occ1024,',
 ' occ1025,',
 ' occ1026,',
 ' occ1027,',
 ' occ1028,',
 ' occud01,',
 ' occud02,',
 ' occud03,',
 ' occud04,',
 ' occud05,',
 ' occud06,',
 ' occud07,',
 ' occud08,',
 ' occud09,',
 ' occud10,',
 ' occud11,',
 ' occud12,',
 ' occud13,',
 ' occud14,',
 ' occud15,',
 ' occ66  ,',
 ' occ1029,',
 ' occ246 ,',  #No.MOD-840392
 ' occ71  ,',  #TQC-A40128  ADD
 ' occpos ,',  #TQC-A40128  ADD
 ' occ67,occoriu,occorig  )',   #FUN-A10036
 ' VALUES(',
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #10
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #20
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #30
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #40
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #50
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #60
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #70
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #80
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #90
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #100
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #110
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #120
 ' ?,?,?,?,?,  ?,?,?,?,?, ', #130
 ' ?,?,?,?,?,  ?  )'  #TQC-A40128  #FUN-A10036                 #132  #No.MOD-840392   #FUN-B30044 add two ?   #MOD-CC0094 remove ,?,?
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	   CALL cl_parse_qry_sql(g_sql,tm[i].azp01) RETURNING g_sql #FUN-A50102	
       PREPARE ins_occ FROM g_sql
       EXECUTE ins_occ USING
    l_occa.occa01    ,
    l_occa.occa02    ,
    l_occa.occa03    ,
    l_occa.occa04    ,
    l_occa.occa05    ,
    l_occa.occa06    ,
    l_occa.occa07    ,
    l_occa.occa08    ,
    l_occa.occa09    ,
    l_occa.occa10    ,
    l_occa.occa11    ,
    l_occa.occa12    ,
    l_occa.occa13    ,
    l_occa.occa14    ,
    l_occa.occa15    ,
    l_occa.occa16    ,
    l_occa.occa171   ,
    l_occa.occa172   ,
    l_occa.occa173   ,
    l_occa.occa174   ,
    l_occa.occa175   ,
    l_occa.occa18    ,
    l_occa.occa19    ,
    l_occa.occa20    ,
    l_occa.occa21    ,
    l_occa.occa22    ,
    l_occa.occa231   ,
    l_occa.occa232   ,
    l_occa.occa233   ,
    l_occa.occa241   ,
    l_occa.occa242   ,
    l_occa.occa243   ,
    l_occa.occa261   ,
    l_occa.occa262   ,
    l_occa.occa263   ,
    l_occa.occa271   ,
    l_occa.occa272   ,
    l_occa.occa273   ,
    l_occa.occa28    ,
    l_occa.occa29    ,
    l_occa.occa292   ,
    l_occa.occa30    ,
    l_occa.occa302   ,
    l_occa.occa31    ,
    l_occa.occa32    ,
    l_occa.occa33    ,
    l_occa.occa34    ,
    l_occa.occa35    ,
    l_occa.occa36    ,
    l_occa.occa37    ,
    l_occa.occa38    ,
    l_occa.occa39    ,
    l_occa.occa39a   ,
    l_occa.occa40    ,
    l_occa.occa41    ,
    l_occa.occa42    ,
    l_occa.occa43    ,
    l_occa.occa44    ,
    l_occa.occa45    ,
    l_occa.occa46    ,
    l_occa.occa47    ,
    l_occa.occa48    ,
    l_occa.occa49    ,
    l_occa.occa50    ,
    l_occa.occa51    ,
    l_occa.occa52    ,
    l_occa.occa53    ,
    l_occa.occa55    ,
    l_occa.occa56    ,
    l_occa.occa57    ,
    l_occa.occa61    ,
    l_occa.occa62    ,
    l_occa.occa63    ,
    l_occa.occa631   ,
    l_occa.occa64    ,
    l_occa.occa68    ,     #FUN-B30044  add
    l_occa.occa69    ,     #FUN-B30044  add
    l_occa.occa701   ,
    l_occa.occa702   ,
    l_occa.occa703   ,
    l_occa.occa704   ,
    l_occa.occaacti  ,
     g_user,   #資料所有者
     g_grup,   #資料所有部門
     '',       #資料修改者
     g_today,  #最近修改日
    l_occa.occa65    ,
   #l_occa.occa1001  ,     #MOD-CC0094 mark
   #l_occa.occa1002  ,     #MOD-CC0094 mark
    l_occa.occa1003  ,
    l_occa.occa1004  ,
    l_occa.occa1005  ,
    l_occa.occa1006  ,
    l_occa.occa1007  ,
    l_occa.occa1008  ,
    l_occa.occa1009  ,
    l_occa.occa1010  ,
    l_occa.occa1011  ,
    l_occa.occa1012  ,
    l_occa.occa1013  ,
    l_occa.occa1014  ,
    l_occa.occa1015  ,
    l_occa.occa1016  ,
    l_occa.occa1017  ,
    l_occa.occa1018  ,
    l_occa.occa1019  ,
    l_occa.occa1020  ,
    l_occa.occa1021  ,
    l_occa.occa1022  ,
    l_occa.occa1023  ,
    l_occa.occa1024  ,
    l_occa.occa1025  ,
    l_occa.occa1026  ,
    l_occa.occa1027  ,
    l_occa.occa1028  ,
    l_occa.occaud01  ,
    l_occa.occaud02  ,
    l_occa.occaud03  ,
    l_occa.occaud04  ,
    l_occa.occaud05  ,
    l_occa.occaud06  ,
    l_occa.occaud07  ,
    l_occa.occaud08  ,
    l_occa.occaud09  ,
    l_occa.occaud10  ,
    l_occa.occaud11  ,
    l_occa.occaud12  ,
    l_occa.occaud13  ,
    l_occa.occaud14  ,
    l_occa.occaud15  ,
    l_occa.occa66    ,
    l_occa.occa1029  ,
    g_plant          ,   #No.MOD-840392
    '1'              ,   #TQC-A40128 ADD
    '1'              ,   #TQC-A40128 ADD #FUN-B40071
    l_occa.occa67,g_user,g_grup #FUN-A10036
 
#-------------------- COPY FILE ------------------------------
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           #LET g_msg = 'INSERT ',s_dbstring(tm[i].azp03 CLIPPED),'occ_file'
           LET g_msg = 'INSERT ',cl_get_target_table(tm[i].azp01,'occ_file') #FUN-A50102
           CALL cl_err(g_msg,'lib-028',1)
           LET g_success = 'N'
           LET l_occa_ins = 'N'   #NO.FUN-840068 add 
           EXIT FOR
       ELSE
           CALL s_upd_abbr(l_occa.occa01,l_occa.occa02,tm[i].azp01,'2','Y','a')  #No.FUN-BB0049
           CALL i250_ins_imab(tm[i].azp03) #新增主檔拋轉記錄檔
           CALL s_dc_carry_record(g_gev04,tm[i].azp01,g_prog,g_occa.occa01,'4')  #NO.FUN840018 add
           IF g_success = 'N' THEN EXIT FOR END IF
           LET l_occa_ins = 'Y'   #no.FUN-840068 add
       END IF
       #mail 2                                      
       IF l_occa_ins = 'Y' THEN     #NO.FUN-840033 add                            
          CALL s_dc_carry_send_mail_2(l_hs_flag,l_gew08,l_hs_path,l_hist_tab)
          #CHI-CB0017 add begin---
          LET l_value1 = g_occa.occano
          LET l_value2 = g_occa.occa01
          CALL s_data_transfer(tm[i].azp01,'2',g_prog,l_value1,l_value2,'','','')
          #CHI-CB0017 add end-----
       END IF                       #NO.FUN-840068 add
   END FOR
  #CALL s_dc_drop_temp_table(l_hist_tab) #CHI-A60011 mark
 
  #MESSAGE 'Data Carry Finish!'   #TQC-C50259 mark
  #TQC-C50259 -- add -- begin
   IF l_occa_ins = 'Y' THEN
      CALL cl_err('','aim-162',0)
   END IF
  #TQC-C50259 -- add -- end
   CALL ui.Interface.refresh()
 
END FUNCTION
 
FUNCTION i250_dbs_upd()
   DEFINE l_occg        RECORD LIKE occg_file.*,
          l_ocd         RECORD LIKE ocd_file.*,
          l_oce         RECORD LIKE oce_file.*,
          l_occa        RECORD LIKE occa_file.*,
          l_oci         RECORD LIKE oci_file.*,
          l_ocj         RECORD LIKE ocj_file.*,
          l_tqk         RECORD LIKE tqk_file.*,
          l_tqo         RECORD LIKE tqo_file.*,
          l_tql         RECORD LIKE tql_file.*,
          l_c,l_s,i     LIKE type_file.num5,    #No.FUN-680137 SMALLINT
         #l_sql         LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(9000) #CHI-A80050 mark
          l_sql         STRING,  #CHI-A80050
          l_cnt         LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_gew08              LIKE gew_file.gew08     #for mail
  #DEFINE l_hist_tab           LIKE type_file.chr50    #for mail #CHI-A60011 mark
   DEFINE l_hs_flag            LIKE type_file.chr1     #for mail
   DEFINE l_hs_path            LIKE ze_file.ze03       #for mail
   DEFINE l_j                  LIKE type_file.num10
   DEFINE l_gew05              LIKE gew_file.gew05
   DEFINE l_gew07              LIKE gew_file.gew07
   DEFINE l_all_cnt            LIKE type_file.num5    
   DEFINE l_cur_cnt            LIKE type_file.num5
   DEFINE l_occa_upd           LIKE type_file.chr1    #NO.FUN-840068 add
   DEFINE l_occ02_t            LIKE occ_file.occ02    #No.FUN-A30110
   DEFINE l_occ_2       RECORD LIKE occ_file.* #CHI-A60011 add
   DEFINE l_value1             LIKE type_file.chr30   #CHI-CB0017 add
   DEFINE l_value2             LIKE type_file.chr30   #CHI-CB0017 add
 
   LET g_sql='SELECT * FROM occa_file WHERE occano="',g_occa.occano CLIPPED,'" '
   PREPARE s_occa_p FROM g_sql
   DECLARE s_occa CURSOR FOR s_occa_p
   LET l_occa_upd = 'N'    #NO.FUN-840068
 
   FOR i = 1 TO tm.getLength()   #CHI-870044
       #建立歷史資料拋轉的臨時表
      #CALL s_dc_cre_temp_table("gex_file") RETURNING l_hist_tab  #CHI-A60011 mark
       IF cl_null(tm[i].azp03) THEN CONTINUE FOR END IF
       IF tm[i].sel = 'N' THEN CONTINUE FOR END IF
 
       SELECT gew05,gew07,gew08 INTO l_gew05,l_gew07,l_gew08 FROM gew_file
        WHERE gew01 = g_gev04
          AND gew02 = '4'     #FUN-910093
          AND gew04 = tm[i].azp01
       IF cl_null(l_gew07) THEN LET l_gew07 = 'N' END IF
 
       #mail_1                                                              
       CALL s_dc_carry_send_mail_1(tm[i].azp01,i,g_gev04,'4',l_hist_tab)
        RETURNING l_hs_flag,l_hs_path
       IF cl_null(tm[i].azp03) OR tm[i].sel= 'N' THEN  CONTINUE FOR END IF
       #LET g_sql='SELECT COUNT(*) FROM ',s_dbstring(tm[i].azp03 CLIPPED),'occa_file ',
       LET g_sql='SELECT COUNT(*) FROM ',cl_get_target_table(tm[i].azp01,'occa_file'), #FUN-A50102
                 ' WHERE occano = ? '
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	   CALL cl_parse_qry_sql(g_sql,tm[i].azp01) RETURNING g_sql #FUN-A50102          
       PREPARE c_occa_p FROM g_sql
       DECLARE c_occa CURSOR FOR c_occa_p
 
       #No.FUN-A30110  --Begin
       #LET g_sql='SELECT occ02 FROM ',s_dbstring(tm[i].azp03 CLIPPED),'occ_file ',
       LET g_sql='SELECT occ02 FROM ',cl_get_target_table(tm[i].azp01,'occ_file'), #FUN-A50102
                 ' WHERE occ01 = ? '
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,tm[i].azp01) RETURNING g_sql #FUN-A50102 
       PREPARE occ02_p1  FROM g_sql
       DECLARE occ02_cs1 CURSOR FOR occ02_p1
       #No.FUN-A30110  --End
 
       #-------------------- UPDATE FILE: occa_file ------------------------------
       FOREACH s_occa INTO l_occa.*
          IF STATUS THEN
             CALL cl_err('foreach occa',STATUS,0)
             EXIT FOREACH
          END IF
          OPEN c_occa USING l_occa.occano
          FETCH c_occa INTO l_cnt
             #CHI-A60011 add --start--
             LET g_forupd_sql = "SELECT * FROM ",cl_get_target_table(tm[i].azp01,'occ_file'),
                                " WHERE occ01=? FOR UPDATE"
             LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
             CALL cl_replace_sqldb(g_sql) RETURNING g_sql
             CALL cl_parse_qry_sql(g_sql,tm[i].azp01) RETURNING g_sql 
             DECLARE i250_cs2_occ_lock CURSOR FROM g_forupd_sql
             OPEN i250_cs2_occ_lock USING l_occa.occa01
             IF STATUS THEN
                LET g_msg = tm[i].azp03 CLIPPED,':occ_file:lock'
                LET g_showmsg=tm[i].azp03,'/',l_occa.occa01
                CALL s_errmsg('azp03,occ01',g_showmsg,g_msg,STATUS,1)
                CLOSE i250_cs2_occ_lock
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             FETCH i250_cs2_occ_lock INTO l_occ_2.* 
             IF SQLCA.SQLCODE THEN
                LET g_msg = tm[i].azp03 CLIPPED,':occ_file:lock'
                LET g_showmsg=tm[i].azp03,'/',l_occa.occa01
                CALL s_errmsg('azp03,occ01',g_showmsg,g_msg,SQLCA.SQLCODE,1)
                CLOSE i250_cs2_occ_lock
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             #CHI-A60011 add --end--
          #No.FUN-A30110  --Begin
          OPEN occ02_cs1 USING l_occa.occa01
          FETCH occ02_cs1 INTO l_occ02_t
          #No.FUN-A30110  --End  
             #LET l_sql='UPDATE ',s_dbstring(tm[i].azp03 CLIPPED),'occ_file ',
             LET l_sql='UPDATE ',cl_get_target_table(tm[i].azp01,'occ_file'), #FUN-A50102
                      #CHI-A80050 mark --start--
                      #'   SET occ02  =? ,occ18  =?,',
                      #'       occ19  =? ,occ11  =?,',
                      #'       occ246 =? ,          ',        #No.MOD-840392
                      #'       occmodu=? ,occdate=? ',        #TQC-740343 add
                      #CHI-A80050 mark --end--
                      #CHI-A80050 mod --start--
                       '   SET occ02 =? ,',
                       '       occ03 =? ,',
                       '       occ04 =? ,',
                       '       occ05 =? ,',
                       '       occ06 =? ,',
                       '       occ07 =? ,',
                       '       occ08 =? ,',
                       '       occ09 =? ,',
                       '       occ10 =? ,',
                       '       occ11 =? ,',
                       '       occ12 =? ,',
                       '       occ13 =? ,',
                       '       occ14 =? ,',
                       '       occ15 =? ,',
                       '       occ16 =? ,',
                       '       occ171=? ,',
                       '       occ172=? ,',
                       '       occ173=? ,',
                       '       occ174=? ,',
                       '       occ175=? ,',
                       '       occ18 =? ,',
                       '       occ19 =? ,',
                       '       occ20 =? ,',
                       '       occ21 =? ,',
                       '       occ22 =? ,',
                       '       occ231=? ,',
                       '       occ232=? ,',
                       '       occ233=? ,',
                       '       occ241=? ,',
                       '       occ242=? ,',
                       '       occ243=? ,',
                       '       occ261=? ,',
                       '       occ262=? ,',
                       '       occ263=? ,',
                       '       occ271=? ,',
                       '       occ272=? ,',
                       '       occ273=? ,',
                       '       occ28 =? ,',
                       '       occ29 =? ,',
                       '       occ292=? ,',
                       '       occ30 =? ,',
                       '       occ302=? ,',
                       '       occ31 =? ,',
                       '       occ32 =? ,',
                       '       occ33 =? ,',
                       '       occ34 =? ,',
                       '       occ35 =? ,',
                       '       occ36 =? ,',
                       '       occ37 =? ,',
                       '       occ38 =? ,',
                       '       occ39 =? ,',
                       '       occ39a=? ,',
                       '       occ40 =? ,',
                       '       occ41 =? ,',
                       '       occ42 =? ,',
                       '       occ43 =? ,',
                       '       occ44 =? ,',
                       '       occ45 =? ,',
                       '       occ46 =? ,',
                       '       occ47 =? ,',
                       '       occ48 =? ,',
                       '       occ49 =? ,',
                       '       occ50 =? ,',
                       '       occ51 =? ,',
                       '       occ52 =? ,',
                       '       occ53 =? ,',
                       '       occ55 =? ,',
                       '       occ56 =? ,',
                       '       occ57 =? ,',
                       '       occ61 =? ,',
                       '       occ62 =? ,',
                       '       occ63 =? ,',
                       '       occ631=? ,',
                       '       occ64 =? ,',
                       '       occ68 =? ,',    #FUN-B30044 add
                       '       occ69 =? ,',    #FUN-B30044 add
                       '       occ701=? ,',
                       '       occ702=? ,',
                       '       occ703=? ,',
                       '       occ704=? ,',
                       '       occacti =?,',
                       '       occuser =?,',
                       '       occgrup =?,',
                       '       occmodu =?,',
                       '       occdate =?,',
                       '       occ65 =?  ,',
                      #'       occ1001 =?,',   #MOD-CC0094 mark
                      #'       occ1002 =?,',   #MOD-CC0094 mark
                       '       occ1003 =?,',
                       '       occ1004 =?,',
                       '       occ1005 =?,',
                       '       occ1006 =?,',
                       '       occ1007 =?,',
                       '       occ1008 =?,',
                       '       occ1009 =?,',
                       '       occ1010 =?,',
                       '       occ1011 =?,',
                       '       occ1012 =?,',
                       '       occ1013 =?,',
                       '       occ1014 =?,',
                       '       occ1015 =?,',
                       '       occ1016 =?,',
                       '       occ1017 =?,',
                       '       occ1018 =?,',
                       '       occ1019 =?,',
                       '       occ1020 =?,',
                       '       occ1021 =?,',
                       '       occ1022 =?,',
                       '       occ1023 =?,',
                       '       occ1024 =?,',
                       '       occ1025 =?,',
                       '       occ1026 =?,',
                       '       occ1027 =?,',
                       '       occ1028 =?,',
                       '       occud01 =?,',
                       '       occud02 =?,',
                       '       occud03 =?,',
                       '       occud04 =?,',
                       '       occud05 =?,',
                       '       occud06 =?,',
                       '       occud07 =?,',
                       '       occud08 =?,',
                       '       occud09 =?,',
                       '       occud10 =?,',
                       '       occud11 =?,',
                       '       occud12 =?,',
                       '       occud13 =?,',
                       '       occud14 =?,',
                       '       occud15 =?,',
                       '       occ66   =?,',
                       '       occ1029 =?,',
                       '       occ246  =?,',
                       '       occ67   =?',
                      #CHI-A80050 mod --end--
                       ' WHERE occ01 =? '
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	         CALL cl_parse_qry_sql(l_sql,tm[i].azp01) RETURNING l_sql #FUN-A50102            
             PREPARE u_occa FROM l_sql
            #CHI-A80050 mark --start--
            #EXECUTE u_occa USING l_occa.occa02,l_occa.occa18,
            #                     l_occa.occa19,l_occa.occa11,
            #                     g_plant,                    #No.MOD-840392
            #                     g_user,g_today,             #TQC-740343 add
            #                     l_occa.occa01
            #CHI-A80050 mark --end--
            #CHI-A80050 mod --start--
             EXECUTE u_occa USING  l_occa.occa02  ,  
                                   l_occa.occa03  ,  
                                   l_occa.occa04  ,  
                                   l_occa.occa05  ,  
                                   l_occa.occa06  ,  
                                   l_occa.occa07  ,  
                                   l_occa.occa08  ,  
                                   l_occa.occa09  ,  
                                   l_occa.occa10  ,  
                                   l_occa.occa11  ,  
                                   l_occa.occa12  ,  
                                   l_occa.occa13  ,  
                                   l_occa.occa14  ,  
                                   l_occa.occa15  ,  
                                   l_occa.occa16  ,  
                                   l_occa.occa171 ,  
                                   l_occa.occa172 ,  
                                   l_occa.occa173 ,  
                                   l_occa.occa174 ,  
                                   l_occa.occa175 ,  
                                   l_occa.occa18  ,  
                                   l_occa.occa19  ,  
                                   l_occa.occa20  ,  
                                   l_occa.occa21  ,  
                                   l_occa.occa22  ,  
                                   l_occa.occa231 ,  
                                   l_occa.occa232 ,  
                                   l_occa.occa233 ,  
                                   l_occa.occa241 ,  
                                   l_occa.occa242 ,  
                                   l_occa.occa243 ,  
                                   l_occa.occa261 ,  
                                   l_occa.occa262 ,  
                                   l_occa.occa263 ,  
                                   l_occa.occa271 ,  
                                   l_occa.occa272 ,  
                                   l_occa.occa273 ,  
                                   l_occa.occa28  ,  
                                   l_occa.occa29  ,  
                                   l_occa.occa292 ,  
                                   l_occa.occa30  ,  
                                   l_occa.occa302 ,  
                                   l_occa.occa31  ,  
                                   l_occa.occa32  ,  
                                   l_occa.occa33  ,  
                                   l_occa.occa34  ,  
                                   l_occa.occa35  ,  
                                   l_occa.occa36  ,  
                                   l_occa.occa37  ,  
                                   l_occa.occa38  ,  
                                   l_occa.occa39  ,  
                                   l_occa.occa39a ,  
                                   l_occa.occa40  ,  
                                   l_occa.occa41  ,  
                                   l_occa.occa42  ,  
                                   l_occa.occa43  ,  
                                   l_occa.occa44  ,  
                                   l_occa.occa45  ,  
                                   l_occa.occa46  ,  
                                   l_occa.occa47  ,  
                                   l_occa.occa48  ,  
                                   l_occa.occa49  ,  
                                   l_occa.occa50  ,  
                                   l_occa.occa51  ,  
                                   l_occa.occa52  ,  
                                   l_occa.occa53  ,  
                                   l_occa.occa55  ,  
                                   l_occa.occa56  ,  
                                   l_occa.occa57  ,  
                                   l_occa.occa61  ,  
                                   l_occa.occa62  ,  
                                   l_occa.occa63  ,  
                                   l_occa.occa631 ,  
                                   l_occa.occa64  ,  
                                   l_occa.occa68  ,  #FUN-B30044 add
                                   l_occa.occa69  ,  #FUN-B30044 add
                                   l_occa.occa701 ,  
                                   l_occa.occa702 ,  
                                   l_occa.occa703 ,  
                                   l_occa.occa704 ,  
                                   l_occa.occaacti,  
                                   l_occa.occauser,  
                                   l_occa.occagrup,  
                                   g_user,
                                   g_today,
                                   l_occa.occa65  ,  
                                  #l_occa.occa1001,  #MOD-CC0094 mark 
                                  #l_occa.occa1002,  #MOD-CC0094 mark
                                   l_occa.occa1003,  
                                   l_occa.occa1004,  
                                   l_occa.occa1005,  
                                   l_occa.occa1006,  
                                   l_occa.occa1007,  
                                   l_occa.occa1008,  
                                   l_occa.occa1009,  
                                   l_occa.occa1010,  
                                   l_occa.occa1011,  
                                   l_occa.occa1012,  
                                   l_occa.occa1013,  
                                   l_occa.occa1014,  
                                   l_occa.occa1015,  
                                   l_occa.occa1016,  
                                   l_occa.occa1017,  
                                   l_occa.occa1018,  
                                   l_occa.occa1019,  
                                   l_occa.occa1020,  
                                   l_occa.occa1021,  
                                   l_occa.occa1022,  
                                   l_occa.occa1023,  
                                   l_occa.occa1024,  
                                   l_occa.occa1025,  
                                   l_occa.occa1026,  
                                   l_occa.occa1027,  
                                   l_occa.occa1028,  
                                   l_occa.occaud01,  
                                   l_occa.occaud02,  
                                   l_occa.occaud03,  
                                   l_occa.occaud04,  
                                   l_occa.occaud05,  
                                   l_occa.occaud06,  
                                   l_occa.occaud07,  
                                   l_occa.occaud08,  
                                   l_occa.occaud09,  
                                   l_occa.occaud10,  
                                   l_occa.occaud11,  
                                   l_occa.occaud12,  
                                   l_occa.occaud13,  
                                   l_occa.occaud14,  
                                   l_occa.occaud15,  
                                   l_occa.occa66  ,  
                                   l_occa.occa1029,  
                                   g_plant, 
                                   l_occa.occa67,  
                                   l_occa.occa01
            #CHI-A80050 mod --end--
             IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 #LET g_msg = 'UPDATE ',s_dbstring(tm[i].azp03 CLIPPED),'occ_file'
                 LET g_msg = 'UPDATE ',cl_get_target_table(tm[i].azp01,'occ_file') #FUN-A50102
                 #CALL cl_err(g_msg,'lib-028',1) #CHI-A60011 mark
                 #CHI-A60011 add --start--
                 LET g_showmsg=tm[i].azp03,'/',l_occa.occa01
                 CALL s_errmsg('azp03,occ01',g_showmsg,g_msg,'lib-028',1)
                 #CHI-A60011 add --end--
                 LET g_success = 'N'
                 LET l_occa_upd = 'N'   #NO.FUN-840068 add
                 EXIT FOREACH
             ELSE
                 #No.FUN-A30110  --Begin
                 IF NOT (l_occa.occa01 MATCHES 'MISC*' OR l_occa.occa01 MATCHES 'EMPL*') THEN   #No.TQC-BB0002 
                    IF l_occa.occa02 <> l_occ02_t THEN
                       #CALL s_upd_abbr(l_occa.occa01,l_occa.occa02,tm[i].azp03,'2','Y')
                       CALL s_upd_abbr(l_occa.occa01,l_occa.occa02,tm[i].azp01,'2','Y','u')  #FUN-A50102  #No.FUN-BB0049
                    END IF
                 END IF    #No.TQC-BB0002  
                 #No.FUN-A30110  --End 
                 CALL i250_ins_imab(tm[i].azp03) #新增主檔拋轉記錄檔
                 CALL s_dc_carry_record(g_gev04,tm[i].azp01,g_prog,g_occa.occa01,'4')  #NO.FUN-840018 add
                 IF g_success = 'N' THEN EXIT FOREACH END IF
                 LET l_occa_upd = 'Y'   #NO.FUN-840068 add
             END IF
             CLOSE i250_cs2_occ_lock  #CHI-A60011 add
       END FOREACH
       #mail 2                                            
       IF l_occa_upd = 'Y' THEN      #no.FUN-840033 add                  
           CALL s_dc_carry_send_mail_2(l_hs_flag,l_gew08,l_hs_path,l_hist_tab)
           #CHI-CB0017 add begin---
           LET l_value1 = g_occa.occano
           LET l_value2 = g_occa.occa01
           CALL s_data_transfer(tm[i].azp01,'2',g_prog,l_value1,l_value2,'','','')
           #CHI-CB0017 add end-----
       END IF 
   END FOR
  #CALL s_dc_drop_temp_table(l_hist_tab)  #CHI-A60011 mark
 
  #MESSAGE 'Data Carry Finish!'     #TQC-C50259 mark
  #TQC-C50259 -- add -- begin
   IF l_occa_upd = 'Y' THEN 
      CALL cl_err('','aim-162',0)
   END IF
  #TQC-C50259 -- add -- end
  
   CALL ui.Interface.refresh()
 
END FUNCTION
 
#資料拋轉時會用到的副程式
FUNCTION axmi250_s_carry_data()  #No.FUN-830090
   DEFINE l_occano       LIKE occa_file.occano
   DEFINE p_row,p_col    LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          l_arrno        LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          l_ac           LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          l_exit_sw      LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
          l_wc           LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(1000)
          l_sql          LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(1000)
          l_time         LIKE type_file.chr8,    #No.FUN-680137 VARCHAR(8)
          l_do_ok        LIKE type_file.chr1     #No.FUN-680137 VARCHAR(1)
   DEFINE l_rec_b        LIKE type_file.num5     #No.FUN-610048  #No.FUN-680137 SMALLINT
   DEFINE l_cnt          LIKE type_file.num5     #TQC-740090 add
   DEFINE l_dbs          LIKE type_file.chr21    #TQC-740090 add
   DEFINE l_i            LIKE type_file.num5     #NO.FUN-840018
   DEFINE l_gew03        LIKE gew_file.gew03     #NO.FUN-840018
   DEFINE l_gev04        LIKE gev_file.gev04     #NO.FUN-840018
   DEFINE l_geu02        LIKE geu_file.geu02     #NO.FUN-840018
   DEFINE l_allow_insert  LIKE type_file.num5                 #可新增否 #NO.FUN-840018 
   DEFINE l_allow_delete  LIKE type_file.num5                 #可刪除否 #NO.FUN-840018
   DEFINE l_n            LIKE type_file.num5  #FUN-9A0092                                                                           
   DEFINE l_azw01        LIKE azw_file.azw01  #FUN-9A0092                                                                           
   DEFINE l_azw06        LIKE azw_file.azw06  #FUN-9A0092                                                                           
   DEFINE l_str          STRING               #FUN-9A0092
 
   SELECT UNIQUE gew03 INTO l_gew03 FROM gew_file
    WHERE gew01 = g_gev04
      AND gew02 = '4'
   IF SQLCA.sqlcode THEN
      IF SQLCA.sqlcode = -284 THEN
         LET l_gew03 = '3'
      END IF
   END IF
   LET l_ac = 1
 
  #IF l_gew03 = '2' OR l_gew03 = '3' THEN              #NO.FUN-840090 #CHI-A60035 mark
   IF l_gew03 = '3' THEN      #CHI-A60035

       OPEN WINDOW s_dc_1_w WITH FORM "sub/42f/s_dc_sel_db1"
            ATTRIBUTE (STYLE = g_win_style CLIPPED)
       CALL cl_ui_locale("s_dc_sel_db1")  #NO.MOD-840158
 
       SELECT gev04 INTO l_gev04 FROM gev_file
        WHERE gev01 = '4' and gev02 = g_plant
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
 
     IF g_occa.occa00 = 'I' THEN #新增
        #IF l_gew03 = '1' OR l_gew03 = '2'  THEN  #NO.FUN-840090 #CHI-A60035 mark
         IF l_gew03 MATCHES '[123]' THEN  #CHI-A60035
            LET l_sql = " SELECT 'Y',gew04,azp02,azp03,' ','N' FROM gew_file,azp_file ",  #FUN-9A0092
                        "  WHERE gew01 = '",g_gev04,"'",
                        "    AND gew02 = '4'",
                        "    AND gew04 = azp01 "
            PREPARE axmi250_s_carry_data_prepare1 FROM l_sql  
            DECLARE azp_curs1 CURSOR FOR axmi250_s_carry_data_prepare1
 
            FOREACH azp_curs1 INTO tm[l_ac].*
               IF SQLCA.sqlcode != 0 THEN
                  CALL cl_err('foreach:',SQLCA.sqlcode,1)
                  EXIT FOREACH
               END IF
               #看l_dbs資料庫是否存在此筆資料,若存在就給exist='Y'做備註
               LET l_cnt = NULL
               CALL s_getdbs_curr(tm[l_ac].azp01) RETURNING l_dbs
               #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"occ_file",
               LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(tm[l_ac].azp01,'occ_file'), #FUN-A50102
                           " WHERE occ01 ='",g_occa.occa01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,tm[l_ac].azp01) RETURNING l_sql #FUN-A50102
               PREPARE occ_count_pre FROM l_sql
               EXECUTE occ_count_pre INTO l_cnt
 
               IF NOT cl_null(l_cnt) THEN
                   #新增時,已存在的不能選取
                   #修改時,已存在的選取
                   IF g_occa.occa00 = 'I' THEN #新增
                       IF l_cnt >= 1 THEN
                           LET tm[l_ac].exist = 'Y'     #存在
                           LET tm[l_ac].sel     = 'N'     #選取    #NO.FUN-840018 mod
                       END IF
                   ELSE
                       IF l_cnt >= 1 THEN
                           LET tm[l_ac].exist = 'Y'     #存在
                           LET tm[l_ac].sel     = 'Y'     #選取    #NO.FUN-840018 mod
                       END IF
                   END IF
               END IF
          LET l_azw06 = NULL                                                                                                     
          LET l_azw01 = NULL                                                                                                        
          LET l_str = ''                                                                                                            
          SELECT azw06 INTO l_azw06 FROM azw_file WHERE azw01 = tm[l_ac].azp01                                                      
          DECLARE s_dc_db1  CURSOR  FOR                                                                                          
                  SELECT azw01 FROM azw_file WHERE azw06 = l_azw06                                                           
          FOREACH s_dc_db1  INTO l_azw01                                                                                            
            IF STATUS THEN                                                                                                          
               CALL cl_err('foreach:',STATUS,1)                                                                                     
               EXIT FOREACH                                                                                                         
            END IF                                                                                                                  
            IF l_azw01 = tm[l_ac].azp01 THEN                                                                                        
               LET l_azw01 = NULL                                                                                                   
               CONTINUE FOREACH                                                                                                     
            END IF                                                                                                                  
            IF cl_null(l_str)  THEN                                                                                                 
               LET l_str = l_azw01                                                                                                  
            ELSE                                                                                                                    
               LET l_str = l_str,",",l_azw01                                                                                        
            END IF                                                                                                                  
          END FOREACH                                                                                                               
          LET tm[l_ac].plant = l_str                                                                                                
               LET l_ac = l_ac + 1
            END FOREACH
         END IF
         CALL tm.deleteElement(l_ac)
     ELSE
           LET l_sql = "SELECT UNIQUE 'N', gew04, azp02,azp03,' ','N' ",   #FUN-9A0092
                       "  FROM azp_file,gew_file",
                       " WHERE azp053 = 'Y' ",
                       "   AND gew01 = '",g_gev04,"'",
                       "   AND gew02 = '4' ",
                       "   AND gew04 = azp01 ",
                       " ORDER BY gew04"
         PREPARE axmi250_s_carry_data_prepare2 FROM l_sql  
         DECLARE azp_curs2 CURSOR FOR axmi250_s_carry_data_prepare2
 
         FOREACH azp_curs2 INTO tm[l_ac].*
            IF SQLCA.sqlcode != 0 THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            #看l_dbs資料庫是否存在此筆資料,若存在就給exist='Y'做備註
            LET l_cnt = NULL
            CALL s_getdbs_curr(tm[l_ac].azp01) RETURNING l_dbs
            #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"occ_file",
            LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(tm[l_ac].azp01,'occ_file'), #FUN-A50102
                        " WHERE occ01 ='",g_occa.occa01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,tm[l_ac].azp01) RETURNING l_sql #FUN-A50102
            PREPARE occ_count_pre1 FROM l_sql
            EXECUTE occ_count_pre1 INTO l_cnt
            #No.CHI-950007  --End  
 
            IF NOT cl_null(l_cnt) THEN
                #新增時,已存在的不能選取
                #修改時,已存在的選取
                IF g_occa.occa00 = 'I' THEN #新增
                    IF l_cnt >= 1 THEN
                        LET tm[l_ac].exist = 'Y'     #存在
                        LET tm[l_ac].sel     = 'N'     #選取    #NO.FUN-840018 mod
                    END IF
                ELSE
                    IF l_cnt >= 1 THEN
                        LET tm[l_ac].exist = 'Y'     #存在
                        LET tm[l_ac].sel     = 'Y'     #選取    #NO.FUN-840018 mod
                    END IF
                END IF
            END IF
          LET l_azw06 = NULL                                                                                                        
          LET l_azw01 = NULL                                                                                                        
          LET l_str = ''                                                                                                            
          SELECT azw06 INTO l_azw06 FROM azw_file WHERE azw01 = tm[l_ac].azp01                                                      
          DECLARE s_dc_db2  CURSOR  FOR                                                                                             
                  SELECT azw01 FROM azw_file WHERE azw06 = l_azw06                                                                  
          FOREACH s_dc_db2  INTO l_azw01                                                                                            
            IF STATUS THEN                                                                                                          
               CALL cl_err('foreach:',STATUS,1)                                                                                     
               EXIT FOREACH                                                                                                         
            END IF                                                                                                                  
            IF l_azw01 = tm[l_ac].azp01 THEN                                                                                        
               LET l_azw01 = NULL                                                                                                   
               CONTINUE FOREACH                                                                                                     
            END IF                                                                                                                  
            IF cl_null(l_str)  THEN                                                                                                 
               LET l_str = l_azw01                                                                                                  
            ELSE                                                                                                                    
               LET l_str = l_str,",",l_azw01                                                                                        
            END IF                                                                                                                  
          END FOREACH                                                                                                               
          LET tm[l_ac].plant = l_str                                                                                                
            LET l_ac = l_ac + 1
         END FOREACH
         CALL tm.deleteElement(l_ac)
     END IF
 
      LET l_rec_b = l_ac -1
   WHILE TRUE
      LET l_exit_sw = "n"
      
  #IF l_gew03 = '2' OR l_gew03 = '3' THEN              #NO.FUN-840090  #CHI-A60035 mark
   IF l_gew03 = '3' THEN         #CHI-A60035  
      IF g_occa.occa00 = 'U' THEN 
          LET l_allow_insert = FALSE
      ELSE
          LET l_allow_insert = TRUE
      END IF
 
      INPUT ARRAY tm WITHOUT DEFAULTS FROM s_azp.*
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   #INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE   #NO.FUN-840018 mark
                   INSERT ROW=l_allow_insert,DELETE ROW=TRUE,APPEND ROW=l_allow_insert)   #FUN-840018 add
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            #新增時,已存在的不能選取
            #修改時,不存在的不能選取
            IF g_occa.occa00 = 'I' THEN #新增
                IF tm[l_ac].exist = 'Y' THEN #存在
                    NEXT FIELD exist
                END IF
            ELSE
                IF tm[l_ac].exist = 'N' THEN #存在
                    IF l_ac <> l_rec_b THEN
                        NEXT FIELD exist
                    ELSE
                        EXIT INPUT
                    END IF
                END IF
            END IF
            CALL i221_250_set_entry( )
            CALL i221_250_set_no_entry(l_ac)
 
	 AFTER FIELD azp01
	    IF NOT cl_null(tm[l_ac].azp01) THEN
	       CALL i221_sel_db_azp01(l_ac)
	       IF NOT cl_null(g_errno) THEN
		  CALL cl_err(tm[l_ac].azp01,g_errno,0)
                  NEXT FIELD azp01
	       END IF
 
                LET l_cnt = 0
                CALL s_getdbs_curr(tm[l_ac].azp01) RETURNING l_dbs
                #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"occ_file",
                LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(tm[l_ac].azp01,'occ_file'), #FUN-A50102
                            " WHERE occ01 ='",g_occa.occa01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,tm[l_ac].azp01) RETURNING l_sql #FUN-A50102
                PREPARE occ_count_pre2 FROM l_sql
                EXECUTE occ_count_pre2 INTO l_cnt
   
                IF NOT cl_null(l_cnt) THEN
                    IF l_cnt >= 1 THEN
                        LET tm[l_ac].exist = 'Y'     #存在
                    ELSE
                        LET tm[l_ac].exist = 'N'
                    END IF
                END IF
                DISPLAY BY NAME tm[l_ac].exist
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
                      LET g_qryparam.arg2     = '4'
                      LET g_qryparam.default1 = tm[l_ac].azp01
                      CALL cl_create_qry() RETURNING tm[l_ac].azp01
                      CALL i221_sel_db_azp01(l_ac)
                      NEXT FIELD azp01
              END CASE
 
         ON ACTION accept
            LET l_exit_sw = 'y'
            EXIT INPUT
 
      END INPUT
   ELSE              #no.FUN-840090
      EXIT WHILE     #NO.FUN-840090
   END IF            #NO.FUN-840090
 
   IF INT_FLAG THEN
     #LET INT_FLAG = 0
      LET l_exit_sw = 'y'
   END IF
 
   IF l_exit_sw = "y" THEN
      EXIT WHILE
   END IF
END WHILE
 
IF l_gew03 = '3' THEN   #CHI-A60035 add
   CLOSE WINDOW s_dc_1_w                 #no.FUN-840018 add
END IF                  #CHI-A60035 add
 
END FUNCTION
 
FUNCTION i250_ins_imab(l_dbs) #新增主檔拋轉記錄檔
  DEFINE l_dbs        LIKE azp_file.azp03
 
  DEFINE l_time       DATETIME YEAR TO SECOND
 
    LET l_time = CURRENT YEAR TO SECOND
    INSERT INTO imab_file(imab00,imabno,imab01,imabtype,imabdate,imabdb)
       VALUES (g_occa.occa00,g_occa.occano,g_occa.occa01,'2',l_time,l_dbs)
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","imab_file","axmi250","",SQLCA.sqlcode,"","",1)
        LET g_success='N'
    END IF
    IF SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err3("ins","imab_file","axmi250","",'lib-028',"","",1)
        LET g_success='N'
    END IF
END FUNCTION
 
FUNCTION i221_250_set_entry()
         CALL cl_set_comp_entry("azp01",TRUE)
END FUNCTION
 
FUNCTION i221_250_set_no_entry(p_i)
DEFINE p_i  LIKE type_file.num5
 
    IF (tm[p_i].exist = 'Y') OR g_occa.occa00 = 'U' AND cl_null(tm[p_i].exist) THEN
         CALL cl_set_comp_entry("azp01",FALSE)
    END IF
END FUNCTION
 
FUNCTION i221_sel_db_azp01(i)
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
          AND gew02 ='4' 
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
#No.FUN-9C0072 精簡程式碼
