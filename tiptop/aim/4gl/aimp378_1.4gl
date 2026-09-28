DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_imm            RECORD LIKE imm_file.*
DEFINE b_imn            RECORD LIKE imn_file.*
DEFINE g_wc,g_wc2,g_sql string                 #No.FUN-580092 HCN
DEFINE u_flag           LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_argv1          LIKE imm_file.imm01    #No.FUN-550029 #No.FUN-690026 VARCHAR(16)
DEFINE g_cnt            LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_change_lang    LIKE type_file.chr1    #是否有做語言切換 No.FUN-570122  #No.FUN-690026 VARCHAR(1)
DEFINE g_msg            LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_forupd_sql     STRING                 #SELECT ... FOR UPDATE SQL

FUNCTION p378_s1(p_imm01,p_i)
 #---No.MOD-570028 add
  DEFINE l_img09      LIKE img_file.img09,
         l_factor     LIKE ima_file.ima31_fac  #No.FUN-690026 DECIMAL(16,8)
  DEFINE l_imn22      LIKE imn_file.imn22
  DEFINE l_cnt        LIKE type_file.num10     #No.FUN-690026 INTEGER
#--end
  DEFINE l_flag       LIKE type_file.num5      #FUN-930038
  DEFINE l_imn10      LIKE imn_file.imn10      #MOD-A70117 add
  DEFINE l_imni RECORD LIKE imni_file.*        #TQC-B80005
  DEFINE p_imm01      LIKE imm_file.imm01      #add by guanyao160721
  DEFINE p_i          LIKE type_file.chr1      #add by guanyao160721

  #str-----add by guanyao160721
  LET g_success ='Y'
  LET g_imm.imm01 = p_imm01
  LET g_bgjob = p_i
  #end-----add by gauyao160721
  #TQC-AC0218--begin--add--
  IF g_bgjob = 'Y' THEN
     SELECT * INTO g_imm.* FROM imm_file WHERE imm01=g_imm.imm01
  END IF
  #TQC-AC0218--end--add---

  CALL p378_u_imm()
 
  CALL s_showmsg_init()   #No.FUN-6C0083 
 
  DECLARE p378_s1_c CURSOR FOR SELECT * FROM imn_file WHERE imn01=g_imm.imm01
  FOREACH p378_s1_c INTO b_imn.*
      IF STATUS THEN LET g_success='N' RETURN END IF
     #No.FUN-570122 ----Start----
      IF g_bgjob = 'N' THEN
         MESSAGE '_s1() read imn:',b_imn.imn02
      END IF
     #MESSAGE '_s1() read imn:',b_imn.imn02
     #No.FUN-570122 ----End----
      MESSAGE '_s1() read imn:',b_imn.imn02 
      CALL ui.Interface.refresh()
      IF cl_null(b_imn.imn03) THEN CONTINUE FOREACH END IF
 
 #--No.MOD-570028 add
      SELECT img09 INTO l_img09 FROM img_file
         WHERE img01=b_imn.imn03 AND img02=b_imn.imn15
           AND img03=b_imn.imn16 AND img04=b_imn.imn17
      CALL s_umfchk(b_imn.imn03,b_imn.imn20,l_img09) RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         CALL cl_err('','mfg3075',1)
         LET g_success = 'N'
         RETURN 1
      END IF
      LET l_imn22 = b_imn.imn22 * l_factor
#--end
     #str MOD-A70117 add
      SELECT img09 INTO l_img09 FROM img_file   #MOD-A70150
         WHERE img01=b_imn.imn03 AND img02=b_imn.imn04   #MOD-A70150
           AND img03=b_imn.imn05 AND img04=b_imn.imn06   #MOD-A70150
      LET l_cnt = 0   LET l_factor = 0
      CALL s_umfchk(b_imn.imn03,b_imn.imn09,l_img09) RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         CALL cl_err('','mfg3075',1)
         LET g_success = 'N'
         RETURN 1
      END IF
      LET l_imn10 = b_imn.imn10 * l_factor
     #end MOD-A70117 add
 
    #No.+046 010409 by plum modi
     
    # CALL p378_u_img(b_imn.imn10,b_imn.imn03,b_imn.imn04,
    #                             b_imn.imn05,b_imn.imn06)
    # IF g_success='N' THEN RETURN END IF
    # CALL p378_u_img(b_imn.imn22*-1,b_imn.imn03,b_imn.imn15,
    #                                b_imn.imn16,b_imn.imn17)
    # IF g_success='N' THEN RETURN END IF
 
      #FUN-930038...................begin
      IF s_industry('icd') THEN
         #TQC-B80005 --START--
         SELECT * INTO l_imni.* FROM imni_file
          WHERE imni01 = b_imn.imn01 AND imni02 = b_imn.imn02  
         #TQC-B80005 --END--
         
         #入庫
         CALL s_icdpost(1,b_imn.imn03,b_imn.imn15,b_imn.imn16,
                        b_imn.imn17,b_imn.imn20,b_imn.imn22,
                       #b_imn.imn01,b_imn.imn02,g_imm.imm02,'N',   #FUN-D50079 mark
                        b_imn.imn01,b_imn.imn02,g_imm.imm17,'N',   #FUN-D50079 add
                        '','',l_imni.imniicd029,l_imni.imniicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119--傳入p_plant參數''---
              RETURNING l_flag
         IF l_flag = 0 THEN
            LET g_success = 'N'
            RETURN
         END IF
         #出庫
         CALL s_icdpost(-1,b_imn.imn03,b_imn.imn04,b_imn.imn05,
                        b_imn.imn06,b_imn.imn09,b_imn.imn10, 
                       #b_imn.imn01,b_imn.imn02,g_imm.imm02,'N',   #FUN-D50079 mark
                        b_imn.imn01,b_imn.imn02,g_imm.imm17,'N',   #FUN-D50079 add
                        '','',l_imni.imniicd029,l_imni.imniicd028,'') #FUN-B30187 #TQC-B80005  #FUN-B80119--傳入p_plant參數''---
              RETURNING l_flag
         IF l_flag = 0 THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      #FUN-930038...................end
 
      #FUN-540025  --begin
      CALL p378_u_imgg()      
      #FUN-540025  --end
      #TQC-620156...............begin
      IF g_success='N' THEN   #No.FUN-6C0083
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH
      END IF
      #TQC-620156...............end
     #CALL p378_u_img(b_imn.imn10,+1,b_imn.imn03,b_imn.imn04,  #MOD-A70117 mark
      CALL p378_u_img(l_imn10,+1,b_imn.imn03,b_imn.imn04,      #MOD-A70117
                                  b_imn.imn05,b_imn.imn06,b_imn.imn02)   #No.MOD-710059 modify
      IF g_success='N' THEN    #No.FUN-6C0083
         #TQC-620156...............begin
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH
         #RETURN
         #TQC-620156...............end
      END IF
       CALL p378_u_img(l_imn22,-1,b_imn.imn03,b_imn.imn15,     #MOD-570028 modify
                      b_imn.imn16,b_imn.imn17,b_imn.imn02) #No.MOD-710059 modify
 
      IF g_success='N' THEN    #No.FUN-6C0083
         #TQC-620156...............begin
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH
         #RETURN
         #TQC-620156...............end
      END IF 
    #NO.+046..end
#     CALL p378_u_ima()                   #No.FUN-A20044
#     IF g_success='N' THEN RETURN END IF #No.FUN-A20044
      CALL p378_u_tlf()
      IF g_success='N' THEN    #No.FUN-6C0083
         #TQC-620156...............begin
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH
         #RETURN
         #TQC-620156...............end
      END IF
 
     #-----No.FUN-860045-----
     CALL p378_u_tlfs()
     IF g_success='N' THEN
        LET g_totsuccess="N"
        LET g_success="Y"
        CONTINUE FOREACH
     END IF
     #-----No.FUN-860045 END-----
     #FUN-AC0074--begin--add-----
     CALL s_updsie_unsie(b_imn.imn01,b_imn.imn02,'4')
     IF g_success='N' THEN
        LET g_totsuccess="N"
        LET g_success="Y"
        CONTINUE FOREACH
     END IF
     #FUN-AC0074--end--add----
 
  END FOREACH
 
  #TQC-620156...............begin
  IF g_totsuccess="N" THEN
     LET g_success="N"
  END IF
  CALL s_showmsg()   #No.FUN-6C0083
  #TQC-620156...............end
  
END FUNCTION
 
#No.FUN-540025  --begin
FUNCTION p378_u_imgg()
  DEFINE l_ima906     LIKE ima_file.ima906
  DEFINE l_ima25      LIKE ima_file.ima25
  
    IF g_sma.sma115 = 'N' THEN RETURN END IF
    SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=b_imn.imn03
    IF l_ima906 = '1' THEN RETURN END IF
    IF cl_null(l_ima906) THEN LET g_success = 'N' RETURN END IF
    SELECT ima25 INTO l_ima25 FROM ima_file
     WHERE ima01=b_imn.imn03
    IF SQLCA.sqlcode THEN
       LET g_success='N' RETURN
    END IF
    IF l_ima906 = '2' THEN  #子母單位
       #source
       IF NOT cl_null(b_imn.imn33) THEN
          CALL p378_upd_imgg('1',b_imn.imn03,b_imn.imn04,b_imn.imn05,
                             b_imn.imn06,b_imn.imn33,b_imn.imn35,
                             b_imn.imn34,+1,'2')
          IF g_success='N' THEN RETURN END IF
       END IF
       IF NOT cl_null(b_imn.imn30) THEN
          CALL p378_upd_imgg('1',b_imn.imn03,b_imn.imn04,b_imn.imn05,
                             b_imn.imn06,b_imn.imn30,b_imn.imn32,
                             b_imn.imn31,+1,'1')
          IF g_success='N' THEN RETURN END IF
       END IF
       #destination
       IF NOT cl_null(b_imn.imn43) THEN
          CALL p378_upd_imgg('1',b_imn.imn03,b_imn.imn15,b_imn.imn16,
                             b_imn.imn17,b_imn.imn43,b_imn.imn45,
                             b_imn.imn44,-1,'2')
          IF g_success='N' THEN RETURN END IF
       END IF
       IF NOT cl_null(b_imn.imn40) THEN
          CALL p378_upd_imgg('1',b_imn.imn03,b_imn.imn15,b_imn.imn16,
                             b_imn.imn17,b_imn.imn40,b_imn.imn42,
                             b_imn.imn41,-1,'1')
          IF g_success='N' THEN RETURN END IF
       END IF
       CALL p378_tlff()
       IF g_success='N' THEN RETURN END IF
    END IF
    IF l_ima906 = '3' THEN  #參考單位
       #source
       IF NOT cl_null(b_imn.imn33) THEN
          CALL p378_upd_imgg('2',b_imn.imn03,b_imn.imn04,b_imn.imn05,
                             b_imn.imn06,b_imn.imn33,b_imn.imn35,
                             b_imn.imn34,+1,'2')
          IF g_success = 'N' THEN RETURN END IF
       END IF
       #destination
       IF NOT cl_null(b_imn.imn43) THEN
          CALL p378_upd_imgg('2',b_imn.imn03,b_imn.imn15,b_imn.imn16,
                             b_imn.imn17,b_imn.imn43,b_imn.imn45,
                             b_imn.imn44,-1,'2')
          IF g_success = 'N' THEN RETURN END IF
       END IF
       CALL p378_tlff()
       IF g_success='N' THEN RETURN END IF
    END IF
 
END FUNCTION
 
FUNCTION p378_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg10,p_imgg211,p_flag,p_no)
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
        p_flag     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
        p_no       LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
  #No.FUN-570122 ----Start----
   IF g_bgjob = 'N' THEN
      MESSAGE "update imgg_file ..."
   END IF
   #MESSAGE "update imgg_file ..."
   #No.FUN-570122 ----End----
 
   CALL ui.Interface.refresh()
 
   LET g_forupd_sql =
       "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
       "   WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
       "   AND imgg09= ? FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE imgg_lock CURSOR FROM g_forupd_sql
 
   OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
   IF STATUS THEN
      CALL cl_err("OPEN imgg_lock:", STATUS, 1)
      LET g_success='N'
      CLOSE imgg_lock
      #ROLLBACK WORK        #NO.TQC-930155---mark----
      RETURN
   END IF
   FETCH imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
   IF STATUS THEN
      CALL cl_err('lock imgg fail',STATUS,1)
      LET g_success='N'
      CLOSE imgg_lock
      #ROLLBACK WORK        #NO.TQC-930155---mark----
      RETURN
   END IF
 
    SELECT ima25,ima906 INTO l_ima25,l_ima906
      FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
#      CALL cl_err('ima25 null',SQLCA.sqlcode,0)   #No.FUN-660156 MARK
       CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","ima25 null",0)  #No.FUN-660156
       LET g_success = 'N' RETURN 
    END IF
    
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING g_cnt,l_imgg21
    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no = '2') THEN 
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' RETURN 
    END IF
 
  #CALL s_upimgg(' ',p_flag,p_imgg10,g_imm.imm02, #FUN-8C0083
  #CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_flag,p_imgg10,g_imm.imm02,#FUN-8C0083  #FUN-D50079 mark
   CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_flag,p_imgg10,g_imm.imm17,             #FUN-D50079 
          p_imgg01,p_imgg02,p_imgg03,p_imgg04,'','','','',p_imgg09,'',l_imgg21,'','','','','','','',p_imgg211)
   IF g_success = 'N' THEN
      CALL cl_err('u_upimgg(-1)','9050',0) RETURN
   END IF
 
END FUNCTION
 
FUNCTION p378_tlff()
 
   #No.FUN-570122 ----Start----
   IF g_bgjob = 'N' THEN
      MESSAGE "d_tlff!"
   END IF
   #MESSAGE "d_tlff!"
   #No.FUN-570122 ----End----
    CALL ui.Interface.refresh()
 
    DELETE FROM tlff_file
     WHERE tlff01 =b_imn.imn03
       AND ((tlff026=g_imm.imm01 AND tlff027=b_imn.imn02) OR
            (tlff036=g_imm.imm01 AND tlff037=b_imn.imn02)) #異動單號/項次 
      #AND tlff06 =g_imm.imm02 #異動日期   #FUN-D50079 mark
       AND tlff06 =g_imm.imm17 #異動日期   #FUN-D50079
          
    IF STATUS THEN
#       CALL cl_err('del tlff:',STATUS,1) LET g_success='N' RETURN
      #CALL cl_err3("del","tlff_file",g_imm.imm02,"",STATUS,"","del tlff:",1)   #NO.FUN-640266  #FUN-D50079 mark
       CALL cl_err3("del","tlff_file",g_imm.imm17,"",STATUS,"","del tlff:",1)   #FUN-D50079 
       LET g_success='N' RETURN
    END IF
END FUNCTION
#FUN-540025  --end   
 
FUNCTION p378_u_imm()
   #No.FUN-570122 ----Start----
   IF g_bgjob = 'N' THEN
      MESSAGE "u_imm!"
   END IF
   #MESSAGE "u_imm!"
   #No.FUN-570122 ----End----
    CALL ui.Interface.refresh()
    UPDATE imm_file SET imm03='N' WHERE imm01=g_imm.imm01
    IF STATUS THEN
#       CALL cl_err('upd imm03:',STATUS,1) LET g_success='N' RETURN
       CALL cl_err3("upd","imm_file",g_imm.imm01,"",SQLCA.sqlcode,"","upd imm03",1)   #NO.FUN-640266 #No.FUN-660156
       LET g_success='N' RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
#       CALL cl_err('upd imm03:','mfg0177',1) LET g_success='N' RETURN
        CALL cl_err3("upd","imm_file",g_imm.imm01,"","mfg0177","","upd imm03",1)  #NO.FUN-640266  #No.FUN-660156
        LET g_success = 'N'
        RETURN
    END IF
END FUNCTION
 
FUNCTION p378_u_img(qty,p_type,p1,p2,p3,p4,p5) # Update img_file  #No.MOD-710059 modify
    DEFINE qty		LIKE img_file.img10  #MOD-530179
    DEFINE p1           LIKE img_file.img01, #NO.MOD-490217
         #----------------No.MOD-650117 modify
          #p2,p3,p4 VARCHAR(20),
           p2           LIKE img_file.img02,
           p3           LIKE img_file.img03,
           p4           LIKE img_file.img04,
           p5           LIKE imn_file.imn02,    #No.MOD-710059 add
         #----------------No.MOD-650117 end
           l_str        STRING,                 #No.MOD-710059 add
           p_type       LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
   #No.FUN-570122 ----Start----
   IF g_bgjob = 'N' THEN
      MESSAGE "u_img!"
   END IF
   #MESSAGE "u_img!"
   #No.FUN-570122 ----End----
    CALL ui.Interface.refresh()
    IF p2 IS NULL THEN LET p2=' ' END IF
    IF p3 IS NULL THEN LET p3=' ' END IF
    IF p4 IS NULL THEN LET p4=' ' END IF
 
  #No.3443 01/09/04 By Carol add lock img_file .......................
{
    SELECT img01,img02,img03,img04 INTO p1,p2,p3,p4 FROM img_file
     WHERE img01=p1 AND img02=p2 AND img03=p3 AND img04=p4
    IF STATUS THEN
       CALL cl_err('sel img:',STATUS,1) LET g_success='N' RETURN
    END IF
}
   #No.FUN-570122 ----Start----
   IF g_bgjob = 'N' THEN
      MESSAGE "update img_file ..."
   END IF
   #MESSAGE "update img_file ..."
   #No.FUN-570122 ----End----
    CALL ui.Interface.refresh()
    LET g_forupd_sql =
      " SELECT img01,img02,img03,img04 FROM img_file ",
      "    WHERE img01= ? ", 
      "    AND img02= ? ",
      "    AND img03= ? ",
      "    AND img04= ? ",
      " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock CURSOR FROM g_forupd_sql 
    OPEN img_lock USING p1,p2,p3,p4
    #NO.TQC-930155------begin-----          
    IF STATUS THEN                           
       CALL cl_err("Open img_lock",STATUS,1)  
       CLOSE img_lock            
       LET g_success = 'N'        
       RETURN                      
    END IF                          
    #NO.TQC-930155------end-------------- 
    FETCH img_lock INTO p1,p2,p3,p4
   #-------------------No.MOD-710059 modify
   #IF STATUS THEN
   #   CALL cl_err('lock img fail',STATUS,1) LET g_success='N' RETURN
   #END IF
    IF STATUS THEN
       LET l_str = "lock img fail, Line No:",p5 CLIPPED
       CALL cl_err(l_str,STATUS,1) LET g_success='N' RETURN
    END IF
   #-------------------No.MOD-710059 end
  #No.3443 end .......................................................
 
   #No.+046 010409 by plum mark 改統一由s_upimg去判斷庫存不足(sma894)來控管
   {
    IF qty < 0 AND l_img10 + qty < 0    ## 庫存為負時
       THEN
       LET g_sql=p1 clipped,'/',p2 clipped,'/',p3 clipped,'/',p4 clipped
       CALL cl_err(g_sql,'asf-375',1)
       LET g_success = 'N'
       RETURN
    END IF
 
    UPDATE img_file SET img10=img10+qty
           WHERE img01=p1 AND img02=p2 AND img03=p3 AND img04=p4
    IF STATUS THEN
#       CALL cl_err('upd img10:',STATUS,1) LET g_success='N' RETURN
       CALL cl_err3("upd","img_file",p1,p2,STATUS,"","upd img10",1)      #NO.FUN-640266  #No.FUN-660156
       LET g_success='N' RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
        CALL cl_err3("upd","img_file",p1,p2,"mfg0177","","upd img10",1)      #NO.FUN-640266
        LET g_success='N' RETURN
#       CALL cl_err('upd img10:','mfg0177',1) LET g_success='N' RETURN
    END IF
   #No.+046..end}
  
 
   #FUN-550011................begin
   IF p_type='-1' THEN
     #------------No.TQC-690001 modify
     #IF NOT s_stkminus(b_imn.imn03,b_imn.imn04,b_imn.imn05,b_imn.imn06,
     #                  b_imn.imn10,1,g_imm.imm02,g_sma.sma894[4,4]) THEN
      IF NOT s_stkminus(b_imn.imn03,b_imn.imn15,b_imn.imn16,b_imn.imn17,
                       #b_imn.imn22,1,g_imm.imm02,g_sma.sma894[4,4]) THEN  #FUN-D30024--mark
                       #b_imn.imn22,1,g_imm.imm02) THEN                    #FUN-D30024--add   #FUN-D50079 mark
                        b_imn.imn22,1,g_imm.imm17) THEN                    #FUN-D50079 
     #------------No.TQC-690001 end
         LET g_success='N'
         RETURN
      END IF
   END IF
   #FUN-550011................end
 
  #No.+046 010409 by plum add 改統一由s_upimg去判斷庫存不足(sma894)來控管
  #CALL s_upimg(' ',p_type,qty,g_today,'','','','',       #FUN-8C0084
   CALL s_upimg(p1,p2,p3,p4,p_type,qty,g_today,'','','','',   #FUN-8C0084
                b_imn.imn01,b_imn.imn02,'','','','','','','','',0,0,'','')   #No.FUN-860045
   IF g_success = 'N' THEN
      LET g_msg='parts: ',p1 CLIPPED,' ',p2 CLIPPED,' ',p3 CLIPPED,
                ' ',p4 CLIPPED
      CALL cl_err(g_msg,'9050',1) RETURN
   END IF
  #No.+046..end
END FUNCTION
 
#No.FUN-A20044 ---mark----start
#FUNCTION p378_u_ima() #------------------------------------ Update ima_file
#    DEFINE l_ima26,l_ima261,l_ima262	LIKE ima_file.ima26  
# 
#   #No.FUN-570122 ----Start----
#   IF g_bgjob = 'N' THEN
#      MESSAGE "u_ima!"
#   END IF
#   #MESSAGE "u_ima!"
#   #No.FUN-570122 ----End----
#    CALL ui.Interface.refresh()
#    LET l_ima26=0 LET l_ima261=0 LET l_ima262=0
#    SELECT SUM(img10*img21) INTO l_ima26  FROM img_file
#           WHERE img01=b_imn.imn03 AND img23='Y' AND img24='Y'
#    IF STATUS THEN #CALL cl_err('sel sum1:',STATUS,1) LET g_success='N' END IF
#       CALL cl_err3("sel","img_file",b_imn.imn03,"",SQLCA.sqlcode,"","sel sum1",1)   #NO.FUN-640266 #No.FUN-660156
#       LET g_success='N' 
#    END IF
#    IF l_ima26 IS NULL THEN LET l_ima26=0 END IF
#    SELECT SUM(img10*img21) INTO l_ima261 FROM img_file
#           WHERE img01=b_imn.imn03 AND img23='N'
#    IF STATUS THEN #CALL cl_err('sel sum2:',STATUS,1) LET g_success='N' END IF
#       CALL cl_err3("sel","img_file",b_imn.imn03,"",SQLCA.sqlcode,"","sel sum2",1)   #No.FUN-660156
#    LET g_success='N' END IF
#    IF l_ima261 IS NULL THEN LET l_ima261=0 END IF
#    SELECT SUM(img10*img21) INTO l_ima262 FROM img_file
#           WHERE img01=b_imn.imn03 AND img23='Y'
#    IF STATUS THEN #CALL cl_err('sel sum3:',STATUS,1) LET g_success='N' END IF
#       CALL cl_err3("sel","img_file",b_imn.imn03,"",SQLCA.sqlcode,"","sel sum3",1)   #No.FUN-660156
#    LET g_success='N' END IF
#    IF l_ima262 IS NULL THEN LET l_ima262=0 END IF
#    UPDATE ima_file SET 
#                    ima26=l_ima26,ima261=l_ima261,ima262=l_ima262
#               WHERE ima01= b_imn.imn03
#    IF STATUS THEN
##       CALL cl_err('upd ima26*:',STATUS,1) LET g_success='N' RETURN
#       CALL cl_err3("upd","ima_file",b_imn.imn03,"",SQLCA.sqlcode,"","upd ima26*",1)   #NO.FUN-640266 #No.FUN-660156
#       LET g_success='N' RETURN
#    END IF
#    IF SQLCA.SQLERRD[3]=0 THEN
##       CALL cl_err('upd ima26*:','mfg0177',1) 
#        CALL cl_err3("upd","ima_file",b_imn.imn03,"","mfg0177","","upd ima26*",1)      #NO.FUN-640266 #No.FUN-660156
#        LET g_success='N' RETURN
#    END IF
#END FUNCTION
#No.FUN-A20044 ---mark---end 
 
FUNCTION p378_u_tlf() #------------------------------------ Update tlf_file
  DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
  DEFINE l_sql   STRING                                    #NO.FUN-8C0131 
  DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131 
   #No.FUN-570122 ----Start----
   IF g_bgjob = 'N' THEN
      MESSAGE "d_tlf!"
   END IF
   #MESSAGE "d_tlf!"
   #No.FUN-570122 ----End----
    CALL ui.Interface.refresh()
  ##NO.FUN-8C0131   add--begin   
    LET l_sql =  " SELECT  * FROM tlf_file ", 
                 "  WHERE  tlf01 = '",b_imn.imn03,"'",
                 "    AND ((tlf026='",g_imm.imm01,"' AND tlf027=",b_imn.imn02,") OR ",
                 "        (tlf036='",g_imm.imm01,"' AND tlf037=",b_imn.imn02,")) ",
                #"   AND tlf06 ='",g_imm.imm02,"'"  #FUN-D50079 mark   
                 "   AND tlf06 ='",g_imm.imm17,"'"  #FUN-D50079    
    DECLARE p378_u_tlf_c CURSOR FROM l_sql
    LET l_i = 0 
    CALL la_tlf.clear()
    FOREACH p378_u_tlf_c INTO g_tlf.*
       LET l_i = l_i + 1
       LET la_tlf[l_i].* = g_tlf.*
    END FOREACH     

  ##NO.FUN-8C0131   add--end  
    DELETE FROM tlf_file
           WHERE tlf01 =b_imn.imn03
             AND ((tlf026=g_imm.imm01 AND tlf027=b_imn.imn02) OR
                  (tlf036=g_imm.imm01 AND tlf037=b_imn.imn02)) #異動單號/項次 
            #AND tlf06 =g_imm.imm02 #異動日期    #FUN-D50079 mark
             AND tlf06 =g_imm.imm17 #異動日期    #FUN-D50079 
    IF STATUS THEN
#      CALL cl_err('del tlf:',STATUS,1) 
      #CALL cl_err3("del","tlf_file",g_imm.imm02,"",STATUS,"","del tlf:",1)   #NO.FUN-640266 #No.FUN-660156  #FUN-D50079 mark
       CALL cl_err3("del","tlf_file",g_imm.imm17,"",STATUS,"","del tlf:",1)   #FUN-D50079 
       LET g_success='N' RETURN
       LET g_success='N' RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
#      CALL cl_err('del tlf:','mfg0177',1) 
      #CALL cl_err3("del","tlf_file",g_imm.imm02,"","mfg0177","","del tlf:",1)   #NO.FUN-640266 #No.FUN-660156 #FUN-D50079 mark
       CALL cl_err3("del","tlf_file",g_imm.imm17,"","mfg0177","","del tlf:",1)   #FUN-D50079 mark
       LET g_success='N' RETURN
       LET g_success='N' RETURN
    END IF
  ##NO.FUN-8C0131   add--begin
    FOR l_i = 1 TO la_tlf.getlength()
       LET g_tlf.* = la_tlf[l_i].*
       IF NOT s_untlf1('') THEN 
          LET g_success='N' RETURN
       END IF 
    END FOR       
  ##NO.FUN-8C0131   add--end    
END FUNCTION
 
#-----No.FUN-860045-----
FUNCTION p378_u_tlfs() #------------------------------------ Update tlfs_file
   DEFINE l_ima918   LIKE ima_file.ima918
   DEFINE l_ima921   LIKE ima_file.ima921
 
   SELECT ima918,ima921 INTO l_ima918,l_ima921 
     FROM ima_file
    WHERE ima01 = b_imn.imn03
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
      MESSAGE "d_tlfs!"
   END IF
 
   CALL ui.Interface.refresh()
 
   DELETE FROM tlfs_file
    WHERE tlfs01 = b_imn.imn03
      AND tlfs10 = b_imn.imn01
      AND tlfs11 = b_imn.imn02
     #AND tlfs111 = g_imm.imm02   #FUN-D50079 mark
      AND tlfs111 = g_imm.imm17   #FUN-D50079 
 
   IF STATUS THEN
      IF g_bgerr THEN
        #LET g_showmsg = b_imn.imn03,'/',g_imm.imm02   #FUN-D50079 mark
         LET g_showmsg = b_imn.imn03,'/',g_imm.imm17   #FUN-D50079 
         CALL s_errmsg('tlfs01,tlfs111',g_showmsg,'del tlfs:',STATUS,1)
      ELSE
         CALL cl_err3("del","tlfs_file",g_imm.imm01,"",STATUS,"","del tlfs",1)
      END IF
      LET g_success='N'
      RETURN
   END IF
 
   IF SQLCA.SQLERRD[3]=0 THEN
      IF g_bgerr THEN
        #LET g_showmsg = b_imn.imn03,'/',g_imm.imm02   #FUN-D50079 mark
         LET g_showmsg = b_imn.imn03,'/',g_imm.imm17   #FUN-D50079 
         CALL s_errmsg('tlfs01,tlfs111',g_showmsg,'del tlfs:','mfg0177',1)
      ELSE
         CALL cl_err3("del","tlfs_file",g_imm.imm01,"","mfg0177","","del tlfs",1) 
      END IF
      LET g_success='N'
      RETURN
   END IF
 
END FUNCTION
#-----No.FUN-810036 END-----