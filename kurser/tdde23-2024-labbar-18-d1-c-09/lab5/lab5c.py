from lab5b import *
def test_normal_pixel():
    '''Testar normalen så att den fungerar'''
    compare = pixel_constraint(100,150,100,150,100,150)
    resultat = compare((100,150,125))
    assert(resultat == 1)
def test_index_out_of_bound_pixel():
    '''Testar så om inputen är out of bound att det anteras'''
    compare = pixel_constraint(100,150,100,150,100,150)
    resultat = compare((100,150,175))
    assert(resultat == 0)
def test_not_integer_pixel():
    '''Testar så att rätt error raisas om fel input användes'''
    try:
        compare = pixel_constraint(100,150,100,150,100,150)
        resultat = compare("20")
        assert(False)
    except TypeError:
        pass
def test_tuple_lenght():
    '''Testar så att rätt error raisas om fel input användes'''
    try:
        compare = pixel_constraint(100,150,100,150,100,150)
        resultat = compare((100,150))
        assert(False)
    except TypeError:
        pass
def test_pixel_constraint():
    '''Kallar på alla andra functions och kollar så de passar'''
    test_normal_pixel()
    test_index_out_of_bound_pixel()
    test_not_integer_pixel()
    test_tuple_lenght()
    print("All tests passed")


def test_normal_gen():
    '''Testar normalen så att den fungerar'''
    generator = generator_from_image([12,3,5,15,86,5])
    resultat = generator(3)
    assert(resultat == 15)
def test_index_out_of_bound_gen():
    '''Testar så om inputen är out of bound att det anteras'''
    try:
        generator = generator_from_image([12,3,5,15,86,5])
        resultat = generator(9)
        assert(False)
    except IndexError:
        pass
def test_not_integer_gen():
    '''Testar så att rätt error raisas om fel input användes'''
    try:
        generator = generator_from_image([12,3,5,15,86,5])
        resultat = generator("4")
        assert(False)
    except TypeError:
        pass
def test_negative_num():
    '''Testar så att den kan hantera negativa nummer'''
    generator = generator_from_image([-25,17])
    resultat = generator(0)
    assert(resultat == -25)    
def test_generator_from_image():
    '''Kallar på alla andra functions och kollar så de passar'''
    test_normal_gen()
    test_index_out_of_bound_gen()
    test_not_integer_gen()
    test_negative_num()
    print("All tests passed")

def gradient_condition(rgb):
    '''returnar ett värde 0-1 beroende på pixeln som inputas'''
    return rgb[2]/255
def test_normal_img():
    '''Testar normalen så att den fungerar'''
    gen2 = generator_from_image([(10,10,10),(10,10,10),(10,10,10)]) 
    gen1 = generator_from_image([(50,50,50),(50,50,50),(50,50,50)]) 
    resultat = combine_images([(0,0,0),(127.5,127.5,127.5),(255,255,255)],gradient_condition,gen1,gen2)
    assert(resultat == [(10,10,10),(30,30,30),(50,50,50)])
def test_wrong_input():
    '''Testar så att rätt error raisas om fel input användes'''
    try:
        gen2 = generator_from_image([(-10,-10,-10),"(10,10,10)",()]) 
        gen1 = generator_from_image([(-10,-10,-10),"(10,10,10)",()]) 
        resultat = combine_images([(0,0,0),(127.5,127.5,127.5),(255,255,255)],gradient_condition,gen1,gen2)
        assert(False)
    except TypeError:
        pass
def test_combine_img():
    '''Kallar på alla andra functions och kollar så de passar'''
    img_list_test = [(50,50,50),(-10-10-10),(200,0,200)]
    test_normal_img()
    test_wrong_input()
    print("All tests passed")

test_pixel_constraint()
test_generator_from_image()
test_combine_img()