/*
================================================================================
檔案代號:qcn_file
檔案名稱:PQC 质量检验单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qcn_file
(
qcn01       varchar2(20) NOT NULL,   /*收货单号                               */
                                     /*收貨單號                               */
qcn03       number(5) NOT NULL,      /*行序                                   */
qcn04       varchar2(10),            /*检验项目                               */
                                     /*檢驗項目                               */
qcn05       varchar2(1),             /*缺点等级                               */
                                     /*缺點等級                               */
qcn06       number(7,3),             /*AQL                                    */
qcn07       number(15,3),            /*不良数量                               */
                                     /*不良數量                               */
qcn08       varchar2(1),             /*判定结果                               */
                                     /*判定結果                               */
                                     /*1.合格    2.重工                       */
qcn09       number(5),               /*接受数量                               */
                                     /*Ac 數量                                */
qcn10       number(5),               /*拒绝数量                               */
                                     /*Re 數量                                */
qcn11       number(15,3),            /*检验量                                 */
                                     /*檢驗量                                 */
qcn12       varchar2(1),             /*检验方式                               */
                                     /*檢驗方式  1.105D/E  2.C=0              */
qcn131      number(15,3),            /*下限                                   */
qcn132      number(15,3),            /*上限                                   */
qcnud01     varchar2(255),           /*自订字段-Textedit                      */
qcnud02     varchar2(40),            /*自订字段-文字                          */
qcnud03     varchar2(40),            /*自订字段-文字                          */
qcnud04     varchar2(40),            /*自订字段-文字                          */
qcnud05     varchar2(40),            /*自订字段-文字                          */
qcnud06     varchar2(40),            /*自订字段-文字                          */
qcnud07     number(15,3),            /*自订字段-数值                          */
qcnud08     number(15,3),            /*自订字段-数值                          */
qcnud09     number(15,3),            /*自订字段-数值                          */
qcnud10     number(10),              /*自订字段-整数                          */
qcnud11     number(10),              /*自订字段-整数                          */
qcnud12     number(10),              /*自订字段-整数                          */
qcnud13     date,                    /*自订字段-日期                          */
qcnud14     date,                    /*自订字段-日期                          */
qcnud15     date,                    /*自订字段-日期                          */
qcnplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
qcnlegal    varchar2(10) NOT NULL,   /*所属法人                               */
qcn14       number(8,4),             /*K法标准值                              */
qcn15       number(8,4)              /*F法标准值                              */
);

alter table qcn_file add  constraint qcn_pk primary key  (qcn01,qcn03) enable validate;
grant select on qcn_file to tiptopgp;
grant update on qcn_file to tiptopgp;
grant delete on qcn_file to tiptopgp;
grant insert on qcn_file to tiptopgp;
grant index on qcn_file to public;
grant select on qcn_file to ods;
