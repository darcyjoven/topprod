/*
================================================================================
檔案代號:qct_file
檔案名稱:质量检验单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qct_file
(
qct01       varchar2(20) NOT NULL,   /*收货单号                               */
                                     /*收貨單號      (qcs01)                  */
qct02       number(5) NOT NULL,      /*收货项次                               */
                                     /*收貨項次      (qcs02)                  */
qct021      number(5) NOT NULL,      /*分批检验顺序                           */
                                     /*分批檢驗順序  (qcs05)                  */
qct03       number(5) NOT NULL,      /*行序                                   */
qct04       varchar2(40),            /*检验项目                               */
                                     /*檢驗項目                               */
qct05       varchar2(1),             /*缺点等级                               */
                                     /*缺點等級                               */
qct06       number(7,3),             /*AQL                                    */
qct07       number(15,3),            /*不良数量                               */
                                     /*不良數量                               */
qct08       varchar2(1),             /*判定结果                               */
                                     /*判定結果                               */
                                     /*1.合格    2.退貨   3.特採              */
qct09       number(5),               /*接受数量                               */
                                     /*Ac 數量                                */
qct10       number(5),               /*拒绝数量                               */
                                     /*Re 數量                                */
qct11       number(15,3),            /*检验量                                 */
                                     /*檢驗量                                 */
qct12       varchar2(1),             /*检验方式                               */
                                     /*檢驗方式  1.105D/E  2.C=0              */
qct131      number(15,3),            /*下限                                   */
qct132      number(15,3),            /*上限                                   */
qctud01     varchar2(255),           /*备注                                   */
qctud02     varchar2(40),            /*异常状况描述                           */
qctud03     varchar2(40),            /*自订字段-文字                          */
qctud04     varchar2(40),            /*ICP编号                                */
qctud05     varchar2(40),            /*特采单编号                             */
qctud06     varchar2(40),            /*厂内检验单号                           */
qctud07     number(15,3),            /*自订字段-数值                          */
qctud08     number(15,3),            /*自订字段-数值                          */
qctud09     number(15,3),            /*自订字段-数值                          */
qctud10     number(10),              /*自订字段-整数                          */
qctud11     number(10),              /*自订字段-整数                          */
qctud12     number(10),              /*自订字段-整数                          */
qctud13     date,                    /*回复时间                               */
qctud14     date,                    /*下次送测时间                           */
qctud15     date,                    /*自订字段-日期                          */
qctplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
qctlegal    varchar2(10) NOT NULL,   /*所属法人                               */
qct14       number(8,4),             /*K法标准值                              */
qct15       number(8,4)              /*F法标准值                              */
);

alter table qct_file add  constraint qct_pk primary key  (qct01,qct02,qct021,qct03) enable validate;
grant select on qct_file to tiptopgp;
grant update on qct_file to tiptopgp;
grant delete on qct_file to tiptopgp;
grant insert on qct_file to tiptopgp;
grant index on qct_file to public;
grant select on qct_file to ods;
