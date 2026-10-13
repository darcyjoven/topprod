/*
================================================================================
檔案代號:pmi_file
檔案名稱:核价单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pmi_file
(
pmi01       varchar2(20) NOT NULL,   /*核价单号                               */
                                     /*核價單號                               */
pmi02       date,                    /*核价日期                               */
                                     /*核價日期                               */
pmi03       varchar2(10),            /*厂商编号                               */
                                     /*廠商編號                               */
pmi04       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
pmi05       varchar2(1),             /*分量计价                               */
                                     /*分量計價Y/N #NO:7178                   */
pmi06       varchar2(1),             /*状况码                                 */
                                     /*狀況碼      #NO:6686                   */
                                     /*0: 開立(Open)                          */
                                     /*1: 已核准                              */
                                     /*S: 送簽                                */
                                     /*R: 送簽退回                            */
                                     /*W: 抽單                                */
pmi07       varchar2(1),             /*签核否                                 */
                                     /*簽核否      #NO:6686                   */
pmiconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N/X) X.作廢                   */
pmiacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
pmiuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
pmigrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
pmimodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
pmidate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
pmi08       varchar2(4),             /*税种                                   */
pmi081      number(9,4),             /*税率                                   */
pmi09       varchar2(10),            /*申请人                                 */
pmi10       varchar2(1),             /*价格类型                               */
                                     /*1.P/O  2. Subcontracting               */
pmiplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pmilegal    varchar2(10) NOT NULL,   /*所属法人                               */
pmioriu     varchar2(10),            /*资料建立者                             */
pmiorig     varchar2(10)             /*资料建立部门                           */
);

alter table pmi_file add  constraint pmi_pk primary key  (pmi01) enable validate;
grant select on pmi_file to tiptopgp;
grant update on pmi_file to tiptopgp;
grant delete on pmi_file to tiptopgp;
grant insert on pmi_file to tiptopgp;
grant index on pmi_file to public;
grant select on pmi_file to ods;
