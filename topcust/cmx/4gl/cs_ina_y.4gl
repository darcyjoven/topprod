# Prog. Version..: '5.00.01-07.05.10(00010)'     #
# Pattern name...: cs_ina_y.4gl
# Descriptions...: 杂收发
# Date & Author..: 16/01/01  By  LGe
# Note           : 传入值:  
# ...............: 返回值:  Y-成功; N-失败
#                           code: 0 成功    其他为错误代码
#                           msg:  错误信息  成功

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

DEFINE l_ina            RECORD LIKE ina_file.*
DEFINE g_sql            STRING

FUNCTION cs_ina_y(p_ina01,p_user)
DEFINE l_ret            RECORD 
             success    LIKE type_file.chr1,
             code       LIKE type_file.chr10,
             msg        STRING
                        END RECORD
DEFINE p_ina01          LIKE ina_file.ina01
DEFINE p_user           LIKE gen_file.gen01
DEFINE l_user           LIKE gen_file.gen01
DEFINE l_grup           LIKE gem_file.gem01

    INITIALIZE l_ret TO NULL 
    LET l_ret.success = 'Y'
  
    IF cl_null(p_ina01) THEN 
        LET l_ret.success = 'N'
        LET l_ret.msg = "无单号！"
        RETURN l_ret.*
    END IF  
   
    INITIALIZE l_ina TO NULL 

    SELECT * INTO l_ina.* FROM ina_file
     WHERE ina01 = p_ina01
    IF SQLCA.SQLCODE THEN 
        LET l_ret.success = 'N'
        LET l_ret.code = SQLCA.SQLCODE
        LET l_ret.msg = "sel ina error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
        RETURN l_ret.*
    END IF 

    IF cl_null(p_user) THEN 
        LET l_user = l_ina.inauser
        LET l_grup = l_ina.inagrup
    ELSE
        LET l_user = p_user
        SELECT gen03 INTO l_grup FROM gen_file 
         WHERE gen01 = l_user
    END IF 

    IF l_ina.inaconf = 'N' THEN 
        LET l_ina.inaconf = 'Y'
        UPDATE ina_file SET inaconf = 'Y',
                            ina08   = '1',
                            inacont = g_time,
                            inaconu = l_user,
                            inacond = g_today
         WHERE ina01 = l_ina.ina01
        IF SQLCA.SQLCODE THEN 
            LET l_ret.success = 'N'
            LET l_ret.code = SQLCA.SQLCODE
            LET l_ret.msg  = "upd ina error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
            RETURN l_ret.*
        END IF 
    END IF 

    IF l_ina.inaconf = 'Y' AND l_ina.inapost = 'N' THEN 
        LET g_success = 'Y'
        CALL cs_ina_post(l_ina.ina00,l_ina.ina01,l_ina.ina03,l_ina.ina07,l_ina.ina04,l_ina.ina06,l_ina.ina00)
        IF g_success = 'N' THEN 
            LET l_ret.success = 'N'
        END IF 
        IF l_ret.success = 'N' THEN 
            RETURN l_ret.*
        ELSE
            UPDATE ina_file SET inapost = 'Y'
             WHERE ina01 = l_ina.ina01
            IF SQLCA.SQLCODE THEN 
                LET l_ret.success = 'N'
                LET l_ret.code = SQLCA.SQLCODE
                LET l_ret.msg = "upd ina post error:",cl_getmsg(SQLCA.SQLCODE,g_lang)
                RETURN l_ret.*
            END IF 
        END IF 
    END IF 

    RETURN l_ret.*
END FUNCTION 


FUNCTION p001_img_lock_cl()

  LET g_sql =
      "SELECT img10,img16,img23,img24,img09,img21 FROM img_file ",
      " WHERE img01= ? AND img02= ? AND img03= ? AND img04= ?  FOR UPDATE "

  LET g_sql = cl_forupd_sql(g_sql)
  DECLARE img_lock CURSOR FROM g_sql
END FUNCTION

FUNCTION p001_ima_lock_cl()
  LET g_sql =
      "SELECT ima25 FROM ima_file WHERE ima01= ? FOR UPDATE " 

  LET g_sql = cl_forupd_sql(g_sql)
  DECLARE ima_lock CURSOR FROM g_sql
END FUNCTION

FUNCTION cs_ina_post(p_ina00,p_ina01,p_ina03,p_ina07,p_ina04,p_ina06,p_argv1)
DEFINE p_ina01  LIKE ina_file.ina01 
DEFINE l_inb    RECORD LIKE inb_file.*
DEFINE p_ina00  LIKE ina_file.ina00
DEFINE p_ina03  LIKE ina_file.ina03
DEFINE p_ina07  LIKE ina_file.ina07
DEFINE p_ina04  LIKE ina_file.ina04
DEFINE p_ina06  LIKE ina_file.ina06
DEFINE p_argv1  LIKE ina_file.ina00
DEFINE l_ima918	LIKE ima_file.ima918,
			 l_ima921	LIKE ima_file.ima921,
			 l_cnt		LIKE type_file.num5,
			 l_flag		LIKE type_file.num5


  INITIALIZE l_ina TO NULL 
  SELECT * INTO l_ina.* FROM ina_file 
   WHERE ina01 = p_ina01 

  DECLARE p001_ina_s1_c CURSOR FOR SELECT * FROM inb_file
                                WHERE inb01=p_ina01

  FOREACH p001_ina_s1_c INTO l_inb.*
    IF STATUS THEN
      EXIT FOREACH
    END IF

    IF cl_null(l_inb.inb04) THEN
       CONTINUE FOREACH
    END IF

    LET l_cnt = 0
    SELECT COUNT(*) INTO l_cnt
      FROM img_file
     WHERE img01 = l_inb.inb04
       AND img02 = l_inb.inb05
       AND img03 = l_inb.inb06
       AND img04 = l_inb.inb07
     IF l_cnt = 0 THEN
       CALL s_padd_img_data1(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,l_ina.ina01,l_inb.inb03,l_ina.ina02) #FUN-CC0095
     END IF

#     CALL s_chk_imgg(l_inb.inb04,l_inb.inb05,
#                     l_inb.inb06,l_inb.inb07,
#                     l_inb.inb902) RETURNING l_flag
#     IF l_flag = 1 THEN
#       CALL s_padd_imgg_data1(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,l_inb.inb902,l_ina.ina01,l_inb.inb03) #FUN-CC0095
#     END IF 
     CALL s_chk_imgg(l_inb.inb04,l_inb.inb05,
                     l_inb.inb06,l_inb.inb07,
                     l_inb.inb905) RETURNING l_flag
     IF l_flag = 1 THEN
       CALL s_padd_imgg_data1(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,l_inb.inb905,l_ina.ina01,l_inb.inb03) #FUN-CC0095
     END IF 

    #IF g_argv1 = '3' THEN 
    #IF l_ina.ina00 = '3' THEN
    # SELECT ima918,ima921 INTO l_ima918,l_ima921
    #   FROM ima_file
    #  WHERE ima01 = l_inb.inb04
    #    AND imaacti = 'Y'
    # IF g_success = 'Y' AND (l_ima918 = 'Y' OR l_ima921 = 'Y') THEN
    #   DECLARE p001_rvbs_inb_cl CURSOR FOR SELECT * FROM tc_zmb_file 
    #   WHERE tc_zmb04 = '3' AND tc_zmb18 = 0 AND tc_zmb05 = l_inb.inb01 AND tc_zmb06 = l_inb.inb03
    #   FOREACH p001_rvbs_inb_cl INTO l_tc_zmb.*
    #   	IF STATUS THEN EXIT FOREACH END IF
    #     LET l_rvbs.rvbs00 = 'aimt302'
    #     LET l_rvbs.rvbs01 = l_inb.inb01
    #     LET l_rvbs.rvbs02 = l_inb.inb03
    #     LET l_rvbs.rvbs03 = l_tc_zmb.tc_zmb15
    #     LET l_rvbs.rvbs04 = ' '
    #     LET l_rvbs.rvbs05 = l_tc_zmb.tc_zmb01
    #     LET l_rvbs.rvbs06 = l_tc_zmb.tc_zmb10
    #     LET l_rvbs.rvbs08 = ' '
    #     LET l_rvbs.rvbs021 = l_inb.inb04
    #     SELECT nvl(MAX(rvbs022),0) + 1 INTO l_rvbs.rvbs022
    #       FROM rvbs_file 
    #       WHERE rvbs00 = 'aimt302' AND rvbs01 = l_inb.inb01 AND rvbs02 = l_inb.inb03
    #       LET l_rvbs.rvbs09 = 1
    #       LET l_rvbs.rvbs10 = 0
    #       LET l_rvbs.rvbs11 = 0
    #       LET l_rvbs.rvbs12 = 0
    #       LET l_rvbs.rvbs13 = 0
    #     LET l_rvbs.rvbsplant = g_plant 
    #     LET l_rvbs.rvbslegal = g_legal 
    #     INSERT INTO rvbs_file VALUES (l_rvbs.*)
    #     IF SQLCA.sqlcode THEN
    #       LET g_success = 'N' 
    #       ROLLBACK WORK
    #       RETURN
    #     END IF
    #   END FOREACH 
    # END IF 
    #END IF 
    
    IF p_argv1 MATCHES '[1256]' THEN
      IF NOT s_stkminus(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                        l_inb.inb09,l_inb.inb08_fac,p_ina03) THEN 
        LET g_success="N" 
        EXIT FOREACH    
      END IF
    END IF

    IF g_sma.sma115 = 'Y' THEN
      CALL p001_ina_update_du(p_ina00,p_ina07,p_ina04,p_ina06,l_inb.*)
    END IF

    IF p_argv1 MATCHES '[12]' THEN
      CALL s_updsie_sie(l_inb.inb01,l_inb.inb03,'3')
    END IF

    IF g_success='N' THEN
      EXIT FOREACH
    END IF

    CALL p001_ina_update(l_inb.inb05,l_inb.inb06,l_inb.inb07,
                     l_inb.inb09,l_inb.inb08,l_inb.inb08_fac,
                     p_ina00,p_ina07,p_ina04,l_inb.inb01,l_inb.inb03,l_inb.inb04,l_inb.inb08)

    IF g_success='N' THEN
      EXIT FOREACH
    END IF
  END FOREACH

END FUNCTION

FUNCTION p001_ina_update_du(p_ina00,p_ina07,p_ina04,p_ina06,l_inb)
DEFINE l_ima25   LIKE ima_file.ima25,
       u_type    LIKE type_file.num5,
       p_ina00   LIKE ina_file.ina00,
       p_ina07   LIKE ina_file.ina07,
       p_ina04   LIKE ina_file.ina04,
       p_ina06   LIKE ina_file.ina06,
       l_inb     RECORD LIKE inb_file.*
DEFINE l_ima906  LIKE ima_file.ima906
 
  SELECT ima906,ima25 INTO l_ima906,l_ima25 FROM ima_file
   WHERE ima01 = l_inb.inb04
  IF SQLCA.sqlcode THEN
    LET g_success='N'
    RETURN
  END IF
  IF l_ima906 = '1' OR l_ima906 IS NULL THEN
     RETURN
  END IF

  CASE WHEN p_ina00 MATCHES "[12]" LET u_type=-1
      WHEN p_ina00 MATCHES "[34]" LET u_type=+1
      WHEN p_ina00 MATCHES "[56]" LET u_type=0
  END CASE

#  IF l_ima906 = '2' THEN  #子母單位
#    LET g_unit_arr[1].unit=l_inb.inb902
#    LET g_unit_arr[1].fac =l_inb.inb903
#    LET g_unit_arr[1].qty =l_inb.inb904
#    LET g_unit_arr[2].unit=l_inb.inb905
#    LET g_unit_arr[2].fac =l_inb.inb906
#    LET g_unit_arr[2].qty =l_inb.inb907
#    IF NOT cl_null(l_inb.inb905) THEN
#      CALL p001_ina_upd_imgg('1',l_inb.inb04,l_inb.inb05,l_inb.inb06,
#                      l_inb.inb07,l_inb.inb905,l_inb.inb906,l_inb.inb907,u_type,'2',l_inb.inb01,l_inb.inb03)
#      IF g_success='N' THEN
#        RETURN
#      END IF
#      IF NOT cl_null(l_inb.inb907) THEN    
#        CALL p001_ina_tlff(l_inb.inb05,l_inb.inb06,l_inb.inb07,l_ima25,
#                       l_inb.inb907,0,l_inb.inb905,l_inb.inb906,u_type,'2',l_inb.*,p_ina00,p_ina07,p_ina04,p_ina06)
#        IF g_success='N' THEN
#          RETURN
#        END IF
#      END IF
#    END IF
#    IF NOT cl_null(l_inb.inb902) THEN
#      CALL p001_ina_upd_imgg('1',l_inb.inb04,l_inb.inb05,l_inb.inb06,
#                         l_inb.inb07,l_inb.inb902,l_inb.inb903,l_inb.inb904,u_type,'1',l_inb.inb01,l_inb.inb03)
#      IF g_success='N' THEN
#        RETURN
#      END IF
#      IF NOT cl_null(l_inb.inb904) THEN                      
#        CALL p001_ina_tlff(l_inb.inb05,l_inb.inb06,l_inb.inb07,l_ima25,
#                       l_inb.inb904,0,l_inb.inb902,l_inb.inb903,u_type,'1',l_inb.*,p_ina00,p_ina07,p_ina04,p_ina06)
#        IF g_success='N' THEN
#          RETURN
#        END IF
#      END IF
#    END IF
#  END IF
  IF l_ima906 = '3' THEN  #參考單位
    IF NOT cl_null(l_inb.inb905) THEN
      CALL p001_ina_upd_imgg('2',l_inb.inb04,l_inb.inb05,l_inb.inb06,
                         l_inb.inb07,l_inb.inb905,l_inb.inb906,l_inb.inb907,u_type,'2',l_inb.inb01,l_inb.inb03)
      IF g_success = 'N' THEN
        RETURN
      END IF
      IF NOT cl_null(l_inb.inb907) THEN                                    #CHI-860005
        CALL p001_ina_tlff(l_inb.inb05,l_inb.inb06,l_inb.inb07,l_ima25,
                       l_inb.inb907,0,l_inb.inb905,l_inb.inb906,u_type,'2',l_inb.*,p_ina00,p_ina07,p_ina04,p_ina06)
        IF g_success='N' THEN
          RETURN
        END IF
      END IF
    END IF
  END IF
 
END FUNCTION

FUNCTION p001_imgg_lock_cl2()
 LET g_sql =
     "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
     "   WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
     "   AND imgg09= ? FOR UPDATE "

 LET g_sql = cl_forupd_sql(g_sql)
 DECLARE imgg_lock CURSOR FROM g_sql

END FUNCTION


FUNCTION p001_ina_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_imgg211,p_imgg10,p_type,p_no,p_ina01,p_inb03)
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
      p_no       LIKE type_file.chr1,   
      p_type     LIKE type_file.num10,
      l_cnt      LIKE type_file.num10,
      p_ina01    LIKE ina_file.ina01,
      p_inb03    LIKE inb_file.inb03,
      g_forupd_sql STRING 

 CALL p001_imgg_lock_cl2()
 OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
 IF STATUS THEN
   LET g_success='N'
   CLOSE imgg_lock
   RETURN
 END IF
 FETCH imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
 IF STATUS THEN
   LET g_success='N'
   CLOSE imgg_lock
   RETURN
 END IF

 SELECT ima25,ima906 INTO l_ima25,l_ima906
   FROM ima_file WHERE ima01=p_imgg01
 IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
   LET g_success = 'N'
   RETURN
 END IF

 CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
       RETURNING l_cnt,l_imgg21
 IF l_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
   LET g_success = 'N'
   RETURN
 END IF

 CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,l_ina.ina02, 
       p_imgg01,p_imgg02,p_imgg03,p_imgg04,'',p_ina01,p_inb03,'',p_imgg09,'',l_imgg21,'','','','','','','',p_imgg211)
 IF g_success='N' THEN
   RETURN
 END IF
 
END FUNCTION
 
FUNCTION p001_ina_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,u_type,p_flag,l_inb,p_ina00,p_ina07,p_ina04,p_ina06)
DEFINE
    p_ware     LIKE img_file.img02,       ##倉庫
    p_loca     LIKE img_file.img03,       ##儲位
    p_lot      LIKE img_file.img04,       ##批號
    p_unit     LIKE img_file.img09,
    p_qty      LIKE img_file.img10,       ##數量  
    p_img10    LIKE img_file.img10,       ##異動後數量
    p_uom      LIKE img_file.img09,       ##img 單位
    p_factor   LIKE img_file.img21,       ##轉換率
    l_imgg10   LIKE imgg_file.imgg10,
    u_type     LIKE type_file.num5,       ##+1:雜收 -1:雜發  0:報廢  
    p_flag     LIKE type_file.chr1
DEFINE l_inb   RECORD LIKE inb_file.*
DEFINE p_ina00 LIKE ina_file.ina00
DEFINE p_ina07 LIKE ina_file.ina07
DEFINE p_ina04 LIKE ina_file.ina04
DEFINE p_ina06 LIKE ina_file.ina06

  IF cl_null(p_ware) THEN LET p_ware=' ' END IF
  IF cl_null(p_loca) THEN LET p_loca=' ' END IF
  IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
  IF cl_null(p_qty)  THEN LET p_qty=0    END IF

  IF p_uom IS NULL THEN
    LET g_success = 'N'
    RETURN
  END IF

  SELECT imgg10 INTO l_imgg10 FROM imgg_file
   WHERE imgg01=l_inb.inb04 AND imgg02=p_ware
     AND imgg03=p_loca      AND imgg04=p_lot
     AND imgg09=p_uom
  IF cl_null(l_imgg10) THEN
    LET l_imgg10 = 0
  END IF

  INITIALIZE g_tlff.* TO NULL
  LET g_tlff.tlff01=l_inb.inb04         #異動料件編號
  IF p_ina00 MATCHES "[34]" THEN
    #----來源----
    LET g_tlff.tlff02=90
    LET g_tlff.tlff026=l_inb.inb11        #來源單號
    #---目的----
    LET g_tlff.tlff03=50                  #'Stock'
    LET g_tlff.tlff030=g_plant
    LET g_tlff.tlff031=p_ware             #倉庫
    LET g_tlff.tlff032=p_loca             #儲位
    LET g_tlff.tlff033=p_lot              #批號
    #**該數量錯誤*****
    LET g_tlff.tlff034=l_imgg10           #異動後數量
    LET g_tlff.tlff035=p_unit             #庫存單位(ima_file or img_file)
    LET g_tlff.tlff036=l_inb.inb01        #雜收單號
    LET g_tlff.tlff037=l_inb.inb03        #雜收項次
  END IF
  IF p_ina00 MATCHES "[1256]" THEN
    #----來源----
    LET g_tlff.tlff02=50                  #'Stock'
    LET g_tlff.tlff020=g_plant
    LET g_tlff.tlff021=p_ware             #倉庫
    LET g_tlff.tlff022=p_loca             #儲位
    LET g_tlff.tlff023=p_lot              #批號
    LET g_tlff.tlff024=l_imgg10           #異動後數量
    LET g_tlff.tlff025=p_unit             #庫存單位(ima_file or img_file)
    LET g_tlff.tlff026=l_inb.inb01        #雜發/報廢單號
    LET g_tlff.tlff027=l_inb.inb03        #雜發/報廢項次
    #---目的----
    IF p_ina00 MATCHES "[12]"
       THEN LET g_tlff.tlff03=90
       ELSE LET g_tlff.tlff03=40
    END IF
    LET g_tlff.tlff036=l_inb.inb11        #目的單號
  END IF
  LET g_tlff.tlff04= ' '             #工作站
  LET g_tlff.tlff05= ' '             #作業序號
  LET g_tlff.tlff06=l_ina.ina02      #發料日期
  LET g_tlff.tlff07=g_today          #異動資料產生日期
  LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
  LET g_tlff.tlff09=g_user           #產生人
  LET g_tlff.tlff10=p_qty            #異動數量
  LET g_tlff.tlff11=p_uom	       #發料單位
  LET g_tlff.tlff12=p_factor         #發料/庫存 換算率
  CASE WHEN p_ina00 = '1' LET g_tlff.tlff13='aimt301'
       WHEN p_ina00 = '2' LET g_tlff.tlff13='aimt311'
       WHEN p_ina00 = '3' LET g_tlff.tlff13='aimt302'
       WHEN p_ina00 = '4' LET g_tlff.tlff13='aimt312'
       WHEN p_ina00 = '5' LET g_tlff.tlff13='aimt303'
       WHEN p_ina00 = '6' LET g_tlff.tlff13='aimt313'
  END CASE
  LET g_tlff.tlff14=l_inb.inb15              #異動原因
  LET g_tlff.tlff17=p_ina07              #Remark
  LET g_tlff.tlff19=p_ina04
  LET g_tlff.tlff20=p_ina06              #Project code

  LET g_tlff.tlff62=l_inb.inb12    #參考單號
  LET g_tlff.tlff64=l_inb.inb901   #手冊編號  no.A050
  LET g_tlff.tlff930=l_inb.inb930 
  IF cl_null(l_inb.inb907) OR l_inb.inb907=0 THEN
    CALL s_tlff(p_flag,NULL)
  ELSE
    CALL s_tlff(p_flag,l_inb.inb905)
  END IF
END FUNCTION

FUNCTION p001_ina_update(p_ware,p_loca,p_lot,p_qty,p_uom,p_factor,p_ina00,p_ina07,p_ina04,p_inb01,p_inb03,p_inb04,p_inb08)
DEFINE p_ware     LIKE img_file.img02,       #倉庫
       p_loca     LIKE img_file.img03,       #儲位
       p_lot      LIKE img_file.img04,       #批號
       p_qty      LIKE tlf_file.tlf10,       #數量
       p_uom      LIKE img_file.img09,       ##img 單位
       p_factor   LIKE ima_file.ima31_fac,   #轉換率  
       u_type     LIKE type_file.num5,       # +1:雜收 -1:雜發  0:報廢 
       l_qty      LIKE img_file.img10,  
       l_ima01    LIKE ima_file.ima01,
       l_ima25    LIKE ima_file.ima25,
       l_imaqty   LIKE type_file.num15_3,
       l_imafac   LIKE img_file.img21,
       l_img      RECORD
       img10      LIKE img_file.img10,
       img16      LIKE img_file.img16,
       img23      LIKE img_file.img23,
       img24      LIKE img_file.img24,
       img09      LIKE img_file.img09,
       img21      LIKE img_file.img21
                  END RECORD,
       l_cnt     LIKE type_file.num5   
DEFINE p_inb01   LIKE inb_file.inb01
DEFINE p_inb03   LIKE inb_file.inb03
DEFINE p_inb04   LIKE inb_file.inb04
DEFINE p_inb08   LIKE inb_file.inb08
DEFINE p_ina00   LIKE ina_file.ina00
DEFINE p_ina07   LIKE ina_file.ina07
DEFINE p_ina04   LIKE ina_file.ina04
DEFINE l_msg,g_forupd_sql     STRING        

  IF cl_null(p_ware) THEN LET p_ware=' ' END IF
  IF cl_null(p_loca) THEN LET p_loca=' ' END IF
  IF cl_null(p_lot)  THEN LET p_lot =' ' END IF
  IF cl_null(p_qty)  THEN LET p_qty =0   END IF

  IF p_uom IS NULL THEN
    LET g_success = 'N'
    RETURN
  END IF

  CALL p001_img_lock_cl()

  OPEN img_lock USING p_inb04,p_ware,p_loca,p_lot
  IF STATUS THEN
    LET g_success='N'
    CLOSE img_lock
    RETURN
  END IF
  FETCH img_lock INTO l_img.*
  IF STATUS THEN
    LET g_success='N'
    CLOSE img_lock
    RETURN
  END IF
  IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF

  CASE WHEN p_ina00 MATCHES "[12]" LET u_type=-1
            LET l_qty= l_img.img10 - p_qty*p_factor 
       WHEN p_ina00 MATCHES "[34]" LET u_type=+1
            LET l_qty= l_img.img10 + p_qty*p_factor  
       WHEN p_ina00 MATCHES "[56]" LET u_type=0
            LET l_qty= l_img.img10 - p_qty*p_factor  
  END CASE
  CALL s_upimg(p_inb04,p_ware,p_loca,p_lot,u_type,p_qty*p_factor,l_ina.ina02,
        '','','','',p_inb01,p_inb03,  
        '','','','','','','','','','','','')
  IF g_success='N' THEN
    RETURN
  END IF

  CALL p001_ima_lock_cl()
  OPEN ima_lock USING p_inb04
  IF STATUS THEN
    LET g_success = 'N'
    CLOSE ima_lock
    RETURN
  END IF

  FETCH ima_lock INTO l_ima25 
  IF STATUS THEN
    LET g_success = 'N'
    CLOSE ima_lock
    RETURN
  END IF

  IF p_inb08=l_ima25 THEN
    LET l_imafac = 1
  ELSE
    CALL s_umfchk(p_inb04,p_inb08,l_ima25)
             RETURNING l_cnt,l_imafac
    IF l_cnt = 1 THEN
      LET g_success ='N'
    END IF
  END IF

  IF cl_null(l_imafac) THEN
    LET l_imafac = 1
  END IF
  LET l_imaqty = p_qty * l_imafac
  CALL s_udima(p_inb04,l_img.img23,l_img.img24,l_imaqty,
                  l_ina.ina02,u_type)  RETURNING l_cnt
  IF g_success='N' THEN
    RETURN
  END IF

  IF g_success='Y' THEN
    CALL p001_ina_tlf(p_ware,p_loca,p_lot,l_ima25,p_qty,l_qty,p_uom,p_factor,
                  u_type,p_inb01,p_inb03,p_ina00,p_ina07,p_ina04)
  END IF
END FUNCTION

FUNCTION p001_ina_tlf(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,u_type,p_inb01,p_inb03,p_ina00,p_ina07,p_ina04)
DEFINE
  p_ware   LIKE img_file.img02,       #倉庫     
  p_loca   LIKE img_file.img03,       #儲位   
  p_lot    LIKE img_file.img04,       #批號   
  p_qty    LIKE tlf_file.tlf10,       
  p_uom    LIKE img_file.img09,       ##img 單位
  p_factor LIKE ima_file.ima31_fac,   ##轉換率 
  p_unit   LIKE ima_file.ima25,       ##單位
  p_img10  LIKE img_file.img10,       #異動後數量
  u_type   LIKE type_file.num5,  	    # +1:雜收 -1:雜發  0:報廢 
  l_sfb02  LIKE sfb_file.sfb02,
  l_sfb03  LIKE sfb_file.sfb03,
  l_sfb04  LIKE sfb_file.sfb04,
  l_sfb22  LIKE sfb_file.sfb22,
  l_sfb27  LIKE sfb_file.sfb27,
  l_sta    LIKE type_file.num5,   
  p_inb01  LIKE inb_file.inb01,
  p_inb03  LIKE inb_file.inb03,
  p_ina00  LIKE ina_file.ina00,
  p_ina07  LIKE ina_file.ina07,
  p_ina04  LIKE ina_file.ina04 
DEFINE l_inb   RECORD LIKE inb_file.*   

 SELECT * INTO l_inb.* FROM inb_file WHERE inb01=p_inb01 AND inb03=p_inb03
 INITIALIZE g_tlf.* TO NULL
 LET g_tlf.tlf01=l_inb.inb04         #異動料件編號
 IF p_ina00 MATCHES "[34]" THEN
   #----來源----
   LET g_tlf.tlf02=90
   LET g_tlf.tlf026=l_inb.inb11        #來源單號
   #---目的----
   LET g_tlf.tlf03=50                  #'Stock'
   LET g_tlf.tlf030=g_plant
   LET g_tlf.tlf031=p_ware             #倉庫
   LET g_tlf.tlf032=p_loca             #儲位
   LET g_tlf.tlf033=p_lot              #批號
   LET g_tlf.tlf034=p_img10            #異動後數量
   LET g_tlf.tlf035=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlf.tlf036=l_inb.inb01        #雜收單號
   LET g_tlf.tlf037=l_inb.inb03        #雜收項次
 END IF
 IF p_ina00 MATCHES "[1256]" THEN
   #----來源----
   LET g_tlf.tlf02=50                  #'Stock'
   LET g_tlf.tlf020=g_plant
   LET g_tlf.tlf021=p_ware             #倉庫
   LET g_tlf.tlf022=p_loca             #儲位
   LET g_tlf.tlf023=p_lot              #批號
   LET g_tlf.tlf024=p_img10            #異動後數量
   LET g_tlf.tlf025=p_unit             #庫存單位(ima_file or img_file)
   LET g_tlf.tlf026=l_inb.inb01        #雜發/報廢單號
   LET g_tlf.tlf027=l_inb.inb03        #雜發/報廢項次
   #---目的----
   IF p_ina00 MATCHES "[12]"
      THEN LET g_tlf.tlf03=90
      ELSE LET g_tlf.tlf03=40
   END IF
   LET g_tlf.tlf036=l_inb.inb11        #目的單號
 END IF
 LET g_tlf.tlf04= ' '             #工作站
 LET g_tlf.tlf05= ' '             #作業序號
 LET g_tlf.tlf06=l_ina.ina02          #發料日期
 LET g_tlf.tlf07=g_today          #異動資料產生日期
 LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
 LET g_tlf.tlf09=g_user           #產生人
 LET g_tlf.tlf10=p_qty            #異動數量
 LET g_tlf.tlf11=p_uom	          #發料單位
 LET g_tlf.tlf12 =p_factor        #發料/庫存 換算率
CASE WHEN p_ina00 = '1' LET g_tlf.tlf13='aimt301'
     WHEN p_ina00 = '2' LET g_tlf.tlf13='aimt311'
     WHEN p_ina00 = '3' LET g_tlf.tlf13='aimt302'
     WHEN p_ina00 = '4' LET g_tlf.tlf13='aimt312'
     WHEN p_ina00 = '5' LET g_tlf.tlf13='aimt303'
     WHEN p_ina00 = '6' LET g_tlf.tlf13='aimt313'
END CASE
 LET g_tlf.tlf14=l_inb.inb15          #異動原因
 LET g_tlf.tlf17=p_ina07              #Remark
 LET g_tlf.tlf19=p_ina04
 LET g_tlf.tlf20=l_inb.inb41
 LET g_tlf.tlf41=l_inb.inb42
 LET g_tlf.tlf42=l_inb.inb43
 LET g_tlf.tlf43=l_inb.inb15

 LET g_tlf.tlf62=l_inb.inb12    #參考單號
 LET g_tlf.tlf64=l_inb.inb901   #手冊編號  no.A050
 LET g_tlf.tlf930=l_inb.inb930
 CALL s_tlf(1,0)
END FUNCTION



