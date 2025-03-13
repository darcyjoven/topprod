# Prog. Version..: '5.30.06-13.03.12(00004)'     #
# Pattern name...:
# Descriptions...: g_imx二維屬性單身更改后，需要把imx_file,ima_file中不存在的子料件編號新增進去,服飾行業專用程式
# Date & Author..: 2011/11/25  By lixiang (FUN-B90101) 
# Modify.........: No:FUN-C20065 12/02/10 By lixh1 在insert into ima_file之前，當ima159為null時要給'3'
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 在insert into ima_file之前給ima928賦值
# Modify.........: No:TQC-C30196 12/03/10 By lixiang 修改顏色後，遍曆當前行的料件是否存在

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/s_slk.global"

#Usage..........:g_imx二維屬性單身更改后，需要把imx_file,ima_file中不存在的子料件編號新增進去 
#                
# Input Parameter: p_ac 當前所在的行--g_imx二維屬性單身，光標所在的行
#                  p_ima01            母料件編號
#                  p_index            g_imx二維屬性單身，光標所在的具體位置
#

#FUN-B90101
#TQC-C30196--add--begin--
FUNCTION s_ins_ima_color(p_ac,p_ima01)
   DEFINE p_ac    LIKE type_file.num5,
          p_ima01 LIKE ima_file.ima01
 
   IF g_imx[p_ac].imx01 >0 AND (NOT cl_null(g_imx[p_ac].imx01)) THEN
      CALL s_ins_ima_slk(p_ac,1,p_ima01)
   END IF
   IF g_imx[p_ac].imx02 >0 AND (NOT cl_null(g_imx[p_ac].imx02)) THEN
      CALL s_ins_ima_slk(p_ac,2,p_ima01)
   END IF
   IF g_imx[p_ac].imx03 >0 AND (NOT cl_null(g_imx[p_ac].imx03)) THEN
      CALL s_ins_ima_slk(p_ac,3,p_ima01)
   END IF
   IF g_imx[p_ac].imx04 >0 AND (NOT cl_null(g_imx[p_ac].imx04)) THEN
      CALL s_ins_ima_slk(p_ac,4,p_ima01)
   END IF
   IF g_imx[p_ac].imx05 >0 AND (NOT cl_null(g_imx[p_ac].imx05)) THEN
      CALL s_ins_ima_slk(p_ac,5,p_ima01)
   END IF
   IF g_imx[p_ac].imx06 >0 AND (NOT cl_null(g_imx[p_ac].imx06)) THEN
      CALL s_ins_ima_slk(p_ac,6,p_ima01)
   END IF
   IF g_imx[p_ac].imx07 >0 AND (NOT cl_null(g_imx[p_ac].imx07)) THEN
      CALL s_ins_ima_slk(p_ac,7,p_ima01)
   END IF
   IF g_imx[p_ac].imx08 >0 AND (NOT cl_null(g_imx[p_ac].imx08)) THEN
      CALL s_ins_ima_slk(p_ac,8,p_ima01)
   END IF
   IF g_imx[p_ac].imx09 >0 AND (NOT cl_null(g_imx[p_ac].imx09)) THEN
      CALL s_ins_ima_slk(p_ac,9,p_ima01)
   END IF
   IF g_imx[p_ac].imx10 >0 AND (NOT cl_null(g_imx[p_ac].imx10)) THEN
      CALL s_ins_ima_slk(p_ac,10,p_ima01)
   END IF
   IF g_imx[p_ac].imx11 >0 AND (NOT cl_null(g_imx[p_ac].imx11)) THEN
      CALL s_ins_ima_slk(p_ac,11,p_ima01)
   END IF
   IF g_imx[p_ac].imx12 >0 AND (NOT cl_null(g_imx[p_ac].imx12)) THEN
      CALL s_ins_ima_slk(p_ac,12,p_ima01)
   END IF
   IF g_imx[p_ac].imx13 >0 AND (NOT cl_null(g_imx[p_ac].imx13)) THEN
      CALL s_ins_ima_slk(p_ac,13,p_ima01)
   END IF
   IF g_imx[p_ac].imx14 >0 AND (NOT cl_null(g_imx[p_ac].imx14)) THEN
      CALL s_ins_ima_slk(p_ac,14,p_ima01)
   END IF
   IF g_imx[p_ac].imx15 >0 AND (NOT cl_null(g_imx[p_ac].imx15)) THEN
      CALL s_ins_ima_slk(p_ac,15,p_ima01)
   END IF    
END FUNCTION
#TQC-C30196--add--end--
FUNCTION s_ins_ima_slk(p_ac,p_index,p_ima01)
   DEFINE p_ac        LIKE type_file.num5,
          p_index     LIKE type_file.num5,
          p_ima01     LIKE ima_file.ima01,
          l_ima01     LIKE ima_file.ima01,
          l_ima02     LIKE ima_file.ima02,
          l_ps        LIKE sma_file.sma46,
          l_n         LIKE type_file.num5 
   DEFINE l_ima       RECORD LIKE ima_file.*, 
          l_agd03     LIKE agd_file.agd03,
          l_agd03t    LIKE agd_file.agd03

   SELECT sma46 INTO l_ps FROM sma_file
   IF cl_null(l_ps) THEN LET l_ps = ' ' END IF

   LET l_ima01 = p_ima01,l_ps,
                 g_imx[p_ac].color,l_ps,
                 g_imxtext[p_ac].detail[p_index].size

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM imx_file WHERE imx000 = l_ima01
   IF l_n = 0 THEN
      INSERT INTO imx_file(imx000,imx00,imx01,imx02) 
        VALUES (l_ima01,p_ima01,g_imx[p_ac].color,g_imxtext[p_ac].detail[p_index].size)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","imx_file",l_ima01,"",SQLCA.sqlcode,"","",1)  
         LET g_success = 'N'
      END IF
   END IF

   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM ima_file WHERE ima01 = l_ima01
   IF l_n = 0 THEN
      #復制父料件信息到中間變量中 
      SELECT * INTO l_ima.* FROM ima_file WHERE ima01 = p_ima01
      #更改其中部分欄位內容
      LET l_ima.ima01  = l_ima01     
      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = p_ima01
      SELECT agd03 INTO l_agd03 FROM agd_file WHERE agd01 = l_ima.ima940 AND agd02 = g_imx[p_ac].color
      SELECT agd03 INTO l_agd03t FROM agd_file WHERE agd01 = l_ima.ima941 AND agd02 = g_imxtext[p_ac].detail[p_index].size
      LET l_ima.ima02 = l_ima02,l_ps,l_agd03,l_ps,l_agd03t
      LET l_ima.imaag1 = l_ima.imaag
      LET l_ima.imaag = '@CHILD'
      LET l_ima.ima940= g_imx[p_ac].color
      LET l_ima.ima941= g_imxtext[p_ac].detail[p_index].size
      #以下這些代碼是從aimi100中的i100_copy函數中copy來的，到INSERT語句之前為止
      LET l_ima.ima05  =NULL      #目前使用版本
      LET l_ima.ima26  =0         #MPS/MRP可用庫存數量
      LET l_ima.ima261 =0         #不可用庫存數量
      LET l_ima.ima262 =0         #庫存可用數量
      LET l_ima.ima29  =NULL      #最近易動日期
      LET l_ima.ima30  =NULL      #最近盤點日期
      LET l_ima.ima33  =0         #最近售價
      LET l_ima.ima40  =0         #累計使用數量 期間
      LET l_ima.ima41  =0         #累計使用數量 年度
      LET l_ima.ima52  =1         #平均訂購量
      LET l_ima.ima53  =0         #最近采購單價
      LET l_ima.ima532 =NULL      #市價最近異動日期
      LET l_ima.ima73  =NULL      #最近入庫日期
      LET l_ima.ima74  =NULL      #最近出庫日期
      LET l_ima.ima881 =NULL      #期間采購最近采購日期
      LET l_ima.ima91  =0         #平均采購單價
      LET l_ima.ima92  ='N'       
      LET l_ima.ima93  ='NNNNNNNN'
      LET l_ima.ima901 = g_today  #料件建檔日期
      LET l_ima.ima902 = NULL     
      LET l_ima.ima151 = 'N'      
      LET l_ima.imauser=g_user    #資料所有者
      LET l_ima.imagrup=g_grup    #資料所有者所屬群
      LET l_ima.imamodu=NULL      #資料修改日期
      LET l_ima.imadate=g_today   #資料建立日期
      LET l_ima.imaacti='Y'       #有效資料
      IF cl_null(l_ima.ima928) THEN LET l_ima.ima928 = 'N' END IF      #TQC-C20131  add
      IF l_ima.ima01[1,4]='MISC' THEN LET l_ima.ima08='Z' END IF
      IF l_ima.ima35 IS NULL THEN LET l_ima.ima35=' ' END IF 
      IF l_ima.ima36 IS NULL THEN LET l_ima.ima36=' ' END IF
      IF cl_null(l_ima.ima903) THEN LET l_ima.ima903 = 'N' END IF
      IF cl_null(l_ima.ima905) THEN LET l_ima.ima905 = 'N' END IF
      IF cl_null(l_ima.ima910) THEN LET l_ima.ima910 = ' ' END IF
      IF cl_null(l_ima.ima156) THEN LET l_ima.ima156 = 'N' END IF     
      IF cl_null(l_ima.ima158) THEN LET l_ima.ima158 = 'N' END IF
      IF cl_null(l_ima.ima159) THEN LET l_ima.ima159 = '3' END IF   #FUN-C20065 
      #將新的料件信息插回到ima_file中去
      INSERT INTO ima_file VALUES(l_ima.*)
      IF SQLCA.sqlcode THEN 
         CALL cl_err3("ins","ima_file",l_ima.ima01,"",SQLCA.sqlcode,"","",1) 
         LET g_success = 'N'
      END IF
   END IF

END FUNCTION 
#FUN-B90101
