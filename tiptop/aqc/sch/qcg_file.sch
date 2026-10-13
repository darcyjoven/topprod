/*
================================================================================
檔案代號:qcg_file
檔案名稱:FQC 质量检验单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qcg_file
(
qcg01       varchar2(20) NOT NULL,   /*收货单号                               */
                                     /*收貨單號                               */
qcg03       number(5) NOT NULL,      /*行序                                   */
qcg04       varchar2(10),            /*检验项目                               */
                                     /*檢驗項目                               */
qcg05       varchar2(1),             /*缺点等级                               */
                                     /*缺點等級                               */
qcg06       number(7,3),             /*AQL                                    */
qcg07       number(15,3),            /*不良数量                               */
                                     /*不良數量                               */
qcg08       varchar2(1),             /*判定结果                               */
                                     /*判定結果                               */
                                     /*1.合格    2.重工                       */
qcg09       number(5),               /*接受数量                               */
                                     /*Ac 數量                                */
qcg10       number(5),               /*拒绝数量                               */
                                     /*Re 數量                                */
qcg11       number(15,3),            /*检验量                                 */
                                     /*檢驗量                                 */
qcg12       varchar2(1),             /*检验方式                               */
                                     /*檢驗方式  1.105D/E  2.C=0              */
qcg131      number(15,3),            /*下限                                   */
qcg132      number(15,3),            /*上限                                   */
qcgud01     varchar2(255),           /*自订字段-Textedit                      */
qcgud02     varchar2(40),            /*自订字段-文字                          */
qcgud03     varchar2(40),            /*自订字段-文字                          */
qcgud04     varchar2(40),            /*自订字段-文字                          */
qcgud05     varchar2(40),            /*自订字段-文字                          */
qcgud06     varchar2(40),            /*自订字段-文字                          */
qcgud07     number(15,3),            /*自订字段-数值                          */
qcgud08     number(15,3),            /*自订字段-数值                          */
qcgud09     number(15,3),            /*自订字段-数值                          */
qcgud10     number(10),              /*自订字段-整数                          */
qcgud11     number(10),              /*自订字段-整数                          */
qcgud12     number(10),              /*自订字段-整数                          */
qcgud13     date,                    /*自订字段-日期                          */
qcgud14     date,                    /*自订字段-日期                          */
qcgud15     date,                    /*自订字段-日期                          */
qcgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
qcglegal    varchar2(10) NOT NULL,   /*所属法人                               */
qcg14       number(8,4),             /*K法标准值                              */
qcg15       number(8,4)              /*F法标准值                              */
);

alter table qcg_file add  constraint qcg_pk primary key  (qcg01,qcg03) enable validate;
grant select on qcg_file to tiptopgp;
grant update on qcg_file to tiptopgp;
grant delete on qcg_file to tiptopgp;
grant insert on qcg_file to tiptopgp;
grant index on qcg_file to public;
grant select on qcg_file to ods;
