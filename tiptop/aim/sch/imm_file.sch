/*
================================================================================
檔案代號:imm_file
檔案名稱:库存调拨单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table imm_file
(
imm01       varchar2(20) NOT NULL,   /*调拨单号                               */
                                     /*調撥單號                               */
imm02       date,                    /*调拨日期                               */
                                     /*調撥日期                               */
imm03       varchar2(1),             /*过帐否                                 */
                                     /*過帳否(Y/N) (撥入確認)                 */
imm04       varchar2(1),             /*拨出审核否                             */
                                     /*撥出確認否(Y/N/X)  X.撥出單作廢        */
immdays     number(5),               /*签核完成天数                           */
                                     /*簽核完成天數                           */
immprit     number(5),               /*签核优先等级                           */
                                     /*簽核優先等級                           */
imm05       number(5),               /*已签核顺序                             */
                                     /*已簽核順序                             */
imm06       number(5),               /*应签核顺序                             */
                                     /*應簽核順序                             */
imm07       number(5),               /*已打印次数                             */
                                     /*已列印次數                             */
imm08       varchar2(10),            /*在途仓                                 */
                                     /*在途倉                                 */
imm09       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
imm10       varchar2(1),             /*资料来源                               */
                                     /*資料來源                               */
                                     /*1.一階段倉庫調撥                       */
                                     /*2.二階段倉庫調撥                       */
                                     /*3.一階段工廠調撥                       */
                                     /*4.二階段工廠調撥                       */
                                     /*5.刻號/BIN調整(for ICD)                */
imm11       varchar2(20),            /*拨入单号                               */
                                     /*撥入單號                               */
                                     /*資料來源='3' 一階段工廠調撥,且參數設定撥*/
                                     /*             出單號與撥入單號相同,     */
                                     /*             imm11 default imm01       */
                                     /*資料來源='2' 二階段倉庫調撥,且參數設定撥*/
                                     /*             出單號與撥入單號相同,     */
                                     /*             imm11 default imm01       */
imm12       date,                    /*拨入日期                               */
                                     /*撥入日期                               */
imm13       varchar2(10),            /*拨入人员                               */
                                     /*撥入人員                               */
immacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
immuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
immgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
immmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
immdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
immconf     varchar2(1),             /*审核码(Y/N/X)                          */
imm14       varchar2(10),            /*部门                                   */
immspc      varchar2(1),             /*SPC抛转码 0/1/2                        */
immud01     varchar2(255),           /*自订字段-Textedit                      */
immud02     varchar2(40),            /*自订字段-文字                          */
immud03     varchar2(40),            /*自订字段-文字                          */
immud04     varchar2(40),            /*自订字段-文字                          */
immud05     varchar2(40),            /*自订字段-文字                          */
immud06     varchar2(40),            /*自订字段-文字                          */
immud07     number(15,3),            /*自订字段-数值                          */
immud08     number(15,3),            /*自订字段-数值                          */
immud09     number(15,3),            /*自订字段-数值                          */
immud10     number(10),              /*自订字段-整数                          */
immud11     number(10),              /*自订字段-整数                          */
immud12     number(10),              /*自订字段-整数                          */
immud13     date,                    /*自订字段-日期                          */
immud14     date,                    /*自订字段-日期                          */
immud15     date,                    /*自订字段-日期                          */
immplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
immlegal    varchar2(10) NOT NULL,   /*所属法人                               */
immoriu     varchar2(10),            /*资料建立者                             */
immorig     varchar2(10),            /*资料建立部门                           */
imm15       varchar2(1) DEFAULT '0' NOT NULL, /*签核状况*/
imm16       varchar2(10),            /*申请人                                 */
immmksg     varchar2(1) DEFAULT 'N' NOT NULL, /*是否签核*/
imm17       date
);

alter table imm_file add  constraint imm_pk primary key  (imm01) enable validate;
grant select on imm_file to tiptopgp;
grant update on imm_file to tiptopgp;
grant delete on imm_file to tiptopgp;
grant insert on imm_file to tiptopgp;
grant index on imm_file to public;
grant select on imm_file to ods;
