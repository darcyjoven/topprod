# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: s_bomcheck
# Date & Author..: 98/11/04 By Sophia
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位用like方式
# Modify.........: No.FUN-550112 05/05/27 By ching 特性BOM功能修改
# Modify.........: No.MOD-5A0039 05/10/04 By Claire 變數傳值對應錯誤
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-580165 06/09/07 By kim 新增check_muti_bom函數-> check BOM 至尾階
# Modify.........: No.CHI-740001 07/09/27 By rainy bma_file要判斷有效碼
# Modify.........: No.TQC-7A0068 07/10/19 By rainy CHI-740001 bma_file判斷有效碼沒做OUTER 轉換
# Modify.........: No.FUN-8B0015 08/11/12 By jan 下階料展BOM時，特性代碼抓ima910
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50066 10/06/10 By jan 處理平行製程部份
# Modify.........: No.MOD-C90133 12/09/20 By Elise asft803不檢查生效日和失效日 

DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE
    l_ac      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    g_bmb     RECORD LIKE bmb_file.*,
    g_part    LIKE bmb_file.bmb03,         #No.MOD-490217
    g_mpart   LIKE ima_file.ima01,         #No.MOD-490217
    l_bmb01   LIKE bmb_file.bmb01,
    t_bmb01   LIKE bmb_file.bmb01,
    g_bflag   LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    g_date    LIKE type_file.dat,           #No.FUN-680121 DATE
    g_finded,g_giveup  LIKE type_file.num5    #FUN-580165
    
DEFINE g_bom DYNAMIC ARRAY OF RECORD #FUN-580165
                bmb01 LIKE bmb_file.bmb01,
                bmb03 LIKE bmb_file.bmb03,
                bmb29 LIKE bmb_file.bmb29,
                bmb06 LIKE bmb_file.bmb06,
                bmb07 LIKE bmb_file.bmb07,
                bmb08 LIKE bmb_file.bmb08
             END RECORD
 
 #FUN-A50066--begin--add------------
 DEFINE g_bom1 DYNAMIC ARRAY OF RECORD 
                brb01  LIKE brb_file.brb01,
                brb03  LIKE brb_file.brb03,
                brb29  LIKE brb_file.brb29,
                brb011 LIKE brb_file.brb011,
                brb012 LIKE brb_file.brb012,
                brb013 LIKE brb_file.brb013,
                brb06  LIKE brb_file.brb06,
                brb07  LIKE brb_file.brb07,
                brb08  LIKE brb_file.brb08
             END RECORD
 DEFINE g_brb     RECORD LIKE brb_file.*
 #FUN-A50066--end--add-----------------            
 
FUNCTION i301_bom_check(p_mpart,p_part,p_dat)
    DEFINE p_part LIKE ima_file.ima01, #part number No.MOD-490217
           p_mpart LIKE ima_file.ima01, #part number No.MOD-490217
          p_dat LIKE type_file.dat #effective date
   DEFINE l_ima910   LIKE ima_file.ima910   #FUN-550112
 
    WHENEVER ERROR CONTINUE
    INITIAlIZE g_bmb.* TO NULL
    LET g_bflag = 'Y'
    LET g_date=p_dat
    LET g_mpart = p_mpart
    LET g_part = p_part
    LET l_ac = 0
    LET t_bmb01 = NULL
    #FUN-550112
    LET l_ima910=''
    SELECT ima910 INTO l_ima910 FROM ima_file WHERE ima01=p_part
    IF cl_null(l_ima910) THEN LET l_ima910=' ' END IF
    #--
    CALL check_bom(p_mpart,p_part,l_ima910)  #FUN-550112  #由BOM產生備料檔
    
 
   RETURN g_bmb.*,g_errno
END FUNCTION
 
FUNCTION check_bom(p_key,p_key1,p_key2)  #FUN-550112
DEFINE
   p_key       LIKE bmb_file.bmb01,  #No.MOD-490217
   p_key1      LIKE bmb_file.bmb01,  #No.MOD-490217
   p_key2	LIKE ima_file.ima910,  #FUN-550112
   l_cmd       LIKE type_file.chr1000,#No.FUN-680121 VARCHAR(300)
   l_bmb       RECORD LIKE bmb_file.*,
   l_bma01     LIKE bma_file.bma01,
   l_bmb03     LIKE bmb_file.bmb03,
   l_ac,arrno  LIKE type_file.num5,          #No.FUN-680121 SMALLINT
   l_i,l_x     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
   sr          DYNAMIC ARRAY OF RECORD 
       bmb     RECORD LIKE bmb_file.*,
       bma01   LIKE bma_file.bma01 
       END RECORD,
   b_seq       LIKE type_file.num10          #No.FUN-680121 INTEGER#restart sequence (line number)
DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #No.FUN-8B0015 
 
   LET b_seq = 0
   LET arrno = 500
  #MOD-C90133 add ---S
   IF g_prog = 'asft803' THEN
      LET l_cmd="SELECT bmb_file.*,bma_file.bma01",
                "  FROM bmb_file,OUTER bma_file",
                " WHERE bmb01='", p_key,"' AND bmb02>",b_seq,"",
                "   AND bmb29 ='",p_key2,"' ",  #FUN-550112
                "   AND bmb_file.bmb03=bma_file.bma01",
                "   AND bma_file.bmaacti = 'Y'", #CHI-740001 add  #TQC-7A0068
                " ORDER BY 1"
   ELSE
  #MOD-C90133 add ---E
      LET l_cmd="SELECT bmb_file.*,bma_file.bma01",
                "  FROM bmb_file,OUTER bma_file",
                " WHERE bmb01='", p_key,"' AND bmb02>",b_seq,"",
                "   AND bmb29 ='",p_key2,"' ",  #FUN-550112
                "   AND bmb_file.bmb03=bma_file.bma01",
                "   AND bma_file.bmaacti = 'Y'", #CHI-740001 add  #TQC-7A0068
                "   AND (bmb04 <='",g_date,
                "'   OR bmb04 IS NULL) AND (bmb05 >'",g_date,
                "'   OR bmb05 IS NULL)",
                " ORDER BY 1"
   END IF  #MOD-C90133 add
   PREPARE cralc_ppp FROM l_cmd
   IF SQLCA.sqlcode THEN
        CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN 0 END IF
   DECLARE cralc_cur CURSOR FOR cralc_ppp
   LET l_ac = 1
   FOREACH cralc_cur INTO sr[l_ac].*
       MESSAGE p_key CLIPPED,'-',sr[l_ac].bmb.bmb03 CLIPPED
        IF sr[l_ac].bmb.bmb03 = g_part THEN  #在BOM中找到此料號
          LET g_bmb.* = sr[l_ac].bmb.*   
          EXIT FOREACH
       END IF
       #FUN-8B0015--BEGIN--                                                                                                     
       LET l_ima910[l_ac]=''                                                                                                    
       SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb.bmb03                                               
       IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF                                                            
       #FUN-8B0015--END-- 
       LET l_ac = l_ac + 1
       IF l_ac > arrno THEN EXIT FOREACH END IF
   END FOREACH
   IF g_bmb.bmb03 IS NOT NULL THEN RETURN END IF 
   LET l_x = l_ac - 1
   #-------- NO:0115 -------------#
   IF l_x = 0 THEN 
      LET g_errno='asf-715' RETURN
   END IF
   #------------------------------#
   FOR l_i = 1 TO l_x 
       MESSAGE p_key CLIPPED,'-',sr[l_i].bmb.bmb03 CLIPPED
       IF sr[l_i].bmb.bmb03 = g_part THEN  #在BOM中找到此料號
          LET g_bmb.* = sr[l_i].bmb.*   
          EXIT FOR
       END IF
       IF sr[l_i].bma01 IS NOT NULL THEN
       #   CALL check_bom(sr[l_i].bmb.bmb03,' ',sr[l_i].bmb.bmb01)  #FUN-550112
       #   CALL check_bom(sr[l_i].bmb.bmb03,sr[l_i].bmb.bmb01,' ')  #MOD-5A0039 #FUN-8B0015
           CALL check_bom(sr[l_i].bmb.bmb03,sr[l_i].bmb.bmb01,l_ima910[l_i])  #FUN-8B0015
       END IF
   END FOR
   LET b_seq = sr[l_x].bmb.bmb02
END FUNCTION
 
#FUN-580165...............begin
FUNCTION s_check_muti_bom(p_bmb01,p_bmb03,p_dat,p_bmb29)
DEFINE p_bmb01 LIKE bmb_file.bmb01,
       p_bmb03 LIKE bmb_file.bmb03,
       p_dat  LIKE type_file.dat,
       p_bmb29 LIKE bmb_file.bmb29
 
   IF s_check_root_bom(p_bmb01,p_bmb03,p_dat,p_bmb29) THEN
      LET g_errno=NULL
   ELSE
      LET g_errno='asf-715'
   END IF
   RETURN g_bmb.*,g_errno
END FUNCTION
 
FUNCTION s_check_muti_bom_c(p_bmb01,p_dat,p_bmb29)
DEFINE #l_sql LIKE type_file.chr1000
       l_sql        STRING       #NO.FUN-910082  
DEFINE p_bmb01 LIKE bmb_file.bmb01,
       p_dat  LIKE type_file.dat,
       p_bmb29 LIKE bmb_file.bmb29
 
   LET l_sql="SELECT bmb01,bmb03,bmb29,bmb06,bmb07,bmb08 FROM bmb_file ",
             " WHERE bmb01= '",p_bmb01,"'",
             #"   AND bmb03= '",p_bmb03,"'",
             "   AND bmb29= '",p_bmb29,"'",
             "   AND (bmb04<= '",p_dat,"' OR bmb04 IS NULL)",
             "   AND ( '",p_dat,"' <bmb05 OR bmb05 IS NULL)"
   PREPARE check_muti_bom_p FROM l_sql
   DECLARE check_muti_bom_c CURSOR FOR check_muti_bom_p
END FUNCTION
 
FUNCTION s_check_muti_bom_c1(p_bmb01,p_bmb03,p_dat,p_bmb29)
DEFINE #l_sql LIKE type_file.chr1000
       l_sql        STRING       #NO.FUN-910082  
DEFINE p_bmb01 LIKE bmb_file.bmb01,
       p_bmb03 LIKE bmb_file.bmb03,
       p_dat  LIKE type_file.dat,
       p_bmb29 LIKE bmb_file.bmb29
 
   LET l_sql="SELECT * FROM bmb_file ",
             " WHERE bmb01= '",p_bmb01,"'",
             "   AND bmb03= '",p_bmb03,"'",
             "   AND bmb29= '",p_bmb29,"'",
             "   AND (bmb04<= '",p_dat,"' OR bmb04 IS NULL)",
             "   AND ( '",p_dat,"' <bmb05 OR bmb05 IS NULL)"
   PREPARE check_muti_bom_p1 FROM l_sql
   DECLARE check_muti_bom_c1 CURSOR FOR check_muti_bom_p1
   OPEN check_muti_bom_c1
   FETCH check_muti_bom_c1 INTO g_bmb.*
   CLOSE check_muti_bom_c1
END FUNCTION
 
#kim:檢查料件是否存在BOM,展至尾階 -> RETURN TRUE : 元件存在BOM
FUNCTION s_check_root_bom(p_bmb01,p_bmb03,p_dat,p_bmb29)
DEFINE p_bmb01 LIKE bmb_file.bmb01,
       p_bmb03 LIKE bmb_file.bmb03,
       p_dat  LIKE type_file.dat,
       p_bmb29 LIKE bmb_file.bmb29
DEFINE l_i,l_n   LIKE type_file.num5  
DEFINE l_bom RECORD
                bmb01 LIKE bmb_file.bmb01,
                bmb03 LIKE bmb_file.bmb03,
                bmb29 LIKE bmb_file.bmb29,
                bmb06 LIKE bmb_file.bmb06,
                bmb07 LIKE bmb_file.bmb07,
                bmb08 LIKE bmb_file.bmb08
             END RECORD
   INITIALIZE g_bmb.* TO NULL
   SELECT COUNT(*) INTO l_n FROM bmb_file 
                           WHERE bmb01= p_bmb01
                             AND bmb03= p_bmb03
                             AND bmb29= p_bmb29
                             AND (bmb04<= p_dat OR bmb04 IS NULL)
                             AND ( p_dat <bmb05 OR bmb05 IS NULL)
   IF l_n>0 THEN #元件存在於第一階
      CALL s_check_muti_bom_c1(p_bmb01,p_bmb03,p_dat,p_bmb29)
      RETURN TRUE
   END IF
   CALL g_bom.clear()
   #若不存在第一階,則BOM往下展開
   CALL s_check_muti_bom_c(p_bmb01,p_dat,p_bmb29)   
   LET l_i=1
   FOREACH check_muti_bom_c INTO l_bom.bmb01,
                                 l_bom.bmb03,
                                 l_bom.bmb29,
                                 l_bom.bmb06,
                                 l_bom.bmb07,
                                 l_bom.bmb08
                                 
      LET g_bom[l_i].bmb01=l_bom.bmb01
      LET g_bom[l_i].bmb03=l_bom.bmb03
      LET g_bom[l_i].bmb29=l_bom.bmb29
      LET g_bom[l_i].bmb06=l_bom.bmb06
      LET g_bom[l_i].bmb07=l_bom.bmb07
      LET g_bom[l_i].bmb08=l_bom.bmb08
      LET l_i=l_i+1
   END FOREACH
   CLOSE check_muti_bom_c
   LET l_n=g_bom.getlength()
   LET g_finded=FALSE #找到否
   LET g_giveup=FALSE #未找到,但放棄往下找
   FOR l_i=1 TO l_n
      CALL s_bom_extend(g_bom[l_i].bmb03,p_bmb03,p_dat,' ',2,g_bom[l_i].bmb06,g_bom[l_i].bmb07,g_bom[l_i].bmb08) #第一階以後,特性代碼必為' '
      IF g_finded THEN
         RETURN TRUE
      END IF
      IF g_giveup THEN #已超過最大階數 20 階,找不到,不再找
         RETURN FALSE 
      END IF
   END FOR
   RETURN FALSE #程式會執行到這行,表示該BOM只有一階,或者根本沒BOM
END FUNCTION
 
FUNCTION s_bom_extend(p_bmb01,p_bmb03,p_dat,p_bmb29,p_level,p_bmb06,p_bmb07,p_bmb08)
DEFINE p_bmb01 LIKE bmb_file.bmb01,
       p_bmb03 LIKE bmb_file.bmb03,
       p_dat  LIKE type_file.dat,
       p_bmb29 LIKE bmb_file.bmb29,
       p_bmb06 LIKE bmb_file.bmb06,
       p_bmb07 LIKE bmb_file.bmb07,
       p_bmb08 LIKE bmb_file.bmb08,
       p_level LIKE type_file.num5   #目前階數
DEFINE l_i,l_n   LIKE type_file.num5  
DEFINE l_bom DYNAMIC ARRAY OF RECORD #FUN-580165
                bmb01 LIKE bmb_file.bmb01,
                bmb03 LIKE bmb_file.bmb03,
                bmb29 LIKE bmb_file.bmb29,
                bmb06 LIKE bmb_file.bmb06,
                bmb07 LIKE bmb_file.bmb07,
                bmb08 LIKE bmb_file.bmb08
             END RECORD
   IF p_level > 20 THEN #已超過最大階數 20 階,找不到,不再找
      LET g_giveup=TRUE
      RETURN 
   END IF
   LET l_i=1
   CALL s_check_muti_bom_c(p_bmb01,p_dat,p_bmb29) 
   FOREACH check_muti_bom_c INTO l_bom[l_i].bmb01,
                                 l_bom[l_i].bmb03,
                                 l_bom[l_i].bmb29,
                                 l_bom[l_i].bmb06,
                                 l_bom[l_i].bmb07,
                                 l_bom[l_i].bmb08
      LET l_n=g_bom.getlength()+1
      LET g_bom[l_n].bmb01=l_bom[l_i].bmb01
      LET g_bom[l_n].bmb03=l_bom[l_i].bmb03
      LET g_bom[l_n].bmb29=l_bom[l_i].bmb29
      LET g_bom[l_n].bmb06=p_bmb06*l_bom[l_i].bmb06
      LET g_bom[l_n].bmb07=p_bmb07*l_bom[l_i].bmb07
      LET g_bom[l_n].bmb08=(p_bmb08/100)*(g_bom[l_n].bmb06/g_bom[l_n].bmb07)*(1+l_bom[l_i].bmb08/100)/100
      LET l_bom[l_i].bmb06=g_bom[l_n].bmb06
      LET l_bom[l_i].bmb07=g_bom[l_n].bmb07
      LET l_bom[l_i].bmb08=g_bom[l_n].bmb08
      IF p_bmb03=l_bom[l_i].bmb03 THEN
         LET g_finded=TRUE
         CALL s_check_muti_bom_c1(p_bmb01,p_bmb03,p_dat,p_bmb29)
         LET g_bmb.bmb06=g_bom[l_n].bmb06
         LET g_bmb.bmb07=g_bom[l_n].bmb07
         LET g_bmb.bmb08=g_bom[l_n].bmb08
         RETURN
      END IF
      LET l_i=l_i+1
   END FOREACH
   CLOSE check_muti_bom_c
   
   IF cl_null(l_bom[l_bom.getlength()].bmb03) THEN
      CALL l_bom.deleteElement(l_bom.getlength())
   END IF
   LET l_n=l_bom.getlength()
   FOR l_i=1 TO l_n
      IF cl_null(l_bom[l_i].bmb03) THEN
         CONTINUE FOR
      END IF
      CALL s_bom_extend(l_bom[l_i].bmb03,p_bmb03,p_dat,' ',p_level+1,l_bom[l_i].bmb06,l_bom[l_i].bmb07,l_bom[l_i].bmb08) #第一階以後,特性代碼必為' '
      IF g_giveup THEN #已超過最大階數 20 階,找不到,不再找
         RETURN
      END IF
      IF g_finded THEN #已找到,不再往下找
         RETURN
      END IF
   END FOR
END FUNCTION
#FUN-580165...............end

#FUN-A50066--begig--add---------------------------------------------------------
FUNCTION s_check_muti_bom_brb(p_brb01,p_brb03,p_dat,p_brb29,p_brb011,p_brb012,p_brb013)
DEFINE p_brb01 LIKE brb_file.brb01,
       p_brb03 LIKE brb_file.brb03,
       p_dat   LIKE type_file.dat,
       p_brb29 LIKE brb_file.brb29,
       p_brb011 LIKE brb_file.brb011,
       p_brb012 LIKE brb_file.brb012,
       p_brb013 LIKE brb_file.brb013
 
   IF s_check_root_bom_brb(p_brb01,p_brb03,p_dat,p_brb29,p_brb011,p_brb012,p_brb013) THEN
      LET g_errno=NULL
   ELSE
      LET g_errno='asf-715'
   END IF
   RETURN g_brb.*,g_errno
END FUNCTION

FUNCTION s_check_muti_bom_c_brb(p_brb01,p_dat,p_brb29,p_brb011,p_brb012,p_brb013)
DEFINE l_sql    STRING
DEFINE p_brb01  LIKE brb_file.brb01,
       p_dat    LIKE type_file.dat,
       p_brb29  LIKE brb_file.brb29,
       p_brb011 LIKE brb_file.brb011,
       p_brb012 LIKE brb_file.brb012,
       p_brb013 LIKE brb_file.brb013
 
   LET l_sql="SELECT brb01,brb03,brb29,brb011,brb012,brb013,brb06,brb07,brb08 FROM brb_file ",
             " WHERE brb01= '",p_brb01,"'",
             "   AND brb011= '",p_brb011,"'",
             "   AND brb012= '",p_brb012,"'",
             "   AND brb013 = ",p_brb013,
             "   AND brb29= '",p_brb29,"'",
             "   AND (brb04<= '",p_dat,"' OR brb04 IS NULL)",
             "   AND ( '",p_dat,"' <brb05 OR brb05 IS NULL)"
   PREPARE check_muti_bom_p2 FROM l_sql
   DECLARE check_muti_bom_c2 CURSOR FOR check_muti_bom_p2
END FUNCTION
 
FUNCTION s_check_muti_bom_c1_brb(p_brb01,p_brb03,p_dat,p_brb29,p_brb011,p_brb012,p_brb013)
DEFINE l_sql        STRING       
DEFINE p_brb01  LIKE brb_file.brb01,
       p_brb03  LIKE brb_file.brb03,
       p_dat    LIKE type_file.dat,
       p_brb29  LIKE brb_file.brb29,
       p_brb011 LIKE brb_file.brb011,
       p_brb012 LIKE brb_file.brb012,
       p_brb013 LIKE brb_file.brb013
 
   LET l_sql="SELECT * FROM brb_file ",
             " WHERE brb01= '",p_brb01,"'",
             "   AND brb03= '",p_brb03,"'",
             "   AND brb29= '",p_brb29,"'",
             "   AND brb011= '",p_brb011,"'",
             "   AND brb012= '",p_brb012,"'",
             "   AND brb013 = ",p_brb013,
             "   AND (brb04<= '",p_dat,"' OR brb04 IS NULL)",
             "   AND ( '",p_dat,"' <brb05 OR brb05 IS NULL)"
   PREPARE check_muti_bom_p3 FROM l_sql
   DECLARE check_muti_bom_c3 CURSOR FOR check_muti_bom_p3
   OPEN check_muti_bom_c3
   FETCH check_muti_bom_c3 INTO g_brb.*
   CLOSE check_muti_bom_c3
END FUNCTION

FUNCTION s_check_root_bom_brb(p_brb01,p_brb03,p_dat,p_brb29,p_brb011,p_brb012,p_brb013)
DEFINE p_brb01 LIKE brb_file.brb01,
       p_brb03 LIKE brb_file.brb03,
       p_dat  LIKE type_file.dat,
       p_brb29 LIKE brb_file.brb29,
       p_brb011 LIKE brb_file.brb011,
       p_brb012 LIKE brb_file.brb012,
       p_brb013 LIKE brb_file.brb013
DEFINE l_i,l_n   LIKE type_file.num5  
DEFINE l_bom RECORD
                brb01  LIKE brb_file.brb01,
                brb03  LIKE brb_file.brb03,
                brb29  LIKE brb_file.brb29,
                brb011 LIKE brb_file.brb011,
                brb012 LIKE brb_file.brb012,
                brb013 LIKE brb_file.brb013,
                brb06  LIKE brb_file.brb06,
                brb07  LIKE brb_file.brb07,
                brb08  LIKE brb_file.brb08
             END RECORD
   INITIALIZE g_brb.* TO NULL
   SELECT COUNT(*) INTO l_n FROM brb_file 
                           WHERE brb01= p_brb01
                             AND brb03= p_brb03
                             AND brb29= p_brb29
                             AND brb011=p_brb011
                             AND brb012=p_brbr012
                             AND brb013=p_brb013
                             AND (brb04<= p_dat OR brb04 IS NULL)
                             AND ( p_dat <brb05 OR brb05 IS NULL)
   IF l_n>0 THEN #元件存在於第一階
      CALL s_check_muti_bom_c1_brb(p_brb01,p_brb03,p_dat,p_brb29,p_brb011,p_brb012,p_brb013)
      RETURN TRUE
   END IF
   CALL g_bom1.clear()
   #若不存在第一階,則BOM往下展開
   CALL s_check_muti_bom_c_brb(p_brb01,p_dat,p_brb29,p_brb011,p_brb012,p_brb013)   
   LET l_i=1
   FOREACH check_muti_bom_c2 INTO l_bom.brb01,
                                 l_bom.brb03,
                                 l_bom.brb29,
                                 l_bom.brb011,
                                 l_bom.brb012,
                                 l_bom.brb013,
                                 l_bom.brb06,
                                 l_bom.brb07,
                                 l_bom.brb08
                                 
      LET g_bom1[l_i].brb01=l_bom.brb01
      LET g_bom1[l_i].brb03=l_bom.brb03
      LET g_bom1[l_i].brb29=l_bom.brb29
      LET g_bom1[l_i].brb011=l_bom.brb011
      LET g_bom1[l_i].brb012=l_bom.brb012
      LET g_bom1[l_i].brb013=l_bom.brb013
      LET g_bom1[l_i].brb06=l_bom.brb06
      LET g_bom1[l_i].brb07=l_bom.brb07
      LET g_bom1[l_i].brb08=l_bom.brb08
      LET l_i=l_i+1
   END FOREACH
   CLOSE check_muti_bom_c2
   LET l_n=g_bom1.getlength()
   LET g_finded=FALSE #找到否
   LET g_giveup=FALSE #未找到,但放棄往下找
   FOR l_i=1 TO l_n
      CALL s_bom_extend_brb(g_bom1[l_i].brb03,p_brb03,p_dat,' ',2,g_bom1[l_i].brb011,g_bom1[l_i].brb012,
                        g_bom1[l_i].brb013,g_bom1[l_i].brb06,g_bom1[l_i].brb07,g_bom1[l_i].brb08) #第一階以後,特性代碼必為' '
      IF g_finded THEN
         RETURN TRUE
      END IF
      IF g_giveup THEN #已超過最大階數 20 階,找不到,不再找
         RETURN FALSE 
      END IF
   END FOR
   RETURN FALSE #程式會執行到這行,表示該BOM只有一階,或者根本沒BOM
END FUNCTION
 

FUNCTION s_bom_extend_brb(p_brb01,p_brb03,p_dat,p_brb29,p_level,p_brb011,p_brb012,p_brb013,p_brb06,p_brb07,p_brb08)
DEFINE p_brb01  LIKE brb_file.brb01,
       p_brb03  LIKE brb_file.brb03,
       p_dat    LIKE type_file.dat,
       p_brb29  LIKE brb_file.brb29,
       p_brb06  LIKE brb_file.brb06,
       p_brb07  LIKE brb_file.brb07,
       p_brb08  LIKE brb_file.brb08,
       p_level  LIKE type_file.num5,   #目前階數
       p_brb011 LIKE brb_file.brb011,
       p_brb012 LIKE brb_file.brb012,
       p_brb013 LIKE brb_file.brb013
DEFINE l_i,l_n   LIKE type_file.num5  
DEFINE l_bom DYNAMIC ARRAY OF RECORD #FUN-580165
                brb01  LIKE brb_file.brb01,
                brb03  LIKE brb_file.brb03,
                brb29  LIKE brb_file.brb29,
                brb011 LIKE brb_file.brb011,
                brb012 LIKE brb_file.brb012,
                brb013 LIKE brb_file.brb013,
                brb06  LIKE brb_file.brb06,
                brb07  LIKE brb_file.brb07,
                brb08  LIKE brb_file.brb08
             END RECORD
   IF p_level > 20 THEN #已超過最大階數 20 階,找不到,不再找
      LET g_giveup=TRUE
      RETURN 
   END IF
   LET l_i=1
   CALL s_check_muti_bom_c_brb(p_brb01,p_dat,p_brb29,p_brb011,p_brb012,p_brb013) 
   FOREACH check_muti_bom_c2 INTO l_bom[l_i].brb01,
                                  l_bom[l_i].brb03,
                                  l_bom[l_i].brb29,
                                  l_bom[l_i].brb011,
                                  l_bom[l_i].brb012,
                                  l_bom[l_i].brb013,
                                  l_bom[l_i].brb06,
                                  l_bom[l_i].brb07,
                                  l_bom[l_i].brb08
      LET l_n=g_bom1.getlength()+1
      LET g_bom1[l_n].brb01=l_bom[l_i].brb01
      LET g_bom1[l_n].brb03=l_bom[l_i].brb03
      LET g_bom1[l_n].brb29=l_bom[l_i].brb29
      LET g_bom1[l_n].brb011=l_bom[l_i].brb011
      LET g_bom1[l_n].brb012=l_bom[l_i].brb012
      LET g_bom1[l_n].brb013=l_bom[l_i].brb013
      LET g_bom1[l_n].brb06=p_brb06*l_bom[l_i].brb06
      LET g_bom1[l_n].brb07=p_brb07*l_bom[l_i].brb07
      LET g_bom1[l_n].brb08=(p_brb08/100)*(g_bom1[l_n].brb06/g_bom1[l_n].brb07)*(1+l_bom[l_i].brb08/100)/100
      LET l_bom[l_i].brb06=g_bom1[l_n].brb06
      LET l_bom[l_i].brb07=g_bom1[l_n].brb07
      LET l_bom[l_i].brb08=g_bom1[l_n].brb08
      IF p_brb03=l_bom[l_i].brb03 THEN
         LET g_finded=TRUE
         CALL s_check_muti_bom_c1_brb(p_brb01,p_brb03,p_dat,p_brb29,p_brb011,p_brb012,p_brb013)
         LET g_brb.brb06=g_bom1[l_n].brb06
         LET g_brb.brb07=g_bom1[l_n].brb07
         LET g_brb.brb08=g_bom1[l_n].brb08
         RETURN
      END IF
      LET l_i=l_i+1
   END FOREACH
   CLOSE check_muti_bom_c2
   
   IF cl_null(l_bom[l_bom.getlength()].brb03) THEN
      CALL l_bom.deleteElement(l_bom.getlength())
   END IF
   LET l_n=l_bom.getlength()
   FOR l_i=1 TO l_n
      IF cl_null(l_bom[l_i].brb03) THEN
         CONTINUE FOR
      END IF
      CALL s_bom_extend_brb(l_bom[l_i].brb03,p_brb03,p_dat,' ',p_level+1,l_bom[l_i].brb011,l_bom[l_i].brb012,
                        l_bom[l_i].brb013,l_bom[l_i].brb06,l_bom[l_i].brb07,l_bom[l_i].brb08) #第一階以後,特性代碼必為' '
      IF g_giveup THEN #已超過最大階數 20 階,找不到,不再找
         RETURN
      END IF
      IF g_finded THEN #已找到,不再往下找
         RETURN
      END IF
   END FOR
END FUNCTION
#FUN-A50066--end--add---------------------


