/*
================================================================================
檔案代號:imr_file
檔案名稱:还料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table imr_file
(
imr00       varchar2(1),             /*偿还方式                               */
                                     /*償還方式(1/2)                          */
                                     /*1.原數償還  2.原價償還                 */
imr01       varchar2(20) NOT NULL,   /*还料单号                               */
                                     /*還料單號                               */
imr02       date,                    /*还料日期                               */
                                     /*還料日期                               */
imr03       varchar2(10),            /*还料人员                               */
                                     /*還料人員                               */
imr04       varchar2(10),            /*部门编号                               */
                                     /*部門編號                               */
imr05       varchar2(20),            /*借料单号                               */
                                     /*借料單號                               */
imr06       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
imr07       varchar2(1),             /*No Use                                 */
imr08       varchar2(1),             /*No Use                                 */
imr09       date,                    /*扣帐日期                               */
                                     /*扣帳日期                               */
imrpost     varchar2(1),             /*过帐码                                 */
                                     /*過帳碼(Y/N/X)                          */
imruser     varchar2(10),            /*资料所有者                             */
                                     /*Data Owener                            */
                                     /*System Maintain                        */
imrgrup     varchar2(10),            /*资料所有群                             */
                                     /*Data Group                             */
                                     /*System Maintain                        */
imrmodu     varchar2(10),            /*资料更改者                             */
                                     /*Data Modified By                       */
                                     /*System Maimtain                        */
imrdate     date,                    /*最近更改日                             */
                                     /*Latest Modified Date                   */
                                     /*System Maintain                        */
imrconf     varchar2(1),             /*审核码(Y/N/X)                          */
imrspc      varchar2(1),             /*SPC抛转码 0/1/2                        */
imrplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
imrlegal    varchar2(10) NOT NULL,   /*所属法人                               */
imroriu     varchar2(10),            /*资料建立者                             */
imrorig     varchar2(10)             /*资料建立部门                           */
);

alter table imr_file add  constraint imr_pk primary key  (imr01) enable validate;
grant select on imr_file to tiptopgp;
grant update on imr_file to tiptopgp;
grant delete on imr_file to tiptopgp;
grant insert on imr_file to tiptopgp;
grant index on imr_file to public;
grant select on imr_file to ods;
