# Prog. Version..: '5.30.06-13.04.22(00003)'     #
#
# Pattern name...: aimt325_sub.4gl
# Descriptions...: 提供aimt325.4gl使用的sub routine
# Date & Author..: No:DEV-D30046 13/04/01 By TSD.sophy
# Modify.........: No:DEV-D40013 13/04/12 By Nina 過單用
# Modify.........: No.DEV-D40015 13/04/19 By Nina 若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
# Modify.........: No.TQC-DB0039 13/11/28 By wangrr 撥出審核時更新imn12

DATABASE ds

GLOBALS "../../config/top.global"

#FUN-CC0095---begin
GLOBALS
   DEFINE g_padd_img       DYNAMIC ARRAY OF RECORD
             img01         LIKE img_file.img01,
             img02         LIKE img_file.img02,
             img03         LIKE img_file.img03,
             img04         LIKE img_file.img04,
             img05         LIKE img_file.img05,
             img06         LIKE img_file.img06,
             img09         LIKE img_file.img09,
             img13         LIKE img_file.img13,
             img14         LIKE img_file.img14,
             img17         LIKE img_file.img17,
             img18         LIKE img_file.img18,
             img19         LIKE img_file.img19,
             img21         LIKE img_file.img21,
             img26         LIKE img_file.img26,
             img27         LIKE img_file.img27,
             img28         LIKE img_file.img28,
             img35         LIKE img_file.img35,
             img36         LIKE img_file.img36,
             img37         LIKE img_file.img37
                           END RECORD

   DEFINE g_padd_imgg      DYNAMIC ARRAY OF RECORD
             imgg00        LIKE imgg_file.imgg00,
             imgg01        LIKE imgg_file.imgg01,
             imgg02        LIKE imgg_file.imgg02,
             imgg03        LIKE imgg_file.imgg03,
             imgg04        LIKE imgg_file.imgg04,
             imgg05        LIKE imgg_file.imgg05,
             imgg06        LIKE imgg_file.imgg06,
             imgg09        LIKE imgg_file.imgg09,
             imgg10        LIKE imgg_file.imgg10,
             imgg20        LIKE imgg_file.imgg20,
             imgg21        LIKE imgg_file.imgg21,
             imgg211       LIKE imgg_file.imgg211,
             imggplant     LIKE imgg_file.imggplant,
             imgglegal     LIKE imgg_file.imgglegal
                           END RECORD
END GLOBALS
#FUN-CC0095---end
#DEV-D30046 --add--begin
DEFINE g_ima906        LIKE ima_file.ima906
DEFINE g_ima918        LIKE ima_file.ima918
DEFINE g_ima921        LIKE ima_file.ima921
DEFINE g_ima930        LIKE ima_file.ima930
DEFINE g_ima907        LIKE ima_file.ima907
DEFINE g_cnt           LIKE type_file.num10
DEFINE g_unit_arr      DYNAMIC ARRAY OF RECORD#No.FUN-610090
          unit            LIKE ima_file.ima25,
          fac             LIKE img_file.img21,
          qty             LIKE img_file.img10
                       END RECORD
DEFINE g_msg           LIKE type_file.chr1000
#DEV-D30046 --add--end

##################################
#作用    : lock cursor    
#回傳值  : 無     
##################################
FUNCTION t325sub_lock_cl()   
   DEFINE l_forupd_sql      STRING        

   LET l_forupd_sql = "SELECT * FROM imm_file WHERE imm01 = ? FOR UPDATE"
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE t325sub_cl CURSOR FROM l_forupd_sql
END FUNCTION  


##################################
#作用    : 撥出確認
#傳入參數: p_imm01          調撥單號
#          p_inTransaction  若p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#          p_ask_conf       若p_ask_post='Y' 會詢問"是否執行確認"
#回傳值  : 無     
##################################
FUNCTION t325sub_y(p_imm01,p_inTransaction,p_ask_conf) 
   DEFINE p_imm01         LIKE imm_file.imm01      #DEV-D30046
   DEFINE p_inTransaction LIKE type_file.num5      #DEV-D30046
   DEFINE p_ask_conf      LIKE type_file.chr1      #DEV-D30046
   DEFINE l_cnt           LIKE type_file.num10   #No.FUN-690026 INTEGER
   DEFINE l_imm08_fac     LIKE imn_file.imn21    #No.MOD-610096 add
   DEFINE l_img09         LIKE img_file.img09    #No.MOD-610096 add
   DEFINE l_sql           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(4000)
   DEFINE l_imn10         LIKE imn_file.imn10
   DEFINE l_imn29         LIKE imn_file.imn29
   DEFINE l_imn03         LIKE imn_file.imn03
   DEFINE l_qcs01         LIKE qcs_file.qcs01
   DEFINE l_qcs02         LIKE qcs_file.qcs02
   DEFINE l_qcs091        LIKE qcs_file.qcs091
   DEFINE l_buf           LIKE gem_file.gem02     #TQC-B50032
   DEFINE l_result        LIKE type_file.chr1     #TQC-C50158
   DEFINE l_cnt_img       LIKE type_file.num5     #FUN-C70087
   DEFINE l_cnt_imgg      LIKE type_file.num5     #FUN-C70087
   DEFINE l_flag          LIKE type_file.chr1     #TQC-D20042
   DEFINE l_where         STRING                  #TQC-D20042
   DEFINE l_n             LIKE type_file.num5     #TQC-D20042
   DEFINE l_store         STRING                  #TQC-D20042
   #DEV-D30046 --add--begin
   DEFINE l_imm           RECORD LIKE imm_file.*   
   DEFINE l_imn           RECORD LIKE imn_file.* 
   DEFINE l_yy,l_mm       LIKE type_file.num5    
   DEFINE l_flag2         LIKE type_file.num5
   DEFINE l_imm01         LIKE imm_file.imm01
   #DEV-D30046 --add--end

   WHENEVER ERROR CONTINUE    #DEV-D30046      

   SELECT * INTO l_imm.* FROM imm_file WHERE imm01 = p_imm01  #DEV-D30046

   #FUN-AB0066 --begin--
   IF NOT s_chk_ware(l_imm.imm08) THEN 
      RETURN 
   END IF 
   #FUN-AB0066 --end--
 
   IF l_imm.imm04 = 'Y' THEN CALL cl_err('','aim-002',0) RETURN END IF   #No.TQC-750041 
   IF l_imm.imm04 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF cl_null(l_imm.imm01) THEN CALL cl_err('',-400,0) RETURN END IF

   IF p_ask_conf = 'Y' THEN   #DEV-D30046
      IF NOT cl_confirm('aim-301') THEN RETURN END IF   #CHI-C50010 add
   END IF    #DEV-D30046

   #TQC-B50032--begin
   IF NOT cl_null(l_imm.imm14) THEN
      SELECT gem02 INTO l_buf FROM gem_file
       WHERE gem01=l_imm.imm14
         AND gemacti='Y'   
      IF STATUS THEN
         CALL cl_err3("sel","gem_file",l_imm.imm14,"",SQLCA.sqlcode,"","select gem",1)
         RETURN 
      END IF
   END IF
   #TQC-B50032--end   
   
   IF NOT cl_null(g_sma.sma53) AND l_imm.imm02 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0) 
      RETURN
   END IF
 
   CALL s_yp(l_imm.imm02) RETURNING l_yy,l_mm
   IF l_yy > g_sma.sma51 THEN               #與目前會計年度,期間比較
      CALL cl_err(l_yy,'mfg6090',0)
      RETURN
   ELSE
      IF l_yy=g_sma.sma51 AND l_mm > g_sma.sma52 THEN
         CALL cl_err(l_mm,'mfg6091',0)
         RETURN
      END IF
   END IF
 
   #No.+022 010328 by linda add 無單身不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM imn_file
    WHERE imn01=l_imm.imm01 
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
   #str MOD-A30247 add
   #當沒有輸入儲位、批號時,撥出、入倉庫不可與在途倉一樣
   DECLARE t325sub_y0_c CURSOR FOR
      SELECT * FROM imn_file WHERE imn01=l_imm.imm01
   FOREACH t325sub_y0_c INTO l_imn.*
      IF STATUS THEN EXIT FOREACH END IF

      IF (l_imn.imn05=' ' AND l_imn.imn06=' ' AND l_imn.imn04=l_imm.imm08) OR
         (l_imn.imn16=' ' AND l_imn.imn17=' ' AND l_imn.imn15=l_imm.imm08) THEN
         CALL cl_err(l_imn.imn04,'aim1010',1)
         RETURN
      END IF

      #FUN-AB0066 --begin--
      IF NOT s_chk_ware(l_imn.imn04) THEN 
         RETURN 
      END IF 
      IF NOT s_chk_ware(l_imn.imn15) THEN 
         RETURN 
      END IF 
      #FUN-AB0066 --end--
      
      #No.MOD-AA0086  --Begin
      IF NOT t325sub_chk_qty(l_imm.*,l_imn.*) THEN  #DEV-D30046
         RETURN
      END IF
      #No.MOD-AA0086  --End  
   END FOREACH
   #end MOD-A30247 add

  #DEV-D40015 add str--------
  #若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
   IF g_aza.aza131 = 'Y' AND g_prog = 'aimt325' THEN
     #確認是否有符合條件的料件
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM ima_file
       WHERE ima01 IN (SELECT imn03 FROM imn_file WHERE imn01 = l_imm.imm01) #料件
         AND ima930 = 'Y'                   #條碼使用否
         AND (ima921 = 'Y' OR ima918 = 'Y') #批號管理否='Y' OR 序號管理否='Y'
	
     #確認是否已有掃描紀錄
      IF l_cnt > 0 THEN
         IF NOT s_chk_barcode_confirm('post','tlfb',l_imm.imm01,'','') THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
  #DEV-D40015 add end--------

   #FUN-C70087---begin
   CALL s_padd_img_init()  #FUN-CC0095
   CALL s_padd_imgg_init()  #FUN-CC0095
   
   DECLARE t325sub_y1_c3 CURSOR FOR SELECT * FROM imn_file
     WHERE imn01 = l_imm.imm01 

   FOREACH t325sub_y1_c3 INTO l_imn.*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM img_file
       WHERE img01 = l_imn.imn03
         AND img02 = l_imn.imn15
         AND img03 = l_imn.imn16
         AND img04 = l_imn.imn17
       IF l_cnt = 0 THEN
          #CALL s_padd_img_data(l_imn.imn03,l_imn.imn15,l_imn.imn16,l_imn.imn17,l_imm.imm01,l_imn.imn02,l_imm.imm02,l_img_table) #FUN-CC0095
          CALL s_padd_img_data1(l_imn.imn03,l_imn.imn15,l_imn.imn16,l_imn.imn17,l_imm.imm01,l_imn.imn02,l_imm.imm02) #FUN-CC0095
       END IF

       CALL s_chk_imgg(l_imn.imn03,l_imn.imn15,
                       l_imn.imn16,l_imn.imn17,
                       l_imn.imn40) RETURNING l_flag2
       IF l_flag2 = 1 THEN
          #CALL s_padd_imgg_data(l_imn.imn03,l_imn.imn15,l_imn.imn16,l_imn.imn17,l_imn.imn40,l_imm.imm01,l_imn.imn02,l_imgg_table)  #FUN-CC0095
          CALL s_padd_imgg_data1(l_imn.imn03,l_imn.imn15,l_imn.imn16,l_imn.imn17,l_imn.imn40,l_imm.imm01,l_imn.imn02)  #FUN-CC0095
       END IF 
       CALL s_chk_imgg(l_imn.imn03,l_imn.imn15,
                       l_imn.imn16,l_imn.imn17,
                       l_imn.imn43) RETURNING l_flag2
       IF l_flag2 = 1 THEN
          #CALL s_padd_imgg_data(l_imn.imn03,l_imn.imn15,l_imn.imn16,l_imn.imn17,l_imn.imn43,l_imm.imm01,l_imn.imn02,l_imgg_table) #FUN-CC0095
          CALL s_padd_imgg_data1(l_imn.imn03,l_imn.imn15,l_imn.imn16,l_imn.imn17,l_imn.imn43,l_imm.imm01,l_imn.imn02) #FUN-CC0095
       END IF 
   END FOREACH 
   #FUN-CC0095---begin mark
   #LET g_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_img_table CLIPPED  #,g_cr_db_str
   #PREPARE cnt_img FROM g_sql
   #LET l_cnt_img = 0
   #EXECUTE cnt_img INTO l_cnt_img
   #
   #LET g_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_imgg_table CLIPPED #,g_cr_db_str
   #PREPARE cnt_imgg FROM g_sql
   #LET l_cnt_imgg = 0
   #EXECUTE cnt_imgg INTO l_cnt_imgg
   #FUN-CC0095---end   
   LET l_cnt_img = g_padd_img.getLength()  #FUN-CC0095
   LET l_cnt_imgg = g_padd_imgg.getLength()  #FUN-CC0095
   
   IF g_sma.sma892[3,3] = 'Y' AND (l_cnt_img > 0 OR l_cnt_imgg > 0) THEN
      IF cl_confirm('mfg1401') THEN 
         IF l_cnt_img > 0 THEN 
            #IF NOT s_padd_img_show(l_img_table) THEN #FUN-CC0095
            IF NOT s_padd_img_show1() THEN  #FUN-CC0095
               #CALL s_padd_img_del(l_img_table) #FUN-CC0095
               LET g_success = 'N' 
               RETURN 
            END IF 
         END IF 
         IF l_cnt_imgg > 0 THEN #FUN-CC0095 
            #IF NOT s_padd_imgg_show(l_imgg_table) THEN  #FUN-CC0095
            IF NOT s_padd_imgg_show1() THEN  #FUN-CC0095
               #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095
               LET g_success = 'N'
               RETURN 
            END IF 
         END IF #FUN-CC0095     
      ELSE
         #CALL s_padd_img_del(l_img_table)  #FUN-CC0095   
         #CALL s_padd_imgg_del(l_imgg_table)  #FUN-CC0095   
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #CALL s_padd_img_del(l_img_table)  #FUN-CC0095   
   #CALL s_padd_imgg_del(l_imgg_table)  #FUN-CC0095   
   #FUN-C70087---end
  
   LET l_sql="SELECT imn10,imn29,imn03,imn01,imn02 FROM imn_file",
             " WHERE imn01= '",l_imm.imm01,"'"
   PREPARE t324_curs1 FROM l_sql
   DECLARE t324_pre1 CURSOR FOR t324_curs1
   FOREACH t324_pre1 INTO l_imn10,l_imn29,l_imn03,l_qcs01,l_qcs02
      IF l_imn29='Y' THEN
         LET l_qcs091=0
         SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file
          WHERE qcs01=l_qcs01
            AND qcs02=l_qcs02
            AND qcs14='Y'
         IF cl_null(l_qcs091) THEN LET l_qcs091=0 END IF
         IF l_qcs091 < l_imn10 THEN
            CALL cl_err(l_imn03,'aim1003',1)
            RETURN
         END IF
      END IF
   END FOREACH
 
  #IF NOT cl_confirm('aim-301') THEN RETURN END IF #CHI-C30106 mark
  #IF NOT cl_confirm('aim-301') THEN RETURN END IF #TQC-C50158 add   #CHI-C50010 mark
 
   DECLARE t325sub_y1_c CURSOR FOR
     SELECT * FROM imn_file WHERE imn01=l_imm.imm01 
 
   IF NOT p_inTransaction THEN   #DEV-D30046
      BEGIN WORK
   END IF    #DEV-D30046
 
   CALL t325sub_lock_cl()   #DEV-D30046
   
   OPEN t325sub_cl USING l_imm.imm01
   IF STATUS THEN
      CALL cl_err("OPEN t325sub_cl:", STATUS, 1)
      CLOSE t325sub_cl
      IF NOT p_inTransaction THEN   #DEV-D30046
         ROLLBACK WORK
      END IF    #DEV-D30046
      RETURN
   END IF
   FETCH t325sub_cl INTO l_imm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err("FETCH t325sub_cl:", STATUS, 1)
      CLOSE t325sub_cl
      IF NOT p_inTransaction THEN   #DEV-D30046
         ROLLBACK WORK
      END IF    #DEV-D30046
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL s_showmsg_init()   #No.FUN-6C0083 
 
   FOREACH t325sub_y1_c INTO l_imn.*
      IF STATUS THEN EXIT FOREACH END IF
      #TQC-D20042---add---str---
       IF g_aza.aza115 = 'Y' THEN
          LET l_store = ''
          IF NOT cl_null(l_imn.imn04) THEN
             LET l_store = l_store,l_imn.imn04
          END IF
          IF NOT cl_null(l_imn.imn15) THEN
             IF NOT cl_null(l_store) THEN
                LET l_store = l_store,"','",l_imn.imn15
             ELSE
                LET l_store = l_store,l_imn.imn15
             END IF
          END IF
          IF NOT cl_null(l_imn.imn28) THEN
             LET l_n = 0
             LET l_flag = FALSE
             CALL s_get_where(l_imm.imm01,'','',l_imn.imn03,l_store,'',l_imm.imm14) RETURNING l_flag,l_where
             IF g_aza.aza115='Y' AND l_flag THEN
                LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",l_imn.imn28,"' AND ",l_where
                PREPARE ggc08_pre5 FROM l_sql
                EXECUTE ggc08_pre5 INTO l_n
                IF l_n < 1 THEN
                   LET g_success='N'
                   CALL s_errmsg('imn28',l_imn.imn28,l_imn.imn28,'aim-425',1)
                END IF
             END IF
          ELSE
             LET g_success = 'N'
             CALL s_errmsg('imn28',l_imn.imn28,l_imn.imn28,'aim-888',1)
          END IF
       END IF
      #TQC-D20042---add---end---
      #TQC-C50158--add--str--
      #撥出倉庫過賬權限檢查
      CALL s_incchk(l_imn.imn04,l_imn.imn05,g_user) RETURNING l_result
      IF NOT l_result THEN  
         LET g_success = 'N'
         LET g_showmsg = l_imn.imn03,"/",l_imn.imn04,"/",l_imn.imn05,"/",g_user
         CALL s_errmsg("imn03/imn04/imn05/inc03",g_showmsg,'','asf-888',1)
         CONTINUE FOREACH
      END IF 
      #TQC-C50158--add--end--

      IF cl_null(l_imn.imn04) THEN CONTINUE FOREACH END IF
      MESSAGE 'Y:read parts==> ',l_imn.imn03

      CALL s_t325_s(l_imn.imn03,l_imn.imn04,l_imn.imn05,l_imn.imn06,
                    -1,l_imn.imn10,l_imn.imn09, l_imn.imn01,l_imn.imn02,
                    l_imm.imm02,l_imn.imn28)   #No.B037       #No.TQC-760153 add imn28
      IF g_success='N' THEN 
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH   #No.FUN-6C0083
      END IF
      SELECT img09 INTO l_img09 FROM img_file
        WHERE img01=l_imn.imn03 AND img02=l_imm.imm08
        AND img03 =' ' AND img04 = ' '
 
      CALL s_umfchk(l_imn.imn03,
                         l_imn.imn09,l_img09)
                    RETURNING l_cnt,l_imm08_fac
           IF l_cnt = 1 THEN
              LET l_imm08_fac = 1
           END IF
       LET l_imn.imn10 = l_imn.imn10 * l_imm08_fac
       LET l_imn.imn10 = s_digqty(l_imn.imn10,l_imn.imn09)   #No.FUN-BB0086
 
      CALL s_t325_s(l_imn.imn03,l_imm.imm08,' '        ,' '        ,
                    +1,l_imn.imn10,l_imn.imn09, l_imn.imn01,l_imn.imn02,
                    l_imm.imm02,l_imn.imn28)   #No.B037     #No.TQC-760153 add imn28
      IF g_success='N' THEN 
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH   #No.FUN-6C0083
      END IF
        IF g_sma.sma115='Y' THEN
           CALL t325sub_upd_s(l_imn.imn04,l_imn.imn05,l_imn.imn06,
                              l_imn.imn33,l_imn.imn34,l_imn.imn35,
                              l_imn.imn30,l_imn.imn31,l_imn.imn32,
                              l_imn.imn01,l_imn.imn02,1,
                              l_imn.*,l_imm.imm02)   #DEV-D30046
           IF g_success='N' THEN
              LET g_totsuccess="N"
              LET g_success="Y"
              CONTINUE FOREACH   #No.FUN-6C0083
           END IF
           CALL t325sub_upd_t(l_imm.imm08,' ',' ',
                              l_imn.imn43,l_imn.imn44,l_imn.imn45,
                              l_imn.imn40,l_imn.imn41,l_imn.imn42,
                              l_imn.imn01,l_imn.imn02,1,
                              l_imn.*,l_imm.imm02)   #DEV-D30046
           IF g_success='N' THEN
              LET g_totsuccess="N"
              LET g_success="Y"
              CONTINUE FOREACH   #No.FUN-6C0083
           END IF
        END IF
        #FUN-AC0074--behin--add---
        CALL s_updsie_sie(l_imn.imn01,l_imn.imn02,'4')
        IF g_success='N' THEN
           LET g_totsuccess="N"
           LET g_success="Y"
           CONTINUE FOREACH
        END IF
        #FUN-AC0074--end--add-----
      #TQC-DB0039--add--str--
      UPDATE imn_file
         SET imn12='Y',
             imn13=g_user,
             imn14=g_today
       WHERE imn01=l_imn.imn01
         AND imn02=l_imn.imn02

      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg = l_imn.imn01,"/",l_imn.imn02
         CALL s_errmsg('imn01,imn02',g_showmsg,'upd imn',SQLCA.SQLCODE,1)
         LET g_success='N'
      END IF
      #TQC-DB0039--add--end
   END FOREACH
 
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
   CALL s_showmsg()   #No.FUN-6C0083
 
   IF g_success='Y' THEN
      UPDATE imm_file SET imm04 = 'Y' WHERE imm01 = l_imm.imm01 
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('imm01',l_imm.imm01,'up imm_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      IF NOT p_inTransaction THEN   #DEV-D30046
         COMMIT WORK
      END IF   #DEV-D30046
      CALL cl_flow_notify(l_imm.imm01,'Y')
      CALL cl_cmmsg(4)
   ELSE
      IF NOT p_inTransaction THEN   #DEV-D30046
         ROLLBACK WORK
      END IF   #DEV-D30046
      CALL cl_rbmsg(4)
   END IF
 
   SELECT imm04 INTO l_imm.imm04 FROM imm_file WHERE imm01 = l_imm.imm01 
   DISPLAY BY NAME l_imm.imm04
 
   IF l_imm.imm04 = "N" THEN
      DECLARE t325sub_y1_c2 CURSOR FOR SELECT * FROM imn_file
        WHERE imn01 = l_imm.imm01 
 
      LET l_imm01 = ""
      LET g_success = "Y"
 
      CALL s_showmsg_init()   #No.FUN-6C0083 
 
      IF NOT p_inTransaction THEN   #DEV-D30046
         BEGIN WORK
      END IF   #DEV-D30046
 
      FOREACH t325sub_y1_c2 INTO l_imn.*
         IF STATUS THEN
            EXIT FOREACH
         END IF
 
         IF g_sma.sma115 = 'Y' THEN
            IF g_ima906 = '2' THEN  #子母單位
               LET g_unit_arr[1].unit= l_imn.imn30
               LET g_unit_arr[1].fac = l_imn.imn31
               LET g_unit_arr[1].qty = l_imn.imn32
               LET g_unit_arr[2].unit= l_imn.imn33
               LET g_unit_arr[2].fac = l_imn.imn34
               LET g_unit_arr[2].qty = l_imn.imn35
               CALL s_dismantle(l_imm.imm01,l_imn.imn02,l_imm.imm12,
                                l_imn.imn03,l_imn.imn04,l_imn.imn05,
                                l_imn.imn06,g_unit_arr,l_imm01)
                      RETURNING l_imm01
               IF g_success='N' THEN 
                  LET g_totsuccess='N'
                  LET g_success="Y"
                  CONTINUE FOREACH   #No.FUN-6C0083
               END IF
            END IF
         END IF
      END FOREACH
 
      IF g_totsuccess="N" THEN
         LET g_success="N"
      END IF
      CALL s_showmsg()   #No.FUN-6C0083
 
      IF NOT p_inTransaction THEN   #DEV-D30046
         IF g_success = "Y" AND NOT cl_null(l_imm01) THEN
            COMMIT WORK
            LET g_msg="aimt324 '",l_imm01,"'"
            CALL cl_cmdrun_wait(g_msg)
         ELSE
            ROLLBACK WORK
         END IF
      END IF   #DEV-D30046
   END IF
 
END FUNCTION

FUNCTION t325sub_chk_qty(p_imm,p_imn)
   DEFINE p_imm       RECORD LIKE imm_file.*   #DEV-D30046
   DEFINE p_imn       RECORD LIKE imn_file.*   #DEV-D30046
   DEFINE l_rvbs06    LIKE rvbs_file.rvbs06
   DEFINE l_rvbs09    LIKE rvbs_file.rvbs09
   DEFINE l_rvbs01    LIKE rvbs_file.rvbs01

   LET g_ima918 = ''   #DEV-D30040 add
   LET g_ima921 = ''   #DEV-D30040 add
   LET g_ima930 = ''   #DEV-D30040 add
   SELECT ima918,ima921,ima930 INTO g_ima918,g_ima921,g_ima930 #DEV-D30040 add ima930,g_ima930
     FROM ima_file
    WHERE ima01 = p_imn.imn03
      AND imaacti = "Y"

   IF cl_null(g_ima930) THEN LET g_ima930 = 'N' END IF  #DEV-D30040 add

   IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
      IF g_prog = 'aimt325' THEN
         LET l_rvbs09 = -1
         LET l_rvbs01 = p_imm.imm01
      ELSE
         LET l_rvbs09 = 1
         LET l_rvbs01 = p_imm.imm11
      END IF
      SELECT SUM(rvbs06) INTO l_rvbs06
        FROM rvbs_file
       WHERE rvbs00 = g_prog
         AND rvbs01 = l_rvbs01
         AND rvbs02 = p_imn.imn02
         AND rvbs09 = l_rvbs09
         AND rvbs13 = 0

      IF cl_null(l_rvbs06) THEN
         LET l_rvbs06 = 0
      END IF

      IF (g_ima930 = 'Y' and l_rvbs06 <> 0) OR g_ima930 = 'N' THEN  #DEV-D30040
         IF p_imn.imn10 <> l_rvbs06 THEN
            CALL cl_err(p_imn.imn03,"aim-011",1)
            RETURN FALSE
         END IF
      END IF                                                        #DEV-D30040
   END IF
   RETURN TRUE
END FUNCTION


##################################
#作用    : 撥入確認
#傳入參數: p_imm01          調撥單號
#          p_inTransaction  若p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#          p_ask_conf       若p_ask_post='Y' 會詢問"是否執行確認"
#回傳值  : 無     
##################################
FUNCTION t325sub_s(p_imm01,p_inTransaction,p_ask_conf)
   DEFINE p_imm01         LIKE imm_file.imm01      #DEV-D30046
   DEFINE p_inTransaction LIKE type_file.num5      #DEV-D30046
   DEFINE p_ask_conf      LIKE type_file.chr1      #DEV-D30046
   DEFINE li_result       LIKE type_file.num5     #No.FUN-550029  #No.FUN-690026 SMALLINT
   DEFINE l_cnt           LIKE type_file.num10    #No.MOD-610096 add  #No.FUN-690026 INTEGER
   DEFINE l_imm08_fac     LIKE imn_file.imn21     #No.MOD-610096 add
   DEFINE l_img09         LIKE img_file.img09     #No.MOD-610096 add
   DEFINE l_t1            LIKE smy_file.smyslip   #TQC-7A0063 
   DEFINE l_rvbs06        LIKE rvbs_file.rvbs06   #No.MOD-AA0086
   DEFINE l_rvbs09        LIKE rvbs_file.rvbs09   #No.MOD-AA0086
   DEFINE l_buf           LIKE gem_file.gem02     #TQC-B50032 
   DEFINE l_result        LIKE type_file.chr1     #TQC-C50158
   #CHI-CA0040---begin
   DEFINE l_sql           STRING 
   DEFINE l_imn10         LIKE imn_file.imn10
   DEFINE l_imn29         LIKE imn_file.imn29
   DEFINE l_imn03         LIKE imn_file.imn03
   DEFINE l_qcs01         LIKE qcs_file.qcs01
   DEFINE l_qcs02         LIKE qcs_file.qcs02
   DEFINE l_qcs091        LIKE qcs_file.qcs091
   #CHI-CA0040---end      
   DEFINE l_flag          LIKE type_file.chr1      #FUN-CB0087 add
   DEFINE l_where         STRING                   #FUN-CB0087 add
   DEFINE l_n             LIKE type_file.num5      #FUN-CB0087 add
   DEFINE l_store         STRING                   #FUN-CB0087 add
   #DEV-D30046 --add--begin
   DEFINE l_yy,l_mm       LIKE type_file.num5      
   DEFINE l_imm           RECORD LIKE imm_file.*   
   DEFINE l_imn           RECORD LIKE imn_file.*  
   DEFINE l_imm01         LIKE imm_file.imm01
   #DEV-D30046 --add--end
   
   WHENEVER ERROR CONTINUE    #DEV-D30046      
 
   SELECT * INTO l_imm.* FROM imm_file
    WHERE imm01 = p_imm01
 
   IF cl_null(l_imm.imm01) THEN CALL cl_err('',-400,0) RETURN END IF
 
   IF l_imm.imm04 = 'N' THEN CALL cl_err('','aim-003',0) RETURN END IF     #No.TQC-750041
 
   IF l_imm.imm04 = 'X' THEN CALL cl_err('','9024',0) RETURN END IF    #no:6810 modify
 
   IF l_imm.imm03 = 'Y' THEN CALL cl_err('','aim-100',0) RETURN END IF #no:6810 modify

   #FUN-AB0066 --begin--
   IF NOT s_chk_ware(l_imm.imm08) THEN 
      RETURN 
   END IF 
   #FUN-AB0066 --end--
 
   IF l_imm.imm12 > g_today THEN
     CALL cl_err('','aim-504',0)
     RETURN
   END IF
   
   #TQC-B50032--begin
   IF NOT cl_null(l_imm.imm14) THEN
      SELECT gem02 INTO l_buf FROM gem_file
       WHERE gem01=l_imm.imm14
         AND gemacti='Y'   
      IF STATUS THEN
         LET g_success = 'N'
         CALL cl_err3("sel","gem_file",l_imm.imm14,"",SQLCA.sqlcode,"","select gem",1)
         RETURN 
      END IF
   END IF
   #TQC-B50032--end
   
   IF cl_null(l_imm.imm11) OR cl_null(l_imm.imm12) OR cl_null(l_imm.imm13) THEN
      CASE
         WHEN cl_null(l_imm.imm11)
            LET g_errno = 'aim-310'
         WHEN cl_null(l_imm.imm12)
            LET g_errno = 'aim-311'
         WHEN cl_null(l_imm.imm13)
            LET g_errno = 'aim-312'
         OTHERWISE
      END CASE
 
      CALL cl_err('',g_errno,1)
      RETURN
   END IF
 
   #檢查若#sma884=N,撥入單不可與撥出單相同(輸入撥入單後,再更改sma884就會有問題)
   IF g_sma.sma884 = 'N' THEN
      IF l_imm.imm01 = l_imm.imm11 THEN
         CALL cl_err('','aim-314',0)
         RETURN
      ELSE
         #檢查撥入單單據別是否正確
         LET g_errno =''
         LET l_t1 = s_get_doc_no(l_imm.imm11) #TQC-7A0063
         CALL s_check_no("aim",l_t1,l_imm.imm11,"A","imm_file","imm11","")  #TQC-7A0063
            RETURNING li_result,l_t1
         DISPLAY BY NAME l_imm.imm11
         IF (NOT li_result) THEN
            RETURN
         END IF
      END IF
   ELSE
      #須檢查若#sma884='Y',且撥入單號<>撥出單號時,顯示訊息『#sma884='Y'撥入單號須等於撥出單號
      #自動將『撥入單號』default 等於『撥出單號』
      IF g_sma.sma884 = 'Y' THEN
         IF l_imm.imm01 != l_imm.imm11 THEN
            CALL cl_err('','aim-315',0)
            LET l_imm.imm11 = l_imm.imm01
            DISPLAY BY NAME l_imm.imm11
            RETURN
         ELSE
           #檢查單據的合理性(單據不可重覆)
            SELECT count(*) INTO g_cnt FROM imm_file
             WHERE imm01 != l_imm.imm11 AND imm11 = l_imm.imm11 
            IF g_cnt > 0 THEN   #資料重複
               CALL cl_err(l_imm.imm11,-239,1)
               RETURN
            END IF
         END IF
      END IF
   END IF
 
 
   IF NOT cl_null(g_sma.sma53) AND l_imm.imm12 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0)
      RETURN
   END IF
 
   CALL s_yp(l_imm.imm12) RETURNING l_yy,l_mm   #bugno:6810 modify imm02->imm12
 
   IF l_yy > g_sma.sma51 THEN                   #與目前會計年度,期間比較
      CALL cl_err(l_yy,'mfg6090',0)
      RETURN
   ELSE
      IF l_yy =g_sma.sma51 AND l_mm > g_sma.sma52 THEN    #No.MOD-8C0293
         CALL cl_err(l_mm,'mfg6091',0)
         RETURN
      END IF
   END IF

   IF p_ask_conf = 'Y' THEN   #DEV-D30046
      IF NOT cl_confirm('aim-301') THEN
         RETURN
      END IF
   END IF    #DEV-D30046

  #DEV-D40015 add str--------
  #若aimi100[條碼使用否]=Y且有勾選製造批號/製造序號，需控卡不可直接確認or過帳
   IF g_aza.aza131 = 'Y' AND g_prog = 'aimt326' THEN
     #確認是否有符合條件的料件
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt
        FROM ima_file
       WHERE ima01 IN (SELECT imn03 FROM imn_file WHERE imn01 = l_imm.imm01) #料件
         AND ima930 = 'Y'                   #條碼使用否
         AND (ima921 = 'Y' OR ima918 = 'Y') #批號管理否='Y' OR 序號管理否='Y'
	
     #確認是否已有掃描紀錄
      IF l_cnt > 0 THEN
         IF NOT s_chk_barcode_confirm('post','tlfb',l_imm.imm01,'','') THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
  #DEV-D40015 add end--------

   #CHI-CA0040---begin
   LET l_sql="SELECT imn10,imn29,imn03,imn01,imn02 FROM imn_file",
             " WHERE imn01= '",l_imm.imm01,"'"
   PREPARE t324_curs2 FROM l_sql
   DECLARE t324_pre2 CURSOR FOR t324_curs2
   FOREACH t324_pre2 INTO l_imn10,l_imn29,l_imn03,l_qcs01,l_qcs02
      IF l_imn29='Y' THEN
         LET l_qcs091=0
         SELECT SUM(qcs091) INTO l_qcs091 FROM qcs_file
          WHERE qcs01=l_qcs01
            AND qcs02=l_qcs02
            AND qcs14='Y'
         IF cl_null(l_qcs091) THEN LET l_qcs091=0 END IF
         IF l_qcs091 < l_imn10 THEN
            CALL cl_err(l_imn03,'aim1003',1)
            RETURN
         END IF
      END IF
   END FOREACH
   #CHI-CA0040---end
 
   DECLARE t325sub_s1_c CURSOR FOR SELECT * FROM imn_file
                                 WHERE imn01 = l_imm.imm01 
 
   IF NOT p_inTransaction THEN   #DEV-D30046
      BEGIN WORK
   END IF     #DEV-D30046
   
   CALL t325sub_lock_cl()   #DEV-D30046
   
   OPEN t325sub_cl USING l_imm.imm01
   IF STATUS THEN
      CALL cl_err("OPEN t325sub_cl:", STATUS, 1)
      CLOSE t325sub_cl
      IF NOT p_inTransaction THEN   #DEV-D30046
         ROLLBACK WORK
      END IF     #DEV-D30046
      RETURN
   END IF
 
   FETCH t325sub_cl INTO l_imm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_imm.imm01,SQLCA.sqlcode,0)
      CLOSE t325sub_cl
      IF NOT p_inTransaction THEN   #DEV-D30046
         ROLLBACK WORK
      END IF     #DEV-D30046
      RETURN
   END IF
 
 
   LET g_success = 'Y'
   
   CALL s_showmsg_init()   #No.FUN-6C0083 
 
   FOREACH t325sub_s1_c INTO l_imn.*
      IF STATUS THEN EXIT FOREACH END IF
      #FUN-CB0087---add---str---
      IF g_aza.aza115 = 'Y' THEN
         LET l_store = ''
         IF NOT cl_null(l_imn.imn04) THEN
            LET l_store = l_store,l_imn.imn04
         END IF
         IF NOT cl_null(l_imn.imn15) THEN
            IF NOT cl_null(l_store) THEN
               LET l_store = l_store,"','",l_imn.imn15
            ELSE
               LET l_store = l_store,l_imn.imn15
            END IF
         END IF
         IF NOT cl_null(l_imn.imn28) THEN
            LET l_n = 0
            LET l_flag = FALSE
            CALL s_get_where(l_imm.imm01,'','',l_imn.imn03,l_store,'',l_imm.imm14) RETURNING l_flag,l_where
            IF g_aza.aza115='Y' AND l_flag THEN
               LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",l_imn.imn28,"' AND ",l_where
               PREPARE ggc08_pre4 FROM l_sql
               EXECUTE ggc08_pre4 INTO l_n
               IF l_n < 1 THEN
                  LET g_success='N'
                  CALL s_errmsg('imn28',l_imn.imn28,l_imn.imn28,'aim-425',1)
               END IF
            END IF
         ELSE
            LET g_success = 'N'
            CALL s_errmsg('imn28',l_imn.imn28,l_imn.imn28,'aim-888',1)
         END IF
      END IF
      #FUN-CB0087---add---end---
      
      #TQC-C50158--add--str--
      #撥入倉庫過賬權限檢查
      CALL s_incchk(l_imn.imn15,l_imn.imn16,g_user) RETURNING l_result
      IF NOT l_result THEN
         LET g_success = 'N'
         LET g_showmsg = l_imn.imn03,"/",l_imn.imn15,"/",l_imn.imn16,"/",g_user
         CALL s_errmsg("imn03/imn15/imn16/inc03",g_showmsg,'','asf-888',1)
         CONTINUE FOREACH
      END IF
      #TQC-C50158--add--end--
      IF cl_null(l_imn.imn04) THEN CONTINUE FOREACH END IF
      
      MESSAGE '_s read parts:',l_imn.imn03
      #No.MOD-AA0086  --Begin
      #产生拨入的rvbs_file资料
      CALL t325sub_ins_rvbs(l_imm.*,l_imn.*)  #DEV-D30046 
      IF g_success='N' THEN
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH   #No.FUN-6C0083
      END IF
      #No.MOD-AA0086  --End  

      #FUN-AB0066 --begin--
      IF NOT s_chk_ware(l_imn.imn04) THEN 
         LET g_totsuccess = 'N'
         RETURN 
      END IF 
      
      IF NOT s_chk_ware(l_imn.imn15) THEN 
         LET g_totsuccess = 'N'
         RETURN 
      END IF 
      #FUN-AB0066 --end--
       
      SELECT img09 INTO l_img09 FROM img_file
        WHERE img01=l_imn.imn03 AND img02=l_imm.imm08
        AND img03 =' ' AND img04 = ' '
 
      CALL s_umfchk(l_imn.imn03,
                       l_imn.imn09,l_img09)
                    RETURNING l_cnt,l_imm08_fac
           IF l_cnt = 1 THEN
              LET l_imm08_fac = 1
           END IF
      LET l_imn.imn10 = l_imn.imn10 * l_imm08_fac
      LET l_imn.imn10 = s_digqty(l_imn.imn10,l_imn.imn09)   #No.FUN-BB0086
 
      CALL s_t325_s(l_imn.imn03,l_imm.imm08,' ',' ',
                    -1,l_imn.imn10,l_imn.imn09,l_imm.imm11,l_imn.imn02,
                    l_imm.imm12,l_imn.imn28)   #No.b037         #bugno:6810 modify    #No.TQC-760153 add imn28
      IF g_success='N' THEN
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH   #No.FUN-6C0083
      END IF
      
      CALL s_t325_s(l_imn.imn03,l_imn.imn15,l_imn.imn16,l_imn.imn17,
                    +1,l_imn.imn22,l_imn.imn20,l_imm.imm11,l_imn.imn02,
                    l_imm.imm12,l_imn.imn28)   #No.b037         #bugno:6810 modify    #No.TQC-760153 add imn28
      IF g_success='N' THEN 
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH   #No.FUN-6C0083
      END IF
      
      IF g_sma.sma115='Y' THEN
         CALL t325sub_upd_s(l_imm.imm08,' ',' ',
                            l_imn.imn43,l_imn.imn44,l_imn.imn45,
                            l_imn.imn40,l_imn.imn41,l_imn.imn42,
                            l_imm.imm11,l_imn.imn02,1,
                            l_imn.*,l_imm.imm02)   #DEV-D30046
         IF g_success='N' THEN
           LET g_totsuccess="N"
           LET g_success="Y"
           CONTINUE FOREACH   #No.FUN-6C0083
         END IF
         CALL t325sub_upd_t(l_imn.imn15,l_imn.imn16,l_imn.imn17,
                            l_imn.imn43,l_imn.imn44,l_imn.imn45,
                            l_imn.imn40,l_imn.imn41,l_imn.imn42,
                            l_imm.imm11,l_imn.imn02,1,
                            l_imn.*,l_imm.imm02)   #DEV-D30046
         IF g_success='N' THEN
           LET g_totsuccess="N"
           LET g_success="Y"
           CONTINUE FOREACH   #No.FUN-6C0083
         END IF
      END IF
       
      UPDATE imn_file
         SET imn24='Y',
             imn25=g_user,
             imn26=g_today
       WHERE imn01=l_imn.imn01
         AND imn02=l_imn.imn02
 
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg = l_imn.imn01,"/",l_imn.imn02
         CALL s_errmsg('imn01,imn02',g_showmsg,'upd imn',SQLCA.SQLCODE,1)
         LET g_success='N'
      END IF
   END FOREACH
 
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
   CALL s_showmsg()   #No.FUN-6C0083
 
   IF g_success='Y' THEN
      UPDATE imm_file SET imm03 = 'Y'
       WHERE imm01 = l_imm.imm01 
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('imm01',l_imm.imm01,'up imm_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
 
   IF g_success = 'Y' THEN
      IF NOT p_inTransaction THEN   #DEV-D30046
         COMMIT WORK
      END IF   #DEV-D30046
      CALL cl_flow_notify(l_imm.imm01,'S')
      CALL cl_cmmsg(4)
   ELSE
      IF NOT p_inTransaction THEN   #DEV-D30046
         ROLLBACK WORK
      END IF   #DEV-D30046
      CALL cl_rbmsg(4)
   END IF
 
   SELECT imm03 INTO l_imm.imm03 FROM imm_file WHERE imm01 = l_imm.imm01 
   DISPLAY BY NAME l_imm.imm03
 
   #DEV-D30046 --mark--begin
   #IF g_success='Y' THEN
   #   CALL t325_b_fill(' 1=1')
   #END IF
   #DEV-D30046 --mark--end
 
   IF NOT p_inTransaction THEN   #DEV-D30046
      IF l_imm.imm03 = "N" THEN
         DECLARE t325sub_s1_c2 CURSOR FOR SELECT * FROM imn_file
           WHERE imn01 = l_imm.imm01 
  
         LET l_imm01 = ""
         LET g_success = "Y"
         BEGIN WORK
  
         FOREACH t325sub_s1_c2 INTO l_imn.*
            IF STATUS THEN
               EXIT FOREACH
            END IF
  
            IF g_sma.sma115 = 'Y' THEN
               IF g_ima906 = '2' THEN  #子母單位
                  LET g_unit_arr[1].unit= l_imn.imn30
                  LET g_unit_arr[1].fac = l_imn.imn31
                  LET g_unit_arr[1].qty = l_imn.imn32
                  LET g_unit_arr[2].unit= l_imn.imn33
                  LET g_unit_arr[2].fac = l_imn.imn34
                  LET g_unit_arr[2].qty = l_imn.imn35
                  CALL s_dismantle(l_imm.imm01,l_imn.imn02,l_imm.imm12,
                                   l_imn.imn03,l_imn.imn04,l_imn.imn05,
                                   l_imn.imn06,g_unit_arr,l_imm01)
                         RETURNING l_imm01
               END IF
            END IF
         END FOREACH
  
         IF g_success = "Y" AND NOT cl_null(l_imm01) THEN
            COMMIT WORK
            LET g_msg="aimt324 '",l_imm01,"'"
            CALL cl_cmdrun_wait(g_msg)
         ELSE
            ROLLBACK WORK
         END IF
      END IF
   END IF   #DEV-D30046
 
END FUNCTION

##################################
#作用    : 撥出確認還原
#傳入參數: p_imm01          調撥單號
#          p_inTransaction  若p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#          p_ask_conf       若p_ask_post='Y' 會詢問"是否執行確認"
#回傳值  : 無     
##################################
FUNCTION t325sub_w(p_imm01,p_inTransaction,p_ask_conf) 
   DEFINE p_imm01         LIKE imm_file.imm01    #DEV-D30046
   DEFINE p_inTransaction LIKE type_file.num5    #DEV-D30046
   DEFINE p_ask_conf      LIKE type_file.chr1    #DEV-D30046
   DEFINE l_cnt           LIKE type_file.num10   #No.MOD-610096 add  #No.FUN-690026 INTEGER
   DEFINE l_imm08_fac     LIKE imn_file.imn21    #No.MOD-610096 add
   DEFINE l_img09         LIKE img_file.img09    #No.MOD-610096 add
   #DEV-D30046 --add--begin
   DEFINE l_imm           RECORD LIKE imm_file.*   
   DEFINE l_imn           RECORD LIKE imn_file.* 
   DEFINE l_yy,l_mm       LIKE type_file.num5    
   #DEV-D30046 --add--end
 
 
   WHENEVER ERROR CONTINUE    #DEV-D30046      
   
   SELECT * INTO l_imm.* FROM imm_file WHERE imm01 = p_imm01
   
   IF cl_null(l_imm.imm01) THEN CALL cl_err('',-400,0)   RETURN END IF
   IF l_imm.imm03 = 'Y' THEN CALL cl_err('','aim-100',0) RETURN END IF
   IF l_imm.imm04 = 'N' THEN CALL cl_err('','aim-003',0) RETURN END IF     #No.TQC-750041
   IF l_imm.imm04 = 'X' THEN CALL cl_err('','9024',0)    RETURN END IF #no.6810 add
 
   #FUN-BC0062 ---------Begin--------
   #當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
      SELECT ccz_file.* INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
      IF g_ccz.ccz28  = '6' AND l_imm.imm04 = 'Y' THEN
         CALL cl_err('','apm-936',1)
         RETURN
      END IF
   #FUN-BC0062 ---------End----------
 
   IF NOT cl_null(g_sma.sma53) AND l_imm.imm02 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0)
      RETURN
   END IF
   
   CALL s_yp(l_imm.imm02) RETURNING l_yy,l_mm # bugno:6810 modify
   IF l_yy > g_sma.sma51 THEN                  # 與目前會計年度,期間比較
      CALL cl_err(l_yy,'mfg6090',0) RETURN
   ELSE 
      IF l_yy = g_sma.sma51 AND l_mm > g_sma.sma52  THEN    #No.MOD-8C0293
         CALL cl_err(l_mm,'mfg6091',0) RETURN
      END IF
   END IF
 
   IF p_ask_conf = 'Y' THEN   #DEV-D30046
      IF NOT cl_confirm('aap-224') THEN RETURN END IF
   END IF   #DEV-D30046
 
   DECLARE t325sub_w1_c CURSOR FOR 
      SELECT * FROM imn_file WHERE imn01 = l_imm.imm01 
   
   IF NOT p_inTransaction THEN   #DEV-D30046
      BEGIN WORK
   END IF   #DEV-D30046 
   
   CALL t325sub_lock_cl()   #DEV-D30046
   
   OPEN t325sub_cl USING l_imm.imm01
   IF STATUS THEN
      CALL cl_err("OPEN t325sub_cl:", STATUS, 1)
      CLOSE t325sub_cl
      IF NOT p_inTransaction THEN   #DEV-D30046
         ROLLBACK WORK
      END IF   #DEV-D30046 
      RETURN
   END IF
   
   FETCH t325sub_cl INTO l_imm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_imm.imm01,SQLCA.sqlcode,0)
      CLOSE t325sub_cl
      IF NOT p_inTransaction THEN   #DEV-D30046
         ROLLBACK WORK
      END IF   #DEV-D30046 
      RETURN
   END IF
   
   LET g_success = 'Y'
  
   CALL s_showmsg_init()   #No.FUN-6C0083 
 
   FOREACH t325sub_w1_c INTO l_imn.*
      IF STATUS THEN EXIT FOREACH END IF
      IF cl_null(l_imn.imn04) THEN CONTINUE FOREACH END IF
      MESSAGE '_w  read parts:',l_imn.imn03
 
      CALL t325sub_rev(l_imn.imn03,l_imn.imn04,l_imn.imn05,l_imn.imn06,
                       +1,l_imn.imn10,l_imn.imn09,l_imm.imm01,l_imn.imn02,l_imm.imm02,
                       l_imm.imm02,l_imm.imm12,l_imn.imn10)  #DEV-D30046
      IF g_success='N' THEN 
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH   #No.FUN-6C0083
      END IF
      
      #No.MOD-AA0086  --Begin
      CALL t325sub_del_tlfs(l_imn.imn04,l_imn.imn05,l_imn.imn06,-1,l_imm.imm01,l_imm.imm02,
                            l_imn.imn03,l_imn.imn02)   #DEV-D30046
      IF g_success='N' THEN 
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH   #No.FUN-6C0083
      END IF
      #No.MOD-AA0086  --End  

      SELECT img09 INTO l_img09 FROM img_file
        WHERE img01=l_imn.imn03 AND img02=l_imm.imm08
        AND img03 =' ' AND img04 = ' '
 
      CALL s_umfchk(l_imn.imn03,
                    l_imn.imn09,l_img09)
         RETURNING l_cnt,l_imm08_fac
      IF l_cnt = 1 THEN
         LET l_imm08_fac = 1
      END IF
      LET l_imn.imn10 = l_imn.imn10 * l_imm08_fac
      LET l_imn.imn10 = s_digqty(l_imn.imn10,l_imn.imn09)   #No.FUN-BB0086
 
      CALL t325sub_rev(l_imn.imn03,l_imm.imm08,' '        ,' '        ,
                       -1,l_imn.imn10,l_imn.imn09,l_imm.imm01,l_imn.imn02,l_imm.imm02,
                       l_imm.imm02,l_imm.imm12,l_imn.imn10)  
      IF g_success='N' THEN 
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH   #No.FUN-6C0083
      END IF
      
      IF g_sma.sma115='Y' THEN
         CALL t325sub_upd_s(l_imm.imm08,' ',' ',
                            l_imn.imn43,l_imn.imn44,l_imn.imn45,
                            l_imn.imn40,l_imn.imn41,l_imn.imn42,
                            l_imm.imm01,l_imn.imn02,2,
                            l_imn.*,l_imm.imm02) 
         IF g_success='N' THEN 
            LET g_totsuccess="N"
            LET g_success="Y"
            CONTINUE FOREACH   #No.FUN-6C0083
         END IF
         SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=l_imn.imn03
         IF g_ima906 MATCHES '[23]' THEN
            DELETE FROM tlff_file
             WHERE tlff902 =l_imm.imm08
               AND tlff903 =' '
               AND tlff904 =' '
               AND tlff905 =l_imm.imm01
               AND tlff906 =l_imn.imn02
               AND tlff907 =1
            IF STATUS THEN
               CALL s_errmsg('tlff902',l_imm.imm08,'del tlf',STATUS,1)
               LET g_success = 'N' CONTINUE FOREACH
            END IF
            IF SQLCA.SQLERRD[3]=0 THEN
               CALL s_errmsg('','','del tlf','aap-161',1)
               LET g_success = 'N' CONTINUE FOREACH
            END IF
         END IF
         CALL t325sub_upd_t(l_imn.imn04,l_imn.imn05,l_imn.imn06,
                            l_imn.imn33,l_imn.imn34,l_imn.imn35,
                            l_imn.imn30,l_imn.imn31,l_imn.imn32,
                            l_imm.imm01,l_imn.imn02,2,
                            l_imn.*,l_imm.imm02)  
         IF g_success='N' THEN 
            LET g_totsuccess="N"
            LET g_success="Y"
            CONTINUE FOREACH   #No.FUN-6C0083
         END IF
         IF g_ima906 MATCHES '[23]' THEN
            DELETE FROM tlff_file
             WHERE tlff902 =l_imn.imn04
               AND tlff903 =l_imn.imn05
               AND tlff904 =l_imn.imn06
               AND tlff905 =l_imm.imm01
               AND tlff906 =l_imn.imn02
               AND tlff907 =-1
            IF STATUS THEN
               LET g_showmsg = l_imn.imn04,"/",l_imn.imn05,"/",l_imn.imn06,"/",l_imm.imm01,"/",l_imn.imn02,"/",-1
               CALL s_errmsg('tlff902,tlff903,tlff904,tlff905,tlff906,tlff907',g_showmsg,'del tlf',STATUS,1)
               LET g_success = 'N' CONTINUE FOREACH
            END IF
            IF SQLCA.SQLERRD[3]=0 THEN
               CALL s_errmsg('','','del tlf','aap-161',1)
               LET g_success = 'N' CONTINUE FOREACH
            END IF
         END IF
      END IF
      #FUN-AC0074--begin--add-----
      CALL s_updsie_unsie(l_imn.imn01,l_imn.imn02,'4')
      IF g_success='N' THEN
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH
      END IF
      #FUN-AC0074--end--add----
   END FOREACH
 
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
   CALL s_showmsg()   #No.FUN-6C0083
 
   IF g_success = 'Y' THEN  #No.+052 010404 by plum
      UPDATE imm_file
         SET imm04 = 'N',
             imm11 = '',       #bugno:6810 add
             imm12 = NULL,     #bugno:6810 add
             imm13 = ''        #bugno:6810 add
       WHERE imm01 = l_imm.imm01
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('imm01',l_imm.imm01,'up imm_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
   
   IF g_success = 'Y' THEN
      IF NOT p_inTransaction THEN   #DEV-D30046
         COMMIT WORK
      END IF   #DEV-D30046
      CALL cl_cmmsg(4)
   ELSE
      IF NOT p_inTransaction THEN   #DEV-D30046
         ROLLBACK WORK
      END IF   #DEV-D30046
      CALL cl_rbmsg(4)
   END IF
   
   SELECT imm04,imm11,imm12,imm13
     INTO l_imm.imm04,l_imm.imm11,l_imm.imm12,l_imm.imm13
     FROM imm_file WHERE imm01 = l_imm.imm01
   DISPLAY BY NAME l_imm.imm04,l_imm.imm11,l_imm.imm12,l_imm.imm13
END FUNCTION

##################################
#作用    : 撥入確認還原
#傳入參數: p_imm01          調撥單號
#          p_inTransaction  若p_inTransaction=FALSE 會在程式中呼叫BEGIN WORK
#          p_ask_conf       若p_ask_post='Y' 會詢問"是否執行確認"
#回傳值  : 無     
##################################
FUNCTION t325sub_z(p_imm01,p_inTransaction,p_ask_conf)
   DEFINE p_imm01         LIKE imm_file.imm01    #DEV-D30046
   DEFINE p_inTransaction LIKE type_file.num5    #DEV-D30046
   DEFINE p_ask_conf      LIKE type_file.chr1    #DEV-D30046
   DEFINE l_cnt           LIKE type_file.num10   #No.MOD-610096 add  #No.FUN-690026 INTEGER
   DEFINE l_imm08_fac     LIKE imn_file.imn21    #No.MOD-610096 add
   DEFINE l_img09         LIKE img_file.img09    #No.MOD-610096 add
   #DEV-D30046 --add--begin
   DEFINE l_imm           RECORD LIKE imm_file.*   
   DEFINE l_imn           RECORD LIKE imn_file.* 
   DEFINE l_yy,l_mm       LIKE type_file.num5    
   #DEV-D30046 --add--end
 
 
   WHENEVER ERROR CONTINUE    #DEV-D30046      
    
   SELECT * INTO l_imm.* FROM imm_file WHERE imm01 = p_imm01
   
   IF cl_null(l_imm.imm01) THEN CALL cl_err('',-400,0)   RETURN END IF
   IF l_imm.imm04 = 'N' THEN CALL cl_err('','aim-003',0) RETURN END IF #no.6810 add    #No.TQC-750041
   IF l_imm.imm04 = 'X' THEN CALL cl_err('','9024',0)    RETURN END IF #no.6810 add
   IF l_imm.imm03 = 'N' THEN CALL cl_err('','aim-307',0) RETURN END IF
 
   #FUN-BC0062 ---------Begin--------
   #當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原 
   SELECT ccz_file.* INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
   IF g_ccz.ccz28  = '6' THEN
      CALL cl_err('','apm-936',1)
      RETURN
   END IF
   #FUN-BC0062 ---------End---------- 
 
   IF NOT cl_null(g_sma.sma53) AND l_imm.imm12 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0) RETURN
   END IF
   
   CALL s_yp(l_imm.imm12) RETURNING l_yy,l_mm
   IF l_yy > g_sma.sma51  THEN      #與目前會計年度,期間比較
       CALL cl_err(l_yy,'mfg6090',0) RETURN
   ELSE 
      IF l_yy = g_sma.sma51 AND l_mm > g_sma.sma52 THEN    #No.MOD-8C0293
         CALL cl_err(l_mm,'mfg6091',0) RETURN
      END IF
   END IF
   
   IF p_ask_conf = 'Y' THEN    #DEV-D30046
      IF NOT cl_confirm('aap-224') THEN RETURN END IF
   END IF   #DEV-D30046
   
   DECLARE t325sub_z1_c CURSOR FOR 
      SELECT * FROM imn_file WHERE imn01=l_imm.imm01 
   
   IF NOT p_inTransaction THEN   #DEV-D30046
      BEGIN WORK
   END IF    #DEV-D30046
 
   CALL t325sub_lock_cl()   #DEV-D30046
   
   OPEN t325sub_cl USING l_imm.imm01
   IF STATUS THEN
      CALL cl_err("OPEN t325sub_cl:", STATUS, 1)
      CLOSE t325sub_cl
      IF NOT p_inTransaction THEN   #DEV-D30046
         ROLLBACK WORK
      END IF    #DEV-D30046
      RETURN
   END IF
   FETCH t325sub_cl INTO l_imm.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_imm.imm01,SQLCA.sqlcode,0)
      CLOSE t325sub_cl
      IF NOT p_inTransaction THEN   #DEV-D30046
         ROLLBACK WORK
      END IF    #DEV-D30046
      RETURN
   END IF
   LET g_success = 'Y'
 
   CALL s_showmsg_init()   #No.FUN-6C0083 
 
   FOREACH t325sub_z1_c INTO l_imn.*
      IF STATUS THEN EXIT FOREACH END IF
      IF cl_null(l_imn.imn04) THEN CONTINUE FOREACH END IF

      SELECT img09 INTO l_img09 FROM img_file
        WHERE img01=l_imn.imn03 AND img02=l_imm.imm08
        AND img03 =' ' AND img04 = ' '
 
      CALL s_umfchk(l_imn.imn03,
                    l_imn.imn09,l_img09)
         RETURNING l_cnt,l_imm08_fac
      IF l_cnt = 1 THEN
         LET l_imm08_fac = 1
      END IF
      LET l_imn.imn10 = l_imn.imn10 * l_imm08_fac
      LET l_imn.imn10 = s_digqty(l_imn.imn10,l_imn.imn09)   #No.FUN-BB0086
 
      CALL t325sub_rev(l_imn.imn03,l_imm.imm08,' '        ,' '        ,
                       +1,l_imn.imn10,l_imn.imn09,l_imm.imm11,l_imn.imn02,l_imm.imm12,
                       l_imm.imm02,l_imm.imm12,l_imn.imn10)  
      IF g_success='N' THEN 
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH   #No.FUN-6C0083
      END IF
        
      CALL t325sub_rev(l_imn.imn03,l_imn.imn15,l_imn.imn16,l_imn.imn17,
                       -1,l_imn.imn22,l_imn.imn20,l_imm.imm11,l_imn.imn02,l_imm.imm12,
                       l_imm.imm02,l_imm.imm12,l_imn.imn10)  
      IF g_success='N' THEN 
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH   #No.FUN-6C0083
      END IF
        
      #No.MOD-AA0086  --Begin
      CALL t325sub_del_tlfs(l_imn.imn15,l_imn.imn16,l_imn.imn17,+1,l_imm.imm11,l_imm.imm12,
                            l_imn.imn03,l_imn.imn02)  
      IF g_success='N' THEN 
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH   #No.FUN-6C0083
      END IF

      #delete 拨入方的rvbs_file资料
      CALL t325sub_del_rvbs(l_imm.*,l_imn.*) 
      IF g_success='N' THEN 
         LET g_totsuccess="N"
         LET g_success="Y"
         CONTINUE FOREACH   #No.FUN-6C0083
      END IF
      #No.MOD-AA0086  --End  
       
      IF g_sma.sma115='Y' THEN
         CALL t325sub_upd_s(l_imn.imn15,l_imn.imn16,l_imn.imn17,
                            l_imn.imn43,l_imn.imn44,l_imn.imn45,
                            l_imn.imn40,l_imn.imn41,l_imn.imn42,
                            l_imm.imm11,l_imn.imn02,2,
                            l_imn.*,l_imm.imm02) 
         IF g_success='N' THEN 
            LET g_totsuccess="N"
            LET g_success="Y"
            CONTINUE FOREACH   #No.FUN-6C0083
         END IF
         SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=l_imn.imn03
         IF g_ima906 MATCHES '[23]' THEN
            DELETE FROM tlff_file
             WHERE tlff902 =l_imn.imn15
               AND tlff903 =l_imn.imn16
               AND tlff904 =l_imn.imn17
               AND tlff905 =l_imm.imm11
               AND tlff906 =l_imn.imn02
               AND tlff907 =1
            IF STATUS THEN
               LET g_showmsg = l_imn.imn15,"/",l_imn.imn16,"/",l_imn.imn17,"/",l_imm.imm11,"/",l_imn.imn02,"/",1
               LET g_success = 'N' CONTINUE FOREACH
            END IF
            IF SQLCA.SQLERRD[3]=0 THEN
               CALL s_errmsg('','','del tlf','aap-161',1)
               LET g_success = 'N' CONTINUE FOREACH 
            END IF
         END IF
         CALL t325sub_upd_t(l_imm.imm08,' ',' ',
                            l_imn.imn43,l_imn.imn44,l_imn.imn45,
                            l_imn.imn40,l_imn.imn41,l_imn.imn42,
                            l_imm.imm11,l_imn.imn02,2,
                            l_imn.*,l_imm.imm02)  
         IF g_success='N' THEN 
            LET g_totsuccess="N"
            LET g_success="Y"
            CONTINUE FOREACH   #No.FUN-6C0083
         END IF
         IF g_ima906 MATCHES '[23]' THEN
            DELETE FROM tlff_file
             WHERE tlff902 =l_imm.imm08
               AND tlff903 =' '
               AND tlff904 =' '
               AND tlff905 =l_imm.imm11
               AND tlff906 =l_imn.imn02
               AND tlff907 =-1
            IF STATUS THEN
               CALL s_errmsg('tlff902',l_imm.imm08,'del tlf',STATUS,1)
               LET g_success = 'N' 
               CONTINUE FOREACH
            END IF
            IF SQLCA.SQLERRD[3]=0 THEN
               CALL s_errmsg('','','del tlf','aap-161',1) 
               LET g_success = 'N' 
               CONTINUE FOREACH
            END IF
         END IF
      END IF
      
      UPDATE imn_file
        SET imn24='N',
      #FUN-D20059--str---
      #     imn25='',
      #     imn26=''
            imn25=g_user,
            imn26=g_today
      #FUN-D20059--end---
       WHERE imn01=l_imn.imn01
         AND imn02=l_imn.imn02
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         LET g_showmsg = l_imn.imn01,"/",l_imn.imn02
         CALL s_errmsg('imn01,imn02',g_showmsg,'upd imn',SQLCA.SQLCODE,1)
         LET g_success='N'
      END IF
   END FOREACH
 
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
   CALL s_showmsg()   #No.FUN-6C0083
 
   IF g_success = 'Y' THEN
      UPDATE imm_file SET imm03 = 'N' WHERE imm01 = l_imm.imm01 
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('imm01',l_imm.imm01,'up imm_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
    
   IF g_success = 'Y' THEN
      IF NOT p_inTransaction THEN   #DEV-D30046
         COMMIT WORK
      END IF   #DEV-D30046
      CALL cl_cmmsg(4)
   ELSE
      IF NOT p_inTransaction THEN   #DEV-D30046
         ROLLBACK WORK
      END IF   #DEV-D30046
      CALL cl_rbmsg(4)
   END IF
      
   #DEV-D30046 --mark--begin
   #SELECT imm03 INTO l_imm.imm03 FROM imm_file WHERE imm01 = l_imm.imm01 
   #DISPLAY BY NAME l_imm.imm03
   # 
   #IF g_success='Y' THEN
   #   CALL t325_b_fill(' 1=1')
   #END IF
   #DEV-D30046 --mark--end
 
END FUNCTION

#撥出
FUNCTION t325sub_upd_s(p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,
                       p_unit1,p_fac1,p_qty1,p_no,p_seq,p_type,
                       p_imn,p_date)  
   DEFINE l_ima25   LIKE ima_file.ima25,
          p_ware    LIKE img_file.img02,
          p_loc     LIKE img_file.img03,
          p_lot     LIKE img_file.img04,
          p_unit2   LIKE img_file.img09,
          p_fac2    LIKE img_file.img21,
          p_qty2    LIKE img_file.img10,
          p_unit1   LIKE img_file.img09,
          p_fac1    LIKE img_file.img21,
          p_qty1    LIKE img_file.img10,
          p_no      LIKE imn_file.imn01,
          p_seq     LIKE imn_file.imn02,
          p_type    LIKE type_file.num5    #No.FUN-690026 SMALLINT
   DEFINE p_imn     RECORD LIKE imn_file.*   #DEV-D30046
   DEFINE p_date    LIKE type_file.dat       #DEV-D30046
  
   SELECT ima906,ima907,ima25 INTO g_ima906,g_ima907,l_ima25 FROM ima_file
    WHERE ima01 = p_imn.imn03
   IF SQLCA.sqlcode THEN
      LET g_success='N' RETURN
   END IF
   IF g_ima906 = '1' OR cl_null(g_ima906) THEN
      RETURN
   END IF
 
   IF g_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(p_qty2) THEN                            #CHI-860005
         CALL t325sub_upd_imgg('1',p_imn.imn03,p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,-1,'2',p_date)
         IF g_success='N' THEN RETURN END IF
         IF p_type=1 THEN
            CALL t325sub_tlff_1('2',p_imn.*,-1,p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,p_unit2,p_qty2,p_no,p_seq,p_date)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      IF NOT cl_null(p_qty1) THEN                            #CHI-860005
         CALL t325sub_upd_imgg('1',p_imn.imn03,p_ware,p_loc,p_lot,p_unit1,p_fac1,p_qty1,-1,'1',p_date)
         IF g_success='N' THEN RETURN END IF
         IF p_type=1 THEN
            CALL t325sub_tlff_1('1',p_imn.*,-1,p_ware,p_loc,p_lot,p_unit1,p_fac1,p_qty1,p_unit2,p_qty2,p_no,p_seq,p_date)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
   IF g_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(p_qty2) THEN                            #CHI-860005
         CALL t325sub_upd_imgg('2',p_imn.imn03,p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,-1,'2',p_date)
         IF g_success = 'N' THEN RETURN END IF
         IF p_type=1 THEN
            CALL t325sub_tlff_1('2',p_imn.*,-1,p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,p_unit2,p_qty2,p_no,p_seq,p_date)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
 
END FUNCTION

#撥入
FUNCTION t325sub_upd_t(p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,
                       p_unit1,p_fac1,p_qty1,p_no,p_seq,p_type,p_imn,p_date)  
   DEFINE l_ima25   LIKE ima_file.ima25,
          p_ware    LIKE img_file.img02,
          p_loc     LIKE img_file.img03,
          p_lot     LIKE img_file.img04,
          p_unit2   LIKE img_file.img09,
          p_fac2    LIKE img_file.img21,
          p_qty2    LIKE img_file.img10,
          p_unit1   LIKE img_file.img09,
          p_fac1    LIKE img_file.img21,
          p_qty1    LIKE img_file.img10,
          p_no      LIKE imn_file.imn01,
          p_seq     LIKE imn_file.imn02,
          p_type    LIKE type_file.num5    #No.FUN-690026 SMALLINT
   DEFINE p_imn     RECORD LIKE imn_file.*   #DEV-D30046
   DEFINE p_date    LIKE type_file.dat       #DEV-D30046
 
   SELECT ima906,ima907,ima25 INTO g_ima906,g_ima907,l_ima25 FROM ima_file
    WHERE ima01 = p_imn.imn03
   IF SQLCA.sqlcode THEN
      LET g_success='N' RETURN
   END IF
   IF g_ima906 = '1' OR cl_null(g_ima906) THEN RETURN END IF
 
   IF g_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(p_qty2) THEN                        #CHI-860005
         CALL t325sub_upd_imgg('1',p_imn.imn03,p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,+1,'2',p_date)
         IF g_success='N' THEN RETURN END IF
         IF p_type=1 THEN
            CALL t325sub_tlff_2('2',p_imn.*,+1,p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,p_unit2,p_qty2,p_no,p_seq,p_date)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      IF NOT cl_null(p_qty1) THEN                        #CHI-860005
         CALL t325sub_upd_imgg('1',p_imn.imn03,p_ware,p_loc,p_lot,p_unit1,p_fac1,p_qty1,+1,'1',p_date)
         IF g_success='N' THEN RETURN END IF
         IF p_type=1 THEN
            CALL t325sub_tlff_2('1',p_imn.*,+1,p_ware,p_loc,p_lot,p_unit1,p_fac1,p_qty1,p_unit2,p_qty2,p_no,p_seq,p_date)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
   IF g_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(p_qty2) THEN                        #CHI-860005
         CALL t325sub_upd_imgg('2',p_imn.imn03,p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,+1,'2',p_date)
         IF g_success = 'N' THEN RETURN END IF
         IF p_type=1 THEN
            CALL t325sub_tlff_2('2',p_imn.*,+1,p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,p_unit2,p_qty2,p_no,p_seq,p_date)
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
 
END FUNCTION

FUNCTION t325sub_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                          p_imgg09,p_imgg211,p_imgg10,p_type,p_no,p_date)
   DEFINE p_imgg00        LIKE imgg_file.imgg00,
          p_imgg01        LIKE imgg_file.imgg01,
          p_imgg02        LIKE imgg_file.imgg02,
          p_imgg03        LIKE imgg_file.imgg03,
          p_imgg04        LIKE imgg_file.imgg04,
          p_imgg09        LIKE imgg_file.imgg09,
          p_imgg211       LIKE imgg_file.imgg211,
          p_imgg10        LIKE imgg_file.imgg10,
          p_no            LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_ima25         LIKE ima_file.ima25,
          l_ima906        LIKE ima_file.ima906,
          l_imgg21        LIKE imgg_file.imgg21,
          p_type          LIKE type_file.num10    #No.FUN-690026 INTEGER
    DEFINE l_forupd_sql   STRING               #DEV-D30046
    DEFINE p_date         LIKE type_file.dat   #DEV-D30046
  
    LET l_forupd_sql =
        "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
        "   WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
        "   AND imgg09= ? FOR UPDATE "
 
    LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
    DECLARE imgg_lock CURSOR FROM l_forupd_sql
 
    OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       CALL cl_err("OPEN imgg_lock:", STATUS, 1)
       LET g_success='N'
       CLOSE imgg_lock
       RETURN
    END IF
    FETCH imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       CALL cl_err('lock imgg fail',STATUS,1)
       LET g_success='N'
       CLOSE imgg_lock
       RETURN
    END IF
 
    SELECT ima25,ima906 INTO l_ima25,l_ima906
      FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","ima25 null",1) #No.FUN-660156
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING g_cnt,l_imgg21
    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' RETURN
    END IF
 
    #CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,g_imm.imm02,#FUN-8C0083  #DEV-D30046 --mark
    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,p_date,   #DEV-D30046 --add
          '','','','','','','','',p_imgg09,'',l_imgg21,'','','','','','','',p_imgg211) #FUN-8C0083 ''-->p_imgg09
    IF g_success='N' THEN RETURN END IF
 
END FUNCTION

FUNCTION t325sub_tlff_1(p_flag,p_imn,p_type,p_ware,p_loc,p_lot,p_unit,
                        p_fac,p_qty,p_unit2,p_qty2,p_no,p_seq,p_date)
DEFINE
   p_imn      RECORD LIKE imn_file.*,
   p_flag     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
   p_type     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
   p_ware     LIKE img_file.img02,
   p_loc      LIKE img_file.img03,
   p_lot      LIKE img_file.img04,
   p_unit     LIKE img_file.img09,
   p_fac      LIKE img_file.img21,
   p_qty      LIKE img_file.img10,
   p_unit2    LIKE img_file.img09,
   p_qty2     LIKE img_file.img10,
   p_no       LIKE imn_file.imn01,
   p_seq      LIKE imn_file.imn02,
   p_date     LIKE type_file.dat,   #DEV-D30046
   l_imgg10   LIKE imgg_file.imgg10
 
    IF p_unit IS NULL THEN
       CALL cl_err('unit null:','asf-031',1) LET g_success = 'N' RETURN
    END IF
 
    INITIALIZE g_tlff.* TO NULL
    SELECT imgg10 INTO l_imgg10 FROM imgg_file
     WHERE imgg01=p_imn.imn03  AND imgg02=p_ware
       AND imgg03=p_loc        AND imgg04=p_lot
       AND imgg09=p_unit
    IF cl_null(l_imgg10) THEN LET l_imgg10=0 END IF
 
    LET g_tlff.tlff01=p_imn.imn03 	        #異動料件編號
    #----來源----
    LET g_tlff.tlff02 =50
    LET g_tlff.tlff020=g_plant                  #工廠別
    LET g_tlff.tlff021=p_ware        	        #倉庫別
    LET g_tlff.tlff022=p_loc                    #儲位別
    LET g_tlff.tlff023=p_lot               	#批號
    LET g_tlff.tlff024=l_imgg10                 #異動後庫存數量
    LET g_tlff.tlff025=p_unit                   #庫存單位(ima_file or img_file)
    LET g_tlff.tlff026=p_no                     #調撥單號
    LET g_tlff.tlff027=p_seq                    #項次
    LET g_tlff.tlff03=99         	 	
    LET g_tlff.tlff030=' '
    LET g_tlff.tlff031=' '
    LET g_tlff.tlff032=' '
    LET g_tlff.tlff033=' '          	
    LET g_tlff.tlff034=0
    LET g_tlff.tlff035=' '
    LET g_tlff.tlff036=' '
    LET g_tlff.tlff037=0
 
#--->異動數量
    LET g_tlff.tlff04=' '                       #工作站
    LET g_tlff.tlff05=' '                       #作業序號
    #LET g_tlff.tlff06=g_imm.imm02               #發料日期 #DEV-D30046 --mark
    LET g_tlff.tlff06=p_date                    #DEV-D30046 --add
    LET g_tlff.tlff07=g_today                   #異動資料產生日期
    LET g_tlff.tlff08=TIME                      #異動資料產生時:分:秒
    LET g_tlff.tlff09=g_user                    #產生人
    LET g_tlff.tlff10=p_qty                     #調撥數量
    LET g_tlff.tlff11=p_unit                    #撥入單位
    LET g_tlff.tlff12=p_fac                     #撥入/撥出庫存轉換率
    LET g_tlff.tlff13='aimt325'                 #異動命令代號
    LET g_tlff.tlff14=' '                       #異動原因
    LET g_tlff.tlff15=' '                       #借方會計科目
    LET g_tlff.tlff16=' '                       #貸方會計科目
    LET g_tlff.tlff17=' '                       #remark
    CALL s_imaQOH(p_imn.imn03)
         RETURNING g_tlff.tlff18
    LET g_tlff.tlff19= ' '                      #異動廠商/客戶編號
    LET g_tlff.tlff20= ' '                      #project no.
    LET g_tlff.tlff61= ' '                      #
    LET g_tlff.tlff930=p_imn.imn9301            #FUN-670093
    IF cl_null(p_qty2) OR p_qty2 = 0 THEN
       CALL s_tlff(p_flag,NULL)
    ELSE
       CALL s_tlff(p_flag,p_unit2)
    END IF
END FUNCTION
 
FUNCTION t325sub_tlff_2(p_flag,p_imn,p_type,p_ware,p_loc,p_lot,p_unit,
                        p_fac,p_qty,p_unit2,p_qty2,p_no,p_seq,p_date)
DEFINE
   p_imn      RECORD LIKE imn_file.*,
   p_flag     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
   p_type     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
   p_ware     LIKE img_file.img02,
   p_loc      LIKE img_file.img03,
   p_lot      LIKE img_file.img04,
   p_unit     LIKE img_file.img09,
   p_fac      LIKE img_file.img21,
   p_qty      LIKE img_file.img10,
   p_unit2    LIKE img_file.img09,
   p_qty2     LIKE img_file.img10,
   p_no       LIKE imn_file.imn01,
   p_seq      LIKE imn_file.imn02,
   p_date     LIKE type_file.dat,   #DEV-D30046
   l_imgg10   LIKE imgg_file.imgg10
 
    IF p_unit IS NULL THEN
       CALL cl_err('unit null:','asf-031',1) LET g_success = 'N' RETURN
    END IF
 
    INITIALIZE g_tlff.* TO NULL
    SELECT imgg10 INTO l_imgg10 FROM imgg_file   #撥出
     WHERE imgg01=p_imn.imn03  AND imgg02=p_ware
       AND imgg03=p_loc        AND imgg04=p_lot
       AND imgg09=p_unit
    IF cl_null(l_imgg10) THEN LET l_imgg10=0 END IF
 
    LET g_tlff.tlff01=p_imn.imn03 	        #異動料件編號
    LET g_tlff.tlff02=99         	 	#來源為倉庫(撥出)
    LET g_tlff.tlff03=50         	        #資料目的為(撥入)
    LET g_tlff.tlff030=g_plant                  #工廠別
    LET g_tlff.tlff031=p_ware                   #倉庫別
    LET g_tlff.tlff032=p_loc                    #儲位別
    LET g_tlff.tlff033=p_lot        	        #批號
    LET g_tlff.tlff034=l_imgg10                 #異動後庫存量
    LET g_tlff.tlff035=p_unit                  	#庫存單位(ima_file or img_file)
    LET g_tlff.tlff036=p_no                     #參考號碼
    LET g_tlff.tlff037=p_seq                    #項次
 
#--->異動數量
    LET g_tlff.tlff04=' '                       #工作站
    LET g_tlff.tlff05=' '                       #作業序號
    #LET g_tlff.tlff06=g_imm.imm02               #發料日期   #DEV-D30046 --mark
    LET g_tlff.tlff06=p_date                    #DEV-D30046 --add
    LET g_tlff.tlff07=g_today                   #異動資料產生日期
    LET g_tlff.tlff08=TIME                      #異動資料產生時:分:秒
    LET g_tlff.tlff09=g_user                    #產生人
    LET g_tlff.tlff10=p_qty                     #調撥數量
    LET g_tlff.tlff11=p_unit                    #撥入單位
    LET g_tlff.tlff12=p_fac                     #撥入/撥出庫存轉換率
    LET g_tlff.tlff13='aimt325'                 #異動命令代號
    LET g_tlff.tlff14=' '                       #異動原因
    LET g_tlff.tlff15=' '                       #借方會計科目
    LET g_tlff.tlff16=' '                       #貸方會計科目
    LET g_tlff.tlff17=' '                       #remark
    CALL s_imaQOH(p_imn.imn03)
         RETURNING g_tlff.tlff18
    LET g_tlff.tlff19= ' '                      #異動廠商/客戶編號
    LET g_tlff.tlff20= ' '                      #project no.
    LET g_tlff.tlff61= ' '                      #
    LET g_tlff.tlff930=p_imn.imn9302            #FUN-670093
    IF cl_null(p_qty2) OR p_qty2 = 0 THEN
       CALL s_tlff(p_flag,NULL)
    ELSE
       CALL s_tlff(p_flag,p_unit2)
    END IF
END FUNCTION

FUNCTION t325sub_ins_rvbs(p_imm,p_imn)
   DEFINE l_rvbs       RECORD LIKE rvbs_file.*
   DEFINE l_ima918     LIKE ima_file.ima918
   DEFINE l_ima921     LIKE ima_file.ima921
   #DEV-D30046 --add --begin
   DEFINE p_imm        RECORD LIKE imm_file.*
   DEFINE p_imn        RECORD LIKE imn_file.*
   #DEV-D30046 --add --end

   SELECT ima918,ima921 INTO l_ima918,l_ima921
     FROM ima_file
    WHERE ima01 = p_imn.imn03
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

   DELETE FROM rvbs_file WHERE rvbs00 = g_prog
                           AND rvbs01 = p_imm.imm11
                           AND rvbs02 = p_imn.imn02
                           AND rvbs13 = 0
                           AND rvbs09 = 1

   DECLARE t325sub_g_rvbs CURSOR FOR SELECT * FROM rvbs_file
                                   WHERE rvbs00 = 'aimt325'
                                     AND rvbs01 = p_imm.imm01
                                     AND rvbs02 = p_imn.imn02
                                     AND rvbs13 = 0
                                     AND rvbs09 = -1

   FOREACH t325sub_g_rvbs INTO l_rvbs.*
      IF STATUS THEN                    
         CALL cl_err('rvbs',STATUS,1)
      END IF

      LET l_rvbs.rvbs00 = g_prog
      LET l_rvbs.rvbs01 = p_imm.imm11
      LET l_rvbs.rvbs09 = 1
      LET l_rvbs.rvbsplant = g_plant #FUN-980004 add
      LET l_rvbs.rvbslegal = g_legal #FUN-980004 add

      INSERT INTO rvbs_file VALUES(l_rvbs.*)
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1)
         LET g_success='N'
      END IF
   END FOREACH
END FUNCTION

FUNCTION t325sub_del_rvbs(p_imm,p_imn)
   DEFINE l_ima918     LIKE ima_file.ima918
   DEFINE l_ima921     LIKE ima_file.ima921
   #DEV-D30046 --add --begin
   DEFINE p_imm        RECORD LIKE imm_file.*
   DEFINE p_imn        RECORD LIKE imn_file.*
   #DEV-D30046 --add --end

   SELECT ima918,ima921 INTO l_ima918,l_ima921
     FROM ima_file
    WHERE ima01 = p_imn.imn03
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
      MESSAGE "d_rvbs!"
   END IF

   CALL ui.Interface.refresh()

   DELETE FROM rvbs_file WHERE rvbs00 = g_prog
                           AND rvbs01 = p_imm.imm11
                           AND rvbs02 = p_imn.imn02
                           AND rvbs13 = 0
                           AND rvbs09 = 1
   IF STATUS THEN
      IF g_bgerr THEN
         LET g_showmsg = p_imm.imm11,'/',p_imn.imn02
         CALL s_errmsg('rvbs01,rvbs02',g_showmsg,'del rvbs:',STATUS,1)
      ELSE
         CALL cl_err3("del","rvbs_file",p_imm.imm11,p_imn.imn02,STATUS,"","del rvbs",1)
      END IF
      LET g_success='N'
      RETURN
   END IF

   IF SQLCA.SQLERRD[3]=0 THEN     
      IF g_bgerr THEN
         LET g_showmsg = p_imm.imm11,'/',p_imn.imn02
         CALL s_errmsg('rvbs01,rvbs02',g_showmsg,'del rvbs:',STATUS,1)
      ELSE
	 CALL cl_err3("del","rvbs_file",p_imm.imm11,p_imn.imn02,STATUS,"","del rvbs",1)
      END IF
      LET g_success='N'
      RETURN
   END IF
END FUNCTION


FUNCTION t325sub_rev(p_part,p_ware,p_loc,p_lot,p_type,p_qty,p_unit,p_no,p_item,p_date,p_imm02,p_imm12,p_imn10)
   DEFINE #p_part,p_ware,p_loc,p_lot VARCHAR(20), #TQC-5C0071
          p_part         LIKE img_file.img01, #TQC-5C0071
          p_ware         LIKE img_file.img02, #TQC-5C0071
          p_loc          LIKE img_file.img03, #TQC-5C0071
          p_lot          LIKE img_file.img04, #TQC-5C0071
          p_type         LIKE type_file.num5,  #-1.出 1.入  #No.FUN-690026 SMALLINT
          p_unit         LIKE img_file.img09, #TQC-5C0071
          p_qty          LIKE img_file.img10, #MOD-530179
          p_no           LIKE imm_file.imm01,
          p_item         LIKE imn_file.imn02,
          p_date         LIKE imm_file.imm02,
          l_date         LIKE imm_file.imm02,   #No.MOD-750088 add
          l_img          RECORD LIKE img_file.*,
          l_ima01        LIKE ima_file.ima01     #No.TQC-930155
   DEFINE la_tlf         DYNAMIC ARRAY OF RECORD LIKE tlf_file.*  #NO.FUN-8C0131 
   DEFINE l_sql          STRING                                   #NO.FUN-8C0131 
   DEFINE l_i            LIKE type_file.num5                      #NO.FUN-8C0131
   DEFINE l_forupd_sql   STRING                   #DEV-D30046
   DEFINE p_imm02        LIKE imm_file.imm12      #DEV-D30046
   DEFINE p_imm12        LIKE imm_file.imm12      #DEV-D30046
   DEFINE p_imn10        LIKE imn_file.imn10      #DEV-D30046
 
   INITIALIZE l_img.* TO NULL
   LET l_forupd_sql = "SELECT img_file.* FROM img_file ",                                                                            
                      " WHERE img01= ? AND img02=  ? ",                                                                            
                      "   AND img03= ? AND img04=  ? FOR UPDATE "                                                                  
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE img_lock CURSOR FROM l_forupd_sql                                                                                       
   OPEN img_lock USING p_part,p_ware,p_loc,p_lot                                                                                   
   IF STATUS THEN                                                                                                                  
      CALL cl_err("img_lock fail:", STATUS, 1)                                                                                     
      LET g_success = 'N'                                                                                                          
      RETURN                                                                                                                       
   END IF                                                                                                                          
   FETCH img_lock INTO l_img.*                                                                                             
   IF STATUS THEN                                                                                                                  
      CALL cl_err("sel img_file fail:", STATUS, 1)                                                                                 
      LET g_success = 'N'                                                                                                          
      RETURN                                                                                                                       
   END IF                                                                                                                          
 
   IF p_type='-1' THEN
      IF g_prog = 'aimt326' THEN
         LET l_date = p_imm12
      ELSE
         LET l_date = p_imm02
      END IF
 
      IF NOT s_stkminus(p_part,p_ware,p_loc,p_lot,
                       #l_imn.imn10,1,p_imm.imm02,g_sma.sma894[4,4]) THEN
                       #l_imn.imn10,1,l_date,g_sma.sma894[4,4]) THEN    #FUN-D30024--mark
                        p_imn10,1,l_date) THEN                      #FUN-D30024--add
         LET g_success='N'
         RETURN
      END IF
   END IF
 
   CALL s_upimg(p_part,p_ware,p_loc,p_lot,p_type,p_qty,p_date,'','','','',       #FUN-8C0084
              # '','','','','','','','','','','','','','')                       #No.MOD-AA0086
                p_no,p_item,'','','','','','','','','','','','')                 #No.MOD-AA0086
 
   IF g_success='N' THEN RETURN END IF #No.+052 010404 by plum
   LET l_forupd_sql = "SELECT ima01 FROM ima_file WHERE ima01= ?  FOR UPDATE "   
   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
   DECLARE ima_lock CURSOR FROM l_forupd_sql
   OPEN ima_lock USING l_img.img01          
   IF STATUS THEN                            
      CALL cl_err('lock ima fail',STATUS,1)   
      LET g_success='N'              
      RETURN                          
   END IF                              
   FETCH ima_lock INTO l_ima01          
   IF STATUS THEN                        
      CALL cl_err('sel ima_file fail',STATUS,1)
      LET g_success='N'                    
      RETURN                                
   END IF                                    
   #No.TQC-930155-------------end--------------
   #TQC-C50236--mark--str--
   #CALL s_udima(l_img.img01,l_img.img23,l_img.img24,p_qty*l_img.img21,
   #             TODAY,p_type) RETURNING g_i
   #IF g_success='N' THEN RETURN END IF #No.+052 010404 by plum
   #TQC-C50236--mark--end--

   ##NO.FUN-8C0131   add--begin   
   LET l_sql =  " SELECT  * FROM tlf_file ", 
                "  WHERE  tlf902 = '",p_ware,"'",
                "    AND tlf903='",p_loc,"' AND tlf904='",p_lot,"'",
                "   AND tlf905 ='",p_no,"' AND tlf906 ='",p_item,"' AND tlf907 =",p_type*-1,""     
   DECLARE t325sub_u_tlf_c CURSOR FROM l_sql
   LET l_i = 0 
   CALL la_tlf.clear()
   FOREACH t325sub_u_tlf_c INTO g_tlf.*
      LET l_i = l_i + 1
      LET la_tlf[l_i].* = g_tlf.*
   END FOREACH     

   ##NO.FUN-8C0131   add--end  
   DELETE FROM tlf_file
          WHERE tlf902 =p_ware
            AND tlf903 =p_loc
            AND tlf904 =p_lot
            AND tlf905 =p_no
            AND tlf906 =p_item
            AND tlf907 =p_type*-1
   IF STATUS THEN
      CALL cl_err3("del","tlf_file",p_ware,"",STATUS,"","del tlf",1)   #NO.FUN-640266 #No.FUN-660156
      LET g_success = 'N' RETURN
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("del","tlf_file",p_ware,"","aap-161","","del tlf",1)   #No.FUN-660156
      LET g_success = 'N' RETURN
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

FUNCTION t325sub_del_tlfs(p_ware,p_loc,p_lot,p_type,p_no,p_date,p_itemno,p_ln)
   DEFINE p_ware       LIKE img_file.img02
   DEFINE p_loc        LIKE img_file.img03
   DEFINE p_lot        LIKE img_file.img04
   DEFINE p_type       LIKE type_file.num5
   DEFINE p_no         LIKE imm_file.imm01
   DEFINE p_date       LIKE type_file.dat
   DEFINE l_ima918     LIKE ima_file.ima918
   DEFINE l_ima921     LIKE ima_file.ima921
   DEFINE p_itemno     LIKE ima_file.ima01   #DEV-D30046
   DEFINE p_ln         LIKE imn_file.imn02   #DEV-D30046

   SELECT ima918,ima921 INTO l_ima918,l_ima921
     FROM ima_file
    WHERE ima01 = p_itemno  #DEV-D30046
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
    WHERE tlfs01 = p_itemno   #DEV-D30046
      AND tlfs02 = p_ware
      AND tlfs03 = p_loc 
      AND tlfs04 = p_lot 
      AND tlfs09 = p_type
      AND tlfs10 = p_no
      AND tlfs11 = p_ln       #DEV-D30046
      AND tlfs111= p_date

   IF STATUS THEN
      IF g_bgerr THEN
         LET g_showmsg = p_itemno,'/',p_date
         CALL s_errmsg('tlfs01,tlfs111',g_showmsg,'del tlfs:',STATUS,1)
      ELSE
         CALL cl_err3("del","tlfs_file",p_no,"",STATUS,"","del tlfs",1)
      END IF
      LET g_success='N'
      RETURN
   END IF

   IF SQLCA.SQLERRD[3]=0 THEN
      IF g_bgerr THEN
         LET g_showmsg = p_itemno,'/',p_date
         CALL s_errmsg('tlfs01,tlfs111',g_showmsg,'del tlfs:','mfg0177',1)
      ELSE
         CALL cl_err3("del","tlfs_file",p_no,"","mfg0177","","del tlfs",1)
      END IF
      LET g_success='N'
      RETURN
   END IF
END FUNCTION

#DEV-D30046 --add--begin
FUNCTION t325sub_refresh(p_imm01)
DEFINE p_imm01       LIKE imm_file.imm01
DEFINE l_imm         RECORD LIKE imm_file.*

   SELECT * INTO l_imm.* FROM imm_file
    WHERE imm01 = p_imm01

   RETURN l_imm.*
END FUNCTION 
#DEV-D30046 --add--end

#DEV-D30046 --add

#DEV-D40013 --add
