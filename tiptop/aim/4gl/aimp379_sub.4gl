# Prog. Version..: '5.30.06-13.03.22(00004)'     #
#
# Program name...: aimp379_sub.4gl
# Description....: 提供aimp379.4gl使用的sub routine
# Date & Author..: 11/05/24 By jan (FUN-B50138)
# Modify.........: No.FUN-B30187 11/06/29 By jason ICD功能修改，增加母批、DATECODE欄位 
# Modify.........: No.TQC-B80005 11/08/03 By jason s_icdpost函數傳入參數
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: No.FUN-D30024 13/03/12 By qiull 負庫存依據imd23判斷

DATABASE ds

GLOBALS "../../config/top.global"

#若 ina00 MATCHES "[1256]" THEN p_flag=+1 ELSE p_flag=-1.(即：入庫p_flag=+1 出庫 p_flag=-1) 
FUNCTION p379sub_p2(p_ina01,p_flag)
DEFINE p_ina01     LIKE ina_file.ina01
DEFINE p_flag      LIKE type_file.num5

   WHENEVER ERROR CONTINUE                #忽略一切錯誤 
   LET g_success='Y'
   LET g_totsuccess = 'Y'  
   IF cl_null(g_bgjob) THEN LET g_bgjob='N' END IF
   CALL p379sub_s1(p_ina01,p_flag)
END FUNCTION
 
FUNCTION p379sub_s1(p_ina01,p_flag)
  DEFINE l_ogc    RECORD LIKE ogc_file.*
  DEFINE l_dt     LIKE type_file.dat   
  DEFINE l_flag   LIKE type_file.num5  
  DEFINE l_flag1  LIKE type_file.chr1 
  DEFINE l_inb    RECORD LIKE inb_file.* 
  DEFINE l_ina    RECORD LIKE ina_file.*
  DEFINE p_ina01  LIKE ina_file.ina01
  DEFINE p_flag   LIKE type_file.num5
  DEFINE l_msg    STRING
  DEFINE l_inbi   RECORD LIKE inbi_file.*   #TQC-B80005
 
  CALL s_showmsg_init()  
  
  SELECT * INTO l_ina.* FROM ina_file WHERE ina01=p_ina01
 
  CALL p379sub_u_ina(p_ina01)
  DECLARE p379sub_s1_c CURSOR FOR SELECT * FROM inb_file WHERE inb01=p_ina01
  FOREACH p379sub_s1_c INTO l_inb.*
     IF STATUS THEN LET g_success='N' RETURN END IF
     IF g_bgjob = 'N' THEN
        LET l_msg= '_s1() read inb:',l_inb.inb03
        CALL cl_msg(l_msg)
     END IF
     CALL ui.Interface.refresh()
     IF cl_null(l_inb.inb04) THEN CONTINUE FOREACH END IF
     IF cl_null(l_inb.inb05) THEN LET l_inb.inb05=' ' END IF
     IF cl_null(l_inb.inb06) THEN LET l_inb.inb06=' ' END IF
     IF cl_null(l_inb.inb07) THEN LET l_inb.inb07=' ' END IF
     CALL s_incchk(l_inb.inb05,l_inb.inb06,g_user) RETURNING l_flag1
     IF l_flag1 = FALSE THEN
         LET g_success='N'
         LET g_showmsg=l_inb.inb03,"/",l_inb.inb05,"/",l_inb.inb06,"/",g_user
         CALL cl_err(g_showmsg,'asf-888',1)
         RETURN 
      END IF
     UPDATE inb_file SET inb13 = 0,
                         inb132 = 0,
                         inb133 = 0,
                         inb134 = 0,
                         inb135 = 0,
                         inb136 = 0,
                         inb137 = 0,
                         inb138 = 0,
                         inb14 = 0
                   WHERE inb01 = l_inb.inb01
                     AND inb03 = l_inb.inb03
     IF STATUS THEN
        IF g_bgerr THEN
           CALL s_errmsg('inb01',l_inb.inb01,'upd inb13:',STATUS,1)
        ELSE
           CALL cl_err3("upd","inb_file",l_inb.inb01,"",SQLCA.sqlcode,"","upd inb13",1)   
        END IF
        LET g_success='N' RETURN 
     END IF
     IF SQLCA.SQLERRD[3]=0 THEN
        IF g_bgerr THEN
           CALL s_errmsg('inb01',l_inb.inb01,'upd inb13:','mfg0177',1)
        ELSE
           CALL cl_err3("upd","inb_file",l_inb.inb01,"","mfg0177","","upd inb13",1) 
        END IF
        LET g_success='N' RETURN
     END IF
 
     IF s_industry('icd') THEN
        #TQC-B80005 --START--
        SELECT * INTO l_inbi.* FROM inbi_file
         WHERE inbi01 = l_inb.inb01 AND inbi03 = l_inb.inb03 
        #TQC-B80005 --END--
     # 呼叫s_icdpost()處理過帳資料-
      CASE
          WHEN l_ina.ina00 MATCHES '[1256]' #出庫
               CALL s_icdpost(-1,l_inb.inb04,l_inb.inb05,l_inb.inb06,
                                 l_inb.inb07,l_inb.inb08,l_inb.inb09,
                                 l_inb.inb01,l_inb.inb03,l_ina.ina02,'N',
                                 '','',l_inbi.inbiicd029,l_inbi.inbiicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119--傳入p_plant參數''---
                    RETURNING l_flag
               IF l_flag = 0 THEN
                  LET g_success = 'N'
                  RETURN
               END IF
          WHEN l_ina.ina00 MATCHES '[34]'   #入庫
               CALL s_icdpost(1,l_inb.inb04,l_inb.inb05,l_inb.inb06,
                                l_inb.inb07,l_inb.inb08,l_inb.inb09,
                                l_inb.inb01,l_inb.inb03,l_ina.ina02,'N',
                                '','',l_inbi.inbiicd029,l_inbi.inbiicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119--傳入p_plant參數''---
                    RETURNING l_flag
               IF l_flag = 0 THEN
                  LET g_success = 'N'
                  RETURN
               END IF
      END CASE
     END IF
 
     IF NOT (l_ina.ina00 MATCHES "[1256]") THEN
        LET l_dt = l_ina.ina02
        IF l_dt IS NULL THEN LET l_dt = l_ina.ina03 END IF
        IF NOT s_stkminus(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                         #l_inb.inb09,l_inb.inb08_fac,l_dt,g_sma.sma894[1,1]) THEN #FUN-D30024--mark
                          l_inb.inb09,l_inb.inb08_fac,l_dt) THEN                   #FUN-D30024--add
           LET g_totsuccess="N"   
           CONTINUE FOREACH
        END IF
     END IF
 
     CALL p379sub_u_imgg(l_inb.*,l_ina.ina01,l_ina.ina02,p_flag)
     IF g_success='N' THEN  
        LET g_totsuccess="N"
        LET g_success="Y"
        CONTINUE FOREACH
     END IF
 
     CALL p379sub_u_img(l_inb.*,p_flag)
     IF g_success='N' THEN  
        LET g_totsuccess="N"
        LET g_success="Y"
        CONTINUE FOREACH
     END IF
 
     CALL p379sub_u_tlf(l_inb.inb04,l_inb.inb03,l_ina.ina01,l_ina.ina02)
     IF g_success='N' THEN 
        LET g_totsuccess="N"
        LET g_success="Y"
        CONTINUE FOREACH
     END IF
 
     CALL p379sub_u_tlfs(l_inb.inb04,l_inb.inb03,l_ina.ina01,l_ina.ina02)
     IF g_success='N' THEN
        LET g_totsuccess="N"
        LET g_success="Y"
        CONTINUE FOREACH
     END IF
 
     #FUN-AC0074--begin--add-----
     IF l_ina.ina00 MATCHES '[12]' THEN
        CALL s_updsie_unsie(l_inb.inb01,l_inb.inb03,'3')
     END IF
     #FUN-AC0074--end--add----

     IF g_success='N' THEN
        RETURN 
     END IF
 
  END FOREACH
 
  IF g_totsuccess="N" THEN  
     LET g_success="N"
  END IF
  CALL s_showmsg()
 
END FUNCTION

FUNCTION p379sub_u_ina(p_ina01)
DEFINE p_ina01     LIKE ina_file.ina01
 
   IF g_bgjob = 'N' THEN
      CALL cl_msg("u_ina!")
   END IF
   CALL ui.Interface.refresh()
    UPDATE ina_file SET inapost='N',ina08='1'  
     WHERE ina01=p_ina01  
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('ina01',p_ina01,'upd inapost:',STATUS,1)
      ELSE
         CALL cl_err3("upd","ina_file",p_ina01,"",SQLCA.sqlcode,"","upd inapost",1)   
      END IF
      LET g_success='N' RETURN
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      IF g_bgerr THEN
         CALL s_errmsg('ina01',p_ina01,'upd inapost:','mfg0177',1)
      ELSE
         CALL cl_err3("upd","ina_file",p_ina01,"","mfg0177","","upd inapost",1)   
      END IF
      LET g_success='N' RETURN
   END IF
END FUNCTION

FUNCTION p379sub_u_imgg(l_inb,p_ina01,p_ina02,p_flag)
  DEFINE l_ima906     LIKE ima_file.ima906
  DEFINE l_ima25      LIKE ima_file.ima25
  DEFINE p_flag       LIKE type_file.num5
  DEFINE l_inb        RECORD LIKE inb_file.*
  DEFINE p_ina01      LIKE ina_file.ina01
  DEFINE p_ina02      LIKE ina_file.ina02
 
    IF g_sma.sma115 = 'N' THEN RETURN END IF    
    SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=l_inb.inb04
    IF l_ima906 = '1' THEN RETURN END IF
    IF cl_null(l_ima906) THEN LET g_success = 'N' RETURN END IF
    SELECT ima25 INTO l_ima25 FROM ima_file
     WHERE ima01=l_inb.inb04
    IF SQLCA.sqlcode THEN
       LET g_success='N' RETURN
    END IF
    IF l_ima906 = '2' THEN  #子母單位
       CALL s_undo_dismantle(p_ina01,l_inb.inb03)
       IF g_success='N' THEN RETURN END IF
       IF NOT cl_null(l_inb.inb905) THEN
          CALL p379sub_upd_imgg('1',l_inb.inb04,l_inb.inb05,l_inb.inb06,
                             l_inb.inb07,l_inb.inb905,l_inb.inb907,
                             l_inb.inb906,'2',p_ina02,p_flag)
          IF g_success='N' THEN RETURN END IF
       END IF
       IF NOT cl_null(l_inb.inb902) THEN
          CALL p379sub_upd_imgg('1',l_inb.inb04,l_inb.inb05,l_inb.inb06,
                             l_inb.inb07,l_inb.inb902,l_inb.inb904,
                             l_inb.inb903,'1',p_ina02,p_flag)
          IF g_success='N' THEN RETURN END IF
       END IF
       CALL p379sub_tlff(l_inb.inb04,l_inb.inb03,p_ina01,p_ina02)
       IF g_success='N' THEN RETURN END IF
    END IF
    IF l_ima906 = '3' THEN  #參考單位
       IF NOT cl_null(l_inb.inb905) THEN
          CALL p379sub_upd_imgg('2',l_inb.inb04,l_inb.inb05,l_inb.inb06,
                             l_inb.inb07,l_inb.inb905,l_inb.inb907,
                             l_inb.inb906,'2',p_ina02,p_flag)
          IF g_success = 'N' THEN RETURN END IF
       END IF
       CALL p379sub_tlff(l_inb.inb04,l_inb.inb03,p_ina01,p_ina02)
       IF g_success='N' THEN RETURN END IF
    END IF
 
END FUNCTION

FUNCTION p379sub_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg10,p_imgg211,p_no,p_ina02,p_flag)
 DEFINE p_imgg00   LIKE imgg_file.imgg00,
        p_imgg01   LIKE imgg_file.imgg01,
        p_imgg02   LIKE imgg_file.imgg02,
        p_imgg03   LIKE imgg_file.imgg03,
        p_imgg04   LIKE imgg_file.imgg04,
        p_imgg09   LIKE imgg_file.imgg09,
        p_imgg10   LIKE imgg_file.imgg10,
        p_imgg211  LIKE imgg_file.imgg211,
        l_ima25    LIKE ima_file.ima25,
        l_ima906   LIKE ima_file.ima906,
        l_imgg21   LIKE imgg_file.imgg21,
        p_ina02    LIKE ina_file.ina02,
        p_flag     LIKE type_file.num5,
        p_no       LIKE type_file.chr1 
 DEFINE l_forupd_sql   STRING
 DEFINE l_cnt      LIKE type_file.num5
 
   IF g_bgjob = 'N' THEN
      CALL cl_msg("update imgg_file ...")
   END IF
   CALL ui.Interface.refresh()
 
   LET l_forupd_sql =
       "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
       "   WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
       "   AND imgg09= ? FOR UPDATE "
 
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE imgg_lock CURSOR FROM l_forupd_sql
 
   OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','OPEN imgg_lock:',STATUS,1)
      ELSE
         CALL cl_err("OPEN imgg_lock:", STATUS, 1)
      END IF
      LET g_success='N'
      CLOSE imgg_lock
      RETURN
   END IF
   FETCH imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','lock imgg fail',STATUS,1)
      ELSE
         CALL cl_err('lock imgg fail',STATUS,1)
      END IF
      LET g_success='N'
      CLOSE imgg_lock
      RETURN
   END IF
 
    SELECT ima25,ima906 INTO l_ima25,l_ima906
      FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       IF g_bgerr THEN
          CALL s_errmsg('ima01',p_imgg01,'ima25 null',SQLCA.sqlcode,0)
       ELSE
          CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","ima25 null",0) 
       END IF
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING l_cnt,l_imgg21
    IF l_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
       IF g_bgerr THEN
          LET g_showmsg = p_imgg01,'/',p_imgg09,'/',l_ima25
          CALL s_errmsg('imgg01,imgg09,ima25',g_showmsg,'','mfg3075',0)
       ELSE
          CALL cl_err('','mfg3075',0)
       END IF
       LET g_success = 'N' RETURN
    END IF
 
   CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_flag,p_imgg10,p_ina02,
          p_imgg01,p_imgg02,p_imgg03,p_imgg04,'','','','',p_imgg09,'',l_imgg21,'','','','','','','',p_imgg211)
   IF g_success = 'N' THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','u_upimgg(-1)','9050',0)
      ELSE
         CALL cl_err('u_upimgg(-1)','9050',0)
      END IF
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION p379sub_tlff(p_inb04,p_inb03,p_ina01,p_ina02)
DEFINE p_inb04     LIKE inb_file.inb04
DEFINE p_inb03     LIKE inb_file.inb03
DEFINE p_ina01     LIKE ina_file.ina01
DEFINE p_ina02     LIKE ina_file.ina02
 
   IF g_bgjob = 'N' THEN
      CALL cl_msg("d_tlff!")
   END IF
    CALL ui.Interface.refresh()
 
    DELETE FROM tlff_file
     WHERE tlff01 =p_inb04
       AND ((tlff026=p_ina01 AND tlff027=p_inb03) OR
            (tlff036=p_ina01 AND tlff037=p_inb03)) #異動單號/項次
       AND tlff905 = p_ina01 
       AND tlff06  = p_ina02 #異動日期
 
    IF STATUS THEN
       IF g_bgerr THEN
          LET g_showmsg = p_inb04,'/',p_ina02
          CALL s_errmsg('tlff01,tlff06',g_showmsg,'del tlff',STATUS,1)
       ELSE
          CALL cl_err3("del","tlf_file",p_ina02,"",STATUS,"","del tlff",1)  
       END IF
       LET g_success='N' RETURN
    END IF
END FUNCTION

FUNCTION p379sub_u_img(l_inb,p_flag) # Update img_file
DEFINE l_qty        LIKE img_file.img10
DEFINE l_inb        RECORD LIKE inb_file.*
DEFINE p_flag       LIKE type_file.num5
DEFINE l_forupd_sql STRING
 
   IF g_bgjob = 'N' THEN
      CALL cl_msg("u_img!")
   END IF
    CALL ui.Interface.refresh()
 
 
   IF g_bgjob = 'N' THEN
      CALL cl_msg("update img_file ...")
   END IF
    CALL ui.Interface.refresh()
    LET l_forupd_sql = " SELECT img01,img02,img03,img04 FROM img_file ",
                       "  WHERE img01= ? ",
                       "    AND img02= ? ",
                       "    AND img03= ? ",
                       "    AND img04= ? ",
                       " FOR UPDATE "
    LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
    DECLARE img_lock CURSOR FROM l_forupd_sql
    OPEN img_lock USING l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07
    IF STATUS THEN             
       CALL cl_err("OPEN img_lock:", STATUS, 1)
       CLOSE img_lock   
       LET g_success='N' 
       RETURN      
    END IF          
    FETCH img_lock INTO l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07
    IF STATUS THEN
       IF g_bgerr THEN
          CALL s_errmsg('','','lock img fail',STATUS,1)
       ELSE
          CALL cl_err('lock img fail',STATUS,1)
       END IF
       LET g_success='N' RETURN
    END IF
 
   LET l_qty=l_inb.inb09*l_inb.inb08_fac
 
   CALL s_upimg(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,p_flag,l_qty,g_today, 
                l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                l_inb.inb01,l_inb.inb03,'','','','','','','','',0,0,'','') 
   IF g_success = 'N' THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','u_upimg(-1)','9050',0)
      ELSE
         CALL cl_err('u_upimg(-1)','9050',0)
      END IF
      RETURN
   END IF
END FUNCTION

FUNCTION p379sub_u_tlf(p_inb04,p_inb03,p_ina01,p_ina02)     # Update tlf_file
DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   
DEFINE l_sql   STRING                                   
DEFINE l_i     LIKE type_file.num5  
DEFINE p_inb04 LIKE inb_file.inb04
DEFINE p_inb03 LIKE inb_file.inb03
DEFINE p_ina01 LIKE ina_file.ina01
DEFINE p_ina02 LIKE ina_file.ina02                    
  
   IF g_bgjob = 'N' THEN
      CALL cl_msg("d_tlf!")
   END IF
 
   CALL ui.Interface.refresh()
 
    LET l_sql =  " SELECT  * FROM tlf_file ", 
                 "  WHERE  tlf01 = '",p_inb04,"'",
                 "    AND ((tlf026='",p_ina01,"' AND tlf027=",p_inb03,") OR ",
                 "        (tlf036='",p_ina01,"' AND tlf037=",p_inb03,")) ",
                 "    AND tlf905 = '",p_ina01,"' AND tlf06 ='",p_ina02,"'"     
    DECLARE p379sub_u_tlf_c CURSOR FROM l_sql
    LET l_i = 0 
    CALL la_tlf.clear()
    FOREACH p379sub_u_tlf_c INTO g_tlf.*
       LET l_i = l_i + 1
       LET la_tlf[l_i].* = g_tlf.*
    END FOREACH     

   DELETE FROM tlf_file
    WHERE tlf01 =p_inb04
      AND ((tlf026=p_ina01 AND tlf027=p_inb03) OR
           (tlf036=p_ina01 AND tlf037=p_inb03)) #異動單號/項次
      AND tlf905 =p_ina01       
      AND tlf06  =p_ina02       #單據日期
 
   IF STATUS THEN
      IF g_bgerr THEN
         LET g_showmsg = p_inb04,'/',p_ina02
         CALL s_errmsg('tlf01,tlf06',g_showmsg,'del tlf:',STATUS,1)
      ELSE
         CALL cl_err3("del","tlf_file",p_ina01,"",STATUS,"","del tlf",1)   
      END IF
      LET g_success='N' RETURN
   END IF
 
   IF SQLCA.SQLERRD[3]=0 THEN
      IF g_bgerr THEN
         LET g_showmsg = p_inb04,'/',p_ina02
         CALL s_errmsg('tlf01,tlf06',g_showmsg,'del tlf:','mfg0177',1)
      ELSE
         CALL cl_err3("del","tlf_file",p_ina01,"","mfg0177","","del tlf",1)  
      END IF
      LET g_success='N' RETURN
   END IF

    FOR l_i = 1 TO la_tlf.getlength()
       LET g_tlf.* = la_tlf[l_i].*
       IF NOT s_untlf1('') THEN 
          LET g_success='N' RETURN
       END IF 
    END FOR       

END FUNCTION

FUNCTION p379sub_u_tlfs(p_inb04,p_inb03,p_ina01,p_ina02) #Update tlfs_file
DEFINE l_ima918   LIKE ima_file.ima918  
DEFINE l_ima921   LIKE ima_file.ima921 
DEFINE p_inb04 LIKE inb_file.inb04
DEFINE p_inb03 LIKE inb_file.inb03
DEFINE p_ina01 LIKE ina_file.ina01
DEFINE p_ina02 LIKE ina_file.ina02  
 
   SELECT ima918,ima921 INTO l_ima918,l_ima921 
     FROM ima_file
    WHERE ima01 = p_inb04
      AND imaacti = "Y"
   
   IF cl_null(l_ima918) THEN
      LET l_ima918='N'
   END IF
                                                                                
   IF cl_null(l_ima921) THEN
      LET l_ima921='N'
   END IF
 
   IF l_ima918 = "N" AND l_ima921 = "N" THEN
      RETURN
   END IF
 
   IF g_bgjob = 'N' THEN
      CALL cl_msg("d_tlfs!")
   END IF
 
   CALL ui.Interface.refresh()
 
   DELETE FROM tlfs_file
    WHERE tlfs01 = p_inb04
      AND tlfs10 = p_ina01
      AND tlfs11 = p_inb03
      AND tlfs111= p_ina02 
 
   IF STATUS THEN
      IF g_bgerr THEN
         LET g_showmsg = p_inb04,'/',p_ina02
         CALL s_errmsg('tlfs01,tlfs111',g_showmsg,'del tlfs:',STATUS,1)
      ELSE
         CALL cl_err3("del","tlfs_file",p_ina01,"",STATUS,"","del tlfs",1)
      END IF
      LET g_success='N'
      RETURN
   END IF
 
   IF SQLCA.SQLERRD[3]=0 THEN
      IF g_bgerr THEN
         LET g_showmsg = p_inb04,'/',p_ina02
         CALL s_errmsg('tlfs01,tlfs111',g_showmsg,'del tlfs:','mfg0177',1)
      ELSE
         CALL cl_err3("del","tlfs_file",p_ina01,"","mfg0177","","del tlfs",1) 
      END IF
      LET g_success='N'
      RETURN
   END IF
 
END FUNCTION
#FUN-B50138
