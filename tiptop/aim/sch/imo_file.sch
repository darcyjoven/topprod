/*
================================================================================
檔案代號:imo_file
檔案名稱:借料资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table imo_file
(
imo01       varchar2(20) NOT NULL,   /*借料单号                               */
                                     /*借料單號                               */
imo02       date,                    /*借料日期                               */
imo03       varchar2(10),            /*借料厂商编号                           */
                                     /*借料廠商編號                           */
imo04       varchar2(40),            /*借料厂商简称                           */
                                     /*借料廠商簡稱                           */
imo05       varchar2(24),            /*贷方科目                               */
                                     /*貸方科目                               */
imo06       varchar2(10),            /*借料人员                               */
                                     /*借料人員                               */
imo07       varchar2(1),             /*结案否                                 */
                                     /*結案否  #No:6817    add                */
imoconf     varchar2(1),             /*审核否                                 */
                                     /*確認否 (Y/N/X) #No:6817    add         */
imopost     varchar2(1),             /*过帐码                                 */
                                     /*過帳碼(Y/N)                            */
imouser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
imogrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
imomodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
imodate     date,                    /*最近更改日                             */
                                     /*System Maintain                        */
imo08       varchar2(10),            /*部门                                   */
imospc      varchar2(1),             /*SPC抛转码 0/1/2                        */
imoplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
imolegal    varchar2(10) NOT NULL,   /*所属法人                               */
imooriu     varchar2(10),            /*资料建立者                             */
imoorig     varchar2(10)             /*资料建立部门                           */
);

alter table imo_file add  constraint imo_pk primary key  (imo01) enable validate;
grant select on imo_file to tiptopgp;
grant update on imo_file to tiptopgp;
grant delete on imo_file to tiptopgp;
grant insert on imo_file to tiptopgp;
grant index on imo_file to public;
grant select on imo_file to ods;
