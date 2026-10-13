/*
================================================================================
檔案代號:lum_file
檔案名稱:待抵变更单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lum_file
(
lum01       varchar2(20) DEFAULT ' ' NOT NULL, /*待抵变更单号*/
lum02       varchar2(20),            /*待抵单号                               */
lum03       date,                    /*单据日期                               */
lum04       date,                    /*立帐日期                               */
lum05       varchar2(10),            /*商户编号                               */
lum051      varchar2(10),            /*新商户编号                             */
lum06       varchar2(20),            /*摊位编号                               */
lum061      varchar2(20),            /*新摊位编号                             */
lum07       varchar2(20),            /*合约编号                               */
lum071      varchar2(20),            /*新合同编号                             */
lum08       number(5),               /*合同版本号                             */
lum081      number(5),               /*新合同版本号                           */
lum09       varchar2(20),            /*新待抵单号                             */
lum10       number(20,6),            /*待抵金额                               */
lum11       number(20,6),            /*已冲金额                               */
lum12       number(20,6),            /*已退金额                               */
lum13       varchar2(10),            /*业务人员                               */
lum14       varchar2(10),            /*部门编号                               */
lum15       varchar2(255),           /*备注                                   */
lum16       varchar2(1) DEFAULT ' ' NOT NULL, /*状况码*/
lum17       varchar2(20),            /*财务单号                               */
lumacti     varchar2(1) NOT NULL,    /*资料有效码                             */
lumcond     date,                    /*审核日期                               */
lumconf     varchar2(1) NOT NULL,    /*确认码                                 */
lumcont     varchar2(8),             /*审核时间                               */
lumconu     varchar2(10),            /*审核人                                 */
lumcrat     date,                    /*资料创建日                             */
lumdate     date,                    /*最近更改日                             */
lumgrup     varchar2(10),            /*资料所有群                             */
lumlegal    varchar2(10) NOT NULL,   /*法人                                   */
lummodu     varchar2(10),            /*资料更改者                             */
lumorig     varchar2(10),            /*资料建立部门                           */
lumoriu     varchar2(10),            /*资料建立者                             */
lumplant    varchar2(10) NOT NULL,   /*门店编号                               */
lumuser     varchar2(10),            /*资料所有者                             */
lummksg     varchar2(1) DEFAULT ' ' NOT NULL /*是否签核*/
);

alter table lum_file add  constraint lum_pk primary key  (lum01) enable validate;
grant select on lum_file to tiptopgp;
grant update on lum_file to tiptopgp;
grant delete on lum_file to tiptopgp;
grant insert on lum_file to tiptopgp;
grant index on lum_file to public;
grant select on lum_file to ods;
