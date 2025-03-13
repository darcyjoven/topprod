# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: s_genrut.4gl
# Descriptions...: 產生製程追蹤資料
# Date & Author..: 92/08/10 By Purple
# Usage..........: CALL s_genrut(p_wo,p_part,p_date,p_rut) RETURNING l_stat
# Input Parameter: p_wo     work order no.
#                  p_part   part number
#                  p_date   effective date 
#                  p_rut    primary code   
# Return code....: l_stat
#                    0  FAIL
#                    1  OK
#                    not 0 - fail
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-560002 05/06/03 By wujie 單據編號修改 
# Modify.........: No.FUN-680147 06/09/01 By Czl  類型轉換
# Modify.........: No.TQC-6A0063 06/10/24 by Claire ecm29-ecm33改ecm291-ecm322
# Modify.........: No.TQC-6A0071 06/11/14 by Claire ecm57-ecm59改ecb44-ecb46
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-930310 09/04/02 By Smapmin 變數登打錯誤
# Modify.........: No.FUN-980012 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-A60076 10/06/25 By huangtao GP5.25 製造功能優化-平行製程(批量修改) 
# Modify.........: No:FUN-A80102 10/08/18 By kim GP5.25號機管理
# Modify.........: No.TQC-B80022 11/08/02 By jason INSERT INTO ecm_file給ecm66預設值'Y' 
# Modify.........: No.CHI-B80096 11/09/02 By fengrui 對組成用量(ecm62)/底數(63)的預設值處理,計算標準產出量(ecm65)的值

DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_genrut(p_wo,p_part,p_date,p_rut)
DEFINE
    p_wo         LIKE adj_file.adj02,         #No.FUN-680147 VARCHAR(16)  #work order no   --FUN-560002
    p_part       like ecb_file.ecb01,         #part number             #No.MOD-490217
    p_rut        LIKE aab_file.aab02,         #No.FUN-680147 VARCHAR(6)   #primary code
    p_date       LIKE type_file.dat,          #No.FUN-680147 DATE      #effective date
    l_ecb        RECORD LIKE ecb_file.*,
    l_eca09      LIKE eca_file.eca09,
    l_ecm012     LIKE ecm_file.ecm012,        #No.CHI-B80096--add--
    l_sfb08      LIKE sfb_file.sfb08,         #No.CHI-B80096--add--
    l_status     LIKE type_file.num10,        #No.FUN-680147 INTEGER   #STATUS CODE
    l_cnt        LIKE type_file.num5          #No.FUN-680147 SMALLINT
 
    WHENEVER ERROR CALL cl_err_msg_log
    DECLARE ecb_cur CURSOR FOR 
       SELECT  * FROM ecb_file
        WHERE ecb01=p_part   #part no.
          AND ecb02=p_rut      #routing no.
#-----> transaction LOG
# BEGIN WORK
    LET l_status=0
    FOREACH ecb_cur INTO l_ecb.*
      IF SQLCA.sqlcode THEN 
         LET l_status=SQLCA.sqlcode
         EXIT FOREACH
      END IF
#-----> generate routing tracking data
     #get QUEUE TIME FROM WORK CENTE
 
      SELECT eca09 INTO l_eca09 FROM eca_file WHERE eca01=l_ecb.ecb08
      IF SQLCA.sqlcode THEN LET l_eca09=0 END IF
      IF cl_null(l_ecb.ecb66) THEN LET l_ecb.ecb66 = 'Y' END IF #TQC-B80022
      IF cl_null(l_ecb.ecb46) OR l_ecb.ecb46 = 0 THEN LET l_ecb.ecb46 = 1 END IF #CHI-B80096--add--
      IF cl_null(l_ecb.ecb51) OR l_ecb.ecb51 = 0 THEN LET l_ecb.ecb51 = 1 END IF #CHI-B80096--add--
      INSERT INTO ecm_file(ecm01        ,ecm02        ,ecm03_par,
                           ecm03        ,
                           ecm04        ,ecm05        ,ecm06,
                           ecm07        ,ecm08        ,ecm09,
		           ecm10        ,ecm11        ,ecm12,
		           ecm121       ,ecm13        ,ecm14,
		           ecm15        ,ecm16        ,ecm17,
		           ecm18        ,ecm19        ,ecm20,
		           ecm21        ,ecm22        ,ecm23,
		           ecm24        ,ecm25        ,ecm26,
                           #TQC-6A0063-begin
		           #ecm27        ,ecm28        ,ecm29,
	                   #ecm30        ,ecm31        ,ecm32,
		           #ecm33        ,ecm34        ,ecm35,
		           ecm27        ,ecm28        ,ecm291,
	                   ecm292       ,ecm301       ,ecm302,
	                   ecm311       ,ecm312       ,ecm313,
	                   ecm314       ,ecm315       ,ecm316,
	                   ecm321       ,ecm322       ,ecm34,
                           ecm35        ,
                           #TQC-6A0063-end
		           ecm36        ,ecm37        ,ecm38,
		           ecm39        ,ecm40        ,ecm41,
		           ecm42        ,ecm43,
                           ecm57        ,ecm58        ,ecm59,          #TQC-6A0071 add
                           ecmplant     ,ecmlegal     ,ecm62,          #CHI-B80096--add--ecm62,ecm63,ecm65-- 
                           ecm63        ,ecm012       ,ecm65,          #FUN-980012 add    #FUN-A60076 add  ecm012 #FUN-A80102
                           ecm66 )
	       VALUES     (p_wo         ,1          ,p_part,
                           l_ecb.ecb03  ,
                           l_ecb.ecb06  ,l_ecb.ecb07  ,l_ecb.ecb08,
                           0            ,0            ,0,
                           0            ,l_ecb.ecb02  ,l_ecb.ecb14,
                           l_ecb.ecb09  ,l_ecb.ecb18  ,l_ecb.ecb19,
                           l_ecb.ecb20  ,l_ecb.ecb21  ,l_ecb.ecb22,
                           l_ecb.ecb10  ,l_eca09      , 0,
                           0            ,0            , 0,
                           0            ,0            , 0,
                           0            ,0            , 0,    
                           0            ,0            , 0, 
                           #TQC-6A0063-begin
                           #0,
                           0            ,0            , 0,
                           0            ,0            , 0,
                           0            ,0            ,
                           #TQC-6A0063-end
                           0            ,0            , 0,
                           l_ecb.ecb26  ,l_ecb.ecb27, l_ecb.ecb28  ,
                           l_ecb.ecb15  ,l_ecb.ecb16, l_ecb.ecb11  ,
                           l_ecb.ecb13  ,
                           l_ecb.ecb44  ,l_ecb.ecb45, l_ecb.ecb46,      #TQC-6A0071 aadd   #MOD-930310
                           g_plant      ,g_legal    , l_ecb.ecb46,      #CHI-B80096--add--ecm62,ecm63,ecm65-- 
                           l_ecb.ecb51  ,l_ecb.ecb012,  0,              #FUN-980012 add   #FUN-A60076 add l_ecb.ecb012 #FUN-A80102
                           l_ecb.ecb66 )

       IF SQLCA.sqlcode  THEN 
          LET l_status=SQLCA.sqlcode 
          EXIT FOREACH
       END IF
       LET l_status=l_status+1
   END FOREACH
   #CHI-B80096--add--Begin--
   LET l_ecm012= ' '
   LET l_sfb08 = ' '
   SELECT DISTINCT sfb08 INTO l_sfb08
     FROM sfb_file WHERE sfb01 = p_wo
   DECLARE schdat1_ecm012_cs CURSOR FOR
      SELECT DISTINCT ecm012 FROM ecm_file
       WHERE ecm01= p_wo
         AND (ecm015 IS NULL OR ecm015=' ')
   FOREACH schdat1_ecm012_cs INTO l_ecm012
      EXIT FOREACH
   END FOREACH
   CALL s_schdat_output(l_ecm012,l_sfb08,p_wo)
   #CHI-B80096--add---End---
#	COMMIT WORK
   RETURN l_status
END FUNCTION
