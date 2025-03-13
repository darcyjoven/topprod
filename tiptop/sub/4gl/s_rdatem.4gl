# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: s_rdatem.4gl
# Descriptions...: 
# Date & Author..: 
# Input Parameter: 
# Return code....: 
# Memo...........: No.+258 將 s_mothck 改為 s_mothck_ar
#                  copy 自s_rdate2.4gl 改成多工廠
# Modify.........: No.9807 04/07/30 ching 票到期日不受occ39影響when oag06='3'
# Modify.........: No.MOD-540021 05/04/15 By Nicola 小月時，日期計算錯誤
# Modify.........: No.FUN-560002 05/06/03 By wujie 單據編號修改
# Modify.........: NO.FUN-630015 06/05/24 BY yiting SQL發生錯誤
# Modify.........: No.MOD-570135 06/06/14 By Smapmin 錯誤日期的判斷
# Modify.........: No.FUN-680022 06/08/29 By Tracy 增加參數訂單日p_date3
# Modify.........: No.FUN-680147 06/09/15 By czl 欄位型態定義,改為LIKE
# Modify.........: No.MOD-680005 06/12/08 By Smapmin 修改基礎日算法
# Modify.........: No.MOD-6C0148 06/12/25 By Smapmin 票到期日不應受廠商付款日影響
# Modify.........: No.FUN-720003 07/02/07 By dxfwo 增加修改單身批處理錯誤統整功能
# Modify.........: No.MOD-740413 07/05/09 By chenl 增加對oag04,oag041,oag07,oag071的判斷，若為空，則賦0值
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-920166 09/02/20 By alex 新增 MSV 判斷
# Modify.........: No.MOD-950199 09/05/19 By lilingyu FUNCTION s_rdatem()段最后要RETURN前,增加判斷l_date2是否小于l_date1,若是則LET l_date2=l_date1
# Modify.........: No.FUN-980020 09/09/08 By douzh GP集團架構修改,sub相關參數
# Modify.........: No.TQC-9C0099 09/12/16 By jan s_rdatem() 參數修改p_dbs-->p_plant
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-CC0123 12/12/18 By Polly 推算l_date1(收款日)若碰到非工作日應往後抓到工作日為止
#                            　　　　　　　　　　　推算l_date2(票到期日)若碰到非工作日或銀行休假日(nph_file)應往後抓到工作日與非銀行休假日為止
# Modify.........: No:MOD-CC0269 12/12/28 By Polly 增加推算l_date2(票到期日)週六周日判斷處理
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
GLOBALS
   DEFINE g_chr          LIKE type_file.chr1         #No.FUN-680147 VARCHAR(01)
END GLOBALS
 
#FUNCTION s_rdatem(p_cus,p_no,p_date,p_date2,p_date3,p_dbs) # 應收款日推算 #No.FUN-680022 add p_date3    #TQC-9C0099
FUNCTION s_rdatem(p_cus,p_no,p_date,p_date2,p_date3,p_plant) # 應收款日推算 #No.FUN-680022 add p_date3 #TQC-9C0099
   DEFINE p_cus                           LIKE occ_file.occ01          #No.FUN-680147 VARCHAR(10)
   DEFINE p_no                            LIKE oag_file.oag01          #No.FUN-680147 VARCHAR(10)   #No.FUN-560002
   DEFINE p_dbs                           LIKE type_file.chr21         #No.FUN-680147 VARCHAR(21)
   DEFINE p_date,l_base,l_date1,l_date2   LIKE type_file.dat           #No.FUN-680147 DATE
   DEFINE l_bdate,p_date2                 LIKE type_file.dat           #No.FUN-680147 DATE #970419 判斷日期合理性
   DEFINE p_bdate,p_edate                 LIKE type_file.dat           #No.FUN-680147 DATE #970419 判斷日期合理性
   DEFINE p_date3                         LIKE type_file.dat           #No.FUN-680147 DATE #No.FUN-680022
   DEFINE l_x,l_y                         LIKE smh_file.smh01          #No.FUN-680147 VARCHAR(8)                   
   DEFINE l_oag RECORD LIKE oag_file.*
   DEFINE l_occ38,l_occ39                 LIKE occ_file.occ38          #No.FUN-680147 VARCHAR(2)
   DEFINE m,l_day                         LIKE type_file.num5          #No.FUN-680147 SMALLINT
   DEFINE l_sql                           LIKE type_file.chr1000       #No.FUN-680147 VARCHAR(1000)
   DEFINE g_db_type                       LIKE type_file.chr3          #No.FUN-680147 VARCHAR(03) #NO.FUN-630015 
   DEFINE l_dbname                        LIKE type_file.chr1          #No.FUN-680147 VARCHAR(01) #NO.FUN-630015
   DEFINE p_plant                         LIKE type_file.chr10         #FUN-980020
   DEFINE i                               LIKE type_file.num5          #MOD-CC0123 add
   DEFINE l_nph02                         LIKE nph_file.nph02          #MOD-CC0123 add
   DEFINE l_n                             LIKE type_file.num10         #MOD-CC0269 add

 
   WHENEVER ERROR CONTINUE
 
#FUN-980020--begin    
    IF cl_null(p_plant) THEN
       LET p_dbs = NULL
    ELSE
       LET g_plant_new = p_plant
       CALL s_getdbs()
       LET p_dbs = g_dbs_new
    END IF
#FUN-980020--end    
 
   #讀取收款條件檔
   SELECT * INTO l_oag.* FROM oag_file WHERE oag01 = p_no
 
#  #NO.FUN-630015 start--   #FUN-920166 fallow原作法在各程式內CALL s_dbstring()
#  LET g_db_type=cl_db_get_database_type()
#  IF g_db_type='IFX' THEN
#     LET l_dbname=':'
#  ELSE
#     LET l_dbname='.'
#  END IF
 
#  LET l_sql = "SELECT * FROM ",p_dbs CLIPPED,l_dbname,"oag_file ",
   #LET l_sql = "SELECT * FROM ",p_dbs CLIPPED,"oag_file ",
   LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'oag_file'), #FUN-A50102
               " WHERE oag01= '",p_no,"' "
#  #FUN-630015 end---
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE oag_p1 FROM l_sql
   IF STATUS THEN
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('','','oag_p1',STATUS,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err('oag_p1',STATUS,1)                                                                             
      END IF                                                                                                                        
      RETURN p_date,p_date
   END IF
 
   DECLARE oag_c1 CURSOR FOR oag_p1
   OPEN oag_c1
   FETCH oag_c1 INTO l_oag.*
   IF STATUS THEN
      RETURN p_date,p_date
   END IF
   CLOSE oag_c1
  
   #讀取客戶主檔
   #LET l_sql = "SELECT occ38,occ39 FROM ",p_dbs CLIPPED,"occ_file ",   #MOD-570135
   LET l_sql = "SELECT occ38,occ39 FROM ",cl_get_target_table(p_plant,'occ_file'), #FUN-A50102
               " WHERE occ01= '",p_cus,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE occ_p1 FROM l_sql
   IF STATUS THEN 
      IF g_bgerr THEN                                                                                                               
         CALL s_errmsg('occ01',p_cus,'occ_p1',STATUS,1)                                                                     
      ELSE                                                                                                                          
         CALL cl_err('occ_p1',STATUS,1)                                                                             
      END IF                                                                                                                        
   END IF
 
   DECLARE occ_c1 CURSOR FOR occ_p1
   OPEN occ_c1
   FETCH occ_c1 INTO l_occ38,l_occ39
   IF l_occ38 IS NOT NULL THEN
     LET l_occ38 = l_occ38 USING '&&'
     LET l_occ39 = l_occ39 USING '&&'
   END IF
   CLOSE occ_c1
  
   LET l_occ38 = l_occ38 USING '&&'
   LET l_occ39 = l_occ39 USING '&&'
   #------00/09/27 modify-----------------------
   IF l_oag.oag03 MATCHES '[25]' THEN
      LET l_base = p_date2
   END IF
   #------------------------------------------------------------ 推應收款日
   IF l_oag.oag03 MATCHES '[14]' THEN     # 出貨日 (Net N Days)
      LET l_base = p_date
   END IF
  #No.FUN-680022  --start--
   IF l_oag.oag03 MATCHES '[36]' THEN     # 訂單日 
      LET l_base = p_date3
   END IF
  #No.FUN-680022  --end--
   #----------------------------00/03/10 modify推月結日
   IF l_oag.oag03 MATCHES '[25]' THEN
      LET l_x = p_date2 USING 'yyyymmdd'
   ELSE
  #No.FUN-680022  --start--    
  #   LET l_x = p_date USING 'yyyymmdd'
      IF l_oag.oag03 MATCHES '[36]' THEN
         LET l_x = p_date3 USING 'yyyymmdd'
      ELSE
         LET l_x = p_date USING 'yyyymmdd'
      END IF
   END IF
  #No.FUN-680022  --end--
   IF l_occ38 != ' ' AND l_occ38 IS NOT NULL AND l_occ38 != 0 THEN
      IF l_occ38 < l_x[7,8] THEN
         LET l_x[5,6] = l_x[5,6] + 1 USING '&&'
         LET l_x[7,8] = l_occ38 USING '&&'   #MOD-680005
      ELSE   #MOD-680005
         LET l_x[7,8]=l_occ38 USING '&&'   #MOD-680005
      END IF
      IF l_x[5,6]>'12' THEN
         LET l_x[1,4]=(l_x[1,4]+1) USING '&&&&'
         LET l_x[5,6]=(l_x[5,6]-12) USING '&&'
      END IF
      #若日期為31日，當月為小月時(一個月只有30天)
      #具必須取得當月真正最後一天的日子 no.4885
      IF l_x[7,8] = 31 THEN
         LET l_base = MDY(l_x[5,6],1,l_x[1,4])
         CALL s_mothck_ar(l_base) RETURNING p_bdate,p_edate
         LET l_x[7,8] = DAY(p_edate) USING '&&'
      END IF
      LET l_base = MDY(l_x[5,6],l_x[7,8],l_x[1,4])
      #-----MOD-570135---------
      IF cl_null(l_base) THEN
         LET l_base = MDY(l_x[5,6],1,l_x[1,4])
         CALL s_mothck_ar(l_base) RETURNING p_bdate,p_edate
         LET l_x[7,8] = DAY(p_edate) USING '&&'
         LET l_base = MDY(l_x[5,6],l_x[7,8],l_x[1,4])
      END IF
      #-----END MOD-570135-----
    END IF
  
  #IF l_oag.oag03 MATCHES '[45]' THEN     # 出貨日次月初 (月結 N Days)
   IF l_oag.oag03 MATCHES '[456]' THEN    # 出貨日次月初 (月結 N Days) #No.FUN-680022 增加訂單日次月初的情況
      LET l_x = l_base USING 'yyyymmdd'
      LET m = 1
      LET l_x[5,6]=l_x[5,6]+m USING '&&'
      IF l_x[5,6]>'12' THEN
         LET l_x[1,4]=(l_x[1,4]+1) USING '&&&&'
         LET l_x[5,6]=(l_x[5,6]-12) USING '&&'
      END IF
      LET l_x[7,8]='01'
      #--- 970419 增加判斷日期合理性
      LET l_bdate = MDY(l_x[5,6],1,l_x[1,4])
    # CALL s_mothck(l_bdate) RETURNING p_bdate,p_edate
      CALL s_mothck_ar(l_bdate) RETURNING p_bdate,p_edate   #No.+258
      LET l_y = p_edate USING 'yyyymmdd'
      IF l_x[7,8]>l_y[7,8] THEN LET l_x[7,8]=l_y[7,8] END IF
      #-----------------------------
      LET l_base = MDY(l_x[5,6],l_x[7,8],l_x[1,4])
   END IF
   #CALL s_rdate_30(l_base, l_oag.oag04) RETURNING l_date1
   #No.B479  010504 mod by linda 加上月數
   #No:9607
   #CALL s_rdate_30(l_base, l_oag.oag041,l_oag.oag04) RETURNING l_date1
   #No.MOD-740413--begin--
   IF cl_null(l_oag.oag04) THEN
      LET l_oag.oag04=0
   END IF
   IF cl_null(l_oag.oag041) THEN
      LET l_oag.oag041=0
   END IF
   #No.MOD-740413--end--
   CALL cl_cal(l_base, l_oag.oag041,l_oag.oag04) RETURNING l_date1
   # IF l_oag.oag03 MATCHES '[45]' THEN
      {
       LET l_x = l_date1 USING 'yyyymmdd'
       IF l_occ38 != ' ' AND l_occ38 IS NOT NULL AND l_occ38 != 0 THEN
         IF l_occ38 < l_x[7,8] THEN
            LET l_x[5,6] = l_x[5,6] + 1 USING '&&'
        #   LET l_x[7,8] = l_occ38 USING '&&'
        #ELSE
        #     LET l_x[7,8]=l_occ38 USING '&&'
         END IF
         IF l_x[5,6]>'12' THEN
            LET l_x[1,4]=(l_x[1,4]+1) USING '&&&&'
            LET l_x[5,6]=(l_x[5,6]-12) USING '&&'
         END IF
         LET l_date1 = MDY(l_x[5,6],l_x[7,8],l_x[1,4])
       END IF
      }
       LET l_x = l_date1 USING 'yyyymmdd'
       IF l_occ39 != ' ' AND l_occ39 IS NOT NULL AND l_occ39 != 0 THEN
         IF l_occ39 < l_x[7,8] THEN
            LET l_x[5,6] = l_x[5,6] + 1 USING '&&'
            LET l_x[7,8] = l_occ39 USING '&&'
         ELSE
              LET l_x[7,8]=l_occ39 USING '&&'
         END IF
         IF l_x[5,6]>'12' THEN
            LET l_x[1,4]=(l_x[1,4]+1) USING '&&&&'
            LET l_x[5,6]=(l_x[5,6]-12) USING '&&'
         END IF
       END IF
       #若為二月，而客戶付款日設定為'30' no.4171
       #則必須取得二月的最後一天的日子
       IF l_occ39 >= 30 AND l_x[5,6] = '02' THEN
          LET l_date1 = MDY(l_x[5,6],1,l_x[1,4])
          CALL s_mothck_ar(l_date1) RETURNING p_bdate,p_edate
          LET l_x[7,8] = DAY(p_edate) USING '&&'
       END IF
       LET l_date1 = MDY(l_x[5,6],l_x[7,8],l_x[1,4])
  
        #-----No.MOD-540021-----
       #若為小月，而客戶付款日設定為'31'
       #則必須取得小月的最後一天的日子
       IF l_occ39 >= 31 THEN
          LET l_date1 = MDY(l_x[5,6],1,l_x[1,4])
          CALL s_mothck_ar(l_date1) RETURNING p_bdate,p_edate
          LET l_x[7,8] = DAY(p_edate) USING '&&'
       END IF
       LET l_date1 = MDY(l_x[5,6],l_x[7,8],l_x[1,4])
        #-----No.MOD-540021 END-----
  
        #-----MOD-570135---------
        IF cl_null(l_date1) THEN
           LET l_date1 = MDY(l_x[5,6],1,l_x[1,4])
           CALL s_mothck_ar(l_date1) RETURNING p_bdate,p_edate
           LET l_x[7,8] = DAY(p_edate) USING '&&'
           LET l_date1 = MDY(l_x[5,6],l_x[7,8],l_x[1,4])
        END IF
        #-----END MOD-570135-----
  
  
   #END IF
   #------------------------------------------------------------ 推票到期日
   IF l_oag.oag06 MATCHES '[14]' THEN     # 出貨日 (Net N Days)
      LET l_base = p_date
   END IF
   IF l_oag.oag06 MATCHES '[25]' THEN
      LET l_base = p_date2
   END IF
  
  ##No.3037 1999/03/16 modify
   IF l_oag.oag06 MATCHES '[25]' THEN
      LET l_x = p_date2 USING 'yyyymmdd'
   ELSE
      LET l_x = p_date  USING 'yyyymmdd'
   END IF
   IF l_occ38 != ' ' AND l_occ38 IS NOT NULL AND l_occ38 != 0 THEN
      IF l_occ38 < l_x[7,8] THEN
         LET l_x[5,6] = l_x[5,6] + 1 USING '&&'
         LET l_x[7,8] = l_occ38 USING '&&'   #MOD-680005
      ELSE   #MOD-680005
         LET l_x[7,8] = l_occ38 USING '&&'   #MOD-680005
      END IF
  
      #nick 02112 no:6432
      IF l_x[5,6]>'12' THEN
          LET l_x[1,4]=(l_x[1,4]+1) USING '&&&&'
          LET l_x[5,6]=(l_x[5,6]-12) USING '&&'
      END IF
      #nick 021126 no:6432
  
      #no:6432
      #若日期為31日，當月為小月時(一個月只有30天)
      #具必須取得當月真正最後一天的日子 no.4885
      IF l_x[7,8] = 31 THEN
          LET l_base = MDY(l_x[5,6],1,l_x[1,4])
          CALL s_mothck_ar(l_base) RETURNING p_bdate,p_edate
          LET l_x[7,8] = DAY(p_edate) USING '&&'
      END IF
      LET l_base = MDY(l_x[5,6],l_x[7,8],l_x[1,4])
      #-----MOD-570135---------
      IF cl_null(l_base) THEN
         LET l_base = MDY(l_x[5,6],1,l_x[1,4])
         CALL s_mothck_ar(l_base) RETURNING p_bdate,p_edate
         LET l_x[7,8] = DAY(p_edate) USING '&&'
         LET l_base = MDY(l_x[5,6],l_x[7,8],l_x[1,4])
      END IF
      #-----END MOD-570135-----
      #no:6432
   END IF
   IF l_oag.oag06 MATCHES '[45]' THEN     # 出貨日次月初 (月結 N Days)
      LET l_x = l_base USING 'yyyymmdd'
      LET m = 1
      LET l_x[5,6]=l_x[5,6]+m USING '&&'
      IF l_x[5,6]>'12' THEN
         LET l_x[1,4]=(l_x[1,4]+1) USING '&&&&'
         LET l_x[5,6]=(l_x[5,6]-12) USING '&&'
      END IF
     #LET l_x[7,8]='01'
  ##No.3037 1999/03/16 modify
      LET l_x[7,8] = '01'
  ##-------------------------
      LET l_base = MDY(l_x[5,6],l_x[7,8],l_x[1,4])
   END IF
   #No.8959 add
   IF l_oag.oag06 MATCHES '[6]' THEN      # 應收款日次月初
      LET l_base = l_date1
      LET l_x = l_base USING 'yyyymmdd'
      LET m = 1
      LET l_x[5,6]=l_x[5,6]+m USING '&&'
      IF l_x[5,6]>'12' THEN
         LET l_x[1,4]=(l_x[1,4]+1) USING '&&&&'
         LET l_x[5,6]=(l_x[5,6]-12) USING '&&'
      END IF
      LET l_x[7,8] = '01'
      LET l_base = MDY(l_x[5,6],l_x[7,8],l_x[1,4])
   END IF
   IF l_oag.oag06 = '3' THEN      # 應收款日
      LET l_base = l_date1
   END IF
  #LET l_date2 = l_base + l_oag.oag07
  #CALL s_rdate_30(l_base, l_oag.oag07) RETURNING l_date2
   #No.B479 010504 by linda mod
   #No:9607
   #CALL s_rdate_30(l_base, l_oag.oag071,l_oag.oag07) RETURNING l_date2
   #No.MOD-740413--begin--
   IF cl_null(l_oag.oag07) THEN
      LET l_oag.oag07=0
   END IF
   IF cl_null(l_oag.oag071) THEN
      LET l_oag.oag071=0
   END IF
   #No.MOD-740413--end--
   CALL cl_cal(l_base, l_oag.oag071,l_oag.oag07) RETURNING l_date2
   #IF l_oag.oag06 MATCHES '[45]' THEN    # 出貨日次月初 (月結 N Days)
      LET l_x = l_date2 USING 'yyyymmdd'
     #LET l_x[7,8]='01'
      LET l_x = l_date2 USING 'yyyymmdd'
  
   #-----MOD-6C0148---------
   ##No.9807
   #IF l_oag.oag06 <> '3' THEN     # 應收款日
   #   IF l_occ39 != ' ' AND l_occ39 IS NOT NULL AND l_occ39 != 0 THEN
   #      IF l_occ39 < l_x[7,8] THEN
   #          LET l_x[5,6] = l_x[5,6] + 1 USING '&&'
   #          IF l_x[5,6]>'12' THEN      #bugno:5724判斷是否月份>12
   #             LET l_x[1,4]=(l_x[1,4]+1) USING '&&&&'
   #             LET l_x[5,6]=(l_x[5,6]-12) USING '&&'
   #          END IF                     #bugno:5724
   #          LET l_x[7,8] = l_occ39 USING '&&'
   #      ELSE
   #          LET l_x[7,8] = l_occ39 USING '&&'
   #      END IF
   #   END IF
   #   #若為二月，而客戶付款日設定為'30' no.4171
   #   #則必須取得二月的最後一天的日子
   #   IF l_occ39 >= 30 AND l_x[5,6] = '02' THEN
   #      LET l_date2 = MDY(l_x[5,6],1,l_x[1,4])
   #      CALL s_mothck_ar(l_date2) RETURNING p_bdate,p_edate
   #      LET l_x[7,8] = DAY(p_edate) USING '&&'
   #   END IF
   #   LET l_date2 = MDY(l_x[5,6],l_x[7,8],l_x[1,4])
   
   #      #-----No.MOD-540021-----
   #     #若為小月，而客戶付款日設定為'31' no.4171
   #     #則必須取得小月的最後一天的日子
   #     IF l_occ39 >= 31 THEN
   #        LET l_date2 = MDY(l_x[5,6],1,l_x[1,4])
   #        CALL s_mothck_ar(l_date2) RETURNING p_bdate,p_edate
   #        LET l_x[7,8] = DAY(p_edate) USING '&&'
   #     END IF
   #     LET l_date2 = MDY(l_x[5,6],l_x[7,8],l_x[1,4])
   #      #-----No.MOD-540021 END-----
   
   #     #-----MOD-570135---------
   #     IF cl_null(l_date2) THEN
   #        LET l_date2 = MDY(l_x[5,6],1,l_x[1,4])
   #        CALL s_mothck_ar(l_date2) RETURNING p_bdate,p_edate
   #        LET l_x[7,8] = DAY(p_edate) USING '&&'
   #        LET l_date2 = MDY(l_x[5,6],l_x[7,8],l_x[1,4])
   #     END IF
   #     #-----END MOD-570135-----
   
   
   #END IF
   ##--
   #-----END MOD-6C0148----- 
   #---------------------------------MOD-CC0123------------------------------(S)
   ##推算l_date1(付款日)若碰到非工作日應往後抓到工作日為止
   ##推算l_date2(票到期日)若碰到非工作日或銀行休假日(nph_file)應往後抓到工作日與非銀行休假日為止
    CALL s_aday(l_date1,1,0) RETURNING l_date1
    CALL s_aday(l_date2,1,0) RETURNING l_date2
    FOR i=1 TO 30
       SELECT nph02 INTO l_nph02 FROM nph_file WHERE nph01 = l_date2
       IF STATUS = 0 THEN
          LET l_date2 = l_date2 + 1
       ELSE
          EXIT FOR
       END IF
    END FOR
   #---------------------------------MOD-CC0123------------------------------(E)
   #-----------------MOD-CC0269------------------------(S)
    LET l_n = WEEKDAY(l_date2)  # 若為週日
    IF l_n = 0 THEN
       LET l_date2 = l_date2 + 1
    END IF
    IF l_n = 6 THEN
       LET l_date2 = l_date2 + 2
    END IF
   #-----------------MOD-CC0269------------------------(E)
  
#MOD-950199 --begin--
   IF l_date2 < l_date1 THEN
      LET l_date2 = l_date1
   END IF 
#MOD-950199 --end--
 
   RETURN l_date1,l_date2
END FUNCTION
 
FUNCTION s_rdate_30(l_base, l_mons, l_days)
 DEFINE l_base  LIKE type_file.dat          #No.FUN-680147 DATE
 DEFINE l_days  LIKE type_file.num5         #No.FUN-680147 SMALLINT
 DEFINE l_mons  LIKE type_file.num5         #No.FUN-680147 SMALLINT
 DEFINE i,j,k   LIKE type_file.num5         #No.FUN-680147 SMALLINT
 DEFINE l_x,l_y LIKE smh_file.smh01         #No.FUN-680147 VARCHAR(8)
 DEFINE l_bdate LIKE type_file.dat          #No.FUN-680147 DATE  #970419 判斷日期合理性
 DEFINE p_bdate,p_edate LIKE type_file.dat          #No.FUN-680147 DATE #970419 判斷日期合理性
 IF l_days IS NULL THEN RETURN l_base END IF
 
#No.B479 010504 by linda add
  IF cl_null(l_mons) THEN LET l_mons=0 END IF
  IF cl_null(l_days) THEN LET l_days=0 END IF
  LET l_base  = l_base  + l_mons UNITS MONTH + l_days UNITS DAY
#No.B479 010504 by linda mark
{
 LET l_x=l_base USING 'yyyymmdd'
 LET i=l_days/30
 LET j=l_days-i*30
 LET l_x[5,6]=(l_x[5,6]+i) USING '&&'
 IF l_x[5,6]>'12' THEN
    LET l_x[1,4]=(l_x[1,4]+1) USING '&&&&'
    LET l_x[5,6]=(l_x[5,6]-12) USING '&&'
 END IF
 #--- 970419 增加判斷日期合理性
 LET l_bdate = MDY(l_x[5,6],1,l_x[1,4])
 #CALL s_mothck(l_bdate) RETURNING p_bdate,p_edate
 CALL s_mothck_ar(l_bdate) RETURNING p_bdate,p_edate   #No.+258
 LET l_y = p_edate USING 'yyyymmdd'
 IF l_x[7,8]>l_y[7,8] THEN LET l_x[7,8]=l_y[7,8] END IF
 #-----------------------------
 LET l_base = MDY(l_x[5,6],l_x[7,8],l_x[1,4])+j
#IF l_days>0 THEN LET l_base = l_base-1 END IF
}
#No.B479 mark end----
 RETURN l_base
END FUNCTION
 
#FUNCTION s_mothck(p_date)
FUNCTION s_mothck_ar(p_date)   #No.+258
    DEFINE  p_date     LIKE type_file.dat,          #No.FUN-680147 DATE
            p_bdate    LIKE type_file.dat,          #No.FUN-680147 DATE
            p_edate    LIKE type_file.dat,          #No.FUN-680147 DATE
            l_date     LIKE type_file.dat,          #No.FUN-680147 DATE
            b_date     LIKE smh_file.smh01,         #No.FUN-680147 VARCHAR(8)
            l_tmp      LIKE type_file.num5          #No.FUN-680147 SMALLINT
 
    IF p_date IS NULL OR p_date=' ' THEN
       RETURN '',''
    END IF
    LET b_date=p_date USING "yyyymmdd"
    IF b_date[7,8]<>'01' THEN
       LET b_date=b_date[1,4],b_date[5,6],b_date[7,8]*0+1 USING '&&'
    END IF
    LET p_bdate = MDY(b_date[5,6],b_date[7,8],b_date[1,4])    #該月第一天
    #將月份加一, 再將日期減一, 即可得到上月的最後一天
    LET b_date=b_date[1,4],b_date[5,6]+1 USING '&&',b_date[7,8]
    IF b_date[5,6]='13' THEN
       LET b_date=b_date[1,4]+1 USING '&&&&',b_date[5,6]*0+1
                   USING '&&',b_date[7,8]
    END IF
    LET l_date = MDY(b_date[5,6],b_date[7,8],b_date[1,4]) #該月之最後一天
    LET p_edate=l_date-1
    RETURN p_bdate,p_edate
END FUNCTION
 
#Patch....NO.TQC-610035 <001> #
