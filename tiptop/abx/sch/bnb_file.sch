/*
================================================================================
檔案代號:bnb_file
檔案名稱:放行单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bnb_file
(
bnb01       varchar2(20) NOT NULL,   /*放行单号                               */
bnb02       date,                    /*出区日期                               */
bnb03       varchar2(1),             /*资料来源                               */
                                     /*資料來源 1/2/3/4/5                     */
bnb04       varchar2(20),            /*原始单据号码                           */
bnb05       varchar2(10),            /*客户编号/厂商编号                      */
bnb06       varchar2(40),            /*简称                                   */
bnb07       varchar2(255),           /*送达地点                               */
bnb08       varchar2(10),            /*出区原因代码                           */
bnb09       varchar2(80),            /*出区原因                               */
bnb10       varchar2(14),            /*No Use                                 */
bnb11       date,                    /*出区期限                               */
bnb12       date,                    /*应返日期                               */
bnb13       date,                    /*销案日期                               */
bnb14       number(10),              /*件数                                   */
bnb15       varchar2(255),           /*备注                                   */
bnb16       varchar2(20),            /*工单号码                               */
bnb17       varchar2(20),            /*提货人                                 */
bnb18       varchar2(30),            /*运输工具号码                           */
bnb19       varchar2(1),             /*单身仅存保税品否                       */
bnb20       varchar2(1),             /*资料对象                               */
                                     /*       1.客戶 2.供應商 3.其它          */
                                     /*       4.雜項 5.其它    #FUN-6A0007    */
bnb21       varchar2(1),             /*NO USE                                 */
bnb22       varchar2(80),            /*出区其它原因说明                       */
bnb90       varchar2(30),            /*核准文号                               */
bnbud01     varchar2(255),           /*自订字段-Textedit                      */
bnbud02     varchar2(40),            /*自订字段-文字                          */
bnbud03     varchar2(40),            /*自订字段-文字                          */
bnbud04     varchar2(40),            /*自订字段-文字                          */
bnbud05     varchar2(40),            /*自订字段-文字                          */
bnbud06     varchar2(40),            /*自订字段-文字                          */
bnbud07     number(15,3),            /*自订字段-数值                          */
bnbud08     number(15,3),            /*自订字段-数值                          */
bnbud09     number(15,3),            /*自订字段-数值                          */
bnbud10     number(10),              /*自订字段-整数                          */
bnbud11     number(10),              /*自订字段-整数                          */
bnbud12     number(10),              /*自订字段-整数                          */
bnbud13     date,                    /*自订字段-日期                          */
bnbud14     date,                    /*自订字段-日期                          */
bnbud15     date,                    /*自订字段-日期                          */
bnbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bnblegal    varchar2(10) NOT NULL,   /*所属法人                               */
bnbdate     date,
bnbgrup     varchar2(10),
bnbmodu     varchar2(10),
bnbuser     varchar2(10)
);

create        index bnb_02 on bnb_file (bnb04);
alter table bnb_file add  constraint bnb_pk primary key  (bnb01) enable validate;
grant select on bnb_file to tiptopgp;
grant update on bnb_file to tiptopgp;
grant delete on bnb_file to tiptopgp;
grant insert on bnb_file to tiptopgp;
grant index on bnb_file to public;
grant select on bnb_file to ods;
