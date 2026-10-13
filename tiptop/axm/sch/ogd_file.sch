/*
================================================================================
檔案代號:ogd_file
檔案名稱:包装资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ogd_file
(
ogd01       varchar2(20) NOT NULL,   /*出货通知单号                           */
                                     /*出貨通知單號                           */
ogd03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
ogd04       number(5) NOT NULL,      /*序号　　　　　　　　　                 */
                                     /*序號 (1.整箱 234.. 併箱)               */
ogd08       varchar2(20),            /*包装方式编号                           */
                                     /*包裝方式編號                           */
ogd09       number(10),              /*每箱装数                               */
                                     /*每箱裝數                               */
ogd10       number(5),               /*箱数                                   */
                                     /*箱數                                   */
ogd11       varchar2(1),             /*包装箱号字首                           */
                                     /*包裝箱號字軌 (default='0')             */
ogd12b      number(10),              /*起始包装箱号                           */
                                     /*起始包裝箱號                           */
ogd12e      number(10),              /*截止包装箱号                           */
                                     /*截止包裝箱號                           */
ogd13       number(15,3),            /*产品数量                               */
                                     /*產品數量                               */
ogd14       number(15,3),            /*单位净重(Kg)                           */
                                     /*單位淨重(Kg)                           */
ogd15       number(15,3),            /*单位毛重(Kg)                           */
                                     /*單位毛重(Kg)                           */
ogd16       number(15,3),            /*单位材积(Cuft)                         */
                                     /*單位材積(Cuft)                         */
ogd14t      number(15,3),            /*总净重(Kg)                             */
                                     /*總淨重(Kg)                             */
ogd15t      number(15,3),            /*总毛重(Kg)                             */
                                     /*總毛重(Kg)                             */
ogd16t      number(15,3),            /*总材积(Cuft)                           */
                                     /*總材積(Cuft)                           */
ogd17       varchar2(1),             /*包装类型                               */
ogdud01     varchar2(255),           /*自订字段-Textedit                      */
ogdud02     varchar2(40),            /*自订字段-文字                          */
ogdud03     varchar2(40),            /*自订字段-文字                          */
ogdud04     varchar2(40),            /*自订字段-文字                          */
ogdud05     varchar2(40),            /*自订字段-文字                          */
ogdud06     varchar2(40),            /*自订字段-文字                          */
ogdud07     number(15,3),            /*自订字段-数值                          */
ogdud08     number(15,3),            /*自订字段-数值                          */
ogdud09     number(15,3),            /*自订字段-数值                          */
ogdud10     number(10),              /*尾箱数                                 */
ogdud11     number(10),              /*自订字段-整数                          */
ogdud12     number(10),              /*自订字段-整数                          */
ogdud13     date,                    /*自订字段-日期                          */
ogdud14     date,                    /*自订字段-日期                          */
ogdud15     date,                    /*自订字段-日期                          */
ogdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ogdlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ogd_file add  constraint ogd_pk primary key  (ogd01,ogd03,ogd04) enable validate;
grant select on ogd_file to tiptopgp;
grant update on ogd_file to tiptopgp;
grant delete on ogd_file to tiptopgp;
grant insert on ogd_file to tiptopgp;
grant index on ogd_file to public;
grant select on ogd_file to ods;
