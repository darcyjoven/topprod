# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Program name...: aimt505_sub.4gl
# Description....: 提供aimt505.4gl使用的sub routine
# Date & Author..: 11/10/20 By jason (FUN-BA0056)
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 抓ime_file資料添加imeacti='Y'條件

DATABASE ds

GLOBALS "../../config/top.global"

# 批次新增img_file
# 傳入參數:(1)SQL where條件
#         (2)倉庫
#         (3)儲位
FUNCTION t505s_ins_img(p_wc,p_stk,p_loc,p_defstk)
DEFINE p_wc LIKE type_file.chr1000 
DEFINE p_stk     LIKE imf_file.imf02    
DEFINE p_loc     LIKE imf_file.imf03    
DEFINE p_defstk  LIKE type_file.chr1
DEFINE l_ima     RECORD LIKE ima_file.*    
DEFINE l_img     RECORD LIKE img_file.*
DEFINE l_sql     LIKE type_file.chr1000  
DEFINE l_cnt     LIKE type_file.num5
DEFINE l_showmsg     STRING
   
   LET l_sql = "SELECT * FROM ima_file WHERE 1=1 AND ",p_wc CLIPPED
   PREPARE t505s_prepare FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('prepare ima',SQLCA.SQLCODE,1)
      CLOSE WINDOW t505s_w1 RETURN
   END IF
   DECLARE t505s_cs CURSOR FOR t505s_prepare   
   FOREACH t505s_cs INTO l_ima.*
      IF NOT s_chk_item_no(l_ima.ima01,"") THEN
         CONTINUE FOREACH
      END IF
      LET l_img.img01 = l_ima.ima01      
      LET l_img.img02 = p_stk
      LET l_img.img03 = p_loc     
      LET l_img.img04 = ' '

      #以料件主檔主要倉庫/儲位新增
      IF p_defstk = 'Y' THEN
         LET l_img.img02 = l_ima.ima35
         LET l_img.img03 = l_ima.ima36
      END IF 

      IF l_img.img02 IS NULL THEN LET l_img.img02 = ' ' END IF
      IF l_img.img03 IS NULL THEN LET l_img.img03 = ' ' END IF
      IF l_img.img04 IS NULL THEN LET l_img.img04 = ' ' END IF
    
      #檢查重覆
      LET l_cnt = 0     
      SELECT COUNT(*) INTO l_cnt FROM img_file  
       WHERE img01 = l_img.img01 AND img02 = l_img.img02
         AND img03 = l_img.img03 AND img04 = l_img.img04
      IF l_cnt > 0 THEN 
         LET l_showmsg = l_img.img01, '/', l_img.img02, '/', l_img.img03        
         CALL s_errmsg('img01,img02,img03',l_showmsg,'ins img',"agl-185",1)        
         CONTINUE FOREACH 
      END IF
      
      LET l_img.img08 = 0
      LET l_img.img09 = l_ima.ima25 
      LET l_img.img10 = 0
      LET l_img.img13 = null    
      LET l_img.img14 = g_today
      LET l_img.img15 = g_today
      LET l_img.img16 = g_today
      LET l_img.img17 = g_today       
      LET l_img.img18 = g_lastdat               #儲存有效天數
      LET l_img.img20 = 1                       #轉換率
      LET l_img.img21 = 1                       #轉換率
      SELECT ime04,ime05,ime06,ime07,ime09
        INTO l_img.img22,l_img.img23,l_img.img24,l_img.img25,l_img.img26
        FROM ime_file
       WHERE ime01 = l_img.img02 AND ime02 = l_img.img03
		 AND imeacti='Y'  #FUN-D40103 add
      IF STATUS = 100 THEN
         LET l_img.img22='S'                    #倉儲類別
         LET l_img.img23='Y'                    #是否為可用倉儲
         LET l_img.img24='N'                    #是否為MRP可用倉儲
         LET l_img.img25='N'                    #保稅與否
      END IF
      LET l_img.img30 = 0
      LET l_img.img31 = 0
      LET l_img.img32 = 0
      LET l_img.img33 = 0
      LET l_img.img34 = 0      
      LET l_img.img37 = g_today
      LET l_img.imgplant = g_plant
      LET l_img.imglegal = g_legal
     
      IF s_internal_item( l_img.img01,g_plant ) AND NOT s_joint_venture( l_img.img01 ,g_plant) THEN  
         INSERT INTO img_file VALUES (l_img.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            LET l_showmsg = l_img.img01, '/', l_img.img02, '/', l_img.img03           
            CALL s_errmsg('img01,img02,img03',l_showmsg,'ins img',SQLCA.sqlcode,1)
            LET g_success = 'N'
            CONTINUE FOREACH 
         ELSE           
            MESSAGE 'Insert img:',l_img.img01 CLIPPED,'/',l_img.img02 CLIPPED,'/',l_img.img03           
         END IF
      END IF
   END FOREACH   
      
   IF g_success = 'N' THEN
      RETURN FALSE 
   END IF      
   RETURN TRUE
END FUNCTION
#FUN-BA0056
