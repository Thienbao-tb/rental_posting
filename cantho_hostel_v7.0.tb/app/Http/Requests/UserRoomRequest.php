<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UserRoomRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'qhuyen_id'     => 'required',
            'phuongxa_id' => 'required',
            'sophong'                    => 'required',
            'chitietdiachi'         => 'required',
            'gia'         => 'required|numeric|min:10000',
            'khuvuc'                 => 'required|numeric|min:5',
            'ten'        => 'required|min:15|max:150|regex:/^[^\s].*$/u',
            'mota' => 'required|min:50|regex:/^[^\s].*$/u',
        ];
    }

    public function messages()
    {
        return [
            'qhuyen_id.required'     => 'Quận huyện không được để trống',

            'phuongxa_id.required' => 'Phường xã không được để trống',

            'sophong.required'             => '*Số nhà không được bỏ trống',

            'chitietdiachi.required'  => '*Địa chỉ chính xác không được bỏ trống',

            'gia.required'       => '*Giá cho thuê không được bỏ trống',
            'gia.numeric'        => '*Giá cho thuê phải là số',
            'gia.min'            => '*Giá cho thuê phải ít nhất là 10,000 VNĐ',
            'khuvuc.required'          => '*Diện tích không được bỏ trống',
            'khuvuc.numeric'           => '*Diện tích phải là một số',
            'khuvuc.min'               => '*Diện tích phải ít nhất 5 m²',

            'ten.required'            => '*Tiêu đề không được bỏ trống',
            'ten.min'                 => '*Tiêu đề phải có ít nhất 15 ký tự',
            'ten.max'                 => '*Tiêu đề tối đa 150 kí tự',
            'ten.regex'               => '*Tiêu đề không được chứa khoảng trắng ở đầu',

            'mota.required'             => '*Mô tả không được bỏ trống',
            'mota.min'                  => '*Mô tả phải có ít nhất 50 ký tự',
            'mota.regex'                => '*Mô tả không được chứa khoảng trắng ở đầu'
        ];
    }
}