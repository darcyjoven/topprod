/*
================================================================================
檔案代號:qdb_file
檔案名稱:Xbar-R控制数据单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qdb_file
(
qdb00       varchar2(1),             /*资料来源                               */
                                     /*資料來源 1:IQC 2:FQC 3:PQC             */
qdb01       varchar2(20) NOT NULL,   /*QC 单号                                */
                                     /*QC 單號                                */
qdb011      number(5) NOT NULL,      /*QC 项次                                */
                                     /*QC 項次  (For IQC)                     */
qdb012      number(5) NOT NULL,      /*QC 分批检验项次                        */
                                     /*QC 分批檢驗項次 (For IQC)              */
qdb013      number(5) NOT NULL,      /*QC 单身项次                            */
                                     /*QC 單身項次                            */
qdb02       varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
qdb03       number(10),              /*样本数                                 */
                                     /*樣本數                                 */
qdb04       number(10),              /*组数                                   */
                                     /*組數                                   */
qdb05       number(15,3),            /*Xbar 合计                              */
                                     /*Xbar 合計                              */
qdb06       number(15,3),            /*R 合计                                 */
                                     /*R 合計                                 */
qdb07       number(15,3),            /*Xbar-CL                                */
qdb071      number(15,3),            /*Xbar-UCL                               */
qdb072      number(15,3),            /*Xbar-LCL                               */
qdb08       number(15,3),            /*R-CL                                   */
qdb081      number(15,3),            /*R-UCL                                  */
qdb082      number(15,3),            /*R-LCL                                  */
qdb09       varchar2(10),            /*检验项目                               */
                                     /*檢驗項目                               */
qdb10       varchar2(1),             /*No Use                                 */
qdbconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N/X)                          */
qdbacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
qdbuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
qdbgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
qdbmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
qdbdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
qdbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
qdblegal    varchar2(10) NOT NULL,   /*所属法人                               */
qdboriu     varchar2(10),            /*资料建立者                             */
qdborig     varchar2(10)             /*资料建立部门                           */
);

alter table qdb_file add  constraint qdb_pk primary key  (qdb01,qdb011,qdb012,qdb013) enable validate;
grant select on qdb_file to tiptopgp;
grant update on qdb_file to tiptopgp;
grant delete on qdb_file to tiptopgp;
grant insert on qdb_file to tiptopgp;
grant index on qdb_file to public;
grant select on qdb_file to ods;
